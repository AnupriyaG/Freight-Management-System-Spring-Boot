package edu.njit.fms.controller;

import java.io.IOException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.crystaldecisions.sdk.occa.report.data.Fields;
import com.crystaldecisions.sdk.occa.report.lib.ReportSDKExceptionBase;

import org.apache.http.client.ClientProtocolException;
import org.apache.log4j.Logger;
import org.json.JSONException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import edu.njit.fms.db.entity.ComputedSegmentScoreManagementData;
import edu.njit.fms.db.entity.CustomProject;
import edu.njit.fms.db.entity.DecisionVariableScoreRange;
import edu.njit.fms.db.entity.ScoreCriteria;
import edu.njit.fms.db.entity.ScoreFactor;
import edu.njit.fms.db.entity.ScoreProject;
import edu.njit.fms.db.entity.ScoreSegment;
import edu.njit.fms.db.repository.ComputedSegmentScoreManagementDataRepository;
import edu.njit.fms.db.repository.CustomProjectRepository;
import edu.njit.fms.db.repository.DecisionVariableScoreRangeRepository;
import edu.njit.fms.db.repository.FmsStipRepository;
import edu.njit.fms.db.repository.ScoreFactorRepository;
import edu.njit.fms.db.repository.ScoreProjectRepository;
import edu.njit.fms.db.repository.ScoreSegmentRepository;
import edu.njit.fms.utils.CrystalReportUtils;
import edu.njit.fms.utils.ReportUtils;

@Controller
public class MultipleSegmentCustomReportController {
    private final static Logger logger = Logger.getLogger(MultipleSegmentCustomReportController.class);

    @Autowired
    ScoreFactorRepository scoreFactorRepository;

    @Autowired
    DecisionVariableScoreRangeRepository decisionVariableScoreRangeRepository;

    @Autowired
    ScoreProjectRepository scoreProjectRepository;

    @Autowired
    ScoreSegmentRepository scoreSegmentRepository;

    @Autowired
    ComputedSegmentScoreManagementDataRepository computedSegmentScoreManagementDataRepository;

    @Autowired
    CustomProjectRepository customProjectRepository;

    @Autowired
    FmsStipRepository fmsStipRepository;

    @Autowired
    ResourceLoader resourceLoader;

    @Autowired
    Environment env;

