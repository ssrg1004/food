<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="web.miniProject.dto.CommentDTO" %>
<%@ page import="web.miniProject.dao.MyPostSearchDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
    
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/myComment.css">
	
<%
	MemberDTO comment_sdto = (MemberDTO) session.getAttribute("loginUser"); 

	/****** 페이징 ******/
	
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
	
	// 실제 글 데이터 가져오는 코드 작성칸 
	/**********************************************************************/
	MyPostSearchDAO dao = new MyPostSearchDAO();
	List<CommentDTO> list = dao.myCommentList(comment_sdto.getMember_id(), startRow, endRow);
	
	int count = dao.myCommentCount(comment_sdto.getMember_id());
	
	// 날짜 시간 출력포맷 설정
	//SimpleDateFormat adf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	/**********************************************************************/

%>


<div class="mypageContent">

    <h2 class="commentTitle">
        내 댓글 관리
    </h2>

    <table class="commentTable">

        <thead>
            <tr>
                <th>번호</th>
                <th>리뷰명</th>
                <th>내용</th>
                <th>작성일</th>
                <!-- <th>관리</th> -->
            </tr>
        </thead>   
         
<%		
		if(list.size() == 0){
%>			
	    <tbody>
	        <tr>
	            <td colspan="4" class="noComment">
	                작성한 댓글이 없습니다.
	            </td>
	        </tr>
	    </tbody>
<%		}else {
			for(int i = 0; i < list.size(); i++){
				CommentDTO dto = (CommentDTO) list.get(i); 
%>
			<tbody>
		            <tr>
		                <td><%=dto.getComment_id() %></td>
		
		                <td>
		                    <a href="../restaurant/resContent.jsp?post_id=<%=dto.getPost_id()%>&comment_id=<%=dto.getComment_id()%>#commentSection">
		                        <%=dto.getPost_title() %>
		                    </a>
		                </td>
		
		                <td>
		                    <a href="../restaurant/resContent.jsp?post_id=<%=dto.getPost_id()%>&comment_id=<%=dto.getComment_id()%>#commentSection">
		                        <%=dto.getContent() %>
		                    </a>
		                </td>
		
		                <td>
		                    <%=dto.getReg_date() %>
		                </td>
	<!-- 				// 수정 및 삭제는 맛집링크에서 직접 하도록 처리
		                <td>
			
		                    <button class="commentEditBtn">
		                        수정
		                    </button>
		
		                    <button class="commentDeleteBtn">
		                        삭제
		                    </button>
		                </td>
	 -->	
		            </tr>
		        </tbody>
<%
			}
		}
%>
    </table>
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
%>			<a href="myPage.jsp?page=myComment&pageNo=<%=startPage-pageBlock%>&commentPageSize=<%=commentPageSize%>">이전</a>
<%		}
		
		// 현재 페이지 번호 버튼 [1][2][3] ... [10]
		for(int i = startPage; i <= endPage; i++){
%>			<a href="myPage.jsp?page=myComment&pageNo=<%=i%>&commentPageSize=<%=commentPageSize%>"><%=i %></a>
<%		}
		
		// [다음] 버튼		: 다음 블록이 있을때만 표시
		if( endPage < pageCount ){
%>			<a href="myPage.jsp?page=myComment&pageNo=<%= startPage + pageBlock %>&commentPageSize=<%=commentPageSize%>">다음</a>
<%		}
	}
%>	
</div>