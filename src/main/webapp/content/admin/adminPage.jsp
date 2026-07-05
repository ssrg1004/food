<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dao.MemberDAO" %>
<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="web.miniProject.dao.CommentDAO" %>
<%@ page import="web.miniProject.dto.CommentDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="web.miniProject.dao.ReviewerPostDAO" %>
<%@ page import="web.miniProject.dto.ReviewerDraftDTO" %>
<%@ page import="java.util.ArrayList" %>
<% request.setAttribute("forceBlock", "Y"); %>
<%@ include file="/content/admin/adminCheck.jsp" %>
<%
// 우측 내용부분 처리
String pageType = request.getParameter("page");

if(pageType == null){
    pageType = "memberList"; 
}
%>   
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛침반</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/common.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">

</head>
<body>

<%@ include file="../header.jsp" %>


<div class="mypageWrap">

    <h1>관리자페이지</h1>

    <div class="mypageBody">
    
        <div class="mypageMenu">
			<a href="adminPage.jsp?page=memberList">회원목록</a>
			
			<a href="adminPage.jsp?page=reviewerAllow">
				평가단 승인
			</a>
			
			<a href="adminPage.jsp?page=reviewerPost">
				평가단 글
			</a>
			
			<a href="adminPage.jsp?page=commentReport">
				댓글 신고
			</a>
			
		</div>
		
       <div class="mypageContent">
            <%
            if(pageType.equals("memberList")){
            	
            	// 1. 검색어 및 현재 페이지 번호 파라미터 받기
            	String searchKeyword = request.getParameter("searchKeyword");
            	if(searchKeyword == null){
            		searchKeyword = "";
            	}
            	
            	String strPageNum = request.getParameter("pageNum");
            	int pageNum = 1; 
            	if(strPageNum != null) {
            		pageNum = Integer.parseInt(strPageNum);
            	}
            	
            	// 2. 진짜 DB 데이터 세트 받아오기
            	MemberDAO dao = new MemberDAO();
            	List<MemberDTO> filteredList = dao.getMemberList(searchKeyword);
            	
            	// 3. 페이징 계산
            	int pageSize = 10;                    
            	int count = filteredList.size();     
            	
            	int pageCount = count / pageSize;    
            	if(count % pageSize != 0) {
            		pageCount++;                     
            	}
            	
            	int startRow = (pageNum - 1) * pageSize;
            	int endRow = startRow + pageSize;
            	if(endRow > count) {
            		endRow = count;
            	}
            %>
            	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; padding-bottom: 15px; border-bottom: 2px solid #333;">
            		<h2 style="font-size: 24px; color: #333; margin: 0;">회원목록 조회 (<%= count %>명)</h2>
            		
            		<form action="adminPage.jsp" method="get" class="nicknameArea">
            			<input type="hidden" name="page" value="memberList">
            			<input type="text" name="searchKeyword" placeholder="아이디 또는 이름 입력" 
            					value="<%= searchKeyword %>" style="width: 240px;">
            			<button type="submit">검색</button>
            			
            			<% if(!searchKeyword.equals("")){ %>
            				<a href="adminPage.jsp?page=memberList" style="display: inline-block; padding: 8px 15px; text-decoration: none; color: #333; border: 1px solid #ddd; border-radius: 6px; background: white; font-size: 14px; height: 42px; line-height: 24px;">전체보기</a>
            			<% } %>
            		</form>
            	</div>
            	
            	<table class="profileTable" style="text-align: center;">
                    <thead>
                        <tr>
                            <th style="text-align: center; font-weight: bold; width: 8%; padding: 10px 8px;">번호</th>
                            <th style="text-align: center; font-weight: bold; width: 17%; padding: 10px 8px;">아이디</th>
                            <th style="text-align: center; font-weight: bold; width: 15%; padding: 10px 8px;">이름</th>
                            <th style="text-align: center; font-weight: bold; width: 28%; padding: 10px 8px;">이메일</th>
                            <th style="text-align: center; font-weight: bold; width: 17%; padding: 10px 8px;">가입일</th>
                            <th style="text-align: center; font-weight: bold; width: 15%; padding: 10px 8px;">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if(count == 0) {
                        %>
                            <tr>
                                <td colspan="6" style="text-align: center; color: #999; padding: 50px 0;">
                                    '<%= searchKeyword %>'에 대한 검색 결과가 없습니다.
                                    </td>
                                </tr>
                            <%
                            } else {
                            	for(int i = startRow; i < endRow; i++) {
                            		MemberDTO member = filteredList.get(i);
                            %>
                                    <tr>
                                        <td style="padding: 10px 8px;"><%= member.getMember_id() %></td>
                                        <td style="padding: 10px 8px;"><%= member.getId() %></td>
                                        <td style="padding: 10px 8px;"><%= member.getName() %></td>
                                        <td style="padding: 10px 8px;"><%= member.getEmail() %></td>
                                        <td style="padding: 10px 8px;"><%= member.getReg_date() %></td>
                                        <td>
                                            <button class="withdrawBtn" type="button" 
            										onclick="kickMember('<%= member.getId() %>', '<%= member.getName() %>')" 
            										style="width: 70px; height: 35px; font-size: 13px; background-color: #d9534f; color: white; border: none; border-radius: 4px; cursor: pointer;">
        											추방
    										</button>
                                        </td>
                                    </tr>
                            <%
                            	}
                            }
                            %>
                        </tbody>
                    </table>
                
                <% if(pageCount > 0) { %>
	                <div class="paging" style="margin-top: 40px;">
	                	<%
	                	for(int i=1; i<=pageCount; i++) {
	                		String activeClass = (i == pageNum) ? "class='active'" : "";
	                	%>
	                		<a href="adminPage.jsp?page=memberList&pageNum=<%=i%>&searchKeyword=<%=searchKeyword%>" <%=activeClass%>><%=i%></a>
	                	<%
	                	}
	                	%>
	                </div>
                <% } %>
                
            <%
            }
            else if(pageType.equals("reviewerAllow")){
            	// 📍 [수정 구역] 오직 승인 대기자만 필터링하여 노출하는 핵심 로직
            	String searchKeyword = request.getParameter("searchKeyword");
            	if(searchKeyword == null){
            		searchKeyword = "";
            	}
            	
            	String strPageNum = request.getParameter("pageNum");
            	int pageNum = 1; 
            	if(strPageNum != null) {
            		pageNum = Integer.parseInt(strPageNum);
            	}
            	
            	MemberDAO dao = new MemberDAO();
            	
            	// 📍 [체크!] 모든 일반회원이 아닌, 대기자('s') 목록만 골라오는 전용 메서드로 연결합니다.
            	List<MemberDTO> applyList = dao.getReviewerApplyList(searchKeyword); 
            	
            	int pageSize = 10;                    
            	int count = applyList.size();     
            	
            	int pageCount = count / pageSize;    
            	if(count % pageSize != 0) {
            		pageCount++;                     
            	}
            	
            	int startRow = (pageNum - 1) * pageSize;
            	int endRow = startRow + pageSize;
            	if(endRow > count) {
            		endRow = count;
            	}
            %>
            	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; padding-bottom: 15px; border-bottom: 2px solid #333;">
            		<h2 style="font-size: 24px; color: #333; margin: 0;">평가단 승인 관리 (<%= count %>명 대기 중)</h2>
            		
            		<form action="adminPage.jsp" method="get" class="nicknameArea">
            			<input type="hidden" name="page" value="reviewerAllow">
            			<input type="text" name="searchKeyword" placeholder="아이디 또는 이름 입력" 
            					value="<%= searchKeyword %>" style="width: 240px;">
            			<button type="submit">검색</button>
            			
            			<% if(!searchKeyword.equals("")){ %>
            				<a href="adminPage.jsp?page=allowReviewer" style="display: inline-block; padding: 8px 15px; text-decoration: none; color: #333; border: 1px solid #ddd; border-radius: 6px; background: white; font-size: 14px; height: 42px; line-height: 24px;">전체보기</a>
            			<% } %>
            		</form>
            	</div>
            	
            	<table class="profileTable" style="text-align: center; width:100%;">
                    <thead>
                        <tr>
                            <th style="text-align: center; font-weight: bold; width: 8%; padding: 10px 8px;">번호</th>
                            <th style="text-align: center; font-weight: bold; width: 17%; padding: 10px 8px;">아이디</th>
                            <th style="text-align: center; font-weight: bold; width: 15%; padding: 10px 8px;">이름</th>
                            <th style="text-align: center; font-weight: bold; width: 17%; padding: 10px 8px;">현재 권한</th>
                            <th style="text-align: center; font-weight: bold; width: 23%; padding: 10px 8px;">신청일</th>
                            <th style="text-align: center; font-weight: bold; width: 20%; padding: 10px 8px;">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if(count == 0) {
                        %>
                            <tr>
                                <td colspan="6" style="text-align: center; color: #999; padding: 50px 0;">
                                    현재 승인 대기 중인 신청자가 없습니다.
                                </td>
                            </tr>
                        <%
                        } else {
                            	for(int i = startRow; i < endRow; i++) {
                            		MemberDTO member = applyList.get(i);
                            %>
                                    <tr>
                                        <td style="padding: 10px 8px;"><%= member.getMember_id() %></td>
                                        <td style="padding: 10px 8px;"><%= member.getId() %></td>
                                        <td style="padding: 10px 8px;"><%= member.getName() %></td>
                                        <td style="padding: 10px 8px;">
                                        	<span style="color: #ea9b4a; font-weight: bold;">승인대기</span>
                                        </td>
                                        <td style="padding: 10px 8px;"><%= member.getReg_date() %></td>
                                        <td style="padding: 10px 8px;">
                                            <button type="button" 
            										onclick="processReviewer('<%= member.getId() %>', '<%= member.getName() %>', 'approve')" 
            										style="width: 60px; height: 35px; font-size: 13px; background-color: #5cb85c; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">
        											승인
    										</button>
    										<button class="withdrawBtn" type="button" 
            										onclick="processReviewer('<%= member.getId() %>', '<%= member.getName() %>', 'reject')" 
            										style="width: 60px; height: 35px; font-size: 13px; background-color: #d9534f; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; margin-left: 4px;">
        											거절
    										</button>
                                        </td>
                                    </tr>
                            <%
                            	}
                            }
                            %>
                        </tbody>
                    </table>
                
                <% if(pageCount > 0) { %>
	                <div class="paging" style="margin-top: 40px;">
	                	<%
	                	for(int i=1; i<=pageCount; i++) {
	                		String activeClass = (i == pageNum) ? "class='active'" : "";
	                	%>
	                		<a href="adminPage.jsp?page=reviewerAllow&pageNum=<%=i%>&searchKeyword=<%=searchKeyword%>" <%=activeClass%>><%=i%></a>
	                	<%
	                	}
	                	%>
	                </div>
                <% } %>
            <%
            }
            else if(pageType.equals("reviewerPost")){
                // 1. DAO 생성 
                ReviewerPostDAO dao = ReviewerPostDAO.getInstance();
                // 2. 대기 중인 목록 가져오기
                ArrayList<ReviewerDraftDTO> waitList = dao.getWaitingList();
                int count = waitList.size();
            %>
            	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; padding-bottom: 15px; border-bottom: 2px solid #333;">
                	<h2 style="font-size: 24px; color: #333; margin: 0;">평가단 게시글 승인 관리 (<%= count %>건)</h2>
                </div>
                <table class="profileTable" style="text-align: center;">
                    <thead>
                        <tr>
                            <th style="text-align: center; font-weight: bold; width: 8%;">번호</th>
                            <th style="text-align: center; font-weight: bold; width: 8%;">목적</th>
                            <th style="text-align: center; font-weight: bold; width: 43%;">제목</th>
                            <th style="text-align: center; font-weight: bold; width: 12%;">작성자</th>
                            <th style="text-align: center; font-weight: bold; width: 12%;">요청일</th>
                            <th style="text-align: center; font-weight: bold; width: 17%;">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if(count == 0) { %>
                            <tr><td colspan="5"style="text-align: center; color: #999; padding: 50px 0;">승인 대기 중인 글이 없습니다.</td></tr>
                        <% } else {
                            for(ReviewerDraftDTO dto : waitList) { %>
                            <tr>
                                <td><%= dto.getDraft_id() %></td>
                                <% 
                                	String request_type = dto.getRequest_type();
									if(request_type.equals("INSERT")) { request_type = "작성"; }
									else if(request_type.equals("UPDATE")){ request_type = "수정"; }
									else if(request_type.equals("DELETE")){ request_type = "삭제"; }
                                %>
                                <td><%= request_type %></td>
                                <td><%= dto.getTitle() %></td>
                                <td><%= dto.getNickname() %></td>
                                <td><%= dto.getRequest_date() %></td>
                                <td>
                                    <button type="button" onclick="processDraft('<%= dto.getDraft_id() %>', 'approve')"
                                    style="width: 60px; height: 35px; font-size: 13px; background-color: #5cb85c; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">
                                    승인
                                    </button>
                                    <button type="button" onclick="processDraft('<%= dto.getDraft_id() %>', 'reject')"
                                    style="width: 60px; height: 35px; font-size: 13px; background-color: #d9534f; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; margin-left: 4px;">
                                    거절
                                    </button>
                                </td>
                            </tr>
                        <% } } %>
                    </tbody>
                </table>
            <% } 
            else if(pageType.equals("commentReport")){
            	// 1. 검색어 및 현재 페이지 번호 파라미터 받기
            	String searchKeyword = request.getParameter("searchKeyword");
            	if(searchKeyword == null){
            		searchKeyword = "";
            	}
            	
            	String strPageNum = request.getParameter("pageNum");
            	int pageNum = 1; 
            	if(strPageNum != null) {
            		pageNum = Integer.parseInt(strPageNum);
            	}
            	
            	// [연동 변경] 2. CommentDAO를 사용해 진짜 DB에서 신고 리스트 가져오기
            	CommentDAO commentDao = new CommentDAO();
            	List<CommentDTO> filteredList = commentDao.getAdminReportList(searchKeyword);
            	
            	// 3. 페이징 계산 (한 페이지에 6개씩 기존 수치 유지)
            	int pageSize = 6;                    
            	int count = filteredList.size();     
            	
            	int pageCount = count / pageSize;    
            	if(count % pageSize != 0) {
            		pageCount++;                     
            	}
            	
            	int startRow = (pageNum - 1) * pageSize;
            	int endRow = startRow + pageSize;
            	if(endRow > count) {
            		endRow = count;
            	}
            %>
            	<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; padding-bottom: 15px; border-bottom: 2px solid #333;">
            		<h2 style="font-size: 24px; color: #333; margin: 0;">댓글 신고 관리 (<%= count %>건)</h2>
            		
            		<form action="adminPage.jsp" method="get" class="nicknameArea">
            			<input type="hidden" name="page" value="commentReport">
            			<input type="text" name="searchKeyword" placeholder="신고사유 또는 내용 입력" 
            					value="<%= searchKeyword %>" style="width: 240px;">
            			<button type="submit">검색</button>
            			
            			<% if(!searchKeyword.equals("")){ %>
            				<a href="adminPage.jsp?page=commentReport" style="display: inline-block; padding: 8px 15px; text-decoration: none; color: #333; border: 1px solid #ddd; border-radius: 6px; background: white; font-size: 14px; height: 42px; line-height: 24px;">전체보기</a>
            			<% } %>
            		</form>
            	</div>
            	
            	<table class="profileTable" style="text-align: center;">
                    <thead>
                        <tr>
                            <%--<th style="text-align: center; font-weight: bold; width: 8%;">번호</th>--%>
                            <th style="text-align: center; font-weight: bold; width: 16%;">신고사유</th>
                            <th style="text-align: center; font-weight: bold; width: 39%;">신고된 댓글 내용</th>
                            <th style="text-align: center; font-weight: bold; width: 12%;">작성자</th>
                            <th style="text-align: center; font-weight: bold; width: 12%;">신고자</th>
                            <th style="text-align: center; font-weight: bold; width: 21%;">관리</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        if(count == 0) {
                        %>
                            <tr>
                                <td colspan="6" style="text-align: center; color: #999; padding: 50px 0;">
                                    새로운 댓글 신고 내역이 없습니다.
                                </td>
                            </tr>
                        <%
                        } else {
                            // [연동 변경] 진짜 DB 데이터에서 리스트 추출 및 출력
                            for(int i = startRow; i < endRow; i++) {
                                CommentDTO report = filteredList.get(i);
                                System.out.println("adminPage : report.getProcess_yn() = " + report.getProcess_yn());
                        		if(!report.getProcess_yn().equals("Y")){
                        %>
                                <tr>
                                    <%--<td><%= report.getComment_id() %></td>  매핑해둔 신고번호 --%>
                                    <td style="font-weight: bold; color: #e8a052;"><%= report.getStatus() %></td> <%-- 매핑해둔 신고사유 --%>
                                    <td style="text-align: left;">
                                     	<%-- 댓글 내용 --%>
                                    	<a href="../restaurant/resContent.jsp?post_id=<%=report.getPost_id()%>&comment_id=<%=report.getComment_id()%>#commentSection"
                                    		style="text-decoration: none; color: inherit; cursor: pointer;">
                                    		<%= report.getContent() %>
                                    	</a>
                                    </td>
                                    <td><%= report.getNickname() %></td> <%-- 작성자 닉네임 --%>
                                    <td><%= report.getPost_title() %></td> <%-- 매핑해둔 신고자 닉네임 --%>
                                    <td>
                                        <button class="withdrawBtn" type="button" 
            									onclick="processReport('<%= report.getComment_id() %>', 'delete')" 
           									    style="width: 65px; height: 35px; font-size: 13px; background: #d9534f;">
       											 삭제
    									</button>
    									<button type="button" 
            									onclick="processReport('<%= report.getComment_id() %>', 'reject')" 
           										 style="width: 65px; height: 35px; font-size: 13px; border: 1px solid #ddd; background: white; color: #333; border-radius: 6px; cursor: pointer; margin-left: 3px;">
       											 반려
   										 </button>
                                    </td>
                                </tr>

                        <%
                                }
                            }
                        }
                        %>
                        </tbody>
                    </table>
                
                <% if(pageCount > 0) { %>
	                <div class="paging" style="margin-top: 40px;">
	                	<%
	                	for(int i=1; i<=pageCount; i++) {
	                		String activeClass = (i == pageNum) ? "class='active'" : "";
	                	%>
	                		<a href="adminPage.jsp?page=commentReport&pageNum=<%=i%>&searchKeyword=<%=searchKeyword%>" <%=activeClass%>><%=i%></a>
	                	<%
	                	}
	                	%>
	                </div>
                <% } %>
            <% } else if(pageType.equals("notice")){
            %>
                <div class="notice-wrap"><h2>공지사항 관리</h2><p>준비 중입니다.</p></div>
            <%
            }
            %>
    	</div>
	</div>
