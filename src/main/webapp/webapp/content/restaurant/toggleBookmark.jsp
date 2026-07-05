<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="web.miniProject.dao.RestaurantBookmarkDAO" %>
<%@ page import="web.miniProject.dao.RestaurantDAO" %>

<%
MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

if(loginUser == null){
    out.print("login");
    return;
}

int post_id = Integer.parseInt(request.getParameter("post_id"));
int member_id = loginUser.getMember_id();

RestaurantBookmarkDAO dao = new RestaurantBookmarkDAO();
RestaurantDAO rDao = new RestaurantDAO(); 

if(dao.isBookmarked(post_id, member_id)){
    dao.deleteBookmark(post_id, member_id);
    rDao.updateBookmarkCount(post_id, -1); // 메인 테이블 카운트 -1
    out.print("removed");
} else {
    dao.insertBookmark(post_id, member_id);
    rDao.updateBookmarkCount(post_id, 1);  // 메인 테이블 카운트 +1
    out.print("added");
}
%>