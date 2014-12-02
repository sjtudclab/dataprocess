package cn.edu.sjtu.dcl.dao.impl;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

public class DB_Conn
{	
	private String driverName = "com.mysql.jdbc.Driver";
	private String userName = "root";
	private String userPwd = "root";
    private String dbName = "trafficdataprocess";
    private String url = "jdbc:mysql://localhost/" + dbName +
                    "?user=" + userName + "&password=" + userPwd;
    private Connection conn = null;
    public Statement sm = null;
    public PreparedStatement ps = null;
    
    public void ConnectDB()
    {
    	 try
    	 {
    		 Class.forName(driverName).newInstance();
        	 conn = DriverManager.getConnection(url);
        	 sm = conn.createStatement();
         }
    	 catch(Exception ex)
    	 {
    		 ex.printStackTrace();
    	 }
    }
    
    public void ConnectPreparedDB(String sql)
    {
    	 try
    	 {
    		 Class.forName(driverName).newInstance();
        	 conn = DriverManager.getConnection(url);
        	 ps = conn.prepareStatement(sql);
        	 
         }
    	 catch(Exception ex)
    	 {
    		 ex.printStackTrace();
    	 }
    }
    
    public void CloseDB()
    {
    	try
    	{
			if(sm != null)
			{
				sm.close();
			}
			if(ps != null)
			{
				ps.close();
			}
			conn.close();
		}
    	catch (SQLException ex)
    	{
			ex.printStackTrace();
		}
    
   }
}