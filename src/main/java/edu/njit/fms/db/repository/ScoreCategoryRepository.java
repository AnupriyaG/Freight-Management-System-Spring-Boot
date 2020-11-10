package edu.njit.fms.db.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import edu.njit.fms.db.entity.ScoreCategory;

public interface ScoreCategoryRepository extends CrudRepository<ScoreCategory, Long> {
    List<ScoreCategory> findBySystemIDOrderByCatID(int systemID);

    @Modifying
    @Transactional
    @Query(value = "insert into scrcategory values(?1,?2,?3,?4,?5,?6,?7,?8,'')", nativeQuery = true)
    void insertScoreCategory(int newScoreSystemID, int categoryID, String categoryName, String categoryDescription, String weight, String dispPosition, String dispText, String isActive);

    @Modifying
    @Transactional
    @Query(value = "update scrcategory set Weight = ?1  where Cat_ID = ?2 and SystemID = ?3", nativeQuery = true)
    void updateScoreCategory(double weight, int categoryID, int systemID);

    @Modifying
    @Transactional
    @Query(value = "delete from scrcategory where SystemID = ?1", nativeQuery = true)
    void deleteScoreCategory(int sysID);

    
}