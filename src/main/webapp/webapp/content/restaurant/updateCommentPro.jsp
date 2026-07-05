<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="web.miniProject.dto.CommentDTO" %>
<%@ page import="web.miniProject.dao.CommentDAO" %>

<% MemberDTO sdto = (MemberDTO) session.getAttribute("loginUser"); %>
<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean class="web.miniProject.dto.CommentDTO" id="dto"/>
<jsp:setProperty name="dto" property="*"/>

<%
	int result = 0;
	CommentDAO dao = new CommentDAO();
	System.out.println("uddateCommentPro : dto.post_id : "+dto.getPost_id());
	// 댓글/답글 수정
	result = dao.updateComment(dto);
	// 등록 실패
	if(result == 0){%>
		<script>
			alert("수정이 실패했습니다.");
			history.go(-1);
		</script>
<%		// 등록 성공	
	}else {%>
		<script>
		<!-- 테스트를 위해 comment.jsp 로 이동시킴 -->
		<!-- 코드 합칠 시에 맛집리뷰 상세페이지로 이동해야됨 -->
		location.href="<%=request.getContextPath()%>/content/restaurant/resContent.jsp?post_id=<%=dto.getPost_id() %>";
		</script>	
<%	}

%>