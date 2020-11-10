/**
 * 
 */
package edu.njit.fms.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import edu.njit.fms.db.repository.DashboardRepository;
import edu.njit.fms.db.repository.FmsStipRepository;
import edu.njit.fms.utils.AlphanumericStringComparator;

/**
 * This controller is responsible for displaying Dashboard related pages
 * @author Karthik Sankaran
 *
 */
@Controller
public class DashboardController {
	@Autowired
	ObjectMapper mapper;

	@Autowired
	FmsStipRepository fmsStipRepository;

	@Autowired
	DashboardRepository dashboardRepository;

	@RequestMapping(value="routeTttriByMilepost")
	@ResponseBody
	public HashMap<String, List<Object[]>> getMaxTTTR(
		@RequestParam(name = "intersection") String intersection, 
		@RequestParam(name = "direction") String direction
	) {
		HashMap<String, List<Object[]>> hm = new HashMap<>();
		List<Object[]> data = dashboardRepository.getRouteTttriByMilepost(intersection, direction);
		for (Object[] data_arr : data) {
			String period = (Integer) data_arr[0] + "";
			Object[] row = new Object[2];
			row[0] = data_arr[1];
			row[1] = data_arr[2];
			if(hm.containsKey(period)) {
				hm.get(period).add(row);
			} else {
				ArrayList<Object[]> t = new ArrayList<>();
				t.add(row);
				hm.put(period, t);
			}
		}		
		return hm;
	}

	@RequestMapping(value = "routeTttriCategoriesByMilepost")
	@ResponseBody
	public HashMap<String, List<Object[]>> getDetailTTTR(
		@RequestParam(name = "intersection") String intersection, 
		@RequestParam(name = "direction") String direction, 
		@RequestParam(name = "year") String year
	) {
		HashMap<String, List<Object[]>> hm = new HashMap<>();
		List<Object[]> data = dashboardRepository.getRouteTttriCategoriesByMilepost(intersection, direction, year);
		for (Object[] data_arr : data) {
			String period = (String) data_arr[0];
			Object[] row = new Object[2];
			row[0] = data_arr[3];
			row[1] = data_arr[2];
			if(hm.containsKey(period)) {
				hm.get(period).add(row);
			} else {
				ArrayList<Object[]> t = new ArrayList<>();
				t.add(row);
				hm.put(period, t);
			}
		}
		return hm;
	}

	@RequestMapping(value = "routeVolumeByMilepost")
	@ResponseBody
	public  List<Object[]> getTrkVolByMP(
		@RequestParam(name = "sri") String sri
	){
		return dashboardRepository.getRouteVolumeByMilepost(sri);
		

	}

	@RequestMapping(value = "routeCrashesByMilepost")
	@ResponseBody
	public HashMap<String, List<Object[]>> getCrashesMP(
		@RequestParam(name = "sri") String sri
	) {
		HashMap<String, List<Object[]>> hm = new HashMap<>();
		List<Object[]> data = dashboardRepository.getRouteCrashesByMilepost(sri);
		for (Object[] data_arr : data) {
			String period = (Integer) data_arr[0] + "";
			Object[] row = new Object[2];
			row[0] = data_arr[1];
			row[1] = data_arr[2];
			double decimalVal = ((BigDecimal) data_arr[2]).doubleValue();
			if (decimalVal == 0.0) continue;
			if(hm.containsKey(period)) {
				hm.get(period).add(row);
			} else {
				ArrayList<Object[]> t = new ArrayList<>();
				t.add(row);
				hm.put(period, t);
			}
		}		
		return hm;

		
		
	}

	@RequestMapping(value = "routeCrashesCategoriesByMilepost")
	@ResponseBody
	public List<Object[]> getDetailCrashesMP(
		@RequestParam(name = "sri") String sri, 
		@RequestParam(name = "year") String year
	) {
		return dashboardRepository.getRouteCrashesCategoriesByMilepost(sri, year);
	}

	@RequestMapping(value = "/routeLargeTruckSeverityByMilepost")
	@ResponseBody
	public List<Object[]> getRouteLargeTruckSeverityByMilepost(
		@RequestParam(name = "sri") String sri, 
		@RequestParam(name = "year") String year
	) {
		return dashboardRepository.getRouteLargeTruckSeverityByMilepost(sri, year);
	}
	/**
	 * Displays the Dashboard Page
	 * @param request The request sent to the server
	 * @return The model and View that must be delivered
	 */
	@RequestMapping(value = "dashboard")
	public String getDashboardPage(HttpServletRequest request)
	{
		return "dashboard";
	}

