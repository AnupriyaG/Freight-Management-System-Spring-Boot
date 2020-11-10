
package edu.njit.fms.controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import edu.njit.fms.db.repository.FmsStipRepository;
import edu.njit.fms.utils.AlphanumericStringComparator;

/**
 * A controller to handle GIS related requests
 * 
 * @author Karthik Sankaran
 *
 */
@Controller
public class GISController {

	
	@Autowired
	FmsStipRepository fmsStipRepository;

	@RequestMapping(value = "/gis")
	public String displayIndexWithoutSlash() {
		return "redirect:/gis/";
	}

	@RequestMapping("/gis/") 
	public String getIndexPage() {
		return "gis";
	}

	//@RequestMapping(value = "gisrequest")
	/* public ModelAndView getDashboardPage(HttpServletRequest request) {
		LogUtils.logRequest(request);
		ModelAndView model = new ModelAndView("gisdata");
		String sri = request.getParameter("sri");
		String mp = request.getParameter("mp");
		String sql = "SELECT * FROM fms_segment WHERE DBNUM2='" + sri + "' AND M_POSTS_FROM='" + mp + "'";
		logger.info("SQL: " + sql);
		Connection con = ConnectionManager.getConnection();
		ResultSet rs;
		try {
			HashMap<String, String> data = new HashMap<String, String>();
			rs = con.createStatement().executeQuery(sql);
			rs.next(); // we only expect one row
			ResultSetMetaData rsmd = rs.getMetaData();
			int colcount = rsmd.getColumnCount();
			for (int i = 1; i <= colcount; i++) {
				String col = rsmd.getColumnLabel(i);
				String val = rs.getString(i);
				data.put(col, val);
			}
			model.addObject("route", data);
			model.addObject("keys", data.keySet().toArray());
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		LogUtils.logModelAndView(model);
		return model;

	}
 */
	
	
	@RequestMapping(value = "featureSearch")
	public ModelAndView getSearchResults(HttpServletRequest request) {
		String field = request.getParameter("field");
		String value = request.getParameter("value");
		String sql;
		if (field == null) {
			//NULL - there is nothing here
		} else if (field.equalsIgnoreCase("route")) {
			sql = "SELECT * FROM ";
		}
		
		ModelAndView modelview = new ModelAndView("gisresults");
		modelview.addObject("field", field);
		modelview.addObject("value", value);
		return modelview;
	}

	@RequestMapping("/filterValues")
	@ResponseBody
	public List<String> getFilterValues(
		@RequestParam(name = "filterName") String filterName,
		@RequestParam(name = "cascadeFilter", required = false) String cascadeFilter
	) {
		switch(filterName) {
			case "DBNUM": 			
				return fmsStipRepository.getDistinctDBNUM();
			case "ProjectName": 	
				return fmsStipRepository.getDistinctProjectNames();
			case "Route": 
				List<String> routeNames = fmsStipRepository.getDistinctRoutes();
				Collections.sort(routeNames, new AlphanumericStringComparator<String>());		
				return routeNames;
			case "County": 			
				return fmsStipRepository.getDistinctCounty();
			case "Municipality": 	
				return fmsStipRepository.getDistinctMunicipality();
			case "MPO": 			
				return fmsStipRepository.getDistinctMPO();
			case "CISCategory": 	
				return fmsStipRepository.getDistinctCISCategory();
			case "CISSubCategory": 	
				return fmsStipRepository.getDistinctCISSubCategory(cascadeFilter);
			default: 
				return new ArrayList<String>();
		}
		
	}
}
