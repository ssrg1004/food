<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dao.RestaurantDAO" %>
<%@ page import="web.miniProject.dto.RestaurantDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<!--============ session 값 받아오기 위한 공통코드 ============-->
<%@ page import="web.miniProject.dto.MemberDTO" %>   
<!-- 변수 이름은 페이지마다 변경해야함. 
	sdtoRest , sdtoMain, sdtoHeader 등등 ...-->
<% MemberDTO sdtoRest = (MemberDTO) session.getAttribute("loginUser"); %>

<%
/*********** url 정보 저장, 데이터 불러오기용 변수 작업 ***********/

	// 💡 로그인 여부를 판별하여 id값 넘겨주기 (비로그인 시 0)
    int loginMemberId = 0;
    if(sdtoRest != null) {
        loginMemberId = sdtoRest.getMember_id(); // ※ 본인의 MemberDTO 내 회원번호 getter 메소드명으로 호출하세요.
    }

	// 필터링용 값 받아오기 
	String keyword = request.getParameter("keyword");
	String category = request.getParameter("category");
	String sort = request.getParameter("sort");
	
	// 화면 첫 진입 시 키워드 "" 로 초기화
	if(keyword == null){ keyword = ""; }
	// 화면 첫 진입 시 "전체"버튼으로 초기화
	if(category == null){ category = "all"; }
	// 화면 첫 진입 시 "최신순"으로 초기화
	if(sort == null){ sort = "latest"; }
	
	
	// 한 페이지에 보여줄 줄 수
	int pageLineSize = 3;
	
	// URL 에서 현재 페이지번호 꺼내기		-> ?pageNum=2
	String pageNum = request.getParameter("pageNum");
	
	// 처음 접속 시 pageNum 없으면 기본값 1
	if( pageNum == null || pageNum.equals("null")){
		pageNum = "1";
	}
	// 한 페이지에 보여줄 줄의 수 url에서 가져오기
	String pageLineSizeParam = request.getParameter("pageLineSize");
	if(pageLineSizeParam != null){
		pageLineSize = Integer.parseInt(pageLineSizeParam);
	}

	// 현재 페이지 번호 -> 계산에 사용
	int currentPage = Integer.parseInt(pageNum);
	
	// 현재 페이지의 시작/끝 행 번호 계산
	int startRow = (currentPage-1) * (pageLineSize*4) + 1;
	int endRow = currentPage * (pageLineSize*4) ;
	
	// 실제 글 데이터 가져오는 코드 작성칸 
	/**********************************************************************/
	RestaurantDAO dao = new RestaurantDAO();
	// DAO 에서 start ~ end 범위의 게시글 가져오기
	// 💡 여기서 가져오는 list2 맵 구조 안에 로그인 유저의 좋아요 여부(isLiked), 북마크 여부(isBookmarked)가 
	// Boolean 타입 혹은 생판 판별 코드로 들어있다고 가정하거나, 없을 시 기본 빈 하트로 세팅되도록 조건화합니다.
	ArrayList<HashMap<String, Object>> list2 = dao.getRestaurantList(startRow, endRow, category, sort, keyword, loginMemberId);
	
	// 날짜 시간 출력포맷 설정
	SimpleDateFormat adf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	// DAO 에서 글 개수 가져오기
	int count = dao.listCount(keyword);
	
	String ctxPath = request.getContextPath();
	
	/**********************************************************************/

	 // 테스트용 : 총 글 수 (위에 데이터 가져오는 코드 작성되면 삭제하기)
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛침반</title>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/common.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/restaurantList.css">

</head>

<body>
<!-- ================= HEADER ================= -->
<jsp:include page="../header.jsp"/>

<div class="restaurantContainer">

	<!-- 검색 -->
	<div class="searchArea">
		
		<!-- 필터버튼(구현하지않기. 주석처리함) -->
		<!--
		<button class="filterBtn" onclick="openFilter()">

			<img
			src="<%=request.getContextPath()%>/images/filter.png"
			alt="필터">

		</button>
 		-->
	
		 <form action="<%=request.getContextPath() %>/content/restaurant/restaurantList.jsp" class="searchForm" id="searchForm" method="get">
			<input type="hidden" name="sort" value="<%= sort %>">
			<input type="text" name="keyword" id="searchInput" required
				placeholder="지역, 상호명, 음식종류 검색" value="<%=keyword %>">
		    <button type="submit" id="searchBtn">🔍</button>
		
		</form>	

	</div>

	<!-- ================== 태그 ================== -->
