<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setAttribute("forceBlock", "Y"); %>
<%@ include file="/content/admin/adminCheck.jsp" %>
<title>맛집 등록</title>

<link rel="stylesheet" href="../../css/resWrite.css">

<div class = "writeWrap">
	<h1>🍽 맛집 등록</h1>
	
	<form action="resWritePro.jsp" method="post" enctype="multipart/form-data" onsubmit="return validateForm();">
	
	<!--  작성자 -->
	<div class="formGroup">
		<label>작성자</label>
		<input type="text" value="관리자" readonly>
	</div>
	
	<!-- 제목 -->
	<div class="formGroup">
		<label>제목</label>
		<input type="text" id="title" name="title" placeholder="제목을 입력해주세요">
	</div>
	
	<!--  썸네일 -->
	<div class="formGroup">
		<label>대표 썸네일</label>
		<input type="file" name="thumbnail" accept="image/*">
	</div>
	
	<!-- 태그 -->
        <div class="formGroup">
            <label>태그 선택 (최대 3개)</label>

           <div class="tagArea">
			<div class="tagGroup">
				<p class="tagGroupTitle">─ 음식 종류 ─</p>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'한식')">#한식</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'중식')">#중식</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'일식')">#일식</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'양식')">#양식</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'아시안')">#아시안</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'카페')">#카페</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'디저트')">#디저트</button>
			</div>

			<div class="tagGroup" style="margin-top: 15px;">
				<p class="tagGroupTitle">─ 방문 목적 ─</p>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'가성비')">#가성비</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'고급')">#고급</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'데이트')">#데이트</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'가족모임')">#가족모임</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'회식')">#회식</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'혼밥')">#혼밥</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'술집')">#술집</button>
			</div>

			<div class="tagGroup" style="margin-top: 15px;">
				<p class="tagGroupTitle">─ 분위기 및 편의 ─</p>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'조용한')">#조용한</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'감성')">#감성</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'시끌벅적한')">#시끌벅적한</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'뷰맛집')">#뷰맛집</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'주차가능')">#주차가능</button>
				<button type="button" class="tagBtn" onclick="toggleTag(this,'야외테라스')">#야외테라스</button>
			</div>
		</div>
		<!-- 06/22 추가  -->
		<input type="hidden" id="selectedTags" name="selectedTags">
		<input type="hidden" id="latitude" name="latitude" value="0">
		<input type="hidden" id="longitude" name="longitude" value="0">
		</div>
		
		<!-- 추가 이미지 -->
		<div class="formGroup">
			<label>추가 이미지</label>
			<input type="file" name="detailImage" accept="image/*"><br><br>
			<input type="file" name="detailImage2" accept="image/*">
		</div>
		
		<!-- 가게 정보 -->
		<h3>📍 가게 기본 정보</h3>
		
		<table class="infoShop">
		
			<tr>
				<th>가게명</th>
				<td>
					<input type="text" name="storeName">
				</td>
			</tr>
			
			<tr>
				<th>우편번호</th>
				<td>
					<input type="text" id="zipcode" name="zipcode" readonly>
				</td>
			</tr>
			
			<tr>
				<th>주소</th>
				<td>
					<input type="text" id="address1" name="address1" readonly>
					<input type="button" value="주소검색" onclick="searchAddress()">
				</td>
			</tr>
			
			<tr>
				<th>상세주소</th>
				<td>
				 	<input type="text" name="address2">
				</td>
			</tr>
			
			<tr>
				<th>전화번호</th>
				<td>
					<input type="text" name="phone">
				</td>
			</tr>
			
			<tr>
				<th>영업시간</th>
				<td>
					<input type="text" name="time">
				</td>
			</tr>
			
			<tr>
				<th>대표메뉴</th>
				<td>
					<input type="text" name="menu">
				</td>
			</tr>
		</table>
		
		<!--  상세 설명 -->
		<div class="formGroup">
			<label>상세 설명 및 평가</label>
			
			<textarea name="content" id="content" rows="15"></textarea>
		</div>
		
		<!-- 버튼 -->
		<div class="btnArea">
			<input type="button" value="취소" onclick="history.back();">
			<input type="submit" value="등록">
		</div>
	</form>
