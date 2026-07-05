<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>

    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/insert.css?v=101">

    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <style>
        .addressGroup {
            display: flex;
            flex-direction: column;
            gap: 8px;
            width: 100%;
        }
        
        /* 등록신청 체크박스 및 라벨 통합 오렌지 스킨 스타일 패키지 */
        .checkFormLabel {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px !important;
            color: #555;
            cursor: pointer;
            margin-top: 4px;
            user-select: none;
            font-weight: 500;
        }
        
        .checkFormLabel input[type="checkbox"] {
            width: 16px !important;
            height: 16px !important;
            cursor: pointer;
            accent-color: #e8a052;
        }
    </style>
</head>
<body>

<div class="registerContainer">
    <div class="registerBox">

        <div style="width: 100%; margin: 0 0 30px 0;">
            <h2 style="text-align: center; font-size: 24px; font-weight: bold; color: #333;">회원가입</h2>
        </div>

        <form action="insertPro.jsp" method="post" onsubmit="return validateForm()">
            <div class="registerFormWrap">

                <div class="inputGroup">
                    <label class="inputLabel">아이디<span class="requiredDot">•</span></label>
                    <div class="rowGroup">
                        <input type="text"
                               name="id"
                               id="id"
                               placeholder="영문 소문자 + 숫자"
                               onkeyup="handleIdKeyup()">
                        <button type="button" class="btnCheck" onclick="checkId()">중복확인</button>
                    </div>
                    <div id="msg-id" class="msg"></div>
                </div>

                <div class="inputGroup">
                    <label class="inputLabel">비밀번호<span class="requiredDot">•</span></label>
                    <input type="password" name="pw" id="pw" placeholder="비밀번호를 입력하세요" onkeydown="return blockSpace(event)" onpaste="return blockPaste(event)">
                    <div id="msg-pw" class="msg"></div>
                </div>

                <div class="inputGroup">
                    <label class="inputLabel">비밀번호 확인<span class="requiredDot">•</span></label>
                    <input type="password" id="pwConfirm" placeholder="비밀번호 확인" oninput="this.value = this.value.replace(/\s/g, '')">
                    <div id="msg-pwConfirm" class="msg"></div>
                </div>

                <div class="inputGroup">
                    <label class="inputLabel">이름<span class="requiredDot">•</span></label>
                    <input type="text" name="name" id="name" placeholder="이름을 입력하세요">
                    <div id="msg-name" class="msg"></div>
                </div>

                <div class="inputGroup">
                    <label class="inputLabel">닉네임<span class="requiredDot">•</span></label>
                    <div class="rowGroup">
                        <input type="text" name="nickname" id="nickname" placeholder="닉네임을 입력하세요" oninput="resetNicknameCheck()">
                        <button type="button" class="btnCheck" onclick="checkNickname()">중복확인</button>
                    </div>
                    <div id="msg-nickname" class="msg"></div>
                </div>

                <div class="inputGroup">
                    <label class="inputLabel">생년월일</label>
                    <input type="date" name="birth">
                </div>

                <div class="inputGroup">
				    <label class="inputLabel">이메일<span class="requiredDot">•</span></label>
				    <input type="email" name="email" id="email" placeholder="example@email.com" required>
				</div>

                <div class="inputGroup">
                    <label class="inputLabel">주소</label>
                    <div class="addressGroup">
                        <div class="rowGroup">
                            <input type="text" name="zipcode" id="zipcode" placeholder="우편번호" readonly>
                            <button type="button" class="btnCheck" onclick="execDaumPostcode()">주소검색</button>
                        </div>
                        <input type="text" name="address1" id="address1" placeholder="기본주소" readonly>
                        <input type="text" name="address2" id="address2" placeholder="상세주소">
                    </div>
                </div>

                <div class="rowGroup" style="gap:10px; align-items:flex-end;">
                    <div class="inputGroup" style="flex:1;">
                        <label class="inputLabel">통신사</label>
                        <select name="telecom">
                            <option value="">선택</option>
                            <option value="SKT">SKT</option>
                            <option value="KT">KT</option>
                            <option value="LG U+">LG U+</option>
                            <option value="MVNO">알뜰요금제</option>
                        </select>
                    </div>
                    <div class="inputGroup" style="flex:2;">
                        <label class="inputLabel">전화번호</label>
                        <input type="text" name="phone" placeholder="010-0000-0000">
                    </div>
                </div>

                <div class="inputGroup">
				    <label class="inputLabel">성별</label>
				    <div class="rowGroup" style="gap:15px;">
				        <label>
				            <input type="radio" name="gender" value="M">
				            남자
				        </label>
				
				        <label>
				            <input type="radio" name="gender" value="F">
				            여자
				        </label>
				    </div>
				</div>
                
                <div class="inputGroup">
                    <label class="inputLabel">평가단 등록신청</label>
                    <label class="checkFormLabel">
                        <input type="checkbox" id="evaluatorCheck" name="evaluatorCheck" onclick="toggleBlogField()">
                        등록 신청합니다
                    </label>
                </div>
                
                <div class="inputGroup" id="blogField" style="display:none;">
                    <label class="inputLabel">블로그 주소</label>
                    <input type="text" name="blogUrl" id="blogUrl" placeholder="https://blog.naver.com/... ">
                </div>

                <div style="margin-top: 15px;">
                    <button type="submit" class="btnSubmit">회원가입</button>
                </div>

            </div>
        </form>

    </div>
