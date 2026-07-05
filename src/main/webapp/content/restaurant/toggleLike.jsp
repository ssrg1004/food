<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="web.miniProject.dao.RestaurantPostLikeDAO" %>
<%@ page import="web.miniProject.dao.RestaurantDAO" %>

<%
MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

if(loginUser == null){
    out.print("login");
    return;
}

int member_id = loginUser.getMember_id();
int post_id = Integer.parseInt(request.getParameter("post_id"));

RestaurantPostLikeDAO dao = new RestaurantPostLikeDAO();
RestaurantDAO rDao = new RestaurantDAO(); 

boolean isLiked = dao.isLiked(post_id, member_id);

if(isLiked){
    dao.deleteLike(post_id, member_id);
    rDao.updateLikeCount(post_id, -1); // 메인 테이블 카운트 -1
    out.print("unliked");
} else {
    dao.insertLike(post_id, member_id);
    rDao.updateLikeCount(post_id, 1);  // 메인 테이블 카운트 +1
    out.print("liked");
}
%>