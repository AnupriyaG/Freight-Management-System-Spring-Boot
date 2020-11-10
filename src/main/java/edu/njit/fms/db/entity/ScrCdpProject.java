package edu.njit.fms.db.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.IdClass;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Data
@IdClass(ScrCdpProject.class)
@AllArgsConstructor
@NoArgsConstructor
public class ScrCdpProject implements Serializable {
    
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
    @Id
    String scrSystemId;
    String route;
    String sri;
}