<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dao.MemberDAO" %>
<%@ page import="web.miniProject.dto.MemberDTO" %>

<%
    // 1. 인코딩
    request.setCharacterEncoding("UTF-8");

    // 2. 파라미터 받기
    String id = request.getParameter("id");
    String pw = request.getParameter("pw");
    String auto = request.getParameter("auto"); // 로그인 유지 체크

    // 3. DTO 세팅
    MemberDTO dto = new MemberDTO();
    dto.setId(id);
    dto.setPw(pw);

    // 4. DAO 호출
    MemberDAO dao = new MemberDAO();
    MemberDTO result = dao.loginCheck(dto);

    // 5. 로그인 성공
    if (result != null) {

        // 세션 생성
        session.setAttribute("loginUser", result);
        // 세션 24시간 유지
        session.setMaxInactiveInterval(60 * 60 * 24);

        // 자동 로그인 (선택)
        if (auto != null && auto.equals("1")) {
            Cookie cookie = new Cookie("loginId", id);
            cookie.setMaxAge(60 * 60 * 24 * 7); // 7일
            cookie.setPath("/");
            response.addCookie(cookie);
        }

        // 이동
        response.sendRedirect("../main.jsp");
        return;
    }

    // 6. 로그인 실패
%>

<script>
    alert("아이디 또는 비밀번호가 일치하지 않습니다.");
    history.back();
</script>