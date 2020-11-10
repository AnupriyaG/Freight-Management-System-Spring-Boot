package edu.njit.fms.db.entity;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CdpProjectsWithScoreID implements Serializable {
    private String dbnum;
    private Integer systemId;
}