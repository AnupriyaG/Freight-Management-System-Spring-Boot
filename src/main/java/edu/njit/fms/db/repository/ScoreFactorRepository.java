package edu.njit.fms.db.repository;

import java.util.List;

import javax.persistence.Cacheable;
import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import edu.njit.fms.db.entity.ScoreFactor;

@Cacheable(false)
public interface ScoreFactorRepository extends CrudRepository<ScoreFactor, Long> {
    @Query(value="SELECT * FROM scrfactor WHERE systemid=?1 and cat_id=?2", nativeQuery = true)
    @Transactional
    List<ScoreFactor> findBySystemIDAndCategoryID(int systemID, int categoryID);

    /**
     * Get the score factors weight in relation to the score system.
     * Each list item contains [factor_description, weight]
     * @param systemID
     * @return
     */
    List<ScoreFactor> findWeightedBySystemID(int systemID);

    @Modifying
    @Transactional
    @Query(value = "insert into scrfactor values(?1,?2,?3,?4,?5,?6,?7,?8)", nativeQuery = true)
    void insertScoreFactor(int newScoreSystemID, int categoryID, int factorID, String factorDescription, double weight, String dispPosition, String dispText, String isActive);

    @Modifying
    @Transactional
    @Query(value = "update scrfactor set Weight = ?1  where Cat_ID = ?2 and SystemID = ?3 and Factor_ID = ?4", nativeQuery = true)
    void updateScoreFactor(double weight, int categoryID, int systemID, int factorID);

    @Modifying
    @Transactional
    @Query(value = "delete from scrfactor where SystemID = ?1", nativeQuery = true)
    void deleteScoreFactor(int sysID);

    
}