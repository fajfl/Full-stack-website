<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <title>自動匯入參考資料庫產品</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        .info { color: blue; }
    </style>
</head>
<body>
    <h1>自動匯入參考資料庫產品</h1>
    
    <%
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = getConnection();
        out.println("<p class='success'>✓ 資料庫連接成功！</p>");
        
        // 首先清空現有產品資料
        String deleteSql = "DELETE FROM product";
        pstmt = conn.prepareStatement(deleteSql);
        int deletedCount = pstmt.executeUpdate();
        out.println("<p class='info'>刪除了 " + deletedCount + " 筆舊資料</p>");
        pstmt.close();
        
        // 準備插入語句
        String insertSql = "INSERT INTO product (product_id, category_id, product_name, price, stock, main_image, description, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
        pstmt = conn.prepareStatement(insertSql);
        
        int productCount = 0;
        
        // 單卡商品 (category_id = 1) - 根據參考資料
        String[][] singleCards = {
            {"1", "1", "姚明 Yao Ming 復古經典卡", "1500", "10", "images/i.jpg", "姚明經典復古收藏卡，NBA中國第一人"},
            {"2", "1", "Anthony Edwards 新秀卡", "1200", "15", "images/J.jpg", "Anthony Edwards 2021新秀卡，未來之星"},
            {"3", "1", "Devin Booker 太陽之子", "1300", "12", "images/book.jpg", "Devin Booker 菲尼克斯太陽隊王牌"},
            {"4", "1", "Donovan Mitchell 爵士核心", "1400", "8", "images/m.jpg", "Donovan Mitchell 猶他爵士隊得分王"},
            {"5", "1", "字母哥 Giannis 冠軍卡", "1800", "6", "images/a.jpg", "Giannis Antetokounmpo 2021冠軍紀念卡"},
            {"6", "1", "林書豪 Jeremy Lin 亞洲之光", "1100", "20", "images/lin.jpg", "林書豪 Linsanity 經典時刻收藏卡"},
            {"7", "1", "SGA 雷霆新星", "1600", "9", "images/sj.jpg", "Shai Gilgeous-Alexander 俄克拉荷馬城雷霆新星"},
            {"8", "1", "Luka Dončić 獨行俠王牌", "2000", "5", "images/t77.jpg", "Luka Dončić 達拉斯獨行俠未來巨星"}
        };
        
        // 卡盒商品 (category_id = 2)
        String[][] cardBoxes = {
            {"11", "2", "Irving 魔術師卡盒", "2800", "12", "images/messageImage_1734975466982.jpg", "Kyrie Irving 限量卡盒，包含10張精選卡片"},
            {"12", "2", "KD 杜蘭特傳奇卡盒", "3500", "8", "images/messageImage_1734975325339.jpg", "Kevin Durant 職業生涯精選卡盒"},
            {"13", "2", "Curry 三分王卡盒", "4200", "10", "images/messageImage_1734975121418.jpg", "Stephen Curry 三分球王者主題卡盒"},
            {"14", "2", "WNBA 女子籃球卡盒", "3000", "15", "images/messageImage_1734975046035.jpg", "WNBA 女子職業籃球聯盟精選卡盒"},
            {"15", "2", "Kobe 曼巴精神卡盒", "6000", "5", "images/messageImage_1734974795496.jpg", "Kobe Bryant 曼巴精神紀念卡盒"},
            {"16", "2", "Edward 狼王卡盒", "3200", "9", "images/messageImage_1734974637632.jpg", "Anthony Edwards 明尼蘇達灰狼主題卡盒"},
            {"17", "2", "Luka Dončić 歐洲魔術師卡盒", "4500", "7", "images/messageImage_1734973070759.jpg", "Luka Dončić 歐洲籃球巨星卡盒"},
            {"18", "2", "LeBron 詹皇傳奇卡盒", "5500", "6", "images/messageImage_1734972793441.jpg", "LeBron James 四冠王傳奇卡盒"}
        };
        
        // 周邊商品 (category_id = 3)
        String[][] accessories = {
            {"21", "3", "專業卡片保護套", "150", "50", "images/box.jpg", "高品質透明保護套，100張裝"},
            {"22", "3", "收藏卡冊豪華版", "800", "20", "images/box2.jpg", "豪華收藏卡冊，可存放200張卡片"},
            {"23", "3", "卡片收納盒大容量", "600", "25", "images/box3.jpg", "大容量收納盒，完美整理您的收藏"},
            {"24", "3", "卡片清潔護理套裝", "350", "30", "images/box4.jpg", "專業卡片清潔用品套裝"},
            {"25", "3", "頂級展示框架", "1200", "12", "images/box5.jpg", "頂級壓克力展示框架，完美展示珍藏"}
        };
        
        // 特別商品 (category_id = 4)
        String[][] specialProducts = {
            {"31", "4", "2024 巴黎奧運紀念卡", "8800", "10", "images/s1.jpg", "2024巴黎奧運會NBA球星紀念卡限量版"},
            {"32", "4", "NBA 里程碑傳奇卡", "15000", "5", "images/s2.jpg", "NBA歷史里程碑時刻紀念收藏卡"},
            {"33", "4", "球星親筆簽名卡", "25000", "3", "images/s3.jpg", "現役球星親筆簽名限量收藏卡"},
            {"34", "4", "冠軍戒指複刻紀念套組", "35000", "2", "images/s4.jpg", "NBA冠軍戒指1:1複刻紀念套組"},
            {"35", "4", "傳奇球衣退役紀念卡", "50000", "1", "images/s5.jpg", "傳奇球星球衣退役儀式紀念卡至尊版"}
        };
        
        // 插入單卡商品
        for (String[] product : singleCards) {
            pstmt.setInt(1, Integer.parseInt(product[0]));
            pstmt.setInt(2, Integer.parseInt(product[1]));
            pstmt.setString(3, product[2]);
            pstmt.setDouble(4, Double.parseDouble(product[3]));
            pstmt.setInt(5, Integer.parseInt(product[4]));
            pstmt.setString(6, product[5]);
            pstmt.setString(7, product[6]);
            pstmt.executeUpdate();
            productCount++;
        }
        
        // 插入卡盒商品
        for (String[] product : cardBoxes) {
            pstmt.setInt(1, Integer.parseInt(product[0]));
            pstmt.setInt(2, Integer.parseInt(product[1]));
            pstmt.setString(3, product[2]);
            pstmt.setDouble(4, Double.parseDouble(product[3]));
            pstmt.setInt(5, Integer.parseInt(product[4]));
            pstmt.setString(6, product[5]);
            pstmt.setString(7, product[6]);
            pstmt.executeUpdate();
            productCount++;
        }
        
        // 插入周邊商品
        for (String[] product : accessories) {
            pstmt.setInt(1, Integer.parseInt(product[0]));
            pstmt.setInt(2, Integer.parseInt(product[1]));
            pstmt.setString(3, product[2]);
            pstmt.setDouble(4, Double.parseDouble(product[3]));
            pstmt.setInt(5, Integer.parseInt(product[4]));
            pstmt.setString(6, product[5]);
            pstmt.setString(7, product[6]);
            pstmt.executeUpdate();
            productCount++;
        }
        
        // 插入特別商品
        for (String[] product : specialProducts) {
            pstmt.setInt(1, Integer.parseInt(product[0]));
            pstmt.setInt(2, Integer.parseInt(product[1]));
            pstmt.setString(3, product[2]);
            pstmt.setDouble(4, Double.parseDouble(product[3]));
            pstmt.setInt(5, Integer.parseInt(product[4]));
            pstmt.setString(6, product[5]);
            pstmt.setString(7, product[6]);
            pstmt.executeUpdate();
            productCount++;
        }
        
        out.println("<p class='success'>✓ 成功匯入 " + productCount + " 個參考產品！</p>");
        out.println("<h2>匯入完成統計：</h2>");
        out.println("<ul>");
        out.println("<li><strong>單卡商品：</strong>8個 (姚明、Edwards、Booker、Mitchell、字母哥、林書豪、SGA、Luka)</li>");
        out.println("<li><strong>卡盒商品：</strong>8個 (Irving、KD、Curry、WNBA、Kobe、Edward、Luka、LeBron)</li>");
        out.println("<li><strong>周邊商品：</strong>5個 (保護套、卡冊、收納盒、清潔套裝、展示框)</li>");
        out.println("<li><strong>特別商品：</strong>5個 (奧運紀念、里程碑、簽名卡、戒指複刻、球衣退役)</li>");
        out.println("</ul>");
        
        out.println("<h3>圖片對應關係：</h3>");
        out.println("<p><strong>單卡：</strong>i.jpg(姚明), J.jpg(Edwards), book.jpg(Booker), m.jpg(Mitchell), a.jpg(字母哥), lin.jpg(林書豪), sj.jpg(SGA), t77.jpg(Luka)</p>");
        out.println("<p><strong>卡盒：</strong>messageImage_*.jpg 系列圖片</p>");
        out.println("<p><strong>周邊：</strong>box.jpg, box2.jpg, box3.jpg, box4.jpg, box5.jpg</p>");
        out.println("<p><strong>特別：</strong>s1.jpg, s2.jpg, s3.jpg, s4.jpg, s5.jpg</p>");
        
        out.println("<p><a href='index.jsp'>查看首頁</a> | <a href='card.jsp'>查看單卡</a> | <a href='card_box.jsp'>查看卡盒</a></p>");
        
    } catch (Exception e) {
        out.println("<p class='error'>✗ 發生錯誤：" + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        closeResources(conn, pstmt, null);
    }
    %>
</body>
</html> 