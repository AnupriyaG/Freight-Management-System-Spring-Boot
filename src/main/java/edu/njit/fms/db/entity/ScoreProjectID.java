package edu.njit.fms.db.entity;

import java.io.Serializable;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ScoreProjectID implements Serializable{
    private int year;
    private String dbnum;
    private int revision;
    private int systemid;
    private int catId;
    private int factorId;
}