package web.miniProject.dto;

/*
	공지사항 테이블
create table notice (
notice_id	number			primary key,
writer 		varchar2(20) 	default 'admin',
title		varchar2(200)	not null,
content		clob,			
view_cnt	number			default 0,
reg_date 	date			default sysdate
);
create sequence notice_seq nocache;
commit;
*/

import java.sql.Timestamp;

public class NoticeDTO {
	private int notice_id;
	private String writer;
	private String title;
	private String content;
	private int view_cnt;
	private Timestamp reg_date;
	
	// getter / setter
	
public int getNotice_id() {
	return notice_id;	
}

public void setNotice_id(int notice_id) {
	this.notice_id=notice_id;
}
	
public String getWriter(){
	return writer;
}

public void setWriter(String writer) {
	this.writer=writer;
}

public String getTitle() {
	return title;
}

public void setTitle(String title) {
	this.title=title;
}

public String getContent() {
	return content;
}

public void setContent(String content) {
	this.content=content;
}

public int getView_cnt() {
	return view_cnt;
}

public void setView_cnt(int view_cnt) {
	this.view_cnt=view_cnt;
}

public Timestamp getReg_date() {
	return reg_date;
}

public void setReg_date(Timestamp reg_date) {
	this.reg_date=reg_date;
}

}
