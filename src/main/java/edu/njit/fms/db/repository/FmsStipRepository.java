package edu.njit.fms.db.repository;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import edu.njit.fms.db.entity.DecisionVariableScoreRange;
import edu.njit.fms.db.entity.FmsStip;

public interface FmsStipRepository extends CrudRepository<FmsStip, Long> {

    List<String> getDistinctDBNUM();
    List<String> getDistinctProjectNames();
    List<String> getDistinctRoutes();
    List<String> getDistinctRoutesWithNulls();
    List<String> getDistinctProgManag();
    List<String> getDistinctCounty();
    List<String> getDistinctMunicipality();
    List<String> getDistinctMPO();
    List<String> getDistinctCISCategory();
    List<String> getDistinctCISSubCategory(String cisCategory);

    List<String> getProjectCascade();
    List<Object> getCustomRoutes();
    String getRouteBySRI(String sri);
    List<String> getAllDBNUMForScoring();
    List<String> getDBNUMForScoringByProjectName(String projectName);
    List<String> getDBNUMForScoringByRoute(String route);
    List<String> getDBNUMForScoringByCounty(String county);
    List<String> getDBNUMForScoringByMunicipality(String municipality);
    List<String> getDBNUMForScoringByMPO(String mpo);
    List<String> getDBNUMForScoringByProgManag(String progmanag);
    List<String> getDBNUMForScoringByCISCategory(String ciscat);
    List<String> getDBNUMForScoringByCISCategoryAndCISBubcategory(String ciscat, String cissubcat);
    String getSystemNameFromID(String scoring_system);
    List<Double[]> getStipScoringSystemReportData(String scoring_system);
    List<Double> getTTRIBarData();
    List<Double> getMilesUnconBarData();
    List<Object[]> getPercCrashRateBarData();
    List<String> getDBNUMListMain();

    List<Object[]> getSelectedStipReport(@Param("dbnums") List<String> dbnums, @Param("systemID") String systemID);
    List<Object[]> getLatLngFromSRIandMP(@Param("sri") String sri, @Param("start_mp") String startMP, @Param("end_mp") String endMP);

    @Query(value = "(SELECT MAX (CONVERT(float,D1.OVERWEIGHT)) AS OVERWEIGHT, MAX(CONVERT(float,D1.LT_PERC)) AS LT_PERC, MAX(CONVERT(float,D1.SEVERITY)) AS SEVERITY, MAX(CONVERT(float,D1.NATIONAL_HIGHWAY_FREIGHT_NETWORK)) AS NATIONAL_HIGHWAY_FREIGHT_NETWORK, MAX(CONVERT(float,D1.INTERMODAL)) AS INTERMODAL, MAX(CONVERT(float,D1.NJ_ACCESS)) AS NJ_ACCESS, MAX(CONVERT(float,D1.NHS)) AS NHS, MAX(CONVERT(float,D1.TRUCK_TRAVEL_TIME_RELIABILITY_INDEX)) AS TRUCK_TRAVEL_TIME_RELIABILITY_INDEX, MAX(CONVERT(float,D1.CRASH_RATE)) AS CRASH_RATE, LEFT(D1.YEAR,4)as Year, D1.PROJECT_NAME, D1.CIS_PROGRAM_CATEGORY from (select * from (select (case when len(SRI) = 8 then SRI+'__' else SRI+'_' end) as SRI_regex,MP_FROM as M_POSTS_FROM_STIP,MP_TO as M_POSTS_TO_STIP,DBNUM,YEAR,PROJECT_NAME,CIS_PROGRAM_CATEGORY from fms_stip where SRI IS NOT NULL AND DBNUM = ?1)T1, (SELECT DBNUM2,M_POSTS_FROM,M_POSTS_TO, NATIONAL_HIGHWAY_FREIGHT_NETWORK_SEGMENT AS NATIONAL_HIGHWAY_FREIGHT_NETWORK,INTERMODAL_SEGMENT AS INTERMODAL,LARGE_TRUCK_PERC_SEGMENT AS LT_PERC,LARGE_TRUCK_CRASH_RATE_SEGMENT AS CRASH_RATE,SEVERITY_SEGMENT AS SEVERITY,NHS_SEGMENT AS NHS,TTTR_SEGMENT AS TRUCK_TRAVEL_TIME_RELIABILITY_INDEX,OVERWEIGHT_PERMIT AS OVERWEIGHT,NJ_ACCESS_SEGMENT AS NJ_ACCESS FROM fms_segment)T2 WHERE (T1.SRI_regex) = T2.DBNUM2 AND ((T1.M_POSTS_FROM_STIP <= T2.M_POSTS_FROM AND T1.M_POSTS_TO_STIP >= T2.M_POSTS_FROM ) OR (T1.M_POSTS_FROM_STIP >= T2.M_POSTS_FROM AND T1.M_POSTS_TO_STIP <= T2.M_POSTS_TO ) OR (T1.M_POSTS_FROM_STIP <= T2.M_POSTS_TO AND T2.M_POSTS_TO <= T1.M_POSTS_TO_STIP)))D1 group by D1.YEAR,D1.PROJECT_NAME,D1.CIS_PROGRAM_CATEGORY )", nativeQuery = true)
    List<Object[]> evalQueryDetails(String dbnum);
    
