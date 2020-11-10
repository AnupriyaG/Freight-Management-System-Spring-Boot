package edu.njit.fms.db.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Data;

@Entity
@Data
@Table(name = "customprojects")
public class CustomProject {
    public CustomProject(String dbn, String sr, double start, double end, int system) {
        setDbnum(dbn);
        setSri(sr);
        setMpStart(start);
        setMpEnd(end);
        setSystemID(system);
	}
	@Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    int id;
    String dbnum;
    String sri;
    Double mpStart;
    Double mpEnd;
    @Column(name = "scrSystemId") 
    int systemID;
}
