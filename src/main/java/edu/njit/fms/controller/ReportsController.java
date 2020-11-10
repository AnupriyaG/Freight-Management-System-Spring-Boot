package edu.njit.fms.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.ParserConfigurationException;

import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;
import com.google.common.collect.HashBasedTable;
import com.google.common.collect.Table;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.xml.sax.SAXException;

import edu.njit.fms.db.entity.DecisionVariableScoreRange;
import edu.njit.fms.db.entity.ScoreSystem;
import edu.njit.fms.db.repository.DecisionVariableScoreRangeRepository;
import edu.njit.fms.db.repository.FmsStipRepository;
import edu.njit.fms.db.repository.ScoreProjectRepository;
import edu.njit.fms.db.repository.ScoreSystemRepository;
import edu.njit.fms.reports.Reports;
import edu.njit.fms.utils.CrystalReportUtils;

@Controller
public class ReportsController {
	private ArrayList<Reports> ReportList;
	static Table<String, String, Double> scrRangeHashTable;
	private final static Logger logger = Logger.getLogger(ReportsController.class);

	@Autowired
	FmsStipRepository fmsStipRepository;

	@Autowired
	ScoreProjectRepository scoreProjectRepository;

	@Autowired
	ScoreSystemRepository scoreSystemRepository;

	@Autowired
	DecisionVariableScoreRangeRepository decisionVariableScoreRangeRepository;

	@Autowired
    ResourceLoader resourceLoader;

	@Autowired
	Environment env;

	@RequestMapping(value = "/reporttest")
	@ResponseBody
	public void getTestReport(HttpServletRequest request, HttpServletResponse response)
			throws ReportSDKExceptionBase, IOException {
		/* File file = new ClassPathResource("reports/Web_Telus_ScoringReport_chartsonly_FMS.rpt").getFile();
		CrystalReportUtils cru = new CrystalReportUtils();
		cru.generateCrystalReport(file.getAbsolutePath(), "DBNUM = '00312' and SystemID = 9", "crtest.pdf", request,
				response); */
	}

	@RequestMapping(value = "/scoringSystems")
	@ResponseBody
	public List<ScoreSystem> listScoringSystems() {
		return scoreSystemRepository.listAllbySystemID();
	}

	@RequestMapping(value = "/DisplaySearchResultsPage", method = RequestMethod.GET)
	public String displayPage(Model model) {
		return "reports";
	}

	@RequestMapping(value = "/getCustomRoutes", method = RequestMethod.GET)
	@ResponseBody
	public List<Object> getCustomRouteList() {
		return fmsStipRepository.getCustomRoutes();
	}

	@RequestMapping(value = "/generateGISImage")
	@ResponseBody
	public String generateStipReportGISImage(@RequestParam("dbnum") String dbnum)
			throws ClientProtocolException, IOException, JSONException {
		List<Object[]> bbdata = fmsStipRepository.getSTIPBoundingBox(dbnum); //get milepost co-ordinates
		double finalMinX = -300, finalMinY = -300, finalMaxX = 300, finalMaxY = 300; //initialize with out of range max, min values
		for (Object[] bb : bbdata) {
			String BLAT = (String) bb[0];
			String BLONG = (String) bb[1];
			double X, Y;
			Logger.getLogger("ReportImage").info(BLAT + " , " + BLONG);
			if (BLAT == null || BLONG == null) {
				Logger.getLogger("ReportImage").info("No Data found");
				X = 0;
				Y = 0;
				/* bb[0] = (Object) (-74.741807 + "");
				bb[1] = (Object) (40.179194 + ""); */
			} else {
				Logger.getLogger("ReportImage").info("DBNUM found");
				X = Double.parseDouble(BLONG);
				Y = Double.parseDouble(BLAT);
			}

			if (X > finalMinX)
				finalMinX = X;
			if (Y > finalMinY)
				finalMinY = Y;
			if (X < finalMaxX)
				finalMaxX = X;
			if (Y < finalMaxY)
				finalMaxY = Y;
		}
		if (bbdata.size() > 1) {
			finalMinX += 0.01;
			finalMaxX -= 0.01;
			finalMinY += 0.01;
			finalMaxY -= 0.01;
		} else {
			if (bbdata.size() > 0) {
				finalMinX = Double.parseDouble((String) bbdata.get(0)[1]);
				finalMaxX = Double.parseDouble((String) bbdata.get(0)[1]);
				finalMinY = Double.parseDouble((String) bbdata.get(0)[0]);
				finalMaxY = Double.parseDouble((String) bbdata.get(0)[0]);
			}
			finalMinX += 0.01;
			finalMaxX -= 0.01;
			finalMinY += 0.01;
			finalMaxY -= 0.01;
		}

		String serviceData = generateSTIPReportArcGISImageData(dbnum, finalMaxX, finalMaxY, finalMinX, finalMinY);

		String url = "http://transprod05.njit.edu:6080/arcgis/rest/services/Utilities/PrintingTools/GPServer/Export%20Web%20Map%20Task/execute";

		HttpClient client = new DefaultHttpClient();
		HttpPost post = new HttpPost(url);

		// add header
		String USER_AGENT = "Mozilla/5.0";
		post.setHeader("User-Agent", USER_AGENT);

		List<NameValuePair> urlParameters = new ArrayList<NameValuePair>();
		urlParameters.add(new BasicNameValuePair("Format", "PNG32"));
		urlParameters.add(new BasicNameValuePair("returnZ", "false"));
		urlParameters.add(new BasicNameValuePair("returnM", "false"));
		urlParameters.add(new BasicNameValuePair("f", "JSON"));
		urlParameters.add(new BasicNameValuePair("Web_Map_as_JSON", serviceData));

		post.setEntity(new UrlEncodedFormEntity(urlParameters));

		HttpResponse response = client.execute(post);
		System.out.println("\nSending 'POST' request to URL : " + url);
		System.out.println("Post parameters : " + post.getEntity());
		System.out.println("Response Code : " + response.getStatusLine().getStatusCode());

		BufferedReader rd = new BufferedReader(new InputStreamReader(response.getEntity().getContent()));

		StringBuffer result = new StringBuffer();
		String line = "";
		while ((line = rd.readLine()) != null) {
			result.append(line);
		}

		System.out.println(result.toString());
		JSONObject resultData = new JSONObject(result.toString());
		if (resultData.has("results")) {
			JSONObject resultsObj = resultData.getJSONArray("results").getJSONObject(0);
			String imgURL = resultsObj.getJSONObject("value").getString("url");
			return imgURL;
		} else return "";

	}

