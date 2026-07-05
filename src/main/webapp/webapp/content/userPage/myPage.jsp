<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="web.miniProject.dao.CommentDAO" %>
<%@ page import="web.miniProject.dao.MyPostSearchDAO" %>
<%@ page import="web.miniProject.dto.MyPagePostDTO" %>

<%
	MemberDTO sdto = (MemberDTO) session.getAttribute("loginUser");
	CommentDAO myPage_dao = new CommentDAO();
	MyPostSearchDAO myCNT_dao = new MyPostSearchDAO();
	

	// 우측 내용부분 처리
	// page 받아오는 것 없으면 정보수정으로 표시
	// 좌측 카테고리 누르는 것에 따라 pageType 변경 -> 우측내용 변경됨 
	String pageType = request.getParameter("page");
	
	if(pageType == null){
	    pageType = "profile";
	}
	
	int likePost_count = myCNT_dao.myLikePostCount(sdto.getMember_id()); //  좋아요 총 글 수
	int bookmarkPost_count = myCNT_dao.myBookmarkPostCount(sdto.getMember_id()); //  북마크 총 글 수
	int myComment_count = myCNT_dao.myCommentCount(sdto.getMember_id()); // 내가 쓴 댓글 수
	int myReviewerPost_count = myCNT_dao.myReviewerPostCount(sdto.getMember_id()); // 내가 쓴 글 수(평가단)
	request.setAttribute("loginUser", sdto);
	request.setAttribute("dao", myPage_dao);


%>   
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛침반</title>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
</head>
<body>

<!-- ================= HEADER ================= -->
<%@ include file="../header.jsp" %>


<div class="mypageWrap">

    <h1>마이페이지</h1>

    <div class="mypageBody">
    
        <!-- 좌측 메뉴 -->
        <div class="mypageMenu">
			<a href="myPage.jsp?page=profile">내 프로필</a>
			
			<a href="myPage.jsp?page=like">
				좋아요 (<%=likePost_count %>)
			</a>
			
			<a href="myPage.jsp?page=bookmark">
				즐겨찾기 (<%=bookmarkPost_count %>)
			</a>
			
			<a href="myPage.jsp?page=post">
				내가 쓴 글 (<%=myReviewerPost_count %>)
			</a>
			<a href="myPage.jsp?page=myComment">
				내가 쓴 댓글 (<%=myComment_count %>)
			</a>
		</div>
		
        <!-- 우측 컨텐츠 -->
        <div class="mypageContent">
            <%
            if(pageType.equals("profile")){
            %>
                <%@ include file="myProfile.jsp" %>
            <%
            }
            else if(pageType.equals("like")){
            %>
                <%@ include file="likeList.jsp" %>
            <%
            }
            else if(pageType.equals("bookmark")){
            %>
                <%@ include file="bookmarkList.jsp" %>
            <%
            }
            else if(pageType.equals("post")){
            %>
                <%@ include file="myPostList.jsp" %>
            <%
            }else if(pageType.equals("myComment")){
            %>
                <%@ include file="myComment.jsp" %>
            <%
            }else if(pageType.equals("withdraw")){
            %>
                <%@ include file="/content/member/withdrawCheck.jsp" %>
            <%
            } 
            %>
    	</div>
	</div>
</div>

</body>
</html>