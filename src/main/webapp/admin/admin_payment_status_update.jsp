<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="../dbConnection.jsp" %>
<%@ page import="java.sql.*" %>

<%
    // 檢查是否為管理員
    String userEmail = (String) session.getAttribute("userEmail");
    if (!"admin@example.com".equals(userEmail)) {
        response.sendRedirect("../member.jsp");
        return;
    }

    // 獲取表單數據
    String orderIdStr = request.getParameter("order_id");
    String newPaymentStatus = request.getParameter("payment_status");

    // 驗證數據
    if (orderIdStr == null || newPaymentStatus == null) {
        response.sendRedirect("admin_order_list.jsp?error=invalid_data");
        return;
    }

    int orderId;
    try {
        orderId = Integer.parseInt(orderIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("admin_order_list.jsp?error=invalid_order_id");
        return;
    }

    // 驗證付款狀態
    if (!newPaymentStatus.equals("未付款") && !newPaymentStatus.equals("已付款") && !newPaymentStatus.equals("已退款")) {
        response.sendRedirect("admin_order_detail.jsp?order_id=" + orderId + "&error=invalid_status");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = getConnection();

        // 先檢查當前付款狀態
        String checkSql = "SELECT payment_status FROM orders WHERE order_id = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setInt(1, orderId);
        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            String currentStatus = rs.getString("payment_status");
            
            // 如果狀態相同，不需要更新
            if (currentStatus.equals(newPaymentStatus)) {
                response.sendRedirect("admin_order_detail.jsp?order_id=" + orderId + "&msg=no_change");
                return;
            }

            // 更新付款狀態
            String updateSql = "UPDATE orders SET payment_status = ? WHERE order_id = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setString(1, newPaymentStatus);
            pstmt.setInt(2, orderId);
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                response.sendRedirect("admin_order_detail.jsp?order_id=" + orderId + "&msg=success");
            } else {
                response.sendRedirect("admin_order_detail.jsp?order_id=" + orderId + "&error=update_failed");
            }
        } else {
            response.sendRedirect("admin_order_detail.jsp?order_id=" + orderId + "&error=order_not_found");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("admin_order_detail.jsp?order_id=" + orderId + "&error=system_error");
    } finally {
        closeResources(conn, pstmt, null);
    }
%> 