    @Query(value = "Select Fix_it_First, Smart_Growth, Default_percent from tip_category_1 where mode = ?1", nativeQuery = true)
    List<Object[]> getWeight(String mode);

    //my changes
    @Query(value = "Select * from decision_variable_score_range", nativeQuery = true)
    List<DecisionVariableScoreRange[]> getScoreRange();

    @Query(value = "select Cat_ID,Factor_ID from scrfactor where Factor_Description = ?1 and SystemID = ?2", nativeQuery = true)
    List<Object[]> getScoreFactor(String factor, String systemID);

    @Modifying
    @Transactional
    @Query(value = "UPDATE FMS_STIP set GIS_URL=?1 WHERE DBNUM=?2", nativeQuery = true)
    void updateGISURL(String gisurl, String dbnum);

    @Query(value = "SELECT ROUTE from fms_segment where dbnum2=?1", nativeQuery = true)
    String getRoute(String dbnum2);

    @Query(value = "SELECT systemId,[Large Truck Crash Rate],[Large Truck Severity Rate],[National Highway Network],[New Jersey Access Network],[Intermodal Connector],[National Highway Freight Network], [Percentage of Large Truck Volume],[Truck Travel Time Reliability Index],[Overweight Truck Permits], [Large Truck Crash Rate]+[Large Truck Severity Rate]+[National Highway Network]+[New Jersey Access Network]+ [Intermodal Connector]+[National Highway Freight Network]+[Percentage of Large Truck Volume]+[Truck Travel Time Reliability Index]+[Overweight Truck Permits] as Total_Score FROM ( select systemId,Round([Large Truck Crash Rate]/25,2)*25 AS 'Large Truck Crash Rate',Round([Large Truck Severity Rate]/25,2)*25 AS 'Large Truck Severity Rate', Round([National Highway Network]/25,2)*25 AS 'National Highway Network',Round([New Jersey Access Network]/25,2)*25 AS 'New Jersey Access Network', Round([Intermodal Connector]/25,2)*25 AS 'Intermodal Connector',Round([National Highway Freight Network]/25,2)*25 AS 'National Highway Freight Network', Round([Percentage of Large Truck Volume]/25,2)*25 AS 'Percentage of Large Truck Volume',Round([Truck Travel Time Reliability Index]/25,2)*25 AS 'Truck Travel Time Reliability Index', Round([Overweight Truck Permits]/25,2)*25 AS 'Overweight Truck Permits' from (select systemID, max_score,factor_description from (select s.SystemID,s.Cat_ID,s.Factor_ID,s.Factor_Description,s.Weight as Perc_Weight,t.weight, cast(((s.Weight/100)*t.weight)as decimal(10,2)) as Max_Score from scrfactor s join (select SystemID, Cat_ID, Weight from scrcategory where SystemID = "
    + "?1"
    + ") t on s.Cat_ID = t.Cat_ID and s.SystemID = t.SystemID) p)i pivot ( sum(Max_Score) for Factor_Description in ([Large Truck Crash Rate],[Large Truck Severity Rate],[National Highway Network],[New Jersey Access Network], [Intermodal Connector],[National Highway Freight Network],[Percentage of Large Truck Volume],[Truck Travel Time Reliability Index],[Overweight Truck Permits])) AS pvt ) F", nativeQuery = true)
    List<Object[]> getStipReportData(String scoreSystem);

    @Query(value = "select MIN(M_POSTS_FROM) as a,MAX(M_POSTS_TO) as b from fms_segment where dbnum2 = ?1", nativeQuery = true)
    List<Object[]> getMinMaxMileposts(String route);

    @Query(value = "select MAX(M_POSTS_TO) from fms_segment where dbnum2 = ?1", nativeQuery = true)
    double fromSelect(String route);

    @Query(value = "select YEAR,DBNUM,NJ_ACCESS_SEGMENT from fms_segment where PROJECT_TYPE = 'STIP' and ROUTE = ?1 and " +
    "(M_POSTS_FROM Between ?2 and ?3 or M_POSTS_TO Between ?2 and ?3)", nativeQuery = true)
    List<Object[]> getStipProjectData(String route, double start, double end);

