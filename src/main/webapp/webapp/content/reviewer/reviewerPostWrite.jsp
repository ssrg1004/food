<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dto.MemberDTO" %>

<%
MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

if(loginUser == null || !"Y".equals(loginUser.getReviewer_yn())){
%>
<script>
alert("평가단만 작성 가능합니다.");
location.href="reviewerPostList.jsp";
</script>
<%
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>평가단 글 작성</title>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/reviewer.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
let blockIndex = 0;

// 서버에 현재 생성된 총 블록 개수 전달 (삭제되어 숨겨진 블록 인덱스까지 카운트 유지 위해 index 그대로 전달)
function updateBlockCount() {
    document.getElementById("blockCount").value = blockIndex;
}

// [추가] 카카오 주소 검색 팝업 구동 함수
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // ERD 매핑용 input 요소에 각각 매칭
            document.getElementById('zipcode').value = data.zonecode;
            document.getElementById('address1').value = data.address;
            document.getElementById('address2').focus(); // 상세주소창으로 포커스 이동
        }
    }).open();
}

function addTextBlock(){
    const container = document.getElementById("blocks");
    const div = document.createElement("div");
    div.className = "block text";
    div.id = "block_wrapper_" + blockIndex; // [추가] 삭제 제어를 위한 ID 지정

    // [변경] 블록 타이틀 우측에 삭제(✕) 버튼 배치 및 hidden type 태그에 ID값 추가
    div.innerHTML =
        '<h4>텍스트 블록 <button type="button" class="btn-block-remove" onclick="removeBlock(' + blockIndex + ')" style="float:right; background:none; border:none; color:#aaa; cursor:pointer; font-size:16px;">✕</button></h4>' +
        '<input type="text" name="subtitle' + blockIndex + '" placeholder="소제목">' +
        '<textarea name="content' + blockIndex + '" placeholder="내용 입력"></textarea>' +
        '<input type="hidden" name="type' + blockIndex + '" id="type_' + blockIndex + '" value="TEXT">';

    container.appendChild(div);
    blockIndex++;
    updateBlockCount(); 
}

function addImageBlock(){
    const container = document.getElementById("blocks");
    const div = document.createElement("div");
    div.className = "block image";
    div.id = "block_wrapper_" + blockIndex; // [추가] 삭제 제어를 위한 ID 지정

    // [변경] 블록 타이틀 우측에 삭제(✕) 버튼 배치 및 hidden type 태그에 ID값 추가
    div.innerHTML =
        '<h4>이미지 블록 <button type="button" class="btn-block-remove" onclick="removeBlock(' + blockIndex + ')" style="float:right; background:none; border:none; color:#aaa; cursor:pointer; font-size:16px;">✕</button></h4>' +
        '<input type="file" name="image' + blockIndex + '">' +
        '<input type="hidden" name="type' + blockIndex + '" id="type_' + blockIndex + '" value="IMAGE">' +
        '<label><input type="checkbox" name="thumb' + blockIndex + '" value="' + blockIndex + '" class="thumb-check" onclick="checkOnlyOneThumb(this)"> 대표 이미지</label>';

    container.appendChild(div);
    blockIndex++;
    updateBlockCount(); 
}

// [추가] 사용자가 잘못 생성한 동적 블록을 화면에서 숨기고 서버 처리를 건너뛰게 마킹하는 함수
function removeBlock(index) {
    const target = document.getElementById("block_wrapper_" + index);
    if(target) {
        // 완전 요소를 삭제하면 파라미터 유실로 오류가 날 수 있으므로 
        // type 구분을 'DELETED'로 조작하고 화면에서만 즉시 숨깁니다. (Pro 페이지에서 예외 skip 유도)
        document.getElementById("type_" + index).value = "DELETED";
        target.style.display = "none";
    }
}

function checkOnlyOneThumb(element) {
    const checkboxes = document.querySelectorAll('.thumb-check');
    checkboxes.forEach((cb) => {
        if (cb !== element) cb.checked = false;
    });
}

