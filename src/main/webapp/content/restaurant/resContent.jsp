<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="/content/admin/adminCheck.jsp" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%@ page import="web.miniProject.dao.RestaurantDAO" %>
<%@ page import="web.miniProject.dto.RestaurantDTO" %>
<%@ page import="web.miniProject.dto.RestaurantInfoDTO" %>
<%@ page import="web.miniProject.dto.RestaurantImageDTO" %>
<%@ page import="web.miniProject.dao.RestaurantPostLikeDAO" %>
<%@ page import="web.miniProject.dao.RestaurantBookmarkDAO" %>
<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="web.miniProject.dto.CommentDTO" %>
<%@ page import="web.miniProject.dao.CommentDAO" %>

<%-- 댓글 유저구분을 위한 세션정보 불러오기 --%>
<% MemberDTO sdtoComment = (MemberDTO) session.getAttribute("loginUser"); %>

<%
	int post_id = Integer.parseInt(request.getParameter("post_id"));
	RestaurantDAO dao = new RestaurantDAO();
	
	// 📍 [조회수 무한 증가 방지 쿠키 로직]
		boolean isViewed = false;
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie c : cookies) {
				// 이미 해당 게시글을 읽은 쿠키가 존재하는지 확인
				if (c.getName().equals("view_post_" + post_id)) {
					isViewed = true;
					break;
				}
			}
		}
		
		// 쿠키가 없다면 최초 열람이므로 조회수를 올리고 쿠키를 구움
		if (!isViewed) {
			dao.updateViewCnt(post_id); // 📍 DAO의 조회수 증가 메서드 호출!
			Cookie viewCookie = new Cookie("view_post_" + post_id, "true");
			viewCookie.setMaxAge(60 * 60 * 24); // 쿠키 유지 시간: 24시간(하루)
			viewCookie.setPath(request.getContextPath());
			response.addCookie(viewCookie);
		}

		// 📍 조회수가 반영된 데이터를 가져옵니다.
		RestaurantDTO dto = dao.getRestaurant(post_id);
	
	if(dto == null){
	    out.println("<script>");
	    out.println("alert('존재하지 않는 게시글입니다.');");
	    out.println("location.href='restaurantList.jsp';");
	    out.println("</script>");
   	 	return;
	}
	
	RestaurantInfoDTO infoDto = dao.getRestaurantInfo(dto.getRestaurant_id());
	ArrayList<RestaurantImageDTO> imageList = dao.getImageList(post_id);
	ArrayList<String> tagList = dao.getTagList(post_id);
	
	int member_id = 0;
	boolean isLiked = false;
	boolean isBookmarked = false;
	
	// 기존 DAO 카운트 함수 대신, DB가 실시간 업데이트되는 DTO의 값을 사용!
	int likeCount = dto.getLike_cnt();
	int bookmarkCount = dto.getBookmark_cnt();
	
	RestaurantPostLikeDAO likeDAO = new RestaurantPostLikeDAO();
	RestaurantBookmarkDAO bookmarkDAO = new RestaurantBookmarkDAO();
	
	if(loginUser != null){
		member_id = loginUser.getMember_id();
		isLiked = likeDAO.isLiked(post_id, member_id);
		isBookmarked = bookmarkDAO.isBookmarked(post_id, member_id);
	}
	
	
	// 댓글 페이징 계산
	
	List<CommentDTO> list = new ArrayList<CommentDTO>();
	CommentDAO cdao = new CommentDAO();
	
	// 한 페이지에 보여줄 댓글 수
	int commentPageSize = 5;

	//URL 에서 현재 페이지번호 꺼내기		-> ?pageNum=2
	String pageNum = request.getParameter("pageNum");
	
	// (내 댓글 검색) URL 에서 comment_id 로 내 댓글이 있는 페이지번호 찾아 부여하기
	String comment_id = request.getParameter("comment_id");
	if(comment_id != null){
		int commentOrder = cdao.myCommentOrder(post_id, Integer.parseInt(comment_id)); 
		pageNum = Integer.toString((commentOrder - 1) / commentPageSize + 1);
	}
	
	// 처음 접속 시 pageNum 없으면 기본값 1
	if( pageNum == null || pageNum.equals("null")){
		pageNum = "1";
	}
	// 한 페이지에 보여줄 줄의 수 url에서 가져오기
	String commentPageSizeParam = request.getParameter("commentPageSize");
	if(commentPageSizeParam != null){
		commentPageSize = Integer.parseInt(commentPageSizeParam);
	}
	// 현재 페이지 번호 -> 계산에 사용
	int currentPage = Integer.parseInt(pageNum);
	
	// 현재 페이지의 시작/끝 행 번호 계산
	int startRow = (currentPage-1) * commentPageSize + 1;
	int endRow = currentPage * commentPageSize ;

	/* 실제 댓글 데이터 가져오기 */
	int count = cdao.comment_count(post_id);
	list = cdao.getCommentList(post_id, startRow, endRow);
	
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%=dto.getTitle()%></title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/common.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
<link rel="stylesheet" href="../../css/resContent.css">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>

