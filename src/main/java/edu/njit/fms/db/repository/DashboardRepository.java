package edu.njit.fms.db.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import edu.njit.fms.db.entity.Dashboard;

public interface DashboardRepository extends CrudRepository<Dashboard, Long> {
    List<String> getRoadList();
    List<Object[]> getDirectionList(@Param("road") String road);
    List<Object> getYearList();

    List<Object[]> getStateTTTRI();
    List<Object[]> getStateMilesUncongested();
    List<Object[]> getStatePercTotalCrashes();

    List<Object[]> getRouteTTTRI(@Param("road") String road, @Param("direction") String direction);
    List<Object[]> getRouteMilesUncongested(@Param("road") String road,@Param("direction") String direction );
    List<Object[]> getRoutePercTotalCrashes(@Param("sri") String sri);

    List<Object[]> getRouteTttriByMilepost(String intersection, String direction);
    List<Object[]> getRouteCrashesByMilepost(@Param("sri") String sri);
    List<Object[]> getRouteVolumeByMilepost(@Param("sri") String sri);

    List<Object[]> getRouteTttriCategoriesByMilepost(String intersection, String direction, String year);
    List<Object[]> getRouteCrashesCategoriesByMilepost(@Param("sri") String sri, @Param("year") String year);
    List<Object[]> getRouteLargeTruckSeverityByMilepost(@Param("sri") String sri, @Param("year") String year);
    
    List<Object[]> getCrashes(String intersection, String direction);
 /*    List<Object[]> getTTTRBreakdownForExcelReport(String intersection,String direction);
    List<Object[]> getMaxTTTRForExcelReport(String intersection,String direction);
    List<Object[]> getCrashesForExcelReport(String intersection,String direction);
    List<Object[]> getDetailedCrashesForExcelReport(String intersection,String direction);
    List<Object[]> getTruckVolumeForExcelReport(String intersection,String direction); */
    List<Object[]> getStateSummaryForExcelReport();
    List<Object[]> getRouteSummaryForExcelReport(String road,String direction,String sri);
    List<Object[]> getRouteLargeTruckSeverityForExcelReport(@Param("sri") String sri);
    
    
    //old graphs
    List<Object[]> getTTRIBarDataByIDY(String intersection, String direction, String year);
    List<Object[]> getMaxTTRIBarDataByIDY(String intersection, String direction, String year);
    List<Double> getMilesUnconDataByIDY(String intersection, String year);
    List<Object[]> getCrashPercDataByIDY(String intersection, String direction, String year);
    List<Object[]> getTruckVolumePerc(String intersection, String direction);
}