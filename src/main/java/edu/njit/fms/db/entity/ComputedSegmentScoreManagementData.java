package edu.njit.fms.db.entity;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@IdClass(ComputedSegmentSccreManagementDataID.class)
@AllArgsConstructor
@NoArgsConstructor
public class ComputedSegmentScoreManagementData {
    @Id
    String dbnum;
    @Id
    Double mpStartSeg;
    @Id
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
    String sri;
    String route;
    
}