</div>

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- 06/22 추가 -->
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=f279225e9e2715da17f18acf8cbbb980&libraries=services"></script>

<script>
// 태그이름들을 담아둘 배열 상자
	let selectedTags = [];
	// 태그버튼을 클릭했을 떄 실행되는 함수
	function toggleTag(btn , tag){
		if(btn.classList.contains("active")){
			btn.classList.remove("active");
			// 배열에서 방금 선택 취소한 태그를 지움
			selectedTags = selectedTags.filter(t => t !== tag);
		} else {
			// 새 태그를 추가하기 전에 이미 3개가 꽉차있는지 확인
			if(selectedTags.length >= 3){
				alert("태그는 최대 3개까지 선택 가능합니다.");
				return;
			}
			// 3개 미만이면 버튼 불을 켜기
			btn.classList.add("active");
			// 배열 상자에 태그 집어 넣기
			selectedTags.push(tag);
		}
		// 서버 전송 준비
		document.getElementById("selectedTags").value = selectedTags.join(",");
	}
	
	// 06/22 수정
	// 등록 버튼을 눌렀을 때 실행되는 유효성 검사 함수
	function validateForm() {
    let title = document.getElementById("title").value.trim();
    if (title == "") {
        alert("제목을 입력하세요");
        return false;
    }

    let lat = document.getElementById("latitude").value;
    let lng = document.getElementById("longitude").value;
    let address = document.getElementById("address1").value.trim();

    // 주소는 입력했는데 위도/경도가 여전히 0이라면 (비동기 타이밍 문제 발생 시)
    if (address !== "" && (lat === "0" || lng === "0")) {
        
        // 카카오 Geocoder 호출해서 동기식처럼 붙잡기
        const geocoder = new kakao.maps.services.Geocoder();
        
        geocoder.addressSearch(address, function(result, status) {
            if (status === kakao.maps.services.Status.OK) {
                document.getElementById("latitude").value = result[0].y;
                document.getElementById("longitude").value = result[0].x;
                
                // 좌표가 세팅되었으니 이제 진짜로 Form을 제출합니다.
                document.querySelector("form").submit();
            } else {
                alert("주소의 위치 좌표를 찾을 수 없습니다. 다시 검색해 주세요.");
            }
        });
        
        return false; // 카카오가 좌표를 찾아올 때까지 일단 제출을 대기시킵니다.
    }

    return true; // 이미 좌표가 잘 들어가 있다면 그대로 정상 제출
}
	
	// 06/22 수정
	function searchAddress(){
	    new daum.Postcode({
	        oncomplete: function(data) {
	            console.log("선택된 주소 : " + data.address);
	            console.log("선택된 우편번호 : " + data.zonecode); 

	            // 1. 주소 및 우편번호 입력창에 값 넣기
	            document.getElementById("address1").value = data.address;
	            document.getElementById("zipcode").value = data.zonecode;
	            
	            // 📍 [여기서부터 추가됨] 카카오 주소-좌표 변환 객체(Geocoder) 생성
	            const geocoder = new kakao.maps.services.Geocoder();
	            
	            // 2. 선택된 주소를 가지고 위도/경도 좌표를 검색합니다
	            geocoder.addressSearch(data.address, function(result, status) {
	                if (status === kakao.maps.services.Status.OK) {
	                    // 성공적으로 좌표를 찾았다면 hidden 태그(latitude, longitude)에 값 주입
	                    document.getElementById("latitude").value = result[0].y;  // 위도
	                    document.getElementById("longitude").value = result[0].x; // 경도
	                    
	                    console.log("📍 좌표 변환 성공! 위도: " + result[0].y + " / 경도: " + result[0].x);
	                } else {
	                    console.log("⚠️ 주소에 매핑되는 좌표를 찾지 못했습니다.");
	                    // 실패 시 안전하게 기본값 0 세팅
	                    document.getElementById("latitude").value = 0;
	                    document.getElementById("longitude").value = 0;
	                }
	            });
	        }
	    }).open();
	}
</script>


