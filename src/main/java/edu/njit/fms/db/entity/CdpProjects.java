package edu.njit.fms.db.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

import lombok.Data;

@Entity
@Data
public class CdpProjects {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;
    String dbnum;
    String projectName;
    String sri;
    double mpStart;
    double mpEnd;
    String username;
    String imagePath;
    String route;
    transient String failureMessage;

}