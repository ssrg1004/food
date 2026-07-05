<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dao.CommentDAO" %>
<%
    // adminPage.jsp에서 fetch로 보낸 데이터 받기
    String strCommentId = request.getParameter("comment_id");
    String type = request.getParameter("type");
    
    String result = "N"; // 기본 응답값은 실패('N')로 설정
    
    if(strCommentId != null && type != null) {
        int comment_id = Integer.parseInt(strCommentId);
        CommentDAO cdao = new CommentDAO();
        
        // DAO를 호출하여 DB 상태를 업데이트하고 결과를 숫자로 받음 (성공 시 1)
        int count = cdao.processReport(comment_id, type);
        
        if(count > 0) {
            result = "Y"; // DB 반영 성공 시 'Y'로 변경
        }
    }
    
    // 📍 [중요] 비동기(fetch) 통신은 HTML 태그를 출력하면 안 되고, 
    // 오직 결과 글자('Y' 또는 'N') 딱 하나만 브라우저에 던져줘야 합니다.
    out.print(result);
%>