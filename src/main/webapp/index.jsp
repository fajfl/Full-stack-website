<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<%
    // 初始化變數 - 設定預設值
    int visitCount = 2580;  // 預設訪問次數
    int productCount = 42;  // 預設商品數量
    int memberCount = 89;   // 預設會員數量
    int messageCount = 23;  // 預設留言數量
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    // 廣告資料
    java.util.List<java.util.Map<String, String>> adsList = new java.util.ArrayList<>();
    
    // 嘗試連接資料庫並獲取數據
    boolean dbConnected = isDatabaseAvailable();
    
    if (dbConnected) {
        try {
            conn = getConnection();
            
            // 獲取和更新網站統計數據
            try {
                // 確保site_settings表存在
                    pstmt = conn.prepareStatement(
                        "CREATE TABLE IF NOT EXISTS site_settings (" +
                        "setting_key VARCHAR(50) PRIMARY KEY, " +
                        "setting_value TEXT, " +
                        "updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
                        ")"
                    );
                    pstmt.executeUpdate();
                    pstmt.close();
                    
                // 獲取當前訪問次數
                    pstmt = conn.prepareStatement("SELECT setting_value FROM site_settings WHERE setting_key = 'visit_count'");
                    rs = pstmt.executeQuery();
                    if (rs.next()) {
                        visitCount = Integer.parseInt(rs.getString("setting_value"));
                    }
                    rs.close();
                    pstmt.close();
                
                // 只有新的會話才增加訪問次數
                    if (session.isNew()) {
                    visitCount++;
                    pstmt = conn.prepareStatement("UPDATE site_settings SET setting_value = ? WHERE setting_key = 'visit_count'");
                    pstmt.setString(1, String.valueOf(visitCount));
                    pstmt.executeUpdate();
                    pstmt.close();
            }
            
                // 獲取其他統計數據
                pstmt = conn.prepareStatement("SELECT COUNT(*) FROM products WHERE status = '上架'");
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    productCount = rs.getInt(1);
                }
                rs.close();
                pstmt.close();
                
                pstmt = conn.prepareStatement("SELECT COUNT(*) FROM members");
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    memberCount = rs.getInt(1);
                }
                rs.close();
                pstmt.close();
                
                pstmt = conn.prepareStatement("SELECT COUNT(*) FROM messages");
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    messageCount = rs.getInt(1);
                }
                rs.close();
                pstmt.close();
                
            } catch (Exception e) {
                System.err.println("Database error in index.jsp: " + e.getMessage());
                // 保持預設值
            }
            
            // 獲取廣告資料
            try {
                pstmt = conn.prepareStatement("SELECT title, image_url, link_url, description FROM banner_ads WHERE is_active = 1 ORDER BY sort_order, created_at DESC LIMIT 10");
                rs = pstmt.executeQuery();
                while (rs.next()) {
                    java.util.Map<String, String> ad = new java.util.HashMap<>();
                    ad.put("image", rs.getString("image_url"));
                    ad.put("text", rs.getString("description"));
                    ad.put("link", rs.getString("link_url") != null ? rs.getString("link_url") : "card.jsp");
                    adsList.add(ad);
            }
                rs.close();
                pstmt.close();
            } catch (Exception e) {
                // 使用預設廣告
            }
            
    } catch (Exception e) {
        System.err.println("Database error in index.jsp: " + e.getMessage());
            // 不重定向，繼續使用預設值
            dbConnected = false;
    } finally {
        closeResources(conn, pstmt, rs);
        }
    } else {
        // 資料庫無法連接時使用預設值
        visitCount = 2580;
        if (session.isNew()) {
            visitCount += (int)(Math.random() * 50) + 1; // 新會話時隨機增加一些訪問次數
        }
        productCount = 42;
        memberCount = 89;
        messageCount = 23;
    }
    
    // 如果沒有廣告資料，使用預設廣告
    if (adsList.isEmpty()) {
        java.util.Map<String, String> ad1 = new java.util.HashMap<>();
        ad1.put("image", "images/J.jpg");
        ad1.put("text", "Anthony Edwards 限量卡片現正熱賣中！");
        ad1.put("link", "card.jsp");
        adsList.add(ad1);
        
        java.util.Map<String, String> ad2 = new java.util.HashMap<>();
        ad2.put("image", "images/messageImage_1.jpg");
        ad2.put("text", "NBA 卡盒系列全新上架！");
        ad2.put("link", "card_box.jsp");
        adsList.add(ad2);
        
        java.util.Map<String, String> ad3 = new java.util.HashMap<>();
        ad3.put("image", "images/i.jpg");
        ad3.put("text", "經典姚明系列卡片重新上架！");
        ad3.put("link", "card.jsp");
        adsList.add(ad3);
        
        java.util.Map<String, String> ad4 = new java.util.HashMap<>();
        ad4.put("image", "images/s1.jpg");
        ad4.put("text", "奧運紀念卡 - 限量典藏版！");
        ad4.put("link", "special.jsp");
        adsList.add(ad4);
        
        java.util.Map<String, String> ad5 = new java.util.HashMap<>();
        ad5.put("image", "images/book.jpg");
        ad5.put("text", "Devin Booker 精選系列");
        ad5.put("link", "card.jsp");
        adsList.add(ad5);
        
        java.util.Map<String, String> ad6 = new java.util.HashMap<>();
        ad6.put("image", "images/messageImage_3.jpg");
        ad6.put("text", "精美周邊商品等你挖掘！");
        ad6.put("link", "card_accessories.jsp");
        adsList.add(ad6);
    }
    
    // 獲取當前廣告索引
    int currentAdIndex = 0;
    String adIndexParam = request.getParameter("ad");
    if (adIndexParam != null && !adIndexParam.isEmpty()) {
        try {
            currentAdIndex = Integer.parseInt(adIndexParam);
            if (currentAdIndex < 0 || currentAdIndex >= adsList.size()) {
                currentAdIndex = 0;
            }
        } catch (NumberFormatException e) {
            currentAdIndex = 0;
        }
    }
    
    // 獲取當前廣告資料
    java.util.Map<String, String> currentAd = adsList.get(currentAdIndex);
    
    // 計算前一個和下一個廣告索引
    int prevAdIndex = (currentAdIndex - 1 + adsList.size()) % adsList.size();
    int nextAdIndex = (currentAdIndex + 1) % adsList.size();
