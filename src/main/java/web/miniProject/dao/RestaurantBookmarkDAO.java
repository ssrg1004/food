package web.miniProject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import web.miniProject.util.matDBUtil;

public class RestaurantBookmarkDAO {

	// 북마크 여부 확인
	public boolean isBookmarked(int post_id, int member_id) {

	    boolean result = false;

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql =
	        "select count(*) from restaurant_bookmark " +
	        "where post_id=? and member_id=?";

	    try {
	        conn = matDBUtil.getConn();
	        pstmt = conn.prepareStatement(sql);

	        pstmt.setInt(1, post_id);
	        pstmt.setInt(2, member_id);

	        rs = pstmt.executeQuery();

	        if(rs.next()) {
	            result = rs.getInt(1) > 0;
	        }

	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn, pstmt, rs);
	    }

	    return result;
	}
	
	// 좋아요 등록
	public int insertBookmark(int post_id, int member_id) {
		int result=0;
			
		Connection conn=null;
		PreparedStatement pstmt=null;
			
		String sql="insert into restaurant_bookmark(post_id, member_id) "
				 +"values(?, ?)";
			
		try {
			conn=matDBUtil.getConn();
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, post_id);				
			pstmt.setInt(2, member_id);
				
			result=pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, null);
		}
		return result;
	}
	
	//북마크 취소
	public int deleteBookmark(int post_id, int member_id) {
		int result=0;
		
		Connection conn=null;
		PreparedStatement pstmt=null;
		
		String sql="delete from restaurant_bookmark "
				  +"where post_id=? and member_id=?";
		
		try {
			conn=matDBUtil.getConn();
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, post_id);
			pstmt.setInt(2, member_id);
			
			result=pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, null);
		}
		return result;
	}
	
	// 북마크 개수
	public int getBookmarkCount(int post_id) {

	    int count = 0;

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql =
	        "select count(*) from restaurant_bookmark " +
	        "where post_id=?";

	    try {
	        conn = matDBUtil.getConn();
	        pstmt = conn.prepareStatement(sql);

	        pstmt.setInt(1, post_id);

	        rs = pstmt.executeQuery();

	        if(rs.next()) {
	            count = rs.getInt(1);
	        }

	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn, pstmt, rs);
	    }

	    return count;
	}
}
