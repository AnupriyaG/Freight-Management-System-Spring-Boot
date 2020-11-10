package edu.njit.fms.db.entity;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Data;

@Entity
@Data
@Table(name = "scrsegment")
public class ScoreSegment {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;
    String dbnum;
    Double mpStartSeg;
    Double mpEndSeg;
    Double totalCountLt;
    Double crLt;
    Double severity;
    Double nationalHighwayFreightNetwork;
    Double intermodal;
    Double njAccess;
    Double nhs;
    Double meanTt;
    Double tt95;
    Double tttr;
    Double overweight;
    Double ltPercStip;
    Double totalScore;
    String scrSystemId;
    String route;
    String sri;
    String imagePath;
    String projectInfoUser;
}