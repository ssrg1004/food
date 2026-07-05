<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="web.miniProject.dto.NoticeDTO" %>
<%@ page import="web.miniProject.dao.NoticeDAO" %>
<%@ page import="web.miniProject.dto.MemberDTO" %>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/common.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/noList.css">
<%@ include file="/content/admin/adminCheck.jsp" %>
<%@ include file="/content/header.jsp" %>

<%
SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd");
NoticeDAO dao = new NoticeDAO();

// 현재 페이지
String pageNum = request.getParameter("pageNum");
if(pageNum == null){
	pageNum = "1";
}

// 현재 페이지 번호
int currentPage = Integer.parseInt(pageNum);

// 한 페이지에 보여줄 글 수
int pageSize = 10;

// 시작행 , 끝행 번호 계산
int startRow =(currentPage -1) * pageSize +1;
int endRow = currentPage * pageSize;

// 페이징 목록 조회
ArrayList<NoticeDTO> list = dao.list(startRow, endRow);

// 전체 게시글 수
int count = dao.getCount();

// 화면에 나오는 번호
int no = count - (currentPage -1) * pageSize;
%>
<div class="container">
<h1>📢 공지사항</h1>
    <!-- 글쓰기 버튼 영역 -->
<% if("admin".equals(role)) { %>
    <div class="top-btns">
        <a href="noWriteForm.jsp" class="btn primary">글쓰기</a>
    </div>
<% } %>
<table class="noList">
	<tr>
		<th>번호</th>
		<th>제목</th>
		<th>작성자</th>
		<th>조회수</th>
		<th>작성일자</th>
	</tr>
<%	
	for(NoticeDTO dto : list){
%>
	<tr>
		<td><%= no-- %></td>
		<td class="titleCell">
			<a href="noContent.jsp?notice_id=<%= dto.getNotice_id() %>"><%= dto.getTitle() %></a>
		</td>
		<td><%= dto.getWriter() %></td>
		<td><%= dto.getView_cnt() %></td>
		<td><%= sdf.format(dto.getReg_date()) %></td>
	</tr>
<% } %>
</table>

<% 
// 총 페이지 수 계산
int pageCount = count/pageSize;
// 글이 있을 때만 페이징 링크
if(count % pageSize !=0){
	pageCount++;
}
%>
<div class="paging">
<% 
    for(int i = 1; i <= pageCount; i++) { 
        // 현재 내가 보고 있는 페이지 번호라면 active 클래스를 줍니다.
        if (i == currentPage) { 
%>
            <a href="noList.jsp?pageNum=<%=i%>" class="active"><%=i%></a>
<% 
        } else { 
%>
            <a href="noList.jsp?pageNum=<%=i%>"><%=i%></a>
<% 
        }
    } 
%>
</div>
</div>
