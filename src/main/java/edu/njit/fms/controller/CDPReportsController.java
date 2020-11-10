package edu.njit.fms.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.transaction.Transactional;

import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;

import org.apache.http.client.ClientProtocolException;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import edu.njit.fms.db.entity.CdpProjects;
import edu.njit.fms.db.entity.CdpProjectsWithScore;
import edu.njit.fms.db.entity.ComputedSegmentScoreManagementData;
import edu.njit.fms.db.entity.DecisionVariableScoreRange;
import edu.njit.fms.db.entity.ScoreCriteria;
import edu.njit.fms.db.entity.ScoreFactor;
import edu.njit.fms.db.entity.ScoreProject;
import edu.njit.fms.db.entity.ScrCdpProject;
import edu.njit.fms.db.entity.UniqueCdpProjectsWithScores;
import edu.njit.fms.db.repository.CdpProjectsRepository;
import edu.njit.fms.db.repository.ComputedSegmentScoreManagementDataRepository;
import edu.njit.fms.db.repository.DecisionVariableScoreRangeRepository;
import edu.njit.fms.db.repository.FmsStipRepository;
import edu.njit.fms.db.repository.ScoreFactorRepository;
import edu.njit.fms.db.repository.ScoreProjectRepository;
import edu.njit.fms.db.repository.ScoreSystemRepository;
import edu.njit.fms.db.repository.ScrCdpProjectRepository;
import edu.njit.fms.utils.CrystalReportUtils;
import edu.njit.fms.utils.ReportUtils;

/**
 * This controller handles CDP Project Related tasks
 */
@Controller
public class CDPReportsController {
    @Autowired
    CdpProjectsRepository cdpProjectsRepository;

    @Autowired
    ScrCdpProjectRepository scrCdpProjectRepository;

    @Autowired
    ScoreProjectRepository scoreProjectRepository;

    @Autowired
    ScoreFactorRepository scoreFactorRepository;

    @Autowired
    ComputedSegmentScoreManagementDataRepository computedSegmentScoreManagementDataRepository;

    @Autowired
    DecisionVariableScoreRangeRepository decisionVariableScoreRangeRepository;

    @Autowired
    FmsStipRepository fmsStipRepository;

    @Autowired
    ScoreSystemRepository scoreSystemRepository;

    @Autowired
    ResourceLoader resourceLoader;

    @Autowired
    Environment env;

    /**
     * Adds a project to the CDP Projects table
     * @param project_name The name of the project
     * @param route The name of the route
     * @param sri The SRI of the route
     * @param mpFrom Start Milepost
     * @param mpTo End Milepost
     * @return The created CDP project and any failure messages
     */
    @RequestMapping("/CDPAddIndividualProject")
    @ResponseBody
    public CdpProjects addIndividualProject(@RequestParam("name") String project_name,
            @RequestParam("route") String route, @RequestParam("sri") String sri,
            @RequestParam("startMP") double mpFrom, @RequestParam("endMP") double mpTo) {
        CdpProjects cdpProj = new CdpProjects();
        cdpProj.setProjectName(project_name);
        cdpProj.setRoute(route);
        cdpProj.setSri(sri);
        cdpProj.setMpStart(mpFrom);
        cdpProj.setMpEnd(mpTo);
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();
        String username = currentPrincipalName;
        cdpProj.setUsername(username);
        cdpProj.setDbnum(username + "_" + sri + "_" + mpFrom + "_" + mpTo);
        if (project_name.trim().equals("")) {
            cdpProj.setFailureMessage("Project Name cannot be empty");
        } else if (sri.trim().equals("")) {
            cdpProj.setFailureMessage("SRI cannot be empty");
        } else if (sri.length() < 10) {
            cdpProj.setFailureMessage("SRI must be at least 10 characters");
        } else {
            int duplicate_count = cdpProjectsRepository.getDuplicateCount(sri, mpFrom, mpTo, username);
            if (duplicate_count > 0) {
                cdpProj.setFailureMessage("A project with this SRI and Milepost already exists");
            } else {
                try {
                    cdpProj = cdpProjectsRepository.save(cdpProj);
                } catch (Exception e) {
                    e.printStackTrace();
                    cdpProj.setFailureMessage(e.getMessage());
                }
            }
        }
        return cdpProj;
    }