<!-- ================= HEADER ================= -->
<%@ include file="../header.jsp" %>

<div class="contentWrap">
	<h1 class="title"><%=dto.getTitle()%></h1>

	<div class="postInfo">
		<span>작성일 : <%=dto.getReg_date()%></span>
		<span>조회수 : <%=dto.getView_cnt()%></span>
	</div>

	<div class="topArea">
		    <%
		    // 💡 1. 서브 이미지('N')가 몇 개인지 미리 카운트합니다.
		    int subImgTotalCount = 0;
		    for(RestaurantImageDTO img : imageList) {
		        if("N".equals(img.getIs_thumbnail())) {
		            subImgTotalCount++;
		        }
		    }
		    %>
		<div class="card imageArea <%= (subImgTotalCount == 0) ? "only-thumb-area" : "" %>">
		
		    <div class="thumbnailBox">
		    <%
		    for(RestaurantImageDTO img : imageList){
		        if("Y".equals(img.getIs_thumbnail())){
		    %>
		        <img src="../../upload/admin/<%=img.getFile_name()%>" class="thumbnailImg">
		    <%
		        }
		    }
		    %>
		    </div>
		
		    <% if(subImgTotalCount > 0) { %>
		    <div class="smallImages">
		        <%
		        int subImgCount = 0;
		        for(RestaurantImageDTO img : imageList){
		            if("N".equals(img.getIs_thumbnail())){
		                subImgCount++;
		                if(subImgCount == 2) {
		        %>
		        <%--
		                    <div class="subImgContainer moreEffect">
		                        <img src="../../upload/admin/<%=img.getFile_name()%>" alt="상세이미지">
		                        <div class="moreOverlay">+ 더보기</div>
		                    </div>
		        --%>
		        <%
		                } else {
		        %>
		                    <div class="subImgContainer">
		                        <img src="../../upload/admin/<%=img.getFile_name()%>" alt="상세이미지">
		                    </div>
		        <%
		                }
		            }
		        }
		        %>
		    </div>
		    <% } %>
		</div>
		
		<div class="card shopInfo">
			<div class="shopHeader">
				<h2 class="shopName"><%=infoDto.getName()%></h2>
				<div class="shopActions">
					<button type="button" class="actionBtn likeBtn <%= isLiked ? "filled" : "" %>" onclick="toggleLike()">
					    <i class="<%= isLiked ? "fa-solid" : "fa-regular" %> fa-heart"></i>
					    <span class="count"><%= likeCount %></span>
					</button>
					<button type="button" class="actionBtn favBtn <%= isBookmarked ? "filled" : "" %>" onclick="toggleBookmark()">
					    <i class="<%= isBookmarked ? "fa-solid" : "fa-regular" %> fa-star"></i>
					    <span class="count"><%= bookmarkCount %></span>
					</button>
				</div>
			</div>

			<div class="shopBody">
				<h3 class="subTitle">📍 가게 정보</h3>
				<table class="infoTable">
					<tr>
						<th>우편번호</th>
						<td><%=infoDto.getZipcode()%></td>
					</tr>
					<tr>
						<th>주소</th>
						<td><%=infoDto.getAddress1()%> <%=infoDto.getAddress2()%></td>
					</tr>
					<tr>
						<th>전화번호</th>
						<td><%=infoDto.getPhone()%></td>
					</tr>
					<tr>
						<th>영업시간</th>
						<td><%=infoDto.getTime()%></td>
					</tr>
					<tr>
						<th>대표메뉴</th>
						<td><%=infoDto.getMenu()%></td>
					</tr>
					<tr>
						<th>태그</th>
						<td>
							<div class="tagListContainer">
							<% 
							if(tagList != null && !tagList.isEmpty()) { 
								for(String tag : tagList) { 
							%>
									<span class="shopTag">#<%= tag %></span>
							<% 
								} 
							} else { 
							%>
									<span style="color:#aaa; font-size:0.85rem;">등록된 태그가 없습니다.</span>
							<% 
							} 
							%>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div> 
	</div> 
	
	<div class="card contentArea">
		<h3>📝 상세 설명 및 평가</h3>
		<div class="contentText">
			<%=dto.getContent() != null ? dto.getContent().replace("\n","<br>") : ""%>
		</div>
	</div>

	<!-- ==================================================================   댓글부분(수정 후)   ================================================================== -->
