package web.miniProject.dto;

import java.sql.Date;

public class ReviewerPostDTO {

    // reviewer_post
    private int post_id;
    private int member_id;

    private String title;
    private String content;
    private String zipcode;   // 우편번호
    private String address1;  // 기본 주소
    private String address2;  // 상세 주소

    private int view_cnt;
    private int like_cnt;
    private int bookmark_cnt;

    private String status;

    private Date reg_date;

    // member 조인용
    private String nickname;

    // reviewer_image 조인용
    private String thumbnail;

    // 로그인 사용자 상태
    private boolean liked;
    private boolean bookmarked;

    public ReviewerPostDTO() {
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getReg_date() {
        return reg_date;
    }

    public void setReg_date(Date reg_date) {
        this.reg_date = reg_date;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getThumbnail() {
        return thumbnail;
    }

    public void setThumbnail(String thumbnail) {
        this.thumbnail = thumbnail;
    }

    public boolean isLiked() {
        return liked;
    }

    public void setLiked(boolean liked) {
        this.liked = liked;
    }

    public boolean isBookmarked() {
        return bookmarked;
    }

    public void setBookmarked(boolean bookmarked) {
        this.bookmarked = bookmarked;
    }

    @Override
    public String toString() {
        return "ReviewerPostDTO [post_id=" + post_id
                + ", member_id=" + member_id
                + ", title=" + title
                + ", zipcode=" + zipcode
                + ", address1=" + address1
                + ", address2=" + address2
                + ", view_cnt=" + view_cnt
                + ", like_cnt=" + like_cnt
                + ", bookmark_cnt=" + bookmark_cnt
                + ", status=" + status
                + ", reg_date=" + reg_date
                + ", nickname=" + nickname
                + ", thumbnail=" + thumbnail
                + ", liked=" + liked
                + ", bookmarked=" + bookmarked
                + "]";
    }
}