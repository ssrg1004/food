<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="web.miniProject.dao.ReviewerPostDAO" %>
<%
request.setCharacterEncoding("UTF-8");
MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

/* 로그인 체크 */
if(loginUser == null){
        response.setStatus(401); 
        out.print("{\"status\":\"fail\", \"message\":\"login_required\"}");
        return;
    }

    int member_id = loginUser.getMember_id();

/* 파라미터 체크 */
String postIdParam = request.getParameter("post_id");
    if(postIdParam == null || postIdParam.trim().equals("")){
        response.setStatus(400);
        out.print("{\"status\":\"fail\", \"message\":\"invalid post_id\"}");
        return;
    }

    int post_id = Integer.parseInt(postIdParam);
    ReviewerPostDAO dao = ReviewerPostDAO.getInstance();

    boolean isBookmarked = false;
    int bookmarkCount = 0;

/* 북마크 토글 비즈니스 로직 */
try {
        isBookmarked = dao.isBookmarked(post_id, member_id);

        if(isBookmarked){
            dao.deleteBookmark(post_id, member_id);
            isBookmarked = false; // 삭제되었으므로 상태를 false로 변경
        } else {
            dao.insertBookmark(post_id, member_id);
            isBookmarked = true;  // 등록되었으므로 상태를 true로 변경
        }
        
        // 트랜잭션 반영 후 최신 북마크 카운트 조회
        bookmarkCount = dao.getBookmarkCount(post_id);
     // 정상 처리 응답 (JSON format)
        out.print("{");
        out.print("\"status\":\"success\",");
        out.print("\"isBookmarked\":" + isBookmarked + ",");
        out.print("\"bookmarkCount\":" + bookmarkCount);
        out.print("}");

    } catch(Exception e){
        e.printStackTrace();
        // 서버 에러 발생 시 500 Internal Server Error 상태코드 반환
        response.setStatus(500);
        out.print("{\"status\":\"fail\", \"message\":\"server error\"}");
    }
%>
