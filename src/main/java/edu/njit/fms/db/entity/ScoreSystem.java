package edu.njit.fms.db.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Data;

@Entity(name = "scrsystem")
@Data
@Table(name = "scrsystem")
public class ScoreSystem {
	@Id
	@Column(name = "systemid")
	private int systemID;
	@Column(name = "systemname")
	private String SystemName;
	private String Description;
	private String Type;
	@Column(name = "maxscore")
	private int MaxScore;
	@Column(name="agencyalias")
	private String AgencyAlias;
	@Column(name = "isactive")
	private int IsActive;
	@Column(name = "loginid")
	private String LoginID;
	@Column(name = "timestamp")
	private String TimeStamp;
	
}
