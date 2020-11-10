package edu.njit.fms.db.entity;

import javax.persistence.Entity;
import javax.persistence.Id;

import lombok.Data;

@Entity
@Data
public class ProjectSystemScore {
    @Id
    String scoreSystem;
    Double score;
    String dbnum;
    String systemId;

}