</div>

<script>
function kickMember(userId, userName) {
    if (confirm(userName + "님을 정말로 추방하시겠습니까?\n삭제된 데이터는 복구할 수 없습니다.")) {
        
        fetch('deleteMember.jsp?id=' + userId)
            .then(response => response.text())
            .then(data => {
                if (data.trim() === 'Y') {
                    alert(userName + "님이 성공적으로 추방되었습니다.");
                    location.reload(); 
                } else {
                    alert("추방 처리에 실패했습니다. 다시 시도해 주세요.");
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert("서버 통신 오류가 발생했습니다.");
            });
    }
}

function processReviewer(userId, userName, type) {
    const actionText = (type === 'approve') ? "평가단으로 승인" : "신청을 거절";
    
    if (confirm(userName + "님의 " + actionText + "하시겠습니까?")) {
        
        fetch('allowReviewerPro.jsp?id=' + userId + '&type=' + type)
            .then(response => response.text())
            .then(data => {
                if (data.trim() === 'Y') {
                    alert("정상적으로 처리되었습니다.");
                    location.reload(); 
                } else {
                    alert("처리에 실패했습니다. 다시 시도해 주세요.");
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert("서버 통신 오류가 발생했습니다.");
            });
    }
}

function processReport(commentId, type) {
    const actionText = (type === 'delete') ? "해당 댓글을 삭제(블라인드) 처리" : "해당 신고를 반려";
    
    if (confirm(actionText + "하시겠습니까?")) {
        // 🛠️ 대기 중인 비동기 처리 페이지(reportProcessPro.jsp)로 comment_id와 type을 들고 갑니다.
        fetch('reportProcessPro.jsp?comment_id=' + commentId + '&type=' + type)
            .then(response => response.text())
            .then(data => {
                if (data.trim() === 'Y') {
                    alert("정상적으로 처리되었습니다.");
                    location.reload(); // 성공 시 화면을 새로고침해서 목록을 갱신합니다.
                } else {
                    alert("처리에 실패했습니다. 다시 시도해 주세요.");
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert("서버 통신 오류가 발생했습니다.");
            });
    }
}

function processDraft(draft_id, action) {
    // 1. 확인 메시지 (사용자 실수 방지)
    if(!confirm(action === 'approve' ? '정말 승인하시겠습니까?' : '정말 거절하시겠습니까?')) {
        return;
    }

    // 2. 페이지 이동 (GET 방식 사용)
    location.href = "draftProcessPro.jsp?draft_id=" + draft_id + "&action=" + action;
}
</script>
</body>
</html>