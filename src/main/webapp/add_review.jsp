<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<%@ page import="java.sql.*" %>

<%
    // 檢查登入狀態
    Integer memberId = (Integer) session.getAttribute("memberId");
    String memberName = (String) session.getAttribute("memberName");
    
    if (memberId == null) {
        response.sendRedirect("member.jsp?message=" + java.net.URLEncoder.encode("請先登入才能留下評論", "UTF-8") + "&type=warning");
        return;
    }
    
    // 獲取表單資料
    String productIdStr = request.getParameter("product_id");
    String ratingStr = request.getParameter("rating");
    String comment = request.getParameter("comment");
    
    if (productIdStr == null || ratingStr == null || comment == null || comment.trim().isEmpty()) {
        response.sendRedirect("product_detail.jsp?id=" + productIdStr + 
                             "&message=" + java.net.URLEncoder.encode("評論資料不完整", "UTF-8") + 
                             "&type=error");
        return;
    }
    
    int productId = 0;
    int rating = 0;
    
    try {
        productId = Integer.parseInt(productIdStr);
        rating = Integer.parseInt(ratingStr);
        
        if (rating < 1 || rating > 5) {
            throw new NumberFormatException("評分必須在1-5之間");
        }
    } catch (NumberFormatException e) {
        response.sendRedirect("product_detail.jsp?id=" + productIdStr + 
                             "&message=" + java.net.URLEncoder.encode("無效的評分數據", "UTF-8") + 
                             "&type=error");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = getConnection();
        
        // 檢查是否已經評論過此產品
        String checkSql = "SELECT COUNT(*) FROM product_reviews WHERE product_id = ? AND member_id = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setInt(1, productId);
        pstmt.setInt(2, memberId);
        ResultSet rs = pstmt.executeQuery();
        
        if (rs.next() && rs.getInt(1) > 0) {
            response.sendRedirect("product_detail.jsp?id=" + productId + 
                                 "&message=" + java.net.URLEncoder.encode("您已經評論過此產品了", "UTF-8") + 
                                 "&type=warning");
            return;
        }
        rs.close();
        pstmt.close();
        
        // 插入新評論
        String insertSql = "INSERT INTO product_reviews (product_id, member_id, member_name, rating, comment, is_verified) VALUES (?, ?, ?, ?, ?, TRUE)";
        pstmt = conn.prepareStatement(insertSql);
        pstmt.setInt(1, productId);
        pstmt.setInt(2, memberId);
        pstmt.setString(3, memberName);
        pstmt.setInt(4, rating);
        pstmt.setString(5, comment.trim());
        
        int result = pstmt.executeUpdate();
        
        if (result > 0) {
            response.sendRedirect("product_detail.jsp?id=" + productId + 
                                 "&message=" + java.net.URLEncoder.encode("感謝您的評論！", "UTF-8") + 
                                 "&type=success");
        } else {
            response.sendRedirect("product_detail.jsp?id=" + productId + 
                                 "&message=" + java.net.URLEncoder.encode("評論提交失敗，請重試", "UTF-8") + 
                                 "&type=error");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("product_detail.jsp?id=" + productId + 
                             "&message=" + java.net.URLEncoder.encode("系統錯誤：" + e.getMessage(), "UTF-8") + 
                             "&type=error");
    } finally {
        closeResources(conn, pstmt, null);
    }
%> 