	private String generateSTIPReportArcGISImageData(String dbnum, double maxX, double maxY, double minX, double minY) {
		return "{" 
				+ "\"mapOptions\":{" + 
				"\"extent\":{" + 
				"\"xmin\":" + maxX + "," + 
				"\"ymin\":" + maxY + "," + 
				"\"xmax\":" + minX + "," + 
				"\"ymax\":" + minY + "," + 
				"\"spatialReference\":{" + 
				"\"wkid\":4326" + 
				"}" + 
				"}" + 
				"}," + 
				"\"operationalLayers\":[" + 
				"{" + 
				"\"url\":\"http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/STIP_FMS/MapServer/0\"," + 
				"\"layerDefinition\":{" + 
				"\"definitionExpression\":\"DBNUM='" + dbnum + "'\"," + 
				"\"drawingInfo\":{\"renderer\":{\"type\":\"simple\",\"symbol\":{\"type\":\"esriSLS\",\"color\":[230, 0, 0, 255],\"width\":5,\"style\":\"esriSLSSolid\"}}}" + 
				"}" + 
				"}" + 
				"]," + 
				"\"baseMap\":{" + 
				"\"title\":\"Topographic Basemap\"," + 
				"\"baseMapLayers\":[" + 
				"{" + 
				"\"url\":\"https://services.arcgisonline.com/arcgis/rest/services/World_Street_Map/MapServer\"" + 
				"}" + 
				"]" + 
				"}," + 
				"\"exportOptions\":{" + 
				"\"outputSize\":[" + 
				"800," + 
				"800" + 
				"]" + 
				"}" + 
				"}";
	}