    /**
     * Adds projects from an Excel file to the CDP Projects table
     * @param file The uploaded file
     * @return A map containing the list of successfull and failed uploads
     * @throws IOException
     * @throws InvalidFormatException
     */
    @PostMapping("/CDPFileUpload")
    @ResponseBody
    public HashMap<String, ArrayList<CdpProjects>> handleFileUpload(@RequestParam("file") MultipartFile file)
            throws IOException, InvalidFormatException {

        File excelFile = File.createTempFile("uploaded_file", "xlsx");

        FileOutputStream fos = new FileOutputStream(excelFile);
        fos.write(file.getBytes());
        fos.close();

        ArrayList<CdpProjects> successProjects = new ArrayList<>();
        ArrayList<CdpProjects> failedProjects = new ArrayList<>();

        HashMap<String, ArrayList<CdpProjects>> toret = new HashMap<>();
        toret.put("success", successProjects);
        toret.put("failed", failedProjects);
//county roads
        Workbook wb = new XSSFWorkbook(excelFile);
        Sheet s = wb.getSheetAt(0);
        int rowCount = s.getLastRowNum();
        for (int i = 1; i <= rowCount; i++) {
            Row r = s.getRow(i);
            String projectName = getNumericOrStringCellValue(r.getCell(0)).trim();
            String sri = getNumericOrStringCellValue(r.getCell(1)).trim();
            String mpStartStr = getNumericOrStringCellValue(r.getCell(2));
            double mpStart = 0;
            String mpEndStr = getNumericOrStringCellValue(r.getCell(3));
            double mpEnd = 0;
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String currentPrincipalName = authentication.getName();
            String username = currentPrincipalName;
            CdpProjects proj = new CdpProjects();
            proj.setProjectName(projectName);
            proj.setSri(sri);
            //sri number validation before querying the database
            if (projectName.equals("")) {
                proj.setFailureMessage("Project Name cannot be empty");
                failedProjects.add(proj);
            } if (sri.equals("")) {
                proj.setFailureMessage("SRI cannot be empty");
                failedProjects.add(proj);
            } if (sri.length() < 10) {
                proj.setFailureMessage("SRI must be at least 10 characters");
                failedProjects.add(proj);
            } else if (isCountyOrLocalRoad(sri)) {
                proj.setFailureMessage("County and Local roads cannot be imported");
                failedProjects.add(proj);
            } else {
                proj.setUsername(username);
                
                String[] routeAndDBNUM = fmsStipRepository.getRouteBySRI(sri).split(","); //this returns 1 string o/p as 'Route,SRI'.Split function is used to seperate route
                String route = null;
                if (routeAndDBNUM != null) route = routeAndDBNUM[0];
                proj.setRoute(route);
                if (route == null) {
                    proj.setFailureMessage("SRI could not be found");
                    failedProjects.add(proj);
                } else if (!isDouble(mpStartStr)) {
                    proj.setFailureMessage("Unable to read Start MP");
                    failedProjects.add(proj);
                } else if (!isDouble(mpEndStr)) {
                    proj.setFailureMessage("Unable to read end MP");
                    failedProjects.add(proj);
                } else {
                    mpStart = Double.parseDouble(mpStartStr);
                    mpStart = round(mpStart, 2);
                    mpEnd = Double.parseDouble(mpEndStr);
                    mpEnd = round(mpEnd, 2);
                    proj.setMpStart(mpStart);
                    proj.setMpEnd(mpEnd);
                    String dbnum = username + "_" + sri + "_" + mpStart + "_" + mpEnd;
                    proj.setDbnum(dbnum);
                    int duplicate_count = cdpProjectsRepository.getDuplicateCount(sri, mpStart, mpEnd, username);
                    if (duplicate_count > 0) {
                        proj.setFailureMessage("A project with this SRI and Milepost already exists");
                        failedProjects.add(proj);
                    } else if (mpStart < 0) {
                        proj.setFailureMessage("Start MP cannot be 0");
                        failedProjects.add(proj);
                    } else if (mpEnd < 0) {
                        proj.setFailureMessage("End MP cannot be 0");
                        failedProjects.add(proj);
                    } else if (mpEnd < mpStart) {
                        proj.setFailureMessage("End MP cannot be less than start Milepost");
                        failedProjects.add(proj);
                    } else {
                        try {
                            successProjects.add(cdpProjectsRepository.save(proj));
                        } catch (Exception e) {
                            e.printStackTrace();
                            proj.setFailureMessage(e.getMessage());
                            failedProjects.add(proj);
                        }
                    }
                }
            }
        }

        wb.close();
        return toret;
    }

