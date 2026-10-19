<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    // 檢查會員登入狀態
    Integer memberId = (Integer) session.getAttribute("memberId");
    String memberName = (String) session.getAttribute("memberName");
    boolean isLoggedIn = memberId != null;
    
    // 處理購物車操作
    String action = request.getParameter("action");
    String message = "";
    String messageType = "";
    
    if ("add_to_cart".equals(action) && isLoggedIn) {
        String productId = request.getParameter("productId");
        String quantityStr = request.getParameter("quantity");
        
        if (productId != null && quantityStr != null) {
            try {
                int quantity = Integer.parseInt(quantityStr);
                if (quantity > 0) {
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    
                    try {
                        conn = getConnection();
                        pstmt = conn.prepareStatement(
                            "INSERT INTO cart_item (member_id, product_id, quantity, created_at) VALUES (?, ?, ?, NOW()) " +
                            "ON DUPLICATE KEY UPDATE quantity = quantity + ?"
                        );
                        pstmt.setInt(1, memberId);
                        pstmt.setInt(2, Integer.parseInt(productId));
                        pstmt.setInt(3, quantity);
                        pstmt.setInt(4, quantity);
                        
                        int result = pstmt.executeUpdate();
                        if (result > 0) {
                            message = "商品已加入購物車！";
                            messageType = "success";
                        }
                    } catch (Exception e) {
                        message = "加入購物車失敗，請稍後再試。";
                        messageType = "error";
                    } finally {
                        closeResources(conn, pstmt, null);
                    }
                }
            } catch (NumberFormatException e) {
                message = "數量格式錯誤。";
                messageType = "error";
            }
        }
    }
    
    // 獲取購物車商品
    List<Map<String, Object>> cartItems = new ArrayList<>();
    double totalAmount = 0;
    
    if (isLoggedIn) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(
                "SELECT c.product_id, c.quantity, p.product_name, p.price, p.main_image " +
                "FROM cart_item c " +
                "LEFT JOIN product p ON c.product_id = p.product_id " +
                "WHERE c.member_id = ? " +
                "ORDER BY c.created_at DESC"
            );
            pstmt.setInt(1, memberId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("productId", rs.getInt("product_id"));
                item.put("quantity", rs.getInt("quantity"));
                item.put("name", rs.getString("product_name"));
                item.put("price", rs.getDouble("price"));
                item.put("imageUrl", rs.getString("main_image"));
                
                double itemTotal = rs.getDouble("price") * rs.getInt("quantity");
                item.put("itemTotal", itemTotal);
                totalAmount += itemTotal;
                
                cartItems.add(item);
            }
        } catch (Exception e) {
            System.err.println("Error loading cart: " + e.getMessage());
        } finally {
            closeResources(conn, pstmt, rs);
        }
    }
    
    // 計算運費
    double shippingFee = totalAmount >= 1000 ? 0 : 100;
    double finalTotal = totalAmount + shippingFee;
