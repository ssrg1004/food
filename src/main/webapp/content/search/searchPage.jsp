<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% request.setCharacterEncoding("UTF-8"); %>

<%@ page import="java.util.ArrayList" %>
<%@ page import="web.miniProject.dao.SearchDAO" %>
<%@ page import="web.miniProject.dto.RestaurantSearchDTO" %>
<%@ page import="web.miniProject.dto.ReviewerSearchDTO" %>

<% 
	String keyword = (String) request.getParameter("keyword"); 
	if(keyword == null){
		keyword = "";
	}

	String type = request.getParameter("type");
	if(type == null){
	    type = "all";
	}
	
	SearchDAO sdao = new SearchDAO();
	ArrayList<RestaurantSearchDTO> restaurantList = new ArrayList<>();
	ArrayList<ReviewerSearchDTO> reviewerList = new ArrayList<>();
	
	// 한페이지에 보여줄 글 개수
	int limit_all = 5;
	int limit_restaurant = 15;
	int limit_reviewer = 15;
	
	if(type.equals("all")){
	    restaurantList = sdao.searchRestaurant(keyword, limit_all);
	    reviewerList = sdao.searchReviewer(keyword, limit_all);

	}else if(type.equals("restaurant")){
	    restaurantList = sdao.searchRestaurant(keyword, limit_restaurant);

	}else if(type.equals("reviewer")){
	    reviewerList = sdao.searchReviewer(keyword, limit_reviewer);

	}
	
	
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛침반</title>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/common.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/searchPage.css">

<%@ include file="../header.jsp" %>
</head>
<body class="searchPage">


<div class="searchTop">

	 <form action="<%=request.getContextPath() %>/content/search/searchPage.jsp" class="searchForm" id="searchForm" method="get">
	
		<input type="text" name="keyword" id="searchInput" required
			placeholder="검색어를 입력해 주세요 (예: 파스타, 홍대, 스시...)">
	    <button type="submit" id="searchBtn">🔍</button>
	
	</form>

</div>

<div class="searchWrap">

    <div class="searchTitle">
        <h2>'<%=keyword%>' 검색 결과</h2>
        <span>총 <%=sdao.searchRestaurantCount(keyword) + sdao.searchReviewerCount(keyword)%>건</span>
    </div>

<div class="searchTab">

    <a class="<%=type.equals("all") ? "active" : ""%>"
       href="searchPage.jsp?keyword=<%=keyword%>&type=all">
        전체
    </a>

    <a class="<%=type.equals("restaurant") ? "active" : ""%>"
       href="searchPage.jsp?keyword=<%=keyword%>&type=restaurant">
        맛집 <%=sdao.searchRestaurantCount(keyword)%>
    </a>

    <a class="<%=type.equals("reviewer") ? "active" : ""%>"
       href="searchPage.jsp?keyword=<%=keyword%>&type=reviewer">
        평가단글 <%=sdao.searchReviewerCount(keyword)%>
    </a>

