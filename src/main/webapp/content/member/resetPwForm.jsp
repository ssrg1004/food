<%-- 

<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String token = request.getParameter("token");
%>

<html>
<head>
<title>비밀번호 재설정</title>
<style>
    body {
        font-family: 'Noto Sans KR', sans-serif;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        background: #f9f9f9;
    }
    .box {
        width: 360px;
        padding: 30px;
        border: 1px solid #eee;
        border-radius: 12px;
        background: #fff;
        text-align: center;
    }
    input {
        width: 100%;
        padding: 10px;
        margin-top: 10px;
    }
    button {
        width: 100%;
        padding: 12px;
        margin-top: 15px;
        background: #ff7a59;
        color: white;
        border: none;
        cursor: pointer;
        border-radius: 8px;
    }
</style>
</head>

<body>

<div class="box">
    <h2>새 비밀번호 설정</h2>

    <form action="resetPwPro.do" method="post">
        <input type="hidden" name="token" value="<%=token%>">

        <input type="password" name="newPw" placeholder="새 비밀번호 입력" required>

        <button type="submit">비밀번호 변경</button>
    </form>
</div>

</body>
</html>

--%>