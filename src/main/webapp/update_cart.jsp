<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<%@ page import="java.sql.*" %>

<%
    // 檢查用戶是否已登入
    Integer memberId = (Integer) session.getAttribute("memberId");
    if (memberId == null) {
        response.sendRedirect("member.jsp?redirect=cart.jsp");
        return;
    }

    String action = request.getParameter("action");
    String productIdStr = request.getParameter("productId");
    String quantityStr = request.getParameter("quantity");

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String message = "";
    String messageType = "info";

    // 檢查資料庫連接
    boolean dbAvailable = isDatabaseAvailable();
    if (!dbAvailable) {
        response.sendRedirect("cart.jsp?msg=" + java.net.URLEncoder.encode("資料庫連接異常，無法更新購物車", "UTF-8"));
        return;
    }

    try {
        conn = getConnection();
        
        if ("remove".equals(action) && productIdStr != null) {
            // 移除商品
            int productId = Integer.parseInt(productIdStr);
            String deleteSql = "DELETE FROM cart_item WHERE member_id = ? AND product_id = ?";
            pstmt = conn.prepareStatement(deleteSql);
            pstmt.setInt(1, memberId);
            pstmt.setInt(2, productId);
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                message = "✅ 商品已成功從購物車移除";
                messageType = "success";
            } else {
                message = "❌ 移除商品失敗，商品可能已不在購物車中";
                messageType = "error";
            }
            
        } else if (("update".equals(action) || "increase".equals(action) || "decrease".equals(action)) && productIdStr != null) {
            int productId = Integer.parseInt(productIdStr);
            int newQuantity = 1;
            
            // 根據不同動作計算新數量
            if ("increase".equals(action)) {
                // 增加數量 - 先獲取當前數量
                String getCurrentQtySql = "SELECT quantity FROM cart_item WHERE member_id = ? AND product_id = ?";
                pstmt = conn.prepareStatement(getCurrentQtySql);
                pstmt.setInt(1, memberId);
                pstmt.setInt(2, productId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    newQuantity = rs.getInt("quantity") + 1;
                } else {
                    message = "❌ 商品不在購物車中";
                    messageType = "error";
                    response.sendRedirect("cart.jsp?msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
                    return;
                }
                rs.close();
                pstmt.close();
                
            } else if ("decrease".equals(action)) {
                // 減少數量 - 先獲取當前數量
                String getCurrentQtySql = "SELECT quantity FROM cart_item WHERE member_id = ? AND product_id = ?";
                pstmt = conn.prepareStatement(getCurrentQtySql);
                pstmt.setInt(1, memberId);
                pstmt.setInt(2, productId);
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    newQuantity = rs.getInt("quantity") - 1;
                    if (newQuantity <= 0) {
                        // 數量為0，移除商品
                        rs.close();
                        pstmt.close();
                        
                        String deleteSql = "DELETE FROM cart_item WHERE member_id = ? AND product_id = ?";
                        pstmt = conn.prepareStatement(deleteSql);
                        pstmt.setInt(1, memberId);
                        pstmt.setInt(2, productId);
                        pstmt.executeUpdate();
                        
                        message = "✅ 商品數量歸零，已從購物車移除";
                        messageType = "success";
                        response.sendRedirect("cart.jsp?msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
                        return;
                    }
                } else {
                    message = "❌ 商品不在購物車中";
                    messageType = "error";
                    response.sendRedirect("cart.jsp?msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
                    return;
                }
                rs.close();
                pstmt.close();
                
            } else if ("update".equals(action) && quantityStr != null) {
                // 手動輸入數量更新
                try {
                    newQuantity = Integer.parseInt(quantityStr);
                    if (newQuantity <= 0) {
                        // 數量為0，移除商品
                        String deleteSql = "DELETE FROM cart_item WHERE member_id = ? AND product_id = ?";
                        pstmt = conn.prepareStatement(deleteSql);
                        pstmt.setInt(1, memberId);
                        pstmt.setInt(2, productId);
                        pstmt.executeUpdate();
                        
                        message = "✅ 商品數量歸零，已從購物車移除";
                        messageType = "success";
                        response.sendRedirect("cart.jsp?msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
                        return;
                    }
                } catch (NumberFormatException e) {
                    message = "❌ 數量格式錯誤，請輸入有效數字";
                    messageType = "error";
                    response.sendRedirect("cart.jsp?msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
                    return;
                }
            }
            
            // 檢查庫存
            String stockCheckSql = "SELECT stock, product_name FROM product WHERE product_id = ?";
            pstmt = conn.prepareStatement(stockCheckSql);
            pstmt.setInt(1, productId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                int stock = rs.getInt("stock");
                String productName = rs.getString("product_name");
                
                if (newQuantity > stock) {
                    message = "❌ 數量超過庫存！「" + productName + "」目前庫存：" + stock + " 張";
                    messageType = "error";
                } else {
                    rs.close();
                    pstmt.close();
                    
                    // 更新數量
                    String updateSql = "UPDATE cart_item SET quantity = ?, updated_at = NOW() " +
                                     "WHERE member_id = ? AND product_id = ?";
                    pstmt = conn.prepareStatement(updateSql);
                    pstmt.setInt(1, newQuantity);
                    pstmt.setInt(2, memberId);
                    pstmt.setInt(3, productId);
                    
                    int result = pstmt.executeUpdate();
                    if (result > 0) {
                        message = "✅ 購物車已成功更新數量為 " + newQuantity;
                        messageType = "success";
                    } else {
                        message = "❌ 更新失敗，商品可能已不在購物車中";
                        messageType = "error";
                    }
                }
            } else {
                message = "❌ 商品不存在或已下架";
                messageType = "error";
            }
        } else {
            message = "❌ 操作參數錯誤";
            messageType = "error";
        }
        
    } catch (NumberFormatException e) {
        message = "❌ 商品ID格式錯誤";
        messageType = "error";
        System.err.println("Product ID format error: " + e.getMessage());
    } catch (Exception e) {
        message = "❌ 操作失敗：" + e.getMessage();
        messageType = "error";
        System.err.println("Cart update error: " + e.getMessage());
        e.printStackTrace();
    } finally {
        closeResources(conn, pstmt, rs);
    }

    // 重定向回購物車頁面
    response.sendRedirect("cart.jsp?msg=" + java.net.URLEncoder.encode(message, "UTF-8"));
%> 