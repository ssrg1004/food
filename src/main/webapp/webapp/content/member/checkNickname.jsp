<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="web.miniProject.dao.MemberDAO" %>

<%
request.setCharacterEncoding("UTF-8");

// 1. 파라미터 받기
String nickname = request.getParameter("nickname");

// 2. null / 공백 체크
if (nickname == null || nickname.trim().equals("")) {
    out.print("EMPTY");
    return;
}

// 3. DAO 호출
MemberDAO dao = new MemberDAO();

// true = 중복
boolean isDuplicate = dao.checkDuplicateNickname(nickname);

// 4. 결과 반환
if (isDuplicate) {
    out.print("DUP");   // 중복
} else {
    out.print("OK");    // 사용 가능
}
%>