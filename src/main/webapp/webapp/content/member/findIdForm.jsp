<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>아이디 찾기</title>
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login.css">

    <script>
        function checkForm() {
            let f = document.forms["findIdForm"];

            if (f.name.value.trim() === "") {
                alert("이름을 입력해주세요");
                f.name.focus();
                return false;
            }

            if (f.email.value.trim() === "") {
                alert("이메일을 입력해주세요");
                f.email.focus();
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
                <h2 style="text-align: center;">아이디 찾기</h2>
            </div>
			<%
			String errorMsg = (String) request.getAttribute("errorMsg");
			%>

			<% if (errorMsg != null) { %>
    			<div style="color:red; text-align:center;">
       			 <%= errorMsg %>
    			</div>
			<% } %>
            <form name="findIdForm" action="findIdPro.jsp" method="post" onsubmit="return checkForm();">
                
                <div class="loginFormWrap">
                    
                    <div>
                        <label class="inputLabel">이름</label>
                        <input type="text" name="name" placeholder="이름을 입력하세요" required>
                    </div>

                    <div>
                        <label class="inputLabel">이메일</label>
                        <input type="text" name="email" placeholder="이메일을 입력하세요" required>
                    </div>

                    <div style="margin-top: 10px;">
                        <button type="submit" class="profileBtn">찾기</button>
                    </div>
                    
                </div>
                
            </form>
            
        </div>
        
    </div>

</body>
</html>