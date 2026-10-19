<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.util.*" %>

<%
    // 檢查登入狀態（使用不同變數名避免衝突）
    Integer cartMemberId = (Integer) session.getAttribute("memberId");
    if (cartMemberId == null) {
        response.sendRedirect("member.jsp?redirect=cart.jsp");
        return;
    }
    
    // 顯示操作結果訊息
    String message = request.getParameter("msg");
    String messageType = "info";
    
    List<Map<String, Object>> cartItems = new ArrayList<>();
    BigDecimal totalAmount = BigDecimal.ZERO;
    BigDecimal shippingFee = new BigDecimal("100"); // 運費
    BigDecimal freeShippingThreshold = new BigDecimal("2000"); // 免運門檻
    boolean dbAvailable = isDatabaseAvailable();
    
    if (dbAvailable) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            
            // 獲取購物車商品
            pstmt = conn.prepareStatement(
                "SELECT c.product_id, c.quantity, p.product_name, p.price, p.stock, p.main_image, " +
                "p.player_name, p.team, p.card_year, p.rarity " +
                "FROM cart_item c " +
                "JOIN product p ON c.product_id = p.product_id " +
                "WHERE c.member_id = ? " +
                "ORDER BY c.created_at DESC"
            );
            pstmt.setInt(1, cartMemberId);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Map<String, Object> item = new HashMap<>();
                item.put("productId", rs.getInt("product_id"));
                item.put("productName", rs.getString("product_name"));
                item.put("price", rs.getBigDecimal("price"));
                item.put("quantity", rs.getInt("quantity"));
                item.put("stock", rs.getInt("stock"));
                item.put("imageUrl", rs.getString("main_image"));
                item.put("playerName", rs.getString("player_name"));
                item.put("team", rs.getString("team"));
                item.put("cardYear", rs.getString("card_year"));
                item.put("rarity", rs.getString("rarity"));
                
                BigDecimal price = rs.getBigDecimal("price");
                int quantity = rs.getInt("quantity");
                BigDecimal subtotal = price.multiply(new BigDecimal(quantity));
                item.put("subtotal", subtotal);
                
                totalAmount = totalAmount.add(subtotal);
                cartItems.add(item);
            }
            
        } catch (Exception e) {
            System.err.println("Cart database error: " + e.getMessage());
            dbAvailable = false;
            message = "載入購物車時發生錯誤，請稍後再試。";
            messageType = "error";
        } finally {
            closeResources(conn, pstmt, rs);
        }
    }
    
    // 計算最終金額
    boolean isFreeShipping = totalAmount.compareTo(freeShippingThreshold) >= 0;
    BigDecimal finalAmount = totalAmount.add(isFreeShipping ? BigDecimal.ZERO : shippingFee);
