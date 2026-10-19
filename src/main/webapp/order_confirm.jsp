<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%
// 檢查登入狀態
Integer memberId = (Integer) session.getAttribute("memberId");
if (memberId == null) {
    response.sendRedirect("member.jsp");
    return;
}

// 獲取表單參數
String shippingName = request.getParameter("shipping_name");
String shippingPhone = request.getParameter("shipping_phone");
String shippingAddress = request.getParameter("shipping_address");
String orderNote = request.getParameter("order_note");
String paymentMethod = request.getParameter("payment_method");

if (shippingName == null || shippingPhone == null || shippingAddress == null || paymentMethod == null ||
    shippingName.trim().isEmpty() || shippingPhone.trim().isEmpty() || shippingAddress.trim().isEmpty()) {
    response.sendRedirect("checkout.jsp?message=" + java.net.URLEncoder.encode("請填寫完整資訊", "UTF-8") + "&type=error");
    return;
}

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;
String message = "";
String messageType = "error";

try {
    conn = getConnection();
    conn.setAutoCommit(false); // 開始交易
    
    // 檢查購物車是否有商品
    String cartSql = "SELECT c.product_id, c.quantity, p.product_name, p.price, p.stock " +
                   "FROM cart_item c JOIN product p ON c.product_id = p.product_id " +
                   "WHERE c.member_id = ?";
    pstmt = conn.prepareStatement(cartSql);
    pstmt.setInt(1, memberId);
    rs = pstmt.executeQuery();
    
    double totalAmount = 0.0;
    java.util.List<java.util.Map<String, Object>> cartItems = new java.util.ArrayList<>();
    
    while (rs.next()) {
        int productId = rs.getInt("product_id");
        int quantity = rs.getInt("quantity");
        String productName = rs.getString("product_name");
        double price = rs.getDouble("price");
        int stock = rs.getInt("stock");
        
        // 檢查庫存
        if (stock < quantity) {
            throw new Exception("商品「" + productName + "」庫存不足！");
        }
        
        double itemTotal = price * quantity;
        totalAmount += itemTotal;
        
        java.util.Map<String, Object> item = new java.util.HashMap<>();
        item.put("productId", productId);
        item.put("quantity", quantity);
        item.put("price", price);
        cartItems.add(item);
    }
    rs.close();
    pstmt.close();
    
    if (cartItems.isEmpty()) {
        throw new Exception("購物車是空的！");
    }
    
    // 計算運費
    double shippingFee = totalAmount >= 10000 ? 0 : 150;
    if ("貨到付款".equals(paymentMethod)) {
        shippingFee += 30; // 貨到付款手續費
    }
    double finalAmount = totalAmount + shippingFee;
    
    // 創建訂單
    String orderSql = "INSERT INTO orders (member_id, total_amount, shipping_fee, final_amount, " +
                    "payment_method, shipping_name, shipping_phone, shipping_address, order_note) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
    pstmt = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS);
    pstmt.setInt(1, memberId);
    pstmt.setDouble(2, totalAmount);
    pstmt.setDouble(3, shippingFee);
    pstmt.setDouble(4, finalAmount);
    pstmt.setString(5, paymentMethod);
    pstmt.setString(6, shippingName.trim());
    pstmt.setString(7, shippingPhone.trim());
    pstmt.setString(8, shippingAddress.trim());
    pstmt.setString(9, orderNote != null ? orderNote.trim() : "");
    
    int result = pstmt.executeUpdate();
    if (result == 0) {
        throw new Exception("建立訂單失敗！");
    }
    
    // 獲取訂單ID
    rs = pstmt.getGeneratedKeys();
    int orderId = 0;
    if (rs.next()) {
        orderId = rs.getInt(1);
    }
    rs.close();
    pstmt.close();
    
    // 插入訂單明細
    String itemSql = "INSERT INTO order_item (order_id, item_sequence, product_id, quantity, price) " +
                   "VALUES (?, ?, ?, ?, ?)";
    pstmt = conn.prepareStatement(itemSql);
    
    for (int i = 0; i < cartItems.size(); i++) {
        java.util.Map<String, Object> item = cartItems.get(i);
        pstmt.setInt(1, orderId);
        pstmt.setInt(2, i + 1);
        pstmt.setInt(3, (Integer) item.get("productId"));
        pstmt.setInt(4, (Integer) item.get("quantity"));
        pstmt.setDouble(5, (Double) item.get("price"));
        pstmt.executeUpdate();
    }
    pstmt.close();
    
    // 更新商品庫存
    String updateStockSql = "UPDATE product SET stock = stock - ? WHERE product_id = ?";
    pstmt = conn.prepareStatement(updateStockSql);
    
    for (java.util.Map<String, Object> item : cartItems) {
        pstmt.setInt(1, (Integer) item.get("quantity"));
        pstmt.setInt(2, (Integer) item.get("productId"));
        pstmt.executeUpdate();
    }
    pstmt.close();
    
    // 清空購物車
    String clearCartSql = "DELETE FROM cart_item WHERE member_id = ?";
    pstmt = conn.prepareStatement(clearCartSql);
    pstmt.setInt(1, memberId);
    pstmt.executeUpdate();
    
    conn.commit(); // 提交交易
    
    message = "訂單建立成功！訂單編號：" + orderId;
    messageType = "success";
    
    // 重定向到訂單成功頁面
    response.sendRedirect("order_success.jsp?orderId=" + orderId);
    return;
    
} catch (Exception e) {
    if (conn != null) {
        try {
            conn.rollback(); // 回滾交易
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
    message = "訂單建立失敗：" + e.getMessage();
    e.printStackTrace();
} finally {
    if (conn != null) {
        try {
            conn.setAutoCommit(true);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    closeResources(conn, pstmt, rs);
}

// 如果有錯誤，重定向回結帳頁面
response.sendRedirect("checkout.jsp?message=" + java.net.URLEncoder.encode(message, "UTF-8") + "&type=" + messageType);
%> 