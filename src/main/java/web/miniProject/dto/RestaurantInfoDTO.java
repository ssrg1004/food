package web.miniProject.dto;

public class RestaurantInfoDTO {
	private int restaurant_id;
	private String name;
	private String zipcode;
	private String address1;
	private String address2;
	private String phone;
	private String time;
	private String menu;
	private double latitude;
	private double longitude;
	
	// getter / setter
	
	public int getRestaurant_id() {return restaurant_id;}
	public void setRestaurant_id(int restaurant_id) {this.restaurant_id=restaurant_id;}
	
	public String getName() {return name;}
	public void setName (String name) {this.name=name;}
	
	public String getZipcode(){return zipcode;}
	public void setZipcode(String zipcode) {this.zipcode=zipcode;}
	
	public String getAddress1() {return address1;}
	public void setAddress1(String address1) {this.address1=address1;}
	
	public String getAddress2() {return address2;}
	public void setAddress2(String address2) {this.address2=address2;}
	
	public String getPhone() {return phone;}
	public void setPhone(String phone) {this.phone=phone;}
	
	public String getTime() {return time;}
	public void setTime(String time) {this.time=time;}
	
	public String getMenu() {return menu;}
	public void setMenu(String menu) {this.menu=menu;}
	
	public double getLatitude() {return latitude;}
	public void setLatitude (double latitude) {this.latitude=latitude;}
	
	public double getLongitude() {return longitude;}
	public void setLongitude(double longitude) {this.longitude=longitude;}
}
