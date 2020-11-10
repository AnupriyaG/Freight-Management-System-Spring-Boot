package edu.njit.fms.db.entity;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.IdClass;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Entity
@Table(name = "scrproject")
@IdClass(ScoreProjectID.class)
@AllArgsConstructor
@NoArgsConstructor
public class ScoreProject {
    @Id
    private int year;
    @Id
    private String dbnum;
    @Id
    private int revision;
    @Id
    private int systemid;
    @Id
    private int catId;
    @Id
    private int factorId;
    private double score;
}