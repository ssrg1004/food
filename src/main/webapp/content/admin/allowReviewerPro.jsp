<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dao.MemberDAO" %>
<%
    // 1. adminPage.jsp의 자바스크립트(fetch)에서 보낸 파라미터를 받습니다.
    // adminPage.jsp가 'id'라는 이름으로 던져주고 있으므로 userId 대신 id로 명확히 받습니다.
    String id = request.getParameter("id");
    String type = request.getParameter("type"); // "approve"(승인) 또는 "reject"(거절)
    
    boolean isSuccess = false;
    
    // 2. 파라미터 방어 코드 (id와 type이 확실히 넘어왔을 때만 처리)
    if (id != null && type != null) {
        MemberDAO dao = new MemberDAO();
        
        // 📍 [대문자 반영] 아까 대문자 'Y'와 'N'으로 수정한 DAO 메서드를 호출합니다.
        // 이 메서드가 실행되면서 DB의 'S'(대기) 상태가 'Y'(승인) 또는 'N'(일반)으로 바뀝니다.
        isSuccess = dao.updateReviewerStatus(id, type);
    }
    
    // 3. adminPage.jsp의 fetch 스크립트가 인식할 수 있도록 최종 결과('Y' 또는 'N')를 리턴합니다.
    if (isSuccess) {
        out.print("Y");
    } else {
        out.print("N");
    }
%>