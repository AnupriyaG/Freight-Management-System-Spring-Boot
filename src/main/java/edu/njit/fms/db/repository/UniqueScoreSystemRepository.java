package edu.njit.fms.db.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import edu.njit.fms.db.entity.UniqueScoreSystem;

public interface UniqueScoreSystemRepository extends CrudRepository<UniqueScoreSystem, Long> {
    @Query(value="SELECT  SCRCAT_UNQ.SystemID SystemID,"+
    "SCRCAT_UNQ.Cat_ID Cat_ID," +
    "SCRCAT_UNQ.Cat_Name Cat_Name," +
    "SCRCAT_UNQ.Cat_Description Cat_Description," +
    "SCRCAT_UNQ.DispText Cat_DispText," +
    "SCRCAT_UNQ.DispPosition Cat_DispPosition," +
    "SCRCAT_UNQ.Weight Cat_Weight," +
    "SCRCAT_UNQ.IsActive Cat_IsActive," +
    "SCRFACTOR_UNQ.SystemID SystemID," +
    "SCRFACTOR_UNQ.Cat_ID Cat_ID," +
    "SCRFACTOR_UNQ.Factor_ID Factor_ID," +
    "SCRFACTOR_UNQ.Factor_Description Factor_Description," +
    "SCRFACTOR_UNQ.DispText Factor_Disp_Text," +
    "SCRFACTOR_UNQ.DispPosition Factor_Disp_Position," +
    "SCRFACTOR_UNQ.Weight Factor_Weight," +
    "SCRFACTOR_UNQ.IsActive Factor_Is_Active," +
    "SCRSYS_UNQ.SystemID SystemID," +
    "SCRSYS_UNQ.SystemName System_Name," +
    "SCRSYS_UNQ.Description Description," +
    "SCRSYS_UNQ.MaxScore MaxScore," +
    "SCRSYS_UNQ.Type Type," +
    "SCRSYS_UNQ.IsActive SystemIsActive," +
    "SCRSYS_UNQ.AgencyAlias Agency_Alias," +
    "SCRSYS_UNQ.LoginID LoginID," +
    "SCRSYS_UNQ.TimeStamp Time_Stamp " +
    "FROM scrCategory SCRCAT_UNQ, scrFactor SCRFACTOR_UNQ, scrSystem SCRSYS_UNQ " +
    "WHERE SCRCAT_UNQ.SystemID = SCRSYS_UNQ.SystemID " +
    "and SCRFACTOR_UNQ.SystemID = SCRCAT_UNQ.SystemID " +
    "and SCRFACTOR_UNQ.Cat_ID = SCRCAT_UNQ.Cat_ID "+
    "and SCRSYS_UNQ.SystemID = ?1", nativeQuery=true)
    List<UniqueScoreSystem> getUniqueScoreSystemByID(int ID);
}