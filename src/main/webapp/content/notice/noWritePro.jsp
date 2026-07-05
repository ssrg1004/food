<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dto.NoticeDTO" %>
<%@ page import="web.miniProject.dao.NoticeDAO" %>
    
<% request.setCharacterEncoding ("UTF-8"); %>

<% request.setAttribute("forceBlock", "Y"); %>
<%@ include file="/content/admin/adminCheck.jsp" %>
<%
String writer = request.getParameter("writer");
String title= request.getParameter("title");
String content= request.getParameter("content");

// DTO 에 담기
NoticeDTO dto = new NoticeDTO();
dto.setWriter(writer);
dto.setTitle(title);
dto.setContent(content);

// DAO 호출
NoticeDAO dao = new NoticeDAO();
int result= dao.noticeInsert(dto);

// 결과
if(result == 1){
	response.sendRedirect("noList.jsp");
} else {
%>
	<script>
		alert("등록 실패");
		history.go(-1);
	</script>
<% } %>