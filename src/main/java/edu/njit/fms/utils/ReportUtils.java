package edu.njit.fms.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

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

import edu.njit.fms.db.entity.CdpProjects;
import edu.njit.fms.db.entity.CustomProject;
import edu.njit.fms.db.repository.FmsStipRepository;

/**
 * This class is responsible for generating data required when building a CrystalReport
 * @author Karthik Sankaran
 * @version February 2020
 */
public class ReportUtils {
    private final static Logger logger = Logger.getLogger(ReportUtils.class);
    
    /**
     * Generates an image using ArcGIS
     * @param cdpProject The CDP project, used to determine extent and highlighting
     * @param fmsStipRepository A reference to the FMS STIP table
     * @return A string containing the URL of the generated image
     * @throws ClientProtocolException
     * @throws IOException
     * @throws JSONException
     */
    public static String generateReportGISImage(CdpProjects cdpProject, FmsStipRepository fmsStipRepository)
            throws ClientProtocolException, IOException, JSONException {
        CustomProject cp = new CustomProject(cdpProject.getDbnum(), cdpProject.getSri(), cdpProject.getMpStart(), cdpProject.getMpEnd(), 0);
        List<CustomProject> cdpl = new ArrayList<>();
        cdpl.add(cp);
        return generateReportGISImage(cdpl, fmsStipRepository);
    }

    /**
     * Generates an image using ArcGIS
     * @param routesList A list of routes/StartMP/endMP data
     * @param fmsStipRepository A reference to the FMS STIP table
     * @return A string containing the URL of the generated image
     * @throws ClientProtocolException
     * @throws IOException
     * @throws JSONException
     */
    public static String generateReportGISImage(List<CustomProject> routesList, FmsStipRepository fmsStipRepository)
            throws ClientProtocolException, IOException, JSONException {
        double finalMinX = -300, finalMinY = -300, finalMaxX = 300, finalMaxY = 300; //init with max/min values
        for (CustomProject c : routesList) {
            List<Object[]> bbdata = fmsStipRepository.getLatLngFromSRIandMP(c.getSri().substring(0,9) + "%", c.getMpStart() + "", c.getMpEnd() + "");
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
        }
        /* if (bbdata.size()>1) {
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
        } */
        
        if (finalMinX == finalMaxX && finalMinY == finalMaxY) {
            finalMinX+=0.01;
			finalMaxX-=0.01;
			finalMinY+=0.01;
			finalMaxY-=0.01;
        }
        System.out.println("MinX:" + finalMinX + ",maxX:" + finalMaxX + ",minY:" + finalMinY + ",maxY:" + finalMaxY);
        System.out.println("X Diff: " + (finalMaxX - finalMinX));
        System.out.println("Y Diff: " + (finalMaxY - finalMinY));
        if (finalMinY - finalMaxY < 0.002) finalMinY += 0.001;

        String serviceData = generateArcGISImageRequestPOSTData(routesList, finalMaxX, finalMaxY, finalMinX, finalMinY);

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
        String imgURL = "";
        if (resultData.has("results")) {
            JSONObject resultsObj = resultData.getJSONArray("results").getJSONObject(0);
            imgURL = resultsObj.getJSONObject("value").getString("url");
        }
		return imgURL;

    }

    /**
     * Creates the POST data that must be sent to ArcGIS to generate the image
     * @param routesList List of customProjects to highlight
     * @param maxX Extent
     * @param maxY Extent
     * @param minX Extent
     * @param minY Extent
     * @return The POST data to be sent to ArcGIS
     */
    private static String generateArcGISImageRequestPOSTData(List<CustomProject> routesList, double maxX,
            double maxY, double minX, double minY) {
                //lets build the definition expression
                List<String> defExpParts = new ArrayList<>();
                for (CustomProject c : routesList) defExpParts.add("(SRI LIKE '"+c.getSri().substring(0,9)+"%' AND MP_START >= "+c.getMpStart()+" AND MP_END <= "+c.getMpEnd()+")");
                String defExpr = defExpParts.stream().collect(Collectors.joining(" OR "));

                logger.info("Generating ARCGIS Request");
                String request = "{" +
        			"\"mapOptions\":{" +
        				"\"extent\":{" +
        					"\"xmin\":"+maxX+"," +
        					"\"ymin\":"+maxY+"," +
        					"\"xmax\":"+minX+"," +
        					"\"ymax\":"+minY+"," +
        					"\"spatialReference\":{" +
        						"\"wkid\":4326" +
        					"}" +
        				"}" +
        			"}," +
        			"\"operationalLayers\":[" + 
                		"{" +
                    		"\"url\":\"http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_NJ_Roadway_New/MapServer/0\"," +
        					"\"layerDefinition\":{" +
                                "\"definitionExpression\":\""+defExpr+"\"," +
        						"\"drawingInfo\":{\"renderer\":{\"type\":\"simple\",\"symbol\":{\"type\":\"esriSLS\",\"color\":[230,0,0,255],\"width\":2,\"style\":\"esriSLSSolid\"}}}" + 
        					"}" +
        		        "}," +
                		"{" +
                    		"\"url\":\"http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_NJ_Roadway_New/MapServer/1\"," +
        					"\"layerDefinition\":{" +
                                "\"definitionExpression\":\""+defExpr+"\"," + 
        						"\"drawingInfo\":{\"renderer\":{\"type\":\"simple\",\"symbol\":{\"type\":\"esriSLS\",\"color\":[230,0,0,255],\"width\":2,\"style\":\"esriSLSSolid\"}}}" + 
                            "}" +
                		"}," +
                		"{" +
                    		"\"url\":\"http://transprod05.njit.edu:6080/arcgis/rest/services/FMS/FMS_NJ_Roadway_New/MapServer/2\"," +
        					"\"layerDefinition\":{" +
                                "\"definitionExpression\":\""+defExpr+"\"," +
        						"\"drawingInfo\":{\"renderer\":{\"type\":\"simple\",\"symbol\":{\"type\":\"esriSLS\",\"color\":[230,0,0,255],\"width\":2,\"style\":\"esriSLSSolid\"}}}" + 
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
        					"700" +
        				"]" +
        			"}" +
        		"}";
        logger.info("JSON Request: " + request);
        return request;
    }
}