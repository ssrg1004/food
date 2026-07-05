<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="web.miniProject.dto.CommentDTO" %>
<%@ page import="web.miniProject.dao.CommentDAO" %>

<% MemberDTO sdto = (MemberDTO) session.getAttribute("loginUser"); %>
<% request.setCharacterEncoding("UTF-8"); %>

<% 
	int comment_id = Integer.parseInt(request.getParameter("comment_id"));
	int post_id = Integer.parseInt(request.getParameter("post_id")); 
%>

<%
	int result = 0;
	CommentDAO dao = new CommentDAO();
	
	// 댓글/답글 삭제
	result = dao.deleteComment(comment_id, sdto.getMember_id());
	// 삭제 실패
	if(result == 0){%>
		<script>
			alert("삭제 실패했습니다.");
			history.go(-1);
		</script>
<%		// 삭제 성공	
	}else {%>
		<script>
		<!-- 테스트를 위해 comment.jsp 로 이동시킴 -->
		<!-- 코드 합칠 시에 맛집리뷰 상세페이지로 이동해야됨 -->
		alert("삭제되었습니다.");
		location.href="<%=request.getContextPath()%>/content/restaurant/resContent.jsp?post_id=<%=post_id %>";
		</script>	
<%	}

%>