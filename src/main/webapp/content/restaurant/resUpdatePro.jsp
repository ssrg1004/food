<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="web.miniProject.dao.RestaurantDAO" %>
<%@ page import="web.miniProject.dto.RestaurantDTO" %>
<%@ page import="web.miniProject.dto.RestaurantInfoDTO" %>
<%@ page import="web.miniProject.dto.RestaurantImageDTO" %>

<%
	// 서버 내 실제 이미지 저장 경로 및 최대 크기 설정
	String savePath = request.getServletContext().getRealPath("/upload/admin");
	int maxSize = 10 * 1024 * 1024;
	String encoding = "UTF-8";
	
	// MultipartRequest 객체 생성
	MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, encoding, new DefaultFileRenamePolicy());
	
	// 폼에서 넘어온 데이터들을 multi 객체로 낚아채기
	int post_id = Integer.parseInt(multi.getParameter("post_id"));
	int restaurant_id = Integer.parseInt(multi.getParameter("restaurant_id"));
	
	String name = multi.getParameter("name");
    String title = multi.getParameter("title");
    String zipcode = multi.getParameter("zipcode");
    String address1 = multi.getParameter("address1");
    String address2 = multi.getParameter("address2");
    String phone = multi.getParameter("phone");
    String time = multi.getParameter("time");
    String menu = multi.getParameter("menu");
    String content = multi.getParameter("content");
    
    // 실체 DTO에 수정된 데이터 집어넣기
    RestaurantDTO dto = new RestaurantDTO();
    dto.setPost_id(post_id);
    dto.setTitle(title);
    dto.setContent(content);
    
    RestaurantInfoDTO infoDto = new RestaurantInfoDTO();
    infoDto.setRestaurant_id(restaurant_id);
    infoDto.setName(name);
    infoDto.setZipcode(zipcode);
    infoDto.setAddress1(address1);
    infoDto.setAddress2(address2);
    infoDto.setPhone(phone);
    infoDto.setTime(time);
    infoDto.setMenu(menu);
    
    RestaurantDAO dao = new RestaurantDAO();
    
    // search_text 수정 및 업데이트
    dao.updateSearchText(post_id);
    
    String[] delImageIds = multi.getParameterValues("del_image_ids");
    if (delImageIds != null) {
        for (String imgIdStr : delImageIds) {
            int image_id = Integer.parseInt(imgIdStr);
            
            // DB에서 지우기 전에 실제 서버 하드디스크 폴더에서 지워야 하므로 파일명 획득
            RestaurantImageDTO imgDto = dao.getImageByImageId(image_id);
            if (imgDto != null) {
                File file = new File(savePath + File.separator + imgDto.getFile_name());
                if (file.exists()) {
                    file.delete(); // 하드디스크에서 파일 삭제
                }
            }
            // DB 레코드 삭제
            dao.deleteImageByImageId(image_id);
        }
    }
    
    // 새로 추가하거나 교체한 파일 업로드 처리
    String newThumbnail = multi.getFilesystemName("new_thumbnail");
    if(newThumbnail != null){
    	dao.deleteThumbnailByPostId(post_id, savePath);
    	
    	// 새로운 사진을 대표('Y') 로 인서트
    	RestaurantImageDTO thumbDto = new RestaurantImageDTO();
        thumbDto.setPost_id(post_id);
        thumbDto.setFile_name(newThumbnail);
        thumbDto.setIs_thumbnail("Y");
        dao.insertRestaurantImage(thumbDto);
    }
    
    // 사용자가 새 서브이미지를 추가
    Enumeration files = multi.getFileNames();
    while(files.hasMoreElements()){
    	String fileInputName = (String) files.nextElement();
    	
    	// 서브 파일 태그 이름이 일치하고 실제로 파일이 업로드 되어있을때만 실행
    	if(fileInputName.equals("new_subFiles")){
    		String fileSystemName = multi.getFilesystemName(fileInputName);
    		// 대표 이미지와 겹치지않게 체크
    		if(fileSystemName != null && !fileInputName.equals("new_thumbnail")){
    			RestaurantImageDTO subDto = new RestaurantImageDTO();
    			subDto.setPost_id(post_id);
                subDto.setFile_name(fileSystemName);
                subDto.setIs_thumbnail("N");
                dao.insertRestaurantImage(subDto);
    		}
    	}
    }
    
    // 최종 텍스트 데이터 DB 업데이트 (성공 시 1 반환)
    int resultPost = dao.updateRestaurantPost(dto);
    int resultInfo = dao.updateRestaurantInfo(infoDto);
    
    // 둘다 정상
    if(resultPost > 0 && resultInfo > 0){
%>
	<script>
		alert("식당 정보가 수정되었습니다");
		location.href="resContent.jsp?post_id=<%= post_id %>";
	</script>
<%
	} else {
%> 
	<script>
		alert("수정에 실패하였습니다");
		history.back();
	</script>
<%  } %>