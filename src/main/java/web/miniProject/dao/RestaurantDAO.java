package web.miniProject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import web.miniProject.dto.RestaurantDTO;
import web.miniProject.dto.RestaurantImageDTO;
import web.miniProject.dto.RestaurantInfoDTO;
import web.miniProject.util.matDBUtil;

public class RestaurantDAO {

	public RestaurantDAO() {}
	
	// 1. 가게 정보 등록
	public int insertRestaurantInfo(RestaurantInfoDTO dto) {
		int restaurant_id=0;
		
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select restaurant_info_seq.nextval from dual";
		
		try {
			conn = matDBUtil.getConn();
			pstmt = conn.prepareStatement(sql);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				restaurant_id = rs.getInt(1);
			}
			
			sql= "insert into restaurant_info "
				+ "(restaurant_id, name, zipcode, address1, address2, phone, time, menu, latitude, longitude)"
				+ " values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1,  restaurant_id);
			pstmt.setString(2,  dto.getName());
			pstmt.setString(3, dto.getZipcode());
			pstmt.setString(4, dto.getAddress1());
			pstmt.setString(5, dto.getAddress2());
			pstmt.setString(6, dto.getPhone());
			pstmt.setString(7, dto.getTime());
			pstmt.setString(8, dto.getMenu());
			pstmt.setDouble(9, dto.getLatitude());
			pstmt.setDouble(10, dto.getLongitude());
			
			pstmt.executeUpdate();
				
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return restaurant_id;
	}
	
	// 2. 게시글 등록
	public int insertRestaurant(RestaurantDTO dto) {
		int post_id=0;
		
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select restaurant_seq.nextval from dual";
		
		try {
			conn=matDBUtil.getConn();
			pstmt = conn.prepareStatement(sql);
			rs= pstmt.executeQuery();
			
			if(rs.next()) {
				post_id=rs.getInt(1);
			}
			// 게시글 기본 정보 등록
			sql= " insert into restaurant_post "
				+" (post_id, member_id, restaurant_id, title, content, view_cnt, like_cnt, bookmark_cnt, reg_date)"
				+" values (?, ?, ?, ?, ?, 0, 0, 0, sysdate)";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, post_id);
			pstmt.setInt(2, dto.getMember_id());
			pstmt.setInt(3, dto.getRestaurant_id());
			pstmt.setString(4, dto.getTitle());
			pstmt.setString(5, dto.getContent());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return post_id;
	}
	
	// 2-1. 💡 맛집 게시글의 SEARCH_TEXT를 최신 정보로 동적 갱신하는 메서드 (검색용이므로 필수)
	public void updateSearchText(int postId) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    
	    String sql = 
	          " UPDATE RESTAURANT_POST RP "
	        + " SET RP.SEARCH_TEXT = ( "
	        + "     SELECT "
	        + "         RP.TITLE || ' ' || "
	        + "         R.NAME || ' ' || "
	        + "         R.NAME || ' ' || "
	        + "         R.MENU || ' ' || "
	        + "         R.MENU || ' ' || "
	        + "         R.ADDRESS1 || ' ' || "
	        + "         R.ADDRESS2 || ' ' || "
	        + "         NVL(( "
	        + "             SELECT LISTAGG('#' || T.TAG_NAME || ' ' || T.TAG_NAME, ' ') "
	        + "             WITHIN GROUP (ORDER BY T.TAG_NAME) "
	        + "             FROM RESTAURANT_POST_TAG RPT "
	        + "             JOIN TAG T ON T.TAG_ID = RPT.TAG_ID "
	        + "             WHERE RPT.POST_ID = RP.POST_ID "
	        + "         ), '') "
	        + "     FROM RESTAURANT_INFO R "
	        + "     WHERE R.RESTAURANT_ID = RP.RESTAURANT_ID "
	        + " ) "
	        + " WHERE RP.POST_ID = ? ";
	        
	    try {
	        conn = matDBUtil.getConn();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, postId);
	        
