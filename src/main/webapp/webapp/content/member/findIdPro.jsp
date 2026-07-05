<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="web.miniProject.dao.MemberDAO" %>

<%
request.setCharacterEncoding("UTF-8");

String name = request.getParameter("name");
String email = request.getParameter("email");

if (name != null) name = name.trim();
if (email != null) email = email.trim();

MemberDAO dao = new MemberDAO();
String id = dao.findId(name, email);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기 결과</title>
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login.css">
</head>

<body>

    <div class="loginContainer">
        
        <div class="mypageContent">

            <% if (id == null) { %>
                
                <div class="profileWrap" style="width: 100%; margin: 0 0 20px 0;">
                    <h2 style="text-align: center;">조회 결과</h2>
                </div>
                <div class="resultMessage" style="margin-top: 30px; margin-bottom: 35px;">
                    일치하는 회원 정보가 없습니다.
                </div>

				<div style="margin-top:20px;">
        			<a href="findIdForm.jsp" class="profileBtn">다시 아이디 찾기</a>
    			</div>
            <% } else { %>
                
                <div class="profileWrap" style="width: 100%; margin: 0 0 20px 0;">
                    <h2 style="text-align: center;">아이디 찾기 성공</h2>
                </div>
                <div class="resultMessage" style="margin-top: 20px; margin-bottom: 5px;">
                    회원님의 아이디는 다음과 같습니다.
                </div>
                <div class="resultIdDisplay"><%= id %></div>

            <% } %>

            <div class="findMenuWrap">
                <a href="findPwForm.jsp" class="profileBtn">비밀번호 찾기</a>
                <a href="loginForm.jsp" class="subBtn">로그인으로 이동</a>
            </div>

        </div>

    </div>

</body>
</html>