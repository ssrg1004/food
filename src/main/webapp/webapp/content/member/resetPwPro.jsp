<%--
<%@ page import="web.miniProject.dao.MemberDAO" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
request.setCharacterEncoding("UTF-8");

String token = request.getParameter("token");
String newPw = request.getParameter("newPw");

MemberDAO dao = new MemberDAO();

int memberId = dao.findMemberByToken(token);

if (memberId != -1) {
    dao.updatePasswordAndClearToken(memberId, newPw);
%>

<script>
    alert("비밀번호가 변경되었습니다.");
    location.href = "login.jsp";
</script>

<%
} else {
%>

<script>
    alert("유효하지 않거나 만료된 링크입니다.");
    location.href = "resetPwForm.jsp";
</script>

<%
}
%>  --%>