<div class="commentSection" id="commentSection">

    <h3>댓글 <%=count %>개</h3>

    <!-- 댓글 목록 -->
    <div class="commentList">
	
	<!-- 댓글 목록(댓글 없을 시) -->
	<%if(count == 0){ %>
		<div class="commentItem">
			<div class="commentHeader">
				<div class="commentInfo"></div>
			</div>
			<div class="commentContent_none">
                작성된 댓글이 없습니다.
            </div>
		</div>
		
	<!-- 댓글 목록(댓글 하나라도 있을 시) -->
	<%}else {%>
		<!-- 반복으로 댓글 꺼내기 -->
		<% 	for(int i = 0; i < list.size(); i++){ 
				CommentDTO cdto = (CommentDTO) list.get(i);
		%>
        <!-- 부모 댓글 -->
        <div class="commentItem">
            <div class="commentHeader">
            	<div class="commentInfo">
            		<!-- 작성자 닉네임 표시 -->
                	<span class="nickname"><%=cdto.getNickname() %></span>
                	<!-- 댓글 별 별점표시 -->
		            <span class="rating">
					<% 	// 별 표시
						for(int j = 0; j < cdto.getStar_score(); j++){ %>
							<img class="starImg" src="<%=request.getContextPath()%>/images/star.png">
					<%	}%>
					</span>      
                </div>
                
                <!-- 작성일 표시 -->
                <span class="commentDate"><%=cdto.getReg_date() %></span>
 
 
                <!-- [버튼] -- 댓글우측  -->
                <span class="commentBtn">
                <%if(sdtoComment != null){ %>
                    <!----- 타인 글 : 답글버튼 / 신고버튼 ----->
                       <!------ 답글 버튼 ------>
                       <!--  본인글은 버튼 미표기 -->
                    <%if(sdtoComment.getMember_id() != cdto.getMember_id()){ %>
                 	   <button class="replyBtn" onclick="toggleReplyForm(<%=cdto.getComment_id() %>)">답글</button>
 
                 	   <!------ 신고버튼 ------>
                 	   <!-- 내 신고여부에 따라 버튼변경됨(한번만 신고가능) -->
					<%	boolean reported = cdao.isReported(cdto.getComment_id(), sdtoComment.getMember_id()); %>
					<%		if(reported){ %>
								<button class="reportBtn reportedBtn" disabled>신고완료</button>
					<%		}else { %>
								<button id="reportBtn<%=cdto.getComment_id()%>" class="reportBtn" onclick="openReport(<%=cdto.getComment_id()%>)">신고</button>
					<%		} %>                 	   
					
					<!----- 본인 글 : 수정버튼 / 삭제버튼 ----->
                    <%}else { %>
                    	<%	// 신고된 글일 경우 수정/삭제 버튼 미표기
                    		if(cdto.getStatus().equals("N")){ %>
	                    		<button class="editBtn" onclick="showEditForm(<%=cdto.getComment_id()%>)">수정</button>	
	                    		<button class="deleteBtn" onclick="deleteComment(<%=cdto.getComment_id()%>, <%=post_id%>)">삭제</button>
	                    <%	} %>		
                    <%} %>
                <%} %>
                </span>
            </div>
            
			<!---- 댓글 내용 ---->
			<%// 신고 승인됨
			if(cdto.getStatus().equals("Y")){ %>
				<div class="commentContent reportContent">신고 처리된 댓글입니다.</div>
			<%}else { %>
				<div id="contentView<%=cdto.getComment_id()%>" class="commentContent">
				   <%=cdto.getContent()%>
				</div>
			<%} %>
			<!---- 답글 및 수정 입력폼 작업 ---->
		   	<!-- 답글 입력폼 -->
			<form action="<%=request.getContextPath()%>/content/restaurant/addCommentPro.jsp" method="post"
				id="replyForm<%=cdto.getComment_id() %>" class="replyForm" style="display:none;">
					<input type="hidden" name="post_id" value="<%=post_id %>">
					<input type="hidden" name="member_id" value="<%=sdtoComment != null? sdtoComment.getMember_id(): "" %>">
					<input type="hidden" name="parent_id" value="<%=cdto.getComment_id()%>">
				    <textarea name="content" placeholder="답글을 입력해주세요."></textarea>	
				    <button type="submit">답글작성</button>
			</form>
			<!-- 수정 입력폼 -->
			<div id="editForm<%=cdto.getComment_id()%>" class="editForm" style="display:none;">	
				<form action="<%=request.getContextPath()%>/content/restaurant/updateCommentPro.jsp" method="post">
					<input type="hidden" name="post_id" value="<%=post_id %>">
				    <input type="hidden" name="comment_id" value="<%=cdto.getComment_id()%>">
				    <input type="hidden" name="member_id" value="<%=cdto.getMember_id()%>">
					<textarea name="content"><%=cdto.getContent()%></textarea>
				        <button type="submit">
				            수정하기
				        </button>
			    </form>
			</div>			


		<!-- 부모댓글 종료 div -->
        </div>
        
        <!-- 자식댓글(대댓글) 반복출력 구간 -->
        <%
			List<CommentDTO> replyList = cdao.getReplyList(cdto.getComment_id());
			
			for(CommentDTO r : replyList){ 
%>
			<!-- 대댓글 -->
			<div class="replyItem">
			
			    <div class="commentHeader">
			        <span class="replyMark">└</span>
			        <span class="nickname"><%=r.getNickname()%></span>
			        <span class="commentDate"><%=r.getReg_date()%></span>
			        
			        <!-- 신고수정삭제버튼 -->
					<span class="commentBtn">
                	<%if(sdtoComment != null){ %>
	                   <!-- 타인 글일 때 - 신고버튼 -->
	                   <%if(sdtoComment.getMember_id() != r.getMember_id()){ %>
                 	   <!-- 신고버튼 -->
						<%	boolean reported = cdao.isReported(r.getComment_id(), sdtoComment.getMember_id()); %>
						<%	if(reported){ %>
									<button class="reportBtn reportedBtn" disabled>신고완료</button>
						<%	}else { %>
									<button id="reportBtn<%=r.getComment_id()%>" class="reportBtn" onclick="openReport(<%=r.getComment_id()%>)">신고</button>
						<%	} %>
	                   <%}else { %>
	                   <%	if(r.getStatus().equals("N")){ %>
	                    <!-- 본인 글일 때 신고버튼은 X, 수정/삭제버튼 보임 -->
	                    <button class="editBtn" onclick="showEditForm(<%=r.getComment_id()%>)">수정 </button>
	                    <button class="deleteBtn" onclick="deleteComment(<%=r.getComment_id()%>, <%=post_id%>)">삭제</button>
	                   	  <%} %>
	                   <%} %>
                    <%} %>    
	               	</span>
			    </div>
				
				<!-- 대댓글 내용 -->
				<%// 신고 승인됨
				if(r.getStatus().equals("Y")){ %>
					<div class="commentContent reportContent">신고 처리된 댓글입니다.</div>
				<%}else { %>
					<div id="contentView<%=r.getComment_id()%>" class="commentContent">
					   <%=r.getContent()%>
					</div>
				<%} %>
				
				<!-- 수정 입력폼(대댓글) -->
				<div id="editForm<%=r.getComment_id()%>" class="editForm" style="display:none;">	
					<form action="<%=request.getContextPath()%>/content/restaurant/updateCommentPro.jsp" method="post">
						<input type="hidden" name="post_id" value="<%=post_id %>">
					    <input type="hidden" name="comment_id" value="<%=r.getComment_id()%>">
					    <input type="hidden" name="member_id" value="<%=r.getMember_id()%>">
						<textarea name="content"><%=r.getContent()%></textarea>
					        <button type="submit">
					            수정하기
					        </button>
				    </form>
				</div>

			</div>
		
		<!--  자식댓글 반복 for문 작업 종료 '}' -->
		<%	} %>
		
		<!-- 부모댓글 반복 for문 작업 종료 '}' -->
		<%	} %>

    <!-- 댓글목록 하나라도 있을 시 else 문 종료 '}' -->
	<%} %>


    <!-- 댓글 작성 -->
 <form action="<%=request.getContextPath()%>/content/restaurant/addCommentPro.jsp" method="post" 
      class="commentWrite <%= (sdtoComment == null) ? "not-logged-in" : "" %>">

    <span class="writeSubTitle"><b>댓글쓰기</b></span>
  
    <% if(sdtoComment != null) { %>
        <div class="ratingArea">
            <label>
                <input type="radio" name="star_score" value="5">
                <% for(int j = 0; j < 5; j++){ %><img class="starImg" src="<%=request.getContextPath()%>/images/star.png"><% } %>
            </label>
            <label>
                <input type="radio" name="star_score" value="4">
                <% for(int j = 0; j < 4; j++){ %><img class="starImg" src="<%=request.getContextPath()%>/images/star.png"><% } %>
            </label>
            <label>
                <input type="radio" name="star_score" value="3">
                <% for(int j = 0; j < 3; j++){ %><img class="starImg" src="<%=request.getContextPath()%>/images/star.png"><% } %>
            </label>
            <label>
                <input type="radio" name="star_score" value="2">
                <% for(int j = 0; j < 2; j++){ %><img class="starImg" src="<%=request.getContextPath()%>/images/star.png"><% } %>
            </label>
            <label>
                <input type="radio" name="star_score" value="1">
                <% for(int j = 0; j < 1; j++){ %><img class="starImg" src="<%=request.getContextPath()%>/images/star.png"><% } %>
            </label>
        </div>
        
        <div class="writeArea">
            <input type="hidden" name="post_id" value="<%=post_id %>">
            <input type="hidden" name="member_id" value="<%=sdtoComment.getMember_id() %>">
            <textarea name="content" placeholder="이 맛집에 대한 따뜻한 리뷰를 남겨주세요!"></textarea>
            <button type="submit" class="writeBtn">작성</button>
        </div>
    <% } else { %>
        <div class="writeArea">
            <div class="loginNagMessage">
                댓글 작성을 위해 <a href="<%=request.getContextPath()%>/content/member/loginForm.jsp" style="font-weight:bold; color:#e8a052; text-decoration:underline; margin:0 5px;">로그인</a>이 필요합니다.
            </div>
        </div>
    <% } %>