</div>

<script>
let isIdChecked = false;
let isNicknameChecked = false;

/* =======================================
   아이디 입력 시 상태 제어 (안전한 표준 방식)
======================================= */
function handleIdKeyup() {
    isIdChecked = false; // 타이핑 시 중복확인 초기화
    
    let id = document.getElementById("id").value;
    let msg = document.getElementById("msg-id");
    let regex = /^[a-z0-9]*$/;

    if (!regex.test(id)) {
        msg.innerText = "영문 소문자와 숫자만 입력 가능합니다.";
        msg.className = "msg";
    } else {
        msg.innerText = "";
    }
}

/* =======================================
   아이디 중복체크
======================================= */
function checkId() {
    let id = document.getElementById("id").value.trim();
    let msg = document.getElementById("msg-id");
    let regex = /^[a-z0-9]+$/;

    if (id === "") {
        msg.innerText = "아이디를 입력하세요.";
        msg.className = "msg";
        isIdChecked = false;
        return;
    }
    
    if (!regex.test(id)) {
        msg.innerText = "아이디는 소문자와 숫자 조합만 가능합니다.";
        msg.className = "msg";
        isIdChecked = false;
        return;
    }

    fetch("checkId.jsp?id=" + encodeURIComponent(id))
        .then(response => response.text())
        .then(result => {
            result = result.trim();

            if (result === "EMPTY") {
                msg.innerText = "아이디를 입력하세요.";
                msg.className = "msg";
                isIdChecked = false;
            } else if (result === "INVALID") {
                msg.innerText = "영문 소문자와 숫자만 가능합니다.";
                msg.className = "msg";
                isIdChecked = false;
            } else if (result === "DUP") {
                msg.innerText = "이미 사용 중인 아이디입니다.";
                msg.className = "msg";
                isIdChecked = false;
            } else if (result === "OK") {
                msg.innerText = "사용 가능한 아이디입니다.";
                msg.className = "msg success";
                isIdChecked = true;
            } else {
                msg.innerText = "중복확인 중 오류가 발생했습니다.";
                msg.className = "msg";
                isIdChecked = false;
            }
        })
        .catch(error => {
            console.error(error);
            msg.innerText = "서버 연결 오류";
            msg.className = "msg";
            isIdChecked = false;
        });
}
/* =======================================
비밀번호 공백 차단
======================================= */
function blockSpace(e) {
    if (e.key === " " || e.code === "Space") {
        e.preventDefault();
        return false;
    }
    return true;
}

function blockPaste(e) {
    let paste = (e.clipboardData || window.clipboardData).getData("text");
    
    if (/\s/.test(paste)) {
        e.preventDefault();
        alert("공백이 포함된 값은 붙여넣을 수 없습니다.");
        return false;
    }
    return true;
}




/* =======================================
   닉네임 중복체크
======================================= */
function checkNickname() {
    let nickname = document.getElementById("nickname").value.trim();
    let msg = document.getElementById("msg-nickname");

    if (nickname === "") {
        msg.innerText = "닉네임을 입력하세요.";
        msg.className = "msg";
        isNicknameChecked = false;
        return;
    }

    fetch("checkNickname.jsp?nickname=" + encodeURIComponent(nickname))
        .then(response => response.text())
        .then(result => {
            result = result.trim();

            if (result === "EMPTY") {
                msg.innerText = "닉네임을 입력하세요.";
                msg.className = "msg";
                isNicknameChecked = false;
            } else if (result === "DUP") {
                msg.innerText = "이미 사용 중인 닉네임입니다.";
                msg.className = "msg";
                isNicknameChecked = false;
            } else if (result === "OK") {
                msg.innerText = "사용 가능한 닉네임입니다.";
                msg.className = "msg success";
                isNicknameChecked = true;
            } else {
                msg.innerText = "중복확인 중 오류가 발생했습니다.";
                msg.className = "msg";
                isNicknameChecked = false;
            }
        })
        .catch(error => {
            console.error(error);
            msg.innerText = "서버 연결 오류";
            msg.className = "msg";
            isNicknameChecked = false;
        });
}

