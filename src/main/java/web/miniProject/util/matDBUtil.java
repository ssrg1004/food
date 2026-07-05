package web.miniProject.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class matDBUtil {
	private static final String driver = "oracle.jdbc.driver.OracleDriver";
	private static final String url = "jdbc:oracle:thin:@192.168.219.49:1521:orcl";
	private static final String user = "pro1";	// 각자 아이디로 변경
	private static final String pw = "1234";	
	
	public static Connection getConn() throws Exception {
		Class.forName(driver);
		return DriverManager.getConnection(url, user, pw);
	} 
	
	public static void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
		try { if(conn  != null) conn.close();  } catch(SQLException e){ e.printStackTrace(); } 
		 try { if(pstmt != null) pstmt.close(); } catch(SQLException e){ e.printStackTrace(); } 
	     try { if(rs != null) rs.close(); } catch(SQLException e){ e.printStackTrace(); }
	}
}