	        pstmt.executeUpdate();
	        
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn, pstmt, null);
	    }
	}
	
	// 3. 이미지 등록 (글 작성용)
	public int insertImage(RestaurantImageDTO dto) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs=null;

        String sql = "insert into restaurant_image "
                   + "(image_id, post_id, file_name, is_thumbnail, image_order)"
                   + " values (restaurant_image_seq.nextval, ?, ?, ?, ?)";

        try {
            conn = matDBUtil.getConn();
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, dto.getPost_id());
            pstmt.setString(2, dto.getFile_name());
            pstmt.setString(3, dto.getIs_thumbnail());
            pstmt.setInt(4, dto.getImage_order());

            result = pstmt.executeUpdate();

        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            matDBUtil.close(conn, pstmt, rs);
        }
        return result;
    }
	
	// 태그명으로 조회
	public int getTagId(String tag_name) {
		int tagId = 0;
		
		Connection conn = null;
		PreparedStatement pstmt=null;
		ResultSet rs = null;
		
		String sql="select tag_id from tag where tag_name = ?";
		
		try {
			conn=matDBUtil.getConn();
			pstmt=conn.prepareStatement(sql);
			pstmt.setString(1, tag_name);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				tagId=rs.getInt("tag_id");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return tagId;
	}
	
	// 게시글 - 태그 연결
	public int insertPostTag(int post_id, int tag_id) {
		int result=0;
		
		Connection conn=null;
		PreparedStatement pstmt=null;
		
		String sql="insert into restaurant_post_tag "
				 + "(post_id, tag_id) "
				 + "values (?, ?)";
		
		try {
			conn=matDBUtil.getConn();
			
			pstmt= conn.prepareStatement(sql);
			
			pstmt.setInt(1, post_id);
			pstmt.setInt(2, tag_id);
			result=pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, null);
		}
		
		return result;
	}
	
	// 게시글 조회
	public RestaurantDTO getRestaurant(int post_id) {
		RestaurantDTO dto = null;
		
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from restaurant_post where post_id=? and delete_yn = 'N'";
		
		try {
			conn= matDBUtil.getConn();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, post_id);
			rs=pstmt.executeQuery();
			
			if(rs.next()) {
				dto = new RestaurantDTO();
				
				dto.setPost_id(rs.getInt("post_id"));
				dto.setMember_id(rs.getInt("member_id"));
				dto.setRestaurant_id(rs.getInt("restaurant_id"));
				dto.setTitle(rs.getString("title"));
				dto.setContent(rs.getString("content"));
				dto.setView_cnt(rs.getInt("view_cnt"));
				dto.setLike_cnt(rs.getInt("like_cnt"));
				dto.setBookmark_cnt(rs.getInt("bookmark_cnt"));
				dto.setReg_date(rs.getDate("reg_date"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return dto;	
	}
	
	// 가게 정보 조회
	public RestaurantInfoDTO getRestaurantInfo(int restaurant_id) {
		RestaurantInfoDTO dto=null;
		
		Connection conn=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql="select * from restaurant_info where restaurant_id=?";
		
		try {
			conn = matDBUtil.getConn();
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, restaurant_id);
			rs= pstmt.executeQuery();
			
			if(rs.next()) {
				dto = new RestaurantInfoDTO();
				
				dto.setRestaurant_id(rs.getInt("restaurant_id"));
				dto.setName(rs.getString("name"));
				dto.setZipcode(rs.getString("zipcode"));
				dto.setAddress1(rs.getString("address1"));
				dto.setAddress2(rs.getString("address2"));
				dto.setPhone(rs.getString("phone"));
				dto.setTime(rs.getString("time"));
				dto.setMenu(rs.getString("menu"));
				dto.setLatitude(rs.getDouble("latitude"));
				dto.setLongitude(rs.getDouble("longitude"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return dto;
	}
	
	// 이미지 목록 조회
	public ArrayList<RestaurantImageDTO> getImageList(int post_id){
		ArrayList<RestaurantImageDTO> list= new ArrayList<RestaurantImageDTO>();
		
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		String sql="select * from restaurant_image where post_id = ? order by image_order";
		
		try {
			conn = matDBUtil.getConn();
			pstmt=conn.prepareStatement(sql);
			pstmt.setInt(1, post_id);
			rs= pstmt.executeQuery();
			
			while(rs.next()) {
				RestaurantImageDTO dto = new RestaurantImageDTO();
				
				dto.setImage_id(rs.getInt("image_id"));
				dto.setPost_id(rs.getInt("post_id"));
				dto.setFile_name(rs.getString("file_name"));
				dto.setIs_thumbnail(rs.getString("is_thumbnail"));
				dto.setImage_order(rs.getInt("image_order"));
				
				list.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return list;
	}
	
	// 태그 목록 조회
	public ArrayList<String> getTagList(int postId) {
	    ArrayList<String> list = new ArrayList<String>();

	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;

	    String sql =
	        "select t.tag_name " +
	        "from restaurant_post_tag rpt, tag t " +
	        "where rpt.tag_id = t.tag_id " +
	        "and rpt.post_id = ?";

	    try {
	        conn = matDBUtil.getConn();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, postId);
	        rs = pstmt.executeQuery();

	        while(rs.next()) {
	            list.add(rs.getString("tag_name"));
	        }
	    } catch(Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn, pstmt, rs);
	    }
	    return list;
	}
	
	// 조회수 증가
	public void updateViewCnt(int post_id) {
		Connection conn = null;
		PreparedStatement pstmt = null;

		String sql =
			"update restaurant_post "
		  + "set view_cnt = view_cnt + 1 "
		  + "where post_id = ? and delete_yn = 'N'";

		try {
			conn = matDBUtil.getConn();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, post_id);
			pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, null);
		}
	}
	
	// 식당 정보 업로드 삭제 (전체 삭제)
	public int deleteRestaurant(int post_id) {

	    int result = 0;

	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    String sql = "update restaurant_post set delete_yn='Y' where post_id=?";

	    try {
	        conn = matDBUtil.getConn();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, post_id);

	        result = pstmt.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn, pstmt, null);
	    }

	    return result;
	}
	
	// 텍스트 수정 (게시글 정보 테이블 업데이트)
	public int updateRestaurantPost(RestaurantDTO postDto) {
		int result=0;
		Connection conn = null;
		PreparedStatement pstmt=null;
		String sql= "update restaurant_post set title=?, content=? where post_id=?";
		
		try {
			conn = matDBUtil.getConn();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, postDto.getTitle());
			pstmt.setString(2, postDto.getContent());
			pstmt.setInt(3, postDto.getPost_id());
			
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, null);
		}
		return result;
	}
	
	// 텍스트 데이터 수정 (식당 상세 정보 테이블 업데이트)
	public int updateRestaurantInfo(RestaurantInfoDTO infoDto) {
		int result=0;
		Connection conn =null;
		PreparedStatement pstmt =null;
		String sql = "update restaurant_info set name = ?, zipcode = ?, address1 = ?, address2 = ?, "
	               + "phone = ?, time = ?, menu = ? where restaurant_id = ?";
		
		try {
			conn = matDBUtil.getConn();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, infoDto.getName());
			pstmt.setString(2, infoDto.getZipcode());
			pstmt.setString(3, infoDto.getAddress1());
			pstmt.setString(4, infoDto.getAddress2());
			pstmt.setString(5, infoDto.getPhone());
			pstmt.setString(6, infoDto.getTime());
			pstmt.setString(7, infoDto.getMenu());
			pstmt.setInt(8, infoDto.getRestaurant_id());
			
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, null);
		}
		return result;	
	}
	
	//  대소문자 매칭 수정 (getImagebyImageId -> getImageByImageId)
	public RestaurantImageDTO getImageByImageId(int image_id) {
		RestaurantImageDTO dto = null;
		Connection conn =null;
		PreparedStatement pstmt=null;
		ResultSet rs =null;
		String sql ="select * from restaurant_image where image_id=?";
		
		try {
			conn = matDBUtil.getConn();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, image_id);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				dto = new RestaurantImageDTO();
				dto.setImage_id(rs.getInt("image_id"));
				dto.setPost_id(rs.getInt("post_id"));
				dto.setFile_name(rs.getString("file_name"));
				dto.setIs_thumbnail(rs.getString("is_thumbnail"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
		return dto;	
	}
	
	//  이미지 삭제
	public int deleteImageByImageId(int image_id) {
		int result=0;
		Connection conn =null;
		PreparedStatement pstmt = null;
		String sql="delete from restaurant_image where image_id=?";
		
		try {
			conn = matDBUtil.getConn();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, image_id);
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, null);
		}
		return result;
	}
	
	// 이미지 수정 (썸네일 삭제 및 물리파일 파쇄)
	public void deleteThumbnailByPostId(int post_id, String savePath) {
		Connection conn =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		String sql_select="select file_name from restaurant_image where post_id=? and is_thumbnail='Y'";
		String sql_delete="delete from restaurant_image where post_id=? and is_thumbnail ='Y'";
		
		try {
			conn = matDBUtil.getConn();
			
			pstmt = conn.prepareStatement(sql_select);
			pstmt.setInt(1, post_id);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				String fileName = rs.getString("file_name");
				if(fileName != null && !fileName.equals("")) {
					java.io.File file = new java.io.File(savePath + java.io.File.separator + fileName);
					if(file.exists()) {
						file.delete();
					}
				}
			} 
			if (pstmt != null) pstmt.close();
			
			pstmt = conn.prepareStatement(sql_delete);
			pstmt.setInt(1, post_id);
			pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, rs);
		}
	}
	
	// 새로운 이미지 등록 (자원 반납 finally 추가 및 시퀀스명 확인)
	// 기존 insertImage와 달리 수정화면에서는 이미지 순서(image_order)가 필수가 아니므로 이 메서드를 씁니다.
	public int insertRestaurantImage(RestaurantImageDTO imgDto) {
		int result =0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		// 시퀀스명을 프로젝트에 쓰이는 restaurant_image_seq.nextval로 일치시켰어!
		String sql ="insert into restaurant_image (image_id, post_id, file_name, is_thumbnail, image_order) "
	               + "values (restaurant_image_seq.nextval, ?, ?, ?, 0)";
		
		try {
			conn = matDBUtil.getConn();
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, imgDto.getPost_id());
			pstmt.setString(2, imgDto.getFile_name());
			pstmt.setString(3, imgDto.getIs_thumbnail());
			
			result = pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			matDBUtil.close(conn, pstmt, null);
		}
		return result;
	}
	
	// 맛집 게시글 목록 조회
	// ==========================================
		// 4. 맛집 목록 조회 (페이징, 최신순 정렬, 주소 JOIN + HashMap 반환)
		// ==========================================
	public ArrayList<HashMap<String, Object>> getRestaurantList(int startRow, int endRow, String category, String sort, String keyword, int loginMemberId) {
	    ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	    
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    // 1. [안전 장치] 카테고리 컬럼명이 불확실하다면, 우선 category 분기를 비워두거나 실제 컬럼명 확인 후 적용하세요.
	    String categoryWhere = "";
	    // 만약 카테고리 컬럼명을 확실히 안다면 아래 주석을 풀고 "i.컬럼명"으로 고치세요.
	    /*
	    if (category != null && !category.equals("all")) {
	        categoryWhere = " WHERE i.category = ? "; 
	    }
	    */
	    
	    // 💡 [추가] 검색어 조건 분기
	    String keywordWhere = "";
	    if (keyword != null && !keyword.trim().isEmpty()) {
	        keywordWhere = " AND p.search_text LIKE '%' || ? || '%' ";
	    }
	    
	    
	    // 2. 정렬 조건 분기 (기존 테이블에 있는 컬럼 기준)
	    String orderByClause = " ORDER BY p.post_id DESC "; // 기본값
	    if (sort != null) {
	        if (sort.equals("like")) {
	            orderByClause = " ORDER BY p.like_cnt DESC, p.post_id DESC ";
	        } else if (sort.equals("bookmark")) {
	            orderByClause = " ORDER BY p.bookmark_cnt DESC, p.post_id DESC ";
	        } else if (sort.equals("view")) {
	            orderByClause = " ORDER BY p.view_cnt DESC, p.post_id DESC ";
	        }
	    }
	    
	    // 3. 질문자님의 원본 쿼리 구조 그대로 유지 + 동적 조건 결합
	    String sql = "SELECT * FROM ("
	               + "    SELECT rownum AS rnum, a.* FROM ("
	               + "        SELECT p.*, i.address1, i.address2, i.name AS r_name, img.image_id, img.file_name, img.is_thumbnail, "
	               + "               (SELECT COUNT(*) FROM restaurant_post_like WHERE post_id = p.post_id AND member_id = ?) AS is_liked_user, "
	               + "               (SELECT COUNT(*) FROM restaurant_bookmark WHERE post_id = p.post_id AND member_id = ?) AS is_bookmarked_user "
	               + "        FROM restaurant_post p "
	               + "        JOIN restaurant_info i ON p.restaurant_id = i.restaurant_id "
	               + "        LEFT JOIN restaurant_image img ON p.post_id = img.post_id AND img.is_thumbnail = 'Y' "
	               + "        WHERE p.delete_yn = 'N' "
	               +         keywordWhere
	               +         categoryWhere
	               +         orderByClause
	               + "    ) a"
	               + ") WHERE rnum BETWEEN ? AND ?";
	    
	    try {
	        conn = matDBUtil.getConn();
	        pstmt = conn.prepareStatement(sql);
	        
	        int paramIndex = 1;
	        
	     // 💡 [추가]: 서브쿼리에 들어갈 로그인 회원 ID 세팅
	        pstmt.setInt(paramIndex++, loginMemberId);
	        pstmt.setInt(paramIndex++, loginMemberId);
	        
	        // 💡 [추가] 검색어가 있으면 셋팅
	        if (keyword != null && !keyword.trim().isEmpty()) {
	            pstmt.setString(paramIndex++, keyword);
	        }
	        
	        // 카테고리 주석을 풀었다면 이 부분도 주석 해제
	        /*
	        if (category != null && !category.equals("all")) {
	            pstmt.setString(paramIndex++, category);
	        }
	        */
	        
	        pstmt.setInt(paramIndex++, startRow);
	        pstmt.setInt(paramIndex++, endRow);
	        
	        rs = pstmt.executeQuery();
	        
	        while(rs.next()) {
	            RestaurantDTO dto = new RestaurantDTO();
	            dto.setPost_id(rs.getInt("post_id"));
	            dto.setMember_id(rs.getInt("member_id"));
	            dto.setRestaurant_id(rs.getInt("restaurant_id"));
	            dto.setTitle(rs.getString("title"));
	            dto.setContent(rs.getString("content"));
	            dto.setView_cnt(rs.getInt("view_cnt"));
	            dto.setLike_cnt(rs.getInt("like_cnt"));         // 원래 컬럼 값 그대로 로드
	            dto.setBookmark_cnt(rs.getInt("bookmark_cnt")); // 원래 컬럼 값 그대로 로드
	            dto.setReg_date(rs.getDate("reg_date"));
	            
	            RestaurantInfoDTO infoDto = new RestaurantInfoDTO();
	            infoDto.setRestaurant_id(rs.getInt("restaurant_id"));
	            infoDto.setAddress1(rs.getString("address1"));
	            
	            RestaurantImageDTO imgDto = null;
	            if(rs.getString("file_name") != null) {
	                imgDto = new RestaurantImageDTO();
	                imgDto.setImage_id(rs.getInt("image_id"));
	                imgDto.setPost_id(rs.getInt("post_id"));
	                imgDto.setFile_name(rs.getString("file_name"));
	                imgDto.setIs_thumbnail(rs.getString("is_thumbnail"));
	            }
	            
	            // 💡 [추가]: 카운트 결과가 0보다 크면 true(눌렀음), 0이면 false(안눌렀음) 처리
	            boolean isLiked = rs.getInt("is_liked_user") > 0;
	            boolean isBookmarked = rs.getInt("is_bookmarked_user") > 0;
	            
	            HashMap<String, Object> map = new HashMap<String, Object>();
	            map.put("post", dto);
	            map.put("info", infoDto);  
	            map.put("image", imgDto);
	            map.put("commentCount", 0); // 기본값 유지
	            
	         // 💡 [중요]: JSP 파일에서 꺼내 쓸 결과값 바인딩 보장
	            map.put("isLiked", isLiked);
	            map.put("isBookmarked", isBookmarked);
	            // 📍 자바스크립트(restaurantList.jsp)가 필요로 하는 키값 바인딩 보장
	            map.put("like_cnt", rs.getInt("like_cnt"));
	            map.put("bookmark_cnt", rs.getInt("bookmark_cnt"));
	            
	            list.add(map);
	        }
	    } catch (Exception e) {
	        e.printStackTrace(); // 💡 에러가 나면 톰캣 콘솔에 원인이 찍힙니다!
	    } finally {
	        matDBUtil.close(conn, pstmt, rs);
	    }
	    return list;
	}
	// 총 게시글 수 조회
	public int listCount(String keyword) {
	    int count = 0;
	    
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    
	    // 💡 검색어 조건 분기
	    String keywordWhere = "";
	    if (keyword != null && !keyword.trim().isEmpty()) {
	        keywordWhere = " AND p.search_text LIKE '%' || ? || '%' ";
	    }
	    
	    // getRestaurantList 내부 쿼리의 FROM 절 구조와 일치시킵니다.
	    String sql = "SELECT COUNT(*) FROM restaurant_post p "
	               + "JOIN restaurant_info i ON p.restaurant_id = i.restaurant_id "
	               + "WHERE p.delete_yn = 'N' "
	               + keywordWhere;
	               
	    try {
	        conn = matDBUtil.getConn();
	        pstmt = conn.prepareStatement(sql);
	        
	        // 💡 검색어가 있을 때만 파라미터 셋팅
	        if (keyword != null && !keyword.trim().isEmpty()) {
	            pstmt.setString(1, keyword);
	        }
	        
	        rs = pstmt.executeQuery();
	        
	        if (rs.next()) {
	            count = rs.getInt(1); // COUNT(*) 결과 가져오기
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn, pstmt, rs);
	    }
	    
	    return count;
	}
	
	public void updateLikeCount(int post_id, int amount) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;
	    String sql = "UPDATE restaurant_post SET like_cnt = like_cnt + ? WHERE post_id = ? and delete_yn = 'N'";
	    try {
	        conn = matDBUtil.getConn();
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setInt(1, amount);
	        pstmt.setInt(2, post_id);
	        pstmt.executeUpdate();
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn, pstmt, null);
	    }
	}
	
	public void updateBookmarkCount(int post_id, int amount) {
	    Connection conn = null;
	    PreparedStatement pstmt = null;

	    String sql =
	        "UPDATE restaurant_post " +
	        "SET bookmark_cnt = bookmark_cnt + ? " +
	        "WHERE post_id = ? AND delete_yn = 'N'";

	    try {
	        conn = matDBUtil.getConn();
	        pstmt = conn.prepareStatement(sql);

	        pstmt.setInt(1, amount);
	        pstmt.setInt(2, post_id);

	        pstmt.executeUpdate();

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        matDBUtil.close(conn, pstmt, null);
	    }
	}
	
	// 메인메뉴 인기글 3개 뽑기
	
	public List<Map<String, Object>> selectTop3ByView() {

	    List<Map<String, Object>> list = new ArrayList<>();

	    String sql = """
	            SELECT 
	                rp.post_id,
	                rp.member_id,
	                rp.restaurant_id,
	                rp.title,
	                rp.view_cnt,
	                rp.like_cnt,
	                rp.bookmark_cnt,
	                rp.reg_date,
	                m.nickname,

	                (
	                    SELECT ri.file_name
	                    FROM restaurant_image ri
	                    WHERE ri.post_id = rp.post_id
	                    ORDER BY 
	                        CASE WHEN ri.is_thumbnail = 'Y' THEN 0 ELSE 1 END,
	                        ri.image_order ASC,
	                        ri.image_id ASC
	                    FETCH FIRST 1 ROW ONLY
	                ) AS thumbnail

	            FROM restaurant_post rp
	            LEFT JOIN member m 
	                ON rp.member_id = m.member_id
	            WHERE rp.DELETE_YN = 'N'
	            ORDER BY rp.view_cnt DESC
	            FETCH FIRST 3 ROWS ONLY
	        """;

	    try (Connection conn = matDBUtil.getConn();
	         PreparedStatement ps = conn.prepareStatement(sql);
	         ResultSet rs = ps.executeQuery()) {

	        while (rs.next()) {
	            // DTO 대신 Map을 생성해서 결과를 매핑
	            Map<String, Object> map = new HashMap<>();

	            map.put("post_id", rs.getInt("post_id"));
	            map.put("member_id", rs.getInt("member_id"));
	            map.put("restaurant_id", rs.getInt("restaurant_id"));
	            map.put("title", rs.getString("title"));
	            map.put("view_cnt", rs.getInt("view_cnt"));
	            map.put("like_cnt", rs.getInt("like_cnt"));
	            map.put("bookmark_cnt", rs.getInt("bookmark_cnt"));
	            map.put("reg_date", rs.getDate("reg_date"));
	            
	            // DTO 수정 없이 닉네임과 썸네일을 그대로 추가
	            map.put("nickname", rs.getString("nickname"));
	            map.put("thumbnail", rs.getString("thumbnail"));

	            list.add(map);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return list;
	}
}