%>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NBA卡包商城 - 首頁</title>
    <link rel="stylesheet" href="css/common.css">
    <style>
        /* Hero Banner 樣式 */
        .hero-banner {
            background: linear-gradient(135deg, rgba(0, 61, 165, 0.9), rgba(0, 195, 255, 0.8)),
                        url('images/member-benefit3.png') center/cover;
            height: 60vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .hero-banner::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 30%, rgba(0, 195, 255, 0.1) 50%, transparent 70%);
            animation: shimmer 3s infinite;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }

        .hero-content {
            z-index: 2;
            max-width: 600px;
        }

        .hero-content h1 {
            font-size: 3.5rem;
            font-weight: bold;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            animation: fadeInUp 1s ease-out;
        }

        .hero-content p {
            font-size: 1.3rem;
            margin-bottom: 30px;
            animation: fadeInUp 1s ease-out 0.3s both;
        }

        .btn-limited {
            background: linear-gradient(135deg, #ff6b6b, #ff8e8e);
            color: white;
            padding: 15px 40px;
            border-radius: 30px;
            text-decoration: none;
            font-size: 1.2rem;
            font-weight: bold;
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.4);
            transition: all 0.3s ease;
            animation: fadeInUp 1s ease-out 0.6s both;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .btn-limited:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 15px 35px rgba(255, 107, 107, 0.6);
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* 動態廣告區 */
        .dynamic-ad {
            padding: 60px 0;
            background: #f8f9fa;
        }

        .ad-container {
            max-width: 1200px;
            margin: 0 auto;
            position: relative;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0,0,0,0.15);
        }

        .ad-carousel {
            position: relative;
            width: 100%;
            height: 900px;
            overflow: hidden;
            border-radius: 20px;
        }

        .ad-slides {
            display: flex;
            width: 100%;
            height: 100%;
            transition: transform 0.6s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }

        .ad-slide {
            min-width: 100%;
            height: 100%;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .ad-slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
        }

        .ad-text-overlay {
            position: absolute;
            bottom: 30px;
            left: 30px;
            right: 30px;
            background: linear-gradient(135deg, rgba(0, 61, 165, 0.95), rgba(0, 195, 255, 0.9));
            color: white;
            padding: 20px 30px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }

        .ad-text-overlay p {
            font-size: 1.3rem;
            font-weight: 600;
            margin: 0;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
            line-height: 1.4;
        }

        .ad-nav {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(0, 61, 165, 0.9);
            color: white;
            border: none;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            font-size: 1.8rem;
            cursor: pointer;
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10;
            box-shadow: 0 4px 15px rgba(0, 61, 165, 0.3);
        }

        .ad-nav:hover {
            background: var(--primary-blue);
            transform: translateY(-50%) scale(1.15);
            box-shadow: 0 6px 20px rgba(0, 61, 165, 0.5);
        }

        .ad-nav.left {
            left: 30px;
        }

        .ad-nav.right {
            right: 30px;
        }

        /* 廣告指示器 */
        .ad-indicators {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-top: 20px;
        }

        .indicator {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: rgba(0, 61, 165, 0.3);
            transition: all 0.3s ease;
            text-decoration: none;
        }

        .indicator:hover {
            background: rgba(0, 61, 165, 0.6);
            transform: scale(1.2);
        }

        .indicator.active {
            background: var(--primary-blue);
            transform: scale(1.3);
        }

        /* 即時消息廣告板 */
        .announcement-board {
            padding: 50px 0;
            background: white;
        }

        .announcement-board h2 {
            text-align: center;
            color: var(--primary-blue);
            font-size: 2.2rem;
            margin-bottom: 30px;
            font-weight: 700;
        }

        .announcements {
            display: flex;
            flex-direction: column;
            gap: 15px;
            max-width: 800px;
            margin: 0 auto;

        }

        .announcement-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px 25px;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 12px;
            border-left: 5px solid var(--primary-blue);
            transition: all 0.3s ease;
            animation: slideInRight 0.5s ease-out;
        }

        .announcement-item:hover {
            transform: translateX(10px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .announcement-badge {
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: bold;
            min-width: 60px;
            text-align: center;
        }

        .announcement-text {
            font-size: 1rem;
            color: #333;
            flex: 1;
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(50px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        /* 網站統計信息 */
        .site-stats {
            padding: 60px 0;
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
            color: white;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
            max-width: 1000px;
            margin: 0 auto;
        }

        .stat-item {
            text-align: center;
            padding: 30px 20px;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
        }

        .stat-item:hover {
            transform: translateY(-10px) scale(1.05);
            background: rgba(255, 255, 255, 0.2);
        }

        .stat-item h3 {
            font-size: 3rem;
            font-weight: bold;
            margin-bottom: 10px;
            color: #fff;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .stat-item p {
            font-size: 1.1rem;
            color: rgba(255, 255, 255, 0.9);
        }

        /* 會員介紹連結 */
        .member-intro {
            padding: 60px 0;
            background: #f8f9fa;
        }

        .member-intro h2 {
            text-align: center;
            color: var(--primary-blue);
            font-size: 2.2rem;
            margin-bottom: 40px;
            font-weight: 700;
        }

        .member-benefits {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }

        .benefit-item {
            text-align: center;
            padding: 30px 20px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }

        .benefit-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
        }

        .benefit-item img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin-bottom: 20px;
        }

        .benefit-item h3 {
            color: var(--primary-blue);
            margin-bottom: 15px;
            font-size: 1.3rem;
        }

        .benefit-item p {
            color: #666;
            line-height: 1.6;
        }

        .member-actions {
            display: flex;
            justify-content: center;
            gap: 20px;
            flex-wrap: wrap;
        }

        .btn-member, .btn-register, .btn-intro {
            padding: 15px 30px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
            font-size: 1.1rem;
        }

        .btn-member {
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
            color: white;
            box-shadow: 0 8px 25px rgba(0, 61, 165, 0.3);
        }

        .btn-register {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.3);
        }

        .btn-intro {
            background: linear-gradient(135deg, #6c757d, #868e96);
            color: white;
            box-shadow: 0 8px 25px rgba(108, 117, 125, 0.3);
        }

        .btn-member:hover, .btn-register:hover, .btn-intro:hover {
            transform: translateY(-3px) scale(1.05);
        }

        /* 響應式設計 */
        @media (max-width: 768px) {
            .hero-content h1 {
                font-size: 2.5rem;
            }
            
            .ad-nav {
                width: 40px;
                height: 40px;
                font-size: 1.2rem;
            }
            
            .stats-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
            }
            
            .stat-item h3 {
                font-size: 2.2rem;
            }
            
            .member-benefits {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .member-actions {
                flex-direction: column;
                align-items: center;
            }

            .btn-member, .btn-register, .btn-intro {
                width: 200px;
                text-align: center;
            }
        }

        @media (max-width: 480px) {
            .hero-content h1 {
                font-size: 2rem;
            }
            
            .hero-content p {
                font-size: 1.1rem;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .announcement-item {
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }
        }
    </style>
</head>

<body>
    <!-- 引入統一的header -->
    <%@ include file="header.jsp" %>

    <!-- 資料庫狀態提示 -->
    <% if (!dbConnected) { %>
        <div style="background: #fff3cd; border: 1px solid #ffeaa7; padding: 10px; text-align: center; color: #856404;">
            <strong>⚠️ 系統提示：</strong>目前資料庫連接異常，顯示的可能不是最新資訊。
            <a href="test_db.jsp" style="color: #856404; text-decoration: underline;">檢查系統狀態</a>
        </div>
    <% } %>

    <!-- Hero Banner -->
    <section class="hero-banner">
        <div class="hero-content">
            <h1>BASKETBALL CARDS</h1>
            <p>中原第一家NBA球員卡商城!</p>
            <a href="card.jsp" class="btn-limited">開逛!</a>
        </div>
    </section>

    <!-- 動態廣告區 -->
    <section class="dynamic-ad">
        <div class="ad-container">
            <button class="ad-nav left" onclick="prevAd()">&#8249;</button>
            <div class="ad-carousel">
                <div class="ad-slides" id="ad-slides">
                    <% for (int i = 0; i < adsList.size(); i++) { 
                        java.util.Map<String, String> ad = adsList.get(i); %>
                        <div class="ad-slide">
                            <a href="<%= ad.get("link") %>" target="_blank">
                                <img src="<%= ad.get("image") %>" alt="廣告圖片">
                            </a>
                            <div class="ad-text-overlay">
                                <p><%= ad.get("text") %></p>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
            <button class="ad-nav right" onclick="nextAd()">&#8250;</button>
        </div>
        
        <!-- 廣告指示器 -->
        <div class="ad-indicators">
            <% for (int i = 0; i < adsList.size(); i++) { %>
                <span class="indicator" onclick="goToSlide(<%= i %>)"></span>
            <% } %>
        </div>
    </section>

    <!-- 即時消息廣告板 -->
    <section class="announcement-board">
        <div class="container">
            <h2>最新消息</h2>
            <div class="announcements" id="announcements">
                <%
                    try {
                        conn = getConnection();
                        pstmt = conn.prepareStatement("SELECT title, content FROM announcements WHERE is_active = 1 ORDER BY created_at DESC LIMIT 10");
                        rs = pstmt.executeQuery();
                        
                        boolean hasAnnouncements = false;
                        while (rs.next()) {
                            hasAnnouncements = true;
                %>
                            <div class="announcement-item">
                                <span class="announcement-badge">公告</span>
                                <span class="announcement-text"><%= rs.getString("title") %>：<%= rs.getString("content") %></span>
                            </div>
                <%
                        }
                        
                        if (!hasAnnouncements) {
                %>
                        <div class="announcement-item">
                            <span class="announcement-badge">新品</span>
                            <span class="announcement-text">2024年最新NBA球員卡已上架！限時優惠中！</span>
                        </div>
                        <div class="announcement-item">
                            <span class="announcement-badge">促銷</span>
                            <span class="announcement-text">購買任意卡盒商品滿$3000免運費！</span>
                        </div>
                        <div class="announcement-item">
                            <span class="announcement-badge">活動</span>
                            <span class="announcement-text">會員介紹朋友註冊即可獲得100元購物金！</span>
                        </div>
                <%
                        }
                    } catch (Exception e) {
                        // 如果announcements表不存在，顯示默認訊息
                %>
                        <div class="announcement-item">
                            <span class="announcement-badge">新品</span>
                            <span class="announcement-text">2024年最新NBA球員卡已上架！限時優惠中！</span>
                        </div>
                        <div class="announcement-item">
                            <span class="announcement-badge">促銷</span>
                            <span class="announcement-text">購買任意卡盒商品滿$3000免運費！</span>
                        </div>
                        <div class="announcement-item">
                            <span class="announcement-badge">活動</span>
                            <span class="announcement-text">會員介紹朋友註冊即可獲得100元購物金！</span>
                        </div>
                <%
                    } finally {
                        closeResources(conn, pstmt, rs);
                    }
                %>
            </div>
        </div>
    </section>

    <!-- 網站統計信息 -->
    <section class="site-stats">
        <div class="container">
            <div class="stats-grid">
                <div class="stat-item">
                    <h3><%= visitCount %></h3>
                    <p>總訪問次數</p>
                </div>
                <div class="stat-item">
                    <h3><%= productCount %></h3>
                    <p>商品種類</p>
                </div>
                <div class="stat-item">
                    <h3><%= memberCount %></h3>
                    <p>註冊會員</p>
                </div>
                <div class="stat-item">
                    <h3><%= messageCount %></h3>
                    <p>客戶留言</p>
                </div>
            </div>
        </div>
    </section>

    <!-- 會員介紹連結 -->
    <section class="member-intro">
        <div class="container">
            <h2>會員專區</h2>
            <div class="member-benefits">
                <div class="benefit-item">
                    <img src="images/box_curry_1.jpg" alt="會員優惠" onerror="this.src='https://via.placeholder.com/100'">
                    <h3>💎 專屬優惠</h3>
                    <p>會員享有專屬折扣和優先購買權</p>
                </div>
                <div class="benefit-item">
                    <img src="images/member-benefit3.png" alt="生日優惠" onerror="this.src='https://via.placeholder.com/100'">
                    <h3>🎂 生日優惠</h3>
                    <p>生日月份享有特別折扣和生日禮品</p>
                </div>
            </div>
            <div class="member-actions">
                <a href="member.jsp" class="btn-member">會員登入</a>
                <a href="member.jsp" class="btn-register">立即註冊</a>
                <a href="member_area.jsp" class="btn-intro">會員介紹</a>
            </div>
        </div>
    </section>

    <!-- 引入統一的footer -->
    <%@ include file="footer.jsp" %>

    <script>
        // 廣告輪播功能
        var currentSlide = 0;
        var totalSlides = <%= adsList.size() %>;
        var slidesContainer;
        var indicators;
        var autoSlideInterval;

        function updateSlide() {
            var translateX = -currentSlide * 100;
            slidesContainer.style.transform = 'translateX(' + translateX + '%)';
            
            // 更新指示器
            for (var i = 0; i < indicators.length; i++) {
                if (i === currentSlide) {
                    indicators[i].classList.add('active');
                } else {
                    indicators[i].classList.remove('active');
                }
            }
        }

        function nextAd() {
            currentSlide = (currentSlide + 1) % totalSlides;
            updateSlide();
        }

        function prevAd() {
            currentSlide = (currentSlide - 1 + totalSlides) % totalSlides;
            updateSlide();
        }

        function goToSlide(index) {
            currentSlide = index;
            updateSlide();
        }

        function startAutoSlide() {
            autoSlideInterval = setInterval(nextAd, 5000);
        }

        function stopAutoSlide() {
            clearInterval(autoSlideInterval);
        }

        // 數字動畫
        function animateNumbers() {
            var statItems = document.querySelectorAll('.stat-item h3');
            statItems.forEach(function(item) {
                var finalNumber = parseInt(item.textContent);
                var currentNumber = 0;
                var increment = finalNumber / 50;
                
                var timer = setInterval(function() {
                    currentNumber += increment;
                    if (currentNumber >= finalNumber) {
                        currentNumber = finalNumber;
                        clearInterval(timer);
                    }
                    item.textContent = Math.floor(currentNumber);
                }, 50);
            });
        }

        // 頁面載入時執行
        document.addEventListener('DOMContentLoaded', function() {
            slidesContainer = document.getElementById('ad-slides');
            indicators = document.querySelectorAll('.indicator');
            
            updateSlide(); // 初始化輪播
            startAutoSlide(); // 開始自動輪播
            
            animateNumbers();
        });
    </script>
</body>
</html> 