</form>

</div>

<!-- 페이징 -->
<div class="paging" style="text-align:center">
<%
	// 댓글이 있을 때만 페이징 링크 생성
	if( count > 0 ){
		// 전체 페이지 수 계산
		int pageCount = count/commentPageSize + (count % commentPageSize == 0 ? 0 : 1);
		
		// 한번에 보여줄 페이지 수 [1] [2] [3] ... [10] 10개 보여줌
		int pageBlock = 10;
		
		// 현재 블록의 시작페이지 번호
		int startPage = (int)( (currentPage-1)/pageBlock ) * pageBlock + 1;
		
		// 현재 블록의 끝 페이지 번호
		int endPage = startPage + pageBlock - 1;
		
		// 끝 페이지가 전체 페이지 수보다 큰 경우 -> 전체 페이지 수로 조정 
		if( endPage > pageCount ){
			endPage = pageCount;	// 남아있는 페이지만 표시
		}
		
		// [이전] / [페이지번호] / [다음]
		
		// [이전] 버튼		: 현재 페이지 블록이 두 번째 이상일 때만 표시
		if( startPage > pageBlock ){
%>			<a href="resContent.jsp?page=like&post_id=<%=post_id %>&pageNum=<%=startPage-pageBlock%>&commentPageSize=<%=commentPageSize%>#commentSection">이전</a>
<%		}
		
		// 현재 페이지 번호 버튼 [1][2][3] ... [10]
		for(int i = startPage; i <= endPage; i++){
%>			<a href="resContent.jsp?page=like&post_id=<%=post_id %>&pageNum=<%=i%>&commentPageSize=<%=commentPageSize%>#commentSection"><%=i %></a>
<%		}
		
		// [다음] 버튼		: 다음 블록이 있을때만 표시
		if( endPage < pageCount ){
%>			<a href="resContent.jsp?page=like&post_id=<%=post_id %>&pageNum=<%= startPage + pageBlock %>&commentPageSize=<%=commentPageSize%>#commentSection">다음</a>
<%		}
	}
