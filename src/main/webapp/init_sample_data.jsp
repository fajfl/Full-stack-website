<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<%@ page import="java.sql.*" %>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = getConnection();
        if (conn != null) {
            // 建立示例商品資料
            String sql = "INSERT IGNORE INTO product (product_id, category_id, product_name, price, stock, main_image, description, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
            pstmt = conn.prepareStatement(sql);
            
            // 單卡商品 (category_id = 1)
            String[][] cardProducts = {
                {"1", "1", "LeBron James 新秀卡", "25000", "3", "images/jordan.jpg", "LeBron James 限量收藏卡，稀有度極高"},
                {"2", "1", "Michael Jordan 簽名卡", "89000", "1", "images/s1.jpg", "喬丹親筆簽名卡，傳奇收藏品"},
                {"3", "1", "Kobe Bryant 紀念卡", "32000", "5", "images/mustcard.jpg", "Kobe Bryant 限量紀念卡"}
            };
            
            // 卡盒商品 (category_id = 2)
            String[][] boxProducts = {
                {"11", "2", "NBA 2024 精選卡盒", "3500", "8", "images/s4.jpg", "包含10張精選球員卡，機率獲得傳奇卡片"},
                {"12", "2", "冠軍收藏卡盒", "5200", "12", "images/s5.jpg", "冠軍球隊專屬卡盒，包含15張卡片"},
                {"13", "2", "新秀特別版卡盒", "2800", "20", "images/a.jpg", "新秀球員主題卡盒，12張卡片"}
            };
            
            // 周邊商品 (category_id = 3)
            String[][] accessoryProducts = {
                {"21", "3", "專業卡冊", "850", "15", "images/i.jpg", "高品質收藏卡冊，可存放180張卡片"},
                {"22", "3", "保護套組合", "420", "30", "images/J.jpg", "100張專業保護套，防水防塵"},
                {"23", "3", "展示盒", "1200", "8", "images/max (1).jpg", "壓克力展示盒，完美展示珍藏卡片"}
            };
            
            // 特別商品 (category_id = 4)
            String[][] specialProducts = {
                {"31", "4", "Michael Jordan 親筆簽名卡", "150000", "2", "images/jordan.jpg", "喬丹親筆簽名限量版收藏卡，全球僅發行100張"},
                {"32", "4", "Lakers 冠軍紀念套組", "8500", "5", "images/s1.jpg", "Lakers 2020冠軍紀念品套組"},
                {"33", "4", "NBA 75週年限量卡", "12000", "3", "images/mustcard.jpg", "NBA 75週年紀念限量卡片"}
            };
            
            // 插入單卡商品
            for (String[] product : cardProducts) {
                pstmt.setInt(1, Integer.parseInt(product[0]));
                pstmt.setInt(2, Integer.parseInt(product[1]));
                pstmt.setString(3, product[2]);
                pstmt.setDouble(4, Double.parseDouble(product[3]));
                pstmt.setInt(5, Integer.parseInt(product[4]));
                pstmt.setString(6, product[5]);
                pstmt.setString(7, product[6]);
                pstmt.executeUpdate();
            }
            
            // 插入卡盒商品
            for (String[] product : boxProducts) {
                pstmt.setInt(1, Integer.parseInt(product[0]));
                pstmt.setInt(2, Integer.parseInt(product[1]));
                pstmt.setString(3, product[2]);
                pstmt.setDouble(4, Double.parseDouble(product[3]));
                pstmt.setInt(5, Integer.parseInt(product[4]));
                pstmt.setString(6, product[5]);
                pstmt.setString(7, product[6]);
                pstmt.executeUpdate();
            }
            
            // 插入周邊商品
            for (String[] product : accessoryProducts) {
                pstmt.setInt(1, Integer.parseInt(product[0]));
                pstmt.setInt(2, Integer.parseInt(product[1]));
                pstmt.setString(3, product[2]);
                pstmt.setDouble(4, Double.parseDouble(product[3]));
                pstmt.setInt(5, Integer.parseInt(product[4]));
                pstmt.setString(6, product[5]);
                pstmt.setString(7, product[6]);
                pstmt.executeUpdate();
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
            }
            
            out.println("<h2>示例資料初始化完成！</h2>");
            out.println("<p>已成功添加12個示例商品</p>");
            out.println("<ul>");
            out.println("<li>單卡商品：3個</li>");
            out.println("<li>卡盒商品：3個</li>");
            out.println("<li>周邊商品：3個</li>");
            out.println("<li>特別商品：3個</li>");
            out.println("</ul>");
            out.println("<a href='index.jsp'>返回首頁</a>");
            
        } else {
            out.println("<h2>資料庫連接失敗</h2>");
            out.println("<p>無法連接到資料庫，請檢查資料庫設定</p>");
        }
        
    } catch (Exception e) {
        out.println("<h2>初始化過程中發生錯誤</h2>");
        out.println("<p>錯誤訊息：" + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        closeResources(conn, pstmt, null);
    }
%> 