	@RequestMapping(value = "dashboardLanding")
	public String getDashboardLandingPage(HttpServletRequest request)
	{
		return "dashboard_landing";
	}

	@RequestMapping(value = "state_tttri")
	@ResponseBody
	public List<Object[]> getStateTTTRI() {
		return dashboardRepository.getStateTTTRI();
	}

	@RequestMapping(value = "state_miles_uncongested")
	@ResponseBody
	public List<Object[]> getStateMilesUncongested() {
		return dashboardRepository.getStateMilesUncongested();
	}

	@RequestMapping(value = "state_perc_total_crashes")
	@ResponseBody
	public List<Object[]> getStatePercTotalCrashes() {
		return dashboardRepository.getStatePercTotalCrashes();
	}

	@RequestMapping(value = "route_tttri")
	@ResponseBody
	public List<Object[]> getRouteTTTRI(
		@RequestParam(name="direction") String direction,
		@RequestParam(name="road") String road
	) {
		return dashboardRepository.getRouteTTTRI(road, direction);
	}
	@RequestMapping(value = "route_miles_uncongested")
	@ResponseBody
	public List<Object[]> getRouteMilesUncongested(
		@RequestParam(name="direction") String direction,
		@RequestParam(name="road") String road
	)	 {
		return dashboardRepository.getRouteMilesUncongested(road, direction);
	}

