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
	// 댓글 등록 (comment)
	if(dto.getParent_id() == null){
		result = dao.insertComment(dto);
		// 등록실패
		if(result == 0){%>
			<script>
				alert("답글 작성이 실패했습니다.");
				history.go(-1);
			</script>		
<%		// 등록 성공
		}else { %>
			<script>
			<!-- 맛집리뷰 상세페이지로 이동 -->
				location.href="<%=request.getContextPath()%>/content/restaurant/resContent.jsp?post_id=<%=dto.getPost_id() %>";
			</script>
<%		}
	}
	// 답글 등록 (reply)
	// 답글은 부모 아이디가 필수로 있음
	if(dto.getParent_id() != null){
		result = dao.insertReply(dto);
		// 등록 실패
		if(result == 0){%>
			<script>
				alert("답글 작성이 실패했습니다.");
				history.go(-1);
			</script>
<%		// 등록 성공	
		}else {%>
			<script>
			<!-- 맛집리뷰 상세페이지로 이동 -->
			location.href="<%=request.getContextPath()%>/content/restaurant/resContent.jsp?post_id=<%=dto.getPost_id() %>";
			</script>	
<%		}
	}
%>