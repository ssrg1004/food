package web.miniProject.dto;

import java.sql.Date;
import java.util.List; // 리스트 추가

public class ReviewerDraftDTO {

    // [기존 필드들 그대로 유지]
    private int draft_id;
    private int post_id;
    private int member_id;
    private String request_type;
    private String status;
    private String title;
    private String content;
    private String content_subtitle;
    private int content_order;
    private String zipcode;
    private String address1;
    private String address2;
    private int view_cnt;
    private int like_cnt;
    private int bookmark_cnt;
    private Date request_date;
    private Date approve_date;
    private Integer admin_id;
    private String nickname;

    // [추가해야 할 필드: 이미지와 태그 리스트]
    private List<String> file_name; // 이미지 파일명 목록
    private List<Integer> tag_id;   // 태그 ID 목록

    // 기본 생성자
    public ReviewerDraftDTO() {}

    // [추가된 필드에 대한 Getter & Setter]
    public List<String> getFile_name() {
        return file_name;
    }

    public void setFile_name(List<String> file_name) {
        this.file_name = file_name;
    }

    public List<Integer> getTag_id() {
        return tag_id;
    }

    public void setTag_id(List<Integer> tag_id) {
        this.tag_id = tag_id;
    }

    public int getDraft_id() {
        return draft_id;
    }

    public void setDraft_id(int draft_id) {
        this.draft_id = draft_id;
    }

    public int getPost_id() {
        return post_id;
    }

    public void setPost_id(int post_id) {
        this.post_id = post_id;
    }

    public int getMember_id() {
        return member_id;
    }

    public void setMember_id(int member_id) {
        this.member_id = member_id;
    }

    public String getRequest_type() {
        return request_type;
    }

    public void setRequest_type(String request_type) {
        this.request_type = request_type;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getContent_subtitle() {
        return content_subtitle;
    }

    public void setContent_subtitle(String content_subtitle) {
        this.content_subtitle = content_subtitle;
    }

    public int getContent_order() {
        return content_order;
    }

    public void setContent_order(int content_order) {
        this.content_order = content_order;
    }
    
    public String getZipcode() {
        return zipcode;
    }

    public void setZipcode(String zipcode) {
        this.zipcode = zipcode;
    }

    public String getAddress1() {
        return address1;
    }

    public void setAddress1(String address1) {
        this.address1 = address1;
    }

    public String getAddress2() {
        return address2;
    }

    public void setAddress2(String address2) {
        this.address2 = address2;
    }

    public int getView_cnt() {
        return view_cnt;
    }

    public void setView_cnt(int view_cnt) {
        this.view_cnt = view_cnt;
    }

    public int getLike_cnt() {
        return like_cnt;
    }

    public void setLike_cnt(int like_cnt) {
        this.like_cnt = like_cnt;
    }

    public int getBookmark_cnt() {
        return bookmark_cnt;
    }

    public void setBookmark_cnt(int bookmark_cnt) {
        this.bookmark_cnt = bookmark_cnt;
    }

    public Date getRequest_date() {
        return request_date;
    }

    public void setRequest_date(Date request_date) {
        this.request_date = request_date;
    }

    public Date getApprove_date() {
        return approve_date;
    }

    public void setApprove_date(Date approve_date) {
        this.approve_date = approve_date;
    }

    public Integer getAdmin_id() {
        return admin_id;
    }

    public void setAdmin_id(Integer admin_id) {
        this.admin_id = admin_id;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }
}