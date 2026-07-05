<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="web.miniProject.dto.*" %>
<%@ page import="web.miniProject.dao.*" %>
<%
	MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
	String ctx = request.getContextPath();
	String sort = request.getParameter("sort");
	if(sort == null) sort = "latest";
	String keyword = request.getParameter("keyword");
	if(keyword == null) keyword = "";
	
	int currentPage = 1;
	try { currentPage = Integer.parseInt(request.getParameter("page")); } catch(Exception e) { currentPage = 1; }
	int limit = 12;
	int startRow = (currentPage - 1) * limit + 1;
	int endRow = currentPage * limit;
	
	ReviewerPostDAO dao = ReviewerPostDAO.getInstance();
	ArrayList<ReviewerPostDTO> postList = dao.getList(startRow, endRow, sort, loginUser, keyword);
	int totalCount = dao.getCount(keyword);
	int totalPage = (int)Math.ceil((double)totalCount / limit);
	if(totalPage == 0) totalPage = 1;
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛집 평가단 게시판</title>
<link rel="stylesheet" href="<%=ctx%>/css/common.css">
<link rel="stylesheet" href="<%=ctx%>/css/header.css">
<link rel="stylesheet" href="<%=ctx%>/css/reviewer.css"> <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
/* ⚠️ 레이아웃 충돌 스타일 제거 완료 (grid 레이아웃 정상 작동 유도) */
.listContainer { width: 850px; margin: 0 auto; } /* 컨테이너 너비 통일 */
.listHeaderArea { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
.writeBtn { background: #ff7a00; color: #fff; text-decoration: none; padding: 10px 18px; border-radius: 8px; font-weight: bold; }
.sortSelect { width: 150px; height: 40px; border: 1px solid #ddd; border-radius: 8px; }

/* 카드를 마우스 호버했을 때 효과만 간단히 추가 */
.restaurantCard { 
    border: 1px solid #eee; 
    border-radius: 12px; 
    overflow: hidden; 
    background: #fff; 
    transition: 0.2s; 
    list-style: none;
    box-shadow: 0 4px 10px rgba(0,0,0,0.02);
}
.restaurantCard:hover { box-shadow: 0 6px 15px rgba(0,0,0,0.1); transform: translateY(-2px); }
.cardImgWrapper { width: 100%; height: 180px; overflow: hidden; cursor: pointer; }
.cardImgWrapper img { width: 100%; height: 100%; object-fit: cover; }
.cardContent { padding: 15px; display: flex; flex-direction: column; justify-content: space-between; height: calc(100% - 180px); box-sizing: border-box; width: 100%; }
.cardTextLeft { width: 100%; overflow: hidden; }
.cardTextLeft h3 { font-size: 16px; color: #222; margin: 0 0 8px 0; cursor: pointer; }
.cardTextLeft h3, .infoRow { width:100%; white-space:nowrap; overflow: hidden; text-overflow: ellipsis; }
.cardActionRight { display: flex; justify-content: flex-end; gap: 10px; margin-top: 10px; padding-top: 10px; border-top: 1px solid #f9f9f9; }
.listActionBtn { border: none; background: none; cursor: pointer; }
.actionIcon { width: 22px; }
.searchArea { margin: 30px 0 60px; text-align: center; }
.searchArea input { width: 300px; height: 40px; padding: 0 10px; border: 1px solid #ddd; border-radius: 4px; }
.searchArea button { height: 42px; width: 90px; background: #ff7a00; color: white; border: none; border-radius: 4px; cursor: pointer; }
</style>
</head>
<body>
<%@ include file="/content/header.jsp" %>
<div class="listContainer">
    <h2 style="font-size:26px; font-weight:700; color:#222; margin: 30px 0 20px 0;">🍽 맛집 평가단 게시판</h2>
    <div class="listHeaderArea">
        <div>
        <% if(loginUser != null && "Y".equalsIgnoreCase(loginUser.getReviewer_yn())){ %>
            <a href="reviewerPostWrite.jsp" class="writeBtn">✍ 글쓰기</a>
        <% } %>
        </div>
        <div>
            <select class="sortSelect" onchange="changeSort(this.value)">
                <option value="latest" <%=sort.equals("latest")?"selected":""%>>최신순</option>
                <option value="like" <%=sort.equals("like")?"selected":""%>>좋아요순</option>
                <option value="view" <%=sort.equals("view")?"selected":""%>>조회수순</option>
                <option value="bookmark" <%=sort.equals("bookmark")?"selected":""%>>즐겨찾기순</option>
            </select>
        </div>
    </div>

    <ul class="restaurantArea">
    <% if(postList.isEmpty()){ %>
        <li style="grid-column: span 3; text-align:center; padding:50px; color:#888;">등록된 게시글이 없습니다.</li>
    <% }else{
        for(ReviewerPostDTO post : postList){
            ArrayList<ReviewerImageDTO> imageList = dao.getImages(post.getPost_id());
            String thumb = post.getThumbnail(); 
            if (thumb == null || thumb.trim().isEmpty()) {
                if (imageList != null && !imageList.isEmpty()) {
                    for (ReviewerImageDTO img : imageList) {
                        if ("Y".equals(img.getIs_thumbnail())) { thumb = img.getFile_name(); break; }
                    }
                    if (thumb == null) thumb = imageList.get(0).getFile_name();
                }
            }
            String imgSrc = (thumb == null || thumb.trim().isEmpty()) ? ctx + "/images/no-image.png" : ctx + "/upload/reviewer/" + thumb;
    %>
        <li class="restaurantCard">
            <div class="cardImgWrapper" onclick="location.href='reviewerPostDetail.jsp?post_id=<%=post.getPost_id()%>'">
                <img src="<%=imgSrc%>" onerror="this.src='<%=ctx%>/images/no-image.png'">
            </div>
            <div class="cardContent">
                <div class="cardTextLeft" onclick="location.href='reviewerPostDetail.jsp?post_id=<%=post.getPost_id()%>'">
                    <h3><%=post.getTitle()%></h3>
                    <p class="writerRow">👤 <%=post.getNickname()%></p>
                    <p class="infoRow">📍 <%=post.getAddress1() == null ? "" : post.getAddress1()%></p>
                    <p class="statusRow" style="font-size:12px; color:#888; margin-top:5px;">👀 <%=post.getView_cnt()%>  ❤️ <%=post.getLike_cnt()%>  🔖 <%=post.getBookmark_cnt()%></p>
                    <p class="dateRow"><%=post.getReg_date()%></p>
                </div>
                <div class="cardActionRight">
                    <button class="listActionBtn" onclick="likeToggle(<%=post.getPost_id()%>)">
                        <img class="actionIcon" src="<%=ctx%>/images/<%=post.isLiked() ? "heart-fill.png" : "heart-empty.png"%>">
                    </button>
                    <button class="listActionBtn" onclick="bookmarkToggle(<%=post.getPost_id()%>)">
                        <img class="actionIcon" src="<%=ctx%>/images/<%=post.isBookmarked() ? "bookmark-fill.png" : "bookmark-empty.png"%>">
                    </button>
                </div>
            </div>
        </li>
    <% } } %>
    </ul>

    <div class="paging">
    <% if(currentPage > 1){ %>
        <a href="reviewerPostList.jsp?page=<%=currentPage-1%>&sort=<%=sort%>&keyword=<%=keyword%>">◀</a>
    <% } %>
    <% for(int i=1;i<=totalPage;i++){ %>
        <% if(i == currentPage){ %>
            <span class="current"><%=i%></span>
        <% }else{ %>
            <a href="reviewerPostList.jsp?page=<%=i%>&sort=<%=sort%>&keyword=<%=keyword%>"><%=i%></a>
        <% } %>
    <% } %>
    <% if(currentPage < totalPage){ %>
        <a href="reviewerPostList.jsp?page=<%=currentPage+1%>&sort=<%=sort%>&keyword=<%=keyword%>">▶</a>
    <% } %>
    </div>

    <div class="searchArea">
        <form action="reviewerPostList.jsp" method="get">
            <input type="hidden" name="sort" value="<%=sort%>">
            <input type="text" name="keyword" value="<%=keyword%>" placeholder="제목 또는 지역 검색">
            <button type="submit">검색</button>
        </form>
    </div>
</div>
<script>
function changeSort(sort){ location.href = "reviewerPostList.jsp?sort=" + sort + "&keyword=<%=keyword%>"; }
function likeToggle(postId){ event.stopPropagation(); $.post("reviewerLikeToggle.jsp", {post_id:postId}, function(){ location.reload(); }); }
function bookmarkToggle(postId){ event.stopPropagation(); $.post("reviewerBookmarkToggle.jsp", {post_id:postId}, function(){ location.reload(); }); }
</script>
</body>
</html>