function resetNicknameCheck() {
    isNicknameChecked = false;
    let msg = document.getElementById("msg-nickname");
    msg.innerText = "";
    msg.className = "msg";
}

/* 주소검색 */
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            document.getElementById("zipcode").value = data.zonecode;
            document.getElementById("address1").value = data.roadAddress;
            document.getElementById("address2").focus();
        }
    }).open();
}

/* 칭 블로그 입력 창 토글 */
function toggleBlogField() {
    const check = document.getElementById("evaluatorCheck");
    const blogField = document.getElementById("blogField");

    if (check.checked) {
        blogField.style.display = "block";
    } else {
        blogField.style.display = "none";
        document.getElementById("blogUrl").value = "";
    }
}

/* =======================================
   최종 대형 서브밋 유효성 검증
======================================= */
function validateForm() {
    let id = document.getElementById("id").value.trim();
    let pw = document.getElementById("pw").value;
    let pwConfirm = document.getElementById("pwConfirm").value;
    let name = document.getElementById("name").value.trim();
    let nickname = document.getElementById("nickname").value.trim();

    let msgId = document.getElementById("msg-id");
    let msgPw = document.getElementById("msg-pw");
    let msgPwConfirm = document.getElementById("msg-pwConfirm");
    let msgName = document.getElementById("msg-name");
    let msgNick = document.getElementById("msg-nickname");

    // 안내 메세지 전면 초기화
    msgId.innerText = ""; msgPw.innerText = ""; msgPwConfirm.innerText = ""; msgName.innerText = ""; msgNick.innerText = "";
    msgId.className = "msg"; msgPw.className = "msg"; msgPwConfirm.className = "msg"; msgName.className = "msg"; msgNick.className = "msg";

    let regex = /^[a-z0-9]+$/;
    let evaluatorCheck = document.getElementById("evaluatorCheck").checked;
    
    let gender = document.querySelector('input[name="gender"]:checked');
    
    let email = document.getElementById("email").value.trim();
    let msgEmail = document.getElementById("msg-email");
    
    let blogUrl = document.getElementById("blogUrl").value.trim();
    
    if (id === "") {
        msgId.innerText = "아이디를 입력해 주세요.";
        document.getElementById("id").focus();
        return false;
    }

    if (!regex.test(id)) {
        msgId.innerText = "아이디는 소문자 + 숫자만 가능합니다.";
        document.getElementById("id").focus();
        return false;
    }

    if (!isIdChecked) {
        msgId.innerText = "아이디 중복확인을 해주세요.";
        document.getElementById("id").focus();
        return false;
    }

    if (pw === "") {
        msgPw.innerText = "비밀번호를 입력해 주세요.";
        document.getElementById("pw").focus();
        return false;
    }

    if (pwConfirm === "") {
        msgPwConfirm.innerText = "비밀번호 확인을 입력해 주세요.";
        document.getElementById("pwConfirm").focus();
        return false;
    }

    if (pw !== pwConfirm) {
        msgPwConfirm.innerText = "비밀번호가 일치하지 않습니다.";
        document.getElementById("pwConfirm").focus();
        return false;
    }

    if (/\s/.test(pw)) {
        msgPw.innerText = "비밀번호에 공백을 사용할 수 없습니다.";
        document.getElementById("pw").focus();
        return false;
    }
    
    if (/\s/.test(pwConfirm)) {
        msgPwConfirm.innerText = "비밀번호에 공백을 사용할 수 없습니다.";
        document.getElementById("pwConfirm").focus();
        return false;
    }
    
    if (name === "") {
        msgName.innerText = "이름을 입력해 주세요.";
        document.getElementById("name").focus();
        return false;
    }

    if (nickname === "") {
        msgNick.innerText = "닉네임을 입력해 주세요.";
        document.getElementById("nickname").focus();
        return false;
    }

    if (!isNicknameChecked) {
        msgNick.innerText = "닉네임 중복확인을 해주세요.";
        document.getElementById("nickname").focus();
        return false;
    }

    if (!gender) {
        alert("성별을 선택해주세요.");
        return false;
    }

    msgEmail.innerText = "";

    if (email === "") {
        msgEmail.innerText = "이메일을 입력해 주세요.";
        document.getElementById("email").focus();
        return false;
    }
    
    if (evaluatorCheck && blogUrl === "") {
        alert("평가단 신청 시 블로그 주소를 입력해주세요.");
        document.getElementById("blogUrl").focus();
        return false;
    }
    
    return true;
}
</script>

</body>
</html>