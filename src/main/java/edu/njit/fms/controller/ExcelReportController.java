package edu.njit.fms.controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.xml.sax.SAXException;

import edu.njit.fms.db.entity.CdpProjects;
import edu.njit.fms.db.entity.UniqueCdpProjectsWithScores;
import edu.njit.fms.db.repository.CdpProjectsRepository;
import edu.njit.fms.db.repository.DashboardRepository;
import edu.njit.fms.db.repository.FmsStipRepository;

/**
 * @author Karthik Sankaran
 *
 */
@Controller
public class ExcelReportController {
	@Autowired
	FmsStipRepository fmsStipRepository;

	@Autowired
	DashboardRepository dashboardRepository;

	@Autowired
    CdpProjectsRepository cdpProjectsRepository;
	
	@Autowired
	EntityManager entityManager;

	private CellStyle headerCellStyle;

	@RequestMapping(value = "OnlyStateSummaryExcelReport")
	@ResponseBody
	public void getStateSummaryExcelReport(HttpServletRequest request, HttpServletResponse response) throws ClassNotFoundException, ParserConfigurationException, SAXException, SQLException, IOException {
		List<Object[]> resultData = null;
		HashMap<String,String> filterDataMap = new HashMap<>();
		Workbook workbook = new XSSFWorkbook();
		headerCellStyle = createHeaderCellStyle(workbook);

		Sheet sheet = workbook.createSheet("State Summary");
		String[] stateSummaryColHeaders = {"Year","TTTRIndex","Truck Craches(% of Total)","Miles Congested(%)"};
		resultData = dashboardRepository.getStateSummaryForExcelReport();
		createHeaderRow(sheet, stateSummaryColHeaders,0,0);
		populateData(sheet, resultData,0,0);
		int numColumns = stateSummaryColHeaders.length;
		for (int i=0; i< numColumns;i++) {
			sheet.autoSizeColumn(i);
		}
	
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		response.setHeader("Content-Disposition", "attachment; filename=DashBoard Report"+".xlsx");
		workbook.write(response.getOutputStream());
		workbook.close();
	}

	@RequestMapping(value = "DashboardExcelReport")
	@ResponseBody
	public void getDashboardExcelReport(@RequestParam("roadway") String road, @RequestParam("direction") String direction, @RequestParam("sri") String sri, @RequestParam("year") String year, HttpServletRequest request, HttpServletResponse response) throws ClassNotFoundException, ParserConfigurationException, SAXException, SQLException, IOException {
		List<Object[]> resultData = null;
		HashMap<String,String> filterDataMap = new HashMap<>();
		Workbook workbook = new XSSFWorkbook();
		headerCellStyle = createHeaderCellStyle(workbook);
		
		Sheet sheet = workbook.createSheet("STATE_SUMMARY");
		String[] stateSummaryColHeaders = {"Year","TTTRIndex","Truck Crashes(% of Total)","Miles Congested(%)"};
		resultData = dashboardRepository.getStateSummaryForExcelReport();
		createHeaderRow(sheet, stateSummaryColHeaders,0,0);
		populateData(sheet, resultData,0,0);
		int numColumns = stateSummaryColHeaders.length;
		for (int i=0; i< numColumns;i++) {
			sheet.autoSizeColumn(i);
		}

		sheet = workbook.createSheet("ROUTE_SUMMARY_"+road);
		String[] routeSummaryColHeaders = {"Year","Roadway","Direction","SRI","TTTRIndex","Truck Crashes(% of Total)","Miles Congested(%)"};
		resultData = dashboardRepository.getRouteSummaryForExcelReport(road,direction,sri);
		createHeaderRow(sheet, routeSummaryColHeaders,0,0);
		populateData(sheet, resultData,0,0);
		numColumns = routeSummaryColHeaders.length;
		for (int i=0; i< numColumns;i++) {
			sheet.autoSizeColumn(i);
		}

		sheet = workbook.createSheet("TTRI_"+road);
		String[] ttriColHeaders = {"Year","Milepost","MaxTTR"};
		resultData = dashboardRepository.getRouteTttriByMilepost(road,direction);
		createHeaderRow(sheet, ttriColHeaders,0,0);
		populateData(sheet, resultData,0,0);
		numColumns = ttriColHeaders.length;
		for (int i=0; i< numColumns;i++) {
			sheet.autoSizeColumn(i);
		}

		sheet = workbook.createSheet("TRUCK_CRASHES_"+road);
		String[] truckCrashesColHeaders = {"Year","SMP","Truck Crashes(% of Total)"};
		resultData = dashboardRepository.getRouteCrashesByMilepost(sri);
		createHeaderRow(sheet, truckCrashesColHeaders,0,0);
		populateData(sheet, resultData,0,0);
		numColumns = truckCrashesColHeaders.length;
		for (int i=0; i< numColumns;i++) {
			sheet.autoSizeColumn(i);
		}

		sheet = workbook.createSheet("TRUCK_VOLUME_"+road);
		String[] truckVolumeColHeaders = {"Milepost","Truck"};
		resultData = dashboardRepository.getRouteVolumeByMilepost(sri);
		createHeaderRow(sheet, truckVolumeColHeaders,0,0);
		populateData(sheet, resultData,0,0);
		numColumns = truckVolumeColHeaders.length;
		for (int i=0; i< numColumns;i++) {
			sheet.autoSizeColumn(i);
		}

		sheet = workbook.createSheet("SEVERITY_RATE_FOR_"+road);
		String[] severityColHeaders = {"Milepost","Truck","Severity Rate"};
		resultData = dashboardRepository.getRouteLargeTruckSeverityForExcelReport(sri);
		createHeaderRow(sheet, severityColHeaders,0,0);
		populateData(sheet, resultData,0,0);
		numColumns = severityColHeaders.length;
		for (int i=0; i< numColumns;i++) {
			sheet.autoSizeColumn(i);
		}
			
		response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
		response.setHeader("Content-Disposition", "attachment; filename=DashBoard Report"+".xlsx");
		workbook.write(response.getOutputStream());
		workbook.close();
	}
	
	
	
