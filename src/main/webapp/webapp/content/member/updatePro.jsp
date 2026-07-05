<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="web.miniProject.dto.MemberDTO" %>

<% request.setCharacterEncoding("UTF-8"); %>

<% MemberDTO sdto = (MemberDTO) session.getAttribute("loginUser"); %>

<jsp:useBean class="web.miniProject.dao.MemberDAO" id="dao" />
<jsp:useBean class="web.miniProject.dto.MemberDTO" id="dto" />
<jsp:setProperty name="dto" property="*"/>

<%
	System.out.println("updatePro : session getId : "+sdto.getId());
	System.out.println("updatePro : session getReviewer_yn : "+sdto.getReviewer_yn());
	// dto = 회원정보 수정 폼에서 submit 한 정보들의 묶음
	// sdto.getPw() = 로그인한 유저의 비밀번호 정보
	int result = dao.updateMember(dto);
	System.out.println("updatePro : 수정 전 dto.getReviewer_yn : "+dto.getReviewer_yn());
	// 정보 수정 완료
	if(result == 1){
		// 세션에 변경된 유저정보 dto로 변경 및 유지시간 초기화(24시) 
		System.out.println("updatePro : result = 1 : 수정완료");
		System.out.println("updatePro : dto.getId : "+dto.getId());
		System.out.println("updatePro : dto.getReviewer_yn : "+dto.getReviewer_yn());
		session.setAttribute("loginUser", dto);
		session.setMaxInactiveInterval(60 * 60 * 24);
	%>
	<script>
		alert("회원정보가 수정되었습니다.");
		window.location="../userPage/myPage.jsp?page=profile";
	</script>
<%	}else{%>
	<script>
		alert("회원정보 수정이 실패했습니다.\n올바르게 정보가 입력되었는지 다시 확인해주세요.");
		history.go(-1);
	</script>
<%	}%>