    /**
     * Scores projects and generates a PDF Report from a list of Routes and Milepost
     * ranges
     * 
     * @param sri      The list of routes
     * @param startMP  The list opf corresponding start MPs
     * @param endMP    The list of corresponding end MPs
     * @param systemID The system ID to use for scoring
     * @return The reference to the Crystal Reports JSP page
     * @throws IOException
     * @throws ClientProtocolException
     * @throws JSONException
     * @throws ReportSDKExceptionBase
     */
    @RequestMapping("/CombinedReport")
    public void scoreAndDownloadReport(@RequestParam(value = "sri") String[] sri,
            @RequestParam(value = "start") double[] startMP, @RequestParam(value = "end") double[] endMP,
            @RequestParam(value = "systemID") int systemID, @RequestParam(value = "projDesc") String projDesc, HttpServletRequest request, HttpServletResponse response)
            throws ClientProtocolException, IOException, JSONException, ReportSDKExceptionBase {

        // STEP 1: Get data for factors in the selected score system
        List<ScoreFactor> scoreFactors = scoreFactorRepository.findWeightedBySystemID(systemID);
        // STEP 2: Get Decision Variable Score Ranges
        Iterable<DecisionVariableScoreRange> scoreRanges = decisionVariableScoreRangeRepository.findAll();
        // STEP 2B: Create a HashMap tyo make it easier to process DVSR Data
        HashMap<String, List<DecisionVariableScoreRange>> scoreRangesMap = CDPReportsController
                .createScoreRangesMap(scoreRanges);

        // STEP 3: Create route objects from parameters. each route object represents an
        // SRI-StartMP-EndMP combination
        // STEP 3A: lets construct dbnums for each reportroute
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String currentPrincipalName = authentication.getName();
        String username = currentPrincipalName;
        long now = Instant.now().toEpochMilli();
        String dbnumPrefix = username + "" + now;
        List<CustomProject> routesList = new ArrayList<>();
        for (int i = 0; i < sri.length; i++) {
            routesList.add(new CustomProject(dbnumPrefix, sri[i], startMP[i], endMP[i], systemID));
        }
        customProjectRepository.save(routesList);

        String imageURL = ReportUtils.generateReportGISImage(routesList, fmsStipRepository);

        // STEP 4: Generate score project records - This is a prerequisite to generate
        // data for SCR_CDP_PROJECT
        // STEP 4A: For every project that needs to be scored ...
        for (CustomProject reportRoute : routesList) {
            List<ScoreProject> projectDataList = new ArrayList<>();
            // STEP 4B: ... and every factor in this score system ...
            for (ScoreFactor scoreFactor : scoreFactors) {
                ScoreProject scoreProject = new ScoreProject();
                scoreProject.setYear(2019);
                scoreProject.setDbnum(reportRoute.getDbnum());
                scoreProject.setRevision(0);
                scoreProject.setSystemid(systemID);

                scoreProject.setCatId(scoreFactor.getCategoryID());
                scoreProject.setFactorId(scoreFactor.getFactorID());
                scoreProject.setScore(100);
                projectDataList.add(scoreProject);
            }
            // STEP 4C: ... create a record in the score project table
            scoreProjectRepository.save(projectDataList);
        }

        // STEP 5: Compute data to be stored in the SCR_CDP_PROJECTS table
        List<String> dbnumList = new ArrayList<>();
        for (CustomProject c : routesList)
            dbnumList.add(c.getDbnum());
        List<ComputedSegmentScoreManagementData> segmentDataList = computedSegmentScoreManagementDataRepository
                .getCombinedReportScoreManagementData(dbnumPrefix);

        List<ScoreSegment> scoreRecords = new ArrayList<>(); // Store computed scores to reduce database calls
        for (ComputedSegmentScoreManagementData segmentData : segmentDataList) {
            ScoreSegment toSave = new ScoreSegment();
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
            toSave.setScrSystemId(systemID + "");
            toSave.setRoute(segmentData.getRoute());
            toSave.setSri(segmentData.getSri());
            toSave.setImagePath(imageURL);
            toSave.setProjectInfoUser(projDesc);
            scoreRecords.add(toSave);
        }
        scoreSegmentRepository.save(scoreRecords);
        List<ScoreProject> projectScoresList = new ArrayList<>();
        for (CustomProject cdpProject : routesList) {

            ScoreCriteria scoreCriteria = CDPReportsController
                    .buildScoreCriteriaMax(scoreSegmentRepository.getCriteriaMaximums(cdpProject.getDbnum()));

            /* if (scoreCriteria.getNhs() != null)
                if (scoreCriteria.getNhs() < 1)
                    scoreCriteria.setNhs(0.0);
            if (scoreCriteria.getNjAccess() != null)
                if (scoreCriteria.getNjAccess() < 1)
                    scoreCriteria.setNjAccess(0.0);
            if (scoreCriteria.getIntermodal() != null)
                if (scoreCriteria.getIntermodal() < 1)
                    scoreCriteria.setIntermodal(0.0);
            if (scoreCriteria.getNationalHighwayFreightNetwork() != null)
                if (scoreCriteria.getNationalHighwayFreightNetwork() < 1)
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
                                    && scoreCriteria.getCrLt() <= dvsr.getEnd_range())
                                scoreCriteria.setCrLt((scoreFactor.getWeight() * dvsr.getScore()) / 100);
                            score = scoreCriteria.getCrLt();
                            break;
                        case "Large Truck Severity Rate":
                            if (scoreCriteria.getSeverity() == null)
                                break;
                            if (scoreCriteria.getSeverity() > dvsr.getStart_range()
                                    && scoreCriteria.getSeverity() <= dvsr.getEnd_range())
                                scoreCriteria.setSeverity((scoreFactor.getWeight() * dvsr.getScore()) / 100);
                            score = scoreCriteria.getSeverity();
                            break;
                        case "National Highway Network":
                            if (scoreCriteria.getNhs() == null)
                                break;
                            if (scoreCriteria.getNhs() >= dvsr.getStart_range()
                                    && scoreCriteria.getNhs() <= dvsr.getEnd_range())
                                scoreCriteria.setNhs((scoreFactor.getWeight() * dvsr.getScore()) / 100);
                            score = scoreCriteria.getNhs();
                            break;
                        case "New Jersey Access Network":
                            if (scoreCriteria.getNjAccess() == null)
                                break;
                            if (scoreCriteria.getNjAccess() >= dvsr.getStart_range()
                                    && scoreCriteria.getNjAccess() <= dvsr.getEnd_range())
                                scoreCriteria.setNjAccess((scoreFactor.getWeight() * dvsr.getScore()) / 100);
                            score = scoreCriteria.getNjAccess();
                            break;
                        case "Intermodal Connector":
                            if (scoreCriteria.getIntermodal() == null)
                                break;
                            if (scoreCriteria.getIntermodal() >= dvsr.getStart_range()
                                    && scoreCriteria.getIntermodal() <= dvsr.getEnd_range())
                                scoreCriteria.setIntermodal((scoreFactor.getWeight() * dvsr.getScore()) / 100);
                            score = scoreCriteria.getIntermodal();
                            break;
                        case "National Highway Freight Network":
                            if (scoreCriteria.getNationalHighwayFreightNetwork() == null)
                                break;
                            if (scoreCriteria.getNationalHighwayFreightNetwork() >= dvsr.getStart_range()
                                    && scoreCriteria.getNationalHighwayFreightNetwork() <= dvsr.getEnd_range())
                                scoreCriteria.setNationalHighwayFreightNetwork(
                                        (scoreFactor.getWeight() * dvsr.getScore()) / 100);
                            score = scoreCriteria.getNationalHighwayFreightNetwork();
                            break;
                        case "Percentage of Large Truck Volume":
                            if (scoreCriteria.getLtPercStip() == null)
                                break;
                            if (scoreCriteria.getLtPercStip() > dvsr.getStart_range()
                                    && scoreCriteria.getLtPercStip() <= dvsr.getEnd_range())
                                scoreCriteria.setLtPercStip((scoreFactor.getWeight() * dvsr.getScore()) / 100);
                            score = scoreCriteria.getLtPercStip();
                            break;
                        case "Truck Travel Time Reliability Index":
                            if (scoreCriteria.getTttr() == null)
                                break;
                            if (scoreCriteria.getTttr() > dvsr.getStart_range()
                                    && scoreCriteria.getTttr() <= dvsr.getEnd_range())
                                scoreCriteria.setTttr((scoreFactor.getWeight() * dvsr.getScore()) / 100);
                            score = scoreCriteria.getTttr();
                            break;
                        case "Overweight Truck Permits":
                            if (scoreCriteria.getOverweight() == null)
                                break;
                            if (scoreCriteria.getOverweight() > dvsr.getStart_range()
                                    && scoreCriteria.getOverweight() <= dvsr.getEnd_range())
                                scoreCriteria.setOverweight((scoreFactor.getWeight() * dvsr.getScore()) / 100);
                            score = scoreCriteria.getOverweight();
                            break;
                    }
                }
                projectScoresList.add(new ScoreProject(2019, cdpProject.getDbnum(), 0, systemID,
                        scoreFactor.getCategoryID(), scoreFactor.getFactorID(), score));
            }
        }
        scoreProjectRepository.save(projectScoresList);

        Resource resource = resourceLoader.getResource("classpath:reports/GISCombinedReport.rpt");
        
        Fields reportFields = new Fields();
        reportFields.add(CrystalReportUtils.createCrystalReportParameterField("", "customsql", "DBNUM = '" + dbnumPrefix + "'"));
        CrystalReportUtils.generateCrystalReportPDF(resource.getURI().getRawPath(), reportFields, request, response, env);
    }

}