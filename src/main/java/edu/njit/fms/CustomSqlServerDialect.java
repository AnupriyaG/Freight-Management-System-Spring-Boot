package edu.njit.fms;

import java.sql.Types;

/**
 * Code required to fix issues with the default SQL Server Dialect provided by Spring/Hibernate
 */
public class CustomSqlServerDialect extends org.hibernate.dialect.SQLServerDialect {

    public CustomSqlServerDialect() {
        registerHibernateType(Types.NVARCHAR, 4000, "string");
    }

}