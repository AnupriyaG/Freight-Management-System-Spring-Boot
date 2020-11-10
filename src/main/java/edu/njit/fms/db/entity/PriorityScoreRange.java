package edu.njit.fms.db.entity;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Data;

@Data
@Entity
@Table(name = "priorityscrrange")
public class PriorityScoreRange {
	private Double Acceptable_Range_From;
	private Double Acceptable_Range_To;	
	@Id
	private Double Low_Range_From;
	private Double Low_Range_To;
	private Double Medium_Range_From;
	private Double Medium_Range_To;
	private Double High_Range_From;
	private Double High_Range_To;
}
