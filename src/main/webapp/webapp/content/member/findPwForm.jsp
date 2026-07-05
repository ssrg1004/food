<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login.css">

    <script>
        function checkForm() {
            let f = document.forms["findPwForm"];

            if (f.id.value.trim() === "") {
                alert("아이디를 입력해주세요.");
                f.id.focus();
                return false;
            }

            if (f.name.value.trim() === "") {
                alert("이름을 입력해주세요.");
                f.name.focus();
                return false;
            }

            if (f.email.value.trim() === "") {
                alert("이메일을 입력해주세요.");
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
                <h2 style="text-align: center;">비밀번호 찾기</h2>
            </div>

            <form name="findPwForm" action="findPwPro.jsp" method="post" onsubmit="return checkForm();">
                
                <div class="loginFormWrap">
                    
                    <div>
                        <label for="id" class="inputLabel">아이디</label>
                        <input type="text" id="id" name="id" placeholder="아이디를 입력하세요" required>
                    </div>
                    
                    <div>
                        <label for="name" class="inputLabel">이름</label>
                        <input type="text" id="name" name="name" placeholder="이름을 입력하세요" required>
                    </div>
                    
                    <div>
                        <label for="email" class="inputLabel">이메일</label>
                        <input type="text" id="email" name="email" placeholder="이메일을 입력하세요" required>
                    </div>
                    
                    <div style="margin-top: 10px;">
                        <button type="submit" class="profileBtn">비밀번호 찾기</button>
                    </div>
                    
                </div>
                
            </form>
            
        </div>
        
    </div>

</body>
</html>