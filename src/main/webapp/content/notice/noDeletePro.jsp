<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dao.NoticeDAO" %>

<% request.setAttribute("forceBlock", "Y"); %>
<%@ include file="/content/admin/adminCheck.jsp" %>
<%
int notice_id=Integer.parseInt(request.getParameter("notice_id"));

NoticeDAO dao = new NoticeDAO();
int result = dao.noDelete(notice_id);

if(result > 0) {
	response.sendRedirect("noList.jsp");
} else {
%>
	<script>
		alert("삭제에 실패하였습니다");
		history.go(-1);
	</script>
<% } %>