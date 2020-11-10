package edu.njit.fms.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.Transactional;

import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;

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
import org.springframework.context.ApplicationContext;
import org.springframework.core.env.Environment;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import edu.njit.fms.db.entity.ScoreSystem;
import edu.njit.fms.db.repository.FmsStipRepository;
import edu.njit.fms.db.repository.ScoreProjectRepository;
import edu.njit.fms.db.repository.ScoreSystemRepository;
import edu.njit.fms.reports.Reports;
import edu.njit.fms.utils.CrystalReportUtils;

@Controller
public class CustomReportsController {
	private final static Logger logger = Logger.getLogger(CustomReportsController.class);

	@Autowired
	FmsStipRepository fmsStipRepository;

	@Autowired
	ScoreProjectRepository scoreProjectRepository;

	@Autowired
	ScoreSystemRepository ScoreSystemRepository;

	@Autowired
	EntityManager entityManager;

	@Autowired
	EntityManagerFactory entityManagerFactory;

	@Autowired
	private ApplicationContext applicationContext;

	@Autowired
	ResourceLoader resourceLoader;

	@Autowired
	Environment env;

	@RequestMapping(value = "/DisplayCustomReports", method = RequestMethod.GET)
	public ModelAndView display_custom_reports_page(HttpServletRequest request) {
		ModelAndView model = new ModelAndView("customreports");
		List<String> Routes = fmsStipRepository.getDistinctRoutesWithNulls();
		List<ScoreSystem> ScoreSystems = ScoreSystemRepository.listAllbySystemID();
		model.addObject("ScoreSystems", ScoreSystems);
		model.addObject("Routes", Routes);

		return model;
	}

