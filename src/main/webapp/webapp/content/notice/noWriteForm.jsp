<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% request.setAttribute("forceBlock", "Y"); %>
<%@ include file="/content/admin/adminCheck.jsp" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/common.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/noWrite.css">


<%@ include file="../header.jsp" %>


<div class="container">
    <h1>📝 글쓰기</h1>

    <div class="card">
        <form action="noWritePro.jsp" method="post" class="write_form">
            <div class="form_group">
                <label class="form_label">작성자</label>
                <input type="text" name="writer" value="관리자" readonly class="form_input readonly">
            </div>
            
            <div class="form_group">
                <label class="form_label">제목</label>
                <input type="text" name="title" placeholder="공지사항 제목을 입력해주세요" class="form_input">
            </div>
            
            <div class="form_group">
                <label class="form_label">내용</label>
                <textarea name="content" placeholder="공지사항 내용을 입력해주세요" class="form_textarea"></textarea>
            </div>
        
            <div class="write_btn">
                <button type="submit" class="btn primary">등록</button>
                <button type="button" class="btn outline" onclick="location.href='noList.jsp'">취소</button>
            </div>
        </form>
    </div>
</div>