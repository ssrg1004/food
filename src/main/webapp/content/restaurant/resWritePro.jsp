<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>

<%@ page import="web.miniProject.dao.RestaurantDAO"%>

<%@ page import="web.miniProject.dto.RestaurantDTO"%>
<%@ page import="web.miniProject.dto.RestaurantInfoDTO"%>
<%@ page import="web.miniProject.dto.RestaurantImageDTO"%>
<% request.setAttribute("forceBlock", "Y"); %>
<%@ include file="/content/admin/adminCheck.jsp" %>
<%
String uploadPath =
	//application.getRealPath("/upload/admin");
	"D:/dev/java/javaSpace/miniProject/src/main/webapp/upload/admin";
	// 테스트용 경로(집)
	//"C:/Users/picac/eclipse-workspace/miniProject/src/main/webapp/upload/admin";
int maxSize =
	1024 * 1024 * 20;

MultipartRequest mr =
	new MultipartRequest(
		request,
		uploadPath,
		maxSize,
		"UTF-8",
		new DefaultFileRenamePolicy()
	);

RestaurantDAO dao =
	new RestaurantDAO();


// ======================
// 가게 정보 저장
// ======================

RestaurantInfoDTO infoDto =
	new RestaurantInfoDTO();

infoDto.setName(
	mr.getParameter("storeName"));

infoDto.setZipcode(
	mr.getParameter("zipcode"));

infoDto.setAddress1(
	mr.getParameter("address1"));

infoDto.setAddress2(
	mr.getParameter("address2"));

infoDto.setPhone(
	mr.getParameter("phone"));

infoDto.setTime(
	mr.getParameter("time"));

infoDto.setMenu(
	mr.getParameter("menu"));

//06/22 수정
//📍 [여기서부터 수정!] 프론트(hidden 태그)에서 넘어온 위도, 경도 값 받기
String latParam = mr.getParameter("latitude");
String lngParam = mr.getParameter("longitude");

//값이 잘 넘어왔다면 double(소수점) 타입으로 변환하고, 없으면 기본값 0.0 세팅
double latitude = (latParam != null && !latParam.isEmpty()) ? Double.parseDouble(latParam) : 0.0;
double longitude = (lngParam != null && !lngParam.isEmpty()) ? Double.parseDouble(lngParam) : 0.0;

infoDto.setLatitude(latitude);   // ⭕ 기존 0 대신 파싱한 변수 넣기
infoDto.setLongitude(longitude); // ⭕ 기존 0 대신 파싱한 변수 넣기

int restaurantId =
	dao.insertRestaurantInfo(infoDto);


// ======================
// 게시글 저장
// ======================

RestaurantDTO dto =
	new RestaurantDTO();

dto.setMember_id(1);

dto.setRestaurant_id(
	restaurantId);

dto.setTitle(
	mr.getParameter("title"));

dto.setContent(
	mr.getParameter("content"));

int postId =
	dao.insertRestaurant(dto);

//======================
//태그 저장
//======================

String selectedTags =
	mr.getParameter("selectedTags");

if(selectedTags != null &&
!selectedTags.trim().equals("")) {

	String[] tags =
		selectedTags.split(",");

	for(String tag : tags) {
		
		tag = tag.trim();

		int tagId =
			dao.getTagId(tag);

		if(tagId > 0) {

			dao.insertPostTag(
				postId,
				tagId
			);
		}
	}
}

//💡 [추가] 글 정보와 모든 태그 저장이 끝난 후 SEARCH_TEXT 최종 업데이트!
dao.updateSearchText(postId);

// ======================
// 썸네일 저장
// ======================

String thumbnail =
	mr.getFilesystemName("thumbnail");

if(thumbnail != null){

	RestaurantImageDTO imageDto =
		new RestaurantImageDTO();

	imageDto.setPost_id(postId);
	imageDto.setFile_name(thumbnail);
	imageDto.setIs_thumbnail("Y");
	imageDto.setImage_order(0);

	dao.insertImage(imageDto);
}


// ======================
// 추가 이미지 저장
// ======================

String detailImage = mr.getFilesystemName("detailImage");

if(detailImage != null){

	RestaurantImageDTO imageDto =
		new RestaurantImageDTO();

	imageDto.setPost_id(postId);
	imageDto.setFile_name(detailImage);
	imageDto.setIs_thumbnail("N");
	imageDto.setImage_order(1);

	dao.insertImage(imageDto);
}

//2. 두 번째 추가 이미지 처리 (새로 추가할 코드)
String detailImage2 = mr.getFilesystemName("detailImage2"); // 괄호 안의 name 확인!

if(detailImage2 != null){
 RestaurantImageDTO imageDto = new RestaurantImageDTO();
 
 imageDto.setPost_id(postId);
 imageDto.setFile_name(detailImage2);
 imageDto.setIs_thumbnail("N");
 imageDto.setImage_order(2); // 두 번째 순서

 dao.insertImage(imageDto);
}
%>

<%
if(postId > 0){ %>
<script>
alert("등록 완료");
location.href = "<%= request.getContextPath() %>/content/restaurant/restaurantList.jsp";
</script>
<% }else{ %>
<script>
alert("등록 실패");
history.back();
</script>
<% } %>