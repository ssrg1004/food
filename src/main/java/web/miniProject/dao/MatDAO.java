package web.miniProject.dao;

import web.miniProject.util.*;

public class MatDAO {

	
	// 닉네임 중복확인 메서드
	/*
	public boolean isNicknameExist(String nickname, String mId){

	    boolean result = false;

	    try{

	        conn = matDBUtil.getConn();

	        String sql =
	            "select count(*) "
	          + "from member "
	          + "where nickname=? and id<>?";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, nickname);
	        pstmt.setString(2, mId);
	        rs = pstmt.executeQuery();

	        if(rs.next()){
	            if(rs.getInt(1) > 0){
	                result = true;
	            }
	        }

	    }catch(Exception e){
	        e.printStackTrace();
	    } finally {
	    	close(conn, pstmt, rs);
	    }

	    return result;
	}
	*/
}
