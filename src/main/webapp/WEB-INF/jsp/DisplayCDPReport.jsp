<%@ page trimDirectiveWhitespaces="true" %>
<%@page import="com.crystaldecisions.reports.sdk.*" %>
<%@page import="com.crystaldecisions.sdk.occa.report.data.*" %>
<%@page import="com.crystaldecisions.sdk.occa.report.lib.*" %>
<%@page import="com.crystaldecisions.sdk.occa.report.reportsource.IReportSource" %>
<%@page import="com.crystaldecisions.report.web.viewer.CrystalReportViewer" %>
<%@page import="com.crystaldecisions.report.web.viewer.CrPrintMode" %>
<%@ page import="com.crystaldecisions.report.web.viewer.ReportExportControl" %>
<%@ page import="com.crystaldecisions.reports.sdk.ReportClientDocument" %>
<%@ page import="com.crystaldecisions.sdk.occa.report.exportoptions.ExportOptions" %>
<%@ page import="com.crystaldecisions.sdk.occa.report.exportoptions.ReportExportFormat" %>
<%@ page import="com.crystaldecisions.sdk.occa.report.exportoptions.RTFWordExportFormatOptions" %>
<%@ page import="com.crystaldecisions.sdk.occa.report.exportoptions.PDFExportFormatOptions" %>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="com.crystaldecisions.report.web.viewer.*"%>
<%@page import="com.crystaldecisions.report.web.*"%>
<%@page import="com.crystaldecisions.reports.sdk.*" %>
<%@page import="com.crystaldecisions.sdk.occa.report.reportsource.*" %>
<%@page import="com.crystaldecisions.sdk.occa.report.data.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>

 <p>Loading latest TIP/STIP projects....Please wait!</p>
	
<%-- <%

	XenoRequest         xeno     = (XenoRequest)request.getAttribute( "XenoRequest" );
%> --%>
<p>Custom SQL: <%-- <%= xeno.getArgument("customsql") %> --%></p>
<%
	     //TIPSearch search = (TIPSearch)Evaluate.string( xeno, "$object{ Search }" );


  	/* String customsql=(String)xeno.getArgument("customsql"); */
  	String dbnum= (request.getAttribute("dbnum")).toString();
		String system_id= (request.getAttribute("system_id")).toString();
		 //session.setAttribute("customsql", customsql);
	     //String filter = customsql ;




/* 		 String ses = (String)xeno.getArgument("session");
		 session.setAttribute("ses",ses); */

		 String reportfile_final="jsp/reports/FMSCDPProject_Multiple.rpt";
			 //String reportfile_final="jsp/reports/Web_Telus_ScoringReport_chartsonly_FMS.rpt";

      //Database username and password
      String userName = "telus_user";
      String password = "telus_user_20110316";


        //check to see if the report source already exists
        Object reportSourceProject = session.getAttribute("reportSourceProject");
        String webRootPath = application.getRealPath("/WEB-INF/jsp/reports/FMSCDPReport.rpt");
        System.out.println(webRootPath);
        //if the report source has not been opened
        //if (reportSourceProject == null) {
          //---------- Create a ReportClientDocument -------------
          ReportClientDocument oReportClientDocument = new ReportClientDocument();

          //---------- Set the path to the location of the report soruce -------------

          //Open report.
          //oReportClientDocument.open("jsp/reports/STIP_Report_Web_Telus.rpt", 0);
		 oReportClientDocument.open("reports/FMSCDPReport.rpt", 0);

          //Get the report source
          reportSourceProject = oReportClientDocument.getReportSource();

          //Cache report source.
          //This will be used by the viewer to display the desired report.
          //session.setAttribute("reportSourceProject", reportSourceProject);
		  session.setAttribute("reportfile_final", reportSourceProject);


        //}

        //Create a new ConnectionInfos and ConnectionInfo object; the ConnectionInfo
        //  will be added to the ConnectionInfos collection after the properties are
        //  set.  The collection can be a collection of one or more objects.
        ConnectionInfos oConnectionInfos = new ConnectionInfos();
        ConnectionInfo oConnectionInfo = new ConnectionInfo();

        //Set username and password for the reports database
        oConnectionInfo.setUserName(userName);
        oConnectionInfo.setPassword(password);

        //Add object to collection
        oConnectionInfos.add(oConnectionInfo);

        session.setAttribute("oConnectionInfos", oConnectionInfos);

        //Create a Fields collection object to store the parameter fields in.
        Fields oFields = new Fields();
        //String CUSTOMSQL = filter;

        setDiscreteParameterValue(oFields, "dbnum", "", dbnum);
        setDiscreteParameterValue(oFields, "dbnum", "Web_Telus_PieChartAnalysis", dbnum);
        setDiscreteParameterValue(oFields, "dbnum", "Web_Telus_TableAnalysis", dbnum);
        setDiscreteParameterValue(oFields, "system_id", "", system_id);
        setDiscreteParameterValue(oFields, "system_id", "Web_Telus_PieChartAnalysis", system_id);
        setDiscreteParameterValue(oFields, "system_id", "Web_Telus_TableAnalysis", system_id);
        session.setAttribute("parameterFields", oFields);


    ReportExportControl exportControl = new ReportExportControl();

    ExportOptions exportOptions = new ExportOptions();

    exportOptions.setExportFormatType(ReportExportFormat.PDF);

    PDFExportFormatOptions PDFExpOpts = new PDFExportFormatOptions();

//    PDFExpOpts.setStartPageNumber(1);

//    RTFExpOpts.setEndPageNumber(3);

    exportOptions.setFormatOptions(PDFExpOpts);

    exportControl.setReportSource(reportSourceProject);

    Fields parameterFields = (Fields)session.getAttribute("parameterFields");
    exportControl.setParameterFields(parameterFields);

	exportControl.setDatabaseLogonInfos(oConnectionInfos);

    exportControl.setExportOptions(exportOptions);

    exportControl.setExportAsAttachment(true);

    exportControl.setName("FMSReport");
    
    exportControl.processHttpRequest(request, response, getServletConfig().getServletContext(), null);

%>
<%!
  /*
   * Utility function to set values for the discrete parameters in the report.  The report parameter value is set
   * and added to the Fields collection, which can then be passed to the viewer so that the user is not prompted
   * for parameter values.
   */
  private void setDiscreteParameterValue(Fields oFields, String paramName,
                                         String reportName, Object value) {

    //Create a ParameterField object for each field that you wish to set.
    ParameterField oParameterField = new ParameterField();

    //You must set the report name.
    //Set the report name to an empty string if your report does not contain a
    //subreport; otherwise, the report name will be the name of the subreport
    oParameterField.setReportName(reportName);

    //Create a Values object and a ParameterFieldDiscreteValue object for each
    //object for each parameter field you wish to set.
    //If a ranged value is being set, a ParameterFieldRangeValue object should
    //be used instead of the discrete value object.
    Values oValues = new Values();
    ParameterFieldDiscreteValue oParameterFieldDiscreteValue = new
        ParameterFieldDiscreteValue();

    //Set the name of the parameter.  This must match the name of the parameter as defined in the
    //report.
    oParameterField.setName(paramName);
    oParameterFieldDiscreteValue.setValue(value);

    //Add the parameter field values to the Values collection object.
    oValues.add(oParameterFieldDiscreteValue);

    //Set the current Values collection for each parameter field.
    oParameterField.setCurrentValues(oValues);

    //oParameterField.setReportName("");

    //Add parameter field to the Fields collection.  This object is then passed to the
    //viewer as the collection of parameter fields values set.
    oFields.add(oParameterField);
  }



%>