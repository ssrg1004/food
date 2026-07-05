<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="web.miniProject.dto.MemberDTO" %>    
<%@ page import="java.util.ArrayList" %>
<%@ page import="web.miniProject.dao.MyPostSearchDAO" %>
<%@ page import="web.miniProject.dto.MyPagePostDTO" %>

<%
	MemberDTO bookmarklist_sdto = (MemberDTO) session.getAttribute("loginUser");
	/*********** url 정보 저장, 데이터 불러오기용 변수 작업 ***********/
	
	// 한 페이지에 보여줄 줄 수
	int pageLineSize = 2;
	
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
	int startRow = (currentPage-1) * (pageLineSize*3) + 1;
	int endRow = currentPage * (pageLineSize*3) ;
	
	// 실제 글 데이터 가져오는 코드 작성칸 
	/**********************************************************************/
	
	MyPostSearchDAO dao = new MyPostSearchDAO();
	
	ArrayList<MyPagePostDTO> list = dao.myBookmarkPost(bookmarklist_sdto.getMember_id(), startRow, endRow);
	
	int count = dao.myBookmarkPostCount(bookmarklist_sdto.getMember_id()); //  총 북마크 글 수
	
	// 날짜 시간 출력포맷 설정
	//SimpleDateFormat adf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	/**********************************************************************/

%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛침반</title>

<!-- css 정보 불러오기 -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">

</head>
<body>
	<%	// 좋아요 글이 없을 시
		if(list.size() == 0){
	%>
			<div id="noPostMassage">
				북마크한 글이 없습니다.
			</div>
	<%	// 좋아요 글이 있을 시 글 목록 표시
		}else {%>
			<div class="postGrid">
			<%for(int i = 0; i < list.size(); i++){ 
				MyPagePostDTO dto = (MyPagePostDTO) list.get(i); 
				String url = "";
				if("RESTAURANT".equals(dto.getPost_type())){
				    url = "../restaurant/resContent.jsp?post_id=" + dto.getPost_id();
				}else{
				    url = "../reviewer/reviewerPostDetail.jsp?post_id=" + dto.getPost_id();
				}
				
				%>
			<a href="<%=url%>" class="postCardLink">
				<div class="postCard">
			        <div class="postImage">
			        	<% if("RESTAURANT".equals(dto.getPost_type())){ %>
			        		<img src="<%=request.getContextPath()%>/upload/admin/<%=dto.getThumbnail()%>">
			        	<% }else{ %>
			        		<img src="<%=request.getContextPath()%>/upload/reviewer/<%=dto.getThumbnail()%>">
			        	<% } %>
			        </div>
			        <div class="postContent">
			            <div class="postTitle">
			                <%=dto.getTitle() %>
			            </div>
			            <div class="postBottom">
			                <div class="postWriter">
			                    <%=dto.getWriter() %>
			                </div>
			                <div class="postStat">
			                    ♥ <%=dto.getLike_cnt() %> &nbsp; ★ <%=dto.getBookmark_cnt() %> &nbsp; 💬 <%=dto.getComment_cnt() %>
			                </div>
			            </div>
			        </div>
			    </div>
		    </a>
			<%} %>	
			</div>
<%		}%>
	<!-- 페이징 -->
 	<div class="paging" style="text-align:center">
	<%
		// 게시글이 있을 때만 페이징 링크 생성
		if( count > 0 ){
			// 전체 페이지 수 계산
			int pageCount = count/(pageLineSize*3) + (count % (pageLineSize*3) == 0 ? 0 : 1);
			
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
	%>			<a href="myPage.jsp?page=bookmark&pageNo=<%=startPage-pageBlock%>&pageLineSize=<%=pageLineSize%>">이전</a>
	<%		}
			
			// 현재 페이지 번호 버튼 [1][2][3] ... [10]
			for(int i = startPage; i <= endPage; i++){
	%>			<a href="myPage.jsp?page=bookmark&pageNo=<%=i%>&pageLineSize=<%=pageLineSize%>"><%=i %></a>
	<%		}
			
			// [다음] 버튼		: 다음 블록이 있을때만 표시
			if( endPage < pageCount ){
	%>			<a href="myPage.jsp?page=bookmark&pageNo=<%= startPage + pageBlock %>&pageLineSize=<%=pageLineSize%>">다음</a>
	<%		}
		}
	%>	
	</div>
	
</body>
</html>