<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page import="web.miniProject.dao.MemberDAO" %>

<%
String id = request.getParameter("id");

if (id == null || id.trim().equals("")) {
    out.print("EMPTY");
    return;
}

/* 🔥 핵심: 영문 소문자 + 숫자만 허용 */
if (!id.matches("^[a-z0-9]+$")) {
    out.print("INVALID");
    return;
}

MemberDAO dao = new MemberDAO();

boolean dup = dao.checkDuplicateId(id);

if (dup) {
    out.print("DUP");
} else {
    out.print("OK");
}
%>