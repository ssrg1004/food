<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="web.miniProject.dto.*" %>
<%@ page import="web.miniProject.dao.*" %>
<%@ page import="java.util.*" %>

<%
MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

int post_id = Integer.parseInt(request.getParameter("post_id"));

ReviewerPostDAO dao = ReviewerPostDAO.getInstance();
ReviewerPostDTO dto = dao.getDetail(post_id, loginUser);

if(dto == null){
%>
<script>
alert("존재하지 않는 글입니다.");
location.href="reviewerPostList.jsp";
</script>
<%
    return;
}

if(loginUser == null || loginUser.getMember_id() != dto.getMember_id()){
%>
<script>
alert("본인 글만 수정 가능합니다.");
location.href="reviewerPostList.jsp";
</script>
<%
    return;
}

// 기존 텍스트 블록
ArrayList<ReviewerDraftDTO> blocks = dao.getContentBlocks(post_id);
int textSize = (blocks == null) ? 0 : blocks.size();

// 기존 이미지 블록
ArrayList<ReviewerImageDTO> images = dao.getImages(post_id);
int imageSize = (images == null) ? 0 : images.size();

// 전체 블록 수
int totalSize = textSize + imageSize;

// 기존 태그
ArrayList<String> tags = dao.getTags(post_id);
if(tags == null) tags = new ArrayList<String>();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글 수정</title>

<link rel="stylesheet" href="<%=request.getContextPath()%>/css/header.css">
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/reviewer.css">

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
let blockIndex = <%=totalSize%>;

function execDaumPostcode(){
    new daum.Postcode({
        oncomplete:function(data){
            document.getElementById("zipcode").value = data.zonecode;
            document.getElementById("address1").value = data.address;
            document.getElementById("address2").focus();
        }
    }).open();
}

function removeBlock(index){
    const wrap = document.getElementById("block_wrapper_" + index);
    if(wrap){
        document.getElementById("type_" + index).value = "DELETED";
        wrap.style.display = "none";
    }
}

function addTextBlock(){
    const c = document.getElementById("blocks");
    const div = document.createElement("div");
    div.className = "block text";
    div.id = "block_wrapper_" + blockIndex;

    div.innerHTML =
        "<h4>텍스트 블록 <button type='button' onclick='removeBlock(" + blockIndex + ")'>✕</button></h4>" +
        "<input type='hidden' name='type" + blockIndex + "' id='type_" + blockIndex + "' value='TEXT'>" +
        "<input type='text' name='subtitle" + blockIndex + "' placeholder='소제목'>" +
        "<textarea name='content" + blockIndex + "' placeholder='내용'></textarea>";

    c.appendChild(div);
    blockIndex++;
    document.getElementById("blockCount").value = blockIndex;
}

function addImageBlock(){
    const c = document.getElementById("blocks");
    const div = document.createElement("div");
    div.className = "block image";
    div.id = "block_wrapper_" + blockIndex;

    div.innerHTML =
        "<h4>이미지 블록 <button type='button' onclick='removeBlock(" + blockIndex + ")'>✕</button></h4>" +
        "<input type='hidden' name='type" + blockIndex + "' id='type_" + blockIndex + "' value='IMAGE'>" +
        "<input type='file' name='image" + blockIndex + "'>" +
        "<label><input type='checkbox' name='thumb" + blockIndex + "' value='" + blockIndex + "'> 대표 이미지</label>";

    c.appendChild(div);
    blockIndex++;
    document.getElementById("blockCount").value = blockIndex;
}
</script>

</head>
<body>

<%@ include file="/content/header.jsp" %>

<div class="formContainer">

