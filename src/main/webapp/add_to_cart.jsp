<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>

<%
    // 檢查用戶是否已登入
    Integer memberId = (Integer) session.getAttribute("memberId");
    if (memberId == null) {
        response.sendRedirect("member.jsp?redirect=cart.jsp");
        return;
    }

    String productIdStr = request.getParameter("product_id");
    String quantityStr = request.getParameter("quantity");
    
    if (productIdStr == null || quantityStr == null) {
        response.sendRedirect("card.jsp?msg=" + java.net.URLEncoder.encode("❌ 商品資訊不完整", "UTF-8"));
        return;
    }

    int productId = 0;
    int quantity = 1;
    
    try {
        productId = Integer.parseInt(productIdStr);
        quantity = Integer.parseInt(quantityStr);
        if (quantity <= 0) quantity = 1;
    } catch (NumberFormatException e) {
        response.sendRedirect("card.jsp?msg=" + java.net.URLEncoder.encode("❌ 商品參數格式錯誤", "UTF-8"));
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    // 檢查資料庫連接
    boolean dbAvailable = isDatabaseAvailable();
    if (!dbAvailable) {
        response.sendRedirect("card.jsp?msg=" + java.net.URLEncoder.encode("❌ 資料庫連接失敗，請稍後再試", "UTF-8"));
        return;
    }
    
    try {
        conn = getConnection();
        
        // 檢查商品是否存在且有庫存
        String checkSql = "SELECT product_name, stock, price FROM product WHERE product_id = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setInt(1, productId);
        rs = pstmt.executeQuery();
        
        if (!rs.next()) {
            response.sendRedirect("card.jsp?msg=" + java.net.URLEncoder.encode("❌ 商品不存在或已下架", "UTF-8"));
            return;
        }
        
        String productName = rs.getString("product_name");
        int availableStock = rs.getInt("stock");
        double price = rs.getDouble("price");
        
        if (availableStock < quantity) {
            response.sendRedirect("card.jsp?msg=" + java.net.URLEncoder.encode("❌ 庫存不足！「" + productName + "」目前庫存：" + availableStock + " 張", "UTF-8"));
            return;
        }
        
        rs.close();
        pstmt.close();
        
        // 檢查是否已在購物車中
        String cartCheckSql = "SELECT quantity FROM cart_item WHERE member_id = ? AND product_id = ?";
        pstmt = conn.prepareStatement(cartCheckSql);
        pstmt.setInt(1, memberId);
        pstmt.setInt(2, productId);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            // 商品已在購物車，增加數量
            int existingQuantity = rs.getInt("quantity");
            int newQuantity = existingQuantity + quantity;
            
            if (newQuantity > availableStock) {
                response.sendRedirect("card.jsp?msg=" + java.net.URLEncoder.encode("❌ 購物車數量 + 欲加入數量超過庫存！「" + productName + "」目前庫存：" + availableStock + " 張", "UTF-8"));
                return;
            }
            
            rs.close();
            pstmt.close();
            
            String updateSql = "UPDATE cart_item SET quantity = ?, updated_at = NOW() WHERE member_id = ? AND product_id = ?";
            pstmt = conn.prepareStatement(updateSql);
            pstmt.setInt(1, newQuantity);
            pstmt.setInt(2, memberId);
            pstmt.setInt(3, productId);
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                response.sendRedirect("cart.jsp?msg=" + java.net.URLEncoder.encode("✅ 已更新購物車中的「" + productName + "」數量為 " + newQuantity + " 張", "UTF-8"));
            } else {
                response.sendRedirect("card.jsp?msg=" + java.net.URLEncoder.encode("❌ 更新購物車失敗", "UTF-8"));
            }
        } else {
            // 新增到購物車
            rs.close();
            pstmt.close();
            
            String insertSql = "INSERT INTO cart_item (member_id, product_id, quantity, created_at) VALUES (?, ?, ?, NOW())";
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setInt(1, memberId);
            pstmt.setInt(2, productId);
            pstmt.setInt(3, quantity);
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                response.sendRedirect("cart.jsp?msg=" + java.net.URLEncoder.encode("✅ 「" + productName + "」已成功加入購物車", "UTF-8"));
            } else {
                response.sendRedirect("card.jsp?msg=" + java.net.URLEncoder.encode("❌ 加入購物車失敗", "UTF-8"));
            }
        }
        
    } catch (Exception e) {
        System.err.println("Add to cart error: " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect("card.jsp?msg=" + java.net.URLEncoder.encode("❌ 加入購物車時發生錯誤，請稍後再試", "UTF-8"));
    } finally {
        closeResources(conn, pstmt, rs);
    }
%> 