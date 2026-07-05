package web.miniProject.dto;

import java.sql.Date;

public class RestaurantDTO {
	
	private int post_id;
	private int member_id;
	private int restaurant_id;
	private String title;
	private String content;
	private int view_cnt;
	private int like_cnt;
	private int bookmark_cnt;
	private Date reg_date;
	
	// getter / setter
	
	public int getPost_id() {return post_id;}
	public void setPost_id(int post_id) {this.post_id=post_id;}
	
	public int getMember_id() {return member_id;}
	public void setMember_id(int member_id) {this.member_id=member_id;}
	
	public int getRestaurant_id() {return restaurant_id;}
	public void setRestaurant_id(int restaurant_id) {this.restaurant_id=restaurant_id;}
	
	public String getTitle() {return title;}
	public void setTitle(String title) {this.title=title;}
	
	public String getContent() {return content;}
	public void setContent(String content) {this.content=content;}
	
	public int getView_cnt() {return view_cnt;}
	public void setView_cnt(int view_cnt) {this.view_cnt=view_cnt;}
	
	public int getLike_cnt() {return like_cnt;}
	public void setLike_cnt(int like_cnt) {this.like_cnt=like_cnt;}
	
	public int getBookmark_cnt() {return bookmark_cnt;}
	public void setBookmark_cnt(int bookmark_cnt) {this.bookmark_cnt=bookmark_cnt;}
	
	public Date getReg_date() {return reg_date;}
	public void setReg_date(Date reg_date) {this.reg_date=reg_date;}
}
