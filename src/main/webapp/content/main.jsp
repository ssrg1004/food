<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="web.miniProject.dao.RestaurantDAO" %>
<%@ page import="web.miniProject.dao.ReviewerPostDAO" %>
<%@ page import="web.miniProject.dto.RestaurantDTO" %>
<%@ page import="web.miniProject.dto.ReviewerPostDTO" %>

<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>

<% 
	MemberDTO sdtoMain = (MemberDTO) session.getAttribute("loginUser"); 

	//DAO 호출
	RestaurantDAO rDao = new RestaurantDAO();
	ReviewerPostDAO rvDao = ReviewerPostDAO.getInstance();
	
	List<Map<String, Object>> rTop3 = rDao.selectTop3ByView();
	List<ReviewerPostDTO> rvTop3 = rvDao.selectTop3ByView();

	// 세션 없음
	if(sdtoMain == null){	// 비로그인 상태
		
		// 자동 로그인 쿠키 값을 저장할 변수 선언
		String cid = null, cpw = null, cauto = null;
	
		// 브라우저에서 넘어온 쿠키 꺼냄
		Cookie[] cookies = request.getCookies();
		
		// 쿠키 존재
		if(cookies != null){
			// 쿠키 하나씩 꺼내서 확인
			for(Cookie c : cookies){
				if(c.getName().equals("cid")){ cid = c.getValue(); }
				if(c.getName().equals("cpw")){ cpw = c.getValue(); }
				if(c.getName().equals("cauto")){ cauto = c.getValue(); }
			}
		}
		// 쿠키가 하나라도 있으면	→ 자동로그인 시도
		if(cid != null || cpw != null || cauto != null){
			response.sendRedirect("loginPro.jsp");
		}
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

<!-- ================= HEADER ================= -->
<%@ include file="header.jsp" %>

<!-- ================= HERO ================= -->

<section class="hero">

    <div class="overlay">

        <div class="heroText">
            <h1>
                오늘 뭐 먹지?<br>
                맛있는 선택, <span>맛침반</span>
            </h1>

            <p>
                다양한 맛집 정보와 평가로<br>
                당신의 미식 여정을 함께합니다.
            </p>

        </div>

        <div class="searchBox">

            <form action="<%=request.getContextPath() %>/content/search/searchPage.jsp" id="searchForm" method="get">

                <input type="text" name="keyword" id="searchInput" required
                    placeholder="검색어를 입력해 주세요 (예: 파스타, 홍대, 스시...)">
                <button type="submit" id="searchBtn">🔍</button>

            </form>

        </div>

    </div>

</section>

<!-- ================= 맛집공유 인기글 ================= -->

<div class="content">
	<div class="sectionHeader">
	    <div class="sectionTitle">
	        맛집공유 인기글 🔥
	    </div>
	    <a href="<%=request.getContextPath()%>/content/restaurant/restaurantList.jsp" class="moreBtn">
	    더보기 <span> ></span>
	    </a>
	</div>
    <div class="cardContainer">
    
       <%
       if(rTop3 != null && !rTop3.isEmpty()){
           	// DTO 대신 Map 구조로 데이터를 순회하며 꺼냅니다.
          	 for(Map<String, Object> map : rTop3){
	               String rThumb = (String) map.get("thumbnail");
	               if(rThumb == null || rThumb.trim().equals("")){
	                   rThumb = "default.jpg";
	               }
        %>

	        <%-- 💡 상세 페이지 이동 링크 연동 (위치를 정확히 /content/restaurant/ 하위로 설정) --%>
	        <a href="<%=request.getContextPath()%>/content/restaurant/resContent.jsp?post_id=<%=map.get("post_id")%>" class="cardLink">
	            <div class="card">
	                <div class="imgBox">
	                    <%-- 💡 DB에서 꺼내온 진짜 맛집 파일명을 출력합니다. --%>
	                    <img src="<%=request.getContextPath()%>/upload/admin/<%=rThumb%>">
	                    <span class="location">맛집</span>
	                </div>
	
	                <div class="cardBody">
	                    <h3><%=map.get("title")%></h3>
	
	                    <div class="cardFooter">
	                        <%-- 💡 하드코딩되었던 작성자를 진짜 닉네임으로 변경 --%>
	                        <div class="writer"><%=map.get("nickname")%></div>
	                        <div class="info">
	                            👀 <%=map.get("view_cnt")%>
	                            ♡ <%=map.get("like_cnt")%>
	                            🔖 <%=map.get("bookmark_cnt")%>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </a>

        <%
			}
		}else {
        %>
        	<p>게시글이 없습니다.</p>
<% 		} %> 
    </div>
</div>

<!-- ================= 맛집평가단 인기글 ================= -->

<div class="content">
	<div class="sectionHeader">
	    <div class="sectionTitle">
	        맛집평가단 인기글 🔥
	    </div>
	    <a href="<%=request.getContextPath()%>/content/reviewer/reviewerPostList.jsp" class="moreBtn">
	    더보기 <span>></span>
	    </a>
	</div>
    <div class="cardContainer">
 
		<%
		if(rvTop3 != null && !rvTop3.isEmpty()){
			for(ReviewerPostDTO dto : rvTop3){
		        String thumb = dto.getThumbnail();

		        if(thumb == null || thumb.trim().equals("")){
		            thumb = "default.jpg";
		        }
		%>
		
			<%--카드 전체를 <a> 태그로 감싸서 클릭 시 상세페이지로 post_id를 들고 이동 --%>
			<a href="<%=request.getContextPath()%>/content/reviewer/reviewerPostDetail.jsp?post_id=<%=dto.getPost_id()%>" class="cardLink">
			    <div class="card">
			        <div class="imgBox">
			            <img src="<%=request.getContextPath()%>/upload/reviewer/<%=thumb%>">
			            <span class="pickBadge">평가단 PICK</span>
			        </div>
			
			        <div class="cardBody">
			            <h3><%=dto.getTitle()%></h3>
			
			            <div class="cardFooter">
			                <div class="writer"><%=dto.getNickname()%></div>
			                <div class="info">
			                    👀 <%=dto.getView_cnt()%>
			                    ♡ <%=dto.getLike_cnt()%>
			                    🔖 <%=dto.getBookmark_cnt()%>
			                </div>
			            </div>
			        </div>
			    </div>
			</a>
		
		<%
			}
		}else {
		%>
			<p>게시글이 없습니다.</p>
<%		}%>          
    </div>
</div>


<script>


</script>


</body>

</html>