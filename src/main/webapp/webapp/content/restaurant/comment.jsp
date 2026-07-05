<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!--------------------------------------------------------->
<!--------------------- 맛집 댓글 구현부분 --------------------->
<!--------------------------------------------------------->
<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="web.miniProject.dto.CommentDTO" %>

<% 	MemberDTO sdtoComment = (MemberDTO) session.getAttribute("loginUser");  %>

<jsp:useBean class="web.miniProject.dao.CommentDAO" id="dao"/>

<%
	// 한 페이지에 보여줄 댓글 수
	int commentPageSize = 10;

	//URL 에서 현재 페이지번호 꺼내기		-> ?pageNum=2
	String pageNum = request.getParameter("pageNum");
	
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
	List<CommentDTO> list = new ArrayList<CommentDTO>();
	int post_id = 1;		// ---------------------------** 맛집 post_id 받아오기
	
	int count = dao.comment_count(post_id);
	System.out.println("count : "+count);
	list = dao.getCommentList(post_id, startRow, endRow);

%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛침반</title>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/comment.css">

</head>
<body>

<div class="commentSection">

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
                <%if(sdtoComment.getId() != null){ %>
                    <!----- 타인 글 : 답글버튼 / 신고버튼 ----->
                       <!------ 답글 버튼 ------>
                       <!--  본인글은 버튼 미표기 -->
                    <%if(sdtoComment.getMember_id() != cdto.getMember_id()){ %>
                 	   <button class="replyBtn" onclick="toggleReplyForm(<%=cdto.getComment_id() %>)">
                 	   		답글
                 	   </button>
                 	   <!------ 신고버튼 ------>
                 	   <!-- 내 신고여부에 따라 버튼변경됨(한번만 신고가능) -->
					<%	boolean reported = dao.isReported(cdto.getComment_id(), sdtoComment.getMember_id()); %>
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
	                    		<button class="deleteBtn" onclick="deleteComment(<%=cdto.getComment_id()%>)">삭제</button>
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
		    		<input type="hidden" name="member_id" value="<%=sdtoComment.getMember_id() %>">
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
			List<CommentDTO> replyList = dao.getReplyList(cdto.getComment_id());
			
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
                	<%if(sdtoComment.getId() != null){ %>
	                   <!-- 타인 글일 때 - 신고버튼 -->
	                   <%if(sdtoComment.getMember_id() != r.getMember_id()){ %>
                 	   <!-- 신고버튼 -->
						<%	boolean reported = dao.isReported(r.getComment_id(), sdtoComment.getMember_id()); %>
						<%	if(reported){ %>
									<button class="reportBtn reportedBtn" disabled>신고완료</button>
						<%	}else { %>
									<button id="reportBtn<%=r.getComment_id()%>" class="reportBtn" onclick="openReport(<%=r.getComment_id()%>)">신고</button>
						<%	} %>
	                   <%}else { %>
	                   <%	if(r.getStatus().equals("N")){ %>
	                    <!-- 본인 글일 때 신고버튼은 X, 수정/삭제버튼 보임 -->
	                    <button class="editBtn" onclick="showEditForm(<%=r.getComment_id()%>)">수정 </button>
	                    <button class="deleteBtn" onclick="deleteComment(<%=r.getComment_id()%>)">삭제</button>
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
    <form action="<%=request.getContextPath()%>/content/restaurant/addCommentPro.jsp" method="post" class="commentWrite">

        <span class="writeSubTitle"><b>댓글쓰기</b></span>
      
		<!-- 별점 -->
		  <div class="ratingArea">
		
		      <label>
		          <input type="radio" name="star_score" value="5">
					<% 	// 별 표시
						for(int j = 0; j < 5; j++){ %>
							<img class="starImg" src="<%=request.getContextPath()%>/images/star.png">
					<%	}%>
		      </label>
		
		      <label>
		          <input type="radio" name="star_score" value="4">
		          	<% 	// 별 표시
						for(int j = 0; j < 4; j++){ %>
							<img class="starImg" src="<%=request.getContextPath()%>/images/star.png">
					<%	}%>
		      </label>
		
		      <label>
		          <input type="radio" name="star_score" value="3">
		          	<% 	// 별 표시
						for(int j = 0; j < 3; j++){ %>
							<img class="starImg" src="<%=request.getContextPath()%>/images/star.png">
					<%	}%>
		      </label>
		
		      <label>
		          <input type="radio" name="star_score" value="2">
		      		<% 	// 별 표시
						for(int j = 0; j < 2; j++){ %>
							<img class="starImg" src="<%=request.getContextPath()%>/images/star.png">
					<%	}%>
		      </label>
		
		      <label>
		          <input type="radio" name="star_score" value="1">
		          	<% 	// 별 표시
						for(int j = 0; j < 1; j++){ %>
							<img class="starImg" src="<%=request.getContextPath()%>/images/star.png">
					<%	}%>
		      </label>
		</div>
		
    	<div class="writeArea">
    	<%if(sdtoComment.getId() != null){ %>
    		<input type="hidden" name="post_id" value="<%=post_id %>">
	    	<input type="hidden" name="member_id" value="<%=sdtoComment.getMember_id() %>">
	        <textarea name="content" placeholder="이 맛집에 대한 따뜻한 리뷰를 남겨주세요!"></textarea>
	        <button type="submit" class="writeBtn">작성</button>
	    <%}else {%>
        	<div class="loginNotice">
				댓글 작성을 위해 <a href="<%=request.getContextPath()%>/content/member/loginForm.jsp">로그인</a>이 필요합니다.
			</div>
	    <%} %>
        </div>

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
%>			<a href="comment.jsp?page=like&pageNo=<%=startPage-pageBlock%>&commentPageSize=<%=commentPageSize%>">이전</a>
<%		}
		
		// 현재 페이지 번호 버튼 [1][2][3] ... [10]
		for(int i = startPage; i <= endPage; i++){
%>			<a href="comment.jsp?page=like&pageNo=<%=i%>&commentPageSize=<%=commentPageSize%>"><%=i %></a>
<%		}
		
		// [다음] 버튼		: 다음 블록이 있을때만 표시
		if( endPage < pageCount ){
%>			<a href="comment.jsp?page=like&pageNo=<%= startPage + pageBlock %>&commentPageSize=<%=commentPageSize%>">다음</a>
<%		}
	}
%>	
</div>

</body>

<script>

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
function deleteComment(comment_id){

    let result = confirm("댓글을 삭제하시겠습니까?");

    if(result){
        location.href = "<%=request.getContextPath()%>/content/restaurant/deleteCommentPro.jsp?comment_id=" + comment_id;
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

</html>