%>	
</div>
	
	<!-- ==================================================================   댓글부분(수정 후) 종료  ================================================================== -->

	<div class="btnArea">
		<input type="button" value="목록" onclick="location.href='restaurantList.jsp'">
		<% if("admin".equals(role)) { %>
			<input type="button" value="수정" onclick="location.href='resUpdateForm.jsp?post_id=<%=post_id%>'">
			<input type="button" value="삭제" onclick="deletePost()">
		<% } %>
	</div>
</div>

<script>
function deletePost(){
	if(confirm("정말 삭제하시겠습니까?")){
		location.href = "resDeletePro.jsp?post_id=<%=post_id%>";
	}
}

function toggleLike(){
    fetch("toggleLike.jsp?post_id=<%=post_id%>")
    .then(response => response.text())
    .then(result => {
        if(result.trim() === "login"){ alert("로그인이 필요합니다."); return; }

        const btn = document.querySelector(".likeBtn");
        const icon = btn.querySelector("i");
        const countSpan = btn.querySelector(".count");
        let count = parseInt(countSpan.innerText);

        if(result.trim() === "liked"){
            btn.classList.add("filled");
            icon.classList.remove("fa-regular"); icon.classList.add("fa-solid");
            countSpan.innerText = count + 1;
        }else if(result.trim() === "unliked"){
            btn.classList.remove("filled");
            icon.classList.remove("fa-solid"); icon.classList.add("fa-regular");
            countSpan.innerText = Math.max(0, count - 1);
        }
    });
}