    @Query(value = "SELECT B.lat AS SEGMENT_LAT, B.long AS SEGMENT_LONG FROM fms_stip AS A LEFT JOIN njdot_mpdata AS B ON B.MP >= ROUND(A.MP_FROM,1) AND " + 
"    B.MP <= ROUND((CASE WHEN ROUND(A.MP_FROM,1) = ROUND(A.MP_TO,1) THEN A.MP_TO + 0.1  " + 
"            ELSE A.MP_TO  " + 
"        END),1) AND " + 
"        b.SRI = (  " + 
"        CASE  " + 
"            WHEN LEN(a.SRI) = 8  " + 
"            THEN a.SRI+'__'  " + 
"            ELSE a.SRI+'_'  " + 
"        END)  " + 
"WHERE " + 
"    a.dbnum=?1 AND " + 
"    a.MP_FROM IS NOT NULL AND " + 
"    a.MP_TO IS NOT NULL AND " + 
"    a.MP_TO != 0 AND " + 
"    a.SRI IS NOT NULL", nativeQuery=true)
    List<Object[]> getSTIPBoundingBox(String dbnum);

    @Query(value = "SELECT COUNT(*) FROM CustomProjects WHERE DBNUM = ?1", nativeQuery = true)
    int getCustomProjectCount(String dbnum);

    @Query(value="SELECT DataYear AS 'Year', TTTR_INDEX AS 'TTTR Index' FROM AnnualChartData order by DataYear", nativeQuery = true)
    List<Object[]> getTTTRIDataforExcelReport();

    @Query(value = "SELECT DataYear AS 'Year', PercInterstateMilageUncongested AS 'Miles Uncongested' FROM AnnualChartData order by DataYear", nativeQuery = true)
    List<Object[]> getMilesUnconforExcelReport();

    @Query(value = "SELECT DataYear AS 'Year', LargeTruckCrash AS 'Large Truck', OtherTruckCrash AS 'Other Truck' FROM AnnualChartData order by DataYear", nativeQuery = true)
    List<Object[]> getPercTotalCrashesforExcelReport();

    @Query(value = "SELECT Road, Direction, [Road Order], [TMC Code], [Milepost], [Weekdays 6AM - 10AM], [Weekdays 10AM - 4PM], [Weekdays 4PM - 8PM], [Overnight], [Weekends] " +
    " FROM ( SELECT road AS Road, Direction, road_order AS [Road Order], TMC_CODE_TRUCK AS [TMC Code], TIME_PERIOD_TRUCK, milepost AS [Milepost], SEG_TTTR " +
    " FROM NPMRDS_INTERSTATE_PERFORMANCE_MEASURE WHERE DATA_YEAR_TRUCK = ?1 AND direction = ?2 AND road = ?3 ) AS SourceTable PIVOT(AVG([SEG_TTTR]) FOR " +
    " [TIME_PERIOD_TRUCK] IN([Weekdays 6AM - 10AM], [Weekdays 10AM - 4PM], [Weekdays 4PM - 8PM], [Overnight], [Weekends])) AS PivotTable " +
    " ORDER BY Road, Direction, [Road Order]", nativeQuery = true)
    List<Object[]> getTTTRbyIDYforExcelReport(String year, String direction, String road);

    @Query(value = "SELECT DataYear AS 'Year', Road, Direction, LargeTruckCrashPercent AS 'Large Truck', OtherTruckCrashPercent AS 'Other Truck' " +
    "FROM AnnualInterstateCrashRate WHERE DataYear = ?1 AND Road = ?2 AND Direction=?3", nativeQuery = true)
    List<Object[]> getMilesUnconbyIDYforExcelReport(String year, String road, String direction);

    @Query(value = "SELECT DataYear AS 'Year', Road, Direction, LargeTruckCrashPercent AS 'Large Truck', OtherTruckCrashPercent AS 'Other Truck' " +
    "FROM AnnualInterstateCrashRate WHERE DataYear = ?1 AND Road = ?2 AND Direction=?3", nativeQuery = true)
    List<Object[]> getPercCrashbyIDYforExcelReport(String year, String road, String direction);

    @Query(value = "SELECT ROUTE AS 'Route', (PercentOfTruckVol * 100) AS 'Perc. Truck Volume', Direc AS Direction FROM TruckVolume " +
    "WHERE ROUTE = ?1 AND Direc = ?2", nativeQuery = true)
    List<Object[]> getPercTruckVolumebyIDYforExcelReport(String route, String direction);

    @Query(value = "select LEFT(YEAR,4)as Year from fms_stip where DBNUM = ?1", nativeQuery = true)
    List<String> getYear(String dbnum);

    List<String[]> getSTIPExcelReport(@Param("customsql") String customsql);
}