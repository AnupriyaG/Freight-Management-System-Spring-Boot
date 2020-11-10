package edu.njit.fms.utils;

import java.io.ByteArrayInputStream;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.businessobjects.visualization.graphic.Property;
import com.crystaldecisions.report.web.viewer.ReportExportControl;
import com.crystaldecisions.reports.reportengineinterface.JPEReportSource;
import com.crystaldecisions.reports.sdk.DatabaseController;
import com.crystaldecisions.reports.sdk.IDataDefinition;
import com.crystaldecisions.reports.sdk.ParameterFieldController;
import com.crystaldecisions.reports.sdk.PrintOutputController;
import com.crystaldecisions.reports.sdk.ReportClientDocument;
import com.crystaldecisions.sdk.occa.report.application.ReportSource;
import com.crystaldecisions.sdk.occa.report.data.ConnectionInfo;
import com.crystaldecisions.sdk.occa.report.data.ConnectionInfos;
import com.crystaldecisions.sdk.occa.report.data.DBField;
import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.data.GroupPath;
import com.crystaldecisions.sdk.occa.report.data.IDBField;
import com.crystaldecisions.sdk.occa.report.data.IProcedure;
import com.crystaldecisions.sdk.occa.report.data.ITable;
import com.crystaldecisions.sdk.occa.report.data.ParameterField;
import com.crystaldecisions.sdk.occa.report.data.ParameterFieldDiscreteValue;
import com.crystaldecisions.sdk.occa.report.data.Values;
import com.crystaldecisions.sdk.occa.report.exportoptions.ExportOptions;
import com.crystaldecisions.sdk.occa.report.exportoptions.PDFExportFormatOptions;
import com.crystaldecisions.sdk.occa.report.exportoptions.ReportExportFormat;
import com.crystaldecisions.sdk.occa.report.lib.IStrings;
import com.crystaldecisions.sdk.occa.report.lib.PropertyBag;
import com.crystaldecisions.sdk.occa.report.lib.PropertyBagHelper;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKException;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;

import org.apache.commons.compress.utils.IOUtils;
import org.apache.log4j.Logger;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;

/**
 * This class is responsible for exporting a CrystalReport file to PDF
 * 
 * @author Karthik Sankaran
 * @version February 2020
 */
@Controller
@Component
public class CrystalReportUtils {
	private final static Logger logger = Logger.getLogger(CrystalReportUtils.class);

	/**
	 * Create a PDF file using the Crystal Reports engine
	 * 
	 * @param reportURI    The location of the rpt file
	 * @param reportFields The parameters that should be passed to the report
	 * @param request      A reference to the HTTPServletRequest
	 * @param response     A refernce to the HTTPServletResponse
	 * @param env          A reference to the Environment in order to read the
	 *                     properties file
	 * @throws ReportSDKExceptionBase Thrown when CrystalReports detects an error
	 * @throws IOException
	 */
	public static void generateCrystalReportPDF(String reportURI, Fields reportFields, HttpServletRequest request,
			HttpServletResponse response, Environment env) throws ReportSDKExceptionBase, IOException {
		String userName = env.getProperty("crystalreports.databaseUsername");
		String password = env.getProperty("crystalreports.databasePassword");

		PropertyBag connectionAttributes = getConnectionPropertiesBag(env);

		ReportClientDocument oReportClientDocument = new ReportClientDocument();
		oReportClientDocument.open(reportURI, 0);

		changeDatabase(oReportClientDocument, connectionAttributes, userName, password);

		JPEReportSource reportSourceProject = (JPEReportSource) oReportClientDocument.getReportSource();// Get the
																										// report
																									// source

		ConnectionInfos oConnectionInfos = new ConnectionInfos();
		ConnectionInfo oConnectionInfo = new ConnectionInfo();

		// oConnectionInfo.setAttributes(connectionAttributes);

		// Set username and password for the reports database
		oConnectionInfo.setUserName(userName);
		oConnectionInfo.setPassword(password);

		// Add object to collection
		oConnectionInfos.add(oConnectionInfo);

		// Create a Fields collection object to store the parameter fields in.
		Fields oFields = reportFields;

		ReportExportControl exportControl = new ReportExportControl();
		ExportOptions exportOptions = new ExportOptions();
		exportOptions.setExportFormatType(ReportExportFormat.PDF);
		PDFExportFormatOptions PDFExpOpts = new PDFExportFormatOptions();
		exportOptions.setFormatOptions(PDFExpOpts);
		exportControl.setReportSource(reportSourceProject);
		exportControl.setParameterFields(oFields);
		exportControl.setDatabaseLogonInfos(oConnectionInfos);
		exportControl.setExportOptions(exportOptions);
		exportControl.setExportAsAttachment(true);
		exportControl.setName("FMSReport");
		logger.info("Writing report data");
		exportControl.processHttpRequest(request, response,
		 request.getServletContext(), null);

		/* PrintOutputController poc = oReportClientDocument.getPrintOutputController();
		ByteArrayInputStream byteArrayInputStream = (ByteArrayInputStream) poc.export(ReportExportFormat.PDF);
		oReportClientDocument.close();

		writeToBrowser(byteArrayInputStream, response, "application/pdf"); */
	}

