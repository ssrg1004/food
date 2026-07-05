package web.miniProject.dto;

import java.sql.Timestamp;

/*
회원 테이블 생성
create table member(
		member_id	number			primary key,
		id 			varchar2(100)	not null,
		pw 			varchar2(100) 	not null,
		name		varchar2(50) 	not null,
		nickname	varchar2(50) 	not null,
		birth		date			,
		email		varchar2(100)	not null,
		zipcode		varchar2(10)	,
		address1	varchar2(300)	,
		address2	varchar2(300)	,
		telecom		varchar2(20) 	,
		phone		varchar2(20) 	,
		gender		varchar2(10) 	,
		reviewer_yn	char(1)			default 'n',
		role		varchar2(20)	default 'user',
		reg_date	date			default sysdate		
);
create sequence member_seq nocache;
commit;
*/

public class MemberDTO {	// 회원
	private int member_id;

    private String id;
    private String pw;

    // 이 부분은 사용되지 않을 수도 있음.
    private String resetToken;
    private Timestamp resetTokenExp;
    
    private String name;
    private String nickname;

    private String birth;

    private String email;
    
    private String zipcode;
    private String address1;
    private String address2;

    private String telecom;
    private String phone;

    private String gender;

    private String reviewer_yn;  // 'Y' or 'N'
    private String reviewer_url;
    private String role;        // USER, ADMIN 등

    private Timestamp reg_date;
		
	private String auto;
	public String getAuto(){ return auto; }
	public void setAuto(String auto){ this.auto=auto; }		
		
		// getter() / setter()
	 public int getMember_id() {
		 return member_id;
	}

	public void setMember_id(int member_id) {
		this.member_id = member_id;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPw() {
		return pw;
	}

	public void setPw(String pw) {
		this.pw = pw;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getBirth() {
        return birth;
    }

    public void setBirth(String birth) {
        this.birth = birth;
    }

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
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

	public String getTelecom() {
		return telecom;
	}

	public void setTelecom(String telecom) {
		this.telecom = telecom;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getReviewer_yn() {
		return reviewer_yn;
	}

	public void setReviewer_yn(String reviewer_yn) {
		this.reviewer_yn = reviewer_yn;
	}
	
	public String getReviewer_url() {
		return reviewer_url;
	}

	public void setReviewer_url(String reviewer_url) {
		this.reviewer_url = reviewer_url;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public Timestamp getReg_date() {
		return reg_date;
	}

	public void setReg_date(Timestamp reg_date) {
		this.reg_date = reg_date;
	}
}