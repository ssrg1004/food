package web.miniProject.dto;

import java.sql.Date;

public class ReviewerApprovalDTO {

    private int approval_id;
    private int post_id;
    private int member_id;

    private String request_type;
    private Date request_date;

    private int admin_id;
    private Date approve_date;

    // 조인용
    private String writer_nickname;
    private String admin_nickname;

    public ReviewerApprovalDTO() {}

    public int getApproval_id() {
        return approval_id;
    }

    public void setApproval_id(int approval_id) {
        this.approval_id = approval_id;
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

    public Date getRequest_date() {
        return request_date;
    }

    public void setRequest_date(Date request_date) {
        this.request_date = request_date;
    }

    public int getAdmin_id() {
        return admin_id;
    }

    public void setAdmin_id(int admin_id) {
        this.admin_id = admin_id;
    }

    public Date getApprove_date() {
        return approve_date;
    }

    public void setApprove_date(Date approve_date) {
        this.approve_date = approve_date;
    }

    public String getWriter_nickname() {
        return writer_nickname;
    }

    public void setWriter_nickname(String writer_nickname) {
        this.writer_nickname = writer_nickname;
    }

    public String getAdmin_nickname() {
        return admin_nickname;
    }

    public void setAdmin_nickname(String admin_nickname) {
        this.admin_nickname = admin_nickname;
    }
}