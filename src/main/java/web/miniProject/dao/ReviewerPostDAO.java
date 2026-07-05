package web.miniProject.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import web.miniProject.dto.MemberDTO;
import web.miniProject.dto.ReviewerDraftDTO;
import web.miniProject.dto.ReviewerPostDTO;
import web.miniProject.dto.ReviewerImageDTO;
import web.miniProject.util.matDBUtil;

public class ReviewerPostDAO {
	
    private static ReviewerPostDAO instance = new ReviewerPostDAO();

    public static ReviewerPostDAO getInstance() {
        return instance;
    }

    private ReviewerPostDAO() {}

    /* ======================================================
       1. 게시글 수(승인된 게시글 개수)
    ====================================================== */
    public int getCount(String keyword){

        int count = 0;

        String sql =
                "SELECT COUNT(*) " +
                "FROM reviewer_post p " +
                "JOIN member m ON p.member_id = m.member_id " +
                "WHERE p.status != 'DELETED' ";

        if(keyword != null && !keyword.trim().isEmpty()){
        	sql += " AND p.search_text LIKE ? ";
        }

        try(Connection conn = matDBUtil.getConn();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            if(keyword != null && !keyword.trim().isEmpty()){
                String k = "%" + keyword + "%";
                pstmt.setString(1, k);
            }

            try(ResultSet rs = pstmt.executeQuery()){
                if(rs.next()){
                    count = rs.getInt(1);
                }
            }

        } catch(Exception e){
            e.printStackTrace();
        }

        return count;
    }

    /* ======================================================
       2. 리스트(게시글 목록) 
    ====================================================== */
    public ArrayList<ReviewerPostDTO> getList(
            int startRow,
            int endRow,
            String sort,
            MemberDTO loginUser,
            String keyword){

        ArrayList<ReviewerPostDTO> list = new ArrayList<>();

        String orderBy = "p.reg_date DESC";

        if("like".equals(sort))
            orderBy = "like_cnt DESC, p.reg_date DESC";
        else if("view".equals(sort))
            orderBy = "p.view_cnt DESC, p.reg_date DESC";
        else if("bookmark".equals(sort))
            orderBy = "bookmark_cnt DESC, p.reg_date DESC";

        int memberId = (loginUser != null) ? loginUser.getMember_id() : -1;

        String sql =
            "SELECT * FROM ( " +
            " SELECT p.post_id, p.member_id, p.title, " +
            " p.zipcode, p.address1, p.address2, " +
            " p.view_cnt, p.reg_date, " +
            " m.nickname, " +

            // thumbnail
            " (SELECT file_name FROM reviewer_image ri " +
            "  WHERE ri.post_id = p.post_id AND is_thumbnail='Y' AND ROWNUM=1) thumbnail, " +
/*
            // 좋아요 개수
            " (SELECT COUNT(*) FROM reviewer_post_like l " +
            "  WHERE l.post_id = p.post_id) like_cnt, " +
			
            // 북마크 개수
            " (SELECT COUNT(*) FROM reviewer_bookmark b " +
            "  WHERE b.post_id = p.post_id) bookmark_cnt, " +
*/
			"  p.like_cnt, " +
			"  p.bookmark_cnt, " +
            // 내가 눌렀는지
            " (SELECT COUNT(*) FROM reviewer_post_like l2 " +
            "  WHERE l2.post_id = p.post_id AND l2.member_id = ?) liked, " +

            " (SELECT COUNT(*) FROM reviewer_bookmark b2 " +
            "  WHERE b2.post_id = p.post_id AND b2.member_id = ?) bookmarked, " +

            " ROW_NUMBER() OVER(ORDER BY " + orderBy + ") rn " +

            " FROM reviewer_post p " +
            " JOIN member m ON p.member_id = m.member_id " +
            " WHERE p.status != 'DELETED' ";

        if(keyword != null && !keyword.trim().isEmpty()){
        	sql += " AND p.search_text LIKE ? ";
        }

        sql += ") WHERE rn BETWEEN ? AND ?";

        try(Connection conn = matDBUtil.getConn();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            int idx = 1;

            pstmt.setInt(idx++, memberId);
            pstmt.setInt(idx++, memberId);

            if(keyword != null && !keyword.trim().isEmpty()){
                String k = "%" + keyword + "%";
                pstmt.setString(idx++, k);
            }

            pstmt.setInt(idx++, startRow);
            pstmt.setInt(idx++, endRow);

            try(ResultSet rs = pstmt.executeQuery()){
                while(rs.next()){
                    ReviewerPostDTO dto = new ReviewerPostDTO();

                    dto.setPost_id(rs.getInt("post_id"));
                    dto.setTitle(rs.getString("title"));
                    dto.setNickname(rs.getString("nickname"));

                    dto.setZipcode(rs.getString("zipcode"));
                    dto.setAddress1(rs.getString("address1"));
                    dto.setAddress2(rs.getString("address2"));

                    dto.setView_cnt(rs.getInt("view_cnt"));
                    dto.setLike_cnt(rs.getInt("like_cnt"));
                    dto.setBookmark_cnt(rs.getInt("bookmark_cnt"));

                    dto.setReg_date(rs.getDate("reg_date"));

                    dto.setThumbnail(rs.getString("thumbnail"));

                    dto.setLiked(rs.getInt("liked") > 0);
                    dto.setBookmarked(rs.getInt("bookmarked") > 0);

                    list.add(dto);
                }
            }

        } catch(Exception e){
            e.printStackTrace();
        }

        return list;
    }
    /* ======================================================
       3. 게시글 상세 조회
    ====================================================== */
    public ReviewerPostDTO getDetail(int postId, MemberDTO loginUser){

        ReviewerPostDTO dto = null;

        int memberId = (loginUser == null) ? -1 : loginUser.getMember_id();

        String sql = 
        	    "SELECT p.post_id, p.member_id, p.title, p.search_text, p.zipcode, p.address1, " +
        	    "       p.address2, p.view_cnt, p.reg_date, m.nickname, " +
        	    "       (SELECT file_name FROM reviewer_image ri WHERE ri.post_id = p.post_id AND is_thumbnail='Y' AND ROWNUM=1) as thumbnail, " +
        	    "       (SELECT COUNT(*) FROM reviewer_post_like l WHERE l.post_id = p.post_id) as like_cnt, " +
        	    "       (SELECT COUNT(*) FROM reviewer_bookmark b WHERE b.post_id = p.post_id) as bookmark_cnt, " +
        	    "       (SELECT COUNT(*) FROM reviewer_post_like l WHERE l.post_id = p.post_id AND l.member_id = ?) as liked, " +
        	    "       (SELECT COUNT(*) FROM reviewer_bookmark b WHERE b.post_id = p.post_id AND b.member_id = ?) as bookmarked " +
        	    "FROM reviewer_post p " +
        	    "JOIN member m ON p.member_id = m.member_id " +
        	    "WHERE p.post_id = ? AND p.status != 'DELETED'";

        try(Connection conn = matDBUtil.getConn();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, memberId);
            pstmt.setInt(2, memberId);
            pstmt.setInt(3, postId);

            try(ResultSet rs = pstmt.executeQuery()){

                if(rs.next()){
                    dto = new ReviewerPostDTO();

                    dto.setPost_id(rs.getInt("post_id"));
                    dto.setMember_id(rs.getInt("member_id"));
                    dto.setTitle(rs.getString("title"));
                    dto.setContent(rs.getString("search_text"));

                    dto.setZipcode(rs.getString("zipcode"));
                    dto.setAddress1(rs.getString("address1"));
                    dto.setAddress2(rs.getString("address2"));

                    dto.setView_cnt(rs.getInt("view_cnt"));
                    dto.setLike_cnt(rs.getInt("like_cnt"));
                    dto.setBookmark_cnt(rs.getInt("bookmark_cnt"));

                    dto.setReg_date(rs.getDate("reg_date"));
                    dto.setNickname(rs.getString("nickname"));
                    dto.setThumbnail(rs.getString("thumbnail"));

                    dto.setLiked(rs.getInt("liked") > 0);
                    dto.setBookmarked(rs.getInt("bookmarked") > 0);
                }
            }

        } catch(Exception e){
            e.printStackTrace();
        }

