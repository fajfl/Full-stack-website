<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>資料庫連接測試</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            background: #f5f5f5;
        }
        .test-container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .success {
            color: green;
            background: #d4edda;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid green;
        }
        .error {
            color: red;
            background: #f8d7da;
            padding: 15px;
            border-radius: 5px;
            border-left: 4px solid red;
        }
        .info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin: 15px 0;
        }
		:root {
    --header-bg: #003da5; /* 標題欄藍色背景 */
    --text-color: white; /* 標題文字白色 */
    --search-bg: #ffffff; /* 搜尋欄背景顏色 */
    --search-border: #cccccc; /* 搜尋欄邊框顏色 */
    --search-placeholder: #888888; /* 搜尋欄占位文字顏色 */
    --search-button-bg: #ffffff; /* 搜尋按鈕背景顏色 */
    --search-button-color: white; /* 搜尋按鈕文字顏色 */
    --divider-color: #e0e0e0; /* 分隔線顏色 */
}

body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: #f9f9f9; /* 淺灰背景 */
}

.header-container {
    display: flex;
    justify-content: center; /* LOGO 和店名置中 */
    align-items: center; /* 垂直居中 */
    padding: 10px 20px;
    background-color: var(--header-bg);
    color: var(--text-color);
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
    position: relative; /* 使右側圖示可以絕對定位 */
}


.logo {
    display: flex;
    align-items: center;
    gap: 10px; /* LOGO 和標題間距 */
}

.logo img {
    height: 40px; /* LOGO 尺寸 */
    border-radius: 50%;
}

.logo h1 {
    font-size: 1.5rem;
}

/* 右側會員和購物車圖示 */
.nav-right {
    position: absolute;
    top: 50%;
    right: 20px; /* 靠右對齊 */
    transform: translateY(-50%);
    display: flex;
    gap: 40px; /* 增大圖示之間的間距 */
}

.nav-right a img {
    width: 30px;
    height: 30px;
    object-fit: contain;
}

/* 分類導航樣式 */
.nav-menu {
    background-color: var(--nav-bg);
    padding: 15px 0;
    box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
}

.nav-menu {
    animation: fadeInDown 1s ease-in-out;
}

