<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dao.MemberDAO" %>
<%
    // adminCheck 등이 필요하다면 여기에 추가
    String id = request.getParameter("id");
    boolean success = false;
    
    if (id != null && !id.equals("")) {
        MemberDAO dao = new MemberDAO();
        success = dao.kickMember(id); // 1단계에서 만든 메서드 호출
    }
    
    // 결과를 text로 반환 (성공 시 Y, 실패 시 N)
    out.print(success ? "Y" : "N");
%>