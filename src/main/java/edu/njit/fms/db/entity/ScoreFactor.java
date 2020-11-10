package edu.njit.fms.db.entity;

import javax.persistence.Cacheable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Data;

@Data
@Entity
@Cacheable(false)
@Table(name = "scrfactor")
public class ScoreFactor
{
	@Column(name = "systemid")
	private int systemID;
	@Column(name = "cat_id")
	private int categoryID;
	
	@Column(name = "Factor_ID")
	private int factorID;
	@Id
	private String Factor_Description;
	private double Weight;
	@Column(name = "dispposition")
	private String DispPosition;
	@Column(name = "disptext")
	private String DispText;
	@Column(name="isactive")
	private String IsActive;
	
	//private transient double Contributing_Score;//added for reports!
}
