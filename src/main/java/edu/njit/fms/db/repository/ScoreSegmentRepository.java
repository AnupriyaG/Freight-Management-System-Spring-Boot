package edu.njit.fms.db.repository;

import org.springframework.data.repository.CrudRepository;

import edu.njit.fms.db.entity.ScoreSegment;

public interface ScoreSegmentRepository extends CrudRepository<ScoreSegment, Long> {
    Double[][] getCriteriaMaximums(String dbnum);
}
