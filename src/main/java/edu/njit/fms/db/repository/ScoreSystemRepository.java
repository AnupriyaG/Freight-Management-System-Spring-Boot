package edu.njit.fms.db.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

import edu.njit.fms.db.entity.ScoreSystem;

public interface ScoreSystemRepository extends CrudRepository<ScoreSystem, Long> {
    List<ScoreSystem> findAll();
    
    @Query(value = "SELECT * FROM scrSystem ORDER BY SystemID", nativeQuery = true)
    List<ScoreSystem> listAllbySystemID();
    @Query(value="SELECT * FROM scrSystem SCRSYS ORDER BY SystemID", nativeQuery=true)
    List<ScoreSystem> listAllSys();
    

    @Query(value="SELECT * FROM scrSystem SCRSYS where IsActive = 1 ORDER BY SystemID", nativeQuery=true)
    List<ScoreSystem> listAllSystems();
    
    @Query(value="SELECT * FROM scrSystem SCRSYS where IsActive = 2 ORDER BY SystemID", nativeQuery=true)
    List<ScoreSystem> listAllDefaultSystems();
    
    @Query(value="SELECT DISTINCT SCRSYS.LoginID LoginID FROM scrSystem SCRSYS ORDER BY LoginID", nativeQuery=true)
    List<String> listScoringUsers();

    @Query(value = "select MAX(SystemID) from scrsystem", nativeQuery = true)
    int getNewSystemID();

    @Modifying
    @Transactional
    @Query(value = "insert into scrsystem values(?1,?2,?3,?4,?5,?6,1,?7,CURRENT_TIMESTAMP)", nativeQuery = true)
    void insertScoreSystem(int newScoreSystemID, String systemName, String description, String type, String maxScore, String agencyAlias, String loginID);

    @Modifying
    @Transactional
    @Query(value = "delete from scrsystem where SystemID = ?1", nativeQuery = true)
    void deleteScoreSystem(int sysID);

    @Query(value = "select SystemName from scrsystem where SystemID = ?1", nativeQuery = true)
    String getSystemNameFromID(String systemID);

    @Modifying
    @Transactional
    @Query(value = "Delete from scrsegment", nativeQuery = true)
    void emptyScoreSegmentTable();

