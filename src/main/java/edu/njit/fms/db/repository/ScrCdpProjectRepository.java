package edu.njit.fms.db.repository;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import edu.njit.fms.db.entity.ScrCdpProject;

public interface ScrCdpProjectRepository extends CrudRepository<ScrCdpProject, Long> {
    Double[][] getCriteriaMaximums(String dbnum);
    Long[] getIdByDBNUM(String dbnum);
    @Transactional
    @Modifying
    @Query(value = "DELETE FROM scr_cdp_project where dbnum = ?1", nativeQuery = true)
    void deleteByDBNUM(String dbnum);
}
