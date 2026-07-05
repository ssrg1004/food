<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="web.miniProject.dao.MemberDAO" %>

<%
request.setCharacterEncoding("UTF-8");

/* =========================
   1. 파라미터 받기
========================= */
String id = request.getParameter("id");
String pw = request.getParameter("pw");
String name = request.getParameter("name");
String nickname = request.getParameter("nickname");
String birth = request.getParameter("birth");
String email = request.getParameter("email");

String zipcode = request.getParameter("zipcode");
String address1 = request.getParameter("address1");
String address2 = request.getParameter("address2");

String telecom = request.getParameter("telecom");
String phone = request.getParameter("phone");
String gender = request.getParameter("gender");

String reviewerYn = request.getParameter("evaluatorCheck");
if (reviewerYn == null) {
    reviewerYn = "N";
}

String reviewerUrl = request.getParameter("blogUrl");
System.out.println("insertPro : reviwere_url : " + reviewerUrl);

/* =========================
   2. 기본 null 방어
========================= */
if (id == null || pw == null || nickname == null) {
%>
<script>
    alert("잘못된 접근입니다.");
    history.back();
</script>
<%
    return;
}

/* =========================
   3. 아이디 형식 검증 (핵심)
   영문 소문자 + 숫자만 허용
========================= */
if (!id.matches("^[a-z0-9]+$")) {
%>
<script>
    alert("아이디는 영문 소문자와 숫자만 가능합니다.");
    history.back();
</script>
<%
    return;
}

/* =========================
   4. DAO 생성
========================= */
MemberDAO dao = new MemberDAO();

/* =========================
   5. 아이디 중복 체크
========================= */
if (dao.checkDuplicateId(id)) {
%>
<script>
    alert("이미 존재하는 아이디입니다.");
    history.back();
</script>
<%
    return;
}

/* =========================
   6. 닉네임 중복 체크
========================= */
if (dao.checkDuplicateNickname(nickname)) {
%>
<script>
    alert("이미 존재하는 닉네임입니다.");
    history.back();
</script>
<%
    return;
}

/* =========================
   7. DTO 세팅
========================= */
MemberDTO dto = new MemberDTO();

dto.setId(id);
dto.setPw(pw);
dto.setName(name);
dto.setNickname(nickname);
dto.setBirth(birth);
dto.setEmail(email);

dto.setZipcode(zipcode);
dto.setAddress1(address1);
dto.setAddress2(address2);

dto.setTelecom(telecom);
dto.setPhone(phone);
dto.setGender(gender);

dto.setReviewer_yn(reviewerYn);
dto.setReviewer_url(reviewerUrl);
dto.setRole("USER");


System.out.println("insertPro : dto.getId() : " + dto.getId());

/* =========================
   8. INSERT 실행
========================= */
int result = dao.insertMember(dto);

/* =========================
   9. 결과 처리
========================= */
if (result > 0) {
%>
<script>
    alert("회원가입이 완료되었습니다.");

    if (window.opener && !window.opener.closed) {
        window.opener.location.href = "loginForm.jsp";
        window.close();
    } else {
        location.href = "loginForm.jsp";
    }
</script>
<%
} else {
%>
<script>
    alert("회원가입에 실패했습니다. 다시 시도해주세요.");
    history.back();
</script>
<%
}
%>