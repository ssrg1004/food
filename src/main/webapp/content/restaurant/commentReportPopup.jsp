<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dto.MemberDTO" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/commentReportPopup.css">

<%
    int comment_id = Integer.parseInt(request.getParameter("comment_id"));

	MemberDTO sdto = (MemberDTO) session.getAttribute("loginUser"); 
    int reporter_id = sdto.getMember_id();
%>



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛침반</title>
</head>
<body>

<div class="reportWrap">

    <div class="reportTitle">
        <span>댓글 신고</span>
        <span>⚠️</span>
    </div>

    <form action="commentReportPro.jsp" method="post">

        <input type="hidden" name="comment_id" value="<%=comment_id%>">
        <input type="hidden" name="reporter_id" value="<%=reporter_id%>">

        <div class="reportList">

            <label class="reportItem">
                <input type="radio" name="reason" value="욕설/비방">
                욕설/비방
            </label>

            <label class="reportItem">
                <input type="radio" name="reason" value="광고/홍보">
                광고/홍보
            </label>

            <label class="reportItem">
                <input type="radio" name="reason" value="도배성 댓글">
                도배성 댓글
            </label>

            <label class="reportItem">
                <input type="radio" name="reason" value="음란/선정성">
                음란/선정성
            </label>

            <label class="reportItem">
                <input type="radio" name="reason" value="개인정보 노출">
                개인정보 노출
            </label>

            <label class="reportItem">
                <input type="radio" name="reason" value="기타" id="etcRadio">
                기타
            </label>
			<!-- 기타사유 텍스트입력 시 필요 -->
            <!-- <textarea name="etc_reason" id="etcText" placeholder="기타 사유 입력"></textarea> -->

        </div>

        <div class="reportBtnArea">
            <button type="submit" class="reportSubmitBtn">댓글 신고</button>
            <button type="button" class="reportCancelBtn" onclick="window.close()">취소</button>
        </div>

    </form>
</div>

<script>
// 기타사유 (텍스트 입력 시 필요)
/*
const etcRadio = document.getElementById("etcRadio");
const etcText = document.getElementById("etcText");

document.querySelectorAll("input[name='reason']").forEach(radio => {
    radio.addEventListener("change", function(){
        if(etcRadio.checked){
            etcText.style.display = "block";
        }else{
            etcText.style.display = "none";
            etcText.value = "";
        }
    });
});
*/
</script>

</body>
</html>