	@RequestMapping(value = "/generateScores", method = RequestMethod.GET)
	@ResponseBody
	public ArrayList<Reports> generateScores(@RequestParam("searchField") String searchField,
			@RequestParam("searchValue") String searchValue, @RequestParam("cascadeValue") String cascadeValue,
			@RequestParam("scoreSystem") int scoringSystem) {
		List<String> dbnumForScoring = new ArrayList<>();
		switch (searchField) {
		case "All":
			dbnumForScoring = fmsStipRepository.getAllDBNUMForScoring();
			break;
		case "DBNUM":
			dbnumForScoring.add(searchValue);
			break;
		case "PROJECT_NAME":
			dbnumForScoring = fmsStipRepository.getDBNUMForScoringByProjectName(searchValue);
			break;
		case "ROUTE":
			dbnumForScoring = fmsStipRepository.getDBNUMForScoringByRoute(searchValue);
			break;
		case "COUNTY":
			dbnumForScoring = fmsStipRepository.getDBNUMForScoringByCounty(searchValue);
			break;
		case "MUNC1":
			dbnumForScoring = fmsStipRepository.getDBNUMForScoringByMunicipality(searchValue);
			break;
		case "MPO":
			dbnumForScoring = fmsStipRepository.getDBNUMForScoringByMPO(searchValue);
			break;
		case "CIS_PROGRAM_CATEGORY":
			if (cascadeValue == null)
				dbnumForScoring = fmsStipRepository.getDBNUMForScoringByCISCategory(searchValue);
			else
				dbnumForScoring = fmsStipRepository.getDBNUMForScoringByCISCategoryAndCISBubcategory(searchValue,
						cascadeValue);
			break;

		}

		double score_dbnums[] = new double[dbnumForScoring.size()];

		// Rounding values, taking same query used in STIP report to display the Max
		// Score column in the table analysis
		String sys_name = fmsStipRepository.getSystemNameFromID(scoringSystem + "");
		String System_Name = scoreSystemRepository.getSystemNameFromID(scoringSystem + "");
		Object[] stipReportData = fmsStipRepository.getStipScoringSystemReportData(scoringSystem + "").get(0);
		logger.info(sys_name);

		HashMap<String, Double> score_contribution_per_criteria = new HashMap<String, Double>();
		score_contribution_per_criteria.put("Large Truck Crash Rate", ((BigDecimal) stipReportData[1]).doubleValue());
		score_contribution_per_criteria.put("Large Truck Severity Rate",
				((BigDecimal) stipReportData[2]).doubleValue());
		score_contribution_per_criteria.put("National Highway Network", ((BigDecimal) stipReportData[3]).doubleValue());
		score_contribution_per_criteria.put("New Jersey Access Network",
				((BigDecimal) stipReportData[4]).doubleValue());
		score_contribution_per_criteria.put("Intermodal Connector", ((BigDecimal) stipReportData[5]).doubleValue());
		score_contribution_per_criteria.put("National Highway Freight Network",
				((BigDecimal) stipReportData[6]).doubleValue());
		score_contribution_per_criteria.put("Percentage of Large Truck Volume",
				((BigDecimal) stipReportData[7]).doubleValue());
		score_contribution_per_criteria.put("Truck Travel Time Reliability Index",
				((BigDecimal) stipReportData[8]).doubleValue());
		score_contribution_per_criteria.put("Overweight Truck Permits", ((BigDecimal) stipReportData[9]).doubleValue());

		evaluateScore(score_dbnums, score_contribution_per_criteria, dbnumForScoring, scoringSystem + "", System_Name,
				false);

		return this.ReportList;
	}

