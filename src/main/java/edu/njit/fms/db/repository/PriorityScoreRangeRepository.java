package edu.njit.fms.db.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import edu.njit.fms.db.entity.PriorityScoreRange;

public interface PriorityScoreRangeRepository extends CrudRepository<PriorityScoreRange, Long> {
    List<PriorityScoreRange> findAll();
}