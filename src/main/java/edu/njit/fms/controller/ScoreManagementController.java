package edu.njit.fms.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.ParserConfigurationException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.xml.sax.SAXException;

import edu.njit.fms.db.entity.DecisionVariableScoreRange;
import edu.njit.fms.db.entity.PriorityScoreRange;
import edu.njit.fms.db.repository.DecisionVariableScoreRangeRepository;
import edu.njit.fms.db.repository.PriorityScoreRangeRepository;

@Controller
public class ScoreManagementController {

	@Autowired
	DecisionVariableScoreRangeRepository decisionVariableScoreRangeRepository;

	@Autowired
	PriorityScoreRangeRepository priorityScoreRangeRepository;

	@Autowired
	EntityManager entityManager;

	@RequestMapping(value = "/scoreManagementData")
	@ResponseBody
	public HashMap<String, Object> getScoreManagementData() {
		HashMap<String, Object> resMap = new HashMap<>();
		resMap.put("National Highway Freight Network", decisionVariableScoreRangeRepository.listScoreRatios("National Highway Freight Network"));
		resMap.put("Intermodal Connector", decisionVariableScoreRangeRepository.listScoreRatios("Intermodal Connector"));
		resMap.put("Large Truck Crash Rate", decisionVariableScoreRangeRepository.listScoreRatios("Large Truck Crash Rate"));
		resMap.put("Large Truck Severity Rate", decisionVariableScoreRangeRepository.listScoreRatios("Large Truck Severity Rate"));
		resMap.put("National Highway Network", decisionVariableScoreRangeRepository.listScoreRatios("National Highway Network"));
		resMap.put("New Jersey Access Network", decisionVariableScoreRangeRepository.listScoreRatios("New Jersey Access Network"));
		resMap.put("Overweight Truck Permits", decisionVariableScoreRangeRepository.listScoreRatios("Overweight Truck Permits"));
		resMap.put("Percentage of Large Truck Volume", decisionVariableScoreRangeRepository.listScoreRatios("Percentage of Large Truck Volume"));
		resMap.put("Truck Travel Time Reliability Index", decisionVariableScoreRangeRepository.listScoreRatios("Truck Travel Time Reliability Index"));
		resMap.put("Priority Score Range", priorityScoreRangeRepository.findAll());
		return resMap;
	}

	@RequestMapping(value = "/ScoreManagement", method = RequestMethod.GET)
	public ModelAndView display(HttpServletRequest request)
			throws ClassNotFoundException, ParserConfigurationException, SQLException, SAXException, IOException {
		ModelAndView model = new ModelAndView("scoreManagement");
		List<DecisionVariableScoreRange> nhfn_ratio_objects = decisionVariableScoreRangeRepository
				.listScoreRatios("National Highway Freight Network");
		List<DecisionVariableScoreRange> intermodal_ratio_objects = decisionVariableScoreRangeRepository.listScoreRatios("Intermodal Connector");
		List<DecisionVariableScoreRange> large_truck_crash_rate_ratio_objects = decisionVariableScoreRangeRepository
				.listScoreRatios("Large Truck Crash Rate");
		List<DecisionVariableScoreRange> large_truck_severity_rate_ratio_objects = decisionVariableScoreRangeRepository
				.listScoreRatios("Large Truck Severity Rate");
		List<DecisionVariableScoreRange> national_highway_network_ratio_objects = decisionVariableScoreRangeRepository
				.listScoreRatios("National Highway Network");
		List<DecisionVariableScoreRange> nj_access_ratio_objects = decisionVariableScoreRangeRepository
				.listScoreRatios("New Jersey Access Network");
		List<DecisionVariableScoreRange> overweight_truck_permits_ratio_objects = decisionVariableScoreRangeRepository
				.listScoreRatios("Overweight Truck Permits");
		List<DecisionVariableScoreRange> perc_large_truck_volume_ratio_objects = decisionVariableScoreRangeRepository
				.listScoreRatios("Percentage of Large Truck Volume");
		List<DecisionVariableScoreRange> tttri_ratio_objects = decisionVariableScoreRangeRepository
				.listScoreRatios("Truck Travel Time Reliability Index");
		List<PriorityScoreRange> pscrrange = priorityScoreRangeRepository.findAll();
		// CategoryScore cs;

		model.addObject("nhfn_ratio_objects", nhfn_ratio_objects);
		model.addObject("intermodal_ratio_objects", intermodal_ratio_objects);
		model.addObject("large_truck_crash_rate_ratio_objects", large_truck_crash_rate_ratio_objects);
		model.addObject("large_truck_severity_rate_ratio_objects", large_truck_severity_rate_ratio_objects);
		model.addObject("national_highway_network_ratio_objects", national_highway_network_ratio_objects);
		model.addObject("nj_access_ratio_objects", nj_access_ratio_objects);
		model.addObject("overweight_truck_permits_ratio_objects", overweight_truck_permits_ratio_objects);
		model.addObject("perc_large_truck_volume_ratio_objects", perc_large_truck_volume_ratio_objects);
		model.addObject("tttri_ratio_objects", tttri_ratio_objects);
		model.addObject("pscrrange", pscrrange);
		model.addObject("passed_mode", "'National_Highway_Freight_Network'");
		System.out.println("Building new controller");
		return model;

	}