	void evaluateScore(double dbnums_score[], HashMap<String, Double> percvalues, List<String> dbnumForScoring,
			String SystemID, String SystemName, Boolean isCustomProjectReq) {
		// check if the passed DBNUMS already exist in scrproject table

		this.ReportList = new ArrayList<Reports>();

	

		for (int i = 0; i < dbnumForScoring.size(); i++) {
			Reports temp_obj = new Reports();
			temp_obj.setSystem_Name(SystemName);
			temp_obj.setDBNUM(dbnumForScoring.get(i));

			//Getting the sum of scores for particular DBNUM and Sytsem Id
			Double SumOfScore = scoreProjectRepository.evalCheckDBNUM(dbnumForScoring.get(i), SystemID);

			boolean dbnum_exists = false;
			if(null == SumOfScore){
				dbnum_exists = false;
			}else {
				dbnum_exists = true;
			}
				// Getting start_range,end_range and weight_perscentage for every mode from decision_variable_score_range
		Table<String, Long, DecisionVariableScoreRange> scrRangeHashTable = HashBasedTable.create();
		
			Iterable<DecisionVariableScoreRange> scrRangeList = decisionVariableScoreRangeRepository.findAll();
		

			List<String> year_of_project = fmsStipRepository.getYear(dbnumForScoring.get(i));
			boolean year_exists = true;
			for (String year : year_of_project) {
				int exist_value = scoreProjectRepository.rowExists(year, dbnumForScoring.get(i));
				// Checks if there exists any row in table for particular DBNUM and Year
				if (exist_value == 0) {
					year_exists = false;
				}
			}
			if ((dbnum_exists == false && year_exists == false) || (dbnum_exists == true && year_exists == false))// Here is where the project is scored!!
			{
				logger.info("###############This is a new project record entry################");
				// Delete the DBNUM if it already exists
				String Year = "";
				double OverWeight = 0;
				double Large_truck_Volume = 0;
				double Severity = 0;
				double NHFN = 0;
				double Intermodal = 0;
				double NJ_Access = 0;
				double NHS = 0;
				double TTTRI = 0;
				double Large_Truck_Crash_Rate = 0;
				/*
				 * String delete_dbnum =
				 * "delete from scrproject where DBNUM = '"+dbnums.get(i)+"' and SystemID = '"
				 * +SystemID+"'"; stmt = con.createStatement();
				 * logger.info("Delete DBNUM Query: "+delete_dbnum);
				 * stmt.executeUpdate(delete_dbnum);
				 */

				for (DecisionVariableScoreRange decision_score_range : scrRangeList) {
					scrRangeHashTable.put(decision_score_range.getCategory_name(),decision_score_range.getId() ,decision_score_range);
				}
				Map<Long, DecisionVariableScoreRange> eceMap = scrRangeHashTable.row("Large Truck Crash Rate");
				for (Map.Entry<Long, DecisionVariableScoreRange> rowKey : eceMap.entrySet()) {
					System.out.println("Id:"+rowKey.getKey()+" start_range :"+rowKey.getValue().getStart_range()+ " End range:"+rowKey.getValue().getEnd_range());
				}
				// String query_detail = "select
				// OVERWEIGHT,LARGE_TRUCK_VOLUME,SEVERITY,BLUE_ROUTE,INTERMODAL,NJ_ACCESS,NHS,BTI,LARGE_TRUCK_CRASH_RATE,LEFT(Year,4)as
				// Year,Project_Name from fms_stip where DBNUM = '"+dbnums.get(i)+"'";
				List<Object[]> queryDetailResult = fmsStipRepository.evalQueryDetails(dbnumForScoring.get(i));
				for (Object[] row : queryDetailResult) {
					if (row[0]!=null) OverWeight = (Double) row[0];
					Large_truck_Volume = (Double) row[1];
					String severity_str = (Double) row[2] + "";
					if (severity_str == null)
						Severity = 0;
					else
						Severity = Double.parseDouble(severity_str);
					NHFN = (Double) row[3];
					Intermodal = (Double) row[4];
					NJ_Access = (Double) row[5];
					NHS = (Double) row[6];
					if (row[7] != null)
						TTTRI = (Double) row[7];
					String ltcr_str = (Double) row[8] + "";
					if (ltcr_str == null)
						Large_Truck_Crash_Rate = 0;
					else
						Large_Truck_Crash_Rate = Double.parseDouble(ltcr_str);
					Year = (String) row[9];
					temp_obj.setProject_Name((String) row[10]);
					temp_obj.setProject_Type((String) row[11]);

				}

				temp_obj.setYear(Year);

				System.out.println("OverWeight = " + OverWeight);
				System.out.println("Large_truck_Volume = " + Large_truck_Volume);
				System.out.println("Severity = " + Severity);
				System.out.println("NHFN = " + NHFN);
				System.out.println("Intermodal = " + Intermodal);
				System.out.println("NJ_Access = " + NJ_Access);
				System.out.println("NHS = " + NHS);
				System.out.println("TTTRI = " + TTTRI);
				System.out.println("Large_Truck_Crash_Rate = " + Large_Truck_Crash_Rate);
				/* if (NHS > 1)
					NHS = 0;
				if (NJ_Access > 1)
					NJ_Access = 0;
				if (Intermodal > 1)
					Intermodal = 0;
				if (NHFN > 1)
					NHFN = 0; */
				// Now since we have the values, we have to query from tip_category table to get
				// the default percentage of the range it belongs to
				Map<Long, DecisionVariableScoreRange> myrange;
				myrange =scrRangeHashTable.row("Overweight Truck Permits");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((OverWeight > (double) row.getValue().getStart_range()) && (OverWeight <= row.getValue().getEnd_range())) {
						OverWeight = (percvalues.get("Overweight Truck Permits") *  (row.getValue().getScore())) / 100;
						System.out.println("OverWeight 1 :"+OverWeight);
						break;
					}
				}

				myrange =scrRangeHashTable.row("Percentage of Large Truck Volume");
				
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((Large_truck_Volume > (double) row.getValue().getStart_range()) && (Large_truck_Volume <= row.getValue().getEnd_range())) {
						Large_truck_Volume = (percvalues.get("Percentage of Large Truck Volume") *  (row.getValue().getScore())) / 100;
						System.out.println("Large_truck_Volume 1 :"+Large_truck_Volume);
						break;
					}
				}

				myrange = scrRangeHashTable.row("Large Truck Severity Rate");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((Severity > (double) row.getValue().getStart_range()) && (Severity <= row.getValue().getEnd_range())) {
						Severity = (percvalues.get("Large Truck Severity Rate") *  (row.getValue().getScore())) / 100;
						System.out.println("Severity 1 :"+Severity);
						break;
					}
				}

