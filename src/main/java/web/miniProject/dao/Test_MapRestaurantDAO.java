package web.miniProject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import web.miniProject.dto.MapMarkerDTO;
import web.miniProject.dto.MapDetailDTO;
import web.miniProject.util.matDBUtil;

public class Test_MapRestaurantDAO {
	
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	private String sql = null;
	
	// 마커 목록 조회
	public List<MapMarkerDTO> getMarkerList() {

	    List<MapMarkerDTO> list = new ArrayList<>();
	    
	    try {

	        conn = matDBUtil.getConn();

	        sql =
	        		
	            "SELECT " +
	            "RP.POST_ID, " +
	            "R.NAME, " +
	            "R.LATITUDE, " +
	            "R.LONGITUDE " +
	            "FROM RESTAURANT_POST RP " +
	            "JOIN RESTAURANT_INFO R " +		// 06/22 수정
	            "ON RP.RESTAURANT_ID=R.RESTAURANT_ID";
	        		
	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();   
	        
	        while(rs.next()) {
	            MapMarkerDTO dto = new MapMarkerDTO();

	            dto.setPostId(rs.getInt("POST_ID"));
	            dto.setName(rs.getString("NAME"));
	            dto.setLatitude(rs.getDouble("LATITUDE"));
	            dto.setLongitude(rs.getDouble("LONGITUDE"));

	            list.add(dto);
	        }
	        
	    } catch(Exception e) {
	    	System.out.println("exception 진입");
	        e.printStackTrace();
	    }
	    return list;
	}
	
	
	// 상세 조회
	public MapDetailDTO getMapDetail(int postId) {

		    MapDetailDTO dto = null;

		    try {

		        conn = matDBUtil.getConn();

		        sql =
		            "SELECT " +

		            "RP.POST_ID, " +

		            "R.NAME, " +
		            "R.PHONE, " +
		            "R.TIME, " +
		            "R.ADDRESS1, " +
		            "R.ADDRESS2, " +

					"RI.FILE_NAME, " +
					
//					"(SELECT COUNT(*) " +
//					" FROM RESTAURANT_POST_LIKE RL " +
//					" WHERE RL.POST_ID = RP.POST_ID) AS LIKE_CNT, " +
					
//					"(SELECT COUNT(*) " +
//					" FROM RESTAURANT_BOOKMARK RB " +
//					" WHERE RB.POST_ID = RP.POST_ID) AS BOOKMARK_CNT, " +
					
					"RP.LIKE_CNT, " +
					"RP.BOOKMARK_CNT, " +
					
					//💡 [정확한 별점 반영] 삭제되지 않고, 별점이 부여된 댓글들만 평균 계산 (없으면 0 처리)
					"(SELECT NVL(AVG(STAR_SCORE), 0) " +
					" FROM RESTAURANT_COMMENT RC " +
					" WHERE RC.POST_ID = RP.POST_ID " +
					"   AND RC.DELETE_YN = 'N' " +
					"   AND RC.STAR_SCORE IS NOT NULL) AS RATING_AVG, " +

					"LISTAGG(T.TAG_NAME, ',') " +
					"WITHIN GROUP " +
					"(ORDER BY T.TAG_NAME) TAGS " +

		            "FROM RESTAURANT_POST RP " +

		            "JOIN RESTAURANT_INFO R " +
		            "ON RP.RESTAURANT_ID=R.RESTAURANT_ID " +

		            "LEFT JOIN RESTAURANT_IMAGE RI " +
		            "ON RP.POST_ID=RI.POST_ID " +
		            "AND RI.IS_THUMBNAIL='Y' " +

		            "LEFT JOIN RESTAURANT_POST_TAG RPT " +
		            "ON RP.POST_ID=RPT.POST_ID " +

		            "LEFT JOIN TAG T " +
		            "ON RPT.TAG_ID=T.TAG_ID " +

		            "WHERE RP.POST_ID=? " +

		            "GROUP BY " +
		            "RP.POST_ID, " +
		            "R.NAME, " +
		            "R.PHONE, " +
		            "R.TIME, " +
		            "R.ADDRESS1, " +
		            "R.ADDRESS2, " +
		            "RI.FILE_NAME, " +
		            "RP.LIKE_CNT, " +
					"RP.BOOKMARK_CNT ";

		        pstmt = conn.prepareStatement(sql);

		        pstmt.setInt(1, postId);

		        rs = pstmt.executeQuery();

		        if(rs.next()) {

		            dto =
		                new MapDetailDTO();

		            dto.setPostId(postId);

		            dto.setRestaurantName(
		                rs.getString("NAME")
		            );

		            dto.setPhone(
		                rs.getString("PHONE")
		            );

		            dto.setTime(
		                rs.getString("TIME")
		            );

		            dto.setAddress1(
		                rs.getString("ADDRESS1")
		            );

		            dto.setAddress2(
		                rs.getString("ADDRESS2")
		            );

		            dto.setThumbnail(
		                rs.getString("FILE_NAME")
		            );

		            dto.setTags(
		                rs.getString("TAGS")
		            );
		            
		            dto.setLikeCnt(
	            	    rs.getInt("LIKE_CNT")
	            	);

	            	dto.setBookmarkCnt(
	            	    rs.getInt("BOOKMARK_CNT")
	            	);
	            	
	            	// 💡 완성된 RATING_AVG 결과를 DTO에 바인딩
	                dto.setRating(
	                		rs.getDouble("RATING_AVG"));
		        }

		    } catch(Exception e) {
		        e.printStackTrace();
		    }

		    return dto;
		}
	
}