<form action="reviewerPostUpdatePro.jsp" method="post" enctype="multipart/form-data">

    <input type="hidden" name="post_id" value="<%=post_id%>">
    <input type="hidden" name="blockCount" id="blockCount" value="<%=totalSize%>">

    <h2>글 수정</h2>

    <input type="text" name="title" value="<%=dto.getTitle()%>">

    <div class="address-group" style="display:flex; gap:10px;">
        <input type="text" name="zipcode" id="zipcode" value="<%=dto.getZipcode() != null ? dto.getZipcode() : ""%>" readonly>
        <button type="button" onclick="execDaumPostcode()">주소 검색</button>
    </div>
    <input type="text" name="address1" id="address1" value="<%=dto.getAddress1() != null ? dto.getAddress1() : ""%>" readonly>
    <input type="text" name="address2" id="address2" value="<%=dto.getAddress2() != null ? dto.getAddress2() : ""%>">

    <hr>

    <!-- 태그 영역 -->
    <div class="tagSection">
        <h3>TAG 카테고리 선택</h3>

        <div class="tagGroup">
            <h4>음식 종류</h4>
            <div class="tagGrid">
                <label class="tagLabel"><input type="checkbox" name="tags" value="한식" <%=tags.contains("한식") ? "checked" : ""%>># 한식</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="중식" <%=tags.contains("중식") ? "checked" : ""%>># 중식</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="일식" <%=tags.contains("일식") ? "checked" : ""%>># 일식</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="양식" <%=tags.contains("양식") ? "checked" : ""%>># 양식</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="아시안" <%=tags.contains("아시안") ? "checked" : ""%>># 아시안</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="카페" <%=tags.contains("카페") ? "checked" : ""%>># 카페</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="디저트" <%=tags.contains("디저트") ? "checked" : ""%>># 디저트</label>
            </div>
        </div>

        <div class="tagGroup">
            <h4>방문 목적</h4>
            <div class="tagGrid">
                <label class="tagLabel"><input type="checkbox" name="tags" value="가성비" <%=tags.contains("가성비") ? "checked" : ""%>># 가성비</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="고급" <%=tags.contains("고급") ? "checked" : ""%>># 고급</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="데이트" <%=tags.contains("데이트") ? "checked" : ""%>># 데이트</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="가족모임" <%=tags.contains("가족모임") ? "checked" : ""%>># 가족모임</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="회식" <%=tags.contains("회식") ? "checked" : ""%>># 회식</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="혼밥" <%=tags.contains("혼밥") ? "checked" : ""%>># 혼밥</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="술집" <%=tags.contains("술집") ? "checked" : ""%>># 술집</label>
            </div>
        </div>

        <div class="tagGroup">
            <h4>분위기 및 편의</h4>
            <div class="tagGrid">
                <label class="tagLabel"><input type="checkbox" name="tags" value="조용한" <%=tags.contains("조용한") ? "checked" : ""%>># 조용한</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="감성" <%=tags.contains("감성") ? "checked" : ""%>># 감성</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="시끌벅적한" <%=tags.contains("시끌벅적한") ? "checked" : ""%>># 시끌벅적한</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="뷰맛집" <%=tags.contains("뷰맛집") ? "checked" : ""%>># 뷰맛집</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="주차가능" <%=tags.contains("주차가능") ? "checked" : ""%>># 주차가능</label>
                <label class="tagLabel"><input type="checkbox" name="tags" value="야외테라스" <%=tags.contains("야외테라스") ? "checked" : ""%>># 야외테라스</label>
            </div>
        </div>
    </div>

    <hr>

    <!-- 기존 블록 렌더링 -->
    <div id="blocks">

    <%
    // 텍스트 블록
    if(blocks != null){
        for(int i=0; i<blocks.size(); i++){
            ReviewerDraftDTO b = blocks.get(i);
            String subtitleVal = b.getContent_subtitle() != null ? b.getContent_subtitle() : "";
            String contentVal = b.getContent() != null ? b.getContent() : "";
    %>
            <div class="block text" id="block_wrapper_<%=i%>">
                <h4>텍스트 블록 <button type="button" onclick="removeBlock(<%=i%>)">✕</button></h4>
                <input type="hidden" name="type<%=i%>" id="type_<%=i%>" value="TEXT">
                <input type="text" name="subtitle<%=i%>" value="<%=subtitleVal%>" placeholder="소제목">
                <textarea name="content<%=i%>" placeholder="내용"><%=contentVal%></textarea>
            </div>
    <%
        }
    }

    // 이미지 블록 (텍스트 블록 다음 인덱스부터)
    if(images != null){
        for(int j=0; j<images.size(); j++){
            ReviewerImageDTO img = images.get(j);
            int idx = textSize + j;
            String fileName = img.getFile_name() != null ? img.getFile_name() : "";
            String isThumb = img.getIs_thumbnail() != null ? img.getIs_thumbnail() : "N";
    %>
            <div class="block image" id="block_wrapper_<%=idx%>">
                <h4>이미지 블록 <button type="button" onclick="removeBlock(<%=idx%>)">✕</button></h4>
                <input type="hidden" name="type<%=idx%>" id="type_<%=idx%>" value="IMAGE">
                <input type="hidden" name="oldImage<%=idx%>" value="<%=fileName%>">
                <div style="margin-bottom:5px; color:#666;">기존 파일: <strong><%=fileName%></strong></div>
                <input type="file" name="image<%=idx%>">
                <label>
                    <input type="checkbox" name="thumb<%=idx%>" value="<%=idx%>" <%="Y".equals(isThumb) ? "checked" : ""%>> 대표 이미지
                </label>
            </div>
    <%
        }
    }
    %>

    </div>

    <br>

    <div class="block-add-btns">
        <button type="button" onclick="addTextBlock()">+ 텍스트 블록 추가</button>
        <button type="button" onclick="addImageBlock()">+ 이미지 블록 추가</button>
    </div>

    <br>

    <button type="submit">수정 요청</button>

</form>
</div>

</body>
</html>