	/*
	 * Utility method that demonstrates how to write an input stream to the server's
	 * local file system.
	 */
	private static void writeToBrowser(ByteArrayInputStream byteArrayInputStream, HttpServletResponse response,
			String mimetype) throws IOException {
	
		//Create a byte[] the same size as the exported ByteArrayInputStream.
		byte[] buffer = new byte[byteArrayInputStream.available()];
		int bytesRead = 0;
		
		//Set response headers to indicate mime type and inline file.
		response.reset();
		response.setHeader("Content-disposition", "inline;filename=report.pdf");
		response.setContentType(mimetype);
		
		//Stream the byte array to the client.
		while((bytesRead = byteArrayInputStream.read(buffer)) != -1) {
			response.getOutputStream().write(buffer, 0, bytesRead);	
		}
		
		//Flush and close the output stream.
		response.getOutputStream().flush();
		response.getOutputStream().close();
		
	}

	private static void changeDatabase(ReportClientDocument oReportClientDocument, PropertyBag connectionAttributes,
			String username, String password) throws ReportSDKException {
				System.out.println("MODIFYING THE DATABASE CONNECTION!!!");
		DatabaseController dbController = oReportClientDocument.getDatabaseController();

		for(Object table : dbController.getDatabase().getTables()) {
			IProcedure oldTable = (IProcedure) table;
			IProcedure newTable = (IProcedure)oldTable.clone(true);  
			
			for (int i = 0; i < newTable.getParameters().size(); i++) {
				ParameterField paramField = (ParameterField)newTable.getParameters().get(i);
				ParameterFieldDiscreteValue parameterValue = new ParameterFieldDiscreteValue();
				if (paramField.getName().equalsIgnoreCase("customsql")) parameterValue.setValue("DBNUM = '00357C'");
				else if (paramField.getName().equalsIgnoreCase("dbnum")) parameterValue.setValue("('1')");
				else if (paramField.getName().equalsIgnoreCase("system_id")) parameterValue.setValue("('1')");
				else parameterValue.setValue("1");

				Values currentValues = new Values();
				currentValues.add(parameterValue);
				paramField.setCurrentValues(currentValues);
			}


			newTable.getConnectionInfo().setAttributes(connectionAttributes);        
			newTable.getConnectionInfo().setUserName(username);
			newTable.getConnectionInfo().setPassword(password);
			
			dbController.setTableLocation(oldTable, newTable); 

		}

		IStrings subReportNames = oReportClientDocument.getSubreportController().getSubreportNames();
		for (int i = 0; i < subReportNames.size(); i ++) {
			DatabaseController subreportDatabaseController = oReportClientDocument.getSubreportController().getSubreport(subReportNames.get(i)).getDatabaseController();

			for(Object table : subreportDatabaseController.getDatabase().getTables()) {
				IProcedure oldTable = (IProcedure) table;
				IProcedure newTable = (IProcedure)oldTable.clone(true);  
				
				for (int j = 0; j < newTable.getParameters().size(); j++) {
					ParameterField paramField = (ParameterField)newTable.getParameters().get(j);
					ParameterFieldDiscreteValue parameterValue = new ParameterFieldDiscreteValue();
					if (paramField.getName().equalsIgnoreCase("customsql")) parameterValue.setValue("DBNUM = '00357C'");
					else if (paramField.getName().equalsIgnoreCase("dbnum")) parameterValue.setValue("('1')");
					else if (paramField.getName().equalsIgnoreCase("system_id")) parameterValue.setValue("('1')");
					else parameterValue.setValue("1");
	
					Values currentValues = new Values();
					currentValues.add(parameterValue);
					paramField.setCurrentValues(currentValues);
				}
				

				newTable.getConnectionInfo().setAttributes(connectionAttributes);        
				newTable.getConnectionInfo().setUserName(username);
				newTable.getConnectionInfo().setPassword(password);
				
				subreportDatabaseController.setTableLocation(oldTable, newTable); 

			}

		}
		
	}

	private static PropertyBag getConnectionPropertiesBag(Environment env) {
		PropertyBag connectionAttributes = new PropertyBag();
		
		connectionAttributes.put("Server Name", env.getProperty("crystalreports.serverName"));
		connectionAttributes.put("Database Name", env.getProperty("crystalreports.databaseName"));
		connectionAttributes.put("Server", env.getProperty("crystalreports.server"));
		connectionAttributes.put("Database DLL", env.getProperty("crystalreports.databaseDLL"));
		connectionAttributes.put("Database", env.getProperty("crystalreports.database"));
		connectionAttributes.put("Connection URL", env.getProperty("crystalreports.connectionURL"));
		connectionAttributes.put("PreQEServerName", env.getProperty("crystalreports.preQEServerName"));
		connectionAttributes.put("JDBC Connection String", env.getProperty("crystalreports.jdbcConnectionString"));

		return connectionAttributes;
	}
	/**
	 * 
	 * @param reportName The name of the subreport, use an empty string for the main report
	 * @param paramName The parameters Name
	 * @param value The parameters value
	 * @return A ParameterField for use in generating a report
	 */
	public static ParameterField createCrystalReportParameterField(
		String reportName, 
		String paramName, 
		Object value
	) {
		ParameterField oParameterField = new ParameterField();
		oParameterField.setReportName(reportName);
		Values oValues = new Values();
		ParameterFieldDiscreteValue oParameterFieldDiscreteValue = new ParameterFieldDiscreteValue();
		oParameterField.setName(paramName);
		oParameterFieldDiscreteValue.setValue(value);
		oValues.add(oParameterFieldDiscreteValue);
		oParameterField.setCurrentValues(oValues);
		return oParameterField;

	}

}
