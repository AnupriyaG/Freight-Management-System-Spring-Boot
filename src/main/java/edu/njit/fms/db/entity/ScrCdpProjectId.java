package edu.njit.fms.db.entity;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScrCdpProjectId implements Serializable {
    String dbnum;
    Double mpStartSeg;
    Double mpEndSeg;
    String scrSystemId;

}