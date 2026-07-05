package web.miniProject.dto;

public class MapDetailDTO {
	private int postId;

    private String restaurantName;

    private String thumbnail;

    private String tags;

    private int likeCnt;
    private int bookmarkCnt;

    private String phone;
    private String time;
    
    private String zipcode;
    private String address1;
    private String address2;
    
    private double rating;
    
	public int getPostId() {
		return postId;
	}
	public void setPostId(int postId) {
		this.postId = postId;
	}
	public String getRestaurantName() {
		return restaurantName;
	}
	public void setRestaurantName(String restaurantName) {
		this.restaurantName = restaurantName;
	}
	public String getThumbnail() {
		return thumbnail;
	}
	public void setThumbnail(String thumbnail) {
		this.thumbnail = thumbnail;
	}
	public String getTags() {
		return tags;
	}
	public void setTags(String tags) {
		this.tags = tags;
	}
	public int getLikeCnt() {
		return likeCnt;
	}
	public void setLikeCnt(int likeCnt) {
		this.likeCnt = likeCnt;
	}
	public int getBookmarkCnt() {
		return bookmarkCnt;
	}
	public void setBookmarkCnt(int bookmarkCnt) {
		this.bookmarkCnt = bookmarkCnt;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
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
	public double getRating() {
	    return rating;
	}
	public void setRating(double rating) {
	    this.rating = rating;
	}
}