%>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>購物車 - NBA卡包商城</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f4f4f4;
        }

        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 0;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 2rem;
        }

        .logo h1 {
            font-size: 1.5rem;
            font-weight: bold;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .nav-menu {
            background-color: rgba(255,255,255,0.1);
        }

        .nav-menu ul {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            list-style: none;
            padding: 0 2rem;
        }

        .nav-menu li a {
            display: block;
            color: white;
            text-decoration: none;
            padding: 15px 20px;
            transition: background-color 0.3s;
        }

        .nav-menu li a:hover, .nav-menu li a.active {
            background-color: rgba(255,255,255,0.2);
        }

        .container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }

        .cart-header {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .cart-header h2 {
            color: #333;
            font-size: 2rem;
        }

        .alert {
            padding: 15px 20px;
            margin: 20px 0;
            border-radius: 8px;
            font-weight: 500;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .empty-cart {
            background: white;
            text-align: center;
            padding: 60px 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .empty-cart-icon {
            font-size: 4rem;
            margin-bottom: 20px;
        }

        .btn {
            display: inline-block;
            padding: 12px 30px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            transition: transform 0.2s;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        .cart-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 20px;
        }

        .cart-items {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .cart-item {
            display: grid;
            grid-template-columns: 100px 1fr auto auto;
            gap: 20px;
            padding: 20px 0;
            border-bottom: 1px solid #eee;
            align-items: center;
        }

        .cart-item:last-child {
            border-bottom: none;
        }

        .item-image img {
            width: 80px;
            height: 80px;
            object-fit: contain;
            background: #f8f9fa;
            padding: 0.5rem;
            border-radius: 8px;
        }

        .item-details h3 {
            color: #333;
            margin-bottom: 5px;
        }

        .item-price {
            color: #667eea;
            font-weight: bold;
        }

        .quantity-controls {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .quantity-btn {
            width: 30px;
            height: 30px;
            border: 1px solid #ddd;
            background: white;
            cursor: pointer;
            border-radius: 4px;
        }

        .quantity-input {
            width: 60px;
            text-align: center;
            border: 1px solid #ddd;
            padding: 5px;
            border-radius: 4px;
        }

        .item-total {
            text-align: right;
            font-weight: bold;
            color: #333;
        }

        .cart-summary {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            height: fit-content;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            padding: 8px 0;
        }

        .summary-row.total {
            border-top: 2px solid #eee;
            padding-top: 15px;
            font-size: 1.2rem;
            font-weight: bold;
            color: #333;
        }

        .checkout-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1.1rem;
            font-weight: bold;
            cursor: pointer;
            margin-top: 20px;
            transition: transform 0.2s;
        }

        .checkout-btn:hover {
            transform: translateY(-2px);
        }

        .login-prompt {
            background: white;
            text-align: center;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        footer {
            background: #333;
            color: white;
            text-align: center;
            padding: 20px;
            margin-top: 50px;
        }

        @media (max-width: 768px) {
            .cart-content {
                grid-template-columns: 1fr;
            }
            
            .cart-item {
                grid-template-columns: 1fr;
                text-align: center;
            }
        }
    </style>
</head>

<body>
    <!-- Header -->
    <%@ include file="header.jsp" %>

    <div class="container">
        <div class="cart-header">
            <h2>🛒 我的購物車</h2>
            <div>
                <a href="card.jsp" class="btn">繼續購物</a>
            </div>
        </div>

        <!-- 訊息顯示 -->
        <% if (!message.isEmpty()) { %>
            <div class="alert alert-<%=messageType%>">
                <%=message%>
            </div>
        <% } %>

        <% if (!isLoggedIn) { %>
            <!-- 未登入提示 -->
            <div class="login-prompt">
                <h3>請先登入會員</h3>
                <p>登入後即可查看您的購物車內容</p>
                <a href="member.jsp" class="btn">立即登入</a>
            </div>
        <% } else if (cartItems.isEmpty()) { %>
            <!-- 空購物車 -->
            <div class="empty-cart">
                <div class="empty-cart-icon">🛒</div>
                <h3>您的購物車是空的</h3>
                <p>快去選購您喜愛的NBA卡片吧！</p>
                <a href="card.jsp" class="btn">開始購物</a>
            </div>
        <% } else { %>
            <!-- 購物車內容 -->
            <div class="cart-content">
                <div class="cart-items">
                    <h3>購物車商品</h3>
                    <% for (Map<String, Object> item : cartItems) { %>
                        <div class="cart-item">
                            <div class="item-image">
                                <img src="<%=item.get("imageUrl") != null ? item.get("imageUrl") : "images/default-product.jpg"%>" 
                                     alt="<%=item.get("name")%>" 
                                     onerror="this.src='images/default-product.jpg'">
                            </div>
                            <div class="item-details">
                                <h3><%=item.get("name")%></h3>
                                <p class="item-price">NT$ <%=String.format("%.0f", (Double)item.get("price"))%></p>
                            </div>
                            <div class="quantity-controls">
                                <form method="post" action="update_cart.jsp" style="display: inline;">
                                    <input type="hidden" name="productId" value="<%=item.get("productId")%>">
                                    <input type="hidden" name="action" value="decrease">
                                    <button type="submit" class="quantity-btn">-</button>
                                </form>
                                <span class="quantity-input"><%=item.get("quantity")%></span>
                                <form method="post" action="update_cart.jsp" style="display: inline;">
                                    <input type="hidden" name="productId" value="<%=item.get("productId")%>">
                                    <input type="hidden" name="action" value="increase">
                                    <button type="submit" class="quantity-btn">+</button>
                                </form>
                            </div>
                            <div class="item-total">
                                NT$ <%=String.format("%.0f", (Double)item.get("itemTotal"))%>
                            </div>
                        </div>
                    <% } %>
                </div>

                <div class="cart-summary">
                    <h3>訂單摘要</h3>
                    <div class="summary-row">
                        <span>商品小計：</span>
                        <span>NT$ <%=String.format("%.0f", totalAmount)%></span>
                    </div>
                    <div class="summary-row">
                        <span>運費：</span>
                        <span><%=shippingFee == 0 ? "NT$ 0 (免運費)" : "NT$ " + String.format("%.0f", shippingFee)%></span>
                    </div>
                    <div class="summary-row total">
                        <span>總計：</span>
                        <span>NT$ <%=String.format("%.0f", finalTotal)%></span>
                    </div>
                    
                    <% if (totalAmount < 1000) { %>
                        <p style="color: #f39c12; font-size: 0.9rem; margin: 10px 0;">
                            再消費 NT$ <%=String.format("%.0f", 1000 - totalAmount)%> 即可免運費！
                        </p>
                    <% } %>
                    
                    <form action="checkout.jsp" method="post">
                        <button type="submit" class="checkout-btn">
                            💳 立即結帳
                        </button>
                    </form>
                    <p style="text-align: center; color: #666; font-size: 0.9rem; margin-top: 10px;">
                        🔒 安全結帳，您的資料受到保護
                    </p>
                </div>
            </div>
        <% } %>
    </div>

    <!-- 引入統一的footer -->
    <%@ include file="footer.jsp" %>
</body>
</html> 