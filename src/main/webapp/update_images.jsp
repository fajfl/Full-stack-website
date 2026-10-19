<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <title>更新商品圖片路徑</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .success { color: green; font-weight: bold; }
        .error { color: red; font-weight: bold; }
    </style>
</head>
<body>
    <h1>更新商品圖片路徑</h1>
    
    <%
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = getConnection();
        out.println("<p class='success'>✓ 資料庫連接成功！</p>");
        
        // 執行圖片路徑更新
        String[] updateQueries = {
            // 單卡類別
            "UPDATE product SET main_image = 'images/jordan.jpg', image_2 = 'images/s1.jpg', image_3 = 'images/s2.jpg' WHERE product_id = 1",
            "UPDATE product SET main_image = 'images/messageImage_1734975466982.jpg', image_2 = 'images/messageImage_1734975325339.jpg' WHERE product_id = 2",
            "UPDATE product SET main_image = 'images/mustcard.jpg', image_2 = 'images/must.jpg', image_3 = 'images/s3.jpg' WHERE product_id = 3",
            "UPDATE product SET main_image = 'images/messageImage_1734975121418.jpg', image_2 = 'images/s4.jpg' WHERE product_id = 4",
            "UPDATE product SET main_image = 'images/messageImage_1734975046035.jpg', image_2 = 'images/s5.jpg', image_3 = 'images/a.jpg' WHERE product_id = 5",
            "UPDATE product SET main_image = 'images/messageImage_1734974795496.jpg', image_2 = 'images/messageImage_1734974637632.jpg' WHERE product_id = 6",
            "UPDATE product SET main_image = 'images/messageImage_1734973070759.jpg', image_2 = 'images/messageImage_1734972793441.jpg' WHERE product_id = 7",
            "UPDATE product SET main_image = 'images/i.jpg', image_2 = 'images/J.jpg', image_3 = 'images/sj.jpg' WHERE product_id = 8",
            
            // 卡盒類別
            "UPDATE product SET main_image = 'images/box.jpg', image_2 = 'images/box2.jpg', image_3 = 'images/box3.jpg', image_4 = 'images/box4.jpg' WHERE product_id = 11",
            "UPDATE product SET main_image = 'images/box5.jpg', image_2 = 'images/mustpack.jpg' WHERE product_id = 12",
            "UPDATE product SET main_image = 'images/porzingis.webp', image_2 = 'images/t77.jpg', image_3 = 'images/lin.jpg' WHERE product_id = 13",
            "UPDATE product SET main_image = 'images/book.jpg', image_2 = 'images/m.jpg' WHERE product_id = 14",
            
            // 周邊類別
            "UPDATE product SET main_image = 'images/White1.jpeg', image_2 = 'images/White2.jpeg' WHERE product_id = 21",
            "UPDATE product SET main_image = 'images/jayson1.jpeg', image_2 = 'images/jayson2.jpeg', image_3 = 'images/jayson3.jpeg' WHERE product_id = 22",
            "UPDATE product SET main_image = 'images/brown1.jpeg', image_2 = 'images/brown2.jpeg' WHERE product_id = 23",
            "UPDATE product SET main_image = 'images/jrue1.jpeg', image_2 = 'images/jrue2.jpeg', image_3 = 'images/jrue3.jpeg' WHERE product_id = 24",
            
            // 特別商品類別
            "UPDATE product SET main_image = 'images/basketball.jpg', image_2 = 'images/special.jpg', image_3 = 'images/nba.png' WHERE product_id = 31",
            "UPDATE product SET main_image = 'images/max (1).jpg', image_2 = 'images/max (3).jpg', image_3 = 'images/S__6520835.jpg', image_4 = 'images/S__10051621.jpg' WHERE product_id = 32",
            "UPDATE product SET main_image = 'images/69876.jpg', image_2 = 'images/AD3.jpg' WHERE product_id = 33",
            "UPDATE product SET main_image = 'images/014842f3-572f-4bf3-974d-24d239eb8682.webp', image_2 = 'images/brown3.jpeg', image_3 = 'images/box3.jpg' WHERE product_id = 34"
        };
        
        int updateCount = 0;
        for (String sql : updateQueries) {
            try {
                pstmt = conn.prepareStatement(sql);
                int result = pstmt.executeUpdate();
                if (result > 0) {
                    updateCount++;
                }
                pstmt.close();
            } catch (Exception e) {
                out.println("<p class='error'>✗ 執行更新失敗：" + e.getMessage() + "</p>");
            }
        }
        
        out.println("<p class='success'>✓ 成功更新 " + updateCount + " 筆商品圖片路徑！</p>");
        out.println("<h2>更新完成！</h2>");
        out.println("<p><a href='test_db.jsp'>查看更新結果</a></p>");
        out.println("<p><a href='card.jsp'>測試單卡頁面</a></p>");
        out.println("<p><a href='index.jsp'>返回首頁</a></p>");
        
    } catch (Exception e) {
        out.println("<p class='error'>✗ 發生錯誤：" + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        closeResources(conn, pstmt, null);
    }
    %>
</body>
</html> 