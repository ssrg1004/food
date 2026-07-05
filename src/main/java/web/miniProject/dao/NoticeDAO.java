package web.miniProject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import web.miniProject.dto.NoticeDTO;
import web.miniProject.util.*;


public class NoticeDAO {

    private Connection conn = null;
    private PreparedStatement pstmt = null;
    private ResultSet rs = null;
    private String sql = null;

    // 공지사항 전체 조회
    public ArrayList<NoticeDTO> list() {

        ArrayList<NoticeDTO> list = new ArrayList<>();

        try {
            // DB 연결
            conn = matDBUtil.getConn();

            sql = "select * from notice order by notice_id desc";

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while(rs.next()) {

                NoticeDTO dto = new NoticeDTO();

                dto.setNotice_id(rs.getInt("notice_id"));
                dto.setWriter(rs.getString("writer"));
                dto.setTitle(rs.getString("title"));
                dto.setContent(rs.getString("content"));
                dto.setView_cnt(rs.getInt("view_cnt"));
                dto.setReg_date(rs.getTimestamp("reg_date"));

                list.add(dto);
            }

        } catch(Exception e) {
            e.printStackTrace();

        } finally {
            // DB 종료
            matDBUtil.close(conn, pstmt, rs);
        }

        return list;
    }
    
    // 공지사항 등록 (DAO insert)
    // 
    public int noticeInsert(NoticeDTO dto) {
		int result = 0;
		
		try {
			conn = matDBUtil.getConn();
			sql="insert into notice(notice_id, title, writer, content, reg_date, view_cnt)"
				+ "values(notice_seq.nextval, ?, ?, ?, sysdate, 0)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getWriter());
			pstmt.setString(3, dto.getContent());
			result=pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return result;
    }
    
    // 공지사항 상세보기 (noContent)
    public NoticeDTO getContent(int notice_id) {
    	NoticeDTO dto = new NoticeDTO();
		
    	try {
			conn= matDBUtil.getConn();
			
			// 조회수 증가
			sql = "update notice"
				+ " set view_cnt = view_cnt + 1"
				+ " where notice_id =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, notice_id);
			pstmt.executeUpdate();
			
			// 게시글 조회
			sql= "select * from notice where notice_id = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, notice_id);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				dto.setNotice_id(rs.getInt("notice_id"));
				dto.setTitle(rs.getString("title"));
				dto.setWriter(rs.getString("writer"));
				dto.setContent(rs.getString("content"));
				dto.setView_cnt(rs.getInt("view_cnt"));
				dto.setReg_date(rs.getTimestamp("reg_date"));
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
    	
    	return dto;
    }
    
    // 공지사항 수정 (noUpdate)
    public int noUpPro (NoticeDTO dto) {
		int result= 0;
    	
		try {
			conn=matDBUtil.getConn();
			
			sql="update notice set title=?, content=? where notice_id=?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			pstmt.setInt(3, dto.getNotice_id());
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return result;
    }
    
    // 공지사항 글 삭제 (noDelete)
    public int noDelete(int notice_id) {
		int result=0;
		
		try {
			conn=matDBUtil.getConn();
			
			sql= "delete from notice where notice_id=?";
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, notice_id);
			
			result=pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return result;
    }
    
    // 전체 글 수
    public int getCount() {
		int result=0;
    	
		try {
			conn=matDBUtil.getConn();
			
			sql="select count(*) from notice";
			pstmt=conn.prepareStatement(sql);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				result=rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return result;
    }
    
    // 페이징 처리
    public ArrayList<NoticeDTO> list(int startRow, int endRow){
		ArrayList<NoticeDTO> list = new ArrayList<>();
		
		try {
			conn = matDBUtil.getConn();
			
			sql= " select * from "
				+" (select rownum rnum, a.* from "
				+" (select * from notice order by notice_id desc) a) "
				+" where rnum >= ? and rnum <= ?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRow);
			pstmt.setInt(2, endRow);
			
			rs=pstmt.executeQuery();
			
			while(rs.next()) {
				NoticeDTO dto = new NoticeDTO ();
				
				dto.setNotice_id(rs.getInt("notice_id"));
				dto.setWriter(rs.getString("writer"));
				dto.setTitle(rs.getString("title"));
				dto.setContent(rs.getString("content"));
				dto.setView_cnt(rs.getInt("view_cnt"));
				dto.setReg_date(rs.getTimestamp("reg_date"));
				
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
    	return list;
    }
    
}