	@RequestMapping(value = "excelReport")
	@ResponseBody
	public void getExcelReport(@RequestParam("dbnums") List<String> dbnums,@RequestParam("systemID") String systemID, HttpServletRequest request, HttpServletResponse response) throws ClassNotFoundException, ParserConfigurationException, SAXException {
		try {
			List<Object[]> selectedStipReport_data = fmsStipRepository.getSelectedStipReport(dbnums, systemID);
			Workbook workbook = new XSSFWorkbook();
			headerCellStyle = createHeaderCellStyle(workbook);
			Sheet sheet = workbook.createSheet("Data");
			
			String[] stipReportHeaders = {"DBNUM", "Project Type", "Project Name", "Description", "Route", "SRI", "Start MP", "End MP", "MPO", "System Name", "Large Truck Severity Rate", "Overweight Truck Permits", "Percentage of Large Truck Volume", "Truck Travel Time Reliability Index", 
			"National Highway Network", "Large Truck Crash Rate", "Intermodal Connector", "NJ Access Network", "National Highway Freight Network", "Total Score", "Priority"};
			createHeaderRow(sheet, stipReportHeaders,0,0);
			
			populateData(sheet, selectedStipReport_data,0,0);
			int numColumns = stipReportHeaders.length;
			for (int i=0; i< numColumns;i++) {
				sheet.autoSizeColumn(i);
			}
			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			response.setHeader("Content-Disposition", "attachment; filename=FMSReport.xlsx");
			workbook.write(response.getOutputStream());
			workbook.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("Excel report generated");
	}

	//Generate Excel Report for CDP projects
	@RequestMapping(value = "excelReportForCDP")
	@ResponseBody
	public void getExcelReportCDP(@RequestParam("dbnum") List<String> dbnums,@RequestParam("scoresystem") String systemID, HttpServletRequest request, HttpServletResponse response) throws ClassNotFoundException, ParserConfigurationException, SAXException {
		try {
			//Getting CDP Projects data for Excel report
			List<Object[]> selectedCDPprojects = cdpProjectsRepository.getCDPExcelReportData(dbnums, systemID);
			Workbook workbook = new XSSFWorkbook();
			headerCellStyle = createHeaderCellStyle(workbook);
			Sheet sheet = workbook.createSheet("Data");
			
			//Headers of columns for the excel Report
			String[] cdpHeaders = {"DBNUM","Project Name","Route", "SRI", "Start MP", "End MP", "System Name","Large Truck Severity Rate", "Overweight Truck Permits", "Percentage of Large Truck Volume",
			"Truck Travel Time Reliability Index","National Highway Network", "Large Truck Crash Rate", "Intermodal Connector", "NJ Access Network", "National Highway Freight Network", "Total Score", "Priority"};
			createHeaderRow(sheet, cdpHeaders,0,0);

			//Populate excel sheet with data
			populateData(sheet, selectedCDPprojects,0,0);
			int numColumns = cdpHeaders.length;
			for (int i=0; i< numColumns;i++) {
				sheet.autoSizeColumn(i);
			}
			response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
			response.setHeader("Content-Disposition", "attachment; filename=CDPReport.xlsx");
			workbook.write(response.getOutputStream());
			workbook.close();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		System.out.println("Excel report for selected CDP Projects generated");
	}

	private void populateData(Sheet sheet, List<Object[]> results, int columnOffset, int rowOffset) throws SQLException {
		int colCount = 0;
		if (results.size()>0) colCount = results.get(0).length;
		int rowNumber = 1 + rowOffset;
		for (Object[] o : results) {
			Row r = sheet.getRow(rowNumber);
			if (r==null) r = sheet.createRow(rowNumber);
			for (int j = 0; j < colCount; j++) {
				Cell c = r.createCell(j + columnOffset);
				if (o[j] instanceof Double) {
					c.setCellValue((double) o[j]);
					c.setCellType(CellType.NUMERIC);
				} else if (o[j] instanceof Integer) {
					c.setCellValue((int) o[j]);
					c.setCellType(CellType.NUMERIC);
				}else if(o[j] instanceof BigDecimal ) {
					BigDecimal bd = (BigDecimal)o[j];
					c.setCellValue(bd.doubleValue());
					c.setCellType(CellType.NUMERIC);
				}
				else {
					c.setCellValue((String) o[j]);
				}
			}
			rowNumber++;
		}
	}

	private Row createHeaderRow(Sheet sheet, String[] headers, int columnOffset, int rowOffset) throws SQLException {
		Row r = sheet.getRow(0 + rowOffset);
		if (r==null) r = sheet.createRow(0);
		int numColumns = headers.length;
		for (int i = 0; i < numColumns; i++) {
			Cell c = r.createCell(i+columnOffset);
			c.setCellValue(headers[i]);
			c.setCellStyle(headerCellStyle);
		}
		return r;
	}

	private CellStyle createHeaderCellStyle(Workbook workbook) {
		// Create a Font for styling header cells
        Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerFont.setFontHeightInPoints((short) 12);
        headerFont.setColor(IndexedColors.BLACK.getIndex());

        // Create a CellStyle with the font
        CellStyle headerCellStyle = workbook.createCellStyle();
        headerCellStyle.setFont(headerFont);
        return headerCellStyle;
	}
}
