package web.miniProject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import web.miniProject.dto.RestaurantSearchDTO;
import web.miniProject.dto.ReviewerSearchDTO;
import web.miniProject.util.matDBUtil;

public class SearchDAO {
	
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	private String sql = null;

	// 맛집 검색목록
	public ArrayList<RestaurantSearchDTO> searchRestaurant(
	        String keyword,
	        int limit){

	    ArrayList<RestaurantSearchDTO> list = new ArrayList<>();

	    String sql =
	    		"SELECT * FROM ( " +
				"    SELECT " +
				"        RP.POST_ID, " +
				"        RP.TITLE, " +
				"        RP.REG_DATE, " +
				"        RP.VIEW_CNT, " +
				"        RP.LIKE_CNT, " +
				"        RP.BOOKMARK_CNT, " +				
				"        RI.FILE_NAME AS THUMBNAIL, " +
				"        R.RESTAURANT_ID, " +
				"        R.NAME, " +
				"        R.ZIPCODE, " +
				"        R.ADDRESS1, " +
				"        R.ADDRESS2, " +

				"        NVL((SELECT ROUND(AVG(RC.STAR_SCORE),1) " +
				"               FROM RESTAURANT_COMMENT RC " +
				"              WHERE RC.POST_ID = RP.POST_ID " +
				"                AND RC.DELETE_YN = 'N'), 0) AS AVG_STAR, " +

				"        NVL((SELECT LISTAGG('#' || T.TAG_NAME, ' ') " +
				"                WITHIN GROUP (ORDER BY T.TAG_ID) " +
				"           FROM RESTAURANT_POST_TAG RPT " +
				"           JOIN TAG T " +
				"             ON RPT.TAG_ID = T.TAG_ID " +
				"          WHERE RPT.POST_ID = RP.POST_ID), '') AS TAGS " +

				"    FROM RESTAURANT_POST RP " +
				"    JOIN RESTAURANT_INFO R " +
				"      ON RP.RESTAURANT_ID = R.RESTAURANT_ID " +
				"    LEFT JOIN RESTAURANT_IMAGE RI " +
				"      ON RP.POST_ID = RI.POST_ID " +
				"     AND RI.IS_THUMBNAIL = 'Y' " +
				"    WHERE RP.SEARCH_TEXT LIKE '%' || ? || '%' " +
				"    ORDER BY RP.REG_DATE DESC " +
				") " +
				"WHERE ROWNUM <= ?";
	    try{

	        conn = matDBUtil.getConn();

	        pstmt = conn.prepareStatement(sql);

	        pstmt.setString(1, keyword);
	        pstmt.setInt(2, limit);

	        rs = pstmt.executeQuery();

	        while(rs.next()){

	            RestaurantSearchDTO dto =
	                    new RestaurantSearchDTO();

	            dto.setPost_id(rs.getInt("POST_ID"));
	            dto.setRestaurant_id(
	                    rs.getInt("RESTAURANT_ID"));

	            dto.setTitle(rs.getString("TITLE"));

	            dto.setName(rs.getString("NAME"));

	            dto.setZipcode(
	                    rs.getString("ZIPCODE"));

	            dto.setAddress1(
	                    rs.getString("ADDRESS1"));

	            dto.setAddress2(
	                    rs.getString("ADDRESS2"));

	            dto.setThumbnail(
	            		rs.getString("thumbnail"));
	            
	            dto.setView_cnt(
	                    rs.getInt("VIEW_CNT"));

	            dto.setLike_cnt(
	                    rs.getInt("LIKE_CNT"));
	            
	            dto.setBookmark_cnt(
	            		rs.getInt("BOOKMARK_CNT"));

	            dto.setReg_date(
	                    rs.getDate("REG_DATE"));

	            dto.setAvg_star(
	            		rs.getDouble("AVG_STAR"));
	            
	            dto.setTags(
	            		rs.getString("TAGS"));

	            list.add(dto);
	        }

	    }catch(Exception e){
	        e.printStackTrace();
	    }finally{
	        matDBUtil.close(conn,pstmt,rs);
	    }

	    return list;
	}
	
	
	// 맛집 검색 개수
	public int searchRestaurantCount(String keyword){
		
	    int count = 0;

	    String sql =
	        "SELECT COUNT(*) " +
	        "FROM RESTAURANT_POST " +
	        "WHERE SEARCH_TEXT LIKE '%' || ? || '%'";

	    try{

	    	conn = matDBUtil.getConn();

	        pstmt = conn.prepareStatement(sql);

	        pstmt.setString(1, keyword);

	        rs = pstmt.executeQuery();

	        if(rs.next()){
	            count = rs.getInt(1);
	        }

	    }catch(Exception e){
	        e.printStackTrace();
	    }finally{
	    	matDBUtil.close(conn,pstmt,rs);
	    }

	    return count;
	}	
	
	
	