	@RequestMapping(value = "route_perc_total_crashes")
	@ResponseBody
	public List<Object[]> getRoutePercTotalCrashes(
		@RequestParam(name = "sri") String sri
	) {
		return dashboardRepository.getRoutePercTotalCrashes(sri);
	}

	
	@RequestMapping(value = "dashboard/chart_data")
	@ResponseBody
	public ObjectNode getChartData(
		@RequestParam(name = "chartSource", required = true) String chartSource,
		@RequestParam(name = "intersection", required = false) String intersection,
		@RequestParam(name = "direction", required = false) String direction, 
		@RequestParam(name = "year", required = false) String year
	) {
		ObjectNode chartNode = mapper.createObjectNode();
		chartNode.putObject("exporting").put("enabled", false);
		ObjectNode chartChartNode = chartNode.putObject("chart");
		chartChartNode.put("styledMode", true);
		
		List<Double> data;
		List<Object[]> dataa;
		//Build series data
		if (chartSource.equalsIgnoreCase("TTTRI_Summary")) {
			ArrayNode seriesListArrayNode = chartNode.putArray("series");
			ObjectNode seriesObject = seriesListArrayNode.addObject();
			seriesObject.put("name", "TTTRI");
			ArrayNode seriesArrayObject = seriesObject.putArray("data");
			data = fmsStipRepository.getTTRIBarData();
			for (Double d : data) seriesArrayObject.add(d);
			//column
			chartChartNode.put("type", "column").putObject("options3d").put("enabled", true).put("alpha", 0).put("beta", 0).put("depth", 50).put("viewDistance", 25);
			//x-axis
			chartNode.putObject("xAxis").putArray("categories").add("2014").add("2015").add("2016");
			//y-axis
			chartNode.putObject("yAxis").putObject("title").put("text", "TTTRI");
			//Set title
			chartNode.putObject("title").put("text", "Truck Travel Time Reliability Index"); 
			chartNode.putObject("plotOptions").putObject("series").put("depth", 25).putObject("dataLabels").put("enabled", true);
			//((ObjectNode) chartNode.get("plotOptions")).putObject("column");
		}
		else if (chartSource.equalsIgnoreCase("MilesUncongested_Summary")) {
			ArrayNode seriesListArrayNode = chartNode.putArray("series");
			ObjectNode seriesObject = seriesListArrayNode.addObject();
			seriesObject.put("name", "Miles Uncongested");
			ArrayNode seriesArrayObject= seriesObject.putArray("data");
			data = fmsStipRepository.getMilesUnconBarData();
			for (Double d : data) seriesArrayObject.add(d);
			//column
			chartChartNode.put("type", "column");
			//x-axis
			chartNode.putObject("xAxis").putArray("categories").add("2014").add("2015").add("2016");
			//y-axis
			chartNode.putObject("yAxis").putObject("title").put("text", "TTTRI");
			//Set title
			chartNode.putObject("title").put("text", "Miles Uncongested"); 
			chartNode.putObject("plotOptions").putObject("series").putObject("dataLabels").put("enabled", true);
		}
		else if (chartSource.equalsIgnoreCase("PercTotalCrashesSummary")) {
			//data
			dataa = fmsStipRepository.getPercCrashRateBarData();
			ArrayNode seriesListArrayNode = chartNode.putArray("series");
			ObjectNode seriesAObject = seriesListArrayNode.addObject();
			seriesAObject.put("name", "Large Truck");
			ArrayNode seriesAArrayObject= seriesAObject.putArray("data");
			ObjectNode seriesBObject = seriesListArrayNode.addObject();
			seriesBObject.put("name", "Other Truck");
			ArrayNode seriesBArrayObject= seriesBObject.putArray("data");
			for (Object[] d : dataa) {
				seriesAArrayObject.add((Double) d[0]);
				seriesBArrayObject.add((Double) d[1]);
			}

			//column
			chartChartNode.put("type", "column");
			//x-axis
			chartNode.putObject("xAxis").putArray("categories").add("2014").add("2015").add("2016");
			//y-axis
			chartNode.putObject("yAxis").putObject("title").put("text", "TTTRI");
			//Set title
			chartNode.putObject("title").put("text", "% of Total Crashes"); 
			chartNode.putObject("plotOptions").putObject("series").putObject("dataLabels").put("enabled", true);
		}
		else if (chartSource.equalsIgnoreCase("TTTRI_IDY")) {
			//data
			List<Object[]> dataLine = dashboardRepository.getTTRIBarDataByIDY(intersection, direction, year);
			HashMap<String, ArrayList<ArrayNode>> datasorter = new HashMap<>();
			for (Object[] sa : dataLine) {
				ArrayList<ArrayNode> tmp = datasorter.get(sa[0]);
				if (tmp == null) {
					tmp = new ArrayList<>();						
				}
				tmp.add(mapper.createArrayNode().add((Double) sa[3]).add((Double)sa[2]));
				datasorter.put((String) sa[0], tmp);
			}
			ArrayNode seriesListArrayNode = chartNode.putArray("series");
			for (String s : datasorter.keySet()) {
				ObjectNode o = seriesListArrayNode.addObject();
				o.put("name", s);
				ArrayNode a = o.putArray("data");
				ArrayList<ArrayNode> t = datasorter.get(s);
				for (ArrayNode an : t) {
					a.add(an);
				}
			}

			List<Object[]> maxLine = dashboardRepository.getMaxTTRIBarDataByIDY(intersection, direction, year);
			ObjectNode o = seriesListArrayNode.addObject();
			o.put("name", "Max TTTR");
			ArrayNode a = o.putArray("data");
			for (Object[] dd : maxLine) {
				a.addArray().add((Double)dd[2]).add((Double)dd[1]);
			}
			
			//y-axis
			chartNode.putObject("yAxis").putObject("title").put("text", "TTTR");
			chartNode.putObject("tooltip").put("shared", true).put("pointFormat", "{series.name}: <b>{point.y:.3f}<br/>");
			//Set title
			chartNode.putObject("title").put("text", "Truck Travel Time Reliability (TTTR)"); 
		}
		else if (chartSource.equalsIgnoreCase("milesUncon_IDY")) {
			List<Double> dataBar = dashboardRepository.getMilesUnconDataByIDY(intersection, year);
			ArrayNode seriesListArrayNode = chartNode.putArray("series");
			ObjectNode seriesAObject = seriesListArrayNode.addObject();
			seriesAObject.put("name", "Miles Uncongested");
			ArrayNode seriesAArrayObject= seriesAObject.putArray("data");
			if (dataBar.size()>0) {
				seriesAArrayObject.add(dataBar.get(0));
			}
			//column
			chartChartNode.put("type", "column");
			//x-axis
			chartNode.putObject("xAxis").putArray("categories").add("Miles Uncongested");
			//y-axis
			chartNode.putObject("yAxis").putObject("title").put("text", "% of Miles Uncongested");
			//Set title
			chartNode.putObject("title").put("text", "% of Miles Uncongested"); 
			chartNode.putObject("plotOptions").putObject("series").putObject("dataLabels").put("enabled", true);
		}
		else if (chartSource.equalsIgnoreCase("percTotCrashesAndTrucks_IDY")) {
			
			List<Object[]> dataBar = dashboardRepository.getCrashPercDataByIDY(intersection, direction, year);
			List<Object[]> dataBar2 = dashboardRepository.getTruckVolumePerc(intersection, direction);
			/* ArrayNode seriesListArrayNode = chartNode.putArray("series"); */
			/* ObjectNode seriesAObject = seriesListArrayNode.addObject();
			seriesAObject.put("name", "Miles Uncongested"); */
			/* ArrayNode seriesAArrayObject= seriesAObject.putArray("data");
			if (dataBar.size()>0) {
				seriesAArrayObject.add(dataBar.get(0));
			} */
			//column
			chartChartNode.put("type", "column");
			//x-axis
			chartNode.putObject("xAxis").putArray("categories").add("Crash %").add("").add("Truck Volume %");
			//y-axis
			ObjectNode yAxis1 = chartNode.objectNode();
			yAxis1.putObject("title").put("text", "% of Total Crashes");
			ObjectNode yAxis2 = chartNode.objectNode();
			yAxis2.putObject("title").put("text", "% of Truck Volume");
			yAxis2.put("opposite", true);
			chartNode.set("yAxis", chartNode.arrayNode()
				.add(yAxis1)
				.add(yAxis2)
			);

			ObjectNode series1 = chartNode.objectNode();
			series1.put("Name", "Truck Crashes");
			series1.put("type", "column");
			series1.put("yAxis", 0);
			if (dataBar.size()>0) {
				Double val1 = (Double) dataBar.get(0)[0];
				Double val2 = (Double) dataBar.get(0)[1];
				series1.putArray("data").add(val1).add(val2);
			} else {
				series1.putArray("data");
			}

			ObjectNode series2 = chartNode.objectNode();
			series2.put("Name", "Truck Volume");
			series2.put("type", "column");
			series2.put("yAxis", 1);
			if (dataBar2.size()>0) {
				Double val1 = (Double) dataBar2.get(0)[1];
				series2.putArray("data").add(0).add(0).add(val1);
			} else {
				series2.putArray("data");
			}


			chartNode.set("series", chartNode.arrayNode()
				.add(series1)
				.add(series2)
			);
			/* ObjectNode yAxis2 = mapper.createObjectNode()
				.set("title", mapper.createObjectNode()
					.put("text", "% of Truck Volume")
				);
			chartNode.putArray("yAxis")
				.add(mapper.createObjectNode()
					.set("title", mapper.createObjectNode()
						.put("text", "% of Total Crashes")
					)
				).add(yAxis2);
			 */
			//Set title
			chartNode.putObject("title").put("text", "% of Total Crashes"); 
		}
		return chartNode;
	}
	
