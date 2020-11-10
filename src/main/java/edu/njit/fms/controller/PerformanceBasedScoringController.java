package edu.njit.fms.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.ParserConfigurationException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.xml.sax.SAXException;

import edu.njit.fms.db.entity.ScoreCategory;
import edu.njit.fms.db.entity.ScoreFactor;
import edu.njit.fms.db.entity.ScoreSystem;
import edu.njit.fms.db.entity.UniqueScoreSystem;
import edu.njit.fms.db.repository.ScoreCategoryRepository;
import edu.njit.fms.db.repository.ScoreFactorRepository;
import edu.njit.fms.db.repository.ScoreSystemRepository;
import edu.njit.fms.db.repository.UniqueScoreSystemRepository;

@Controller
public class PerformanceBasedScoringController {

	@Autowired
	UniqueScoreSystemRepository uniqueScoreSystemRepository;

	@Autowired
	ScoreSystemRepository scoreSystemRepository;

	@Autowired
	ScoreCategoryRepository scoreCategoryRepository;

	@Autowired
	ScoreFactorRepository scoreFactorRepository;

	@RequestMapping(value = "/performanceBasedScoring")
	public String displayIndexWithoutSlash() {
		return "redirect:/performanceBasedScoring/";
	}

	@RequestMapping(value = "/performanceBasedScoring/data")
	@ResponseBody
	public HashMap<String, Object> getJSON() {

		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String currentPrincipalName = authentication.getName();
		List<ScoreSystem> allSystems = scoreSystemRepository.listAllSystems();
		List<ScoreSystem> allDefaultSystems = scoreSystemRepository.listAllDefaultSystems();
		List<String> scoringUsers = scoreSystemRepository.listScoringUsers();
		HashMap<String, Object> hm = new HashMap<String, Object>();
		hm.put("all", allSystems);
		hm.put("default", allDefaultSystems);
		hm.put("loggedInUser", currentPrincipalName);
		hm.put("scoringUsers", scoringUsers);
		return hm;
	}

	@RequestMapping(value = "/performanceBasedScoring/")
	public String displayIndex() {
		return "performanceBasedScoring/index";
	}

	@RequestMapping(value = "/performanceBasedScoring/view")
	public String displayView(@RequestParam("SystemID") int sysID) {
		return "performanceBasedScoring/view";
	}

	@RequestMapping(value = "/performanceBasedScoring/details")
	@ResponseBody
	public HashMap<String, Object> getDetailsJSON(@RequestParam("id") int sysID) {
		List<UniqueScoreSystem> selectedUniqueScoreSystem = uniqueScoreSystemRepository.getUniqueScoreSystemByID(sysID);
		List<ScoreCategory> scoreCategories = scoreCategoryRepository.findBySystemIDOrderByCatID(sysID);
		for (ScoreCategory sc : scoreCategories) {
			System.out.println("==============================================================" + sc.getCatID());
			System.out.println(sc);
			List<ScoreFactor> scoreF = new ArrayList<ScoreFactor>();
			scoreF = scoreFactorRepository.findBySystemIDAndCategoryID(sysID, sc.getCatID());
			System.out.println(scoreF);
			sc.setScoreFactors(scoreF);
		}
		HashMap<String, Object> data = new HashMap<>();
		data.put("categories", scoreCategories);
		data.put("scoreSystem", selectedUniqueScoreSystem);

		return data;
	}

	@RequestMapping(value = "/performanceBasedScoring/edit", method = RequestMethod.GET)
	public String displayEdit(@RequestParam("SystemID") int sysID, Model model) {
		List<UniqueScoreSystem> selectedUniqueScoreSystem = uniqueScoreSystemRepository.getUniqueScoreSystemByID(sysID);
		List<ScoreCategory> scoreCategories = scoreCategoryRepository.findBySystemIDOrderByCatID(sysID);
		for (ScoreCategory sc : scoreCategories) {
			sc.setScoreFactors(scoreFactorRepository.findBySystemIDAndCategoryID(sysID, sc.getCatID()));
		}
		model.addAttribute("Categories", scoreCategories);
		model.addAttribute("UniqueScoreSystem", selectedUniqueScoreSystem);
		return "performanceBasedScoring/edit";
	}

	@RequestMapping(value = "/performanceBasedScoring/updatetest", method = RequestMethod.POST)
	@ResponseBody
	public String updateScoreSystem1(@RequestBody String payload) throws JSONException {
		System.out.println(payload);
		JSONObject payloadObject = new JSONObject(payload);
		ScoreSystem scoreSystem = new ScoreSystem();
		scoreSystem.setSystemID(Integer.parseInt(payloadObject.getString("id")));
		scoreSystem.setSystemName(payloadObject.getString("name"));
		scoreSystem.setDescription(payloadObject.getString("description"));
		scoreSystem.setIsActive(1);
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String currentPrincipalName = authentication.getName();
		scoreSystem.setLoginID(currentPrincipalName);
		scoreSystemRepository.save(scoreSystem); 
		JSONArray categories = payloadObject.getJSONArray("categories");
		for (int i=0; i < categories.length(); i++) {
			JSONObject category = categories.getJSONObject(i);
			scoreCategoryRepository.updateScoreCategory(Float.parseFloat(category.getString("weight")), (i+1), Integer.parseInt(payloadObject.getString("id")));
			JSONArray factors = category.getJSONArray("factors");
			for (int j = 0; j < factors.length(); j++) {
				JSONObject factor = factors.getJSONObject(j);
				scoreFactorRepository.updateScoreFactor(Float.parseFloat(factor.getString("weight")), (i+1), Integer.parseInt(payloadObject.getString("id")), (j+1));
			}
		}
		return "OK";
	}

