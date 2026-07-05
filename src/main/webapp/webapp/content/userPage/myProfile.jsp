<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="web.miniProject.dto.MemberDTO" %>   

<% MemberDTO mp_sdto = (MemberDTO) session.getAttribute("loginUser"); %>

<!-- CSS -->
<link rel="stylesheet" href="<%=request.getContextPath()%>/css/main.css">

<!-- 주소 API(카카오) -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
</head>

<body>

<div class="profileWrap">

    <h2>내 프로필 수정</h2>

    <form action="<%=request.getContextPath()%>/content/member/updatePro.jsp" method="post" onsubmit="return updateCheck()">

        <table class="profileTable">

            <tr>
                <th>아이디</th>
                <td>
                    <input type="hidden" id="mId" name="id" value="<%=mp_sdto.getId() %>">
			        <span class="readonlyText"><%=mp_sdto.getId() %></span>
                </td>
            </tr>

            <tr>
                <th>닉네임</th>
                <td>
                    <div class="nicknameArea">
	                    <input type="text" id="nickname" name="nickname" value="<%=mp_sdto.getNickname() %>">
	                    <button type="button" onclick="checkNickname()">중복확인</button>
                    </div>
                    <!-- ajax 이용해서 닉네임 확인 후 메시지출력 -->
					<div id="nicknameMsg" class="checkMsg"></div>
                </td>
                
                
            </tr>

            <tr>
                <th>비밀번호</th>
                <td>
                    <input type="password" id="pw" name="pw" onkeyup="checkPw()">
                </td>
            </tr>

            <tr>
                <th>비밀번호 확인</th>
                <td>
                    <input type="password" id="pwCheck" onkeyup="checkPw()">
                    <!-- 비밀번호 동일 확인 후 메시지출력 -->
					<div id="pwMsg" class="checkPw"></div>
                </td>
            </tr>

            <tr>
                <th>이메일</th>
                <td>
                    <input type="email" id="email" name="email" value="<%=mp_sdto.getEmail() %>">
                </td>
            </tr>      

			<tr>
			   <th>주소</th>
			   <td>
			   <!-- 기존 값 value 에 넣어서 불러오기(우편번호/기본주소/상세주소) -->
			       <div class="addressTop">		
			           <input type="text"
			                  id="zipcode"
			                  name="zipcode"
			                  placeholder="우편번호"
			                  <%if(mp_sdto.getZipcode() != null) {%>
			                  		value="<%=mp_sdto.getZipcode() %>"
			                  <%} %>
			                  readonly>
			           <button type="button" onclick="execDaumPostcode()">
			                주소검색
			            </button>
			        </div>
			        <input type="text"
			               id="address1"
			               name="address1"
			               placeholder="기본주소"
			               <%if(mp_sdto.getAddress1() != null) {%>
			               		value="<%=mp_sdto.getAddress1() %>"
			               <%} %>
			               readonly>
			        <input type="text"
			               id="address2"
			               name="address2"
			               <%if(mp_sdto.getAddress2() != null) {%>
			               		value="<%=mp_sdto.getAddress2() %>"
			               <%} %>
			               placeholder="상세주소">
			    </td>
			</tr>
			<tr>
     			<th>성별</th>
                <td>
                   	<%if(mp_sdto.getGender().equals("M")) {%> 남자
                   		<input type="hidden" name="gender" value="M">
                   	<%}else if(mp_sdto.getGender().equals("F")) {%>여자
                   		<input type="hidden" name="gender" value="W">
                   	<%}else { %>-
                   	<%} %>
                </td>
            </tr>

            <tr>
                <th>통신사</th>
                <td>
                    <select name="telecom">
                        <option>
                        	<%if(mp_sdto.getTelecom() != null) {%>
	                        	<%=mp_sdto.getTelecom() %>
                        	<%} %>
                        </option>
                        <option>SKT</option>
                        <option>KT</option>
                        <option>LG U+</option>
                        <option>알뜰폰</option>
                    </select>
                </td>
            </tr>

            <tr>
                <th>전화번호</th>
                <td>
                <!-- vaule 에 유저 폰번호 데이터 넣기 -->
                    <input type="text" name="phone"
                           placeholder="010-1234-5678" 
                           <%if(mp_sdto.getPhone() != null) {%>
	                        	value="<%=mp_sdto.getPhone() %>"
                        	<%} %>
                    >
                </td>
            </tr>
		<!----- 평가단 가입창 ----->
		<!-- role:user, reviewer:N == 평가단 아닌 일반 user만 평가단가입 표기 -->
		<%	if(mp_sdto.getReviewer_yn().equals("N") && !mp_sdto.getRole().equals("admin")){%>
			<tr>
                <th>평가단 가입</th>
                <td>
                    <label>
                        <input type="checkbox"
                               id="reviewerCheck"
                               name="reviewer_yn"
                               value="S"
                               onchange="toggleUrl()">
                        가입 희망 (관리자 승인 필요)
                    </label>
                </td>
            </tr>

            <tr id="urlRow" style="display:none;">
                <th>URL</th>
                <td>
                    <input type="text"
                           name="reviewer_url"
                           placeholder="블로그 또는 SNS 주소">
                </td>
            </tr>
        <!-- 그 외는 평가단가입창 미표기 -->  
        <!-- 평가단인 경우 기존 값인 Y 값으로 넘김 -->
		<%	}else if(mp_sdto.getReviewer_yn().equals("Y")){ %>
			<input type="hidden" name="reviewer_yn_hidden" value="Y">
		 <!-- 관리자인 경우 : N 처리 -->
		<%	}else { %>
			<input type="hidden" name="reviewer_yn_hidden" value="N">
		<%	} %>
		<!--------------------------------------------------------------->
		
        </table>
		<% if(mp_sdto.getRole().equals("admin")){ %>
			<input type="hidden" name="role" value="admin">
		<%}else{ %>
			<input type="hidden" name="role" value="USER">
		<%} %>
		
        <div class="profileBtnArea">
            <button type="submit" class="profileBtn">
                수정하기
            </button>
            <button type="button" class="withdrawBtn"
            	onclick="window.location='myPage.jsp?page=withdraw'">
                회원탈퇴
            </button>
        </div>
        

    </form>

