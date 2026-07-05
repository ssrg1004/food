<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>계정 찾기</title>
    
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/login.css">
</head>

<body>

    <div class="loginContainer">
        
        <div class="mypageContent">
            
            <div class="profileWrap" style="width: 100%; margin: 0 0 25px 0;">
                <h2 style="text-align: center;">아이디 · 비밀번호 찾기</h2>
            </div>

            <div class="findMenuWrap">
                
                <a href="javascript:void(0);" 
                   onclick="if(opener && !opener.closed){ opener.location.href='findIdForm.jsp'; } window.close();" 
                   class="profileBtn">
                   아이디 찾기
                </a>

                <a href="javascript:void(0);" 
                   onclick="if(opener && !opener.closed){ opener.location.href='findPwForm.jsp'; } window.close();" 
                   class="profileBtn">
                   비밀번호 찾기
                </a>
                
            </div>
            
        </div>
        
    </div>

</body>
</html>