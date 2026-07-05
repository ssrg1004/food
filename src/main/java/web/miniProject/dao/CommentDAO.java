package web.miniProject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import web.miniProject.dto.CommentDTO;
import web.miniProject.util.matDBUtil;

public class CommentDAO {

	private Connection conn = null;
	private PreparedStatement pstmt = null;
	private ResultSet rs = null;
	private String sql = null;
    private String tst =null;
	private Integer integ = 0;
	
	// 내가 쓴 댓글 전체 개수 조회(삭제댓글 제외)
	public int myComment_count(int member_id) {
		int result = 0;
		try {
			conn = matDBUtil.getConn();
			sql = "select count(*) " + 
					" from restaurant_comment " + 
					" where member_id=? and delete_yn='N'";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, member_id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return result;
	}
	
	// 특정 맛집에서의 내 댓글 순번 찾기(마이페이지 - 내 댓글 누르면 맛집정보에서 내 댓글 바로 보이도록)
	public int myCommentOrder(int post_id, int comment_id) {
		int root_comment_id = 0;
		int result = 0;
		try {
			conn = matDBUtil.getConn();
			
			// 부모댓글 id 구하기
			sql = "select nvl(parent_id, comment_id) as root_comment_id " +
			      "from restaurant_comment " +
			      "where comment_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, comment_id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				root_comment_id = rs.getInt(1);
			}
			
			sql = 
				"select count(*) + 1 as comment_order " +
				"from restaurant_comment " +
				"where post_id = ? " +
				"  and delete_yn = 'N' " +
				"  and parent_id is null " +
				"  and comment_id < ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, post_id);
			pstmt.setInt(2, comment_id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return result;
	}

	// 내가 쓴 댓글 목록 불러오기(삭제댓글 제외)
	public List<CommentDTO> getMyCommentList(int member_id, int startRow, int endRow) {

	    List<CommentDTO> list = new ArrayList<CommentDTO>();

	    try {
	        conn = matDBUtil.getConn();
	        sql = "select * from ( " +
        	      "    select " +
        	      "        row_number() over (order by comment_id desc) rn, " +
        	      "        c.*, " +
        	      "        m.nickname, " +
        	      "        p.title " +
        	      "    from restaurant_comment c " +
        	      "    inner join member m " +
        	      "        on c.member_id = m.member_id " +
        	      "    inner join restaurant_post p " +
        	      "        on c.post_id = p.post_id " +
        	      "    where c.member_id=? and c.delete_yn='N' " +
        	      ") " +
        	      "where rn between ? and ?";

	        pstmt = conn.prepareStatement(sql);

	        pstmt.setInt(1, member_id);
	        pstmt.setInt(2, startRow);
	        pstmt.setInt(3, endRow);

	        rs = pstmt.executeQuery();

	        while(rs.next()) {
	            CommentDTO dto = new CommentDTO();

	            dto.setComment_id(rs.getInt("comment_id"));
	            dto.setPost_id(rs.getInt("post_id"));
	            dto.setMember_id(rs.getInt("member_id"));
	            dto.setParent_id((Integer)rs.getObject("parent_id"));
	            dto.setContent(rs.getString("content"));
	            dto.setStar_score(rs.getInt("star_score"));
	            dto.setDelete_yn(rs.getString("delete_yn"));
	            dto.setStatus(rs.getString("status"));
	            dto.setReg_date(rs.getString("reg_date"));
	            dto.setNickname(rs.getString("nickname"));
	            dto.setPost_title(rs.getString("title"));
	            list.add(dto);
	        }

	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn,pstmt,rs);
	    }
	    return list;
	}
	
	// 부모 댓글 개수 조회
	public int comment_count(int post_id) {
		int result = 0;
		Connection conn = null;
		try {
			conn = matDBUtil.getConn();
			sql = "select count(*) " + 
					" from restaurant_comment " + 
					" where post_id=? and parent_id is null and delete_yn='N'";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, post_id);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				result = rs.getInt(1);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return result;
	}
	
	// 부모 댓글 목록 불러오기
	public List<CommentDTO> getCommentList(int post_id, int startRow, int endRow) {

	    List<CommentDTO> list = new ArrayList<CommentDTO>();

	    try {
	        conn = matDBUtil.getConn();
	        sql = "select * from ( " +
        	      "    select " +
        	      "        row_number() over (order by comment_id desc) rn, " +
        	      "        c.*, " +
        	      "        m.nickname " +
        	      "    from restaurant_comment c " +
        	      "    inner join member m " +
        	      "        on c.member_id = m.member_id " +
        	      "    where c.post_id=? and c.parent_id is null and c.delete_yn='N' " +
        	      ") " +
        	      "where rn between ? and ?";

	        pstmt = conn.prepareStatement(sql);

	        pstmt.setInt(1, post_id);
	        pstmt.setInt(2, startRow);
	        pstmt.setInt(3, endRow);

	        rs = pstmt.executeQuery();

	        while(rs.next()) {
	            CommentDTO dto = new CommentDTO();

	            dto.setComment_id(rs.getInt("comment_id"));
	            dto.setPost_id(rs.getInt("post_id"));
	            dto.setMember_id(rs.getInt("member_id"));
	            dto.setParent_id((Integer)rs.getObject("parent_id"));
	            dto.setContent(rs.getString("content"));
	            dto.setStar_score(rs.getInt("star_score"));
	            dto.setDelete_yn(rs.getString("delete_yn"));
	            dto.setStatus(rs.getString("status"));
	            dto.setReg_date(rs.getString("reg_date"));
	            dto.setNickname(rs.getString("nickname"));
	            list.add(dto);
	        }

	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn,pstmt,rs);
	    }
	    return list;
	}
	
