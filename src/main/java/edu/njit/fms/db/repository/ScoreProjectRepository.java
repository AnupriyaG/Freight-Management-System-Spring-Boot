package edu.njit.fms.db.repository;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import edu.njit.fms.db.entity.ScoreProject;

public interface ScoreProjectRepository extends CrudRepository<ScoreProject, Long> {
    @Query(value = "Select sum(Score) from scrproject where DBNUM = ?1 and SystemID = ?2", nativeQuery = true)
    Double evalCheckDBNUM(String dbnum, String systemID);
    
    @Modifying
    @Transactional
    @Query(value = "Insert into scrproject values (?1,?2,0,?3,?4,?5,?6)", nativeQuery = true)
    void setScoreProject(String year, String dbnum, String systemID,String catID, String factorID, double newValue);

    @Modifying
    @Transactional
    @Query(value = "Update scrproject set Score = ?1 where Year = ?2 and DBNUM = ?3 and Revision = 0 and SystemID = ?4 and Cat_ID = ?5 and Factor_ID = ?6", nativeQuery = true)
    int updateScoreProject(double score, String year, String dbnum, String systemID, int row, int row2);

    
    @Modifying
    @Transactional
    @Query(value = "delete from scrproject where DBNUM like 'Segment_%'", nativeQuery = true)
    void emptyScoreProjectSegments();

    
    @Modifying
    @Transactional
    @Query(value = "delete from scrproject where DBNUM = ?1", nativeQuery = true)
    void deleteScoreProjects(String dbnum);

    int rowExists(String year, String dbnum);

}