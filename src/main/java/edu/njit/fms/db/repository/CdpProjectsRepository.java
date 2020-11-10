package edu.njit.fms.db.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import edu.njit.fms.db.entity.CdpProjects;
import edu.njit.fms.db.entity.CdpProjectsWithScore;
import edu.njit.fms.db.entity.UniqueCdpProjectsWithScores;

public interface CdpProjectsRepository extends CrudRepository<CdpProjects, Long> {
    @Query(nativeQuery = true, value = "select count(*) from cdp_projects where sri=?1 and mp_start = ?2 and mp_end = ?3 and username = ?4")
    int getDuplicateCount(String sri, double mpStart, double mpEnd, String username);

    List<CdpProjects> getProjectsUnscoredByScoreSystem(int system_id);

    List<CdpProjects> getProjectsByDBNUMList(List<String> dbnums);

    List<UniqueCdpProjectsWithScores> getProjectsWithScores(int systemID, List<String> username);
    
    List<Object[]> getCDPExcelReportData(@Param("dbnums") List<String> dbnums, @Param("systemID") String systemID);
    
    List<CdpProjectsWithScore> getProjectsWithScoresByDBNUM(String dbnum);
    
    
}