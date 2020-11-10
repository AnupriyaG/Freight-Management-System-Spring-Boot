package edu.njit.fms.db.entity;

import javax.persistence.Entity;
import javax.persistence.Id;

import lombok.Data;

/**
 * This is a dummy entity. It does not store any data or map to a table.
 * This has just been created to aid in organizing queries.
 */
@Entity
@Data
public class Dashboard {
    @Id
    int dummyID;
}