	// 댓댓글 불러오기
	public List<CommentDTO> getReplyList(int parent_id) {

	    List<CommentDTO> list =new ArrayList<CommentDTO>();

	    try {
	        conn = matDBUtil.getConn();
	        sql = "select c.*, m.nickname" +
	        	      " from restaurant_comment c" +
	        	      " inner join member m" +
	        	      "     on c.member_id = m.member_id " +
	        	      " where c.parent_id = ? " +
	        	      " and c.delete_yn = 'N' " +
	        	      " order by c.comment_id desc";
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1,parent_id);
	        rs = pstmt.executeQuery();

	        while(rs.next()) {
	            CommentDTO dto = new CommentDTO();
	            dto.setComment_id(rs.getInt("comment_id"));
	            dto.setPost_id(rs.getInt("post_id"));
	            dto.setMember_id(rs.getInt("member_id"));
	            dto.setParent_id(rs.getInt("parent_id"));
	            dto.setContent( rs.getString("content"));
	            dto.setDelete_yn(rs.getString("delete_yn"));
	            dto.setStatus(rs.getString("status"));
	            dto.setReg_date(rs.getString("reg_date"));
	            dto.setNickname(rs.getString("nickname"));
	            list.add(dto);
	        }

	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn,pstmt,rs);
	    }
	    return list;
	}
	
	// 댓글 등록
	public int insertComment(CommentDTO dto) {
	    int result = 0;

	    try {
	        conn = matDBUtil.getConn();
	        sql = "insert into restaurant_comment " +
	        	      " (comment_id, post_id, member_id, parent_id, content, star_score) " +
	        	      " values (comment_seq.nextval, ?, ?, ?, ?, ?)";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1,dto.getPost_id());
	        pstmt.setInt(2,dto.getMember_id());
	        if(dto.getParent_id() == null){
	            pstmt.setNull(3, java.sql.Types.NUMERIC);
	        }else{
	            pstmt.setInt(3, dto.getParent_id());
	        }
	        pstmt.setString(4,dto.getContent());
	        pstmt.setInt(5,dto.getStar_score());

	        result = pstmt.executeUpdate();

	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn, pstmt, rs);
	    }
	    return result;
	}
	// 답글 등록
	public int insertReply(CommentDTO dto) {
	    int result = 0;

	    try {
	        conn = matDBUtil.getConn();
	        sql = "insert into restaurant_comment " +
	        	      " (comment_id, post_id, member_id, parent_id, content) " +
	        	      " values (comment_seq.nextval, ?, ?, ?, ?)";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1,dto.getPost_id());
	        pstmt.setInt(2,dto.getMember_id());
	        pstmt.setObject(3,dto.getParent_id());
	        pstmt.setString(4,dto.getContent());

	        result =  pstmt.executeUpdate();

	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn, pstmt, rs);
	    }

	    return result;
	}
	
	// 댓글 수정
	public int updateComment(CommentDTO dto) {
	    int result = 0;

	    try {
	        conn = matDBUtil.getConn();
	        sql =
	            "update restaurant_comment " +
	            " set content=? " +
	            " where comment_id=?" +
	            " and member_id=?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1,dto.getContent());
	        pstmt.setInt(2,dto.getComment_id());
	        pstmt.setInt(3, dto.getMember_id());

	        result = pstmt.executeUpdate();

	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn, pstmt, rs);
	    }
	    return result;
	}
	
	// 댓글 삭제
	public int deleteComment(int comment_id, int member_id) {
	    int result = 0;

	    try {
	        conn = matDBUtil.getConn();
	        sql =
	            "update restaurant_comment " +
	            " set delete_yn='Y' " +
	            " where comment_id=? " +
	        	" and member_id=?";
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1,comment_id);
	        pstmt.setInt(2, member_id);
	        result = pstmt.executeUpdate();
	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn, pstmt, rs);
	    }
	    return result;
	}
	
	// 댓글 신고여부
	public boolean isReported(int comment_id, int reporter_id){

	    boolean result = false;

	    try{
	        conn = matDBUtil.getConn();

	        sql =
	            "SELECT COUNT(*) " +
	            "FROM COMMENT_REPORT " +
	            "WHERE COMMENT_ID=? AND REPORTER_ID=?";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, comment_id);
	        pstmt.setInt(2, reporter_id);

	        rs = pstmt.executeQuery();

	        if(rs.next()){
	            result = rs.getInt(1) > 0;
	        }
	    }catch(Exception e){
	        e.printStackTrace();
	    }

	    return result;
	}
	
	// 댓글 신고
	public int reportComment(int comment_id, int reporter_id, String reason) {
		int result = 0;
		
		try {
			conn = matDBUtil.getConn();
			sql = "insert into comment_report " +  
					" (report_id, comment_id, reporter_id, reason) " +
					" values(report_seq.nextval, ?, ?, ?) ";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, comment_id);
		    pstmt.setInt(2, reporter_id);
		    pstmt.setString(3, reason);
			
		    result = pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
	        matDBUtil.close(conn, pstmt, rs);
	    }
		
		return result;
	}
	
	// 관리자페이지 - 댓글 신고 목록 조회  (06/19)
		public List<CommentDTO> getAdminReportList(String searchKeyword) {
			List<CommentDTO> list = new ArrayList<CommentDTO>();
			
			try {
				conn = matDBUtil.getConn();
				
				// 조인을 통해 신고 정보, 원본 댓글 본문, 댓글 작성자(m1) 닉네임, 신고자(m2) 닉네임을 가져옵니다.
				// 여기서는 화면 매핑 편의를 위해 신고번호를 comment_id에, 신고자 닉네임을 post_title 필드 등에 임시 매핑하여 활용합니다.
				sql = "select " +
					  "    r.comment_id, " +
					  "    r.reason, " +
					  "    c.content, " +
					  "    c.post_id, " +
					  "    r.process_yn, " +
					  "    m1.nickname as writer_nickname, " +
					  "    m2.nickname as reporter_nickname " +
					  "from comment_report r " +
					  "inner join restaurant_comment c on r.comment_id = c.comment_id " +
					  "inner join member m1 on c.member_id = m1.member_id " + // 댓글 작성자
					  "inner join member m2 on r.reporter_id = m2.member_id " +// 신고자
					  "where c.delete_yn = 'N' ";
				
				if (searchKeyword != null && !searchKeyword.trim().equals("")) {
					sql += "where r.reason like ? or c.content like ? ";
					sql += "order by r.report_id desc";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, "%" + searchKeyword + "%");
					pstmt.setString(2, "%" + searchKeyword + "%");
				} else {
					sql += "order by r.report_id desc";
					pstmt = conn.prepareStatement(sql);
				}
				
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					CommentDTO dto = new CommentDTO();
					// 기존 DTO 필드를 활용하여 신고 데이터 바인딩
					dto.setComment_id(rs.getInt("comment_id"));       // [팁] 신고번호를 여기에 담음
					dto.setStatus(rs.getString("reason"));           // [팁] 신고사유를 여기에 담음
					dto.setContent(rs.getString("content"));         // 댓글 내용
					dto.setNickname(rs.getString("writer_nickname")); // 작성자 닉네임
					dto.setPost_title(rs.getString("reporter_nickname")); // [팁] 신고자 닉네임을 여기에 임시 저장
					dto.setPost_id(rs.getInt("post_id"));
					dto.setProcess_yn(rs.getString("process_yn"));
					
					list.add(dto);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				matDBUtil.close(conn, pstmt, rs);
			}
			return list;
		}
		
		//06/22 추가
		// CommentDAO.java 클래스 내부에 추가할 메서드
		public int processReport(int comment_id, String type) {
			System.out.println("processReport : comment_id =  " + comment_id);
			System.out.println("processReport : type =  " + type);
			
		    Connection conn = null;
		    PreparedStatement pstmt = null;
		    PreparedStatement pstmt2 = null;
		    String sql = "";
		    String sql2 = "";
		    int result = 0;
		    try {
		        conn = matDBUtil.getConn(); // 본인의 Connection 커넥션 가져오는 메서드명으로 맞추세요.
		        conn.setAutoCommit(false);
		        
		        if("delete".equals(type)) {
		        	System.out.println("processReport : if (delete) ");
		            // [삭제] 요청 시: 서브쿼리 제거하고 직접 comment_id로 댓글 삭제(status/delete_yn 변경)
		            sql = "update restaurant_comment set status = 'Y' where comment_id = ?";
		            
		            // [신고 테이블]: 이 댓글에 들어온 모든 신고를 일괄 처리 완료('Y')로 변경
		            sql2 = "update comment_report set process_yn = 'Y' where comment_id = ?";
		            
		        } else if("reject".equals(type)) {
		            // [반려] 요청 시: 이 댓글에 들어온 모든 신고 내역을 신고 테이블에서 삭제
		            sql = "delete from comment_report where comment_id = ?";
		        }
		        
		        // 첫 번째 쿼리 실행
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setInt(1, comment_id);
		        result = pstmt.executeUpdate(); 
		        System.out.println("processReport : result =  "+result);
		        // delete일 때 두 번째 쿼리 실행
		        if ("delete".equals(type)) {
		            pstmt2 = conn.prepareStatement(sql2);
		            pstmt2.setInt(1, comment_id);
		            result = pstmt2.executeUpdate();
		            System.out.println("processReport : result2 =  "+result);
		        }
		        
		        // 트랜잭션 정상 종료 시 커밋
		        conn.commit();
		        
		    } catch(Exception e) {
		        if (conn != null) {
		            try { conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
		        }
		        e.printStackTrace();
		        result = 0;
		    } finally {
		        // 변수 컴파일 에러 예방을 위해 각각 안전하게 close
		        if (pstmt2 != null) try { pstmt2.close(); } catch (Exception e) {}
		        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
		        if (conn != null) try { conn.close(); } catch (Exception e) {}
		    }
		    return result;
		}
}