    //@Query(value = "SELECT D3.MP_START_SEG, D3.MP_END_SEG, D3.TOTAL_COUNT_LT, D3.CR_LT, D3.SEVERITY, D3.NATIONAL_HIGHWAY_FREIGHT_NETWORK, D3.INTERMODAL, D3.NJ_ACCESS, D3.NHS, D3.MEAN_TT, D3.TT95, D3.TTTR,D3.OVERWEIGHT, D3.LT_PERC_STIP, Round(SUM(D3.SCORE),4) AS TOTAL_SCORE,D3.SRI FROM (SELECT D1.Factor_Description, D2.DBNUM_SEG, D2.MP_START_SEG, D2.MP_END_SEG, D2.TOTAL_COUNT,D2.TOTAL_CR,D2.TOTAL_COUNT_LT, D2.CR_LT, D2.SEVERITY, D2.NATIONAL_HIGHWAY_FREIGHT_NETWORK, D2.INTERMODAL, D2.NJ_ACCESS, D2.NHS, D2.MEAN_TT, D2.TT95, D2.TTTR,D2.OVERWEIGHT, D2.CR_SCR_STIP,D2.SEV_SCR_STIP,D2.NHS_SCR_STIP,D2.NJ_ACCESS_SCR_STIP,D2.INTERMODAL_SCR_STIP,D2.NATIONAL_HIGHWAY_FREIGHT_NETWORK_SCR_STIP,D2.LT_SCR_STIP,D2.OVERWEIGHT_SCR_STIP,D2.TTTR_SCR_STIP,D2.LT_PERC_STIP,D1.Score,D2.SRI FROM (SELECT * FROM (select DISTINCT S2.DBNUM,S2.SYSTEMID,S1.Factor_Description,S1.Weight,Fix_it_First,Smart_Growth,Transit_Oriented,(S1.Weight/100)*Transit_Oriented AS SCORE from scrfactor S1 JOIN tip_category ON S1.Factor_Description = Mode JOIN scrproject S2 ON S2.SystemID = S1.SystemID WHERE DBNUM = ?1 " +
    //" GROUP BY S1.Factor_Description,S2.DBNUM,S2.SYSTEMID,S1.Weight,Fix_it_First,Smart_Growth,Transit_Oriented) T2 ) D1, (SELECT T2.DBNUM AS DBNUM_SEG, T2.M_POSTS_FROM AS MP_START_SEG, T2.M_POSTS_TO AS MP_END_SEG, T2.TOTAL_COUNT,T2.TOTAL_CR,T2.TOTAL_COUNT_LT, T2.CR_LT, T2.SEVERITY, T2.NATIONAL_HIGHWAY_FREIGHT_NETWORK, T2.INTERMODAL, T2.NJ_ACCESS, T2.NHS, T2.MEAN_TT, T2.TT95, T2.TTTR,T2.OVERWEIGHT, CONVERT(float,T2.CR_SCR) AS CR_SCR_STIP, CONVERT(float,T2.SEV_SCR) AS SEV_SCR_STIP, CONVERT(float,T2.NHS_SCR) AS NHS_SCR_STIP,CONVERT(float,T2.NJ_ACCESS_SCR) AS NJ_ACCESS_SCR_STIP, CONVERT(float,T2.INTERMODAL_SCR) AS INTERMODAL_SCR_STIP, CONVERT(float,T2.NATIONAL_HIGHWAY_FREIGHT_NETWORK_SCR) AS NATIONAL_HIGHWAY_FREIGHT_NETWORK_SCR_STIP, CONVERT(float,T2.LT_SCR) AS LT_SCR_STIP, CONVERT(float,T2.OVERWEIGHT_SCR) AS OVERWEIGHT_SCR_STIP, CONVERT(float,T2.TTTR_SCR) AS TTTR_SCR_STIP,CONVERT(float,T2.LT_PERC) AS LT_PERC_STIP,T2.SRI FROM (SELECT ROUTE ,DBNUM, DBNUM2,M_POSTS_FROM, M_POSTS_TO, NATIONAL_HIGHWAY_FREIGHT_NETWORK_SEGMENT AS NATIONAL_HIGHWAY_FREIGHT_NETWORK,INTERMODAL_SEGMENT AS INTERMODAL,LARGE_TRUCK_PERC_SEGMENT AS LT_PERC,LARGE_TRUCK_CRASH_RATE_SEGMENT AS CRASH_RATE,SEVERITY_SEGMENT AS SEVERITY, NHS_SEGMENT AS NHS,TTTR_SEGMENT AS TTTR, OVERWEIGHT_PERMIT AS OVERWEIGHT, CRASH_RATE_SCORE AS CR_SCR,SEVERITY_SCORE AS SEV_SCR, NHS_SCORE AS NHS_SCR,NJ_ACCESS_SCORE AS NJ_ACCESS_SCR, INTERMODAL_SCORE AS INTERMODAL_SCR, NATIONAL_HIGHWAY_FREIGHT_NETWORK_SEGMENT AS NATIONAL_HIGHWAY_FREIGHT_NETWORK_SCR,LARGE_TRUCK_SCORE AS LT_SCR,OVERWEIGHT_SCORE AS OVERWEIGHT_SCR,TTTR_SEGMENT AS TTTR_SCR, TOTAL_COUNT AS TOTAL_COUNT,CR AS TOTAL_CR,TCOUNTLT AS TOTAL_COUNT_LT, LARGE_TRUCK_CRASH_RATE_SEGMENT AS CR_LT, MEAN_TRAVEL_TIME_SEGMENT AS MEAN_TT, TT95_SEGMENT AS TT95, CONVERT(float,NJ_ACCESS_SEGMENT) AS NJ_ACCESS,DBNUM2 AS SRI FROM fms_segment WHERE DBNUM2 = ?2 AND M_POSTS_FROM>=?3 AND M_POSTS_TO<=?4) T2 )D2" +
    //" WHERE (((D2.OVERWEIGHT BETWEEN D1.Fix_it_First AND D1.Smart_Growth) AND D1.Factor_Description = 'OVERWEIGHT TRUCK PERMITS') OR ((D2.SEVERITY BETWEEN D1.Fix_it_First AND D1.Smart_Growth) AND D1.Factor_Description = 'LARGE TRUCK SEVERITY RATE') OR ((D2.CR_LT BETWEEN D1.Fix_it_First AND D1.Smart_Growth) AND D1.Factor_Description = 'LARGE TRUCK CRASH RATE') OR ((D2.NATIONAL_HIGHWAY_FREIGHT_NETWORK BETWEEN D1.Fix_it_First AND D1.Smart_Growth) AND D1.Factor_Description = 'NATIONAL HIGHWAY FREIGHT NETWORK') OR ((D2.NHS BETWEEN D1.Fix_it_First AND D1.Smart_Growth) AND D1.Factor_Description = 'National Highway Network') OR ((D2.NJ_ACCESS BETWEEN D1.Fix_it_First AND D1.Smart_Growth) AND D1.Factor_Description = 'New Jersey Access Network') OR ((D2.INTERMODAL BETWEEN D1.Fix_it_First AND D1.Smart_Growth) AND D1.Factor_Description = 'Intermodal Connector') OR ((D2.LT_PERC_STIP BETWEEN D1.Fix_it_First AND D1.Smart_Growth) AND D1.Factor_Description = 'Percentage of Large Truck Volume') OR ((D2.TTTR BETWEEN D1.Fix_it_First AND D1.Smart_Growth) AND D1.Factor_Description = 'Truck Travel Time Reliability Index')) )D3 GROUP BY D3.MP_START_SEG, D3.MP_END_SEG, D3.TOTAL_COUNT_LT, D3.CR_LT, D3.SEVERITY, D3.NATIONAL_HIGHWAY_FREIGHT_NETWORK, D3.INTERMODAL, D3.NJ_ACCESS, D3.NHS, D3.MEAN_TT, D3.TT95, D3.TTTR,D3.OVERWEIGHT, D3.LT_PERC_STIP, D3.SRI ORDER BY MP_START_SEG, MP_END_SEG", nativeQuery = true)
    List<Object[]> getMainSegmentData(String dbnum,String route, double start, double end);

    @Query(value = "select max(OVERWEIGHT) as a,max(LT_PERC_STIP) as b,max(SEVERITY) as c,max(NATIONAL_HIGHWAY_FREIGHT_NETWORK) as d,max(INTERMODAL) as e,max(NJ_ACCESS) as f,max(NHS) as g,max(TTTR) as h,max(CR_LT) as i from scrsegment", nativeQuery = true)
    Object[] getMaximumCriteria();
}