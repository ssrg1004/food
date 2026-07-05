<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="web.miniProject.dao.NoticeDAO" %>
<%@ page import="web.miniProject.dto.NoticeDTO" %>

<% request.setAttribute("forceBlock", "Y"); %>
<%@ include file="/content/admin/adminCheck.jsp" %>

<% int notice_id = Integer.parseInt(request.getParameter("notice_id"));

// 기존 글 조회
NoticeDAO dao = new NoticeDAO();
NoticeDTO dto = dao.getContent(notice_id);
%>    

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
<link rel="stylesheet" href="../../css/noList.css">

<%@ include file="../header.jsp" %>

<h1>📝 공지사항 수정</h1>

<div class="card">
	<form action="noUpdatePro.jsp" method="post" class="write_form">
		<%-- 사용자에게는 보이지 않지만 서버로 전달이 필요 --%>
		<input type="hidden" name="notice_id" value="<%= dto.getNotice_id() %>">
		
		<input type="text" name="title" value="<%= dto.getTitle() %>">
		
		<textarea name="content"><%= dto.getContent() %></textarea>
		
		<div class="write_btn">
			<button type="submit" class="btn primary">수정</button>
			<button type="button" class="btn"
              onclick="location.href='noContent.jsp?notice_id=<%= dto.getNotice_id() %>'">
            취소
        </button>
		</div>
	</form>
</div>