<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="web.miniProject.dao.ReviewerPostDAO"%>
<%@ page import="web.miniProject.dto.MemberDTO"%>

<%
request.setCharacterEncoding("UTF-8");

/* 로그인 체크 */
MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

if(loginUser == null){
    response.sendRedirect("../member/loginForm.jsp");
    return;
}

/* post_id 받기 및 유효성 검증 */
String post_idParam = request.getParameter("post_id");
if(post_idParam == null || post_idParam.trim().isEmpty()){
%>
<script>
alert("잘못된 접근입니다.");
location.href="reviewerPostList.jsp";
</script>
<%
    return;
}

int post_id = Integer.parseInt(post_idParam);
ReviewerPostDAO dao = ReviewerPostDAO.getInstance();

/* 1. 작성자 확인 */
if(!dao.isWriter(post_id, loginUser.getMember_id())){
%>
<script>
alert("본인 글만 삭제할 수 있습니다.");
history.back();
</script>
<%
    return;
}

/* 2. 중복 삭제 요청 확인 (추가된 안전장치) */
if(dao.isAlreadyDrafted(post_id)){
%>
<script>
alert("이미 삭제 요청 승인 대기 중인 게시글입니다.");
location.href="reviewerPostList.jsp";
</script>
<%
    return;
}

/* 3. 삭제 요청 등록 및 DB 예외 처리 */
try {
    //dao.deleteDraft(post_id, loginUser.getMember_id());
%>
<script>
alert("삭제 요청이 접수되었습니다. 관리자 승인 후 삭제됩니다.");
location.href="reviewerPostList.jsp";
</script>
<%
} catch(Exception e) {
    // DB 인서트 실패 시 자바스크립트 안내
%>
<script>
alert("삭제 요청 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.");
history.back();
</script>
<%
}
%>