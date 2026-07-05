<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

	<% // 세션 전체 삭제 session.invalidate(); // 메인 페이지로 이동 response.sendRedirect("main.jsp"); %>
	


<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

HttpSession session2 = request.getSession(false);
if (session != null) {
    session.invalidate();
}

response.sendRedirect(request.getContextPath() + "/content/main.jsp");
%>
