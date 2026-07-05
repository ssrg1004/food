<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>

<%@ page import="web.miniProject.dao.RestaurantDAO" %>
<%@ page import="web.miniProject.dto.RestaurantDTO" %>
<%@ page import="web.miniProject.dto.RestaurantImageDTO" %>
<%@ page import="web.miniProject.dto.RestaurantInfoDTO" %>

<%
	// resContent.jsp 에서 넘겨준 post_id를 받음
	String postIdParam = request.getParameter("post_id");
	if(postIdParam == null || postIdParam.trim().equals("")){
%>
	<script>
		alert("잘못된 접근입니다");
		history.back();
	</script>
<% 
		return;
	} 
	int post_id = Integer.parseInt(postIdParam);
	
	RestaurantDAO dao = new RestaurantDAO();
	
	// 기존에 저장된 데이터들을 DB에서 가져와 DTO 에 담기
	RestaurantDTO dto = dao.getRestaurant(post_id);
	
	if(dto == null){
%>
	<script>
		alert("존재하지 않는 게시글입니다")
		location.href="resList.jsp";
	</script>
<% }
	// 게시글 데이터를 기반으로 식당 정보와 이미지 리스트 가져오기
    RestaurantInfoDTO infoDto = dao.getRestaurantInfo(dto.getRestaurant_id());
    ArrayList<RestaurantImageDTO> imageList = dao.getImageList(post_id);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>식당 정보 수정 - <%=dto.getTitle()%></title>

<link rel="stylesheet" href="../../css/resContent.css">
<link rel="stylesheet" href="../../css/resUpdate.css">

</head>
<body>

<div class="contentWrap">
    <form action="resUpdatePro.jsp" method="post" enctype="multipart/form-data">
        
        <input type="hidden" name="post_id" value="<%=post_id%>">
        <input type="hidden" name="restaurant_id" value="<%=infoDto.getRestaurant_id()%>">
        
        <div class="card contentArea">
            <h3>🛠️ 식당 정보 정밀 수정</h3>
            
            <table class="formTable">
                <tr>
                    <th>식당 이름</th>
                    <td><input type="text" name="name" class="inputField" value="<%=infoDto.getName()%>" required></td>
                </tr>
                <tr>
                    <th>글 제목</th>
                    <td><input type="text" name="title" class="inputField" value="<%=dto.getTitle()%>" required></td>
                </tr>
                <tr>
                    <th>우편번호</th>
                    <td><input type="text" name="zipcode" class="inputField" value="<%=infoDto.getZipcode() != null ? infoDto.getZipcode() : ""%>"></td>
                </tr>
                <tr>
                    <th>주소</th>
                    <td>
                        <input type="text" name="address1" class="inputField addressField" value="<%=infoDto.getAddress1() != null ? infoDto.getAddress1() : ""%>">
                        <input type="text" name="address2" class="inputField" value="<%=infoDto.getAddress2() != null ? infoDto.getAddress2() : ""%>">
                    </td>
                </tr>
                <tr>
                    <th>전화번호</th>
                    <td><input type="text" name="phone" class="inputField" value="<%=infoDto.getPhone() != null ? infoDto.getPhone() : ""%>"></td>
                </tr>
                <tr>
                    <th>영업시간</th>
                    <td><input type="text" name="time" class="inputField" value="<%=infoDto.getTime() != null ? infoDto.getTime() : ""%>"></td>
                </tr>
                <tr>
                    <th>대표메뉴</th>
                    <td><input type="text" name="menu" class="inputField" value="<%=infoDto.getMenu() != null ? infoDto.getMenu() : ""%>"></td>
                </tr>
                <tr>
                    <th>상세 설명</th>
                    <td>
                        <textarea name="content" class="inputField contentAreaText" rows="8"><%=dto.getContent()%></textarea>
                    </td>
                </tr>
                
                <tr>
                    <th>기존 이미지 관리</th>
                    <td>
                        <p class="imgNotice">
                            ※ 삭제하고 싶은 사진의 <b>[삭제 체크]</b>를 누르면 DB와 서버에서 삭제됩니다.
                        </p>
                        <div class="imgUpdateBox">
                        <% 
                        if(imageList != null && imageList.size() > 0) {
                            for(RestaurantImageDTO img : imageList) { 
                        %>
                            <div class="imgUpdateItem">
                                <img src="../../upload/admin/<%=img.getFile_name()%>" alt="식당사진">
                                <div class="imgItemName">
                                    <%= "Y".equals(img.getIs_thumbnail()) ? "[대표] " : "[서브] " %><%=img.getFile_name()%>
                                </div>
                                <hr class="imgDivider">
                                
                                <label class="delLabel">
                                    <input type="checkbox" name="del_image_ids" value="<%=img.getImage_id()%>"> 삭제 체크
                                </label>
                            </div>
                        <% 
                            } 
                        } else {
                        %>
                            <p class="noImgMsg">등록된 기존 이미지가 없습니다.</p>
                        <% } %>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>새 이미지 추가</th>
                    <td>
                        <div class="fileInputGroup">
                            <label class="fileLabel">➕ 새 대표 이미지로 교체 (기존 대표는 자동 파쇄):</label><br>
                            <input type="file" name="new_thumbnail" class="fileUploadBtn">
                        </div>
                        <div class="fileInputGroup">
                            <label class="fileLabel">➕ 추가 서브 이미지 등록 (다중 선택 가능):</label><br>
                            <input type="file" name="new_subFiles" class="fileUploadBtn" multiple>
                        </div>
                    </td>
                </tr>
            </table>
            
            <div class="btnArea">
                <input type="submit" value="수정 완료">
                <input type="button" value="취소" onclick="history.back();">
            </div>
        </div>
    </form>
</div>

</body>
</html>