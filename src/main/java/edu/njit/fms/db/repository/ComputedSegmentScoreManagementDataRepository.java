package edu.njit.fms.db.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import edu.njit.fms.db.entity.ComputedSegmentScoreManagementData;

public interface ComputedSegmentScoreManagementDataRepository extends CrudRepository<ComputedSegmentScoreManagementData, Long> {
    List<ComputedSegmentScoreManagementData> getSegmentScoreManagementData(String dbnum,String sri, double start, double end);
    List<ComputedSegmentScoreManagementData> getSegmentScoreManagementDataForDBNUMs(List<String> dbnums);
    List<ComputedSegmentScoreManagementData> getCombinedReportScoreManagementData(String dbnum);
}