%>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>購物車 - NBA卡包商城</title>
    <link rel="stylesheet" href="css/common.css">
    <style>
        :root {
            --primary-blue: #003da5;
            --accent-blue: #0056b3;
            --secondary-blue: #17a2b8;
            --success-green: #28a745;
            --warning-orange: #ffc107;
            --danger-red: #dc3545;
            --light-bg: #f8f9fa;
            --border-color: #e9ecef;
            --text-dark: #343a40;
            --text-muted: #6c757d;
        }

        body {
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
            font-family: 'Arial', sans-serif;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        /* 頁面標題 */
        .page-header {
            text-align: center;
            margin-bottom: 40px;
            padding: 40px 20px;
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 61, 165, 0.3);
            color: white;
            position: relative;
            overflow: hidden;
        }

        .page-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="cart-grid" width="20" height="20" patternUnits="userSpaceOnUse"><path d="M 20 0 L 0 0 0 20" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="1"/></pattern></defs><rect width="100" height="100" fill="url(%23cart-grid)" /></svg>');
            animation: float 20s linear infinite;
        }

        @keyframes float {
            0% { transform: translate(-25%, -25%) rotate(0deg); }
            100% { transform: translate(-25%, -25%) rotate(360deg); }
        }

        .page-header h1 {
            font-size: 3rem;
            margin: 0 0 10px 0;
            position: relative;
            z-index: 1;
        }

        .page-header p {
            font-size: 1.2rem;
            margin: 0;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .cart-stats {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-top: 20px;
            position: relative;
            z-index: 1;
        }

        .stat-item {
            text-align: center;
        }

        .stat-item .number {
            font-size: 2rem;
            font-weight: bold;
            display: block;
        }

        .stat-item .label {
            font-size: 0.9rem;
            opacity: 0.8;
        }

        /* 購物車主要內容 */
        .cart-content {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 30px;
            margin-bottom: 40px;
        }

        /* 購物車商品列表 */
        .cart-items {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        }

        .cart-items h3 {
            color: var(--primary-blue);
            font-size: 1.5rem;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .cart-items h3::before {
            content: '🛒';
            font-size: 1.2em;
        }

        .cart-item {
            display: flex;
            align-items: center;
            padding: 25px;
            margin-bottom: 20px;
            background: linear-gradient(135deg, #ffffff, #f8f9fa);
            border-radius: 15px;
            border: 2px solid var(--border-color);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .cart-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-blue), var(--secondary-blue));
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .cart-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.15);
            border-color: var(--primary-blue);
        }

        .cart-item:hover::before {
            opacity: 1;
        }

        .item-image {
            width: 120px;
            height: 120px;
            object-fit: contain;
            background: #f8f9fa;
            padding: 0.25rem;
            border-radius: 12px;
            margin-right: 20px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease;
        }

        .cart-item:hover .item-image {
            transform: scale(1.05);
        }

        .item-info {
            flex: 1;
            padding-right: 20px;
        }

        .item-name {
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--text-dark);
            margin-bottom: 8px;
            line-height: 1.3;
        }

        .item-details {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 10px;
        }

        .detail-tag {
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 500;
        }

        .item-price {
            font-size: 1.3rem;
            font-weight: bold;
            color: var(--danger-red);
            margin-bottom: 5px;
        }

        .item-stock {
            font-size: 0.9rem;
            color: var(--text-muted);
        }

        .quantity-controls {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
            margin-right: 20px;
        }

        .quantity-form {
            display: flex;
            align-items: center;
            gap: 8px;
            background: var(--light-bg);
            padding: 10px;
            border-radius: 10px;
        }

        .quantity-btn {
            width: 35px;
            height: 35px;
            border: none;
            background: var(--primary-blue);
            color: white;
            border-radius: 8px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .quantity-btn:hover {
            background: var(--accent-blue);
            transform: scale(1.1);
        }

        .quantity-input {
            width: 60px;
            text-align: center;
            border: 2px solid var(--border-color);
            padding: 8px;
            border-radius: 8px;
            font-weight: bold;
        }

        .update-btn {
            background: var(--success-green);
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .update-btn:hover {
            background: #218838;
            transform: translateY(-2px);
        }

        .item-subtotal {
            text-align: center;
            margin-right: 20px;
        }

        .subtotal-label {
            font-size: 0.9rem;
            color: var(--text-muted);
            margin-bottom: 5px;
        }

        .subtotal-amount {
            font-size: 1.4rem;
            font-weight: bold;
            color: var(--primary-blue);
        }

        .remove-btn {
            background: var(--danger-red);
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 8px;
            cursor: pointer;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }

        .remove-btn:hover {
            background: #c82333;
            transform: scale(1.05);
        }

        /* 訂單摘要 */
        .order-summary {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            height: fit-content;
            position: sticky;
            top: 20px;
        }

        .order-summary h3 {
            color: var(--primary-blue);
            font-size: 1.5rem;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .order-summary h3::before {
            content: '📋';
            font-size: 1.2em;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 0;
            border-bottom: 1px solid var(--border-color);
        }

        .summary-row:last-child {
            border-bottom: none;
            border-top: 2px solid var(--primary-blue);
            margin-top: 15px;
            padding-top: 20px;
            font-size: 1.2rem;
            font-weight: bold;
        }

        .summary-label {
            color: var(--text-dark);
        }

        .summary-value {
            font-weight: bold;
            color: var(--primary-blue);
        }

        .free-shipping-badge {
            background: var(--success-green);
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            margin-left: 10px;
        }

        .shipping-progress {
            margin: 15px 0;
            padding: 15px;
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            border-radius: 10px;
            border-left: 4px solid var(--secondary-blue);
        }

        .progress-text {
            font-size: 0.9rem;
            color: var(--primary-blue);
            font-weight: 600;
            margin-bottom: 10px;
        }

        .progress-bar {
            width: 100%;
            height: 8px;
            background: #e0e0e0;
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, var(--secondary-blue), var(--success-green));
            border-radius: 4px;
            transition: width 0.3s ease;
        }

        .checkout-actions {
            margin-top: 30px;
            display: flex;
            flex-direction: column;
            gap: 15px;
        }

        .btn {
            padding: 15px 25px;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .btn:hover::before {
            left: 100%;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0, 61, 165, 0.4);
        }

        .btn-secondary {
            background: linear-gradient(135deg, var(--text-muted), #495057);
            color: white;
        }

        .btn-secondary:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(108, 117, 125, 0.4);
        }

        /* 空購物車狀態 */
        .empty-cart {
            text-align: center;
            padding: 80px 40px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            grid-column: 1 / -1;
        }

        .empty-cart::before {
            content: '🛒';
            font-size: 5rem;
            display: block;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .empty-cart h2 {
            color: var(--primary-blue);
            font-size: 2rem;
            margin-bottom: 15px;
        }

        .empty-cart p {
            color: var(--text-muted);
            font-size: 1.1rem;
            margin-bottom: 30px;
        }

        /* 系統維護狀態 */
        .db-offline {
            text-align: center;
            padding: 80px 40px;
            background: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            grid-column: 1 / -1;
        }

        .db-offline::before {
            content: '🔌';
            font-size: 5rem;
            display: block;
            margin-bottom: 20px;
            opacity: 0.5;
        }

        .db-offline h3 {
            color: var(--primary-blue);
            font-size: 2rem;
            margin-bottom: 15px;
        }

        /* 警告訊息樣式 */
        .alert {
            padding: 15px 20px;
            margin-bottom: 20px;
            border: none;
            border-radius: 10px;
            font-size: 1rem;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: space-between;
            animation: slideDown 0.5s ease;
        }

        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .alert-success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-error {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .alert-info {
            background: linear-gradient(135deg, #d1ecf1, #bee5eb);
            color: #0c5460;
            border-left: 4px solid #17a2b8;
        }

        .alert-warning {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            color: #856404;
            border-left: 4px solid #ffc107;
        }

        .alert-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: inherit;
            opacity: 0.7;
            transition: opacity 0.3s ease;
            margin-left: 15px;
        }

        .alert-close:hover {
            opacity: 1;
        }

        /* 響應式設計 */
        @media (max-width: 768px) {
            .cart-content {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .cart-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .item-image {
                align-self: center;
                margin-right: 0;
            }

            .quantity-controls {
                align-self: center;
                margin-right: 0;
            }

            .item-subtotal {
                align-self: center;
                margin-right: 0;
            }

            .page-header h1 {
                font-size: 2rem;
            }

            .cart-stats {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>

<body>
    <!-- 引入統一的header -->
    <%@ include file="header.jsp" %>

    <div class="container">
        <!-- 資料庫狀態提示 -->
        <% if (!dbAvailable) { %>
            <div class="alert alert-warning">
                <strong>⚠️ 系統提示：</strong>目前資料庫連接異常，購物車功能可能無法正常使用。
                <a href="test_db.jsp" style="color: #856404; text-decoration: underline;">檢查系統狀態</a>
            </div>
        <% } %>

        <!-- 訊息顯示 -->
        <% if (message != null && !message.trim().isEmpty()) { %>
            <div class="alert alert-<%=messageType%>" id="messageAlert">
                <%= message %>
                <button type="button" class="alert-close" onclick="closeAlert()">×</button>
            </div>
        <% } %>

        <!-- 頁面標題 -->
        <div class="page-header">
            <h1>🛒 我的購物車</h1>
            <p>精心挑選的珍藏球星卡，準備好成為您的收藏了嗎？</p>
            <% if (dbAvailable && !cartItems.isEmpty()) { %>
                <div class="cart-stats">
                    <div class="stat-item">
                        <span class="number"><%=cartItems.size()%></span>
                        <span class="label">商品種類</span>
                    </div>
                    <div class="stat-item">
                        <span class="number"><%=cartItems.stream().mapToInt(item -> (Integer)item.get("quantity")).sum()%></span>
                        <span class="label">商品總數</span>
                    </div>
                    <div class="stat-item">
                        <span class="number">NT$ <%=String.format("%,.0f", totalAmount.doubleValue())%></span>
                        <span class="label">商品金額</span>
                    </div>
                </div>
            <% } %>
        </div>

        <div class="cart-content">
            <% if (!dbAvailable) { %>
                <div class="db-offline">
                    <h3>系統維護中</h3>
                        <p>目前無法連接到資料庫，暫時無法顯示購物車內容。</p>
                    <div style="margin-top: 30px; display: flex; gap: 15px; justify-content: center;">
                        <a href="test_db.jsp" class="btn btn-secondary">檢查系統狀態</a>
                            <a href="javascript:location.reload()" class="btn btn-primary">重新整理</a>
                    </div>
                </div>
            <% } else if (cartItems.isEmpty()) { %>
                <div class="empty-cart">
                    <h2>購物車空空如也</h2>
                    <p>還沒有找到心儀的球星卡嗎？快去探索我們的精選收藏吧！</p>
                    <a href="card.jsp" class="btn btn-primary">開始探索</a>
                </div>
            <% } else { %>
                <!-- 購物車商品列表 -->
                <div class="cart-items">
                    <h3>購物車商品</h3>
                    <% for (Map<String, Object> item : cartItems) { %>
                        <div class="cart-item">
                            <img src="<%= item.get("imageUrl") != null ? item.get("imageUrl") : "images/default_product.jpg" %>" 
                                 alt="<%= item.get("productName") %>" 
                                 class="item-image"
                                 onerror="this.src='images/default_product.jpg'">
                            
                            <div class="item-info">
                                <div class="item-name"><%= item.get("productName") %></div>
                                <div class="item-details">
                                    <% if (item.get("playerName") != null) { %>
                                        <span class="detail-tag">🏀 <%= item.get("playerName") %></span>
                                    <% } %>
                                    <% if (item.get("team") != null) { %>
                                        <span class="detail-tag">🏟️ <%= item.get("team") %></span>
                                    <% } %>
                                    <% if (item.get("cardYear") != null) { %>
                                        <span class="detail-tag">📅 <%= item.get("cardYear") %></span>
                                    <% } %>
                                    <% if (item.get("rarity") != null) { %>
                                        <span class="detail-tag">⭐ <%= item.get("rarity") %></span>
                                    <% } %>
                                </div>
                                <div class="item-price">NT$ <%= String.format("%,.0f", ((BigDecimal)item.get("price")).doubleValue()) %></div>
                                <div class="item-stock">庫存：<%= item.get("stock") %> 張</div>
                            </div>
                            
                            <div class="quantity-controls">
                                <form action="update_cart.jsp" method="post" class="quantity-form">
                                    <input type="hidden" name="productId" value="<%= item.get("productId") %>">
                                    <button type="submit" name="action" value="decrease" class="quantity-btn">−</button>
                                    <input type="number" name="quantity" value="<%= item.get("quantity") %>" 
                                           min="1" max="<%= item.get("stock") %>" class="quantity-input">
                                    <button type="submit" name="action" value="increase" class="quantity-btn">+</button>
                                </form>
                            </div>
                            
                            <div class="item-subtotal">
                                <div class="subtotal-label">小計</div>
                                <div class="subtotal-amount">NT$ <%= String.format("%,.0f", ((BigDecimal)item.get("subtotal")).doubleValue()) %></div>
                            </div>
                            
                            <form action="update_cart.jsp" method="post">
                                <input type="hidden" name="productId" value="<%= item.get("productId") %>">
                                <button type="submit" name="action" value="remove" class="remove-btn">🗑️ 移除</button>
                            </form>
                        </div>
                    <% } %>
                </div>

                <!-- 訂單摘要 -->
                <div class="order-summary">
                    <h3>訂單摘要</h3>
                    
                    <div class="summary-row">
                        <span class="summary-label">商品小計</span>
                        <span class="summary-value">NT$ <%= String.format("%,.0f", totalAmount.doubleValue()) %></span>
                    </div>
                    
                    <div class="summary-row">
                        <span class="summary-label">運費</span>
                        <span class="summary-value">
                            <% if (isFreeShipping) { %>
                                <span style="text-decoration: line-through; color: #999;">NT$ 100</span>
                                <span class="free-shipping-badge">免運費</span>
                            <% } else { %>
                                NT$ 100
                            <% } %>
                        </span>
                    </div>
                    
                    <% if (!isFreeShipping) { %>
                        <div class="shipping-progress">
                            <div class="progress-text">
                                還差 NT$ <%= String.format("%,.0f", freeShippingThreshold.subtract(totalAmount).doubleValue()) %> 即可免運費！
                            </div>
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: <%= Math.min(100, totalAmount.multiply(new BigDecimal("100")).divide(freeShippingThreshold, 2, BigDecimal.ROUND_HALF_UP).doubleValue()) %>%"></div>
                            </div>
                        </div>
                    <% } %>
                    <div class="summary-row">
                        <span class="summary-label">總計</span>
                        <span class="summary-value" style="color: var(--danger-red); font-size: 1.3rem;">NT$ <%= String.format("%,.0f", finalAmount.doubleValue()) %></span>
                    </div>
                    
                    <div class="checkout-actions">
                        <a href="checkout.jsp" class="btn btn-primary">🚀 立即結帳</a>
                        <a href="card.jsp" class="btn btn-secondary">🛍️ 繼續購物</a>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <!-- 引入統一的footer -->
    <%@ include file="footer.jsp" %>

    <script>
        // 關閉警告訊息
        function closeAlert() {
            const alert = document.getElementById('messageAlert');
            if (alert) {
                alert.style.animation = 'slideUp 0.5s ease';
                setTimeout(() => {
                    alert.remove();
                }, 500);
            }
        }

        // 自動隱藏成功訊息
        document.addEventListener('DOMContentLoaded', function() {
            const alert = document.getElementById('messageAlert');
            if (alert && alert.classList.contains('alert-success')) {
                setTimeout(() => {
                    closeAlert();
                }, 3000); // 3秒後自動隱藏成功訊息
            }

            // 數量控制相關JavaScript
            const quantityInputs = document.querySelectorAll('.quantity-input');
            quantityInputs.forEach(input => {
                input.addEventListener('change', function() {
                    const form = this.closest('.quantity-form');
                    const updateBtn = form.parentNode.querySelector('.update-btn');
                    if (updateBtn) {
                        updateBtn.style.background = '#ffc107';
                        updateBtn.textContent = '請點擊更新';
                        updateBtn.style.animation = 'pulse 1s infinite';
                    }
                });

                // 限制數量輸入
                input.addEventListener('input', function() {
                    let value = parseInt(this.value);
                    const max = parseInt(this.getAttribute('max'));
                    
                    if (value > max) {
                        this.value = max;
                        showToast('數量不可超過庫存 ' + max + ' 張', 'warning');
                    } else if (value < 1) {
                        this.value = 1;
                    }
                });
            });

            // 添加載入動畫
            const cartItems = document.querySelectorAll('.cart-item');
            cartItems.forEach((item, index) => {
                item.style.opacity = '0';
                item.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    item.style.transition = 'all 0.5s ease';
                    item.style.opacity = '1';
                    item.style.transform = 'translateY(0)';
                }, index * 100);
            });

            // 確認移除商品
            const removeButtons = document.querySelectorAll('.remove-btn');
            removeButtons.forEach(btn => {
                btn.addEventListener('click', function(e) {
                    const productName = this.closest('.cart-item').querySelector('.item-name').textContent;
                    if (!confirm('確定要移除「' + productName + '」嗎？')) {
                        e.preventDefault();
                    }
                });
            });
        });

        // 快速訊息提示
        function showToast(message, type = 'info') {
            const toast = document.createElement('div');
            toast.className = `alert alert-${type}`;
            toast.style.position = 'fixed';
            toast.style.top = '20px';
            toast.style.right = '20px';
            toast.style.zIndex = '9999';
            toast.style.minWidth = '300px';
            toast.innerHTML = message;
            
            document.body.appendChild(toast);
            
            setTimeout(() => {
                toast.style.animation = 'slideUp 0.5s ease';
                setTimeout(() => {
                    toast.remove();
                }, 500);
            }, 2000);
        }

        // 添加CSS動畫
        const style = document.createElement('style');
        style.textContent = `
            @keyframes slideUp {
                from { opacity: 1; transform: translateY(0); }
                to { opacity: 0; transform: translateY(-20px); }
            }
            @keyframes pulse {
                0% { transform: scale(1); }
                50% { transform: scale(1.05); }
                100% { transform: scale(1); }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html> 