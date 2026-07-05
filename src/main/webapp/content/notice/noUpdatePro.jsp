<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="web.miniProject.dao.NoticeDAO" %>
<%@ page import="web.miniProject.dto.NoticeDTO" %>

<% request.setAttribute("forceBlock", "Y"); %>
<%@ include file="/content/admin/adminCheck.jsp" %>
<% request.setCharacterEncoding("UTF-8"); %>

<%
// 폼 데이터 받기
int notice_id = Integer.parseInt(request.getParameter("notice_id"));
String title=request.getParameter("title");
String content=request.getParameter("content");

// DTO에 저장
NoticeDTO dto = new NoticeDTO();
dto.setNotice_id(notice_id);
dto.setTitle(title);
dto.setContent(content);

// 수정 실행
NoticeDAO dao = new NoticeDAO();
int result = dao.noUpPro(dto);

// 결과
if(result > 0){
	response.sendRedirect("noContent.jsp?notice_id=" + notice_id);
} else {
%>
	<script>
		alert("수정이 실패하였습니다")
		history.go(-1);
	</script>
<% } %>