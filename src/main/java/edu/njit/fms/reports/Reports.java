package edu.njit.fms.reports;

import lombok.Data;

@Data
public class Reports 
{
	private String Year;
	private String DBNUM;
	private String Project_Type;
	private String Project_Name;
	private String Score;
	private String System_Name;
	private boolean selectedForDownload;
}
