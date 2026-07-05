<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="web.miniProject.dao.RestaurantDAO" %>
<%@ page import="web.miniProject.dto.RestaurantImageDTO" %>
    
<%
	// 1. 주소창이나 폼에서 넘어온 글 번호(post_id) 받기
	String postIdParam = request.getParameter("post_id");
	
	if(postIdParam == null || postIdParam.trim().equals("")){
%>
	<script>
		alert("정상적인 접근이 아닙니다");
		history.back();
	</script>
<%	
	return;
	} 
	
	int post_id = Integer.parseInt(postIdParam);
	
	RestaurantDAO dao = new RestaurantDAO();
	
	// 2. DB를 지우기 전에 해당 글에 묶인 이미지 파일명 목록 먼저 확보
	List<RestaurantImageDTO> imageList = dao.getImageList(post_id);
	
	// 3. 톰캣 서버 내의 실제 이미지 저장 경로
	String savePath = request.getServletContext().getRealPath("/upload/admin");
	
	// 4. DAO 를 통해 DB 데이터 삭제
	int result = dao.deleteRestaurant(post_id);
	
	if(result > 0){
		// 5. DB 삭제 성공 시, 서버 폴더 안의 실제 이미지 파일도 삭제
		if(imageList != null && imageList.size() > 0){
			for(RestaurantImageDTO img : imageList){
				String file_name = img.getFile_name(); // DTO getter 메서드
				if(file_name != null && !file_name.equals("")){
					File file = new File(savePath + File.separator + file_name);
					if(file.exists()){
						file.delete();
					}
				}
			}
		}
	%>
	
	<script>
	alert("글이 정상적으로 삭제되었습니다");
	location.href="restaurantList.jsp";
	</script>
<% } else { %>
	<script>
		alert("삭제에 실패했습니다. 다시 시도해 주세요");
		history.back();
	</script>
<% } %>