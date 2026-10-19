<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="../dbConnection.jsp" %>
<%@ page import="java.sql.*" %>

<%
    // 檢查是否為POST請求
    if (!"POST".equals(request.getMethod())) {
        response.sendRedirect("admin_order_list.jsp");
        return;
    }

    // 獲取表單數據
    String orderIdStr = request.getParameter("order_id");
    String newStatus = request.getParameter("status");
    
    // 驗證參數
    if (orderIdStr == null || newStatus == null || orderIdStr.trim().isEmpty() || newStatus.trim().isEmpty()) {
        response.sendRedirect("admin_order_list.jsp?error=invalid_params");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = getConnection();
        
        // 更新訂單狀態
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, newStatus);
        pstmt.setInt(2, Integer.parseInt(orderIdStr));
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            // 更新成功，重定向回訂單詳情頁面
            response.sendRedirect("admin_order_detail.jsp?order_id=" + orderIdStr + "&success=status_updated");
        } else {
            // 更新失敗，重定向回訂單列表
            response.sendRedirect("admin_order_list.jsp?error=update_failed");
        }
        
    } catch (Exception e) {
        // 發生錯誤，記錄錯誤並重定向
        e.printStackTrace();
        response.sendRedirect("admin_order_list.jsp?error=system_error");
    } finally {
        // 關閉資料庫連接
        closeResources(conn, pstmt, null);
    }
%> 