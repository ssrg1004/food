<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="web.miniProject.dao.MemberDAO" %>

<% MemberDTO sdto = (MemberDTO) session.getAttribute("loginUser"); %>

<%
	request.setCharacterEncoding("UTF-8");
	
	String pw = request.getParameter("pw");
	
	// 세션의 아이디와 넘어온 pw 값을 dao 탈퇴메서드에 넣어 처리
	String member_id = sdto.getId();
	System.out.println("member_id:"+member_id);
	System.out.println("pw:"+pw);
	
	// MemberDAO dao = new MemberDAO();
	
	// 세션의 아이디와 넘어온 pw 값을 dao 탈퇴메서드에 넣어 처리
	// DAO 메서드 호출		→ 	DB에서 DELETE 작업
	MemberDAO dao = new MemberDAO();
	boolean result = dao.deleteMember(member_id, pw);
	if(result){
		// 세션 초기화
		session.invalidate();
		// 쿠키 삭제
		Cookie[] cookies = request.getCookies();
		if( cookies != null ){
			for( Cookie c : cookies ){
				if(c.getName().equals("cid") || c.getName().equals("cpw") || c.getName().equals("cauto")){
					c.setMaxAge(0);
					response.addCookie(c);
				}
			}
		}
%>
	<script>
	
	alert("탈퇴되었습니다. 맛침반을 이용해주셔서 감사합니다.");
	location.href="<%=request.getContextPath()%>/content/main.jsp";
	
	</script>

	<%
	}else{
	%>
	<script>
	alert("비밀번호를 확인해주세요.");
	location.href="<%=request.getContextPath()%>/content/userPage/myPage.jsp?page=withdraw";
	</script>
<%
}
%>