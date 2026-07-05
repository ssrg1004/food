<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="web.miniProject.dao.Test_MapRestaurantDAO"%>
<%@ page import="web.miniProject.dto.MapDetailDTO"%>
<%
	int post_id = Integer.parseInt(request.getParameter("postId"));

	Test_MapRestaurantDAO dao = new Test_MapRestaurantDAO();

	MapDetailDTO dto = dao.getMapDetail(post_id);
	
	String time = dto.getTime();
	String phone = dto.getPhone();
	String address1 = dto.getAddress1();
	String address2 = dto.getAddress2();
	
	if(phone == null) { phone = "-"; }
	if(address1 == null) { address1 = ""; }
	if(address2 == null) { address2 = ""; }

%>

{
    "postId":"<%=dto.getPostId()%>",
    "name":"<%=dto.getRestaurantName()%>",
    "thumbnail":"<%=dto.getThumbnail()%>",
    "tags":"<%=dto.getTags()%>",
    "phone":"<%=phone%>",
    "time":"<%=time%>",
    "address":"<%=address1%> <%=address2%>",
    "likeCnt":"<%=dto.getLikeCnt()%>",
	"bookmarkCnt":"<%=dto.getBookmarkCnt()%>",
	"rating": <%=dto.getRating()%>
}