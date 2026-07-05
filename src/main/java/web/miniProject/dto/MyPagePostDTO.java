package web.miniProject.dto;

import java.util.Date;

public class MyPagePostDTO {
	private int post_id;
    private String post_type; // RESTAURANT / REVIEWER

    private String title;

    private String thumbnail;

    private String writer;

    private int like_cnt;
    private int bookmark_cnt;
    private int comment_cnt;
    
    private String status;

    private String reg_date;

	public int getPost_id() {
		return post_id;
	}

	public void setPost_id(int post_id) {
		this.post_id = post_id;
	}

	public String getPost_type() {
		return post_type;
	}

	public void setPost_type(String post_type) {
		this.post_type = post_type;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getThumbnail() {
		return thumbnail;
	}

	public void setThumbnail(String thumbnail) {
		this.thumbnail = thumbnail;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
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

	public int getComment_cnt() {
		return comment_cnt;
	}

	public void setComment_cnt(int comment_cnt) {
		this.comment_cnt = comment_cnt;
	}

	public String getReg_date() {
		return reg_date;
	}

	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
    
    
}
