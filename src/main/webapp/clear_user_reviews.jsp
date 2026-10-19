<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<%@ page import="java.sql.*" %>

<%
    // 檢查登入狀態
    Integer memberId = (Integer) session.getAttribute("memberId");
    String memberName = (String) session.getAttribute("memberName");
    boolean isLoggedIn = memberId != null;
    
    if (!isLoggedIn) {
        response.sendRedirect("member.jsp?message=" + java.net.URLEncoder.encode("請先登入", "UTF-8") + "&type=warning");
        return;
    }
    
    String productIdStr = request.getParameter("product_id");
    String memberIdStr = request.getParameter("member_id");
    
    if (productIdStr == null || memberIdStr == null) {
        response.sendRedirect("test_review_logic.jsp?message=" + java.net.URLEncoder.encode("參數錯誤", "UTF-8") + "&type=error");
        return;
    }
    
    int productId = 0;
    int targetMemberId = 0;
    
    try {
        productId = Integer.parseInt(productIdStr);
        targetMemberId = Integer.parseInt(memberIdStr);
        
        // 安全檢查：只能刪除自己的評論
        if (targetMemberId != memberId) {
            response.sendRedirect("test_review_logic.jsp?message=" + java.net.URLEncoder.encode("權限不足", "UTF-8") + "&type=error");
            return;
        }
        
    } catch (NumberFormatException e) {
        response.sendRedirect("test_review_logic.jsp?message=" + java.net.URLEncoder.encode("參數格式錯誤", "UTF-8") + "&type=error");
        return;
    }
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = getConnection();
        
        // 刪除用戶對該商品的所有評論
        String deleteSQL = "DELETE FROM product_reviews WHERE product_id = ? AND member_id = ?";
        pstmt = conn.prepareStatement(deleteSQL);
        pstmt.setInt(1, productId);
        pstmt.setInt(2, memberId);
        
        int deletedRows = pstmt.executeUpdate();
        
        if (deletedRows > 0) {
            response.sendRedirect("test_review_logic.jsp?product_id=" + productId + 
                                 "&message=" + java.net.URLEncoder.encode("成功刪除 " + deletedRows + " 條評論", "UTF-8") + 
                                 "&type=success");
        } else {
            response.sendRedirect("test_review_logic.jsp?product_id=" + productId + 
                                 "&message=" + java.net.URLEncoder.encode("沒有找到要刪除的評論", "UTF-8") + 
                                 "&type=warning");
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("test_review_logic.jsp?product_id=" + productId + 
                             "&message=" + java.net.URLEncoder.encode("刪除失敗：" + e.getMessage(), "UTF-8") + 
                             "&type=error");
    } finally {
        closeResources(conn, pstmt, null);
    }
%> 