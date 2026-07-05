package web.miniProject.dto;

public class ReviewerLikeDTO {

    private int post_id;
    private int member_id;

    public ReviewerLikeDTO() {}

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
}