    private boolean isCountyOrLocalRoad(String sri) {
        //convert the SRI into a number
        int sriNbr = Integer.parseInt(sri.substring(0, 8));
        if (sriNbr >= 500 && sriNbr <= 699) { //SRI between 500 and 699 are county/local, except for 676
            if (sriNbr == 676) return false; //this is an interstate
            else return true;
        } else if (sriNbr >= 701) { //SRI above 701 are local
            return true;
        } else { //everything else is not local
            return false;
        }
    }
    private static double round(double value, int places) {
        if (places < 0) throw new IllegalArgumentException();
     
        BigDecimal bd = new BigDecimal(Double.toString(value));
        bd = bd.setScale(places, RoundingMode.HALF_UP);
        return bd.doubleValue();
    }

    boolean isDouble(String str) {
        try {
            Double.parseDouble(str);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    @RequestMapping("/CDPGetProjects")
    @ResponseBody
    public List<UniqueCdpProjectsWithScores> getProjectsList(@RequestParam(value = "system_id") int systemID) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        List<String> usernameList = new ArrayList<>();
        if (username.equals("Administrator")) usernameList = scoreSystemRepository.listScoringUsers();
        else usernameList.add(username);
        usernameList.remove(null);
        return cdpProjectsRepository.getProjectsWithScores(systemID, usernameList);
    }

    @RequestMapping("/CDPGetProjectsByDBNUM")
    @ResponseBody
    public List<CdpProjectsWithScore> getProjectsListByDBNUM(@RequestParam(value = "dbnum") String dbnum) {
        return cdpProjectsRepository.getProjectsWithScoresByDBNUM(dbnum);
    }

     @RequestMapping(value = "/Delete_CDPProject", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, String> deleteCDPProject(@RequestParam("ID") Long ID) {
        System.out.println("Deleting "+ID);
        String dbnum = cdpProjectsRepository.findOne(ID).getDbnum();
        
        scoreProjectRepository.deleteScoreProjects(dbnum);

        scrCdpProjectRepository.deleteByDBNUM(dbnum);
        //Long[] IDs = scrCdpProjectRepository.getIdByDBNUM(dbnum);
        /* if(IDs.length > 0){
            for(Long id : IDs){
                scrCdpProjectRepository.delete(id);
            }    
        } */

        cdpProjectsRepository.delete(ID);
        System.out.println("Deleted");
		HashMap<String, String> hm = new HashMap<>();
		hm.put("status", "OK");
		return hm;
    } 

    // Delete multiple projects
    @RequestMapping(value = "/Delete_CDPProjects", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, String> deleteCDPProjects(@RequestParam("dbnums") List<String> dbnums_list) {
       
        List<CdpProjects> cdpProjects = cdpProjectsRepository.getProjectsByDBNUMList(dbnums_list);
        for(CdpProjects cdpProject:cdpProjects){
            Long[] IDs = scrCdpProjectRepository.getIdByDBNUM(cdpProject.getDbnum());
            System.out.println(" id for scrproject :"+IDs);
            scoreProjectRepository.deleteScoreProjects(cdpProject.getDbnum());
            for(String dbnum : dbnums_list){
                System.out.println("Time for dbnum :"+dbnum);
                scrCdpProjectRepository.deleteByDBNUM(dbnum);;
            }
            cdpProjectsRepository.delete(cdpProject.getId());
        }
        System.out.println("*******Deleted multiple selected project successfully!*****************");
		HashMap<String, String> hm = new HashMap<>();
		hm.put("status", "OK");
		return hm;
    
    }

    @RequestMapping(value = "/Update_CDPProject", method = RequestMethod.GET)
	@ResponseBody
	public HashMap<String, String> updateCDPProject(@RequestParam("ID") Long ID, @RequestParam("project") String project,
    @RequestParam("sri") String sri, @RequestParam("mpStart") Double mpStart,
    @RequestParam("mpEnd") Double mpEnd, HttpServletRequest request) {
        CdpProjects cdp_project = cdpProjectsRepository.findOne(ID);
        cdp_project.setId(ID);
        cdp_project.setProjectName(project);
        cdp_project.setMpStart(mpStart);
        cdp_project.setMpEnd(mpEnd);
        cdp_project.setSri(sri);
        cdpProjectsRepository.save(cdp_project);

        //Delete score before update or edit from SCR_CDP_PROJECT and scrproject
        scoreProjectRepository.deleteScoreProjects(cdp_project.getDbnum());
        Long[] IDs = scrCdpProjectRepository.getIdByDBNUM(cdp_project.getDbnum());
            scoreProjectRepository.deleteScoreProjects(cdp_project.getDbnum());
            if(IDs.length > 0){
                for(Long id : IDs){
                    scrCdpProjectRepository.delete(id);
                }    
            }

		HashMap<String, String> hm = new HashMap<>();
		hm.put("status", "OK");
		return hm;
    }

    @RequestMapping(value = "/sri_present", method = RequestMethod.GET)
	@ResponseBody
    public HashMap<String, String> isSRIPresent(@RequestParam("sri") String sri, HttpServletRequest request) {
        String[] routeAndDBNUM = fmsStipRepository.getRouteBySRI(sri).split(","); //this returns 1 string o/p as 'Route,SRI'.Split function is used to seperate route
        String route = routeAndDBNUM[0];
        HashMap<String, String> hm = new HashMap<>();
        if(null == route){
            hm.put("status", "NOT FOUND");
            return hm;
        }else{
            hm.put("status", "FOUND");
            return hm;
        }
    }

    @RequestMapping("/CDPScoreProjects")
    @ResponseBody
    public String[] scoreProjects(@RequestParam(value = "system_id") int scoreSystemID,
            @RequestParam(value = "dbnum") List<String> dbnums) {
        // STEP 1: Get data for factors in the selected score system
        List<ScoreFactor> scoreFactors = scoreFactorRepository.findWeightedBySystemID(scoreSystemID);
        // STEP 2: Get Decision Variable Score Ranges
        Iterable<DecisionVariableScoreRange> scoreRanges = decisionVariableScoreRangeRepository.findAll();
        // STEP 2B: Create a HashMap tyo make it easier to process DVSR Data
        HashMap<String, List<DecisionVariableScoreRange>> scoreRangesMap = createScoreRangesMap(scoreRanges);

        // STEP 3: Get list of projects that need to be scored
        List<CdpProjects> projectsForScoring = cdpProjectsRepository.getProjectsByDBNUMList(dbnums);
        // STEP 3B: Get DBNUM list
        List<String> projectDBNUMsForScoring = new ArrayList<String>();
        for (int i = 0; i < projectsForScoring.size(); i++) {
            projectDBNUMsForScoring.add(projectsForScoring.get(i).getDbnum());
        }

        // STEP 4: Generate score project records - This is a prerequisite to generate
        // data for SCR_CDP_PROJECT
        // STEP 4A: For every project that needs to be scored ...
        for (CdpProjects cdpProject : projectsForScoring) {
            List<ScoreProject> projectDataList = new ArrayList<>();
            // STEP 4B: ... and every factor in this score system ...
            for (ScoreFactor scoreFactor : scoreFactors) {
                ScoreProject scoreProject = new ScoreProject();
                scoreProject.setYear(2019);
                scoreProject.setDbnum(cdpProject.getDbnum());
                scoreProject.setRevision(0);
                scoreProject.setSystemid(scoreSystemID);

                scoreProject.setCatId(scoreFactor.getCategoryID());
                scoreProject.setFactorId(scoreFactor.getFactorID());
                scoreProject.setScore(0);
                projectDataList.add(scoreProject);
            }
            // STEP 4C: ... create a record in the score project table
            scoreProjectRepository.save(projectDataList);
        }

        // STEP 5: Compute data to be stored in the SCR_CDP_PROJECTS table
        List<ComputedSegmentScoreManagementData> segmentDataList = computedSegmentScoreManagementDataRepository
                .getSegmentScoreManagementDataForDBNUMs(projectDBNUMsForScoring);

        List<ScrCdpProject> scoreRecords = new ArrayList<>(); // Store computed scores to reduce database calls
        for (ComputedSegmentScoreManagementData segmentData : segmentDataList) {
            ScrCdpProject toSave = new ScrCdpProject();
            toSave.setDbnum(segmentData.getDbnum());
            toSave.setMpStartSeg(segmentData.getMpStartSeg());
            toSave.setMpEndSeg(segmentData.getMpEndSeg());
            toSave.setTotalCountLt(segmentData.getTotalCountLt());
            toSave.setCrLt(segmentData.getCrLt());
            toSave.setSeverity(segmentData.getSeverity());
            toSave.setNationalHighwayFreightNetwork(segmentData.getNationalHighwayFreightNetwork());
            toSave.setIntermodal(segmentData.getIntermodal());
            toSave.setNjAccess(segmentData.getNjAccess());
            toSave.setNhs(segmentData.getNhs());
            toSave.setMeanTt(segmentData.getMeanTt());
            toSave.setTt95(segmentData.getTt95());
            toSave.setTttr(segmentData.getTttr());
            toSave.setOverweight(segmentData.getOverweight());
            toSave.setLtPercStip(segmentData.getLtPercStip());
            toSave.setTotalScore(segmentData.getTotalScore());
            toSave.setScrSystemId(scoreSystemID + "");
            toSave.setRoute(segmentData.getRoute());
            toSave.setSri(segmentData.getSri());
            scoreRecords.add(toSave);
        }
        scrCdpProjectRepository.save(scoreRecords);
        List<ScoreProject> projectScoresList = new ArrayList<>();
        for (CdpProjects cdpProject : projectsForScoring) {

            ScoreCriteria scoreCriteria = buildScoreCriteriaMax(
                    scrCdpProjectRepository.getCriteriaMaximums(cdpProject.getDbnum()));

            /* if (scoreCriteria.getNhs() != null)
                if (scoreCriteria.getNhs() > 1)
                    scoreCriteria.setNhs(0.0);
            if (scoreCriteria.getNjAccess() != null)
                if (scoreCriteria.getNjAccess() > 1)
                    scoreCriteria.setNjAccess(0.0);
            if (scoreCriteria.getIntermodal() != null)
                if (scoreCriteria.getIntermodal() > 1)
                    scoreCriteria.setIntermodal(0.0);
            if (scoreCriteria.getNationalHighwayFreightNetwork() != null)
                if (scoreCriteria.getNationalHighwayFreightNetwork() > 1)
                    scoreCriteria.setNationalHighwayFreightNetwork(0.0); */
            for (ScoreFactor scoreFactor : scoreFactors) {
                List<DecisionVariableScoreRange> rangeResults = scoreRangesMap.get(scoreFactor.getFactor_Description());
                double score = 0;
                for (DecisionVariableScoreRange dvsr : rangeResults) {
                    switch (scoreFactor.getFactor_Description()) {
                    case "Large Truck Crash Rate":
                        if (scoreCriteria.getCrLt() == null)
                            break;
                        if (scoreCriteria.getCrLt() > dvsr.getStart_range()
                                && scoreCriteria.getCrLt() <= dvsr.getEnd_range()) {
                                    score = (scoreFactor.getWeight() * dvsr.getScore()) / 100;
                                } 
                        break;
                    case "Large Truck Severity Rate":
                        if (scoreCriteria.getSeverity() == null)
                            break;
                        if (scoreCriteria.getSeverity() > dvsr.getStart_range()
                                && scoreCriteria.getSeverity() <= dvsr.getEnd_range()) {
                                    score = (scoreFactor.getWeight() * dvsr.getScore()) / 100;
                                } 
                        break;
                    case "National Highway Network":
                        if (scoreCriteria.getNhs() == null)
                            break;
                        if (scoreCriteria.getNhs() >= dvsr.getStart_range()
                                && scoreCriteria.getNhs() <= dvsr.getEnd_range()) {
                                    score = (scoreFactor.getWeight() * dvsr.getScore()) / 100;
                                } 
                        break;
                    case "New Jersey Access Network":
                        if (scoreCriteria.getNjAccess() == null)
                            break;
                        if (scoreCriteria.getNjAccess() >= dvsr.getStart_range()
                                && scoreCriteria.getNjAccess() <= dvsr.getEnd_range()) {
                                    score = (scoreFactor.getWeight() * dvsr.getScore()) / 100;
                                } 
                        break;
                    case "Intermodal Connector":
                        if (scoreCriteria.getIntermodal() == null)
                            break;
                        if (scoreCriteria.getIntermodal() >= dvsr.getStart_range()
                                && scoreCriteria.getIntermodal() <= dvsr.getEnd_range()) {
                                    score = (scoreFactor.getWeight() * dvsr.getScore()) / 100;
                                } 
                        break;
                    case "National Highway Freight Network":
                        if (scoreCriteria.getNationalHighwayFreightNetwork() == null)
                            break;
                        if (scoreCriteria.getNationalHighwayFreightNetwork() >= dvsr.getStart_range()
                                && scoreCriteria.getNationalHighwayFreightNetwork() <= dvsr.getEnd_range()) {
                                    score = (scoreFactor.getWeight() * dvsr.getScore()) / 100;
                                } 
                        break;
                    case "Percentage of Large Truck Volume":
                        if (scoreCriteria.getLtPercStip() == null)
                            break;
                        if (scoreCriteria.getLtPercStip() > dvsr.getStart_range()
                                && scoreCriteria.getLtPercStip() <= dvsr.getEnd_range()) {
                                    score = (scoreFactor.getWeight() * dvsr.getScore()) / 100;
                                } 
                        break;
                    case "Truck Travel Time Reliability Index":
                        if (scoreCriteria.getTttr() == null)
                            break;
                        if (scoreCriteria.getTttr() > dvsr.getStart_range()
                                && scoreCriteria.getTttr() <= dvsr.getEnd_range()) {
                                    score = (scoreFactor.getWeight() * dvsr.getScore()) / 100;
                                } 
                        break;
                    case "Overweight Truck Permits":
                        if (scoreCriteria.getOverweight() == null)
                            break;
                        if (scoreCriteria.getOverweight() > dvsr.getStart_range()
                                && scoreCriteria.getOverweight() <= dvsr.getEnd_range()) {
                                    score = (scoreFactor.getWeight() * dvsr.getScore()) / 100;
                                } 
                        break;
                    }
                }
                
                projectScoresList.add(new ScoreProject(2019, cdpProject.getDbnum(), 0, scoreSystemID,
                        scoreFactor.getCategoryID(), scoreFactor.getFactorID(), score));
            }
            
        }
        
        scoreProjectRepository.save(projectScoresList);
        // scrCdpProjectRepository.save(scoreRecords);
        String[] toret = { "OK" };
        return toret;
    }

    public static ScoreCriteria buildScoreCriteriaMax(Double[][] criteriaMaximums) {
        ScoreCriteria sc = new ScoreCriteria();
        sc.setOverweight(criteriaMaximums[0][0]);
        sc.setLtPercStip(criteriaMaximums[0][1]);
        sc.setSeverity(criteriaMaximums[0][2]);
        sc.setNationalHighwayFreightNetwork(criteriaMaximums[0][3]);
        sc.setIntermodal(criteriaMaximums[0][4]);
        sc.setNjAccess(criteriaMaximums[0][5]);
        sc.setNhs(criteriaMaximums[0][6]);
        sc.setTttr(criteriaMaximums[0][7]);
        sc.setCrLt(criteriaMaximums[0][8]);
        return sc;
    }

    public static HashMap<String, List<DecisionVariableScoreRange>> createScoreRangesMap(
            Iterable<DecisionVariableScoreRange> scoreRanges) {
        HashMap<String, List<DecisionVariableScoreRange>> toret = new HashMap<>();
        for (DecisionVariableScoreRange dvsr : scoreRanges) {
            if (toret.containsKey(dvsr.getCategory_name())) {
                toret.get(dvsr.getCategory_name()).add(dvsr);
            } else {
                List<DecisionVariableScoreRange> toAdd = new ArrayList<DecisionVariableScoreRange>();
                toAdd.add(dvsr);
                toret.put(dvsr.getCategory_name(), toAdd);
            }
        }
        return toret;
    }

    public static HashMap<String, Double> convertScoreFactorListToScoreFactorWeightHashMap(List<ScoreFactor> list) {
        HashMap<String, Double> toret = new HashMap<>();
        for (ScoreFactor data : list) {
            String factor_name = data.getFactor_Description().trim();
            double weight = data.getWeight();
            toret.put(factor_name, weight);
        }
        return toret;
    }

    public static String getNumericOrStringCellValue(Cell c) {
        if (c == null)
            return "";
        CellType ct = c.getCellType();
        if (ct == CellType.STRING) {
            return c.getStringCellValue();
        } else {
            return c.getNumericCellValue() + "";
        }
    }

    @RequestMapping(value = "/DownloadCDPReportPDF")
    @Transactional
    public ModelAndView downloadCDPReportPDF(@RequestParam("dbnum") List<String> dbnums,
            @RequestParam("scoresystem") List<String> scoreSystem, 
            HttpServletRequest request, 
            HttpServletResponse response
    ) throws ClientProtocolException, IOException, JSONException, ReportSDKExceptionBase {
        List<CdpProjects> projects = cdpProjectsRepository.getProjectsByDBNUMList(dbnums);
        for (CdpProjects c : projects) {
            c.setImagePath(ReportUtils.generateReportGISImage(c, fmsStipRepository));
        }
        cdpProjectsRepository.save(projects);

        String strDBNUMs = "(" +  dbnums.stream().map(s -> "'" + s + "'").collect(Collectors.joining(", ")) + ")";
        String strSystem = "(" + scoreSystem.stream().map(s -> "'" + s + "'").collect(Collectors.joining(", ")) + ")";
        Resource resource = resourceLoader.getResource("classpath:reports/FMSCDPReport_Multiple.rpt");
        System.out.println(strDBNUMs);
        Fields reportFields = new Fields();
        System.out.println("Generating fields");
        reportFields.add(CrystalReportUtils.createCrystalReportParameterField("", "dbnum", strDBNUMs));
        reportFields.add(CrystalReportUtils.createCrystalReportParameterField("", "system_id", strSystem));
        System.out.println(" #######*********#########   Lenght of reports :"+reportFields.size());
        System.out.println("Generating report");
        /* CrystalReportUtils.generateCrystalReportPDF(resource.getURI().getRawPath(), reportFields, request, response, env); */
        ModelAndView m = new ModelAndView("DisplayCDPReport");
        m.addObject("dbnum", strDBNUMs);
        m.addObject("system_id", strSystem);
        return m;
    }
}