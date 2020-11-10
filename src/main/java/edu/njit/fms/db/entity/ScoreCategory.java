package edu.njit.fms.db.entity;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Data;


@Data
@Entity
@Table(name = "scrcategory")
public class ScoreCategory 
{
	private int systemID;
	@Id
	@Column(name = "Cat_ID")
	private int catID;
	private String Cat_Name;
	private String Cat_Description;
	private String Weight;
	@Column(name = "dispposition")
	private String DispPosition;
	@Column(name = "disptext")
	private String DispText;
	@Column(name = "isactive")
	private String IsActive;
	private String target;
	
	private transient List<ScoreFactor> scoreFactors;
}
