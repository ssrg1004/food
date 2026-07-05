<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dao.ReviewerPostDAO" %>
<%
    // 디버깅: 요청이 제대로 들어오는지 확인
    String action = request.getParameter("action"); 
    String idParam = request.getParameter("draft_id");
    
    out.println("DEBUG: action=" + action + ", draft_id=" + idParam + "<br>");

    if (idParam == null || action == null) {
        out.println("<script>alert('잘못된 요청입니다.'); history.back();</script>");
        return;
    }

    int draft_id = Integer.parseInt(idParam);
    ReviewerPostDAO dao = ReviewerPostDAO.getInstance();

    try {
    	if ("approve".equals(action)) {
            dao.approveDraft(draft_id);
            out.println("<script>alert('승인되었습니다.'); location.href='adminPage.jsp?page=reviewerPost';</script>");
        } else if ("reject".equals(action)) {
            dao.rejectDraft(draft_id);
            out.println("<script>alert('거절되었습니다.'); location.href='adminPage.jsp?page=reviewerPost';</script>");
        } else {
            out.println("<script>alert('유효하지 않은 요청입니다.'); history.back();</script>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('오류가 발생했습니다: " + e.getMessage() + "'); history.back();</script>");
    }
%>