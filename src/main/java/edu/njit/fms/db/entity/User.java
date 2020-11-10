package edu.njit.fms.db.entity;

import javax.persistence.Entity;
import javax.persistence.Id;

import lombok.Data;

@Data
@Entity
public class User 
{
	public transient String principleid;
	public String groupid;
	public transient String domain;
	@Id
	public String loginid;
	public String fullname;
	public transient int roleid;
	public transient boolean isgroup;
	public transient String password;
	
	/* public boolean isGroup() 
	{
		return isgroup;
	}

	public void setallClassVariables(String uname,String pwd)
	{
		Connection con = ConnectionManager.getConnection();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String roleid="";
		String groupid = "";
		String principleid = "";
		try 
		{
			String SQL = "select roleid,groupid,principleid from groupmap,roleloginmap where groupmap.groupid = roleloginmap.loginid and principleid = '"+this.loginid +"' and groupmap.domain = '"+this.domain+"';";
			pstmt = con.prepareStatement(SQL);
			System.out.println(SQL);
			rs = pstmt.executeQuery();
			while ( rs.next() )
			{
				roleid = rs.getString(1);
				groupid = rs.getString(2);
				principleid = rs.getString(3);
			}
			this.setRoleid(Integer.parseInt(roleid));
			this.setGroupid(groupid);
			this.setPrincipleid(principleid);
		}
		catch (SQLException e) 
		{
			System.out.println(e);
		}
	} */
	
}
