<%@ page import="web.miniProject.dao.MemberDAO" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String email = request.getParameter("email");

    MemberDAO dao = new MemberDAO();
    String password = dao.findPassword(id, name, email);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 찾기 결과</title>
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login.css?v=103">
</head>

<body>

<div class="loginContainer">

    <div class="mypageContent">

        <div style="width: 100%; margin: 0 0 25px 0;">
            <h2 style="text-align: center; font-size: 22px; font-weight: bold; color: #333;">비밀번호 찾기 결과</h2>
        </div>

        <div class="loginFormWrap">

            <%
                if (password != null) {
            %>
                <p class="resultMessage" style="margin-bottom: 5px;">회원님의 비밀번호를 찾았습니다.</p>
                
                <h2 class="resultIdDisplay"><%= password %></h2>

                <div style="margin-top: 10px;">
                    <a href="loginForm.jsp" style="text-decoration: none;">
                        <button type="button" class="profileBtn">로그인으로 이동</button>
                    </a>
                </div>

            <%
                } else {
            %>
                <p class="resultMessage" style="color: #ff2e2e; font-weight: 600; margin-bottom: 5px;">
                    일치하는 회원 정보가 없습니다.
                </p>
                <p class="resultMessage" style="font-size: 13px; color: #888;">
                    입력하신 아이디, 이름, 이메일 정보를 다시 한번 확인해 주세요.
                </p>

                <div style="margin-top: 15px;">
                    <a href="findPwForm.jsp" style="text-decoration: none;">
                        <button type="button" class="subBtn">다시 찾기</button>
                    </a>
                </div>

            <%
                }
            %>

        </div>

    </div>

</div>

</body>
</html>

<!--
    <div class="loginContainer">
        
        <div class="mypageContent">
            
            <div class="profileWrap" style="width: 100%; margin: 0 0 20px 0;">
                <h2 style="text-align: center; font-size: 22px;">비밀번호 재설정 메일 발송</h2>
            </div>
            
            <div class="resultMessage" style="margin-top: 30px; margin-bottom: 35px;">
                가입하신 이메일로 비밀번호 재설정 링크를 전송했습니다.<br>
                메일함에서 링크를 확인해 주세요.
            </div>
            
            <div class="findMenuWrap">
                <a href="loginForm.jsp" class="profileBtn">로그인 화면으로</a>
            </div>
            
        </div>
        
    </div>
-->
