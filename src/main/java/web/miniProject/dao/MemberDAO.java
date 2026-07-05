	package web.miniProject.dao;
	
	import java.sql.Connection;
	import java.sql.PreparedStatement;
	import java.sql.ResultSet;
	import java.sql.SQLException;
	import java.util.ArrayList;
	import java.util.List;
	
	import web.miniProject.dto.MemberDTO;
	import web.miniProject.util.matDBUtil;
	
	public class MemberDAO {
	
		private Connection conn = null;
		private PreparedStatement pstmt = null;
		private ResultSet rs = null;
		private String sql = null;
		
		// 회원 가입 (INSERT)
		public int insertMember(MemberDTO dto) {
			int result = 0;

		    try {
			     conn = matDBUtil.getConn();
			     sql =
                         "INSERT INTO member ( " +
                         "    member_id, " +
                         "    id, pw, name, nickname, birth, email, " +
                         "    zipcode, address1, address2, " +
                         "    telecom, phone, gender, " +
                         "    reviewer_yn, reviewer_url, role, reg_date " +
                         ") VALUES ( " +
                         "    member_seq.NEXTVAL, " +
                         "    ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSDATE " +
                         ")";

			     pstmt = conn.prepareStatement(sql);

			     pstmt.setString(1, dto.getId());
			     pstmt.setString(2, dto.getPw());
			     pstmt.setString(3, dto.getName());
			     pstmt.setString(4, dto.getNickname());
			     pstmt.setString(5, dto.getBirth());
			     pstmt.setString(6, dto.getEmail());

			     pstmt.setString(7, dto.getZipcode());
			     pstmt.setString(8, dto.getAddress1());
			     pstmt.setString(9, dto.getAddress2());

			     pstmt.setString(10, dto.getTelecom());
			     pstmt.setString(11, dto.getPhone());

			     // 성별
			     pstmt.setString(12, dto.getGender());

		        // 기본값
			     // 회원가입 시 평가단 가입X -> 체크박스 미표시 -> 'N'
			     // 회원가입 시 평가단 가입 -> 체크박스 표시 -> 'S' (대기표시. 관리자에게 전달)
			     pstmt.setString(13,dto.getReviewer_yn() != "N"? "S" : "N");
			     pstmt.setString(14, dto.getReviewer_url());
                 pstmt.setString(15, dto.getRole() != null? dto.getRole(): "USER");
 
			     result = pstmt.executeUpdate();
			     System.out.println("insertMember() : result : " + result);

		    } catch (Exception e) {
		    	e.printStackTrace();
		    } finally {
		    	matDBUtil.close(conn, pstmt, rs);
		    }
		    return result;
		}
		
		// 아이디 중복체크
		public boolean checkDuplicateId(String id) {

		    boolean result = false;

		    try {
		        conn = matDBUtil.getConn();

		        sql = "SELECT COUNT(*) FROM member WHERE id = ?";

		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, id);

		        rs = pstmt.executeQuery();

		        if (rs.next()) {
		            result = rs.getInt(1) > 0;
		        }

		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        matDBUtil.close(conn, pstmt, rs);
		    }

		    return result;
		}
		
		// 닉네임 중복체크
		public boolean checkDuplicateNickname(String nickname) {

		    boolean result = false;

		    try {
		        conn = matDBUtil.getConn();

		        sql = "SELECT COUNT(*) FROM member WHERE nickname = ?";

		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, nickname);

		        rs = pstmt.executeQuery();

		        if (rs.next()) {
		            result = rs.getInt(1) > 0;
		        }

		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        matDBUtil.close(conn, pstmt, rs);
		    }

		    return result;
		}
		
		// 로그인 (id/pw 일치 → 로그인 성공, id/pw 불일치 → 로그인 실패)
		public MemberDTO loginCheck(MemberDTO dto){
			
			MemberDTO member = null;
			// 입력값 검증 (아이디나 비밀번호가 없으면 DB까지 안가고 종료)
			if (dto == null || dto.getId() == null || dto.getPw() == null) {
		        return null;
		    }
	
			try {
	              conn = matDBUtil.getConn();
	           // 필요한 컬럼만 명시 
	              sql = "SELECT member_id, id, pw, name, nickname, birth, email, zipcode, " +
	                    "address1, address2, telecom, phone, gender, reviewer_yn, reviewer_url, role " +
	                    "FROM member WHERE id = ?";
	              
	              pstmt = conn.prepareStatement(sql);
	              pstmt.setString(1, dto.getId());
	   
	              rs = pstmt.executeQuery();
	   
	              if (rs.next()) {
	   
	                  // DB 비밀번호
	                  String dbPw = rs.getString("pw");
	   
	                  // 비밀번호 비교
	                  if (dbPw != null && dbPw.equals(dto.getPw())) {
	                      member = new MemberDTO();
	                      member.setMember_id(rs.getInt("member_id"));
	                      member.setId(rs.getString("id"));
	                      member.setName(rs.getString("name"));
	                      member.setNickname(rs.getString("nickname"));
	                      member.setBirth(rs.getString("birth"));
	                      member.setEmail(rs.getString("email"));
	                      member.setZipcode(rs.getString("zipcode"));
	                      member.setAddress1(rs.getString("address1"));
	                      member.setAddress2(rs.getString("address2"));
	                      member.setTelecom(rs.getString("telecom"));
	                      member.setPhone(rs.getString("phone"));
	                      member.setGender(rs.getString("gender"));
	                      member.setReviewer_yn(rs.getString("reviewer_yn"));
	                      member.setReviewer_url(rs.getString("reviewer_url"));
	                      member.setRole(rs.getString("role"));
	                      
	                      // 2. reviewer_yn 기본값 처리 적용 ("Y"/"N" 중 기본값 세팅)
	                      String reviewerYn = rs.getString("reviewer_yn");
	                      member.setReviewer_yn(reviewerYn == null ? "N" : reviewerYn);
	                  }
	              }
	   
	          } catch (Exception e) {
	              e.printStackTrace();
	   
	          } finally {
	             matDBUtil.close(conn, pstmt, rs);
	          }
	   
			return member;
		}
		
	
		 // 아이디 찾기 (이름 + 이메일)
		// 공백 대소문자 처리
		public String findId(String name, String email) {
	
		    String id = null;
	
		    try {
		        conn = matDBUtil.getConn();
	
		        String sql = "SELECT id FROM member WHERE TRIM(name) = TRIM(?) AND LOWER(email) = LOWER(?)";
	
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, name);
		        pstmt.setString(2, email);
	
		        rs = pstmt.executeQuery();
	
		        if (rs.next()) {
		            id = rs.getString("id");
		        }
	
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        matDBUtil.close(conn, pstmt, rs);
		    }
	
		    return id;
		}
	
		// 비밀번호 찾기 아이디 이름 이메일
		public String findPassword(String id, String name, String email) {

		    String password = null;

		    try {
		        conn = matDBUtil.getConn();

		        String sql =
		            "SELECT PW FROM member " +
		            "WHERE TRIM(id) = TRIM(?) " +
		            "AND TRIM(name) = TRIM(?) " +
		            "AND LOWER(TRIM(email)) = LOWER(TRIM(?))";

		        pstmt = conn.prepareStatement(sql);

		        pstmt.setString(1, id == null ? "" : id.trim());
		        pstmt.setString(2, name == null ? "" : name.trim());
		        pstmt.setString(3, email == null ? "" : email.trim());

		        rs = pstmt.executeQuery();

		        if (rs.next()) {
		            password = rs.getString("PW");
		        }

		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        matDBUtil.close(conn, pstmt, rs);
		    }

		    return password;
		}
		
		// 회원 탈퇴 (DELETE)
		public boolean deleteMember(String id, String pw) {
			boolean result = false;

			try {
				conn = matDBUtil.getConn();

				// id와 pw가 모두 일치하는 행만 삭제
				sql = "DELETE FROM member WHERE id = ? AND pw = ?";

				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, id);
				pstmt.setString(2, pw);
				
				// executeUpdate()는 영향을 받은 행의 개수를 반환합니다 (성공 시 1)
				int count = pstmt.executeUpdate();
				System.out.println("count:"+count);
				if (count > 0) {
					result = true; // 삭제 성공
				}

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				matDBUtil.close(conn, pstmt, rs);
			}

			return result;
		}

		/*	    비밀번호 이메일 찾기 할 때 필요한 부분 jar 다운 2개 필요함
		1. 회원 존재 확인 (비밀번호 재설정용)

	    public int checkMemberForReset(String id, String name, String email) {
	
	        int memberId = -1;
	
	        try {
	            conn = matDBUtil.getConn();
	
	            String sql =
	            "SELECT member_id FROM member WHERE id = ? AND name = ? AND email = ?";
	
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, id);
	            pstmt.setString(2, name);
	            pstmt.setString(3, email);
	
	            rs = pstmt.executeQuery();
	
	            if (rs.next()) {
	                memberId = rs.getInt("member_id");
	            }
	
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            matDBUtil.close(conn, pstmt, rs);
	        }
	
	        return memberId;
	    }
	

	    


	   //2. reset token 저장 (ORACLE 수정 완료)

	    public void saveResetToken(int memberId, String token) {
	
	        try {
	            conn = matDBUtil.getConn();
	
	            String sql =
	            "UPDATE member " +
	            "SET reset_token = ?, " +
	            "reset_token_exp = SYSDATE + (10/1440) " +   // 10분
	            "WHERE member_id = ?";
	
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, token);
	            pstmt.setInt(2, memberId);
	
	            pstmt.executeUpdate();
	
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            matDBUtil.close(conn, pstmt, null);
	        }
	    }
	
	
	    //3. token으로 회원 찾기 (ORACLE 수정 완료)
	    public int findMemberByToken(String token) {
	
	        int memberId = -1;
	
	        try {
	            conn = matDBUtil.getConn();
	
	            String sql =
	            "SELECT member_id " +
	            "FROM member " +
	            "WHERE reset_token = ? " +
	            "AND reset_token_exp > SYSDATE";
	
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, token);
	
	            rs = pstmt.executeQuery();
	
	            if (rs.next()) {
	                memberId = rs.getInt("member_id");
	            }
	
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            matDBUtil.close(conn, pstmt, rs);
	        }
	
	        return memberId;
	    }
	
	
	   
	   //4. 비밀번호 변경 + 토큰 삭제
	    
	    public int updatePasswordAndClearToken(int memberId, String newPw) {
	
	        int result = 0;
	
	        try {
	            conn = matDBUtil.getConn();
	
	            String sql =
	            "UPDATE member " +
	            "SET pw = ?, " +
	            "reset_token = NULL, " +
	            "reset_token_exp = NULL " +
	            "WHERE member_id = ?";
	
	            pstmt = conn.prepareStatement(sql);
	            pstmt.setString(1, newPw);
	            pstmt.setInt(2, memberId);
	
	            result = pstmt.executeUpdate();
	
	        } catch (Exception e) {
	            e.printStackTrace();
	        } finally {
	            matDBUtil.close(conn, pstmt, null);
	        }
	
	        return result;
	    }
	    
	   
*/	    
		// 6/12 종찬 추가
		// 닉네임 중복체크 - 마이페이지
		public boolean checkDuplicateNickname_mypage(String nickname, String id) {

		    boolean result = false;

		    try {
		        conn = matDBUtil.getConn();

		        sql = "SELECT COUNT(*) FROM member WHERE nickname = ? and id = ?";

		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, nickname);
		        pstmt.setString(2, id);
		        rs = pstmt.executeQuery();

		        if (rs.next()) {
		            result = rs.getInt(1) > 0;
		        }

		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        matDBUtil.close(conn, pstmt, rs);
		    }

		    return result;
		}
		
		// 6/15 종찬 추가
		// 회원정보 수정(1. 비밀번호 재검증 -> 2. 정보수정)
		public int updateMember(MemberDTO dto) {
			int result = 0;
			String dbpw = null;
			
			try {
				conn = matDBUtil.getConn();
				
				// 비밀번호 대조
				sql = "select pw from member where id=?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, dto.getId());
				rs = pstmt.executeQuery();
				if(rs.next()) {
					dbpw = rs.getString(1);
				}
				
				// 비밀번호가 동일할 시 업데이트 진행
				if(dto.getPw().equals(dbpw)) {
					sql = 
						"update member set " +
						" nickname=?, " +
						" email=?, " +
						" zipcode=?, " +
						" address1=?, " +
						" address2=?, " +
						" telecom=?, " +
						" phone=?, " +
						" reviewer_yn=?, " +
						" reviewer_url=? " +
						" where id=?";

					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, dto.getNickname());
					pstmt.setString(2, dto.getEmail());
					pstmt.setString(3, dto.getZipcode());
					pstmt.setString(4, dto.getAddress1());
					pstmt.setString(5, dto.getAddress2());
					pstmt.setString(6, dto.getTelecom());
					pstmt.setString(7, dto.getPhone());
					if(dto.getReviewer_yn() == null) {
						dto.setReviewer_yn("N");
					}
					pstmt.setString(8, dto.getReviewer_yn());
					pstmt.setString(9, dto.getReviewer_url());
					pstmt.setString(10, dto.getId());
					result = pstmt.executeUpdate();
				}			
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				matDBUtil.close(conn, pstmt, rs);
			}
			return result;
		} 
		
		// 관리자페이지 - 전체 회원 목록 조회 (검색 기능 포함)
		public List<MemberDTO> getMemberList(String searchKeyword) {
			List<MemberDTO> list = new ArrayList<>();
			
			try {
				conn = matDBUtil.getConn();
				
				// 검색어가 없을 때와 있을 때 분기 처리
				if(searchKeyword == null || searchKeyword.trim().equals("")) {
					sql = "SELECT * FROM member ORDER BY member_id DESC";
					pstmt = conn.prepareStatement(sql);
				} else {
					sql = "SELECT * FROM member WHERE id LIKE ? OR name LIKE ? ORDER BY member_id DESC";
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, "%" + searchKeyword + "%");
					pstmt.setString(2, "%" + searchKeyword + "%");
				}
				
				rs = pstmt.executeQuery();
				
				while(rs.next()) {
					MemberDTO dto = new MemberDTO();
					dto.setMember_id(rs.getInt("member_id"));
					dto.setId(rs.getString("id"));
					dto.setName(rs.getString("name"));
					dto.setEmail(rs.getString("email"));
					dto.setReg_date(rs.getTimestamp("reg_date"));
					// 필요한 다른 필드가 있다면 여기에 추가 선언 가능합니다.
					
					list.add(dto);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				matDBUtil.close(conn, pstmt, rs);
			}
			
			return list;
		}
		
		// 관리자 기능 - 회원 강제 추방 (아이디로 삭제)
		public boolean kickMember(String id) {
		    boolean result = false;
		    try {
		        conn = matDBUtil.getConn();
		        sql = "DELETE FROM member WHERE id = ?";
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, id);
		        
		        int count = pstmt.executeUpdate();
		        if (count > 0) {
		            result = true; 
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        matDBUtil.close(conn, pstmt, rs);
		    }
		    return result;
		}
		
		// 1. 평가단 신청을 한 사람(reviewer_yn = 'S')만 골라오는 메서드
		public List<MemberDTO> getReviewerApplyList(String searchKeyword) {
		    List<MemberDTO> list = new ArrayList<>();
		    try {
		        conn = matDBUtil.getConn();
		        
		        // 중요: reviewer_yn 값이 's'(신청함)인 회원만 조회합니다.
		        sql = "SELECT * FROM member WHERE reviewer_yn = 'S' AND (id LIKE ? OR name LIKE ?) ORDER BY reg_date DESC";
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, "%" + searchKeyword + "%");
		        pstmt.setString(2, "%" + searchKeyword + "%");
		        rs = pstmt.executeQuery();
		        
		        while (rs.next()) {
		            MemberDTO member = new MemberDTO();
		            member.setMember_id(rs.getInt("member_id"));
		            member.setId(rs.getString("id"));
		            member.setName(rs.getString("name"));
		            member.setReviewer_yn(rs.getString("reviewer_yn"));
		            member.setReg_date(rs.getTimestamp("reg_date"));
		            list.add(member);
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        matDBUtil.close(conn, pstmt, rs);
		    }
		    return list;
		}

		// 2. 승인 / 거절 처리 메서드
		public boolean updateReviewerStatus(String id, String type) {
		    boolean result = false;
		    try {
		        conn = matDBUtil.getConn();
		        
		        if ("approve".equals(type)) {
		            // 승인 시: 최종 평가단인 대문자 'Y'로 변경합니다. (목록에서 사라짐)
		            sql = "UPDATE member SET reviewer_yn = 'Y' WHERE id = ?";
		        } else {
		            // 거절 시:'N'으로 되돌립니다. (목록에서 사라짐)
		            sql = "UPDATE member SET reviewer_yn = 'N' WHERE id = ?";
		        }
		        
		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, id);
		        
		        int count = pstmt.executeUpdate();
		        if (count > 0) {
		            result = true; 
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		    } finally {
		        matDBUtil.close(conn, pstmt, rs);
		    }
		    return result;
		}
	}
		
		
