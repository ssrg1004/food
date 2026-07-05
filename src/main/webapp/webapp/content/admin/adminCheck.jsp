<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dto.MemberDTO" %>

<%
	// 세션에서 로그인한 유저의 모든 정보를 꺼내기
	MemberDTO loginUser = (MemberDTO) session.getAttribute("loginUser");

	// 로그인 상태일 때만 role 꺼내기, 비로그인이면 빈 문자열(" ") 세팅
	String role=(loginUser != null) ? loginUser.getRole() : "";
	
	// 만약 차단 모드가 켜져있고, 관리자가 아니라면 메인으로 튕겨내기
	String forceBlock = (String) request.getAttribute("forceBlock");
	if("Y".equals(forceBlock) && !"admin".equals(role)) {
%>
	<script>
		alert("관리자만 접근 가능한 페이지입니다");
		location.href="<%= request.getContextPath() %>/content/main.jsp";
	</script>
<% 
		return;
	} %>