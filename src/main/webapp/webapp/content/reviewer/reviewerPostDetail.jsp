<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="web.miniProject.dto.*" %>
<%@ page import="web.miniProject.dao.*" %>
<%
    MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");
    String ctx = request.getContextPath();
    int post_id = Integer.parseInt(request.getParameter("post_id"));

    ReviewerPostDAO dao = ReviewerPostDAO.getInstance();
    dao.increaseViewCnt(post_id);

    ReviewerPostDTO dto = dao.getDetail(post_id, loginUser);
    ReviewerPostDTO prevPost = dao.getPrevPost(post_id);
    ReviewerPostDTO nextPost = dao.getNextPost(post_id);
    ArrayList<String> tags = dao.getTags(post_id);

    // ==========================================================================
    // 💡 [변경] 복잡한 자바 리스트 결합 & 정렬 제거 ➡️ DB 통합 쿼리 메서드 딱 한 줄로 호출
    // ==========================================================================
    ArrayList<Map<String, Object>> totalBlocks = dao.getIntegratedContents(post_id);

    if(dto == null){
%>
<script>alert("존재하지 않는 게시글입니다."); location.href="reviewerPostList.jsp";</script>
<% return; }

    boolean liked = false;
    boolean bookmarked = false;
    if(loginUser != null){
        liked = dao.isLiked(post_id, loginUser.getMember_id());
        bookmarked = dao.isBookmarked(post_id, loginUser.getMember_id());
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%=dto.getTitle()%></title>
<link rel="stylesheet" href="<%=ctx%>/css/header.css">
<link rel="stylesheet" href="<%=ctx%>/css/reviewer.css"> 
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
/* 상세페이지 레이아웃 서식 */
.tagArea { margin: 20px 0; display: flex; gap: 8px; }
.tag { background: #f5f5f5; padding: 5px 12px; border-radius: 15px; font-size: 13px; color: #ff7a00; font-weight: 600; }
.addressArea { font-size: 14px; color: #666; background: #fafafa; padding: 12px; border-radius: 8px; margin-bottom: 20px; }
.actionArea { display: flex; justify-content: center; gap: 15px; margin: 30px 0; }
.actionArea button { background: white; border: 1px solid #ddd; padding: 10px 20px; border-radius: 20px; cursor: pointer; font-weight: 600; display: inline-flex; align-items: center; gap: 5px; }
.actionArea button img { width: 18px; }

/* 💡 오더 순서 흐름 배치를 위한 스타일 시트 */
.contentArea { display: flex; flex-direction: column; gap: 25px; margin: 30px 0; }
.detailTextBlock { width: 100%; box-sizing: border-box; }
.detailTextBlock h3 { font-size: 19px; color: #222; margin: 0 0 10px 0; font-weight: 700; }
.detailTextBlock p { font-size: 15px; line-height: 1.8; color: #444; margin: 0; white-space: pre-wrap; }

.detailImageBlock { width: 100%; margin: 5px 0; }
.detailImageBlock img { width: 100%; max-height: 550px; border-radius: 12px; object-fit: cover; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
</style>
</head>
<body>
<%@ include file="/content/header.jsp" %>

<div class="detailContainer">

    <h2><%=dto.getTitle()%></h2>

    <div class="infoTop">
        <span>👤 <%=dto.getNickname()%></span>
        <span>📅 <%=dto.getReg_date()%></span>
    </div>

    <div class="statusBar">
        <div>👀 조회수 <span><%=dto.getView_cnt()%></span></div>
        <div>❤️ 좋아요 <span><%=dto.getLike_cnt()%></span></div>
        <div>🔖 북마크 <span><%=dto.getBookmark_cnt()%></span></div>
    </div>

    <div class="contentArea">
        <% 
        if(totalBlocks != null && !totalBlocks.isEmpty()){
            for(Map<String, Object> block : totalBlocks) {
                String type = (String)block.get("type");
                
                // 1. 해당 순서가 이미지 블록일 때
                if("IMAGE".equals(type)) {
                    String fileName = (String)block.get("data1");
        %>
                    <div class="detailImageBlock">
                        <img src="<%=ctx%>/upload/reviewer/<%=fileName%>" alt="리뷰이미지">
                    </div>
        <%
                // 2. 해당 순서가 텍스트 블록일 때
                } else if("TEXT".equals(type)) {
                    String subtitle = (String)block.get("data1");
                    String content = (String)block.get("data2");
        %>
                    <div class="detailTextBlock">
                        <% if(subtitle != null && !subtitle.trim().isEmpty()){ %>
                            <h3><%=subtitle%></h3>
                        <% } %>
                        <p><%=content%></p>
                    </div>
        <%
                }
            }
        } else { 
        %>
            <p>콘텐츠 내용이 없습니다.</p>
        <% } %>
    </div>

    <div class="addressArea">
        📍 <strong>위치:</strong> 
        <%= dto.getAddress1() == null ? "" : dto.getAddress1() %>
        <%= dto.getAddress2() == null ? "" : dto.getAddress2() %>
    </div>

    <div class="tagArea">
        <% if(tags != null){ for(String t : tags){ %>
            <span class="tag">#<%=t%></span>
        <% } } %>
    </div>

    <div class="actionArea">
        <button onclick="likeToggle(<%=post_id%>)">
            <img src="<%=ctx%>/images/<%=liked ? "heart-fill.png" : "heart-empty.png"%>"> 좋아요
        </button>
        <button onclick="bookmarkToggle(<%=post_id%>)">
            <img src="<%=ctx%>/images/<%=bookmarked ? "heart-fill.png" : "heart-empty.png"%>"> 북마크
        </button>
        <% if(loginUser != null && loginUser.getMember_id() == dto.getMember_id()){ %>
            <button onclick="location.href='reviewerPostUpdate.jsp?post_id=<%=post_id%>'">수정</button>
            <button onclick="deletePost(<%=post_id%>)" style="color:#e74c3c;">삭제</button>
        <% } %>
    </div>

    <hr style="border:0; border-top:1px solid #eee; margin:30px 0;">

    <div class="btnArea" style="justify-content: space-between;">
        <div class="prevNextGroup" style="display:flex; gap:10px;">
            <% if(prevPost != null){ %>
                <button onclick="location.href='reviewerPostDetail.jsp?post_id=<%=prevPost.getPost_id()%>'">← 이전 글</button>
            <% } %>
            <% if(nextPost != null){ %>
                <button onclick="location.href='reviewerPostDetail.jsp?post_id=<%=nextPost.getPost_id()%>'">다음 글 →</button>
            <% } %>
        </div>
        <a href="reviewerPostList.jsp">목록으로</a>
    </div>
</div>

<script>
function likeToggle(post_id){ $.ajax({ url:"reviewerLikeToggle.jsp", type:"post", data:{post_id:post_id}, success:function(){ location.reload(); } }); }
function bookmarkToggle(post_id){ $.ajax({ url:"reviewerBookmarkToggle.jsp", type:"post", data:{post_id:post_id}, success:function(){ location.reload(); } }); }
function deletePost(post_id){ if(confirm("삭제하시겠습니까?")){ location.href = "reviewerPostDeleteForm.jsp?post_id=" + post_id; } }
</script>
</body>
</html>