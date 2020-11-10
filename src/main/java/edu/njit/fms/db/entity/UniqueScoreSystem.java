package edu.njit.fms.db.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

import lombok.Data;

@Entity
@Data
public class UniqueScoreSystem 
{
	@Id
	@Column(name = "systemid")
	private int systemID;
	@Column(name = "catId")
	private int catID;
	private String catName;
	private String catDescription;
	@Column(name="catDisptext")
	private String catDispText;
	@Column(name="catDispposition")
	private String catDispPosition;
	private String catWeight;
	@Column(name="catIsactive")
	private String catIsActive;
	@Column(name="factorId")
	private int factorID;
	private String factorDescription;
	private String factorDispText;
	private String factorDispPosition;
	private String factorWeight;
	private String factorIsActive;
	private String systemName;
	private String description;
	@Column(name="maxscore")
	private String maxScore;
	private String type;
	@Column(name="systemisactive")
	private String systemIsActive;
	private String agencyAlias;
	private String loginID;
	private String timeStamp;

}