function toggleBookmark(){
    fetch("toggleBookmark.jsp?post_id=<%=post_id%>")
    .then(response => response.text())
    .then(result => {
        if(result.trim() === "login"){ alert("로그인이 필요합니다."); return; }

        const btn = document.querySelector(".favBtn");
        const icon = btn.querySelector("i");
        const countSpan = btn.querySelector(".count");
        let count = parseInt(countSpan.innerText);

        if(result.trim() === "added"){
            icon.classList.remove("fa-regular"); icon.classList.add("fa-solid");
            btn.classList.add("filled");
            countSpan.innerText = count + 1;
        } else if(result.trim() === "removed"){
            icon.classList.remove("fa-solid"); icon.classList.add("fa-regular");
            btn.classList.remove("filled");
            countSpan.innerText = Math.max(0, count - 1);
        }
    });
}

function validateComment() {
    const content = document.getElementById("commentContent").value;
    if(content.trim() === "") {
        alert("댓글 내용을 입력해 주세요.");
        document.getElementById("commentContent").focus();
        return false;
    }
    return true;
}

// ------------- 댓글용 스크립트 --------------//

// 답글 칸 on/off
function toggleReplyForm(comment_id){

    let replyForm = document.getElementById("replyForm" + comment_id);

    if(replyForm.style.display == "none"){
        replyForm.style.display = "flex";
    }else{
        replyForm.style.display = "none";
    }
}

// 댓글 수정 칸 on/off
function showEditForm(comment_id){
    
	let content = document.getElementById("contentView" + comment_id);
    let form = document.getElementById("editForm" + comment_id);
    
    if(!content || !form){
        return;
    }

    if(form.style.display == "none"){
        content.style.display = "none";
        form.style.display = "block";
    }else{
        content.style.display = "block";
        form.style.display = "none";
    }
}

// 댓글 삭제
function deleteComment(comment_id, post_id){

    let result = confirm("댓글을 삭제하시겠습니까?");

    if(result){
        location.href = "<%=request.getContextPath()%>/content/restaurant/deleteCommentPro.jsp?comment_id=" + comment_id + "&post_id=" + post_id;
    }
}

// 댓글/답글 신고
function openReport(comment_id){
    window.open(
        "<%=request.getContextPath()%>/content/restaurant/commentReportPopup.jsp?comment_id=" + comment_id,
        "reportPopup",
        "width=500,height=450,left=500,top=200"
    );
}

</script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    // 💡 화면 로드가 완료되면 실행
    syncImageHeight();

    // 혹시 모르니 이미지나 폰트가 완전히 다 로딩된 후에도 한 번 더 정밀 계산
    $(window).on('load', function() {
        syncImageHeight();
    });

    // 브라우저 창 크기가 조절될 때도 높이를 계속 동기화
    $(window).on('resize', function() {
        syncImageHeight();
    });
});

function syncImageHeight() {
    // 1. 우측 가게정보 카드의 순수한 실제 높이(px)를 측정합니다.
    var shopInfoHeight = $('.shopInfo').outerHeight();
    
    // 2. 측정된 높이를 좌측 이미지 카드(.imageArea)의 높이로 똑같이 지정합니다.
    if(shopInfoHeight > 0) {
        $('.imageArea').css('height', shopInfoHeight + 'px');
    }
}
</script>
</body>
</html>