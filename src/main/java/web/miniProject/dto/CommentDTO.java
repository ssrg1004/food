package web.miniProject.dto;

public class CommentDTO {
	private int comment_id;
	private int post_id;
	private int member_id;
	private Integer parent_id;
	private String content;
	private int star_score;
	private String delete_yn;
	private String status;
	private String reg_date;
	private String nickname;
	private String post_title;
	private String process_yn;

	// getter
	public int getComment_id() { return this.comment_id; }
	public int getPost_id() { return this.post_id; }
	public int getMember_id() { return this.member_id; }
	public Integer getParent_id() { return this.parent_id; }
	public String getContent() { return this.content; }
	public int getStar_score() { return this.star_score; }
	public String getDelete_yn() { return this.delete_yn; }
	public String getStatus() { return this.status; }
	public String getReg_date() { return this.reg_date; }
	public String getNickname() { return this.nickname; }
	public String getPost_title() { return post_title; }
	public String getProcess_yn() { return process_yn; }
	
	// setter
	public void setComment_id(int comment_id) { this.comment_id = comment_id; }
	public void setPost_id(int post_id) { this.post_id = post_id; }
	public void setMember_id(int member_id) { this.member_id = member_id; }
	public void setParent_id(Integer parent_id) { this.parent_id = parent_id; }
	public void setContent(String content) { this.content = content; }
	public void setStar_score(int star_score) { this.star_score = star_score; }
	public void setDelete_yn(String delete_yn) { this.delete_yn = delete_yn; }
	public void setStatus(String status) { this.status = status; }
	public void setReg_date(String reg_date) { this.reg_date = reg_date; }
	public void setNickname(String nickname) { this.nickname = nickname; }
	public void setPost_title(String post_title) { this.post_title = post_title; }
	public void setProcess_yn(String process_yn) { this.process_yn = process_yn; }
}
