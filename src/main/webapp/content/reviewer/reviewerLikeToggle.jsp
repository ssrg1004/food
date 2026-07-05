<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="web.miniProject.dao.ReviewerPostDAO" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("application/json; charset=UTF-8");

    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

    /* [로그인 체크] 비로그인 유저는 401 권한없음 반환 */
    if(loginUser == null){
        response.setStatus(401); 
        out.print("{\"status\":\"fail\", \"message\":\"login_required\"}");
        return;
    }

    int member_id = loginUser.getMember_id();

    /* [파라미터 체크] 잘못된 게시글 ID 접근은 400 잘못된 요청 반환 */
    String postIdParam = request.getParameter("post_id");
    if(postIdParam == null || postIdParam.trim().equals("")){
        response.setStatus(400);
        out.print("{\"status\":\"fail\", \"message\":\"invalid post_id\"}");
        return;
    }

    int post_id = Integer.parseInt(postIdParam);
    ReviewerPostDAO dao = ReviewerPostDAO.getInstance();

    boolean isLiked = false;
    int likeCount = 0;

    /* [좋아요 토글 비즈니스 로직] */
    try {
        isLiked = dao.isLiked(post_id, member_id);

        if(isLiked){
            dao.deleteLike(post_id, member_id);
            isLiked = false; // 취소되었으므로 상태 false
        } else {
            dao.insertLike(post_id, member_id);
            isLiked = true;  // 등록되었으므로 상태 true
        }
        
        // 데이터 정합성이 확보된 최신 좋아요 개수 확보
        likeCount = dao.getLikeCount(post_id);
        
        // JSON 객체 조립 및 출력
        out.print("{");
        out.print("\"status\":\"success\",");
        out.print("\"isLiked\":" + isLiked + ",");
        out.print("\"likeCount\":" + likeCount);
        out.print("}");

    } catch(Exception e){
        e.printStackTrace();
        response.setStatus(500);
        out.print("{\"status\":\"fail\", \"message\":\"server error\"}");
    }
%>