package edu.njit.fms.db.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import edu.njit.fms.db.entity.DecisionVariableScoreRange;

public interface DecisionVariableScoreRangeRepository extends CrudRepository<DecisionVariableScoreRange, Long> {
    DecisionVariableScoreRange findById(long id);
    List<DecisionVariableScoreRange> listScoreRatios(String mode);
}