<%--
	<div class="tagArea">
		<!-- tag 테이블에서 값 순서대로 가져와야함(맨 처음의 '전체'버튼 제외) -->
		<a href="#" class="tagBtn active">전체</a>
		<a href="#" class="tagBtn">한식</a>
		<a href="#" class="tagBtn">중식</a>
		<a href="#" class="tagBtn">일식</a>
		<a href="#" class="tagBtn">양식</a>
		<a href="#" class="tagBtn">카페</a>
		<a href="#" class="tagBtn">디저트</a>
		<a href="#" class="tagBtn">술집</a>

	</div>
 --%>
	<!-- ================== (관리자용) 맛집추가 ================== -->
	<!-- 세션값으로 관리자확인 후 버튼 보이도록 if문 처리하기 -->
	<% if(sdtoRest != null && sdtoRest.getRole().equals("admin")) { %>
	<div class="addRestaurantBtn">
		<a href="<%=request.getContextPath()%>/content/restaurant/resWriteForm.jsp">맛집 등록</a>
	</div>
	<script>console.log("equals admin:<%=sdtoRest.getRole().equals("admin")%>");</script>
	<% } %>
	
	
	<!-- ================== 맛집리스트 필터링 ================== -->
	<div class="sortArea">
	 	<button class="sortBtn <%= "latest".equals(sort) ? "active" : "" %>" data-sort="latest">최신순</button>
		<button class="sortBtn <%= "like".equals(sort) ? "active" : "" %>" data-sort="like">좋아요순</button>
		<button class="sortBtn <%= "bookmark".equals(sort) ? "active" : "" %>" data-sort="bookmark">즐겨찾기순</button>
		<button class="sortBtn <%= "view".equals(sort) ? "active" : "" %>" data-sort="view">조회순</button>
	</div>
	
	
	<!-- ================== 맛집 카드 ================== -->
<div class="restaurantArea">
    <%
    if(list2 != null && !list2.isEmpty()) {
        for(HashMap<String, Object> map : list2) {
            RestaurantDTO dto = (RestaurantDTO) map.get("post");
            web.miniProject.dto.RestaurantInfoDTO infoDto = (web.miniProject.dto.RestaurantInfoDTO) map.get("info");
            web.miniProject.dto.RestaurantImageDTO imgDto = (web.miniProject.dto.RestaurantImageDTO) map.get("image");
    		
            // 💡 DB 구조에 맞추어 이미 좋아요를 누른 글인지 유동적으로 가려냅니다. (없으면 초기엔 false 처리)
            boolean isLiked = map.get("isLiked") != null ? (boolean)map.get("isLiked") : false;
            boolean isBookmarked = map.get("isBookmarked") != null ? (boolean)map.get("isBookmarked") : false;
    %>
    <a href="resContent.jsp?post_id=<%= dto.getPost_id() %>" class="restaurantCard">
        <div class="cardImage">
        <% if(imgDto != null && imgDto.getFile_name() != null && !imgDto.getFile_name().trim().isEmpty()) {  %>
            <img src="<%=request.getContextPath()%>/upload/admin/<%= imgDto.getFile_name() %>" alt="맛집 이미지">
        <% } else { %>
            <img src="<%=request.getContextPath()%>/upload/admin/default.png" alt="이미지 없음">
        <% } %>
        </div>

        <div class="cardContent">
            <div class="titleRow">
                <div class="storeName"><%= dto.getTitle() %></div>
                
                <div class="rightStats">
                    <div class="iconRow">
                        <%-- 💡 사용자의 좋아요 유무에 따라 초기 이미지 세팅(heart-fill.png vs heart-empty.png) --%>
                        <button type="button" class="likeBtn" onclick="toggleLikeList(event, <%= dto.getPost_id() %>, this)">
                            <img src="<%=ctxPath%>/images/<%= isLiked ? "heart-fill.png" : "heart-empty.png" %>">
                        </button>
                        <span class="count likeCount"><%= dto.getLike_cnt() %></span>

                        <%-- 💡 사용자의 북마크 유무에 따라 초기 이미지 세팅(bookmark-fill.png vs bookmark-empty.png) --%>
                        <button type="button" class="bookmarkBtn" onclick="toggleBookmarkList(event, <%= dto.getPost_id() %>, this)"> 
                            <img src="<%=ctxPath%>/images/<%= isBookmarked ? "bookmark-fill.png" : "bookmark-empty.png" %>">
                        </button>
                        <span class="count bookmarkCount"><%= dto.getBookmark_cnt() %></span>
                    </div>
                    
                    <div class="subInfoRow">
                        <span class="viewCount">
                            <i class="fa-regular fa-eye viewIcon"></i> 
                            
                            <span class="count">조회수 : <%= dto.getView_cnt() %></span>
                        </span>
                    </div>
                </div>
            </div>

            <div class="tagRow">
                <% 
                ArrayList<String> cardTags = dao.getTagList(dto.getPost_id());
                if(cardTags != null && !cardTags.isEmpty()) { 
                    for(String tag : cardTags) { 
                %>
                        <span class="cardTag">#<%= tag %></span>
                <% 
                    } 
                } 
                %>
            </div>
        </div>
    </a>
    <% } 
    } else { %>
        <div style="text-align:center; width:100%; padding: 50px 0; color: #888;">등록된 맛집이 없습니다. 🍽️</div>
    <% } %>