	@RequestMapping(value = "dashboard/tttri")
	@ResponseBody
	public List<Double> getTTTRIChartData() {
		return fmsStipRepository.getTTRIBarData();
	}
	
	@RequestMapping(value = "dashboard/perc_crashes")
	@ResponseBody
	public List<Object[]> getPercCrashesData() {
		return fmsStipRepository.getPercCrashRateBarData();
	}

	@RequestMapping(value = "dashboard/milesuncon_idy")
	@ResponseBody
	public List<Double> getMilesUnconIDYData(
		@RequestParam(name = "intersection", required = false) String intersection,
		@RequestParam(name = "year", required = false) String year
	) {
		return dashboardRepository.getMilesUnconDataByIDY(intersection, year);
	}

	@RequestMapping(value = "dashboard/intersections")
	@ResponseBody
	public List<String> getIntersectionsList() {
		List<String> roadNames = dashboardRepository.getRoadList();
		Collections.sort(roadNames, new AlphanumericStringComparator<String>());
		return roadNames;
	}

	
	
	/**
	 * Gets the directions available on this road
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "dashboard/directions")
	@ResponseBody
	public List<Object[]> getDirectionData(@RequestParam(name = "road") String road) {
		return dashboardRepository.getDirectionList(road);
	}

	/**
	 * Gets data for the years dropdown
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "dashboard/year")
	@ResponseBody
	public List<Object> getYearList() {
		return dashboardRepository.getYearList();
	}

	
}
