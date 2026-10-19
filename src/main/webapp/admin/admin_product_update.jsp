<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="../dbConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>

<%
    // 權限檢查：只有管理員才能訪問此頁面
    String memberLevel = (String) session.getAttribute("memberLevel");
    if (memberLevel == null || !"管理員".equals(memberLevel)) {
        response.sendRedirect("../index.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    String message = "";
    String messageType = "error";

    try {
        // 獲取表單數據
        int productId = Integer.parseInt(request.getParameter("product_id"));
        String productName = request.getParameter("product_name");
        BigDecimal price = new BigDecimal(request.getParameter("price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String status = request.getParameter("status");
        String description = request.getParameter("description");
        
        // 更新資料庫
        conn = getConnection();
        String sql = "UPDATE product SET product_name = ?, price = ?, stock = ?, status = ?, description = ? WHERE product_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, productName);
        pstmt.setBigDecimal(2, price);
        pstmt.setInt(3, stock);
        pstmt.setString(4, status);
        pstmt.setString(5, description);
        pstmt.setInt(6, productId);
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            message = "商品更新成功！";
            messageType = "success";
        } else {
            message = "商品更新失敗，請重試。";
        }
        
    } catch (Exception e) {
        message = "更新商品時發生錯誤: " + e.getMessage();
        e.printStackTrace();
    } finally {
        closeResources(conn, pstmt, null);
    }
    
    // 重定向回商品列表頁面，並帶上訊息
    response.sendRedirect("admin_products.jsp?msg=" + java.net.URLEncoder.encode(message, "UTF-8") + "&msgType=" + messageType);
%> 