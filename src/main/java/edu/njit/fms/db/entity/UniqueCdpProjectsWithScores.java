package edu.njit.fms.db.entity;

import javax.persistence.Entity;
import javax.persistence.Id;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
//@IdClass(CdpProjectsWithScoreID.class)
@AllArgsConstructor
@NoArgsConstructor
public class UniqueCdpProjectsWithScores {
    Long id;
    @Id
    String dbnum;
    String projectName;
    String sri;
    double mpStart;
    double mpEnd;
    String username;
    String imagePath;
    String route;
    Double score;
    //@Id
    Integer systemId;
    String systemName;
    transient String failureMessage;
    
}