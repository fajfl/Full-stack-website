<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="../dbConnection.jsp" %>
<%@ page import="java.sql.*" %>

<%
    // 權限檢查：只有管理員才能訪問此頁面
    String memberLevel = (String) session.getAttribute("memberLevel");
    if (memberLevel == null || !"管理員".equals(memberLevel)) {
        response.sendRedirect("../index.jsp");
        return;
    }

    String productId = request.getParameter("product_id");
    String newStatus = request.getParameter("status");
    String message = "";
    String messageType = "error";

    if (productId != null && !productId.trim().isEmpty() && 
        newStatus != null && !newStatus.trim().isEmpty()) {
        
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = getConnection();
            
            // 更新商品狀態
            String updateSql = "UPDATE product SET status = ? WHERE product_id = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, Integer.parseInt(productId));
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                message = "商品狀態更新成功！";
                messageType = "success";
            } else {
                message = "商品狀態更新失敗，請重試。";
            }
            
        } catch (Exception e) {
            message = "更新商品狀態時發生錯誤: " + e.getMessage();
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, null);
        }
    } else {
        message = "無效的商品ID或狀態。";
    }
    
    // 重定向回商品列表頁面，並帶上訊息
    response.sendRedirect("admin_products.jsp?msg=" + java.net.URLEncoder.encode(message, "UTF-8") + "&msgType=" + messageType);
%> 