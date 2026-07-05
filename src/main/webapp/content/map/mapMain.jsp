<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="web.miniProject.dto.RestaurantDTO" %>
<%@ page import="web.miniProject.dto.MapMarkerDTO" %>
<%@ page import="web.miniProject.dto.MapDetailDTO" %>
<%@ page import="web.miniProject.dao.Test_MapRestaurantDAO" %>
<%@ page import="java.util.*" %>
    
<%
	Test_MapRestaurantDAO dao = new Test_MapRestaurantDAO();
	
	List<MapMarkerDTO> list = dao.getMarkerList();
%>  
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>맛침반 - 맛집지도</title>
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/common.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/mapMain.css">
</head>
<body>

<!-- ================= HEADER ================= -->
<%@ include file="/content/header.jsp" %>
	<div class="mapWrapper">
		<div class="container">
		
		    <div id="restaurantInfo">
				<div class="emptyMessage">
					🗺️<br>
    				지도에서 마커를 클릭하면<br>
    				상세정보가 표시됩니다.
				</div>
		    </div>
		
		    <div id="map"></div>
		
		</div>
	</div>
	
	<script type="text/javascript" src="https://dapi.kakao.com/v2/maps/sdk.js?appkey=f279225e9e2715da17f18acf8cbbb980&libraries=services"></script>
<script>

var restaurants = [

<%
for(int i=0;i<list.size();i++){

    MapMarkerDTO dto = list.get(i);
%>

{
    postId:<%=dto.getPostId()%>,
    name:"<%=dto.getName()%>",
    lat:<%=dto.getLatitude()%>,
    lng:<%=dto.getLongitude()%>
}

<%=i < list.size()-1 ? "," : "" %>

<%
}
%>

];


// 지도 생성

var mapContainer =
    document.getElementById("map");

var mapOption = {

    center :
        new kakao.maps.LatLng(
            37.5665,
            126.9780
        ),

    level : 5
};

var map =
    new kakao.maps.Map(
        mapContainer,
        mapOption
    );


// 마커 생성

restaurants.forEach(function(r){

    var marker =
        new kakao.maps.Marker({

            map : map,

            position :
                new kakao.maps.LatLng(
                    r.lat,
                    r.lng
                )
        });

    kakao.maps.event.addListener(marker,'click',

        function(){
            loadDetail(r.postId);

        }
    );
});


// AJAX

function loadDetail(postId){
    fetch("mapDetail.jsp?postId=" + postId)
    .then(response => response.json())
    .then(data => {

        let tagsHtml = "";
        let ctx = "<%=request.getContextPath()%>";
        
     	// 💡 1. DB에서 소수점 별점(예: 4.5)을 가져오되, 없으면 0.0 처리
        let rawRating = parseFloat(data.rating || 0); 
        // 소수점 첫째 자리까지 표기 (예: 4.56 -> "4.6")
        let displayRating = rawRating.toFixed(1);

     	// 💡 2. 별(⭐) 개수는 반올림해서 정수로 계산 (예: 4.5 이상이면 5개, 4.4 이하면 4개)
        let starCount = Math.round(rawRating); 
        let starsHtml = "";

        for (let i = 0; i < starCount; i++) {
            starsHtml += "⭐";
        }

        if(data.tags){
            data.tags.split(",").forEach(tag => {
                tagsHtml += "<span class='tag'>#" + tag + "</span>";
            });
        }
        // 06/22 수정
        let imgPath = ctx + "/upload/admin/"
		
        let html = 
        	// ================= TITLE (클릭 이동) =================
            '<a class="titleLink" href="' + ctx + '/content/restaurant/resContent.jsp?post_id=' + data.postId + '">' +
                '<h2 class="title">' + data.name + '</h2>' +
            '</a>' +

            // ================= TAG (작게) =================
            '<div class="tagWrap">' + tagsHtml + '</div>' +

            // ================= STATS =================
            '<div class="statRow">' +
            
                '<div class="statItem">' + starsHtml +' (' + displayRating + ')</div>' +
                '<div class="rightStats">' +
	                '<div class="statItem">❤️ ' + data.likeCnt + '</div>' +
	                '<div class="statItem">🔖 ' + data.bookmarkCnt + '</div>' +
                '</div>' +
            '</div>' +

            // ================= IMAGE =================
            '<img src="' + imgPath + data.thumbnail + '" class="thumb">' +

            // ================= INFO =================
            '<div class="infoBox">' +
                '<div class="infoLine"><span>영업시간</span><div>' + data.time + '</div></div>' +
                '<div class="infoLine"><span>주소</span><div>' + data.address + '</div></div>' +
                '<div class="infoLine"><span>전화번호</span><div>' + data.phone + '</div></div>' +
            '</div>' +

            // ================= BUTTON =================
            '<a class="detailBtn" href="' + ctx + '/content/restaurant/resContent.jsp?post_id=' + data.postId + '">' +
                '상세페이지' +
            '</a>';

        document.getElementById("restaurantInfo").innerHTML = html;
    })
    .catch(error => {
        console.error(error);
    });
}

window.onload = function(){

    document.getElementById("restaurantInfo")
    .addEventListener("click", function(e){
        e.stopPropagation();
    });

    document.getElementById("map")
    .addEventListener("click", function(e){
        e.stopPropagation();
    });

};


</script>
</body>
</html>