	@RequestMapping(value = "/DownloadCustomReport", method = RequestMethod.GET)
	@Transactional
	public ModelAndView download_custom_reports_page(@RequestParam("route") String route,
			@RequestParam("from") double start,
			@RequestParam("to") double end, @RequestParam("scoresystem") String ScoreSystem,
			@RequestParam("projdesc") String ProjDesc, HttpServletRequest request, HttpServletResponse response)
			throws ClientProtocolException, IOException, JSONException, ReportSDKExceptionBase {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String currentPrincipalName = authentication.getName();
		String uname = currentPrincipalName;
		String customDBNUM = route + "_" + start + "_" + end + "_" + ScoreSystem + "_" + uname;

		ModelAndView model = new ModelAndView("DisplayCustomProjectReport");

		String route_name = fmsStipRepository.getRoute(route);

		// Delete DBNUM start
		scoreProjectRepository.emptyScoreProjectSegments();

		List<String> dbnum = new ArrayList<String>();
		dbnum.add("Segment_" + start + "_" + end);

		// Rounding values, taking same query used in STIP report to display the Max
		// Score column in the table analysis
		String System_Name = ScoreSystemRepository.getSystemNameFromID(ScoreSystem);
		List<Object[]> stipReportData = fmsStipRepository.getStipReportData(ScoreSystem);
		HashMap<String, Double> score_contribution_per_criteria = new HashMap<String, Double>();
		for (Object[] row : stipReportData) {
			score_contribution_per_criteria.put("Large Truck Crash Rate", ((BigDecimal) row[1]).doubleValue());
			score_contribution_per_criteria.put("Large Truck Severity Rate", ((BigDecimal) row[2]).doubleValue());
			score_contribution_per_criteria.put("National Highway Network", ((BigDecimal) row[3]).doubleValue());
			score_contribution_per_criteria.put("New Jersey Access Network", ((BigDecimal) row[4]).doubleValue());
			score_contribution_per_criteria.put("Intermodal Connector", ((BigDecimal) row[5]).doubleValue());
			score_contribution_per_criteria.put("National Highway Freight Network",
					((BigDecimal) row[6]).doubleValue());
			score_contribution_per_criteria.put("Percentage of Large Truck Volume",
					((BigDecimal) row[7]).doubleValue());
			score_contribution_per_criteria.put("Truck Travel Time Reliability Index",
					((BigDecimal) row[8]).doubleValue());
			score_contribution_per_criteria.put("Overweight Truck Permits", ((BigDecimal) row[9]).doubleValue());
		}

		// Load Score System End

		// Now that the Score System is loaded and the dbnums HashMap is filled, we need
		// to calculate the Total score each criteria contributes

		double dbnums_score[] = new double[dbnum.size()];
		evaluateScore(dbnums_score, score_contribution_per_criteria, dbnum, ScoreSystem, System_Name, true);

		for (int i = 0; i < dbnum.size(); i++) {
			System.out.println("Checking the scores for individual query in custom reports -" + dbnums_score[i]);
		}

		// Now delete the entries in scrsegment table
		ScoreSystemRepository.emptyScoreSegmentTable();

		// URL for stip project generation - start
		String url = request.getRequestURI().split("/DownloadCustom")[0];
		String url_stip = "";
		
			url_stip = url + "/DownloadStipProjectReportDetails?DBNUM=";
		System.out.println("URLSTIP: " + url_stip);
		// URL for stip project generation - start

		
		// Now insert records in scrsegment table

		int primary_cnt = 1;
		List<Object[]> mainSegmentData = ScoreSystemRepository.getMainSegmentData(dbnum.get(0), route, start, end);
		String image_url = generateCustomReportGISImage(route, start + "", end + "", fmsStipRepository);
		logger.info("Image:" + image_url);
		for (Object[] row : mainSegmentData) {
			String Insert_ScrSegment_Query = "Insert into scrsegment(DBNUM,MP_START_SEG,MP_END_SEG,TOTAL_COUNT_LT,CR_LT,SEVERITY,NATIONAL_HIGHWAY_FREIGHT_NETWORK,INTERMODAL,NJ_ACCESS,NHS,MEAN_TT,TT95,TTTR,OVERWEIGHT,LT_PERC_STIP,TOTAL_SCORE,SCR_SYSTEM_ID,ROUTE,Project_Info_User,Image_Path,URL,SRI) values ("
					+ "'Segment_" + start + "_" + end + "',";
			for (int i = 1; i <= 15; i++) {
				if (row[i - 1] instanceof String) {
					Insert_ScrSegment_Query += ((String) row[i - 1]) + ",";
				} else if (row[i - 1] instanceof Integer) {
					Insert_ScrSegment_Query += ((Integer) row[i - 1]) + ",";
				} else {
					Insert_ScrSegment_Query += ((Double) row[i - 1]) + ",";
				}
			}
			Insert_ScrSegment_Query += "'" + ScoreSystem + "','" + route_name + "','" + ProjDesc
					+ "','"+image_url+"' ,'" + url_stip + "', '" + (String) row[15] + "')";
			logger.info(Insert_ScrSegment_Query);

			// session.connection().createStatement().execute("SET IDENTITY_INSERT [dbo]." +
			// tableName + " OFF");
			// entityManager.createQuery("SET IDENTITY_INSERT scrsegment
			// ON").executeUpdate();
			// EntityTransaction tx = entityManager.getTransaction(); EntityManager em =
			// entityManagerFactory.createEntityManager(); // table
			// Session session = (Session) em.getDelegate();
			//// tx.begin();
			// session.doWork(new Work(){
			//
			// @Override
			// @Transactional
			// public void execute(java.sql.Connection connection) throws SQLException {
			// connection.createStatement().execute("SET IDENTITY_INSERT scrsegment ON");
			// }
			// });

			// has identity_insert set as "YES"
			logger.info("CUSTOM_INSERT_QUERY: " + Insert_ScrSegment_Query);
			// entityManager.createNativeQuery("SET IDENTITY_INSERT scrsegment
			// ON").executeUpdate();
			entityManager.createNativeQuery(Insert_ScrSegment_Query).executeUpdate();
			// tx.commit();
			primary_cnt++;
		}
		// Insert the appropriate value into the scrproject table i.e. the maximum
		// values start
		score_custom_project(request, score_contribution_per_criteria);
		// Insert the appropriate value into the scrproject table i.e. the maximum
		// values end

		// Now we need to download image - start
		// download_image_from_url(request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+GISUtils.generateReportImageURL(route,
		// start, end),
		// SessionManager.getInstance().getSessionfromMap(request.getSession().getId()).getServletContext().getRealPath("WEB-INF")+"/crystalreportimages/temp_img.jpg");
		// Now we need to download image - end

		// insert record into customreport table

		
		String check_sql = "SELECT COUNT(*) FROM CustomProjects WHERE DBNUM = '" + customDBNUM + "'";
		double count = fmsStipRepository.getCustomProjectCount(customDBNUM);

		if (count > 0) {

		} else {
			String sql = "INSERT INTO [dbo].[CustomProjects]([DBNUM],[ROUTE],[SRI],[MP_START],[MP_END],[SCR_SYSTEM_ID],[Username]) VALUES('"
					+ customDBNUM + "', '" + route_name + "', '" + route + "', '" + start + "','" + end + "', '"
					+ ScoreSystem + "','" + uname + "')";
			entityManager.createNativeQuery(sql).executeUpdate();

			
			// String geom_sql = "UPDATE [dbo].[CustomProjects] SET [GEO]= ( "
			// + "SELECT geometry::STGeomFromText('LINESTRING('+ LONLATSTR+')',2260) FROM "
			// + "( SELECT DISTINCT A.DBNUM, " + "STUFF ( ( SELECT ',' + long + ' ' + lat "
			// + "FROM ( SELECT DISTINCT SRI, MP, long, lat FROM njdot_mpdata) C "
			// + "WHERE c.SRI = A.SRI AND ROUND(A.MP_START, 1) <= C.MP AND ROUND(A.MP_END,1)
			// >= C.MP+0.1 "
			// + "ORDER BY C.MP, ',' + long + ' ' + lat FOR XML PATH('') ), 1, 1, '' ) AS
			// LONLATSTR "
			// + "FROM CustomProjects AS A " + "JOIN njdot_mpdata AS B ON
			// ROUND(A.MP_START,1) <= B.MP "
			// + "AND ROUND(A.MP_END,1) >= B.MP+0.1 AND b.SRI = a.SRI " + "AND A.DBNUM = '"
			// + customDBNUM
			// + "' WHERE A.SRI IS NOT NULL OR A.SRI !='null' " + ") AS D "
			// + "WHERE LONLATSTR IS NOT NULL ) WHERE DBNUM = '" + customDBNUM + "'";
			// logger.info("GEOMSQL: " + geom_sql);
			// entityManager.createNativeQuery(geom_sql).executeUpdate();
		}

		String rptfile = "ScoringReport_chartsonly_FMSCustomReport";
		// need to give the custom sql value and the rpt file
		model.addObject("customsql", "DBNUM Like 'Segment%'");
		model.addObject("rptfile", rptfile);
		return model;

		/* Resource resource = resourceLoader.getResource("classpath:reports/CustomReport.rpt");

        Fields reportFields = new Fields();
        reportFields.add(CrystalReportUtils.createCrystalReportParameterField("", "customsql", "DBNUM Like 'Segment%'"));
        CrystalReportUtils.generateCrystalReportPDF(resource.getURI().getRawPath(), reportFields, request, response, env);
		 */
	}

	