@keyframes fadeInDown {
    from {
        opacity: 0;
        transform: translateY(-30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}


.nav-menu ul {
    list-style: none;
    margin: 0;
    padding: 0;
    display: flex;
    justify-content: center;
    gap: 30px;
}

.nav-menu ul li a {
    color: var(--nav-text-color);
    text-decoration: none;
    font-weight: bold;
    font-size: 16px;
    padding: 5px 15px;
    position: relative;
    overflow: hidden;
    display: inline-block;
    transition: all 0.4s ease; /* ✨加這行 */

    /* 可選：初始陰影淡淡的 */
    text-shadow: 0 0 2px rgba(0, 0, 0, 0.05);
}

.nav-menu ul li a:hover {
    transform: scale(1.1) rotate(-1deg); /* ✨加這行：微放大並旋轉 */
    text-shadow: 0 0 8px rgba(0, 61, 165, 0.6), 0 0 16px rgba(0, 61, 165, 0.4); /* ✨加這行：閃光感 */
}


.nav-menu ul li a::after {
    content: '';
    position: absolute;
    left: -100%;
    bottom: 0;
    width: 100%;
    height: 3px;
    background: linear-gradient(90deg, #00c3ff, #003da5); /* ✨更酷的底線漸層 */
    transform: skewX(-20deg);
    transition: all 0.4s ease; /* ✨更滑順 */
}

.nav-menu ul li a:hover::after {
    left: 0; /* ✨底線滑入動畫 */
}


.nav-menu ul li a:hover::after {
    transform: scaleX(1); /* 展開底線 */
    transform-origin: left;
}

.search-bar {
    display: flex;
    align-items: center;
}

.search-bar input {
    padding: 8px 12px;
    border: none;
    border-radius: 4px 0 0 4px;
    outline: none;
    width: 250px;
}

.search-bar button {
    padding: 8px 12px;
    background-color: #fff;
    border: none;
    border-radius: 0 4px 4px 0;
    cursor: pointer;
    border-left: 1px solid #ddd;
}



/* 會員下拉選單樣式 */
.member-section {
    position: relative;
    display: flex;
    align-items: center;
}

.member-section a {
    display: flex;
    align-items: center;
    gap: 8px;
    color: white;
    text-decoration: none;
    padding: 8px 12px;
    border-radius: 6px;
    transition: background-color 0.3s;
}

.member-section a:hover {
    background-color: rgba(255, 255, 255, 0.1);
}

.member-section span {
    font-size: 14px;
    font-weight: 500;
}

.member-dropdown {
    position: relative;
    display: inline-block;
}

.member-info {
    display: flex;
    align-items: center;
    gap: 8px;
    color: white;
    text-decoration: none;
    padding: 8px 12px;
    border-radius: 6px;
    transition: background-color 0.3s;
    cursor: pointer;
}

.member-info:hover {
    background-color: rgba(255, 255, 255, 0.1);
}

.dropdown-menu {
    position: absolute;
    top: 100%;
    right: 0;
    background: white;
    min-width: 160px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    border-radius: 8px;
    padding: 8px 0;
    margin-top: 8px;
    opacity: 0;
    visibility: hidden;
    transform: translateY(-10px);
    transition: all 0.3s ease;
    z-index: 1001;
}

.member-dropdown:hover .dropdown-menu {
    opacity: 1;
    visibility: visible;
    transform: translateY(0);
}

.dropdown-menu a {
    display: block;
    padding: 12px 16px;
    color: #333;
    text-decoration: none;
    font-size: 14px;
    transition: background-color 0.3s;
}

.dropdown-menu a:hover {
    background-color: #f8f9fa;
    color: #003da5;
}
    </style>
</head>
<body>
<!-- 引入統一的header -->
    <%@ include file="header.jsp" %>
    <div class="test-container">
        <h1>🗄️ 資料庫連接測試</h1>
        
        <%
            try {
                // 測試資料庫連接
                if (isDatabaseAvailable()) {
                    out.println("<div class='success'>");
                    out.println("<h3>✅ 資料庫連接成功！</h3>");
                    out.println("<p>系統已成功連接到MySQL資料庫。</p>");
                    
                    Connection conn = getConnection();
                    if (conn != null) {
                        DatabaseMetaData metaData = conn.getMetaData();
                        out.println("<div class='info'>");
                        out.println("<h4>📋 資料庫資訊：</h4>");
                        out.println("<p><strong>資料庫名稱：</strong>" + metaData.getDatabaseProductName() + "</p>");
                        out.println("<p><strong>版本：</strong>" + metaData.getDatabaseProductVersion() + "</p>");
                        out.println("<p><strong>驅動程式：</strong>" + metaData.getDriverName() + "</p>");
                        out.println("<p><strong>驅動版本：</strong>" + metaData.getDriverVersion() + "</p>");
                        out.println("</div>");
                        
                        // 測試查詢
                        PreparedStatement pstmt = conn.prepareStatement("SELECT COUNT(*) as count FROM information_schema.tables WHERE table_schema = 'nba_db'");
                        ResultSet rs = pstmt.executeQuery();
                        if (rs.next()) {
                            int tableCount = rs.getInt("count");
                            out.println("<p><strong>資料表數量：</strong>" + tableCount + "</p>");
                        }
                        rs.close();
                        pstmt.close();
                        conn.close();
                    }
                    out.println("</div>");
                    
                    out.println("<div style='margin-top: 20px;'>");
                    out.println("<a href='index.jsp' style='background: #003da5; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px;'>返回首頁</a>");
                    out.println("<a href='db_status.jsp' style='background: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin-left: 10px;'>詳細檢查</a>");
                    out.println("</div>");
                    
                } else {
                    out.println("<div class='error'>");
                    out.println("<h3>❌ 資料庫連接失敗</h3>");
                    out.println("<p>無法連接到資料庫。請檢查以下項目：</p>");
                    out.println("<ul>");
                    out.println("<li>MySQL伺服器是否正在運行</li>");
                    out.println("<li>資料庫名稱是否為 'nba_db'</li>");
                    out.println("<li>用戶名和密碼是否正確</li>");
                    out.println("<li>JDBC驅動程式是否已安裝</li>");
                    out.println("</ul>");
                    out.println("</div>");
                    
                    out.println("<div style='margin-top: 20px;'>");
                    out.println("<button onclick='location.reload()' style='background: #dc3545; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer;'>重新測試</button>");
                    out.println("</div>");
                }
            } catch (Exception e) {
                out.println("<div class='error'>");
                out.println("<h3>❌ 測試過程中發生錯誤</h3>");
                out.println("<p><strong>錯誤訊息：</strong>" + e.getMessage() + "</p>");
                out.println("</div>");
            }
        %>
        
        <div style="margin-top: 30px; text-align: center;">
            <p><small>🕒 測試時間：<%= new java.util.Date() %></small></p>
        </div>
    </div>
</body>
</html> 