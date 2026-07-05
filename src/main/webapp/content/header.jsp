<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dto.MemberDTO" %>

<% 
	MemberDTO sdtoHeader = (MemberDTO) session.getAttribute("loginUser"); 
%>
<header>
    <div class="logo">
        <a href="<%=request.getContextPath()%>/content/main.jsp">🍽️ 맛침반</a>
    </div>
    <nav>
        <a href="<%=request.getContextPath()%>/content/restaurant/restaurantList.jsp">맛집공유</a>
        <a href="<%=request.getContextPath()%>/content/reviewer/reviewerPostList.jsp">맛집평가단</a>
        <a href="<%=request.getContextPath()%>/content/map/mapMain.jsp">맛집지도</a>
        <a href="<%=request.getContextPath()%>/content/notice/noList.jsp">공지사항</a>
    </nav>

    <div class="userBlock">
    <!-- 로그인 X -->
    <% if(sdtoHeader == null) { %>
       	<button class="loginBtn" onclick="window.location='<%=request.getContextPath()%>/content/member/loginForm.jsp'">로그인</button>
    <!-- 로그인 했을 시 -->
   	<%}else { %>
	    <%
	        // 1. 세션 유저의 role 가져옴
	        String userRole = sdtoHeader.getRole();
	        
	        // 2. 기본 이동 경로는 일반 회원용 마이페이지로 설정
	        String myPagePath = request.getContextPath() + "/content/userPage/myPage.jsp"; 
	        
	        // 3. role이 "admin"일 때만 관리자 페이지 경로로 변경
	        if ("admin".equals(userRole)) {
	            myPagePath = request.getContextPath() + "/content/admin/adminPage.jsp";
	        }
	    %>
	    <a href="<%= myPagePath %>">
	        <img class="personImg" src="<%=request.getContextPath()%>/images/person.png">
	    </a>
	           	
   		<div>
   			<a class="headNickname" href="<%= myPagePath %>"><%=sdtoHeader.getNickname() %></a>
   			 님 환영합니다.
   		</div>
		<button class="logoutBtn" onclick="window.location='<%=request.getContextPath()%>/content/member/logoutForm.jsp'">로그아웃</button>
   	<%} %>

    </div>
</header>
