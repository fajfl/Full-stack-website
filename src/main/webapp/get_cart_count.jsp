<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
    // 檢查登入狀態
    Integer memberId = (Integer) session.getAttribute("memberId");
    int cartCount = 0;
    
    if (memberId != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            if (conn != null) {
                String sql = "SELECT SUM(quantity) as total FROM cart_item WHERE member_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, memberId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    cartCount = rs.getInt("total");
                }
            }
        } catch (Exception e) {
            // 錯誤時返回0
            cartCount = 0;
        } finally {
            closeResources(conn, pstmt, rs);
        }
    }
    
    // 返回JSON格式
    out.print("{\"count\":" + cartCount + "}");
%> 