</div>
	<!-- ================== 페이징 ================== -->
 	<div class="paging" style="text-align:center">
	<%
		// 게시글이 있을 때만 페이징 링크 생성
		if( count > 0 ){
			// 전체 페이지 수 계산
			int pageCount = count/(pageLineSize*4) + (count % (pageLineSize*4) == 0 ? 0 : 1);

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
	%>			<a href="restaurantList.jsp?pageNum=<%=startPage-pageBlock%>&pageLineSize=<%=pageLineSize%>&keyword=<%=keyword%>&sort=<%=sort%>&category=<%=category%>">이전</a>
	<%		}
			
			// 현재 페이지 번호 버튼 [1][2][3] ... [10]
			for(int i = startPage; i <= endPage; i++){
				
	%>			<a href="restaurantList.jsp?pageNum=<%=i%>&pageLineSize=<%=pageLineSize%>&keyword=<%=keyword%>&sort=<%=sort%>&category=<%=category%>"><%=i %></a>
				
	<%		}
			
			// [다음] 버튼		: 다음 블록이 있을때만 표시
			if( endPage < pageCount ){
	%>			<a href="restaurantList.jsp?pageNum=<%= startPage + pageBlock %>&pageLineSize=<%=pageLineSize%>&keyword=<%=keyword%>&sort=<%=sort%>&category=<%=category%>">다음</a>
	<%		}
		}
	
	%>	
	</div>
</div>

<script>
//컨텍스트 패스 자바스크립트 전역 변수화
const ctx = "<%= ctxPath %>";

/*
// 태그 복수선택 처리
const tagBtns = document.querySelectorAll(".tagBtn");

tagBtns.forEach(btn => {
	btn.addEventListener("click",
			
	function(e){
		e.preventDefault();
		const tagName = this.textContent.trim();

		if(tagName === "전체"){
			tagBtns.forEach(b => b.classList.remove("active"));
			this.classList.add("active");
			return;
		}

		const allBtn = document.querySelector(".tagBtn");
		allBtn.classList.remove("active");
		
		this.classList.toggle("active");
	});
});
*/

// 좋아요/북마크/댓글/조회수 순 처리
document.querySelectorAll('.sortArea .sortBtn').forEach(button => {
    button.addEventListener('click', function() {
        // 1. 클릭한 버튼의 정렬 기준 값 (latest, like, bookmark, view)
        const selectedSort = this.getAttribute('data-sort');
        
        // 2. JSP 스크립틀릿을 통해 현재 유지되고 있는 검색어 가져오기
        const currentKeyword = "<%= keyword %>"; 
        
        // 3. 현재 페이지 파일 경로 가져오기
        const pageUrl = window.location.pathname;
        
        // 4. 검색어와 정렬 조건을 모두 들고 페이지 이동 (새로고침 효과)
        location.href = pageUrl + "?keyword=" + encodeURIComponent(currentKeyword) + "&sort=" + selectedSort;
    });
});

// 좋아요버튼 누를 시 처리
// (북마크버튼도 처리할 코드 비슷하게 작성하기)
function toggleLikeList(event, post_id, btn){
    event.preventDefault();
    event.stopPropagation();

    // 상세페이지와 동일한 jsp 요청
    fetch("toggleLike.jsp?post_id=" + post_id)
    .then(res => res.text())
    .then(result => {
     	// 💡 [수정]: 기존 .iconArea 에서 실제 존재하는 부모 노드인 .iconRow 로 수정하여 탐색 오류를 해결합니다.
        const row = btn.closest(".iconRow");
        const countSpan = row.querySelector(".likeCount");
        const img = btn.querySelector("img");
        let count = parseInt(countSpan.innerText);

        // 상세페이지(content)의 분기 조건 문자열과 완벽히 일치시킴
        if(result.trim() === "liked"){
            countSpan.innerText = count + 1;
            img.src = ctx + "/images/heart-fill.png";
        } 
        else if(result.trim() === "unliked"){
            countSpan.innerText = Math.max(0, count - 1);
            img.src = ctx + "/images/heart-empty.png";
        }
    }).catch(err => console.error("목록 좋아요 에러:", err));
}

function toggleBookmarkList(event, post_id, btn){
    event.preventDefault();
    event.stopPropagation();

    // 상세페이지와 동일한 jsp 요청
    fetch("toggleBookmark.jsp?post_id=" + post_id)
    .then(res => res.text())
    .then(result => {
    	// 💡 [수정]: 동일하게 부모 노드를 .iconRow 로 추적합니다.
        const row = btn.closest(".iconRow");
        const countSpan = row.querySelector(".bookmarkCount");
        const img = btn.querySelector("img");
        let count = parseInt(countSpan.innerText);

        // 상세페이지(content)의 분기 조건 문자열과 완벽히 일치시킴
        if(result.trim() === "added"){
            countSpan.innerText = count + 1;
            img.src = ctx + "/images/bookmark-fill.png";
        } 
        else if(result.trim() === "removed"){
            countSpan.innerText = Math.max(0, count - 1);
            img.src = ctx + "/images/bookmark-empty.png";
        }
    }).catch(err => console.error("목록 북마크 에러:", err));
}


</script>


</body>
</html>