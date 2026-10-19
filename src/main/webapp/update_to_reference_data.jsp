<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <title>更新至參考資料庫規格</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
        .info { color: blue; }
    </style>
</head>
<body>
    <h1>更新至參考資料庫規格</h1>
    <p>根據您的圖片命名規則，更新產品名稱、價格和描述以匹配參考資料庫</p>
    
    <%
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = getConnection();
        out.println("<p class='success'>✓ 資料庫連接成功！</p>");
        
        // 更新產品資料以匹配參考資料庫
        String[] updateQueries = {
            // 根據圖片命名更新單卡產品 (i.jpg = 姚明, J.jpg = Edwards, etc.)
            "UPDATE product SET product_name = '姚明 Yao Ming 復古經典卡', price = 1500, description = '姚明經典復古收藏卡，NBA中國第一人' WHERE main_image LIKE '%i.jpg%'",
            "UPDATE product SET product_name = 'Anthony Edwards 新秀卡', price = 1200, description = 'Anthony Edwards 2021新秀卡，未來之星' WHERE main_image LIKE '%J.jpg%'",
            "UPDATE product SET product_name = 'Devin Booker 太陽之子', price = 1300, description = 'Devin Booker 菲尼克斯太陽隊王牌' WHERE main_image LIKE '%book.jpg%'",
            "UPDATE product SET product_name = 'Donovan Mitchell 爵士核心', price = 1400, description = 'Donovan Mitchell 猶他爵士隊得分王' WHERE main_image LIKE '%m.jpg%'",
            "UPDATE product SET product_name = '字母哥 Giannis 冠軍卡', price = 1800, description = 'Giannis Antetokounmpo 2021冠軍紀念卡' WHERE main_image LIKE '%a.jpg%'",
            "UPDATE product SET product_name = '林書豪 Jeremy Lin 亞洲之光', price = 1100, description = '林書豪 Linsanity 經典時刻收藏卡' WHERE main_image LIKE '%lin.jpg%'",
            "UPDATE product SET product_name = 'SGA 雷霆新星', price = 1600, description = 'Shai Gilgeous-Alexander 俄克拉荷馬城雷霆新星' WHERE main_image LIKE '%sj.jpg%'",
            "UPDATE product SET product_name = 'Luka Dončić 獨行俠王牌', price = 2000, description = 'Luka Dončić 達拉斯獨行俠未來巨星' WHERE main_image LIKE '%t77.jpg%'",
            
            // 更新卡盒產品 (根據messageImage文件名)
            "UPDATE product SET product_name = 'Irving 魔術師卡盒', price = 2800, description = 'Kyrie Irving 限量卡盒，包含10張精選卡片' WHERE main_image LIKE '%messageImage_1734975466982.jpg%'",
            "UPDATE product SET product_name = 'KD 杜蘭特傳奇卡盒', price = 3500, description = 'Kevin Durant 職業生涯精選卡盒' WHERE main_image LIKE '%messageImage_1734975325339.jpg%'",
            "UPDATE product SET product_name = 'Curry 三分王卡盒', price = 4200, description = 'Stephen Curry 三分球王者主題卡盒' WHERE main_image LIKE '%messageImage_1734975121418.jpg%'",
            "UPDATE product SET product_name = 'WNBA 女子籃球卡盒', price = 3000, description = 'WNBA 女子職業籃球聯盟精選卡盒' WHERE main_image LIKE '%messageImage_1734975046035.jpg%'",
            "UPDATE product SET product_name = 'Kobe 曼巴精神卡盒', price = 6000, description = 'Kobe Bryant 曼巴精神紀念卡盒' WHERE main_image LIKE '%messageImage_1734974795496.jpg%'",
            "UPDATE product SET product_name = 'Edward 狼王卡盒', price = 3200, description = 'Anthony Edwards 明尼蘇達灰狼主題卡盒' WHERE main_image LIKE '%messageImage_1734974637632.jpg%'",
            "UPDATE product SET product_name = 'Luka Dončić 歐洲魔術師卡盒', price = 4500, description = 'Luka Dončić 歐洲籃球巨星卡盒' WHERE main_image LIKE '%messageImage_1734973070759.jpg%'",
            "UPDATE product SET product_name = 'LeBron 詹皇傳奇卡盒', price = 5500, description = 'LeBron James 四冠王傳奇卡盒' WHERE main_image LIKE '%messageImage_1734972793441.jpg%'",
            
            // 更新周邊產品 (根據box系列文件名)
            "UPDATE product SET product_name = '專業卡片保護套', price = 150, description = '高品質透明保護套，100張裝' WHERE main_image LIKE '%box.jpg%' AND main_image NOT LIKE '%box2%' AND main_image NOT LIKE '%box3%' AND main_image NOT LIKE '%box4%' AND main_image NOT LIKE '%box5%'",
            "UPDATE product SET product_name = '收藏卡冊豪華版', price = 800, description = '豪華收藏卡冊，可存放200張卡片' WHERE main_image LIKE '%box2.jpg%'",
            "UPDATE product SET product_name = '卡片收納盒大容量', price = 600, description = '大容量收納盒，完美整理您的收藏' WHERE main_image LIKE '%box3.jpg%'",
            "UPDATE product SET product_name = '卡片清潔護理套裝', price = 350, description = '專業卡片清潔用品套裝' WHERE main_image LIKE '%box4.jpg%'",
            "UPDATE product SET product_name = '頂級展示框架', price = 1200, description = '頂級壓克力展示框架，完美展示珍藏' WHERE main_image LIKE '%box5.jpg%'",
            
            // 更新特別商品 (根據s系列文件名)
            "UPDATE product SET product_name = '2024 巴黎奧運紀念卡', price = 8800, description = '2024巴黎奧運會NBA球星紀念卡限量版' WHERE main_image LIKE '%s1.jpg%'",
            "UPDATE product SET product_name = 'NBA 里程碑傳奇卡', price = 15000, description = 'NBA歷史里程碑時刻紀念收藏卡' WHERE main_image LIKE '%s2.jpg%'",
            "UPDATE product SET product_name = '球星親筆簽名卡', price = 25000, description = '現役球星親筆簽名限量收藏卡' WHERE main_image LIKE '%s3.jpg%'",
            "UPDATE product SET product_name = '冠軍戒指複刻紀念套組', price = 35000, description = 'NBA冠軍戒指1:1複刻紀念套組' WHERE main_image LIKE '%s4.jpg%'",
            "UPDATE product SET product_name = '傳奇球衣退役紀念卡', price = 50000, description = '傳奇球星球衣退役儀式紀念卡至尊版' WHERE main_image LIKE '%s5.jpg%'"
        };
        
        int updateCount = 0;
        int totalAffected = 0;
        
        for (String sql : updateQueries) {
            try {
                pstmt = conn.prepareStatement(sql);
                int result = pstmt.executeUpdate();
                if (result > 0) {
                    updateCount++;
                    totalAffected += result;
                    // 顯示更新的產品資訊
                    if (sql.contains("i.jpg")) out.println("<p class='info'>✓ 更新姚明卡片 (i.jpg)</p>");
                    else if (sql.contains("J.jpg")) out.println("<p class='info'>✓ 更新Edwards卡片 (J.jpg)</p>");
                    else if (sql.contains("book.jpg")) out.println("<p class='info'>✓ 更新Booker卡片 (book.jpg)</p>");
                    else if (sql.contains("m.jpg")) out.println("<p class='info'>✓ 更新Mitchell卡片 (m.jpg)</p>");
                    else if (sql.contains("a.jpg")) out.println("<p class='info'>✓ 更新字母哥卡片 (a.jpg)</p>");
                    else if (sql.contains("lin.jpg")) out.println("<p class='info'>✓ 更新林書豪卡片 (lin.jpg)</p>");
                    else if (sql.contains("sj.jpg")) out.println("<p class='info'>✓ 更新SGA卡片 (sj.jpg)</p>");
                    else if (sql.contains("t77.jpg")) out.println("<p class='info'>✓ 更新Luka卡片 (t77.jpg)</p>");
                    else if (sql.contains("messageImage")) out.println("<p class='info'>✓ 更新卡盒產品</p>");
                    else if (sql.contains("box")) out.println("<p class='info'>✓ 更新周邊產品</p>");
                    else if (sql.contains("s1.jpg") || sql.contains("s2.jpg") || sql.contains("s3.jpg") || sql.contains("s4.jpg") || sql.contains("s5.jpg")) out.println("<p class='info'>✓ 更新特別商品</p>");
                }
                pstmt.close();
            } catch (Exception e) {
                out.println("<p class='error'>✗ 執行更新失敗：" + e.getMessage() + "</p>");
            }
        }
        
        out.println("<p class='success'>✓ 成功執行 " + updateCount + " 個更新查詢，影響 " + totalAffected + " 筆記錄！</p>");
        
        // 顯示更新摘要
        out.println("<h2>更新摘要：</h2>");
        out.println("<h3>圖片命名規則對應：</h3>");
        out.println("<ul>");
        out.println("<li><strong>單卡 (NT$1,100-2,000)：</strong></li>");
        out.println("<ul>");
        out.println("<li>i.jpg → 姚明 (NT$1,500)</li>");
        out.println("<li>J.jpg → Anthony Edwards (NT$1,200)</li>");
        out.println("<li>book.jpg → Devin Booker (NT$1,300)</li>");
        out.println("<li>m.jpg → Donovan Mitchell (NT$1,400)</li>");
        out.println("<li>a.jpg → 字母哥 Giannis (NT$1,800)</li>");
        out.println("<li>lin.jpg → 林書豪 (NT$1,100)</li>");
        out.println("<li>sj.jpg → SGA (NT$1,600)</li>");
        out.println("<li>t77.jpg → Luka Dončić (NT$2,000)</li>");
        out.println("</ul>");
        
        out.println("<li><strong>卡盒 (NT$2,800-6,000)：</strong></li>");
        out.println("<ul>");
        out.println("<li>messageImage_*466982.jpg → Irving (NT$2,800)</li>");
        out.println("<li>messageImage_*325339.jpg → KD (NT$3,500)</li>");
        out.println("<li>messageImage_*121418.jpg → Curry (NT$4,200)</li>");
        out.println("<li>messageImage_*046035.jpg → WNBA (NT$3,000)</li>");
        out.println("<li>messageImage_*795496.jpg → Kobe (NT$6,000)</li>");
        out.println("<li>messageImage_*637632.jpg → Edward (NT$3,200)</li>");
        out.println("<li>messageImage_*070759.jpg → Luka (NT$4,500)</li>");
        out.println("<li>messageImage_*793441.jpg → LeBron (NT$5,500)</li>");
        out.println("</ul>");
        
        out.println("<li><strong>周邊 (NT$150-1,200)：</strong></li>");
        out.println("<ul>");
        out.println("<li>box.jpg → 保護套 (NT$150)</li>");
        out.println("<li>box2.jpg → 卡冊 (NT$800)</li>");
        out.println("<li>box3.jpg → 收納盒 (NT$600)</li>");
        out.println("<li>box4.jpg → 清潔套裝 (NT$350)</li>");
        out.println("<li>box5.jpg → 展示框架 (NT$1,200)</li>");
        out.println("</ul>");
        
        out.println("<li><strong>特別商品 (NT$8,800-50,000)：</strong></li>");
        out.println("<ul>");
        out.println("<li>s1.jpg → 奧運紀念卡 (NT$8,800)</li>");
        out.println("<li>s2.jpg → 里程碑傳奇卡 (NT$15,000)</li>");
        out.println("<li>s3.jpg → 親筆簽名卡 (NT$25,000)</li>");
        out.println("<li>s4.jpg → 冠軍戒指複刻 (NT$35,000)</li>");
        out.println("<li>s5.jpg → 球衣退役紀念卡 (NT$50,000)</li>");
        out.println("</ul>");
        out.println("</ul>");
        
        out.println("<p><a href='index.jsp'>查看首頁</a> | <a href='test_db.jsp'>查看更新結果</a> | <a href='card.jsp'>測試單卡頁面</a></p>");
        
    } catch (Exception e) {
        out.println("<p class='error'>✗ 發生錯誤：" + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        closeResources(conn, pstmt, null);
    }
    %>
</body>
</html> 