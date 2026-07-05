<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="web.miniProject.util.matDBUtil" %>
<%@ page import="web.miniProject.dto.MemberDTO" %>
<%@ page import="web.miniProject.dto.ReviewerDraftDTO" %>
<%@ page import="web.miniProject.dao.ReviewerPostDAO" %>

<%
request.setCharacterEncoding("UTF-8");

// 1. 세션 및 권한 체크
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

/* 2. 업로드 디렉토리 설정 및 파일 제한 크기(10MB) 지정 */
String path = request.getServletContext().getRealPath("/upload/reviewer/");
System.out.println("reviewerPostWritePro : path = "+ path);
int size = 10 * 1024 * 1024;

File dir = new File(path);
if(!dir.exists()) {
    dir.mkdirs();
}

/* 3. MultipartRequest 객체 생성 (enctype="multipart/form-data" 파싱 완료) */
MultipartRequest multi = new MultipartRequest(request, path, size, "UTF-8", new DefaultFileRenamePolicy());

// 기본 정보 및 고정 태그 배열 수집
String title = multi.getParameter("title");
String zipcode = multi.getParameter("zipcode");
String address1 = multi.getParameter("address1");
String address2 = multi.getParameter("address2");
String[] checkedTags = multi.getParameterValues("tags");

ReviewerPostDAO dao = ReviewerPostDAO.getInstance();

Connection conn = null;
boolean success = false;

try {
    // 4. 단일 커넥션 확보 및 수동 커밋 모드로 트랜잭션 개시
    conn = matDBUtil.getConn();
    conn.setAutoCommit(false); 

    // 5. Draft 메인 DTO 세팅 (ERD에 맞추어 CONTENT는 메인에서 제외됨)
	ReviewerDraftDTO dto = new ReviewerDraftDTO();
    dto.setMember_id(loginUser.getMember_id());
    dto.setTitle(title);
    dto.setZipcode(zipcode);
    dto.setAddress1(address1);
    dto.setAddress2(address2);	

    // REVIEWER_POST_DRAFT 테이블에 데이터 인서트 및 생성된 draft_id 반환받기
    int draft_id = dao.insertDraft(conn, dto);
	System.out.println("reviewerPostWritePro : draft_id : "+draft_id);
    if (draft_id > 0) {
        
        // 6. 사용자가 선택한 고정 카테고리 태그가 있다면 관계 매핑 (insertTags 메서드 내부 구현에 맞춰 conn 전달 가능 시 수정)
        if (checkedTags != null && checkedTags.length > 0) {
            // 프로젝트 구조상 insertTags가 내부에서 conn을 따로 열거나 닫는 구조라면 그대로 쓰고, 
            // 가급적이면 이 메서드도 conn을 받도록 리팩토링하시는 것이 가장 이상적입니다.
            System.out.println("reviewerPostWritePro : tags() 전 if문");
            dao.insertTags(conn, draft_id, checkedTags);
            System.out.println("reviewerPostWritePro : tags() 후 if문");
        }

        // 7. Write.jsp에서 넘어온 동적 블록 카운트 변수 파싱
        int blockCount = 0;
        if(multi.getParameter("blockCount") != null) {
            blockCount = Integer.parseInt(multi.getParameter("blockCount"));
        }
        
		// 사용자가 중간 블록을 삭제했을 때 순서 번호(Order)에 공백이 생기지 않도록 0 부터 순차 증가시킬 고유 압축 정렬 인덱스 카운터 변수 도입
        int realOrder = 0;
        
        // 8. 블록 개수만큼 루프를 돌며 각각 전용 테이블에 순차 세이빙
        for (int i = 0; i < blockCount; i++) {
            String type = multi.getParameter("type" + i);
            
            // [변경 핵심 포인트]: 루프 도중 null 이거나 화면에서 '삭제' 버튼을 누른 블록(DELETED)은 
            // DB 인서트 처리를 하지 않고 그대로 SKIP하여 생략
            if (type == null || "DELETED".equals(type)) {
                continue;
            }

            if ("TEXT".equals(type)) {
                String subtitle = multi.getParameter("subtitle" + i);
                String content = multi.getParameter("content" + i);
                if (content != null && !content.trim().equals("")) {
                    // 순서값 i 대신 중간 공백 없이 채워지는 realOrder를 넘기고 카운트
                    dao.insertDraftTextBlock(conn, draft_id, subtitle, content, realOrder++);
                }
            } 
            // [IMAGE 블록 분기] -> ERD에 따라 REVIEWER_IMAGE_DRAFT 테이블로 매핑 저장
            else if ("IMAGE".equals(type)) {
                String file = multi.getFilesystemName("image" + i);
                String thumb = multi.getParameter("thumb" + i); 

                if (file != null) {
                    // 대표 이미지 체크박스가 체크되었는지 blockIndex(i) 문자열과 대조 검증
                	String isThumbnail = String.valueOf(i).equals(thumb) ? "Y" : "N";
					// 외부 conn을 주입하여 실행
                	dao.insertDraftImageBlock(conn, draft_id, file, isThumbnail, realOrder++);
                
					
                }
            }
            
        }
        
        // 9. 하위 블록들까지 완벽하게 에러 없이 데이터가 쌓였다면 최종 승인(Commit)
        conn.commit();
        success = true;
    }

} catch (Exception e) {
    e.printStackTrace();
    // 오류 발생 시 트랜잭션 전체 무효화 (Rollback)
    if (conn != null) {
        try { conn.rollback(); } catch (Exception ex) { ex.printStackTrace(); }
    }
} finally {
    // 10. 자원 반납 및 기본 오토커밋 모드 원상복구
	if (conn != null) {
        try { conn.setAutoCommit(true); conn.close(); } catch (Exception ex) { ex.printStackTrace(); }
    }
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>작성 처리</title>
</head>
<body>

<script>
<% if (success) { %>
    alert("작성 완료 (관리자 승인 대기)");
    location.href = "reviewerPostList.jsp";
<% } else { %>
    alert("글 등록 중 오류가 발생했습니다. 다시 시도해 주세요.");
    history.back();
<% } %>
</script>
</body>
</html>