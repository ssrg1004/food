<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dao.MemberDAO" %>    
    
<%

	String nickname = request.getParameter("nickname");
	String mId = request.getParameter("mId");
	
	boolean exist = true;

	MemberDAO dao = new MemberDAO();
	
	// 본인 사용중인 닉네임일 시 사용가능함으로 알려주기
	if(dao.checkDuplicateNickname_mypage(nickname, mId) == true){
		out.print("OK");
	// 닉네임 수정할 시
	}else {
		exist = dao.checkDuplicateNickname(nickname);
		// 중복값 있으면 exist = true -> "FAIL" 전달 (사용불가)
		if(exist){
		    out.print("FAIL");
		// 중복값 없으면 exist = false -> "OK" 전달 (사용가능)
		}else{
		    out.print("OK");
		}
	}
	
	
%>