<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%
    // 檢查是否已登入
    Integer memberId = (Integer) session.getAttribute("memberId");
    if (memberId == null) {
        response.sendRedirect("member.jsp");
        return;
    }

    String action = request.getParameter("action");
    String message = "";
    String messageType = "success";

    if ("update_profile".equals(action)) {
        // 更新會員基本資料
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            String sql = "UPDATE member SET email = ?, phone = ?, address = ? WHERE member_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            pstmt.setString(2, phone);
            pstmt.setString(3, address);
            pstmt.setInt(4, memberId);
            
            int updated = pstmt.executeUpdate();
            if (updated > 0) {
                message = "個人資料更新成功！";
                messageType = "success";
            } else {
                message = "更新失敗，請稍後再試。";
                messageType = "error";
            }
        } catch (Exception e) {
            message = "更新失敗：" + e.getMessage();
            messageType = "error";
        } finally {
            closeResources(conn, pstmt, null);
        }
    } else if ("update_avatar".equals(action)) {
        // 更新會員頭像
        String avatar = request.getParameter("avatar");
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            String sql = "UPDATE member SET avatar = ? WHERE member_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, avatar);
            pstmt.setInt(2, memberId);
            
            int updated = pstmt.executeUpdate();
            if (updated > 0) {
                message = "頭像更新成功！";
                messageType = "success";
            } else {
                message = "頭像更新失敗，請稍後再試。";
                messageType = "error";
            }
        } catch (Exception e) {
            message = "頭像更新失敗：" + e.getMessage();
            messageType = "error";
        } finally {
            closeResources(conn, pstmt, null);
        }
    } else if ("change_password".equals(action)) {
        // 修改密碼
        String currentPassword = request.getParameter("current_password");
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");
        
        if (!newPassword.equals(confirmPassword)) {
            message = "新密碼與確認密碼不符！";
            messageType = "error";
        } else {
            Connection conn = null;
            PreparedStatement checkStmt = null;
            PreparedStatement updateStmt = null;
            ResultSet rs = null;
            
            try {
                conn = getConnection();
                
                // 先驗證當前密碼
                String checkSql = "SELECT password FROM member WHERE member_id = ?";
                checkStmt = conn.prepareStatement(checkSql);
                checkStmt.setInt(1, memberId);
                rs = checkStmt.executeQuery();
                
                if (rs.next() && rs.getString("password").equals(currentPassword)) {
                    // 更新密碼
                    String updateSql = "UPDATE member SET password = ? WHERE member_id = ?";
                    updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setString(1, newPassword);
                    updateStmt.setInt(2, memberId);
                    
                    int updated = updateStmt.executeUpdate();
                    if (updated > 0) {
                        message = "密碼修改成功！";
                        messageType = "success";
                    } else {
                        message = "密碼修改失敗，請稍後再試。";
                        messageType = "error";
                    }
                } else {
                    message = "當前密碼錯誤！";
                    messageType = "error";
                }
            } catch (Exception e) {
                message = "密碼修改失敗：" + e.getMessage();
                messageType = "error";
            } finally {
                if (rs != null) try { rs.close(); } catch (Exception e) {}
                if (checkStmt != null) try { checkStmt.close(); } catch (Exception e) {}
                if (updateStmt != null) try { updateStmt.close(); } catch (Exception e) {}
                if (conn != null) try { conn.close(); } catch (Exception e) {}
            }
        }
    }

    // 重定向回會員專區並帶上訊息
    session.setAttribute("update_message", message);
    session.setAttribute("update_message_type", messageType);
    response.sendRedirect("member_area.jsp");
%> 