	@RequestMapping(value = "/performanceBasedScoring/update",method = RequestMethod.POST)
	//public void updateScoreSystem(@ModelAttribute("tempScoreSystem")ArrayList<Category> categoryList)
	public String updateScoreSystem(
		@RequestParam("Weight")String categoryWeight,
		@RequestParam("ScoreSystemName")String scrName,
		@RequestParam("ScoreSystemDescription")String scrDescript,
		@RequestParam("CriteriaWeight")String criteriaWeight,
		@RequestParam("SystemID")int sysID,
		@RequestParam("CriteriaSize")String critera_size,
		@RequestParam("LoginID")String loginID, 
		Model model
	) 
		throws ClassNotFoundException, ParserConfigurationException, SQLException, SAXException, IOException
	{
		ScoreSystem scoreSystem = new ScoreSystem();
		scoreSystem.setSystemID(sysID);
		scoreSystem.setSystemName(scrName);
		scoreSystem.setDescription(scrDescript);
		scoreSystem.setLoginID(loginID);
		scoreSystemRepository.save(scoreSystem);

		String [] CategoryWeights = extractvalues(categoryWeight);
		String [] CriteriaWeights = extractvalues(criteriaWeight);
		String [] CriteriaSize = extractvalues(critera_size);
		for(int i=0;i<CategoryWeights.length;i++) {
			scoreCategoryRepository.updateScoreCategory(Float.parseFloat(CategoryWeights[i]), (i+1), sysID);
		}
		int criteria_count=0;
		for(int i=0;i<CategoryWeights.length;i++)
		{
			for(int j=0;j<Integer.parseInt(CriteriaSize[i]);j++)
			{
				scoreFactorRepository.updateScoreFactor(Float.parseFloat(CriteriaWeights[criteria_count]), (i+1), sysID, (j+1));
				criteria_count++;
			}
		}

		return "redirect:/performanceBasedScoring/edit?SystemID=" + sysID;
	}

	@RequestMapping(value = "/performanceBasedScoring/delete",method = RequestMethod.GET)
	public String deleteScoreSystem(@RequestParam("SystemID")int sysID,HttpServletRequest request) throws ClassNotFoundException, ParserConfigurationException, SQLException, SAXException, IOException
	{
		scoreSystemRepository.deleteScoreSystem(sysID);
		scoreCategoryRepository.deleteScoreCategory(sysID);
		scoreFactorRepository.deleteScoreFactor(sysID);
		
		
		return "redirect:/performanceBasedScoring/";
	}
	
	@RequestMapping(value = "/performanceBasedScoring/AddExisting",method = RequestMethod.GET)
	public String copyScoreSystem(
		@RequestParam("SystemID")int sysID,
		HttpServletRequest request
	) {
		int newScoreSystemID = scoreSystemRepository.getNewSystemID() + 1;
		List<UniqueScoreSystem> selectedUniqueScoreSystem = uniqueScoreSystemRepository.getUniqueScoreSystemByID(sysID);
		
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		String currentPrincipalName = authentication.getName();
		System.out.println("Score System: " + selectedUniqueScoreSystem.get(0).getSystemName());
		scoreSystemRepository.insertScoreSystem(
			newScoreSystemID, 
			selectedUniqueScoreSystem.get(0).getSystemName() + "-COPY", 
			selectedUniqueScoreSystem.get(0).getDescription(), 
			selectedUniqueScoreSystem.get(0).getType(), 
			selectedUniqueScoreSystem.get(0).getMaxScore(), 
			selectedUniqueScoreSystem.get(0).getAgencyAlias(), 
			currentPrincipalName
		);

		List<ScoreCategory> scoreCategories = scoreCategoryRepository.findBySystemIDOrderByCatID(sysID);
		
		for (ScoreCategory sc : scoreCategories) {
			System.out.println("Score Category: " + sc.getCatID() + " - " + sc.getCat_Name());
			scoreCategoryRepository.insertScoreCategory(newScoreSystemID, sc.getCatID(), sc.getCat_Name(), sc.getCat_Description(), sc.getWeight(), sc.getDispPosition(), sc.getDispText(), sc.getIsActive());
			List<ScoreFactor> scoreFactors = scoreFactorRepository.findBySystemIDAndCategoryID(sysID, sc.getCatID());
			for (ScoreFactor sf : scoreFactors) {
				System.out.println("Score Factor: " + sf.getFactorID() + " - " +  sf.getFactor_Description());
				scoreFactorRepository.insertScoreFactor(newScoreSystemID, sf.getCategoryID(), sf.getFactorID(), sf.getFactor_Description(), sf.getWeight(), sf.getDispPosition(), sf.getDispText(), sf.getIsActive());
			}
		}
		
		return "redirect:/performanceBasedScoring/edit?SystemID=" + newScoreSystemID;
	}

	@RequestMapping(value = "/performanceBasedScoring/scoringSystems")
	@ResponseBody
	public List<ScoreSystem> apiScoringSystems() {
		
		return scoreSystemRepository.listAllSys();
	}

	public String[] extractvalues(String temp)
	{
		String [] holder = temp.split(",");
		return holder;
	}

}
