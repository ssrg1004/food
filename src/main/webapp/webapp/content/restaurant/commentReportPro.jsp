<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.sql.*" %>
<%@ page import="web.miniProject.dao.CommentDAO" %>

<%
	request.setCharacterEncoding("UTF-8");
	
	int comment_id = Integer.parseInt(request.getParameter("comment_id"));
	int reporter_id = Integer.parseInt(request.getParameter("reporter_id"));
	
	String reason = request.getParameter("reason");
	// 기타사유 텍스트입력 넘어올 시 필요
	/*
	String etc_reason = request.getParameter("etc_reason");
	
	if("기타".equals(reason)){
	    reason = "기타: " + etc_reason;
	}
	*/
	
	int result = 0;
	CommentDAO dao = new CommentDAO();
	
	result = dao.reportComment(comment_id, reporter_id, reason);

	if(result != 0){ %>
	<script>
		alert("신고가 접수되었습니다.");
		
		if(window.opener){

		    const btn =
		        window.opener.document.getElementById(
		            "reportBtn<%=comment_id%>"
		        );

		    if(btn){
		        btn.innerText = "신고완료";
		        btn.disabled = true;
		        btn.classList.add("reportedBtn");
		    }
		}
		
		window.close();
	</script>
	<%}else { %>
	<script>
		alert("신고가 실패하였습니다. 관리자에게 문의해주세요.");
		window.close();
	</script>
<%
	}
%>