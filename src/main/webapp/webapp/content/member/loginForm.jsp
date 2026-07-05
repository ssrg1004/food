<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login.css">

    <script>
        function validateLogin() {
            const id = document.loginForm.id.value.trim();
            const pw = document.loginForm.pw.value.trim();

            if (id === "") {
                alert("아이디를 입력하세요");
                document.loginForm.id.focus();
                return false;
            }

            if (pw === "") {
                alert("비밀번호를 입력하세요");
                document.loginForm.pw.focus();
                return false;
            }

            return true;
        }
    </script>
</head>

<body>

    <div class="loginContainer">
        
        <div class="mypageContent">
            
            <div class="profileWrap" style="width: 100%; margin: 0 0 25px 0;">
                <h2 style="text-align: center;">로그인</h2>
            </div>

            <form name="loginForm" action="loginPro.jsp" method="post" onsubmit="return validateLogin()">
                
                <div class="loginFormWrap">
                    
                    <div>
                        <input type="text" name="id" placeholder="아이디" required>
                    </div>
                    
                    <div>
                        <input type="password" name="pw" placeholder="비밀번호" required>
                    </div>
                    
                    <div class="autoLoginArea">
                        <input type="checkbox" name="auto" value="1" id="autoCheck" checked style="cursor:pointer;">
                        <label for="autoCheck" style="cursor:pointer; user-select: none;">로그인 상태 유지</label>
                    </div>
                    
                    <div style="margin-top: 10px;">
                        <input type="submit" class="profileBtn" value="로그인" style="width: 100%;">
                    </div>
                    
                </div>
                
            </form>

            <div class="loginLinks">
                <a href="#" onclick="openRegisterPopup(); return false;">회원가입</a>
                <a href="#" onclick="openFindPopup(); return false;">아이디·비밀번호 찾기</a>
            </div>
            
        </div>
        
    </div>
    
    <%-- 팝업 창 스크립트 --%>
    <script>
    function openRegisterPopup() {
        var url = "insertForm.jsp"; 
        var title = "회원가입";
        var width = 470;
        var height = 800;
        var left = (window.screen.width / 2) - (width / 2);
        var top = (window.screen.height / 2) - (height / 2);
        var options = "width=" + width + ",height=" + height + ",left=" + left + ",top=" + top + ",scrollbars=yes, resizable=no";
        window.open(url, title, options);
    }

    function openFindPopup() {
        var url = "findIdPw.jsp";
        var title = "계정찾기";
        var width = 450;  
        var height = 550;
        var left = (window.screen.width / 2) - (width / 2);
        var top = (window.screen.height / 2) - (height / 2);
        var options = "width=" + width + ",height=" + height + ",left=" + left + ",top=" + top + ",scrollbars=yes, resizable=no";
        window.open(url, title, options);
    }
    </script>    
</body>
</html>