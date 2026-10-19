<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<%
    // 檢查是否已登入
    Integer memberId = (Integer) session.getAttribute("memberId");
    if (memberId == null) {
        response.sendRedirect("member.jsp");
        return;
    }

    // 獲取更新訊息
    String updateMessage = (String) session.getAttribute("update_message");
    String updateMessageType = (String) session.getAttribute("update_message_type");
    if (updateMessage != null) {
        session.removeAttribute("update_message");
        session.removeAttribute("update_message_type");
    }
%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>會員專區 - NBA卡包商城</title>
    <style>
        :root {
            --primary-color: #003da5;
            --secondary-color: #00c3ff;
            --accent-color: #ffd700;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --light-bg: #f8f9fa;
            --card-bg: #ffffff;
            --text-dark: #2c3e50;
            --text-muted: #6c757d;
            --border-color: #e9ecef;
            --shadow: 0 4px 12px rgba(0, 61, 165, 0.1);
            --shadow-hover: 0 8px 25px rgba(0, 61, 165, 0.15);
            --gradient-primary: linear-gradient(135deg, #003da5 0%, #00c3ff 100%);
            --gradient-bg: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: var(--gradient-bg);
            min-height: 100vh;
            color: var(--text-dark);
        }

        /* 導航列 */
        .navbar {
            background: var(--primary-color);
            padding: 1rem 0;
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 2rem;
        }

        .nav-brand a {
            color: white;
            text-decoration: none;
            font-size: 1.5rem;
            font-weight: bold;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
        }

        .nav-links a:hover, .nav-links a.active {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-2px);
        }

        /* 主容器 */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        /* 警告訊息 */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 0.75rem;
            margin-bottom: 2rem;
            border-left: 4px solid;
            animation: slideInDown 0.5s ease-out;
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-success {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
            border-color: var(--success-color);
        }

        .alert-error {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
            border-color: var(--danger-color);
        }

        .alert-warning {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            color: #856404;
            border-color: var(--warning-color);
        }

        /* 歡迎區域 */
        .welcome-section {
            background: var(--card-bg);
            border-radius: 1.5rem;
            padding: 3rem 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
            position: relative;
            overflow: hidden;
            animation: slideInUp 0.6s ease-out;
        }

        .welcome-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: var(--gradient-primary);
        }

        .welcome-section::after {
            content: '🏀';
            position: absolute;
            top: 2rem;
            right: 2rem;
            font-size: 3rem;
            opacity: 0.1;
            animation: float 3s ease-in-out infinite;
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
        }

        .member-header {
            display: flex;
            align-items: center;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .member-avatar {
            position: relative;
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .member-avatar:hover {
            transform: scale(1.05);
        }

        .member-avatar img {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            border: 4px solid var(--primary-color);
            box-shadow: var(--shadow);
            object-fit: cover;
            background: #f8f9fa;
            padding: 5px;
        }

        .member-level-badge {
            position: absolute;
            bottom: -5px;
            right: -5px;
            background: var(--accent-color);
            color: var(--text-dark);
            padding: 0.25rem 0.5rem;
            border-radius: 1rem;
            font-size: 0.7rem;
            font-weight: bold;
            box-shadow: var(--shadow);
        }

        .member-level-badge.VIP {
            background: linear-gradient(135deg, #ffd700, #ffed4a);
        }

        .member-level-badge.管理員 {
            background: linear-gradient(135deg, #dc3545, #e74c3c);
            color: white;
        }

        .avatar-edit-hint {
            position: absolute;
            bottom: -20px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 0.7rem;
            color: var(--text-muted);
            background: white;
            padding: 0.2rem 0.5rem;
            border-radius: 0.5rem;
            box-shadow: var(--shadow);
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .member-avatar:hover .avatar-edit-hint {
            opacity: 1;
        }

        .member-info {
            flex: 1;
        }

        .member-info h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            background: var(--gradient-primary);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .member-subtitle {
            color: var(--text-muted);
            font-size: 1.1rem;
            margin-bottom: 1rem;
        }

        .member-stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 1rem;
            margin-top: 2rem;
        }

        .stat-item {
            text-align: center;
            padding: 1rem;
            background: linear-gradient(135deg, rgba(0, 61, 165, 0.05), rgba(0, 195, 255, 0.05));
            border-radius: 1rem;
            border: 2px solid rgba(0, 61, 165, 0.1);
            transition: all 0.3s ease;
        }

        .stat-item:hover {
            transform: translateY(-5px);
            border-color: var(--primary-color);
            box-shadow: var(--shadow-hover);
        }

        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--primary-color);
            display: block;
        }

        .stat-label {
            font-size: 0.9rem;
            color: var(--text-muted);
            margin-top: 0.25rem;
        }

        /* 快速操作區域 */
        .section-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: white;
            margin-bottom: 1.5rem;
            text-align: center;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }

        .action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .action-card {
            background: var(--card-bg);
            border-radius: 1rem;
            padding: 2rem;
            text-align: center;
            box-shadow: var(--shadow);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .action-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient-primary);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }

        .action-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-hover);
        }

        .action-card:hover::before {
            transform: scaleX(1);
        }

        .action-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
            display: block;
            animation: bounce 2s infinite;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-10px); }
            60% { transform: translateY(-5px); }
        }

        .action-card h3 {
            font-size: 1.3rem;
            margin-bottom: 0.5rem;
            color: var(--primary-color);
        }

        .action-card p {
            color: var(--text-muted);
            margin-bottom: 1.5rem;
        }

        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            background: var(--gradient-primary);
            color: white;
            text-decoration: none;
            border-radius: 0.5rem;
            font-weight: 500;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }

        .btn:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        .btn-secondary {
            background: linear-gradient(135deg, var(--text-muted), #495057);
        }

        .btn-danger {
            background: linear-gradient(135deg, var(--danger-color), #c82333);
        }

        /* 內容區域 */
        .content-section {
            background: var(--card-bg);
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
            animation: fadeIn 0.6s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .content-section h2 {
            color: var(--primary-color);
            font-size: 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        /* 表單樣式 */
        .form-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text-dark);
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid var(--border-color);
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(0, 61, 165, 0.1);
            transform: translateY(-2px);
        }

        /* 頭像選擇器 */
        .avatar-selector {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
            gap: 1rem;
            margin: 1rem 0;
            max-height: 300px;
            overflow-y: auto;
            padding: 1rem;
            border: 2px dashed var(--border-color);
            border-radius: 0.5rem;
        }

        .avatar-option {
            position: relative;
            cursor: pointer;
            transition: all 0.3s ease;
            border-radius: 0.5rem;
            overflow: hidden;
        }

        .avatar-option:hover {
            transform: scale(1.05);
        }

        .avatar-option img {
            width: 80px;
            height: 80px;
            object-fit: contain;
            background: #f8f9fa;
            border: 2px solid var(--border-color);
            border-radius: 0.5rem;
            padding: 5px;
            transition: all 0.3s ease;
        }

        .avatar-option input[type="radio"] {
            position: absolute;
            opacity: 0;
        }

        .avatar-option input[type="radio"]:checked + label img {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px var(--primary-color), 0 0 0 5px rgba(0, 61, 165, 0.3);
            transform: scale(1.02);
        }

        .avatar-option input[type="radio"]:checked + label .avatar-label {
            color: var(--primary-color);
            font-weight: bold;
        }

        .avatar-label {
            font-size: 0.7rem;
            text-align: center;
            margin-top: 0.25rem;
            color: var(--text-muted);
        }

        /* 訂單項目 */
        .order-item {
            border: 2px solid var(--border-color);
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
        }

        .order-item:hover {
            border-color: var(--primary-color);
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .order-id {
            color: var(--primary-color);
        }

        .order-date {
            color: var(--text-muted);
        }

        .order-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 0.5rem;
        }

        .status {
            padding: 0.25rem 0.75rem;
            border-radius: 1rem;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .status.已付款 {
            background: linear-gradient(135deg, #d4edda, #c3e6cb);
            color: #155724;
        }

        .status.未付款 {
            background: linear-gradient(135deg, #f8d7da, #f5c6cb);
            color: #721c24;
        }

        .status.已完成 {
            background: linear-gradient(135deg, #d1ecf1, #bee5eb);
            color: #0c5460;
        }

        .status.處理中 {
            background: linear-gradient(135deg, #fff3cd, #ffeaa7);
            color: #856404;
        }

        /* 空狀態 */
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: var(--text-muted);
        }

        .empty-state .icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .empty-state h3 {
            margin-bottom: 0.5rem;
        }

        /* 載入動畫 */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(0, 61, 165, 0.3);
            border-radius: 50%;
            border-top-color: var(--primary-color);
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }

        /* 響應式設計 */
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .member-header {
                flex-direction: column;
                text-align: center;
            }

            .member-info h1 {
                font-size: 2rem;
            }

            .action-grid {
                grid-template-columns: 1fr;
            }

            .nav-links {
                display: none;
            }

            .member-stats {
                grid-template-columns: repeat(2, 1fr);
            }

            .order-details {
                grid-template-columns: 1fr;
            }

            .avatar-selector {
                grid-template-columns: repeat(auto-fill, minmax(80px, 1fr));
            }
        }

        @media (max-width: 480px) {
            .member-info h1 {
                font-size: 1.5rem;
            }

            .action-card {
                padding: 1.5rem;
            }

            .content-section {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>
    <%
    // 獲取會員詳細資訊和統計數據
    String memberName = "";
    String memberLevel = "";
    String email = "";
    String phone = "";
    String address = "";
    String avatar = "";
    String created_at = "";
    int totalOrders = 0;
    double totalSpent = 0.0;
    int cartItems = 0;
    boolean dbAvailable = true;
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
        try {
            conn = getConnection();
        
        // 獲取會員基本資訊
        String memberSql = "SELECT username, member_level, email, phone, address, avatar, created_at FROM member WHERE member_id = ?";
        pstmt = conn.prepareStatement(memberSql);
            pstmt.setInt(1, memberId);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
            memberName = rs.getString("username") != null ? rs.getString("username") : "";
            memberLevel = rs.getString("member_level") != null ? rs.getString("member_level") : "一般會員";
                email = rs.getString("email") != null ? rs.getString("email") : "";
                phone = rs.getString("phone") != null ? rs.getString("phone") : "";
                address = rs.getString("address") != null ? rs.getString("address") : "";
            avatar = rs.getString("avatar") != null ? rs.getString("avatar") : "images/member_icon.png";
                created_at = rs.getString("created_at") != null ? rs.getString("created_at") : "";
            }
        rs.close();
        pstmt.close();
        
        // 獲取訂單統計
        String orderStatsSql = "SELECT COUNT(*) as order_count, COALESCE(SUM(final_amount), 0) as total_spent FROM orders WHERE member_id = ?";
        pstmt = conn.prepareStatement(orderStatsSql);
        pstmt.setInt(1, memberId);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            totalOrders = rs.getInt("order_count");
            totalSpent = rs.getDouble("total_spent");
        }
        rs.close();
        pstmt.close();
        
        // 獲取購物車數量
        String cartSql = "SELECT COUNT(*) as cart_count FROM cart_item WHERE member_id = ?";
        pstmt = conn.prepareStatement(cartSql);
        pstmt.setInt(1, memberId);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            cartItems = rs.getInt("cart_count");
        }
        rs.close();
        pstmt.close();
        
        } catch (Exception e) {
            System.err.println("Database error in member_area.jsp: " + e.getMessage());
            dbAvailable = false;
        } finally {
            closeResources(conn, pstmt, rs);
    }
    %>

    <!-- 導航列 -->
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand">
                <a href="index.jsp">🏀 NBA卡包商城</a>
            </div>
            <div class="nav-links">
                <a href="index.jsp">首頁</a>
                <a href="cart.jsp">購物車</a>
                <a href="member_area.jsp" class="active">會員專區</a>
                <a href="message_board.jsp">留言板</a>
                <a href="member.jsp?action=logout">登出</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <!-- 更新訊息 -->
        <% if (updateMessage != null) { %>
            <div class="alert alert-<%=updateMessageType%>">
                <strong><%="success".equals(updateMessageType) ? "✅ 成功：" : "❌ 錯誤："%></strong><%=updateMessage%>
            </div>
        <% } %>

        <!-- 資料庫狀態提示 -->
        <% if (!dbAvailable) { %>
            <div class="alert alert-warning">
                <strong>⚠️ 系統提示：</strong>目前資料庫連接異常，部分功能可能無法正常使用。
            </div>
        <% } %>

        <!-- 歡迎區域 -->
        <div class="welcome-section">
            <div class="member-header">
                <div class="member-avatar" onclick="showAvatarSelector()">
                    <img src="<%=avatar%>" alt="會員頭像" onerror="this.src='images/member_icon.png'">
                    <div class="member-level-badge <%=memberLevel.replace("會員", "")%>">
                        <%=memberLevel%>
                    </div>
                    <div class="avatar-edit-hint">點擊更換頭像</div>
                </div>
                <div class="member-info">
                    <h1>歡迎回來，<%=memberName%>！</h1>
                    <p class="member-subtitle">感謝您對NBA卡包商城的支持</p>
                    <div class="member-stats">
                        <div class="stat-item">
                            <span class="stat-number"><%=totalOrders%></span>
                            <span class="stat-label">總訂單</span>
                    </div>
                        <div class="stat-item">
                            <span class="stat-number">NT$<%=String.format("%,.0f", totalSpent)%></span>
                            <span class="stat-label">總消費</span>
                    </div>
                        <div class="stat-item">
                            <span class="stat-number"><%=cartItems%></span>
                            <span class="stat-label">購物車</span>
                    </div>
                        <div class="stat-item">
                            <span class="stat-number"><%=created_at.length() > 10 ? created_at.substring(0,10) : created_at%></span>
                            <span class="stat-label">註冊日期</span>
                    </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 快速操作 -->
        <h2 class="section-title">🚀 快速操作</h2>
        <div class="action-grid">
            <div class="action-card">
                <span class="action-icon">📦</span>
                <h3>我的訂單</h3>
                <p>查看訂單記錄和配送狀態</p>
                <button class="btn" onclick="showOrders()">查看訂單</button>
            </div>
            
            <div class="action-card">
                <span class="action-icon">🛒</span>
                <h3>購物車</h3>
                <p>查看和管理購物車商品</p>
                <a href="cart.jsp" class="btn">前往購物車</a>
            </div>
            
            <div class="action-card">
                <span class="action-icon">👤</span>
                <h3>個人資料</h3>
                <p>修改個人資料和密碼</p>
                <button class="btn" onclick="showProfile()">編輯資料</button>
            </div>
            
            <div class="action-card">
                <span class="action-icon">🎯</span>
                <h3>繼續購物</h3>
                <p>探索更多NBA卡片收藏</p>
                <a href="card.jsp" class="btn">立即購物</a>
            </div>
        </div>

        <!-- 頭像選擇區域 -->
        <div id="avatar-section" class="content-section" style="display: none;">
            <h2>🖼️ 選擇頭像</h2>
            <p style="margin-bottom: 1rem; color: var(--text-muted);">您可以選擇預設頭像或已購買的卡包圖片作為頭像</p>
            
            <form id="avatarForm" action="update_member.jsp" method="post">
                <input type="hidden" name="action" value="update_avatar">
                
                <div class="avatar-selector">
                    <!-- 預設頭像 -->
                    <div class="avatar-option">
                        <input type="radio" name="avatar" value="images/member_icon.png" id="default-avatar" <%="images/member_icon.png".equals(avatar) ? "checked" : ""%>>
                        <label for="default-avatar">
                            <img src="images/member_icon.png" alt="預設頭像">
                            <div class="avatar-label">預設頭像</div>
                        </label>
                    </div>
                    
                    <%
                    // 獲取會員購買過的卡盒商品圖片
                    Connection avatarConn = null;
                    PreparedStatement avatarPstmt = null;
                    ResultSet avatarRs = null;
                    try {
                        avatarConn = getConnection();
                        String purchasedBoxesSql = "SELECT DISTINCT p.product_id, p.product_name, p.main_image " +
                                                 "FROM orders o " +
                                                 "JOIN order_item oi ON o.order_id = oi.order_id " +
                                                 "JOIN product p ON oi.product_id = p.product_id " +
                                                 "WHERE o.member_id = ? AND p.category_id = 1 " ;
                                                 
                        avatarPstmt = avatarConn.prepareStatement(purchasedBoxesSql);
                        avatarPstmt.setInt(1, memberId);
                        avatarRs = avatarPstmt.executeQuery();
                        
                        while (avatarRs.next()) {
                            String productId = avatarRs.getString("product_id");
                            String productName = avatarRs.getString("product_name");
                            String mainImage = avatarRs.getString("main_image");
                            boolean isSelected = mainImage.equals(avatar);
                    %>
                            <div class="avatar-option">
                                <input type="radio" name="avatar" value="<%=mainImage%>" id="avatar-<%=productId%>" <%=isSelected ? "checked" : ""%>>
                                <label for="avatar-<%=productId%>">
                                    <img src="<%=mainImage%>" alt="<%=productName%>">
                                    <div class="avatar-label"><%=productName.length() > 15 ? productName.substring(0, 15) + "..." : productName%></div>
                                </label>
                            </div>
                    <%
                        }
                    } catch (Exception e) {
                        System.err.println("Error loading purchased boxes: " + e.getMessage());
                    } finally {
                        closeResources(avatarConn, avatarPstmt, avatarRs);
                    }
                    %>
                </div>
                
                <div style="display: flex; gap: 1rem; justify-content: center; margin-top: 2rem;">
                    <button type="submit" class="btn">
                        <span id="avatarUpdateText">更新頭像</span>
                        <span id="avatarUpdateLoading" style="display: none;"><span class="loading"></span> 更新中...</span>
                    </button>
                    <button type="button" class="btn btn-secondary" onclick="hideAvatarSelector()">取消</button>
                </div>
            </form>
        </div>

        <!-- 訂單記錄區域 -->
        <div id="orders-section" class="content-section" style="display: none;">
            <h2>📋 我的訂單</h2>
            <div class="orders-list">
                <%
                Connection orderConn = null;
                PreparedStatement orderPstmt = null;
                ResultSet orderRs = null;
                    try {
                    orderConn = getConnection();
                        String orderSql = "SELECT order_id, total_amount, final_amount, payment_method, payment_status, " +
                                        "order_status, shipping_name, created_at FROM orders WHERE member_id = ? " +
                                        "ORDER BY created_at DESC LIMIT 10";
                    orderPstmt = orderConn.prepareStatement(orderSql);
                    orderPstmt.setInt(1, memberId);
                    orderRs = orderPstmt.executeQuery();
                        
                        boolean hasOrders = false;
                    while (orderRs.next()) {
                            hasOrders = true;
                        int orderId = orderRs.getInt("order_id");
                        double totalAmount = orderRs.getDouble("total_amount");
                        double finalAmount = orderRs.getDouble("final_amount");
                        String paymentMethod = orderRs.getString("payment_method");
                        String paymentStatus = orderRs.getString("payment_status");
                        String orderStatus = orderRs.getString("order_status");
                        String shippingName = orderRs.getString("shipping_name");
                        String orderDate = orderRs.getString("created_at");
                %>
                    <div class="order-item">
                        <div class="order-header">
                            <span class="order-id">訂單編號：#<%=orderId%></span>
                            <span class="order-date"><%=orderDate.length() > 16 ? orderDate.substring(0,16) : orderDate%></span>
                        </div>
                        <div class="order-details">
                            <p><strong>收件人：</strong><%=shippingName%></p>
                            <p><strong>付款方式：</strong><%=paymentMethod%></p>
                            <p><strong>訂單金額：</strong>NT$ <%=String.format("%,.0f", finalAmount)%></p>
                            <p><strong>付款狀態：</strong><span class="status <%=paymentStatus%>"><%=paymentStatus%></span></p>
                            <p><strong>訂單狀態：</strong><span class="status <%=orderStatus%>"><%=orderStatus%></span></p>
                        </div>
                    </div>
                <%
                        }
                        
                        if (!hasOrders) {
                %>
                    <div class="empty-state">
                        <div class="icon">📦</div>
                        <h3>尚無訂單記錄</h3>
                        <p>您還沒有任何訂單，立即開始購物吧！</p>
                        <a href="card.jsp" class="btn">立即購物</a>
                    </div>
                <%
                        }
                    } catch (Exception e) {
                        System.err.println("Database error loading orders: " + e.getMessage());
                %>
                        <div class="alert alert-error">
                            <h4>❌ 載入訂單失敗</h4>
                            <p>無法載入訂單記錄：<%=e.getMessage()%></p>
                        </div>
                <%
                    } finally {
                    closeResources(orderConn, orderPstmt, orderRs);
                }
                %>
            </div>
        </div>

        <!-- 個人資料編輯區域 -->
        <div id="profile-section" class="content-section" style="display: none;">
            <h2>✏️ 個人資料</h2>
            <div class="form-section">
                <form id="profileForm" action="update_member.jsp" method="post">
                    <input type="hidden" name="action" value="update_profile">
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="display_name">使用者名稱</label>
                            <input type="text" id="display_name" name="display_name" value="<%=memberName%>" readonly>
                        </div>
                        <div class="form-group">
                            <label for="member_level">會員等級</label>
                            <input type="text" id="member_level" name="member_level" value="<%=memberLevel%>" readonly>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="email">電子郵件 *</label>
                            <input type="email" id="email" name="email" value="<%=email%>" required>
                            </div>
                        <div class="form-group">
                            <label for="phone">聯絡電話</label>
                            <input type="tel" id="phone" name="phone" value="<%=phone%>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="address">地址</label>
                        <textarea id="address" name="address" rows="3"><%=address%></textarea>
                    </div>
                    <div class="form-group">
                        <label for="join_date">註冊時間</label>
                        <input type="text" id="join_date" name="join_date" value="<%=created_at%>" readonly>
                    </div>
                    <div style="display: flex; gap: 1rem; justify-content: center; margin-top: 2rem;">
                        <button type="submit" class="btn">
                            <span id="updateText">更新資料</span>
                            <span id="updateLoading" style="display: none;"><span class="loading"></span> 更新中...</span>
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="hideProfile()">取消</button>
                        <button type="button" class="btn btn-danger" onclick="showPasswordForm()">修改密碼</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- 修改密碼區域 -->
        <div id="password-section" class="content-section" style="display: none;">
            <h2>🔒 修改密碼</h2>
            <div class="form-section">
                <form id="passwordForm" action="update_member.jsp" method="post">
                    <input type="hidden" name="action" value="change_password">
                    
                    <div class="form-group">
                        <label for="current_password">目前密碼 *</label>
                        <input type="password" id="current_password" name="current_password" required>
                    </div>
                    <div class="form-group">
                        <label for="new_password">新密碼 *</label>
                        <input type="password" id="new_password" name="new_password" required minlength="6">
                    </div>
                    <div class="form-group">
                        <label for="confirm_password">確認新密碼 *</label>
                        <input type="password" id="confirm_password" name="confirm_password" required minlength="6">
                    </div>
                    <div style="display: flex; gap: 1rem; justify-content: center; margin-top: 2rem;">
                        <button type="submit" class="btn">
                            <span id="passwordUpdateText">修改密碼</span>
                            <span id="passwordUpdateLoading" style="display: none;"><span class="loading"></span> 修改中...</span>
                        </button>
                        <button type="button" class="btn btn-secondary" onclick="hidePasswordForm()">取消</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
    function showOrders() {
            hideAllSections();
        document.getElementById('orders-section').style.display = 'block';
            document.getElementById('orders-section').scrollIntoView({ behavior: 'smooth' });
    }
    
    function showProfile() {
            hideAllSections();
            document.getElementById('profile-section').style.display = 'block';
            document.getElementById('profile-section').scrollIntoView({ behavior: 'smooth' });
        }
        
        function showAvatarSelector() {
            hideAllSections();
            document.getElementById('avatar-section').style.display = 'block';
            document.getElementById('avatar-section').scrollIntoView({ behavior: 'smooth' });
        }
        
        function showPasswordForm() {
            hideAllSections();
            document.getElementById('password-section').style.display = 'block';
            document.getElementById('password-section').scrollIntoView({ behavior: 'smooth' });
        }
        
        function hideProfile() {
            document.getElementById('profile-section').style.display = 'none';
        }
        
        function hideAvatarSelector() {
            document.getElementById('avatar-section').style.display = 'none';
        }
        
        function hidePasswordForm() {
            document.getElementById('password-section').style.display = 'none';
        }
        
        function hideAllSections() {
            document.getElementById('orders-section').style.display = 'none';
            document.getElementById('profile-section').style.display = 'none';
            document.getElementById('avatar-section').style.display = 'none';
            document.getElementById('password-section').style.display = 'none';
        }

        // 表單提交處理
        document.getElementById('profileForm').addEventListener('submit', function(e) {
            const updateBtn = document.querySelector('#updateText').parentElement;
            const updateText = document.getElementById('updateText');
            const updateLoading = document.getElementById('updateLoading');
            
            updateBtn.disabled = true;
            updateText.style.display = 'none';
            updateLoading.style.display = 'inline';
        });

        document.getElementById('avatarForm').addEventListener('submit', function(e) {
            const updateBtn = document.querySelector('#avatarUpdateText').parentElement;
            const updateText = document.getElementById('avatarUpdateText');
            const updateLoading = document.getElementById('avatarUpdateLoading');
            
            updateBtn.disabled = true;
            updateText.style.display = 'none';
            updateLoading.style.display = 'inline';
        });

        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            const newPassword = document.getElementById('new_password').value;
            const confirmPassword = document.getElementById('confirm_password').value;
            
            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('新密碼與確認密碼不符！');
                return;
            }
            
            const updateBtn = document.querySelector('#passwordUpdateText').parentElement;
            const updateText = document.getElementById('passwordUpdateText');
            const updateLoading = document.getElementById('passwordUpdateLoading');
            
            updateBtn.disabled = true;
            updateText.style.display = 'none';
            updateLoading.style.display = 'inline';
        });

        // 頁面載入動畫
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.action-card');
            cards.forEach((card, index) => {
                card.style.animationDelay = `${index * 0.1}s`;
                card.style.animation = 'slideInUp 0.6s ease-out forwards';
            });
        });
    </script>
</body>
</html> 