				myrange = scrRangeHashTable.row("National Highway Freight Network");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((NHFN >= (double) row.getValue().getStart_range()) && (NHFN <= row.getValue().getEnd_range())) {
						NHFN = (percvalues.get("National Highway Freight Network") *  (row.getValue().getScore())) / 100;
						System.out.println("NHFN 1 :"+NHFN);
						break;
					}
				}

				myrange = scrRangeHashTable.row("Intermodal Connector");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((Intermodal >= (double) row.getValue().getStart_range()) && (Intermodal <= row.getValue().getEnd_range())) {
						Intermodal = (percvalues.get("Intermodal Connector") *  (row.getValue().getScore())) / 100;
						System.out.println("Intermodal 1 :"+Intermodal);
						break;
					}
				}

				myrange = scrRangeHashTable.row("New Jersey Access Network");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((NJ_Access >= (double) row.getValue().getStart_range()) && (NJ_Access <= row.getValue().getEnd_range())) {
						NJ_Access = (percvalues.get("New Jersey Access Network") *  (row.getValue().getScore())) / 100;
						System.out.println("NJ_Access 1 :"+NJ_Access);
						break;
					}
				}

				myrange = scrRangeHashTable.row("National Highway Network");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((NHS >= (double) row.getValue().getStart_range()) && (NHS <= row.getValue().getEnd_range())) {
						NHS = (percvalues.get("National Highway Network") *  (row.getValue().getScore())) / 100;
						System.out.println("NHS 1 :"+NHS);
						break;
					}
				}

				myrange = scrRangeHashTable.row("Truck Travel Time Reliability Index");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((TTTRI > (double) row.getValue().getStart_range()) && (TTTRI <= row.getValue().getEnd_range())) {
						TTTRI = (percvalues.get("Truck Travel Time Reliability Index") *  (row.getValue().getScore())) / 100;
						System.out.println("TTTRI :"+TTTRI);
						break;
					}
				}

				myrange = scrRangeHashTable.row("Large Truck Crash Rate");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((Large_Truck_Crash_Rate > (double) row.getValue().getStart_range()) && (Large_Truck_Crash_Rate <= row.getValue().getEnd_range())) {
						Large_Truck_Crash_Rate = (percvalues.get("Large Truck Crash Rate") *  (row.getValue().getScore())) / 100;
						System.out.println("Large_Truck_Crash_Rate 1 :"+Large_Truck_Crash_Rate);
						break;
					}
				}

				System.out.println("-------------------------------------");
				double newOverWeight = Math.round(OverWeight * 100.0) / 100.0;
				double newLarge_truck_Volume = Math.round(Large_truck_Volume * 100.0) / 100.0;
				double newSeverity = Math.round(Severity * 100.0) / 100.0;
				double newNHFN = Math.round(NHFN * 100.0) / 100.0;
				double newIntermodal = Math.round(Intermodal * 100.0) / 100.0;
				double newNJ_Access = Math.round(NJ_Access * 100.0) / 100.0;
				double newNHS = Math.round(NHS * 100.0) / 100.0;
				double newTTTRI = Math.round(TTTRI * 100.0) / 100.0;
				double newLarge_Truck_Crash_Rate = Math.round(Large_Truck_Crash_Rate * 100.0) / 100.0;

				// Now that the we have scored each criteria based on the scoring system, we
				// need to insert it in scrproject table
				if ((Year == null) || (Year == "")) {
					Year = "2014";// Hardcoding the value of year, since we know that it is a Custom Project(i.e
									// Project type = SEGMENT)
				}
				List<Object[]> scoreFactorResult;

				scoreFactorResult = fmsStipRepository.getScoreFactor("Large Truck Crash Rate", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID,
							(Integer) row[0] + "", (Integer) row[1] + "", newLarge_Truck_Crash_Rate);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Large Truck Severity Rate", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID,
							(Integer) row[0] + "", (Integer) row[1] + "", newSeverity);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("National Highway Network", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID,
							(Integer) row[0] + "", (Integer) row[1] + "", newNHS);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("New Jersey Access Network", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID,
							(Integer) row[0] + "", (Integer) row[1] + "", newNJ_Access);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Intermodal Connector", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID,
							(Integer) row[0] + "", (Integer) row[1] + "", newIntermodal);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("National Highway Freight Network", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID,
							(Integer) row[0] + "", (Integer) row[1] + "", newNHFN);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Percentage of Large Truck Volume", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID,
							(Integer) row[0] + "", (Integer) row[1] + "", newLarge_truck_Volume);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Truck Travel Time Reliability Index", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID,
							(Integer) row[0] + "", (Integer) row[1] + "", newTTTRI);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Overweight Truck Permits", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID,
							(Integer) row[0] + "", (Integer) row[1] + "", newOverWeight);
				}

				/*
				 * fmsStipRepository.getAllDBNUMForScoring() // now that the data is inserted
				 * into the db, we query from the very first query
				 * System.out.println(check_dbnum_query); // check_dbnum_query = "Select
				 * sum(Score) from scrproject where DBNUM = // '"+dbnums.get(i)+"'"; pstmt =
				 * con.prepareStatement(check_dbnum_query); rs = pstmt.executeQuery(); while
				 * (rs.next()) { dbnums_score[i] = rs.getDouble(1); dbnums_score[i] =
				 * Math.round(dbnums_score[i] * 100.0) / 100.0;
				 * temp_obj.setScore(String.valueOf(dbnums_score[i])); }
				 */

			} else {
				logger.info("###############This is a old project record update################");
				// Delete the DBNUM if it already exists
				String Year = "";
				double OverWeight = 0;
				double Large_truck_Volume = 0;
				double Severity = 0;
				double NHFN = 0;
				double Intermodal = 0;
				double NJ_Access = 0;
				double NHS = 0;
				double TTTRI = 0;
				double Large_Truck_Crash_Rate = 0;

				

				for (DecisionVariableScoreRange decision_score_range : scrRangeList) {
					scrRangeHashTable.put(decision_score_range.getCategory_name(),decision_score_range.getId() ,decision_score_range);
				}
				Map<Long, DecisionVariableScoreRange> eceMap = scrRangeHashTable.row("Large Truck Crash Rate");
				for (Map.Entry<Long, DecisionVariableScoreRange> rowKey : eceMap.entrySet()) {
					System.out.println("Id:"+rowKey.getKey()+" start_range :"+rowKey.getValue().getStart_range()+ " End range:"+rowKey.getValue().getEnd_range());
				}

				List<Object[]> queryDetailResult = fmsStipRepository.evalQueryDetails(dbnumForScoring.get(i));
				for (Object[] row : queryDetailResult) {
					if (row[0] != null)	OverWeight = (double) row[0];
					if (row[1] != null)	Large_truck_Volume = (double) row[1];
					if (row[2] != null)	Severity = (double) row[2];
					
					/* String severity_str = (double) row[2] + "";
					if (severity_str == null)
						Severity = 0;
					else
						Severity = Double.parseDouble(severity_str); */
					NHFN = (double) row[3];
					Intermodal = (double) row[4];
					NJ_Access = (double) row[5];
					NHS = (double) row[6];
					if (row[7] != null)
						TTTRI = (double) row[7];
					if (row[8] != null)	Large_Truck_Crash_Rate = (double) row[8];
					
					/* String ltcr_str = row[8] + "";
					if (ltcr_str == null)
						Large_Truck_Crash_Rate = 0;
					else
						Large_Truck_Crash_Rate = Double.parseDouble(ltcr_str); */
					Year = (String) row[9];
					temp_obj.setProject_Name((String) row[10]);
					temp_obj.setProject_Type((String) row[11]);
				}

				temp_obj.setYear(Year);

				System.out.println("OverWeight = " + OverWeight);
				System.out.println("Large_truck_Volume = " + Large_truck_Volume);
				System.out.println("Severity = " + Severity);
				System.out.println("NHFN = " + NHFN);
				System.out.println("Intermodal = " + Intermodal);
				System.out.println("NJ_Access = " + NJ_Access);
				System.out.println("NHS = " + NHS);
				System.out.println("TTTRI = " + TTTRI);
				System.out.println("Large_Truck_Crash_Rate = " + Large_Truck_Crash_Rate);
				/* if (NHS > 1)
					NHS = 0;
				if (NJ_Access > 1)
					NJ_Access = 0;
				if (Intermodal > 1)
					Intermodal = 0;
				if (NHFN > 1)
					NHFN = 0; */
				// Now since we have the values, we have to query from tip_category table to get
				// the default percentage of the range it belongs to

				Map<Long, DecisionVariableScoreRange> myrange;
				myrange =scrRangeHashTable.row("Overweight Truck Permits");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((OverWeight > (double) row.getValue().getStart_range()) && (OverWeight <= row.getValue().getEnd_range())) {
						OverWeight = (percvalues.get("Overweight Truck Permits") *  (row.getValue().getScore())) / 100;
						System.out.println("OverWeight 1 :"+OverWeight);
						break;
					}
				}

				myrange =scrRangeHashTable.row("Percentage of Large Truck Volume");
				
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((Large_truck_Volume > (double) row.getValue().getStart_range()) && (Large_truck_Volume <= row.getValue().getEnd_range())) {
						Large_truck_Volume = (percvalues.get("Percentage of Large Truck Volume") *  (row.getValue().getScore())) / 100;
						System.out.println("Large_truck_Volume 1 :"+Large_truck_Volume);
						break;
					}
				}

				myrange = scrRangeHashTable.row("Large Truck Severity Rate");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((Severity > (double) row.getValue().getStart_range()) && (Severity <= row.getValue().getEnd_range())) {
						Severity = (percvalues.get("Large Truck Severity Rate") *  (row.getValue().getScore())) / 100;
						System.out.println("Severity 1 :"+Severity);
						break;
					}
				}
