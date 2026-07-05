package web.miniProject.dao;

import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import web.miniProject.dto.MyPagePostDTO;
import web.miniProject.dto.CommentDTO;
import web.miniProject.util.matDBUtil;

public class MyPostSearchDAO {
	
	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	private String sql = null;
	
	// 내가 좋아요 한 글 목록
	public ArrayList<MyPagePostDTO> myLikePost(int member_id, int start, int end){
		ArrayList<MyPagePostDTO> list = new ArrayList<MyPagePostDTO>();
		
		try {
			conn = matDBUtil.getConn();
			sql =
			    "SELECT * " +
			    "FROM ( " +
			    "    SELECT ROW_NUMBER() OVER(ORDER BY REG_DATE DESC) RN, A.* " +
			    "    FROM ( " +
			    // 맛집글
			    "        SELECT " +
			    "            RP.POST_ID, " +
			    "            'RESTAURANT' AS POST_TYPE, " +
			    "            RP.TITLE, " +
			    "            M.NICKNAME AS WRITER, " +
			    "            RI.FILE_NAME AS THUMBNAIL, " +
			    "            RP.LIKE_CNT, " +
			    "            RP.BOOKMARK_CNT, " +
			    "            ( " +
			    "                SELECT COUNT(*) " +
			    "                FROM RESTAURANT_COMMENT RC " +
			    "                WHERE RC.POST_ID = RP.POST_ID " +
			    "                AND RC.DELETE_YN = 'N' " +
			    "            ) AS COMMENT_CNT, " +
			    "            RP.REG_DATE " +
			    "        FROM RESTAURANT_POST_LIKE L " +
			    "        JOIN RESTAURANT_POST RP " +
			    "            ON L.POST_ID = RP.POST_ID " +
			    "        JOIN MEMBER M " +
			    "            ON RP.MEMBER_ID = M.MEMBER_ID " +
			    "        LEFT JOIN RESTAURANT_IMAGE RI " +
			    "            ON RP.POST_ID = RI.POST_ID " +
			    "           AND RI.IS_THUMBNAIL = 'Y' " +
			    "        WHERE L.MEMBER_ID = ? " +
			    "          AND RP.DELETE_YN = 'N' " +

			    "        UNION ALL " +

			    // 평가단글
			    "        SELECT " +
			    "            RP.POST_ID, " +
			    "            'REVIEWER' AS POST_TYPE, " +
			    "            RP.TITLE, " +
			    "            M.NICKNAME AS WRITER, " +
			    "            RI.FILE_NAME AS THUMBNAIL, " +
			    "            RP.LIKE_CNT, " +
			    "            RP.BOOKMARK_CNT, " +
			    "            0 AS COMMENT_CNT, " +
			    "            RP.REG_DATE " +
			    "        FROM REVIEWER_POST_LIKE L " +
			    "        JOIN REVIEWER_POST RP " +
			    "            ON L.POST_ID = RP.POST_ID " +
			    "        JOIN MEMBER M " +
			    "            ON RP.MEMBER_ID = M.MEMBER_ID " +
			    "        LEFT JOIN REVIEWER_IMAGE RI " +
			    "            ON RP.POST_ID = RI.POST_ID " +
			    "           AND RI.IS_THUMBNAIL = 'Y' " +
			    "        WHERE L.MEMBER_ID = ? " +

			    "    ) A " +
			    ") " +
			    "WHERE RN BETWEEN ? AND ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, member_id);	// 맛집
			pstmt.setInt(2, member_id); // 평가단
			pstmt.setInt(3, start);	// 페이징 
			pstmt.setInt(4, end); // 페이징
			
			rs = pstmt.executeQuery();
			while(rs.next()) {
				MyPagePostDTO dto = new MyPagePostDTO();
				dto.setPost_id(rs.getInt("post_id"));
				dto.setPost_type(rs.getString("post_type"));
				dto.setTitle(rs.getString("title"));
				dto.setWriter(rs.getString("writer"));
				dto.setThumbnail(rs.getString("thumbnail"));
				dto.setLike_cnt(rs.getInt("like_cnt"));
				dto.setBookmark_cnt(rs.getInt("bookmark_cnt"));
				dto.setComment_cnt(rs.getInt("comment_cnt"));
				
				list.add(dto);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return list;
	}
	
	// 내가 좋아요 한 글의 수
	public int myLikePostCount(int member_id) {
		int result = 0;
		
		try {
			conn = matDBUtil.getConn();
			sql =
			    "SELECT COUNT(*) " +
			    "FROM ( " +

			    "    SELECT RP.POST_ID " +
			    "    FROM RESTAURANT_POST_LIKE L " +
			    "    JOIN RESTAURANT_POST RP " +
			    "      ON L.POST_ID = RP.POST_ID " +
			    "    WHERE L.MEMBER_ID = ? " +
			    "      AND RP.DELETE_YN = 'N' " +

			    "    UNION ALL " +

			    "    SELECT RP.POST_ID " +
			    "    FROM REVIEWER_POST_LIKE L " +
			    "    JOIN REVIEWER_POST RP " +
			    "      ON L.POST_ID = RP.POST_ID " +
			    "    WHERE L.MEMBER_ID = ? " +

			    ")";
			pstmt = conn.prepareStatement(sql);

			pstmt.setInt(1, member_id);
			pstmt.setInt(2, member_id);

			rs = pstmt.executeQuery();

			if(rs.next()){
			    result = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return result;
	}
	
	
	// 내가 북마크 한 글 목록
		public ArrayList<MyPagePostDTO> myBookmarkPost(int member_id, int start, int end){
			ArrayList<MyPagePostDTO> list = new ArrayList<MyPagePostDTO>();
			
			try {
				conn = matDBUtil.getConn();
				sql =
					"SELECT * " +
					"FROM ( " +
					"    SELECT ROW_NUMBER() OVER(ORDER BY REG_DATE DESC) RN, A.* " +
					"    FROM ( " +
			        // 맛집글
			        "        SELECT " +
			        "            RP.POST_ID, " +
			        "            'RESTAURANT' AS POST_TYPE, " +
			        "            RP.TITLE, " +
			        "            M.NICKNAME AS WRITER, " +
			        "            RI.FILE_NAME AS THUMBNAIL, " +
			        "            RP.LIKE_CNT, " +
			        "            RP.BOOKMARK_CNT, " +
			        "            ( " +
			        "                SELECT COUNT(*) " +
			        "                FROM RESTAURANT_COMMENT RC " +
			        "                WHERE RC.POST_ID = RP.POST_ID " +
			        "                AND RC.DELETE_YN = 'N' " +
			        "            ) AS COMMENT_CNT, " +
			        "            RP.REG_DATE " +
			        "        FROM RESTAURANT_BOOKMARK B " +
			        "        JOIN RESTAURANT_POST RP " +
			        "            ON B.POST_ID = RP.POST_ID " +
			        "        JOIN MEMBER M " +
			        "            ON RP.MEMBER_ID = M.MEMBER_ID " +
			        "        LEFT JOIN RESTAURANT_IMAGE RI " +
			        "            ON RP.POST_ID = RI.POST_ID " +
			        "           AND RI.IS_THUMBNAIL = 'Y' " +
			        "        WHERE B.MEMBER_ID = ? " +
			        "          AND RP.DELETE_YN = 'N' " +

			        "        UNION ALL " +

			        // 평가단글
			        "        SELECT " +
			        "            RP.POST_ID, " +
			        "            'REVIEWER' AS POST_TYPE, " +
			        "            RP.TITLE, " +
			        "            M.NICKNAME AS WRITER, " +
			        "            RI.FILE_NAME AS THUMBNAIL, " +
			        "            RP.LIKE_CNT, " +
			        "            RP.BOOKMARK_CNT, " +
			        "            0 AS COMMENT_CNT, " +
			        "            RP.REG_DATE " +
			        "        FROM REVIEWER_BOOKMARK B " +
			        "        JOIN REVIEWER_POST RP " +
			        "            ON B.POST_ID = RP.POST_ID " +
			        "        JOIN MEMBER M " +
			        "            ON RP.MEMBER_ID = M.MEMBER_ID " +
			        "        LEFT JOIN REVIEWER_IMAGE RI " +
			        "            ON RP.POST_ID = RI.POST_ID " +
			        "           AND RI.IS_THUMBNAIL = 'Y' " +
			        "        WHERE B.MEMBER_ID = ? " +

			        "    ) A " +
			        ") " +
			        "WHERE RN BETWEEN ? AND ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, member_id);	// 맛집
				pstmt.setInt(2, member_id); // 평가단
				pstmt.setInt(3, start);	// 페이징 
				pstmt.setInt(4, end); // 페이징
				
				rs = pstmt.executeQuery();
				while(rs.next()) {
					MyPagePostDTO dto = new MyPagePostDTO();
					dto.setPost_id(rs.getInt("post_id"));
					dto.setPost_type(rs.getString("post_type"));
					dto.setTitle(rs.getString("title"));
					dto.setWriter(rs.getString("writer"));
					dto.setThumbnail(rs.getString("thumbnail"));
					dto.setLike_cnt(rs.getInt("like_cnt"));
					dto.setBookmark_cnt(rs.getInt("bookmark_cnt"));
					dto.setComment_cnt(rs.getInt("comment_cnt"));
					list.add(dto);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				matDBUtil.close(conn, pstmt, rs);
			}
			return list;
		}
		
		// 내가 북마크 한 글의 수
		public int myBookmarkPostCount(int member_id) {
			int result = 0;
			
			try {
				conn = matDBUtil.getConn();
				sql =
				    "SELECT COUNT(*) " +
				    "FROM ( " +

				    "    SELECT RP.POST_ID " +
				    "    FROM RESTAURANT_BOOKMARK B " +
				    "    JOIN RESTAURANT_POST RP " +
				    "      ON B.POST_ID = RP.POST_ID " +
				    "    WHERE B.MEMBER_ID = ? " +
				    "      AND RP.DELETE_YN = 'N' " +

				    "    UNION ALL " +

				    "    SELECT RP.POST_ID " +
				    "    FROM REVIEWER_BOOKMARK B " +
				    "    JOIN REVIEWER_POST RP " +
				    "      ON B.POST_ID = RP.POST_ID " +
				    "    WHERE B.MEMBER_ID = ? " +

				    ")";
				pstmt = conn.prepareStatement(sql);

				pstmt.setInt(1, member_id);
				pstmt.setInt(2, member_id);

				rs = pstmt.executeQuery();

				if(rs.next()){
				    result = rs.getInt(1);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				matDBUtil.close(conn, pstmt, rs);
			}
			return result;
		}
	
	
		
		// 내가 쓴 댓글 목록
		public ArrayList<CommentDTO> myCommentList(int member_id, int start, int end){
			ArrayList<CommentDTO> list = new ArrayList<CommentDTO>();
			
			try {
				conn = matDBUtil.getConn();
				sql =
					"SELECT * " +
				    "FROM ( " +
				    "    SELECT ROW_NUMBER() OVER(ORDER BY RC.REG_DATE DESC) RN, " +
				    "           RC.COMMENT_ID, " +
				    "           RC.POST_ID, " +
				    "           RC.CONTENT, " +
				    "           RC.REG_DATE, " +
				    "           RP.TITLE, " +
				    "           M.NICKNAME AS WRITER " +
				    "    FROM RESTAURANT_COMMENT RC " +
				    "    JOIN RESTAURANT_POST RP " +
				    "      ON RC.POST_ID = RP.POST_ID " +
				    "    JOIN MEMBER M " +
				    "      ON RP.MEMBER_ID = M.MEMBER_ID " +
				    "    WHERE RC.MEMBER_ID = ? " +
				    "      AND RC.DELETE_YN = 'N' " +
				    "      AND RP.DELETE_YN = 'N' " +
				    ") " +
				    "WHERE RN BETWEEN ? AND ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, member_id);
				pstmt.setInt(2, start);	// 페이징 
				pstmt.setInt(3, end); // 페이징
				
				rs = pstmt.executeQuery();
				while(rs.next()) {
					CommentDTO dto = new CommentDTO();
					dto.setComment_id(rs.getInt("comment_id"));
					dto.setPost_id(rs.getInt("post_id"));
					dto.setContent(rs.getString("content"));
					dto.setReg_date(rs.getString("reg_date"));
					dto.setPost_title(rs.getString("title"));
					dto.setNickname(rs.getString("writer"));
					
					list.add(dto);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				matDBUtil.close(conn, pstmt, rs);
			}
			return list;
		}
		
		// 내가 쓴 댓글의 수
		public int myCommentCount(int member_id) {
			int result = 0;
			
			try {
				conn = matDBUtil.getConn();
				sql =
				    "SELECT COUNT(*) " +
		    	    "FROM RESTAURANT_COMMENT RC " +
		    	    "JOIN RESTAURANT_POST RP " +
		    	    "  ON RC.POST_ID = RP.POST_ID " +
		    	    "WHERE RC.MEMBER_ID = ? " +
		    	    "  AND RC.DELETE_YN = 'N' " +
		    	    "  AND RP.DELETE_YN = 'N'";
				pstmt = conn.prepareStatement(sql);

				pstmt.setInt(1, member_id);

				rs = pstmt.executeQuery();

				if(rs.next()){
				    result = rs.getInt(1);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				matDBUtil.close(conn, pstmt, rs);
			}
			return result;
		}
		
		
		
		// 내가 쓴 글 목록(평가단)
		public ArrayList<MyPagePostDTO> myReviewerPostList(int member_id, int start, int end){
			ArrayList<MyPagePostDTO> list = new ArrayList<MyPagePostDTO>();
			
			try {
				conn = matDBUtil.getConn();
				sql =
					"SELECT * " +
				    "FROM ( " +
				    "    SELECT ROW_NUMBER() OVER(ORDER BY RP.REG_DATE DESC) RN, " +
				    "           RP.POST_ID, " +
				    "           RP.TITLE, " +
				    "           M.NICKNAME AS WRITER, " +
				    "           RI.FILE_NAME AS THUMBNAIL, " +
				    "           RP.LIKE_CNT, " +
				    "           RP.BOOKMARK_CNT, " +
				    "           RP.STATUS, " +
				    "           RP.REG_DATE " +
				    "    FROM REVIEWER_POST RP " +
				    "    JOIN MEMBER M " +
				    "      ON RP.MEMBER_ID = M.MEMBER_ID " +
				    "    LEFT JOIN REVIEWER_IMAGE RI " +
				    "      ON RP.POST_ID = RI.POST_ID " +
				    "     AND RI.IS_THUMBNAIL = 'Y' " +
				    "    WHERE RP.MEMBER_ID = ? " +
				    ") " +
				    "WHERE RN BETWEEN ? AND ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setInt(1, member_id);
				pstmt.setInt(2, start);	// 페이징 
				pstmt.setInt(3, end); // 페이징
				
				rs = pstmt.executeQuery();
				while(rs.next()) {
					MyPagePostDTO dto = new MyPagePostDTO();
					
					dto.setPost_id(rs.getInt("post_id"));
					dto.setTitle(rs.getString("title"));
					dto.setWriter(rs.getString("writer"));
					dto.setThumbnail(rs.getString("thumbnail"));
					dto.setLike_cnt(rs.getInt("like_cnt"));
					dto.setBookmark_cnt(rs.getInt("bookmark_cnt"));
					dto.setStatus(rs.getString("status"));
					dto.setReg_date(rs.getString("reg_date"));
					
					list.add(dto);
				}
				
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				matDBUtil.close(conn, pstmt, rs);
			}
			return list;
		}
		
		// 내가 작성한 글의 수(평가단)
		public int myReviewerPostCount(int member_id) {
			int result = 0;
			
			try {
				conn = matDBUtil.getConn();
				sql =
				    "SELECT COUNT(*) " +
		    	    "FROM REVIEWER_POST " +
		    	    "WHERE MEMBER_ID = ?";
				pstmt = conn.prepareStatement(sql);

				pstmt.setInt(1, member_id);

				rs = pstmt.executeQuery();

				if(rs.next()){
				    result = rs.getInt(1);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
				matDBUtil.close(conn, pstmt, rs);
			}
			return result;
		}
	
}