	// 평가단 검색 목록
	public ArrayList<ReviewerSearchDTO> searchReviewer(
	        String keyword,
	        int limit){

	    ArrayList<ReviewerSearchDTO> list = new ArrayList<>();

	    String sql =
	            "SELECT * FROM ( " +
	            "    SELECT " +
	            "        RP.POST_ID, " +
	            "        RP.TITLE, " +
	            "        RP.REG_DATE, " +
	            "        RP.VIEW_CNT, " +
	            "        RP.LIKE_CNT, " +
	            "        RP.BOOKMARK_CNT, " +
	            "        M.NICKNAME, " +
	            "        RI.FILE_NAME AS THUMBNAIL, " +

	            "        RC.CONTENT_SUBTITLE AS SUBTITLE, " +
	            "        DBMS_LOB.SUBSTR(RC.CONTENT, 200, 1) AS CONTENT, " +

	            "        NVL( " +
	            "            (SELECT LISTAGG('#' || T.TAG_NAME, ' ') " +
	            "                    WITHIN GROUP (ORDER BY T.TAG_ID) " +
	            "               FROM REVIEWER_POST_TAG RPT " +
	            "               JOIN TAG T " +
	            "                 ON RPT.TAG_ID = T.TAG_ID " +
	            "              WHERE RPT.POST_ID = RP.POST_ID), '' " +
	            "        ) AS TAGS " +

	            "    FROM REVIEWER_POST RP " +

	            "    JOIN MEMBER M " +
	            "      ON M.MEMBER_ID = RP.MEMBER_ID " +

	            "    LEFT JOIN REVIEWER_IMAGE RI " +
	            "      ON RI.POST_ID = RP.POST_ID " +
	            "     AND RI.IS_THUMBNAIL = 'Y' " +

	            "    /* 핵심: CONTENT 1개만 미리 선택 */ " +
	            "    LEFT JOIN ( " +
	            "        SELECT POST_ID, CONTENT_SUBTITLE, CONTENT " +
	            "        FROM ( " +
	            "            SELECT " +
	            "                RC.POST_ID, " +
	            "                RC.CONTENT_SUBTITLE, " +
	            "                RC.CONTENT, " +
	            "                ROW_NUMBER() OVER ( " +
	            "                    PARTITION BY RC.POST_ID " +
	            "                    ORDER BY RC.CONTENT_ORDER " +
	            "                ) AS RN " +
	            "            FROM REVIEWER_CONTENT RC " +
	            "        ) " +
	            "        WHERE RN = 1 " +
	            "    ) RC " +
	            "    ON RC.POST_ID = RP.POST_ID " +

	            "    WHERE RP.SEARCH_TEXT LIKE '%' || ? || '%' " +
	            "    ORDER BY RP.REG_DATE DESC " +
	            ") " +
	            "WHERE ROWNUM <= ?";

	    try{

	        conn = matDBUtil.getConn();

	        pstmt = conn.prepareStatement(sql);

	        pstmt.setString(1, keyword);
	        pstmt.setInt(2, limit);

	        rs = pstmt.executeQuery();

	        while(rs.next()){

	            ReviewerSearchDTO dto = new ReviewerSearchDTO();

	            dto.setPost_id(rs.getInt("POST_ID"));

	            dto.setTitle(rs.getString("TITLE"));

	            dto.setReg_date(rs.getDate("REG_DATE")); // 또는 rs.getTimestamp()

	            dto.setView_cnt(rs.getInt("VIEW_CNT"));

	            dto.setLike_cnt(rs.getInt("LIKE_CNT"));

	            dto.setBookmark_cnt(rs.getInt("BOOKMARK_CNT"));

	            dto.setNickname(rs.getString("NICKNAME"));

	            dto.setThumbnail(rs.getString("THUMBNAIL"));

	            dto.setSubtitle(rs.getString("SUBTITLE"));

	            dto.setContent(rs.getString("CONTENT"));

	            dto.setTags(rs.getString("TAGS"));

	            list.add(dto);
	        }

	    }catch(Exception e){
	        e.printStackTrace();
	    }finally{
	    	matDBUtil.close(conn,pstmt,rs);
	    }

	    return list;
	}
	
	
	// 평가단 검색 개수
	public int searchReviewerCount(String keyword){

	    int count = 0;

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql =
	        "SELECT COUNT(*) " +
	        "FROM REVIEWER_POST " +
	        "WHERE SEARCH_TEXT LIKE '%' || ? || '%'";

	    try{

	        conn = matDBUtil.getConn();

	        pstmt = conn.prepareStatement(sql);

	        pstmt.setString(1, keyword);

	        rs = pstmt.executeQuery();

	        if(rs.next()){
	            count = rs.getInt(1);
	        }

	    }catch(Exception e){
	        e.printStackTrace();
	    }finally{
	    	matDBUtil.close(conn,pstmt,rs);
	    }

	    return count;
	}	
	
}
