package web.miniProject.dto;

import java.util.Date;

public class RestaurantSearchDTO {
	private int post_id;
    private int restaurant_id;

    private String title;
    private String name;
    
    private String thumbnail;

    private String zipcode;
    private String address1;
    private String address2;

    private int view_cnt;
    private int like_cnt;
    private int bookmark_cnt;
    
    private Date reg_date;

	private double avg_star;
    private String tags;
    

	public int getPost_id() {
		return post_id;
	}

	public void setPost_id(int post_id) {
		this.post_id = post_id;
	}

	public int getRestaurant_id() {
		return restaurant_id;
	}

	public void setRestaurant_id(int restaurant_id) {
		this.restaurant_id = restaurant_id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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

	public Date getReg_date() {
		return reg_date;
	}

	public void setReg_date(Date reg_date) {
		this.reg_date = reg_date;
	}

	
	public String getThumbnail() {
		return thumbnail;
	}

	public void setThumbnail(String thumbnail) {
		this.thumbnail = thumbnail;
	}
    
    public double getAvg_star() {
		return avg_star;
	}

	public void setAvg_star(double avg_star) {
		this.avg_star = avg_star;
	}

	public String getTags() {
		return tags;
	}

	public void setTags(String tags) {
		this.tags = tags;
	}
}