	void score_custom_project(HttpServletRequest request, HashMap<String, Double> percvalues) {

		double OverWeight = 0;
		double Large_truck_Volume = 0;
		double Severity = 0;
		double NHFN = 0;
		double Intermodal = 0;
		double NJ_Access = 0;
		double NHS = 0;
		double TTTRI = 0;
		double Large_Truck_Crash_Rate = 0;

		// Executing score_custom_project start
		Object[] maxCriteria = (Object[]) ScoreSystemRepository.getMaximumCriteria()[0];
		if (maxCriteria[0] != null ) OverWeight = (double) maxCriteria[0];
		if (maxCriteria[1] != null ) Large_truck_Volume = (double) maxCriteria[1];
		if (maxCriteria[2] != null ) Severity = (double) maxCriteria[2];
		if (maxCriteria[3] != null ) NHFN = (double) maxCriteria[3];
		if (maxCriteria[4] != null ) Intermodal = (double) maxCriteria[4];
		if (maxCriteria[5] != null ) NJ_Access = (double) maxCriteria[5];
		if (maxCriteria[6] != null ) NHS = (double) maxCriteria[6];
		if (maxCriteria[7] != null ) TTTRI = (double) maxCriteria[7];
		if (maxCriteria[8] != null ) Large_Truck_Crash_Rate = (double) maxCriteria[8];

		System.out.println("OverWeight = " + OverWeight);
		System.out.println("Large_truck_Volume = " + Large_truck_Volume);
		System.out.println("Severity = " + Severity);
		System.out.println("NHFN = " + NHFN);
		System.out.println("Intermodal = " + Intermodal);
		System.out.println("NJ_Access = " + NJ_Access);
		System.out.println("NHS = " + NHS);
		System.out.println("TTTRI = " + TTTRI);
		System.out.println("Large_Truck_Crash_Rate = " + Large_Truck_Crash_Rate);
		if (NHS > 1)
			NHS = 0;
		if (NJ_Access > 1)
			NJ_Access = 0;
		if (Intermodal > 1)
			Intermodal = 0;
		if (NHFN > 1)
			NHFN = 0;
		// Now since we have the values, we have to query from tip_category table to get
		// the default percentage of the range it belongs to
		List<Object[]> rangeResults;

		rangeResults = fmsStipRepository.getWeight("OverWeight Truck Permits");
		for (Object[] row : rangeResults) {
			if ((OverWeight > (double) row[0]) && (OverWeight <= (double) row[1])) {
				OverWeight = (percvalues.get("Overweight Truck Permits") * (double) row[2]) / 100;
				break;
			}
		}

		rangeResults = fmsStipRepository.getWeight("Percentage of Large Truck Volume");
		for (Object[] row : rangeResults) {
			if ((Large_truck_Volume > (double) row[0]) && (Large_truck_Volume <= (double) row[1])) {
				Large_truck_Volume = (percvalues.get("Percentage of Large Truck Volume") * (double) row[2]) / 100;
				break;
			}
		}

		rangeResults = fmsStipRepository.getWeight("Large Truck Severity Rate");
		for (Object[] row : rangeResults) {
			if ((Severity > (double) row[0]) && (Severity <= (double) row[1])) {
				Severity = (percvalues.get("Large Truck Severity Rate") * (double) row[2]) / 100;
				break;
			}
		}

		rangeResults = fmsStipRepository.getWeight("National Highway Freight Network");
		for (Object[] row : rangeResults) {
			if ((NHFN >= (double) row[0]) && (NHFN <= (double) row[1])) {
				NHFN = (percvalues.get("National Highway Freight Network") * (double) row[2]) / 100;
				break;
			}
		}

		rangeResults = fmsStipRepository.getWeight("Intermodal Connector");
		for (Object[] row : rangeResults) {
			if ((Intermodal >= (double) row[0]) && (Intermodal <= (double) row[1])) {
				Intermodal = (percvalues.get("Intermodal Connector") * (double) row[2]) / 100;
				break;
			}
		}

		rangeResults = fmsStipRepository.getWeight("New Jersey Access Network");
		for (Object[] row : rangeResults) {
			if ((NJ_Access >= (double) row[0]) && (NJ_Access <= (double) row[1])) {
				NJ_Access = (percvalues.get("New Jersey Access Network") * (double) row[2]) / 100;
				break;
			}
		}

		rangeResults = fmsStipRepository.getWeight("National Highway Network");
		for (Object[] row : rangeResults) {
			if ((NHS >= (double) row[0]) && (NHS <= (double) row[1])) {
				NHS = (percvalues.get("National Highway Network") * (double) row[2]) / 100;
				System.out.println(NHS);
				break;
			}
		}

		rangeResults = fmsStipRepository.getWeight("Truck Travel Time Reliability Index");
		for (Object[] row : rangeResults) {
			if ((TTTRI > (double) row[0]) && (TTTRI <= (double) row[1])) {
				TTTRI = (percvalues.get("Truck Travel Time Reliability Index") * (double) row[2]) / 100;
				break;
			}
		}

		rangeResults = fmsStipRepository.getWeight("Large Truck Crash Rate");
		for (Object[] row : rangeResults) {
			if ((Large_Truck_Crash_Rate > (double) row[0]) && (Large_Truck_Crash_Rate <= (double) row[1])) {
				Large_Truck_Crash_Rate = (percvalues.get("Large Truck Crash Rate") * (double) row[2]) / 100;
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

		System.out.println("=================================================================");
		System.out.println("newOverWeight = " + newOverWeight);
		System.out.println("newLarge_truck_Volume = " + newLarge_truck_Volume);
		System.out.println("newSeverity = " + newSeverity);
		System.out.println("newNHFN = " + newNHFN);
		System.out.println("newIntermodal = " + newIntermodal);
		System.out.println("newNJ_Access = " + newNJ_Access);
		System.out.println("newNHS = " + newNHS);
		System.out.println("newTTTRI = " + newTTTRI);
		System.out.println("newLarge_Truck_Crash_Rate = " + newLarge_Truck_Crash_Rate);
		// Now that the we have scored each criteria based on the scoring system, we
		// need to insert it in scrproject table

		String update_scrproject_query = "update scrproject set score = " + newLarge_Truck_Crash_Rate
				+ " where Cat_ID = 1 and Factor_ID = 1 and DBNUM like 'Segment%'";
		entityManager.createNativeQuery(update_scrproject_query).executeUpdate();

		update_scrproject_query = "update scrproject set score = " + newSeverity
				+ " where Cat_ID = 1 and Factor_ID = 2 and DBNUM like 'Segment%'";
		entityManager.createNativeQuery(update_scrproject_query).executeUpdate();

		update_scrproject_query = "update scrproject set score = " + newNHS
				+ "where Cat_ID = 2 and Factor_ID = 1 and DBNUM like 'Segment%'";
		entityManager.createNativeQuery(update_scrproject_query).executeUpdate();

		update_scrproject_query = "update scrproject set score = " + newNJ_Access
				+ " where Cat_ID = 2 and Factor_ID = 2 and DBNUM like 'Segment%'";
		entityManager.createNativeQuery(update_scrproject_query).executeUpdate();

		update_scrproject_query = "update scrproject set score = " + newIntermodal
				+ " where Cat_ID = 2 and Factor_ID = 3 and DBNUM like 'Segment%'";
		entityManager.createNativeQuery(update_scrproject_query).executeUpdate();

		update_scrproject_query = "update scrproject set score = " + newNHFN
				+ "where Cat_ID = 2 and Factor_ID = 4 and DBNUM like 'Segment%'";
		entityManager.createNativeQuery(update_scrproject_query).executeUpdate();

		update_scrproject_query = "update scrproject set score = " + newLarge_truck_Volume
				+ " where Cat_ID = 3 and Factor_ID = 1 and DBNUM like 'Segment%'";
		entityManager.createNativeQuery(update_scrproject_query).executeUpdate();

		update_scrproject_query = "update scrproject set score = " + newTTTRI
				+ " where Cat_ID = 3 and Factor_ID = 2 and DBNUM like 'Segment%'";
		entityManager.createNativeQuery(update_scrproject_query).executeUpdate();

		update_scrproject_query = "update scrproject set score = " + newOverWeight
				+ " where Cat_ID = 3 and Factor_ID = 3 and DBNUM like 'Segment%'";
		entityManager.createNativeQuery(update_scrproject_query).executeUpdate();

	}

	@RequestMapping(value = "/DownloadStipProjectReportDetails", method = RequestMethod.GET)
	public ModelAndView download_stip_reports_page(@RequestParam("DBNUM") String dbnum, HttpServletRequest request) {
		ModelAndView model = new ModelAndView("test");
		System.out.println(dbnum);
		String rptfile = "STIPReport_ESTIP_new_NJIT-DB";
		model.addObject("customsql", "S2.DBNUM_STIP = '" + dbnum + "'");
		model.addObject("rptfile", rptfile);
		System.out.println("inside the stip page controller!");
		return model;
	}

	@RequestMapping(value = "/fromMPList", method = RequestMethod.GET)
	@ResponseBody
	public ArrayList<String> selectStartMP(@RequestParam("route") String route) {

		ArrayList<String> M_POSTS_FROM = new ArrayList<String>();
		Object[] mixmaxVals = fmsStipRepository.getMinMaxMileposts(route).get(0);
		double min = (double) mixmaxVals[0];
		double max = (double) mixmaxVals[1];
		// Exectuing range_query query start

		double end = max;
		double temp = min;
		while (temp <= end) {
			double temp2 = temp;
			M_POSTS_FROM.add(String.valueOf((Math.round(temp2 * 100.0) / 100.0)));
			temp += 0.1;
		}

		return M_POSTS_FROM;
	}

	@RequestMapping(value = "/toMPList", method = RequestMethod.GET)
	@ResponseBody
	public ArrayList<String> selectEndMP(@RequestParam("from") String from, @RequestParam("route") String route) {

		ArrayList<String> M_POSTS_TO = new ArrayList<String>();
		double temp = Double.parseDouble(from);
		double end = fmsStipRepository.fromSelect(route);

		while (temp <= end) {

			double temp2 = temp += 0.1;
			M_POSTS_TO.add(String.valueOf((Math.round(temp2 * 100.0) / 100.0)));
			temp = (Math.round(temp * 100.0) / 100.0);
		}

		return M_POSTS_TO;
	}

	@RequestMapping(value = "/SegmentDetails", method = RequestMethod.POST)
	@ResponseBody
	public ModelAndView segmentDetails(@RequestParam("ROUTE") String route, @RequestParam("FROM") double start,
			@RequestParam("TO") double end, @RequestParam("ScoreSystem") String ScoreSystem,
			HttpServletRequest request) {
		ModelAndView model = new ModelAndView("segment_details");

		ArrayList<Reports> STIP_Projects = new ArrayList<Reports>();
		List<Object[]> stipProjectData = fmsStipRepository.getStipProjectData(route, start, end);
		for (Object[] row : stipProjectData) {
			Reports temp = new Reports();
			temp.setYear((String) row[0]);
			temp.setDBNUM((String) row[1]);
			temp.setProject_Name((String) row[2]);
			STIP_Projects.add(temp);
		}
		model.addObject("STIP_Projects", STIP_Projects);
		System.out.println(STIP_Projects.size());

		return model;
	}

	void evaluateScore(double dbnums_score[], HashMap<String, Double> percvalues, List<String> dbnumForScoring,
			String SystemID, String SystemName, Boolean isCustomProjectReq) {
		// check if the passed DBNUMS already exist in scrproject table

		ArrayList<Reports> ReportList = new ArrayList<Reports>();

		for (int i = 0; i < dbnumForScoring.size(); i++) {
			Reports temp_obj = new Reports();
			temp_obj.setSystem_Name(SystemName);
			temp_obj.setDBNUM(dbnumForScoring.get(i));
			List<Double> checkDBNUMResults = new ArrayList<>();
			checkDBNUMResults.add(scoreProjectRepository.evalCheckDBNUM(dbnumForScoring.get(i), SystemID));

			boolean dbnum_exists = false;
			for (Double d : checkDBNUMResults) {
				if (d == null) {
					dbnum_exists = false;
				} else {
					dbnum_exists = true;
					dbnums_score[i] = d;
					dbnums_score[i] = Math.round(dbnums_score[i] * 100.0) / 100.0;
					logger.info("Coming from scrproject table directly - " + dbnums_score[i] + "for DBNUM = "
							+ dbnumForScoring.get(i));
					temp_obj.setScore(String.valueOf(dbnums_score[i]));
				}
			}

			if (dbnum_exists == false)// Here is where the project is scored!!
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

				// String query_detail = "select
				// OVERWEIGHT,LARGE_TRUCK_VOLUME,SEVERITY,BLUE_ROUTE,INTERMODAL,NJ_ACCESS,NHS,BTI,LARGE_TRUCK_CRASH_RATE,LEFT(Year,4)as
				// Year,Project_Name from fms_stip where DBNUM = '"+dbnums.get(i)+"'";
				List<Object[]> queryDetailResult = fmsStipRepository.evalQueryDetails(dbnumForScoring.get(i));
				for (Object[] row : queryDetailResult) {
					OverWeight = ((BigDecimal) row[0]).doubleValue();
					Large_truck_Volume = ((BigDecimal) row[1]).doubleValue();
					String severity_str = (String) row[2];
					if (severity_str == null)
						Severity = 0;
					else
						Severity = Double.parseDouble(severity_str);
					NHFN = ((BigDecimal) row[3]).doubleValue();
					Intermodal = ((BigDecimal) row[4]).doubleValue();
					NJ_Access = ((BigDecimal) row[5]).doubleValue();
					NHS = ((BigDecimal) row[6]).doubleValue();
					TTTRI = ((BigDecimal) row[7]).doubleValue();
					String ltcr_str = (String) row[8];
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
				if (NHS > 1)
					NHS = 0;
				if (NJ_Access > 1)
					NJ_Access = 0;
				if (Intermodal > 1)
					Intermodal = 0;
				if (NHFN > 1)
					NHFN = 0;
				// Now since we have the values, we have to query from tip_category table to get
				// the default percentage of the range it belongs to
				List<Object[]> rangeResults;

				rangeResults = fmsStipRepository.getWeight("OverWeight Truck Permits");
				for (Object[] row : rangeResults) {
					if ((OverWeight > (double) row[0]) && (OverWeight <= (double) row[1])) {
						OverWeight = (percvalues.get("Overweight Truck Permits") * (double) row[2]) / 100;
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("Percentage of Large Truck Volume");
				for (Object[] row : rangeResults) {
					if ((Large_truck_Volume > (double) row[0]) && (Large_truck_Volume <= (double) row[1])) {
						Large_truck_Volume = (percvalues.get("Percentage of Large Truck Volume") * (double) row[2])
								/ 100;
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("Large Truck Severity Rate");
				for (Object[] row : rangeResults) {
					if ((Severity > (double) row[0]) && (Severity <= (double) row[1])) {
						Severity = (percvalues.get("Large Truck Severity Rate") * (double) row[2]) / 100;
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("National Highway Freight Network");
				for (Object[] row : rangeResults) {
					if ((NHFN >= (double) row[0]) && (NHFN <= (double) row[1])) {
						NHFN = (percvalues.get("National Highway Freight Network") * (double) row[2]) / 100;
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("Intermodal Connector");
				for (Object[] row : rangeResults) {
					if ((Intermodal >= (double) row[0]) && (Intermodal <= (double) row[1])) {
						Intermodal = (percvalues.get("Intermodal Connector") * (double) row[2]) / 100;
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("New Jersey Access Network");
				for (Object[] row : rangeResults) {
					if ((NJ_Access >= (double) row[0]) && (NJ_Access <= (double) row[1])) {
						NJ_Access = (percvalues.get("New Jersey Access Network") * (double) row[2]) / 100;
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("National Highway Network");
				for (Object[] row : rangeResults) {
					if ((NHS >= (double) row[0]) && (NHS <= (double) row[1])) {
						NHS = (percvalues.get("National Highway Network") * (double) row[2]) / 100;
						System.out.println(NHS);
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("Truck Travel Time Reliability Index");
				for (Object[] row : rangeResults) {
					if ((TTTRI > (double) row[0]) && (TTTRI <= (double) row[1])) {
						TTTRI = (percvalues.get("Truck Travel Time Reliability Index") * (double) row[2]) / 100;
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("Large Truck Crash Rate");
				for (Object[] row : rangeResults) {
					if ((Large_Truck_Crash_Rate > (double) row[0]) && (Large_Truck_Crash_Rate <= (double) row[1])) {
						Large_Truck_Crash_Rate = (percvalues.get("Large Truck Crash Rate") * (double) row[2]) / 100;
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
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID, (int) row[0] + "",
							(int) row[1] + "", newLarge_Truck_Crash_Rate);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Large Truck Severity Rate", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID, (int) row[0] + "",
							(int) row[1] + "", newSeverity);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("National Highway Network", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID, (int) row[0] + "",
							(int) row[1] + "", newNHS);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("New Jersey Access Network", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID, (int) row[0] + "",
							(int) row[1] + "", newNJ_Access);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Intermodal Connector", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID, (int) row[0] + "",
							(int) row[1] + "", newIntermodal);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("National Highway Freight Network", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID, (int) row[0] + "",
							(int) row[1] + "", newNHFN);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Percentage of Large Truck Volume", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID, (int) row[0] + "",
							(int) row[1] + "", newLarge_truck_Volume);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Truck Travel Time Reliability Index", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID, (int) row[0] + "",
							(int) row[1] + "", newTTTRI);
				}

				scoreFactorResult = fmsStipRepository.getScoreFactor("Overweight Truck Permits", SystemID);
				for (Object[] row : scoreFactorResult) {
					scoreProjectRepository.setScoreProject(Year, dbnumForScoring.get(i), SystemID, (int) row[0] + "",
							(int) row[1] + "", newOverWeight);
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

				List<Object[]> queryDetailResult = fmsStipRepository.evalQueryDetails(dbnumForScoring.get(i));
				for (Object[] row : queryDetailResult) {
					OverWeight = (double) row[0];
					Large_truck_Volume = (double) row[1];
					String severity_str = (double) row[2] + "";
					if (severity_str == null)
						Severity = 0;
					else
						Severity = Double.parseDouble(severity_str);
					NHFN = (double) row[3];
					Intermodal = (double) row[4];
					NJ_Access = (double) row[5];
					NHS = (double) row[6];
					TTTRI = (double) row[7];
					String ltcr_str = row[8] + "";
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
				if (NHS > 1)
					NHS = 0;
				if (NJ_Access > 1)
					NJ_Access = 0;
				if (Intermodal > 1)
					Intermodal = 0;
				if (NHFN > 1)
					NHFN = 0;
				// Now since we have the values, we have to query from tip_category table to get
				// the default percentage of the range it belongs to

				List<Object[]> rangeResults;

				rangeResults = fmsStipRepository.getWeight("OverWeight Truck Permits");
				for (Object[] row : rangeResults) {
					if ((OverWeight > (double) row[0]) && (OverWeight <= (double) row[1])) {
						OverWeight = (percvalues.get("Overweight Truck Permits") * (double) row[2]) / 100;
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("Percentage of Large Truck Volume");
				for (Object[] row : rangeResults) {
					if ((Large_truck_Volume > (double) row[0]) && (Large_truck_Volume <= (double) row[1])) {
						Large_truck_Volume = (percvalues.get("Percentage of Large Truck Volume") * (double) row[2])
								/ 100;
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("Large Truck Severity Rate");
				for (Object[] row : rangeResults) {
					if ((Severity > (double) row[0]) && (Severity <= (double) row[1])) {
						Severity = (percvalues.get("Large Truck Severity Rate") * (double) row[2]) / 100;
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("National Highway Freight Network");
				for (Object[] row : rangeResults) {
					if ((NHFN >= (double) row[0]) && (NHFN <= (double) row[1])) {
						NHFN = (percvalues.get("National Highway Freight Network") * (double) row[2]) / 100;
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("Intermodal Connector");
				for (Object[] row : rangeResults) {
					if ((Intermodal >= (double) row[0]) && (Intermodal <= (double) row[1])) {
						Intermodal = (percvalues.get("Intermodal Connector") * (double) row[2]) / 100;
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("New Jersey Access Network");
				for (Object[] row : rangeResults) {
					if ((NJ_Access >= (double) row[0]) && (NJ_Access <= (double) row[1])) {
						NJ_Access = (percvalues.get("New Jersey Access Network") * (double) row[2]) / 100;
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("National Highway Network");
				for (Object[] row : rangeResults) {
					if ((NHS >= (double) row[0]) && (NHS <= (double) row[1])) {
						NHS = (percvalues.get("National Highway Network") * (double) row[2]) / 100;
						System.out.println(NHS);
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("Truck Travel Time Reliability Index");
				for (Object[] row : rangeResults) {
					if ((TTTRI > (double) row[0]) && (TTTRI <= (double) row[1])) {
						TTTRI = (percvalues.get("Truck Travel Time Reliability Index") * (double) row[2]) / 100;
						break;
					}
				}

				rangeResults = fmsStipRepository.getWeight("Large Truck Crash Rate");
				for (Object[] row : rangeResults) {
					if ((Large_Truck_Crash_Rate > (double) row[0]) && (Large_Truck_Crash_Rate <= (double) row[1])) {
						Large_Truck_Crash_Rate = (percvalues.get("Large Truck Crash Rate") * (double) row[2]) / 100;
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

			ReportList.add(temp_obj);
			// check_dbnum_query = "Select sum(Score) from scrproject where DBNUM = '";
		}
		// return dbnums_score;
		System.out.println("Evaluation is done! the data is inserted into scrproject table!");
	}

	public static String generateCustomReportGISImage(
		String sri, String start_mp, String end_mp, FmsStipRepository fmsStipRepository
	) throws ClientProtocolException, IOException, JSONException {
		List<Object[]> bbdata = fmsStipRepository.getLatLngFromSRIandMP(sri.substring(0,9) + "%", start_mp, end_mp);
		double finalMinX = -300, finalMinY = -300, finalMaxX = 300, finalMaxY = 300;
		for (Object[] bb : bbdata) {
			String BLAT = ((BigDecimal) bb[0]).toString();
			String BLONG = ((BigDecimal) bb[1]).toString();
			double X,Y;
			//Logger.getLogger("ReportImage").info(BLAT+ " , " +BLONG);
			if (BLAT==null||BLONG==null) {
				Logger.getLogger("ReportImage").info("No Data found");
				X=0;Y=0;
			} else {
				//Logger.getLogger("ReportImage").info("DBNUM found");
				X = Double.parseDouble(BLONG);
				Y = Double.parseDouble(BLAT);
			}
			
			if (X > finalMinX) finalMinX = X;
			if (Y > finalMinY) finalMinY = Y; 
			if (X < finalMaxX) finalMaxX = X;
			if (Y < finalMaxY) finalMaxY = Y; 
		}
		if (bbdata.size()>1) {
			finalMinX+=0.01;
			finalMaxX-=0.01;
			finalMinY+=0.01;
			finalMaxY-=0.01;
		} else {
			finalMinX=((BigDecimal) bbdata.get(0)[1]).doubleValue();//Double.parseDouble((String) bbdata.get(0)[1]);
			finalMaxX=((BigDecimal) bbdata.get(0)[1]).doubleValue();//Double.parseDouble((String) bbdata.get(0)[1]);
			finalMinY=((BigDecimal) bbdata.get(0)[0]).doubleValue();//Double.parseDouble((String) bbdata.get(0)[0]);
			finalMaxY=((BigDecimal) bbdata.get(0)[0]).doubleValue();//Double.parseDouble((String) bbdata.get(0)[0]);
			finalMinX+=0.01;
			finalMaxX-=0.01;
			finalMinY+=0.01;
			finalMaxY-=0.01;
		}

		String serviceData = generateCustomReportArcGISImageData(sri, start_mp, end_mp, finalMaxX, finalMaxY, finalMinX, finalMinY);

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
		System.out.println("Response Code : " + 
                                    response.getStatusLine().getStatusCode());

		BufferedReader rd = new BufferedReader(
                        new InputStreamReader(response.getEntity().getContent()));

		StringBuffer result = new StringBuffer();
		String line = "";
		while ((line = rd.readLine()) != null) {
			result.append(line);
		}

		System.out.println(result.toString());
		JSONObject resultData = new JSONObject(result.toString());
		JSONObject resultsObj = resultData.getJSONArray("results").getJSONObject(0);
		String imgURL = resultsObj.getJSONObject("value").getString("url");
		return imgURL;
	}
	
	private static String generateCustomReportArcGISImageData(String sri, String start_mp, String end_mp,double maxX, double maxY, double minX,
	double minY) {
		logger.info("Generating ARCGIS Request");
		logger.info("SRI=" + sri);
		String request = "{" +
			"\"mapOptions\": { " +
				"\"extent\": { " +
					"\"xmin\": "+maxX+", " +
					"\"ymin\": "+maxY+", " +
					"\"xmax\": "+minX+", " +
					"\"ymax\": "+minY+", " +
					"\"spatialReference\": { " +
						"\"wkid\": 4326 " +
 					"} " +
				"} " +
			"}, " +
			"\"operationalLayers\": [ " + 
        		"{ " +
            		"\"url\": \"http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_NJ_Roadway_New/MapServer/0\", " +
					"\"layerDefinition\": { " +
                        "\"definitionExpression\": \"SRI LIKE '"+sri.substring(0,9)+"%' AND MP_START >= "+start_mp+" AND MP_END <= "+end_mp+" \", " +
						"\"drawingInfo\": {\"renderer\": {\"type\": \"simple\",\"symbol\": {\"type\": \"esriSLS\",\"color\": [230, 0, 0, 255],\"width\": 2,\"style\": \"esriSLSSolid\"}}}" + 
					"}" +
		        "}, " +
        		"{ " +
            		"\"url\": \"http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_NJ_Roadway_New/MapServer/1\", " +
					"\"layerDefinition\": { " +
                        "\"definitionExpression\": \"SRI LIKE '"+sri.substring(0,9)+"%' AND MP_START >= "+start_mp+" AND MP_END <= "+end_mp+" \", " + 
						"\"drawingInfo\": {\"renderer\": {\"type\": \"simple\",\"symbol\": {\"type\": \"esriSLS\",\"color\": [230, 0, 0, 255],\"width\": 2,\"style\": \"esriSLSSolid\"}}}" + 
                    "}" +
        		"}, " +
        		"{ " +
            		"\"url\": \"http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_NJ_Roadway_New/MapServer/2\", " +
					"\"layerDefinition\": { " +
                        "\"definitionExpression\": \"SRI LIKE '"+sri.substring(0,9)+"%' AND MP_START >= "+start_mp+" AND MP_END <= "+end_mp+" \", " +
						"\"drawingInfo\": {\"renderer\": {\"type\": \"simple\",\"symbol\": {\"type\": \"esriSLS\",\"color\": [230, 0, 0, 255],\"width\": 2,\"style\": \"esriSLSSolid\"}}}" + 
                    "}" +
        		"} " +
    		"], " +
			"\"baseMap\": { " +
				"\"title\": \"Topographic Basemap\", " +
				"\"baseMapLayers\": [ " +
					"{ " +
						"\"url\": \"https://services.arcgisonline.com/arcgis/rest/services/World_Street_Map/MapServer\" " +
					"}" +
				"] " +
			"}, " +
			"\"exportOptions\": { " +
				"\"outputSize\": [ " +
					"800, " +
					"700 " +
				"] " +
			"} " +
		"}";
logger.info("JSON Request: " + request);
return request;
}


}