	@RequestMapping(value = "/Add_Range", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, String> add_range(@RequestParam("mode") String mode,
			@RequestParam("start_range") Double start_range,
			@RequestParam("end_range") Double end_range, @RequestParam("perc_weight") double perc_weight) {

		DecisionVariableScoreRange newRecord = new DecisionVariableScoreRange();
		newRecord.setCategory_name(mode);
		newRecord.setStart_range(start_range);
		newRecord.setEnd_range(end_range);
		newRecord.setScore(perc_weight);

		DecisionVariableScoreRange saved_score = decisionVariableScoreRangeRepository.save(newRecord);
		HashMap<String, String> hm = new HashMap<>();
		hm.put("status", "OK");
		hm.put("saved_score_id",saved_score.getId().toString());
		return hm;

	}

	@RequestMapping(value = "/Delete_Range", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, String> delete_range(@RequestParam("ID") Long ID) {
		decisionVariableScoreRangeRepository.delete(ID);
		HashMap<String, String> hm = new HashMap<>();
		hm.put("status", "OK");
		return hm;
	}

	@RequestMapping(value = "/Update_Range", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, String> update_range(@RequestParam("ID") Long ID, @RequestParam("start_range") Double start_range,
			@RequestParam("end_range") Double end_range, @RequestParam("perc_weight") double perc_weight,
			@RequestParam("mode") String mode, HttpServletRequest request) {
		DecisionVariableScoreRange updateRecord = new DecisionVariableScoreRange();
		updateRecord.setId(ID);
		updateRecord.setStart_range(start_range);
		updateRecord.setEnd_range(end_range);
		updateRecord.setScore(perc_weight);
		updateRecord.setCategory_name(mode);

		decisionVariableScoreRangeRepository.save(updateRecord);

		HashMap<String, String> hm = new HashMap<>();
		hm.put("status", "OK");
		return hm;
	}

	@RequestMapping(value = "/Update_Score_Range", method = RequestMethod.GET)
	public String update_score_range(@RequestParam("acpt_from") String acpt_from,
			@RequestParam("acpt_to") String acpt_to, @RequestParam("low_from") String low_from,
			@RequestParam("low_to") String low_to, @RequestParam("medium_from") String medium_from,
			@RequestParam("medium_to") String medium_to, @RequestParam("high_from") String high_from,
			@RequestParam("high_to") String high_to, @RequestParam("mode") String mode, HttpServletRequest request)
			throws ClassNotFoundException, ParserConfigurationException, SQLException, SAXException, IOException {
		String Priority_Score_Range_Update_Query = "update priorityscrrange set Low_Range_From = " + low_from
				+ ", Low_Range_To = " + low_to + ", Medium_Range_From = " + medium_from + ", Medium_Range_To = "
				+ medium_to + ", High_Range_From = " + high_from + ", High_Range_To = " + high_to
				+ ", Acceptable_Range_From =" + acpt_from + ", Acceptable_Range_To=" + acpt_to;
			entityManager.createQuery(Priority_Score_Range_Update_Query).executeUpdate();
		

		return "redirect:/ScoreManagement";

	}

	@RequestMapping(value = "/Update_Individual_Priority_Score_Range", method = RequestMethod.GET)
	public String update_individual_priority_score_range(@RequestParam("from") String from,
			@RequestParam("to") String to, @RequestParam("priority") String priority, @RequestParam("mode") String mode,
			HttpServletRequest request)
			throws ClassNotFoundException, ParserConfigurationException, SQLException, SAXException, IOException {

		String Priority_Score_Range_Update_Query = "update priorityscrrange set " + priority + "_Range_From = " + from
				+ ", " + priority + "_Range_To = " + to;
			entityManager.createQuery(Priority_Score_Range_Update_Query).executeUpdate();
			

		return "redurect:/ScoreManagement";

	}

}