        return dto;
    }

    public ArrayList<ReviewerDraftDTO> getContentBlocks(int post_id){
        ArrayList<ReviewerDraftDTO> list = new ArrayList<>();
        String sql = "SELECT * FROM reviewer_content WHERE post_id = ? ORDER BY content_order ASC";

        try(Connection conn = matDBUtil.getConn();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, post_id);
            try(ResultSet rs = pstmt.executeQuery()){
                while(rs.next()){
                    ReviewerDraftDTO dto = new ReviewerDraftDTO();
                    dto.setContent_subtitle(rs.getString("content_subtitle"));
                    dto.setContent(rs.getString("content"));
                    
                    list.add(dto);
                }
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        return list;
    }
    
    public ReviewerPostDTO getPost(int post_id){

        ReviewerPostDTO dto = null;

        String sql =
                "SELECT p.draft_id, p.post_id, p.member_id, " +
                "       p.title, p.zipcode, p.address1, p.address2, " +
                "       p.request_type, p.status, p.request_date, " +
                "       m.nickname " +
                "FROM reviewer_post_draft p " +
                "JOIN member m ON p.member_id = m.member_id " +
                "WHERE p.post_id = ? " +
                "ORDER BY p.draft_id DESC FETCH FIRST 1 ROW ONLY";

        try(Connection conn = matDBUtil.getConn();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, post_id);

            try(ResultSet rs = pstmt.executeQuery()){

                if(rs.next()){

                	dto = new ReviewerPostDTO();

                    dto.setPost_id(rs.getInt("post_id"));
                    dto.setMember_id(rs.getInt("member_id"));
                    dto.setTitle(rs.getString("title"));

                    dto.setZipcode(rs.getString("zipcode"));
                    dto.setAddress1(rs.getString("address1"));
                    dto.setAddress2(rs.getString("address2"));

                    dto.setStatus(rs.getString("status"));
                    dto.setReg_date(rs.getDate("request_date"));

                    dto.setNickname(rs.getString("nickname"));
                }
            }

        } catch(Exception e){
            e.printStackTrace();
        }

        return dto;
    }
    
    public ReviewerPostDTO getPrevPost(int post_id){

        ReviewerPostDTO dto = null;

        String sql =
            "SELECT * FROM ( " +
            " SELECT post_id, title " +
            " FROM reviewer_post " +
            " WHERE post_id < ? AND status != 'DELETED' " +
            " ORDER BY post_id DESC " +
            ") WHERE ROWNUM = 1";

        try(Connection conn = matDBUtil.getConn();
            PreparedStatement pstmt = conn.prepareStatement(sql)){

            pstmt.setInt(1, post_id);

            try(ResultSet rs = pstmt.executeQuery()){

                if(rs.next()){

                    dto = new ReviewerPostDTO();

                    dto.setPost_id(rs.getInt("post_id"));
                    dto.setTitle(rs.getString("title"));
                }
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return dto;
    }
    
    public ReviewerPostDTO getNextPost(int post_id){

        ReviewerPostDTO dto = null;

        String sql =
            "SELECT * FROM ( " +
            " SELECT post_id, title " +
            " FROM reviewer_post " +
            " WHERE post_id > ? AND status != 'DELETED' " +
            " ORDER BY post_id ASC " +
            ") WHERE ROWNUM = 1";

        try(Connection conn = matDBUtil.getConn();
            PreparedStatement pstmt = conn.prepareStatement(sql)){

            pstmt.setInt(1, post_id);

            try(ResultSet rs = pstmt.executeQuery()){

                if(rs.next()){

                    dto = new ReviewerPostDTO();

                    dto.setPost_id(rs.getInt("post_id"));
                    dto.setTitle(rs.getString("title"));
                }
            }

        }catch(Exception e){
            e.printStackTrace();
        }

        return dto;
    }
    
    /* ======================================================
       4. 이미지 목록 조회
    ====================================================== */
    public ArrayList<ReviewerImageDTO> getImages(int post_id) {

        ArrayList<ReviewerImageDTO> list = new ArrayList<>();

        String sql =
            "SELECT * FROM REVIEWER_IMAGE " +
            "WHERE post_id = ? " +
            "ORDER BY image_order ASC";

        try (Connection conn = matDBUtil.getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, post_id);

            try (ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    ReviewerImageDTO dto = new ReviewerImageDTO();

                    dto.setImage_id(rs.getInt("image_id"));
                    dto.setPost_id(rs.getInt("post_id"));
                    dto.setFile_name(rs.getString("file_name"));
                    dto.setIs_thumbnail(rs.getString("is_thumbnail"));
                    dto.setImage_order(rs.getInt("image_order"));

                    list.add(dto);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    /* ======================================================
       4 + 5. getImage 와 getPost 동시에 진행 (등록한 순서대로 출력을 위한 메서드)
 	====================================================== */    
    public ArrayList<Map<String, Object>> getIntegratedContents(int postId) {
        ArrayList<Map<String, Object>> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

     // 💡 TO_CLOB 함수를 사용하여 데이터 타입을 CLOB으로 통일시켜 줍니다.
        String sql = 
            "SELECT 'IMAGE' AS TYPE, FILE_NAME AS DATA1, TO_CLOB(IS_THUMBNAIL) AS DATA2, IMAGE_ORDER AS BLOCK_ORDER " +
            "FROM REVIEWER_IMAGE WHERE POST_ID = ? " +
            "UNION ALL " +
            "SELECT 'TEXT' AS TYPE, CONTENT_SUBTITLE AS DATA1, CONTENT AS DATA2, CONTENT_ORDER AS BLOCK_ORDER " +
            "FROM REVIEWER_CONTENT WHERE POST_ID = ? " +
            "ORDER BY BLOCK_ORDER ASC";

        try {
            conn = matDBUtil.getConn();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, postId);
            pstmt.setInt(2, postId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("type", rs.getString("TYPE"));          // 'IMAGE' 또는 'TEXT'
                map.put("data1", rs.getString("DATA1"));        // FILE_NAME 또는 CONTENT_SUBTITLE
                map.put("data2", rs.getString("DATA2"));        // IS_THUMBNAIL 또는 CONTENT(CLOB)
                map.put("order", rs.getInt("BLOCK_ORDER"));     // 통합 순서 번호
                list.add(map);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            matDBUtil.close(conn, pstmt, rs);
        }
        return list;
    }   
    
    

    /* ======================================================
       5. 조회수 증가
    ====================================================== */
    public void increaseViewCnt(int post_id){
        String sql = "UPDATE reviewer_post SET view_cnt = view_cnt + 1 WHERE post_id=?";

        try(Connection conn = matDBUtil.getConn();
            PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, post_id);
            int result = pstmt.executeUpdate();
            if(result == 0){
                System.out.println("[WARNING] 조회수 증가 실패 - post_id: " + post_id);
            }
        } catch(Exception e){
             e.printStackTrace();
        }
    }

    
    
    /* ======================================================
      ✓ 6. DRAFT 게시글 등록/수정 요청 초안 (draft) 저장
    ====================================================== */
    //6-1. REVIEWER_POST_DRAFT (승인대기T) 메인 정보 저장
    public int insertDraft(Connection conn, ReviewerDraftDTO dto) throws Exception {
        int draft_id = 0;
        
        // ERD 설계서 컬럼 구조 100% 반영: region 컬럼 제거 및 주소 3종 확장 매핑
        String sql = "INSERT INTO reviewer_post_draft " +
                     "(draft_id, post_id, member_id, request_type, status, title, zipcode, address1, address2, request_date) " +
                     "VALUES (REVIEWER_POST_DRAFT_SEQ.NEXTVAL, NULL, ?, 'INSERT', 'WAIT', ?, ?, ?, ?, SYSDATE)";

        try (PreparedStatement pstmt = conn.prepareStatement(sql, new String[]{"draft_id"})) {
            pstmt.setInt(1, dto.getMember_id());
            pstmt.setString(2, dto.getTitle());
            pstmt.setString(3, dto.getZipcode());  // ZIPCODE 매핑
            pstmt.setString(4, dto.getAddress1()); // ADDRESS1 매핑
            pstmt.setString(5, dto.getAddress2()); // ADDRESS2 매핑

            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    draft_id = rs.getInt(1);
                }
            }
        }
        return draft_id;
    }

    //6-2. REVIEWER_IMAGE_DRAFT (평가단 이미지 초안) 저장
    public void insertDraftImageBlock(Connection conn,
            int draft_id,
            String fileName,
            String isThumbnail,
            int order) throws Exception {

    		String sql =
    			"INSERT INTO reviewer_image_draft " +
    			"(image_id, draft_id, file_name, is_thumbnail, image_order) " +
    			"VALUES (reviewer_image_draft_seq.NEXTVAL, ?, ?, ?, ?)";

    		try(PreparedStatement pstmt =
    				conn.prepareStatement(sql)) {

    			pstmt.setInt(1, draft_id);
    			pstmt.setString(2, fileName);
    			pstmt.setString(3, isThumbnail);
    			pstmt.setInt(4, order);

    			pstmt.executeUpdate();
    		}
    }

    //6-3. REVIEWER_CONTENT_DRAFT (평가단 내용 초안) 저장
    public void insertDraftTextBlock(Connection conn, int draft_id,
        String subtitle, String content, int order) throws Exception {

    	String sql =
			"INSERT INTO reviewer_content_draft " +
			"(content_id, draft_id, content_subtitle, content, content_order) " +
			"VALUES (REVIEWER_CONTENT_DRAFT_SEQ.NEXTVAL, ?, ?, ?, ?)";
		
		try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
		
			pstmt.setInt(1, draft_id);
			pstmt.setString(2, subtitle);
			pstmt.setString(3, content);
			pstmt.setInt(4, order);
			
			pstmt.executeUpdate();
		}
    }
    
	/* ======================================================
    기존 글에 대한 "수정 요청 초안(Draft)" 신규 생성 (INSERT)
 	====================================================== */
    public int insertUpdateDraft(Connection conn, ReviewerDraftDTO dto) throws Exception {
        int draft_id = 0;

        String sql = 
            "INSERT INTO reviewer_post_draft " +
            "(draft_id, post_id, member_id, request_type, status, title, zipcode, address1, address2, request_date) " +
            "VALUES (REVIEWER_POST_DRAFT_SEQ.NEXTVAL, ?, ?, 'UPDATE', 'WAIT', ?, ?, ?, ?, SYSDATE)";

        // 첫 번째 인자로 sql을, 두 번째 인자로 생성된 키를 리턴받겠다는 설정을 넣습니다.
        try (PreparedStatement pstmt = conn.prepareStatement(sql, new String[]{"DRAFT_ID"})) {

            pstmt.setInt(1, dto.getPost_id());
            pstmt.setInt(2, dto.getMember_id());
            pstmt.setString(3, dto.getTitle());
            pstmt.setString(4, dto.getZipcode());
            pstmt.setString(5, dto.getAddress1());
            pstmt.setString(6, dto.getAddress2());

            pstmt.executeUpdate();

            // [핵심] 별도의 SELECT CURRVAL 없이 바로 가져옵니다.
            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    draft_id = rs.getInt(1);
                }
            }
        }

        return draft_id;
    }
    
    
    /* ======================================================
    7. 게시글 DELETE 삭제 요청 및 검증
	====================================================== */

	// 이미 삭제 요청 대기 중인지 확인하는 메서드
	public boolean isAlreadyDrafted(int post_id) {
	     boolean result = false;
	     String sql = "SELECT 1 FROM reviewer_post_draft WHERE post_id=? AND status='WAIT' AND ROWNUM=1";
	
	     try (Connection conn = matDBUtil.getConn();
	          PreparedStatement pstmt = conn.prepareStatement(sql)) {
	         
	         pstmt.setInt(1, post_id);
	         try (ResultSet rs = pstmt.executeQuery()) {
	             if (rs.next()) {
	                 result = true; 
	             }
	         }
	     } catch (Exception e) {
	         e.printStackTrace();
	     }
	     return result;
	 }
	
	public void requestDeleteDraft(int post_id, int member_id) throws Exception {
	    String sqlGetTitle = "SELECT TITLE FROM REVIEWER_POST WHERE POST_ID = ?";
	    
	    // 상태값을 대문자 'WAIT'으로 통일
	    String sqlInsert = "INSERT INTO REVIEWER_POST_DRAFT (DRAFT_ID, POST_ID, MEMBER_ID, REQUEST_TYPE, STATUS, REQUEST_DATE, TITLE) " +
	                       "VALUES (REVIEWER_POST_DRAFT_SEQ.NEXTVAL, ?, ?, 'DELETE', 'WAIT', SYSDATE, ?)";
	    
	    // 게시글 상태를 'WAIT'으로 변경
	    String sqlUpdatePost = "UPDATE REVIEWER_POST SET STATUS = 'WAIT' WHERE POST_ID = ?";

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    try {
	        conn = matDBUtil.getConn();
	        conn.setAutoCommit(false); 

	        // 1. 제목 조회
	        String title = "";
	        pstmt = conn.prepareStatement(sqlGetTitle);
	        pstmt.setInt(1, post_id);
	        rs = pstmt.executeQuery();
	        if(rs.next()) {
	            title = rs.getString("TITLE");
	        }
	        pstmt.close();

	        // 2. 삭제 요청 등록 (대문자 'DELETE', 'WAIT' 적용)
	        pstmt = conn.prepareStatement(sqlInsert);
	        pstmt.setInt(1, post_id);
	        pstmt.setInt(2, member_id);
	        pstmt.setString(3, title);
	        pstmt.executeUpdate();
	        pstmt.close();

	        // 3. 게시글 상태를 'WAIT'으로 업데이트
	        pstmt = conn.prepareStatement(sqlUpdatePost);
	        pstmt.setInt(1, post_id);
	        pstmt.executeUpdate();
	        pstmt.close();

	        conn.commit();
	    } catch (Exception e) {
	        if (conn != null) conn.rollback();
	        throw e;
	    } finally {
	        if (conn != null) {
	            conn.setAutoCommit(true);
	            conn.close();
	        }
	    }
	}
	
	public boolean isWriter(int post_id, int member_id) {
	     boolean result = false;
	     String sql = "SELECT 1 FROM reviewer_post WHERE post_id=? AND member_id=? AND ROWNUM=1";
	
	     try (Connection conn = matDBUtil.getConn();
	          PreparedStatement pstmt = conn.prepareStatement(sql)) {
	         
	         pstmt.setInt(1, post_id);
	         pstmt.setInt(2, member_id);
	
	         try (ResultSet rs = pstmt.executeQuery()) {
	             if (rs.next()) {
	                 result = true; 
	             }
	         }
	     } catch (Exception e) {
	         e.printStackTrace();
	     }
	     return result;
	 }
    
	// 관리자 승인 처리 메서드
	public void approveDelete(int draft_id, int post_id) throws Exception {

	    Connection conn = matDBUtil.getConn();
	    conn.setAutoCommit(false); // 트랜잭션 시작

	    try {
	        // 1. 드래프트 상태를 'APPROVED'로 업데이트
	        String sql1 = 
	            "UPDATE REVIEWER_POST_DRAFT " +
	            "SET STATUS = 'APPROVED' " +
	            "WHERE DRAFT_ID = ?";

	        try (PreparedStatement pstmt1 = conn.prepareStatement(sql1)) {
	            pstmt1.setInt(1, draft_id);
	            pstmt1.executeUpdate();
	        }

	        // 2. 게시글 상태를 'DELETED'로 업데이트 (Soft Delete)
	        String sql2 = 
	            "UPDATE REVIEWER_POST " +
	            "SET STATUS = 'DELETED' " +
	            "WHERE POST_ID = ?";

	        try (PreparedStatement pstmt2 = conn.prepareStatement(sql2)) {
	            pstmt2.setInt(1, post_id);
	            pstmt2.executeUpdate();
	        }

	        conn.commit(); // 모든 작업 성공 시 커밋

	    } catch (Exception e) {
	        if (conn != null) conn.rollback(); // 예외 발생 시 롤백
	        throw e;
	    } finally {
	        if (conn != null) {
	            conn.setAutoCommit(true);
	            conn.close();
	        }
	    }
	}
	
	
	/* ======================================================
    ✓ 8. LIKE 좋아요 확인, 추가, 삭제 및 카운트 조회
	====================================================== */
	//사용자가 해당 게시글에 좋아요를 눌렀는지 여부 확인
	public boolean isLiked(int post_id, int member_id) {
		// COUNT(*) 대신 SELECT 1 검증으로 최적화
		String sql = "SELECT 1 FROM reviewer_post_like WHERE post_id=? AND member_id=?";

		try (Connection conn = matDBUtil.getConn();
			PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, post_id);
			pstmt.setInt(2, member_id);

			try (ResultSet rs = pstmt.executeQuery()) {
				return rs.next();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	return false;
	}

	// 좋아요 등록 및 게시글의 좋아요 카운트 증가 (트랜잭션 처리)
	public void insertLike(int post_id, int member_id) throws Exception {
		String sql1 = "INSERT INTO reviewer_post_like(post_id, member_id) VALUES(?,?)";
		String sql2 = "UPDATE reviewer_post SET like_cnt = like_cnt + 1 WHERE post_id=?";

		try (Connection conn = matDBUtil.getConn()) {
			conn.setAutoCommit(false); // 트랜잭션 시작

			try (PreparedStatement pstmt1 = conn.prepareStatement(sql1);
				PreparedStatement pstmt2 = conn.prepareStatement(sql2)) {
                 
				pstmt1.setInt(1, post_id);
				pstmt1.setInt(2, member_id);
              
				// 좋아요 매핑 테이블에 데이터 삽입
				int row = pstmt1.executeUpdate();
                 
				// 좋아요 데이터가 정상 삽입되었을 때만 메인글 카운트 1 증가
				if (row > 0) {
					pstmt2.setInt(1, post_id);
					pstmt2.executeUpdate();
				}

				// 두 연산 모두 안전하게 끝난 후 최종 커밋
				conn.commit(); 

			} catch (SQLIntegrityConstraintViolationException e) {
				if (conn != null) conn.rollback();
				throw e; 
		} catch (Exception e) {
			if (conn != null) conn.rollback();
			throw e;
			}
		}
	}

	// 좋아요 취소 및 게시글의 좋아요 카운트 차감 (트랜잭션 처리)
	public void deleteLike(int post_id, int member_id) throws Exception {
		String sql1 = "DELETE FROM reviewer_post_like WHERE post_id=? AND member_id=?";
		String sql2 = "UPDATE reviewer_post SET like_cnt = CASE WHEN like_cnt > 0 THEN like_cnt - 1 ELSE 0 END WHERE post_id=?";

		try (Connection conn = matDBUtil.getConn()) {
			conn.setAutoCommit(false);

			try (PreparedStatement pstmt1 = conn.prepareStatement(sql1);
				PreparedStatement pstmt2 = conn.prepareStatement(sql2)) {
             
				pstmt1.setInt(1, post_id);
				pstmt1.setInt(2, member_id);
				int row = pstmt1.executeUpdate();

				// 삭제 성공 시에만 카운트 차감
				if (row > 0) {
					pstmt2.setInt(1, post_id);
					pstmt2.executeUpdate();
				}
				conn.commit(); // 최종 커밋
                 
			} catch (Exception e) {
				if (conn != null) conn.rollback();
				throw e;
			}
		}
	}

	//해당 게시글의 실시간 총 좋아요 개수 조회
	public int getLikeCount(int post_id) {
		int count = 0;
		String sql = "SELECT COUNT(*) FROM reviewer_post_like l " +
                "JOIN reviewer_post p ON l.post_id = p.post_id " +
                "WHERE l.post_id = ? AND p.status != 'DELETED'";

		try (Connection conn = matDBUtil.getConn();
			PreparedStatement pstmt = conn.prepareStatement(sql)) {
         
			pstmt.setInt(1, post_id);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
				count = rs.getInt(1);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}

	/* ======================================================
    ✓ 9. BOOKMARK 확인, 추가, 삭제 및 카운트 조회
	====================================================== */
 
	//사용자가 해당 게시글을 북마크했는지 여부 확인

	public boolean isBookmarked(int post_id, int member_id) {
	// SELECT 1 과 Try-with-resources 조합으로 성능 최적화
	String sql = "SELECT 1 FROM reviewer_bookmark WHERE post_id=? AND member_id=?";

	try (Connection conn = matDBUtil.getConn();
		PreparedStatement pstmt = conn.prepareStatement(sql)) {

		pstmt.setInt(1, post_id);
		pstmt.setInt(2, member_id);

		try (ResultSet rs = pstmt.executeQuery()) {
			return rs.next(); // 데이터가 존재하면 true, 없으면 false
		}
	} catch (Exception e) {
         e.printStackTrace();
	}
		return false;
	}

	// 북마크 등록 및 게시글의 북마크 카운트 증가 (트랜잭션 처리)
	public void insertBookmark(int post_id, int member_id) throws Exception {
		String sql1 = "INSERT INTO reviewer_bookmark(post_id, member_id) VALUES(?,?)";
		String sql2 = "UPDATE reviewer_post SET bookmark_cnt = bookmark_cnt + 1 WHERE post_id=?";

	try (Connection conn = matDBUtil.getConn()) {
		// 수동 커밋 모드로 전환하여 트랜잭션 시작
		conn.setAutoCommit(false);

		try (PreparedStatement pstmt1 = conn.prepareStatement(sql1);
			 PreparedStatement pstmt2 = conn.prepareStatement(sql2)) {
             
			pstmt1.setInt(1, post_id);
			pstmt1.setInt(2, member_id);
			int row = pstmt1.executeUpdate();

			// 1. 북마크 데이터가 정상적으로 생성되었을 때만 카운트 증가
			if (row > 0) {
				pstmt2.setInt(1, post_id);
				pstmt2.executeUpdate();
			}
             
			// 2. 두 연산이 완벽히 에러 없이 끝난 이 시점에 커밋
			conn.commit();

			} catch (Exception e) {
             if (conn != null) conn.rollback(); // 중간에 예외 발생 시 확실하게 전체 롤백
             throw e; // 상위 레이어(JSP)로 예외 전파
			}
		}
	}

	// 해당 게시글의 실시간 총 북마크 개수 조회
	public int getBookmarkCount(int post_id) {
		int count = 0;
		String sql = "SELECT COUNT(*) FROM reviewer_bookmark WHERE post_id = ?";

		// 자원을 try-with-resources 괄호 안에 선언하여 커넥션 누수 방지
		try (Connection conn = matDBUtil.getConn();
			PreparedStatement pstmt = conn.prepareStatement(sql)) {
         
			pstmt.setInt(1, post_id);

			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					count = rs.getInt(1); // COUNT(*) 결과 저장
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return count;
	}
 
	// 북마크 취소 및 게시글의 북마크 카운트 차감 (트랜잭션 처리)
	public void deleteBookmark(int post_id, int member_id) throws Exception {
		String sql1 = "DELETE FROM reviewer_bookmark WHERE post_id=? AND member_id=?";
		// 음수 카운트 방지를 위해 CASE WHEN 조건 적용
		String sql2 = "UPDATE reviewer_post SET bookmark_cnt = CASE WHEN bookmark_cnt > 0 THEN bookmark_cnt - 1 ELSE 0 END WHERE post_id=?";

		try (Connection conn = matDBUtil.getConn()) {
			// 수동 커밋 모드로 전환하여 트랜잭션 시작
			conn.setAutoCommit(false);

			try (PreparedStatement pstmt1 = conn.prepareStatement(sql1);
				PreparedStatement pstmt2 = conn.prepareStatement(sql2)) {
             
				pstmt1.setInt(1, post_id);
				pstmt1.setInt(2, member_id);
				int row = pstmt1.executeUpdate();

				// 1. 삭제가 성공적으로 이루어졌을 때만 카운트 차감
				if (row > 0) {
					pstmt2.setInt(1, post_id);
					pstmt2.executeUpdate();
				}
           
				// 2. 안전하게 모든 연산 확인 후 커밋 처리
				conn.commit();
             
			} catch (Exception e) {
			if (conn != null) conn.rollback(); // 예외 발생 시 롤백
			throw e; // 상위 레이어(JSP)로 예외 전파
			}
		}
	}

	/* ======================================================
    ✓ 10. 고정형 TAG (조회, 등록, 삭제/수정, 태그 검색)
 ====================================================== */
	/*
	10-1. 게시글 상세보기 시: 이 글에 체크된 태그들 가져오기
	*/
	public ArrayList<String> getTags(int post_id) {
        ArrayList<String> tags = new ArrayList<>();
        String sql =
                "SELECT t.tag_name " +
                "FROM reviewer_post_tag pt " +
                "JOIN tag t ON pt.tag_id = t.tag_id " +
                "WHERE pt.post_id = ?";

        try (Connection conn = matDBUtil.getConn();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

               pstmt.setInt(1, post_id);

               try (ResultSet rs = pstmt.executeQuery()) {
                   while (rs.next()) {
                       tags.add(rs.getString("tag_name")); // ✔ 이름 기준
                   }
               }
           } catch (Exception e) {
               e.printStackTrace();
           }
           return tags;
       }

	/*
	10-2. 글 작성 및 수정 시: 사용자가 체크한 태그들 등록하기
	(고정 태그이므로 별도의 정제 과정 없이 깔끔하게 삽입)
	*/
	public void insertTags(Connection conn, int draft_id, String[] checkedTags) throws Exception {
	    if (checkedTags == null || checkedTags.length == 0) return;

	    String findTagSql = "SELECT tag_id FROM tag WHERE tag_name = ?";
	    String insertSql = "INSERT INTO reviewer_post_tag_draft (draft_id, tag_id) VALUES (?, ?)";

	    try (PreparedStatement findStmt = conn.prepareStatement(findTagSql);
	         PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {

	        for (String tagName : checkedTags) {
	        	System.out.println("Pro.insertTags() : tag : "+tagName);
	            // 1. tag_name → tag_id 변환
	            findStmt.setString(1, tagName);

	            try (ResultSet rs = findStmt.executeQuery()) {
	                if (rs.next()) {
	                    int tagId = rs.getInt("tag_id");

	                    // 2. 관계 테이블 저장
	                    insertStmt.setInt(1, draft_id);
	                    insertStmt.setInt(2, tagId);
	                    insertStmt.addBatch();
	                }
	            }
	        }

	        insertStmt.executeBatch();
	    }
	}
	/**** 구 코드 0622 1634
	public void insertTags(int draft_id, String[] checkedTags) throws Exception {
	    if (checkedTags == null || checkedTags.length == 0) return;

	    String findTagSql = "SELECT tag_id FROM tag WHERE tag_name = ?";
	    String insertSql = "INSERT INTO reviewer_post_tag_draft (draft_id, tag_id) VALUES (?, ?)";

	    try (Connection conn = matDBUtil.getConn();
	         PreparedStatement findStmt = conn.prepareStatement(findTagSql);
	         PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {

	        for (String tagName : checkedTags) {
	        	System.out.println("Pro.insertTags() : tag : "+tagName);
	            // 1. tag_name → tag_id 변환
	            findStmt.setString(1, tagName);

	            try (ResultSet rs = findStmt.executeQuery()) {
	                if (rs.next()) {
	                    int tagId = rs.getInt("tag_id");

	                    // 2. 관계 테이블 저장
	                    insertStmt.setInt(1, draft_id);
	                    insertStmt.setInt(2, tagId);
	                    insertStmt.addBatch();
	                }
	            }
	        }

	        insertStmt.executeBatch();
	    }
	}
*/
	/*
	10-3. 글 수정 및 삭제 시: 기존에 체크했던 태그들 일괄 초기화
	(수정 폼에서는 먼저 다 지우고 새로 체크된 걸 insertTags로 넣는 게 가장 깔끔)
	*/
	public void deleteTags(int post_id) throws Exception {
        String sql = "DELETE FROM reviewer_post_tag WHERE post_id = ?";

        try (Connection conn = matDBUtil.getConn();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, post_id);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
	// ReviewerDraftDTO 에서 모든정보 가져오기
	public ArrayList<ReviewerDraftDTO> getWaitingList() {
	    ArrayList<ReviewerDraftDTO> list = new ArrayList<>();
	    String sql = "SELECT d.*, m.nickname FROM reviewer_post_draft d " +
	                 "JOIN member m ON d.member_id = m.member_id " +
	                 "WHERE d.status = 'WAIT' ORDER BY d.request_date DESC";

	    try (Connection conn = matDBUtil.getConn();
	         PreparedStatement pstmt = conn.prepareStatement(sql);
	         ResultSet rs = pstmt.executeQuery()) {
	        
	        while (rs.next()) {
	            ReviewerDraftDTO dto = new ReviewerDraftDTO();
	            dto.setDraft_id(rs.getInt("draft_id"));
	            dto.setPost_id(rs.getInt("post_id"));
	            dto.setMember_id(rs.getInt("member_id"));
	            dto.setNickname(rs.getString("nickname"));
	            dto.setTitle(rs.getString("title"));
	            dto.setRequest_date(rs.getDate("request_date"));
	            dto.setStatus(rs.getString("status"));
	            dto.setRequest_type(rs.getString("request_type"));
	            
	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
	
	/* ========================================================================
    [관리자 승인 시스템] 통합 로직
    ======================================================================== */

 // 1. 메인 승인 처리 메서드
	public void approveDraft(int draft_id) throws Exception {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    ReviewerDraftDTO draft = getDraftById(draft_id);
	    String requestType = draft.getRequest_type();
	    int targetPostId = draft.getPost_id();

	    try {
	        conn = matDBUtil.getConn();
	        conn.setAutoCommit(false);

	        // [삭제 승인]
	        if ("DELETE".equals(requestType)) {
	            String sqlDelete = "UPDATE REVIEWER_POST SET STATUS = 'DELETED' WHERE POST_ID = ?";
	            pstmt = conn.prepareStatement(sqlDelete);
	            pstmt.setInt(1, targetPostId);
	            pstmt.executeUpdate();
	            pstmt.close();

	        // [신규/수정 승인]
	        } else {

	            // A. 신규 게시글 생성 (targetPostId == 0)
	            if (targetPostId == 0) {

	                // post_id 채번
	                pstmt = conn.prepareStatement("SELECT REVIEWER_POST_SEQ.NEXTVAL FROM DUAL");
	                rs = pstmt.executeQuery();
	                if (rs.next()) targetPostId = rs.getInt(1);
	                rs.close();
	                pstmt.close();

	                // 게시글 삽입
	                String sqlInsert =
	                    "INSERT INTO REVIEWER_POST (POST_ID, MEMBER_ID, TITLE, ZIPCODE, ADDRESS1, ADDRESS2, REG_DATE, STATUS) " +
	                    "VALUES (?, ?, ?, ?, ?, ?, SYSDATE, 'APPROVED')";
	                pstmt = conn.prepareStatement(sqlInsert);
	                pstmt.setInt(1, targetPostId);
	                pstmt.setInt(2, draft.getMember_id());
	                pstmt.setString(3, draft.getTitle());
	                pstmt.setString(4, draft.getZipcode());
	                pstmt.setString(5, draft.getAddress1());
	                pstmt.setString(6, draft.getAddress2());
	                pstmt.executeUpdate();
	                pstmt.close();

	            // B. 수정 승인 (targetPostId != 0)
	            } else {

	                // 제목/주소 수정
	                String sqlUpdatePost =
	                    "UPDATE REVIEWER_POST SET TITLE = ?, ZIPCODE = ?, ADDRESS1 = ?, ADDRESS2 = ? WHERE POST_ID = ?";
	                pstmt = conn.prepareStatement(sqlUpdatePost);
	                pstmt.setString(1, draft.getTitle());
	                pstmt.setString(2, draft.getZipcode());
	                pstmt.setString(3, draft.getAddress1());
	                pstmt.setString(4, draft.getAddress2());
	                pstmt.setInt(5, targetPostId);
	                pstmt.executeUpdate();
	                pstmt.close();

	                // 기존 내용 삭제
	                String sqlDeleteContent = "DELETE FROM REVIEWER_CONTENT WHERE POST_ID = ?";
	                pstmt = conn.prepareStatement(sqlDeleteContent);
	                pstmt.setInt(1, targetPostId);
	                pstmt.executeUpdate();
	                pstmt.close();

	                // draft에 이미지가 있을 때만 기존 이미지 삭제
	                String sqlCheckImages = "SELECT COUNT(*) FROM REVIEWER_IMAGE_DRAFT WHERE DRAFT_ID = ?";
	                pstmt = conn.prepareStatement(sqlCheckImages);
	                pstmt.setInt(1, draft_id);
	                rs = pstmt.executeQuery();
	                int imageCount = 0;
	                if (rs.next()) imageCount = rs.getInt(1);
	                rs.close();
	                pstmt.close();

	                if (imageCount > 0) {
	                    String sqlDeleteImages = "DELETE FROM REVIEWER_IMAGE WHERE POST_ID = ?";
	                    pstmt = conn.prepareStatement(sqlDeleteImages);
	                    pstmt.setInt(1, targetPostId);
	                    pstmt.executeUpdate();
	                    pstmt.close();
	                }
	            }

	            // ✅ 내용 복사: reviewer_content_draft → reviewer_content (신규/수정 공통)
	            String sqlGetContents =
	                "SELECT CONTENT_SUBTITLE, CONTENT, CONTENT_ORDER " +
	                "FROM REVIEWER_CONTENT_DRAFT WHERE DRAFT_ID = ? ORDER BY CONTENT_ORDER";
	            String sqlInsertContent =
	                "INSERT INTO REVIEWER_CONTENT (CONTENT_ID, POST_ID, CONTENT_SUBTITLE, CONTENT, CONTENT_ORDER) " +
	                "VALUES (REVIEWER_CONTENT_SEQ.NEXTVAL, ?, ?, ?, ?)";

	            try (PreparedStatement selectStmt = conn.prepareStatement(sqlGetContents);
	                 PreparedStatement insertStmt = conn.prepareStatement(sqlInsertContent)) {
	                selectStmt.setInt(1, draft_id);
	                try (ResultSet contentRs = selectStmt.executeQuery()) {
	                    while (contentRs.next()) {
	                        insertStmt.setInt(1, targetPostId);
	                        insertStmt.setString(2, contentRs.getString("CONTENT_SUBTITLE"));
	                        insertStmt.setString(3, contentRs.getString("CONTENT"));
	                        insertStmt.setInt(4, contentRs.getInt("CONTENT_ORDER"));
	                        insertStmt.executeUpdate();
	                    }
	                }
	            }

	            // ✅ 이미지 복사: reviewer_image_draft → reviewer_image (draft에 이미지 있을 때만)
	            String sqlGetImages =
	                "SELECT FILE_NAME, IS_THUMBNAIL, IMAGE_ORDER " +
	                "FROM REVIEWER_IMAGE_DRAFT WHERE DRAFT_ID = ? ORDER BY IMAGE_ORDER ASC";
	            String sqlInsertImage =
	                "INSERT INTO REVIEWER_IMAGE (IMAGE_ID, POST_ID, FILE_NAME, IS_THUMBNAIL, IMAGE_ORDER) " +
	                "VALUES (REVIEWER_IMAGE_SEQ.NEXTVAL, ?, ?, ?, ?)";

	            try (PreparedStatement selectStmt = conn.prepareStatement(sqlGetImages);
	                 PreparedStatement insertStmt = conn.prepareStatement(sqlInsertImage)) {
	                selectStmt.setInt(1, draft_id);
	                try (ResultSet imageRs = selectStmt.executeQuery()) {
	                	System.out.println("이미지 복사 시작 - draft_id: " + draft_id + ", targetPostId: " + targetPostId);
	                    while (imageRs.next()) {
	                    	System.out.println("이미지 복사 중: " + imageRs.getString("FILE_NAME")); // 추가
	                        insertStmt.setInt(1, targetPostId);
	                        insertStmt.setString(2, imageRs.getString("FILE_NAME"));
	                        insertStmt.setString(3, imageRs.getString("IS_THUMBNAIL"));
	                        insertStmt.setInt(4, imageRs.getInt("IMAGE_ORDER"));
	                        insertStmt.executeUpdate();
	                    }
	                }
	            }

	            // 게시글 상태 업데이트
	            String sqlStatusPost = "UPDATE REVIEWER_POST SET STATUS = 'APPROVED' WHERE POST_ID = ?";
	            pstmt = conn.prepareStatement(sqlStatusPost);
	            pstmt.setInt(1, targetPostId);
	            pstmt.executeUpdate();
	            pstmt.close();
	        }

	        // [승인 기록]
	        String sqlApprove =
	            "INSERT INTO REVIEWER_APPROVAL (APPROVAL_ID, POST_ID, MEMBER_ID, REQUEST_TYPE, ADMIN_ID, APPROVE_DATE) " +
	            "VALUES ((SELECT NVL(MAX(APPROVAL_ID), 0) + 1 FROM REVIEWER_APPROVAL), ?, ?, ?, 1, SYSDATE)";
	        pstmt = conn.prepareStatement(sqlApprove);
	        pstmt.setInt(1, targetPostId);
	        pstmt.setInt(2, draft.getMember_id());
	        pstmt.setString(3, requestType);
	        pstmt.executeUpdate();
	        pstmt.close();

	        // [드래프트 상태 업데이트]
	        String sqlStatusDraft = "UPDATE REVIEWER_POST_DRAFT SET STATUS = 'APPROVED' WHERE DRAFT_ID = ?";
	        pstmt = conn.prepareStatement(sqlStatusDraft);
	        pstmt.setInt(1, draft_id);
	        pstmt.executeUpdate();
	        pstmt.close();
	        
	        
	     // 💡 [추가] 5. 모든 승인/이관 처리가 완료된 후 정식 SEARCH_TEXT 동적 생성 수행
	        String sqlUpdateSearchText = 
		              " UPDATE REVIEWER_POST p "
		            + " SET p.SEARCH_TEXT = ( "
		            + "     SELECT "
		            + "         p.TITLE || ' ' || "
		            + "         m.NICKNAME || ' ' || "
		            + "         NVL(p.ADDRESS1, '') || ' ' || "
		            + "         NVL(p.ADDRESS2, '') || ' ' || "
		            + "         NVL(( "
		            + "             SELECT LISTAGG('#' || t.TAG_NAME, ' ') "
		            + "             WITHIN GROUP (ORDER BY t.TAG_ID) "
		            + "             FROM REVIEWER_POST_TAG rpt "
		            + "             JOIN TAG t ON rpt.TAG_ID = t.TAG_ID "
		            + "             WHERE rpt.POST_ID = p.POST_ID "
		            + "         ), '') "
		            + "     FROM MEMBER m "
		            + "     WHERE m.MEMBER_ID = p.MEMBER_ID "
		            + " ) "
		            + " WHERE p.POST_ID = ? ";
		            
	        pstmt = conn.prepareStatement(sqlUpdateSearchText);
	        pstmt.setInt(1, targetPostId);
	        pstmt.executeUpdate();
	        pstmt.close();	     

	        conn.commit();

	    } catch (Exception e) {
	        if (conn != null) conn.rollback();
	        throw e;
	    } finally {
	        if (conn != null) conn.setAutoCommit(true);
	        matDBUtil.close(conn, pstmt, rs);
	    }
	}
 // 2. 초안 단건 조회
	public ReviewerDraftDTO getDraftById(int draft_id) {
	    // 1. CONTENT_DRAFT 테이블까지 LEFT JOIN 추가
	    String sql = "SELECT d.*, c.content, c.content_subtitle, c.content_order, m.nickname " +
	                 "FROM reviewer_post_draft d " +
	                 "LEFT JOIN reviewer_content_draft c ON d.draft_id = c.draft_id " +
	                 "LEFT JOIN member m ON d.member_id = m.member_id " +
	                 "WHERE d.draft_id = ?";
	    
	    try (Connection conn = matDBUtil.getConn(); 
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, draft_id);
	        
	        try (ResultSet rs = pstmt.executeQuery()) {
	            if (rs.next()) {
	                ReviewerDraftDTO dto = new ReviewerDraftDTO();
	                
	                // 기본 정보 세팅
	                dto.setDraft_id(rs.getInt("draft_id"));
	                dto.setPost_id(rs.getInt("post_id"));
	                dto.setMember_id(rs.getInt("member_id"));
	                dto.setTitle(rs.getString("title"));
	                dto.setRequest_type(rs.getString("request_type"));
	                dto.setZipcode(rs.getString("zipcode"));
	                dto.setAddress1(rs.getString("address1"));
	                dto.setAddress2(rs.getString("address2"));
	                dto.setRequest_date(rs.getDate("request_date"));
	                
	                // [핵심] CONTENT_DRAFT에서 가져온 데이터 세팅
	                dto.setContent(rs.getString("content"));
	                dto.setContent_subtitle(rs.getString("content_subtitle"));
	                dto.setContent_order(rs.getInt("content_order"));
	                
	                return dto;
	            }
	        }
	    } catch (Exception e) { 
	        e.printStackTrace(); 
	    }
	    return null;
	}

 // pivate 사용 이유 : 외부 오남용 방지 , 코드 가독성 향상, 유지보수 쉬움
 // 3. 원본 게시글 INSERT
 private int insertIntoPostTable(Connection conn, ReviewerDraftDTO draft) throws Exception {
	    String sql = "INSERT INTO reviewer_post "
	               + " (post_id, member_id, title, zipcode, address1, address2, reg_date) "
	               + " VALUES (reviewer_post_seq.NEXTVAL, ?, ?, ?, ?, ?, sysdate)";
	    
	    // [중요] Statement.RETURN_GENERATED_KEYS 옵션을 추가합니다.
	    try (PreparedStatement pstmt = conn.prepareStatement(sql, new String[] {"post_id"})) {
	    	pstmt.setInt(1, draft.getMember_id());
	    	pstmt.setString(2, draft.getTitle());
	    	pstmt.setString(3, draft.getZipcode());
	    	pstmt.setString(4, draft.getAddress1());
	    	pstmt.setString(5, draft.getAddress2());
	        
	        int affectedRows = pstmt.executeUpdate();
	        if (affectedRows == 0) {
	            throw new Exception("글 생성 실패: 삽입된 행이 없습니다.");
	        }

	        // 생성된 post_id를 가져옵니다.
	        try (ResultSet rs = pstmt.getGeneratedKeys()) {
	            if (rs.next()) {
	                return rs.getInt(1); // 생성된 post_id 반환
	            } else {
	                throw new Exception("ID를 가져오는데 실패했습니다.");
	            }
	        }
	    }
 }
 // 4. 원본 게시글 UPDATE
 private void updatePostTable(Connection conn, ReviewerDraftDTO draft) throws Exception {
	    String sql = "UPDATE reviewer_post SET title=?, content=?, zipcode=?, address1=?, address2=?, reg_date=sysdate WHERE post_id=?";
	    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setString(1, draft.getTitle());
	        pstmt.setString(2, draft.getContent());    // 📍 content 추가
	        pstmt.setString(3, draft.getZipcode());
	        pstmt.setString(4, draft.getAddress1());
	        pstmt.setString(5, draft.getAddress2());
	        pstmt.setInt(6, draft.getPost_id());       // 📍 인덱스 6으로 변경
	        
	        int result = pstmt.executeUpdate();
	        if (result == 0) throw new Exception("수정할 게시글을 찾을 수 없습니다.");
	    }
	}


 public void insertApprovalRecord(Connection conn, ReviewerDraftDTO draft, int post_id) throws Exception {
	    String sql = "INSERT INTO reviewer_approval (approval_id, post_id, member_id, request_type, request_date, approve_date) " +
	                 "VALUES (reviewer_approval_seq.NEXTVAL, ?, ?, ?, ?, SYSDATE)";
	    
	    try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        pstmt.setInt(1, post_id); // 이제 올바른 post_id가 들어갑니다.
	        pstmt.setInt(2, draft.getMember_id());
	        pstmt.setString(3, draft.getRequest_type());
	        pstmt.setDate(4, draft.getRequest_date());
	        pstmt.executeUpdate();
	    }
	}
 
 // 6. 상태 업데이트 및 기록
 private void updateDraftStatus(Connection conn, int draft_id, String status) throws Exception {
	 String sql = "UPDATE reviewer_post_draft SET status=? WHERE draft_id=?";
	 try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
		 pstmt.setString(1, status);
		 pstmt.setInt(2, draft_id);
		 pstmt.executeUpdate();
	 }
 }
 // 외부에서 사용
 public void updateDraftStatus(int draft_id, String status) throws Exception {
	    try (Connection conn = matDBUtil.getConn()) {
	        updateDraftStatus(conn, draft_id, status); // 내부 메서드 호출
	    }
	}
 
 public void rejectDraft(int draft_id) throws Exception {
	    // 상태를 'rejected'로 업데이트하는 쿼리
	    String sql = "UPDATE reviewer_post_draft SET status = 'REJECTED' WHERE draft_id = ?";
	    
	    try (Connection conn = matDBUtil.getConn();
	         PreparedStatement pstmt = conn.prepareStatement(sql)) {
	        
	        pstmt.setInt(1, draft_id);
	        
	        int result = pstmt.executeUpdate();
	        if (result == 0) {
	            throw new Exception("해당 초안을 찾을 수 없습니다.");
	        }
	        // 거절 시에는 별도의 데이터 생성/삭제 작업이 필요 없으므로 바로 종료
	    } catch (Exception e) {
	        e.printStackTrace();
	        throw e;
	    }
	}
 
 public void updateDraft(ReviewerDraftDTO draft) throws Exception {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    
	    try {
	        conn = matDBUtil.getConn();
	        conn.setAutoCommit(false); // 트랜잭션 시작

	        // 1. 내용 업데이트
	        String sqlUpdate = "UPDATE REVIEWER_POST_DRAFT SET TITLE = ?, CONTENT = ?, CONTENT_SUBTITLE = ? WHERE DRAFT_ID = ?";
	        pstmt = conn.prepareStatement(sqlUpdate);
	        pstmt.setString(1, draft.getTitle());
	        pstmt.setString(2, draft.getContent());
	        pstmt.setString(3, draft.getContent_subtitle());
	        pstmt.setInt(4, draft.getDraft_id());
	        pstmt.executeUpdate();
	        pstmt.close();
	        
	        // 2. 상태를 'WAIT'로 변경 (만들어두신 메서드 활용!)
	        updateDraftStatus(conn, draft.getDraft_id(), "WAIT");
	        
	        conn.commit();
	    } catch (Exception e) {
	        if (conn != null) conn.rollback();
	        throw e;
	    } finally {
	        if (conn != null) conn.setAutoCommit(true);
	        matDBUtil.close(conn, pstmt, null);
	    }
	}
 
 	//삭제 (Soft Delete)
 	public void deleteDraft(int draft_id) throws Exception {
 		try {
 			// 이미 만들어두신 메서드를 호출하여 상태만 변경합니다.
 			updateDraftStatus(draft_id, "DELETED");
 		} catch (Exception e) {
 			throw e;
 		}
 	}
 	
 // 관리자 페이지용: 대기 중인 모든 요청(수정 + 삭제) 가져오기
 	public List<ReviewerDraftDTO> getPendingRequests() throws Exception {
 	    List<ReviewerDraftDTO> list = new ArrayList<>();
 	    String sql = "SELECT * FROM REVIEWER_POST_DRAFT WHERE STATUS = 'WAIT' ORDER BY REQUEST_DATE DESC";
 	    
 	    try (Connection conn = matDBUtil.getConn();
 	         PreparedStatement pstmt = conn.prepareStatement(sql);
 	         ResultSet rs = pstmt.executeQuery()) {
 	        
 	        while (rs.next()) {
 	            ReviewerDraftDTO dto = new ReviewerDraftDTO();
 	            dto.setDraft_id(rs.getInt("draft_id"));
 	            dto.setPost_id(rs.getInt("post_id"));
 	            dto.setMember_id(rs.getInt("member_id"));
 	            dto.setRequest_type(rs.getString("request_type")); // 'update' 또는 'delete'
 	            dto.setStatus(rs.getString("status"));
 	            dto.setRequest_date(rs.getDate("request_date"));
 	            list.add(dto);
 	        }
 	    }
 	    return list;
 	}
 	
 	/*  메인 화면에 사용할 DAO  */
	public List<ReviewerPostDTO> selectTop3ByView() {
	    List<ReviewerPostDTO> list = new ArrayList<>();

	    // 썸네일 여부('Y') 조건이 데이터 불일치를 일으킬 수 있으므로,
	    // 게시글에 등록된 첫 번째 이미지 블록(순서가 제일 빠른 것)을 무조건 가져오도록 안전하게 변경합니다.
	    String sql = """
                SELECT 
                    rp.post_id,
                    rp.member_id,
                    rp.title,
                    rp.view_cnt,
                    rp.like_cnt,
                    rp.bookmark_cnt,
                    rp.reg_date,
                    m.nickname,

                    (
                        SELECT ri.file_name
                        FROM reviewer_image ri
                        WHERE ri.post_id = rp.post_id
                        ORDER BY 
                            CASE WHEN ri.is_thumbnail = 'Y' THEN 0 ELSE 1 END,
                            ri.image_order ASC,
                            ri.image_id ASC
                        FETCH FIRST 1 ROW ONLY
                    ) AS thumbnail

                FROM reviewer_post rp
                LEFT JOIN member m 
                    ON rp.member_id = m.member_id
                ORDER BY rp.view_cnt DESC
                FETCH FIRST 3 ROWS ONLY
            """;

	    try (Connection conn = matDBUtil.getConn();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {
	            ReviewerPostDTO dto = new ReviewerPostDTO();

	            dto.setPost_id(rs.getInt("post_id"));
	            dto.setMember_id(rs.getInt("member_id"));
	            dto.setTitle(rs.getString("title"));
	            dto.setView_cnt(rs.getInt("view_cnt"));
	            dto.setLike_cnt(rs.getInt("like_cnt"));
	            dto.setBookmark_cnt(rs.getInt("bookmark_cnt"));
	            dto.setReg_date(rs.getDate("reg_date"));
	            dto.setNickname(rs.getString("nickname"));
	            
	            dto.setThumbnail(rs.getString("thumbnail"));

	            list.add(dto);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
 	
 }