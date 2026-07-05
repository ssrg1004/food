<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dao.NoticeDAO" %>
<%@ page import="web.miniProject.dto.NoticeDTO" %>
<%@ include file="/content/admin/adminCheck.jsp" %>

<link rel="stylesheet" href="../../css/common.css">
<link rel="stylesheet" href="../../css/header.css">
<link rel="stylesheet" href="../../css/noContent.css">

<%@ include file="/content/header.jsp" %>

<%
int notice_id = Integer.parseInt(request.getParameter("notice_id"));
NoticeDAO dao = new NoticeDAO();
NoticeDTO dto = dao.getContent(notice_id);
%>

<div class="container">
    <h1>📢 공지사항</h1>

    <div class="notice_view">
        <h2 class="notice_title">
            <%= dto.getTitle() %>
        </h2>

        <div class="notice_info">
            <span>번호 <strong><%= dto.getNotice_id() %></strong></span>
            <span class="divider">|</span>
            <span>작성자 <strong><%= dto.getWriter() %></strong></span>
            <span class="divider">|</span>
            <span>조회수 <strong><%= dto.getView_cnt() %></strong></span>
            <span class="divider">|</span>
            <span>작성일 <strong><%= dto.getReg_date() %></strong></span>
        </div>

        <div class="notice_content">
            <pre><%= dto.getContent() %></pre>
        </div>

        <div class="notice_btns">
            <a href="noList.jsp" class="btn outline">목록</a>

            <% if("admin".equals(role)) { %>
                <a href="noUpdateForm.jsp?notice_id=<%= dto.getNotice_id() %>" class="btn edit">수정</a>
                <a href="noDeletePro.jsp?notice_id=<%= dto.getNotice_id() %>" class="btn delete" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
            <% } %>
        </div>
    </div>
</div>