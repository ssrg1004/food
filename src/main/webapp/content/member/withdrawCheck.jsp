<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛침반</title>
</head>
<body>

<form action="<%=request.getContextPath()%>/content/member/withdrawPro.jsp"
      method="post"
      onsubmit="return withdrawCheck();">

    <div class="withdrawWrap">

        <h2>회원탈퇴 확인</h2>

        <p class="withdrawText">
            회원탈퇴를 진행하려면 비밀번호를 입력해주세요.
        </p>

        <input type="password"
               name="pw"
               class="withdrawInput"
               placeholder="비밀번호 입력">

        <button type="submit"
                class="withdrawBtnFinalCheck">
            회원탈퇴
        </button>
    </div>
</form>

<script>
function withdrawCheck(){
    return confirm("정말 탈퇴하시겠습니까?");
}
</script>


</body>
</html>