//NHFN
				myrange = scrRangeHashTable.row("National Highway Freight Network");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((NHFN >= (double) row.getValue().getStart_range()) && (NHFN <= row.getValue().getEnd_range())) {
						NHFN = (percvalues.get("National Highway Freight Network") *  (row.getValue().getScore())) / 100;
						System.out.println("NHFN 1 :"+NHFN);
						break;
					}
				}

				myrange = scrRangeHashTable.row("Intermodal Connector");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((Intermodal >= (double) row.getValue().getStart_range()) && (Intermodal <= row.getValue().getEnd_range())) {
						Intermodal = (percvalues.get("Intermodal Connector") *  (row.getValue().getScore())) / 100;
						System.out.println("Intermodal 1 :"+Intermodal);
						break;
					}
				}

				myrange = scrRangeHashTable.row("New Jersey Access Network");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((NJ_Access >= (double) row.getValue().getStart_range()) && (NJ_Access <= row.getValue().getEnd_range())) {
						NJ_Access = (percvalues.get("New Jersey Access Network") *  (row.getValue().getScore())) / 100;
						System.out.println("NJ_Access 1 :"+Intermodal);
						break;
					}
				}

				myrange = scrRangeHashTable.row("National Highway Network");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((NHS >= (double) row.getValue().getStart_range()) && (NHS <= row.getValue().getEnd_range())) {
						NHS = (percvalues.get("National Highway Network") *  (row.getValue().getScore())) / 100;
						System.out.println("NHS 1 :"+Intermodal);
						break;
					}
				}

				myrange = scrRangeHashTable.row("Truck Travel Time Reliability Index");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((TTTRI > (double) row.getValue().getStart_range()) && (TTTRI <= row.getValue().getEnd_range())) {
						TTTRI = (percvalues.get("Truck Travel Time Reliability Index") *  (row.getValue().getScore())) / 100;
						System.out.println("TTTRI :"+TTTRI);
						break;
					}
				}

				myrange = scrRangeHashTable.row("Large Truck Crash Rate");
				for(Map.Entry<Long, DecisionVariableScoreRange> row : myrange.entrySet()){
					if ((Large_Truck_Crash_Rate > (double) row.getValue().getStart_range()) && (Large_Truck_Crash_Rate <= row.getValue().getEnd_range())) {
						Large_Truck_Crash_Rate = (percvalues.get("Large Truck Crash Rate") *  (row.getValue().getScore())) / 100;
						System.out.println("Large_Truck_Crash_Rate 1 :"+Large_Truck_Crash_Rate);
						break;
					}
				}

				System.out.println("-------------------------------------");
				double newOverWeight = Math.round(OverWeight * 100.0) / 100.0;
				double newLarge_truck_Volume = Math.round(Large_truck_Volume * 100.0) / 100.0;
				double newSeverity = Math.round(Severity * 100.0) / 100.0;
				double newNHFN = Math.round(NHFN * 100.0) / 100.0;
				double newIntermodal = Math.round(Intermodal * 100.0) / 100.0;
				double newNJ_Access = Math.round(NJ_Access * 100.0) / 100.0;
				double newNHS = Math.round(NHS * 100.0) / 100.0;
				double newTTTRI = Math.round(TTTRI * 100.0) / 100.0;
				double newLarge_Truck_Crash_Rate = Math.round(Large_Truck_Crash_Rate * 100.0) / 100.0;

				// Now that the we have scored each criteria based on the scoring system, we
				// need to update it in scrproject table
				if ((Year == null) || (Year == "")) {
					Year = "2014";// Hardcoding the value of year, since we know that it is a Custom Project(i.e
									// Project type = SEGMENT)
				}

				List<Object[]> scoreFactorResult;

				scoreFactorResult = fmsStipRepository.getScoreFactor("Large Truck Crash Rate", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.updateScoreProject(newLarge_Truck_Crash_Rate, Year, dbnumForScoring.get(i),
							SystemID, (int) row[0], (int) row[1]);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Large Truck Severity Rate", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.updateScoreProject(newSeverity, Year, dbnumForScoring.get(i), SystemID,
							(int) row[0], (int) row[1]);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("National Highway Network", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.updateScoreProject(newNHS, Year, dbnumForScoring.get(i), SystemID,
							(int) row[0], (int) row[1]);

				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("New Jersey Access Network", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.updateScoreProject(newNJ_Access, Year, dbnumForScoring.get(i), SystemID,
							(int) row[0], (int) row[1]);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Intermodal Connector", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.updateScoreProject(newIntermodal, Year, dbnumForScoring.get(i), SystemID,
							(int) row[0], (int) row[1]);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("National Highway Freight Network", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.updateScoreProject(newNHFN, Year, dbnumForScoring.get(i), SystemID,
							(int) row[0], (int) row[1]);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Percentage of Large Truck Volume", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.updateScoreProject(newLarge_truck_Volume, Year, dbnumForScoring.get(i),
							SystemID, (int) row[0], (int) row[1]);

				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Truck Travel Time Reliability Index", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.updateScoreProject(newTTTRI, Year, dbnumForScoring.get(i), SystemID,
							(int) row[0], (int) row[1]);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Overweight Truck Permits", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.updateScoreProject(newOverWeight, Year, dbnumForScoring.get(i), SystemID,
							(int) row[0], (int) row[1]);
				}

				/*
				 * // now that the data is inserted into the db, we query from the very first
				 * query System.out.println(check_dbnum_query); // check_dbnum_query = "Select
				 * sum(Score) from scrproject where DBNUM = // '"+dbnums.get(i)+"'"; pstmt =
				 * con.prepareStatement(check_dbnum_query); rs = pstmt.executeQuery(); while
				 * (rs.next()) { dbnums_score[i] = rs.getDouble(1); dbnums_score[i] =
				 * Math.round(dbnums_score[i] * 100.0) / 100.0;
				 * temp_obj.setScore(String.valueOf(dbnums_score[i])); }
				 */

				/*
				 * String query_detail =
				 * "Select LEFT(YEAR,4)as YEAR,PROJECT_NAME,CIS_PROGRAM_CATEGORY FROM fms_stip where DBNUM = '"
				 * +dbnums.get(i)+"'"; PreparedStatement preparedstmt = null; ResultSet
				 * resultset = null; preparedstmt = con.prepareStatement(query_detail);
				 * resultset = preparedstmt.executeQuery(); while(resultset.next()) {
				 * temp_obj.setDBNUM(dbnums.get(i)); temp_obj.setYear(resultset.getString(1));
				 * temp_obj.setProject_Name(resultset.getString(2));
				 * temp_obj.setProject_Type(resultset.getString(3)); }
				 */
			}
			//Getting the sum of scores for particular DBNUM and Sytsem Id
			Double totalScore = scoreProjectRepository.evalCheckDBNUM(dbnumForScoring.get(i), SystemID);
			dbnums_score[i] = totalScore;
			dbnums_score[i] = Math.round(dbnums_score[i] * 100.0) / 100.0;
			logger.info("Coming from scrproject table directly - " + dbnums_score[i] + "for DBNUM = "+ dbnumForScoring.get(i));
			temp_obj.setScore(String.valueOf(dbnums_score[i]));

			this.ReportList.add(temp_obj);
			// check_dbnum_query = "Select sum(Score) from scrproject where DBNUM = '";
		}
		// return dbnums_score;
		System.out.println("Evaluation is done! the data is inserted into scrproject table!");
	}

	@RequestMapping(value = "/LoadProjectReport", method = RequestMethod.GET)
	public void downloadindividual(
		@RequestParam("DBNUM") String DBNUM,
		@RequestParam("systemID") String systemID, 
		HttpServletRequest request, 
		HttpServletResponse response
	) throws ClassNotFoundException, SQLException, ParserConfigurationException, SAXException, IOException, JSONException, ReportSDKExceptionBase {
		System.out.println(DBNUM);
		System.out.println(systemID);
		String dbnum = DBNUM.replace("'", ""); 
		fmsStipRepository.updateGISURL(generateStipReportGISImage(dbnum), dbnum);

		Resource resource = resourceLoader.getResource("classpath:reports/STIPReport.rpt");

		Fields reportFields = new Fields();
        reportFields.add(CrystalReportUtils.createCrystalReportParameterField("", "customsql", "DBNUM = " + DBNUM + " and SystemID = " + systemID));
        CrystalReportUtils.generateCrystalReportPDF(resource.getURI().getRawPath(), reportFields, request, response, env);
	}

	@Autowired
	private EntityManager entityManager;

	@RequestMapping(value = "/LoadProjectReportMultiple", method = RequestMethod.GET)
	public void downloadmultiple(
		@RequestParam("customsql") String customsql,
		HttpServletRequest request,
		HttpServletResponse response
	) throws ClientProtocolException, IOException, JSONException, ReportSDKExceptionBase {
		System.out.println(customsql);
		// generate gis image
		if (customsql.contains("DBNUM")) { // its a list of DBNUMs
			String[] dbnums = customsql.split("\\('")[1].split("'','1'")[0].split("','");
			// customsql.split("OR");
			for (int i = 0; i < dbnums.length; i++) {
				fmsStipRepository.updateGISURL(generateStipReportGISImage(dbnums[i]), dbnums[i]);
			}

		} else { // its a custom filter
			String sql = "SELECT DBNUM FROM FMS_STIP WHERE " + customsql.split(" and ")[0].replace("&", "\\&");
			List dbnumData = entityManager.createNativeQuery(sql).getResultList();
			for (Object row : dbnumData) {
				String dbnum = (String) row;
				fmsStipRepository.updateGISURL(generateStipReportGISImage(dbnum), dbnum);
			}
		}
		Resource resource = resourceLoader.getResource("classpath:reports/STIPReport_Multiple.rpt");

		Fields reportFields = new Fields();
        reportFields.add(CrystalReportUtils.createCrystalReportParameterField("", "customsql", customsql));
        CrystalReportUtils.generateCrystalReportPDF(resource.getURI().getRawPath(), reportFields, request, response, env);

	}
	
}