</div>
	<%----------------------------- 전체 검색 -----------------------------%>
	<%if(type.equals("all")) { %>
	<%-- 맛집 영역 --%>
	<div class="resultSection">

        <div class="sectionHeader">
            <h3>🍽️ 맛집</h3>
        </div>
        <div class="restaurantList">
	        <% for(int i = 0; i < restaurantList.size(); i++){
	        	RestaurantSearchDTO dto = (RestaurantSearchDTO) restaurantList.get(i);
	        %>
	        <a href="<%=request.getContextPath()%>/content/restaurant/resContent.jsp?post_id=<%=dto.getPost_id()%>" class="restaurantCard">
				<img src="<%=request.getContextPath()%>/upload/admin/<%=dto.getThumbnail()%>">
				<div class="restaurantInfo">
				    <h4><%=dto.getTitle() %></h4>
				
					<div class="star">
					<%
						double star = dto.getAvg_star();
						int fullStar = (int)Math.round(star); // 반올림
	
						for(int j = 1; j <= 5; j++) { 
					%>
						<%= j <= fullStar ? "⭐" : "☆" %>
					<% 	
						} 
					%>
					<span><%= String.format("%.1f", star) %></span>
					</div>
				
					<div class="tagArea">
						<%= dto.getTags() == null ? "" : dto.getTags() %>
					</div>
				
					<div class="address">
					    <%=dto.getAddress1() %><%=dto.getAddress2() == null? "": " "+dto.getAddress2()%>
					</div>
				</div>
	        </a>
			<%} %>
        </div>

		<a class="categoryMoreBtn" href="<%=request.getContextPath()%>/content/restaurant/restaurantList.jsp?keyword=<%=keyword%>">	
	   	 	'<%=keyword %>' 맛집 전체보기 (<%=sdao.searchRestaurantCount(keyword) %>) <span>→</span>
		</a>
    </div>
	
	<!-- 평가단 영역 -->
    <div class="resultSection">

        <div class="sectionHeader">
            <h3>📝 맛집평가단</h3>
        </div>

        <div class="reviewList">
 			<% for(int i = 0; i < reviewerList.size(); i++){
	        	ReviewerSearchDTO dto = (ReviewerSearchDTO) reviewerList.get(i);
	        %>
	        <a href="<%=request.getContextPath()%>/content/reviewer/reviewerPostDetail.jsp?post_id=<%=dto.getPost_id()%>" class="reviewCard">
                <img src="<%=request.getContextPath()%>/upload/reviewer/<%=dto.getThumbnail()%>">
                <div class="reviewInfo">
                    <h4><%=dto.getTitle() %></h4>
	                <p>
                        <%= (dto.getSubtitle() == null || dto.getSubtitle().trim().isEmpty()) ? "-" : dto.getSubtitle() %>
                    </p>
                    <p>
                    	<%= (dto.getContent() == null || dto.getContent().trim().isEmpty()) ? "-" : dto.getContent() %>
                    </p>
					<div></div>
                    <div class="meta">
                        <%=dto.getNickname() %>
                    </div>
                </div>
            </a>
			<%} %>
        </div>
		<a class="categoryMoreBtn" href="<%=request.getContextPath()%>/content/reviewer/reviewerPostList.jsp?keyword=<%=keyword%>">
	    	'<%=keyword %>' 평가단글 전체보기 (<%=sdao.searchReviewerCount(keyword) %>) <span>→</span>
		</a>
    </div>
	

	<%----------------------------- 맛집만 검색 -----------------------------%>
	<%}else if(type.equals("restaurant")) { %>
	<div class="resultSection">

        <div class="sectionHeader">
            <h3>🍽️ 맛집</h3>
        </div>
        <div class="restaurantList">
	        <% for(int i = 0; i < restaurantList.size(); i++){
	        	RestaurantSearchDTO dto = (RestaurantSearchDTO) restaurantList.get(i);
	        %>
	        <a href="<%=request.getContextPath()%>/content/restaurant/resContent.jsp?post_id=<%=dto.getPost_id()%>" class="restaurantCard">
				<img src="<%=request.getContextPath()%>/upload/admin/<%=dto.getThumbnail()%>">
				<div class="restaurantInfo">
				    <h4><%=dto.getTitle() %></h4>
				
					<div class="star">
					<%
						double star = dto.getAvg_star();
						int fullStar = (int)Math.round(star); // 반올림
	
						for(int j = 1; j <= 5; j++) { 
					%>
						<%= j <= fullStar ? "⭐" : "☆" %>
					<% 	
						} 
					%>
					<span><%= String.format("%.1f", star) %></span>
					</div>
				
					<div class="tagArea">
						<%= dto.getTags() == null ? "" : dto.getTags() %>
					</div>
				
					<div class="address">
					    <%=dto.getAddress1() %><%=dto.getAddress2() == null? "": " "+dto.getAddress2()%>
					</div>
				</div>
	        </a>
			<%} %>
        </div>

		<a class="categoryMoreBtn" href="<%=request.getContextPath()%>/content/restaurant/restaurantList.jsp?keyword=<%=keyword%>">	
	   	 	'<%=keyword %>' 맛집 전체보기 (<%=sdao.searchRestaurantCount(keyword) %>) <span>→</span>
		</a>
    </div>
    
	
	<%----------------------------- 평가단만 검색 -----------------------------%>
	<%}else if(type.equals("reviewer")) { %>

    <!-- 평가단 영역 -->
   <div class="resultSection">

        <div class="sectionHeader">
            <h3>📝 맛집평가단</h3>
        </div>

        <div class="reviewList">
 			<% for(int i = 0; i < reviewerList.size(); i++){
	        	ReviewerSearchDTO dto = (ReviewerSearchDTO) reviewerList.get(i);
	        %>
	        <a href="<%=request.getContextPath()%>/content/reviewer/reviewerPostDetail.jsp?post_id=<%=dto.getPost_id()%>" class="reviewCard">
                <img src="<%=request.getContextPath()%>/upload/reviewer/<%=dto.getThumbnail()%>">
                <div class="reviewInfo">
                    <h4><%=dto.getTitle() %></h4>
	                <p>
                        <%= (dto.getSubtitle() == null || dto.getSubtitle().trim().isEmpty()) ? "-" : dto.getSubtitle() %>
                    </p>
                    <p>
                    	<%= (dto.getContent() == null || dto.getContent().trim().isEmpty()) ? "-" : dto.getContent() %>
                    </p>

                    <div class="meta">
                        <%=dto.getNickname() %>
                    </div>
                </div>
            </a>
			<%} %>
        </div>
		<a class="categoryMoreBtn" href="<%=request.getContextPath()%>/content/reviewer/reviewerPostList.jsp?keyword=<%=keyword%>">
	    	'<%=keyword %>' 평가단글 전체보기 (<%=sdao.searchReviewerCount(keyword) %>) <span>→</span>
		</a>
    </div>
<%	} %>
</body>
</html>