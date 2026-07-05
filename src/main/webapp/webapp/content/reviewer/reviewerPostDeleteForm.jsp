<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="web.miniProject.dto.MemberDTO"%>

<%
request.setCharacterEncoding("UTF-8");

/* 로그인 체크 */
MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

if(loginUser == null){
    response.sendRedirect("../member/loginForm.jsp");
    return;
}

/* postId 받기 */
String post_idParam = request.getParameter("post_id");

if(post_idParam == null || post_idParam.trim().isEmpty()){
%>
<script>
alert("잘못된 접근입니다.");
history.back();
</script>
<%
    return;
}

int postId = Integer.parseInt(post_idParam);
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 삭제</title>
<link rel="stylesheet" href="../css/reviewer.css"> 
</head>
<body>

<div class="deleteContainer">

    <h2>게시글 삭제</h2>
    <p>정말로 이 게시글을 삭제하시겠습니까?<br>삭제 요청 후 관리자 승인을 거쳐 최종 삭제됩니다.</p>

    <form action="reviewerPostDeletePro.jsp" method="post">
        <input type="hidden" name="post_id" value="<%=post_idParam%>">
        
        <div class="btnGroup">
            <button type="submit" class="btn-delete-action">삭제</button>
            <button type="button" class="btn-cancel-action" 
                    onclick="location.href='reviewerPostList.jsp'">취소</button>
        </div>
    </form>

</div>

</body>
</html>