</div>

<script>

// 닉네임 중복검색 AJAX
function checkNickname(){

    let nickname = document.getElementById("nickname").value;
    let mId = document.getElementById("mId").value;

    fetch(
        "nicknameCheck.jsp?nickname=" + encodeURIComponent(nickname)
        + "&mId=" + encodeURIComponent(mId) )
    .then(response => response.text())
    .then(result => {
        let msg = document.getElementById("nicknameMsg");

        if(result.trim() == "OK"){
            msg.innerHTML = "사용 가능한 닉네임입니다.";
            msg.style.color = "green";
        }else{
            msg.innerHTML = "이미 사용중인 닉네임입니다.";
            msg.style.color = "red";
        }
    });
}

// 비밀번호 확인
function checkPw(){

    let pw =  document.getElementById("pw").value;
    let pwCheck = document.getElementById("pwCheck").value;
    let msg = document.getElementById("pwMsg");

    if(pwCheck.length == 0){
        msg.innerHTML = "";
        return;
    }

    if(pw == pwCheck){
        msg.innerHTML = "비밀번호가 일치합니다.";
        msg.style.color = "green";

    }else{
        msg.innerHTML = "비밀번호가 일치하지 않습니다.";
        msg.style.color = "red";
    }
}

// 주소검색
function execDaumPostcode() {
	
    new daum.Postcode({
        oncomplete: function(data) {
            document.getElementById("zipcode").value = data.zonecode;
            document.getElementById("address1").value = data.address;
            document.getElementById("address2").focus();
        }

    }).open();
}

// 평가단 가입 URL토글
function toggleUrl(){
	
    let check = document.getElementById("reviewerCheck");
    let row = document.getElementById("urlRow");

    if(check.checked){
        row.style.display = "";
    }
    else{
        row.style.display = "none";
    }
}

// 회원정보 수정버튼 누를 시 한번 더 검증하는 메서드
function updateCheck(){
    let pw = document.getElementById("pw").value;
    let pwCheck = document.getElementById("pwCheck").value;
    let emailCheck = document.getElementById("email").value;
    
    if(pw.trim() == ""){
    	alert("비밀번호를 입력해주세요.");
        document.getElementById("pw").focus();
        return false;
    }
    else if(pw != pwCheck){
        alert("비밀번호가 일치하지 않습니다.");
        document.getElementById("pwCheck").focus();
        return false;
    }
    else if(emailCheck.trim() == ""){
    	alert("이메일을 작성해주세요.");
        document.getElementById("email").focus();
        return false;
    }else{
    	return confirm("회원정보를 수정하시겠습니까?");
    }
}

</script>