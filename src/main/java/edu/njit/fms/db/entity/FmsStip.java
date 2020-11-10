package edu.njit.fms.db.entity;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import lombok.Data;

@Data
@Entity
@Table(name = "fms_stip")
public class FmsStip{
    private String year;
    @Id
    private String dbnum;
    private String upc;
    private String contract_number;
    private String m_posts;

}