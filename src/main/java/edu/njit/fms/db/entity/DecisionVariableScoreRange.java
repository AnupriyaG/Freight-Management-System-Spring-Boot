package edu.njit.fms.db.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Data;

@Data
@Entity
@Table(name = "decision_variable_score_range")
public class DecisionVariableScoreRange
{
	@Column(name = "mode")
	private String category_name;
	@Column(name = "start_range")
	private double start_range;
	@Column(name = "end_range")
	private double end_range;
	@Column(name = "weight_percentage")
	private double score;
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@Column(name = "id")
	private Long id;
	private transient boolean editing = false;
	private transient boolean newRecord = false;
	
}