function validateForm() {
    // 실제 살아있는(DELETED가 아닌) 블록 개수 계산
    let activeBlockCount = 0;
    for(let i=0; i<blockIndex; i++) {
        const typeVal = document.getElementById("type_" + i).value;
        if(typeVal !== "DELETED") activeBlockCount++;
    }

    if (activeBlockCount === 0) {
        alert("최소 한 개 이상의 텍스트 또는 이미지 블록을 유지해야 합니다.");
        return false;
    }
    
    // 이미지 블록 중 대표 이미지가 선택되었는지 검증
    let hasImage = false;
    let hasThumb = false;
    for(let i=0; i<blockIndex; i++) {
        const typeVal = document.getElementById("type_" + i).value;
        if(typeVal === "IMAGE") {
            hasImage = true;
            const thumbCheck = document.querySelector('input[name="thumb' + i + '"]');
            if(thumbCheck && thumbCheck.checked) {
                hasThumb = true;
            }
        }
    }

    if (hasImage && !hasThumb) {
        alert("이미지 블록이 있을 경우, 하나는 반드시 '대표 이미지'로 지정해야 합니다.");
        return false;
    }
    return true;
}
</script>
</head>

<body>

<%@ include file="/content/header.jsp" %>

<div class="formContainer">

<form action="reviewerPostWritePro.jsp" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
    
    <h2>평가단 글 작성</h2>

    <input type="hidden" name="blockCount" id="blockCount" value="0">

    <input type="text" name="title" placeholder="제목을 입력하세요" required>
    
    <div class="address-group" style="display: flex; gap: 10px; margin-bottom: 15px;">
        <input type="text" name="zipcode" id="zipcode" placeholder="우편번호" readonly style="width: 180px; margin-bottom: 0;">
        <button type="button" onclick="execDaumPostcode()" style="height: 48px; border-radius: 8px; background: #ff6b35; color: #fff; padding: 0 20px; border: none; font-weight: 600; cursor: pointer;">주소 검색</button>
    </div>
    <input type="text" name="address1" id="address1" placeholder="주소 검색 버튼을 눌러주세요" readonly>
    <input type="text" name="address2" id="address2" placeholder="상세 주소를 입력하세요">

    <div class="tagSection">
        <h3>TAG 카테고리 선택</h3>
        
        <div class="tagGroup">
            <h4>음식 종류</h4>
            <div class="tagGrid">
                <label class="tagLabel"><input type="checkbox" name="tags" value="한식"># 한식</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="중식"># 중식</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="일식"># 일식</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="양식"># 양식</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="아시안"># 아시안</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="카페"># 카페</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="디저트"># 디저트</label>
            </div>
        </div>

        <div class="tagGroup">
            <h4>방문 목적</h4>
            <div class="tagGrid">
                <label class="tagLabel"><input type="checkbox" name="tags" value="가성비"># 가성비</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="고급"># 고급</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="데이트"># 데이트</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="가족모임"># 가족모임</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="회식"># 회식</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="혼밥"># 혼밥</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="술집"># 술집</label>
            </div>
        </div>

        <div class="tagGroup">
            <h4>분위기 및 편의</h4>
            <div class="tagGrid">
                <label class="tagLabel"><input type="checkbox" name="tags" value="조용한"># 조용한</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="감성"># 감성</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="시끌벅적한"># 시끌벅적한</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="뷰맛집"># 뷰맛집</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="주차가능"># 주차가능</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="야외테라스"># 야외테라스</label>
            </div>
        </div>
    </div>
    <hr>

    <div id="blocks"></div>

    <br>

    <div class="block-add-btns">
    <button type="button" onclick="addTextBlock()">+ 텍스트 블록 추가</button>
    <button type="button" onclick="addImageBlock()">+ 이미지 블록 추가</button>
</div>

    <br><br>

    <button type="submit">등록</button>

</form>

</div>

</body>
</html>