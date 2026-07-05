<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="web.miniProject.util.matDBUtil" %>
<%@ page import="web.miniProject.dto.*" %>
<%@ page import="web.miniProject.dao.*" %>

<%
request.setCharacterEncoding("UTF-8");

MemberDTO loginUser = (MemberDTO)session.getAttribute("loginUser");

if(loginUser == null || !"Y".equals(loginUser.getReviewer_yn())){
%>
<script>
alert("권한이 없습니다.");
location.href="reviewerPostList.jsp";
</script>
<%
    return;
}

String path = request.getServletContext().getRealPath("/upload/reviewer/");
File dir = new File(path);
if(!dir.exists()) dir.mkdirs();

int size = 10 * 1024 * 1024;

MultipartRequest multi =
    new MultipartRequest(request, path, size, "UTF-8", new DefaultFileRenamePolicy());

int post_id = Integer.parseInt(multi.getParameter("post_id"));
String title = multi.getParameter("title");
String zipcode = multi.getParameter("zipcode");
String address1 = multi.getParameter("address1");
String address2 = multi.getParameter("address2");
String[] tags = multi.getParameterValues("tags");

ReviewerPostDAO dao = ReviewerPostDAO.getInstance();
Connection conn = null;
boolean success = false;

try {
    conn = matDBUtil.getConn();
    conn.setAutoCommit(false);

    // 1. draft 생성
    ReviewerDraftDTO dto = new ReviewerDraftDTO();
    dto.setPost_id(post_id);
    dto.setMember_id(loginUser.getMember_id());
    dto.setTitle(title);
    dto.setZipcode(zipcode);
    dto.setAddress1(address1);
    dto.setAddress2(address2);
    dto.setRequest_type("UPDATE");

    int draft_id = dao.insertUpdateDraft(conn, dto);

    // 2. 블록 저장
    int blockCount = Integer.parseInt(multi.getParameter("blockCount"));
    int realOrder = 0;

    for(int i=0; i<blockCount; i++){

        String type = multi.getParameter("type" + i);
        if(type == null || "DELETED".equals(type)) continue;

        // 텍스트 블록
        if("TEXT".equals(type)){
            String subtitle = multi.getParameter("subtitle" + i);
            String content = multi.getParameter("content" + i);

            if(content != null && !content.trim().equals("")){
                dao.insertDraftTextBlock(conn, draft_id, subtitle, content, realOrder++);
            }
        }
        // 이미지 블록
        else if("IMAGE".equals(type)){
            String newFile = multi.getFilesystemName("image" + i); // 새로 업로드한 파일
            String oldFile = multi.getParameter("oldImage" + i);   // ✅ 기존 파일명
            String thumb = multi.getParameter("thumb" + i);

            // 새 파일 없으면 기존 파일 유지
            String fileToSave = (newFile != null) ? newFile : oldFile;

            if(fileToSave != null){
                String isThumb = (thumb != null && thumb.equals(String.valueOf(i))) ? "Y" : "N";
                dao.insertDraftImageBlock(conn, draft_id, fileToSave, isThumb, realOrder++);
            }
        }
    }

    // 3. 태그 처리
    dao.deleteTags(post_id);
    if(tags != null && tags.length > 0){
        dao.insertTags(conn, draft_id, tags); // ✅ draft_id 사용
    }

    // 4. commit
    conn.commit();
    success = true;

} catch(Exception e){
    e.printStackTrace();
    if(conn != null){
        try { conn.rollback(); } catch(Exception ex){}
    }
} finally {
    if(conn != null){
        try { conn.setAutoCommit(true); conn.close(); } catch(Exception ex){}
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>수정 요청 처리</title>
</head>
<body>
<script>
<% if(success){ %>
    alert("수정 요청 완료 (관리자 승인 대기)");
    location.href="reviewerPostDetail.jsp?post_id=<%=post_id%>";
<% } else { %>
    alert("수정 실패");
    history.back();
<% } %>
</script>
</body>
</html>