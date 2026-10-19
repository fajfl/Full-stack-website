<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>搜尋結果 - NBA卡包商城</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/search_results.css">
</head>
<body>
    <%
    // 獲取搜尋關鍵字
    String query = request.getParameter("query");
    if (query == null) {
        query = "";
    }
    query = query.trim();
    
    // 檢查登入狀態（使用不同變數名避免衝突）
    Integer searchMemberId = (Integer) session.getAttribute("memberId");
    String searchMemberName = (String) session.getAttribute("memberName");
    boolean searchIsLoggedIn = searchMemberId != null;
    
    // 分頁參數
    int pageSize = 12;
    int searchCurrentPage = 1;
    try {
        searchCurrentPage = Integer.parseInt(request.getParameter("page"));
        if (searchCurrentPage < 1) searchCurrentPage = 1;
    } catch (Exception e) {
        searchCurrentPage = 1;
    }
    int offset = (searchCurrentPage - 1) * pageSize;
    
    // 搜尋結果
    java.util.List<java.util.Map<String, Object>> searchResults = new java.util.ArrayList<>();
    int totalResults = 0;
    
    if (!query.isEmpty()) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            
            // 計算總結果數
            String countSql = "SELECT COUNT(*) as total FROM product p " +
                            "WHERE (p.product_name LIKE ? OR p.description LIKE ? OR p.player_name LIKE ?) " +
                            "AND p.stock > 0";
            pstmt = conn.prepareStatement(countSql);
            String searchPattern = "%" + query + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                totalResults = rs.getInt("total");
            }
            rs.close();
            pstmt.close();
            
            // 獲取搜尋結果
            String searchSql = "SELECT p.product_id, p.product_name, p.description, p.price, p.stock, " +
                             "p.main_image, p.player_name, p.team, p.rarity, c.category_name " +
                             "FROM product p LEFT JOIN category c ON p.category_id = c.category_id " +
                             "WHERE (p.product_name LIKE ? OR p.description LIKE ? OR p.player_name LIKE ?) " +
                             "AND p.stock > 0 " +
                             "ORDER BY p.product_name LIMIT ? OFFSET ?";
            pstmt = conn.prepareStatement(searchSql);
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            pstmt.setInt(4, pageSize);
            pstmt.setInt(5, offset);
            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                java.util.Map<String, Object> product = new java.util.HashMap<>();
                product.put("id", rs.getInt("product_id"));
                product.put("name", rs.getString("product_name"));
                product.put("description", rs.getString("description"));
                product.put("price", rs.getDouble("price"));
                product.put("stock", rs.getInt("stock"));
                product.put("image", rs.getString("main_image"));
                product.put("player", rs.getString("player_name"));
                product.put("team", rs.getString("team"));
                product.put("rarity", rs.getString("rarity"));
                product.put("category", rs.getString("category_name"));
                searchResults.add(product);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pstmt, rs);
        }
    }
    
    int totalPages = (int) Math.ceil((double) totalResults / pageSize);
    %>

    <!-- 引入統一的header -->
    <%@ include file="header.jsp" %>

    <div class="container">
        <!-- 搜尋區域 -->
        <div class="search-header">
            <h1>搜尋結果</h1>
            <div class="search-form">
                <form action="search_results.jsp" method="get">
                    <input type="text" name="query" value="<%=query%>" placeholder="請輸入搜尋關鍵字..." required>
                    <button type="submit" class="btn btn-primary">🔍 搜尋</button>
                </form>
            </div>
            
            <% if (!query.isEmpty()) { %>
                <div class="search-info">
                    關鍵字「<strong><%=query%></strong>」的搜尋結果：共找到 <strong><%=totalResults%></strong> 項商品
                </div>
            <% } %>
        </div>

        <!-- 搜尋結果 -->
        <% if (query.isEmpty()) { %>
            <div class="no-search">
                <h2>請輸入搜尋關鍵字</h2>
                <p>您可以搜尋商品名稱、球員姓名或商品描述</p>
            </div>
        <% } else if (searchResults.isEmpty()) { %>
            <div class="no-results">
                <h2>找不到相關商品</h2>
                <p>建議您：</p>
                <ul>
                    <li>檢查關鍵字是否正確</li>
                    <li>嘗試使用更簡單的關鍵字</li>
                    <li>瀏覽我們的商品分類</li>
                </ul>
                <div class="category-links">
                    <a href="card.jsp" class="btn btn-primary">瀏覽單卡</a>
                    <a href="card_box.jsp" class="btn btn-primary">瀏覽卡盒</a>
                    <a href="card_accessories.jsp" class="btn btn-primary">瀏覽周邊</a>
                    <a href="special.jsp" class="btn btn-primary">瀏覽特別商品</a>
                </div>
            </div>
        <% } else { %>
            <!-- 分頁資訊 -->
            <div class="page-info">
                顯示第 <%=(offset + 1)%> - <%=Math.min(offset + pageSize, totalResults)%> 項，共 <%=totalResults%> 項結果
            </div>

            <!-- 商品列表 -->
            <div class="product-grid">
                <%
                for (java.util.Map<String, Object> product : searchResults) {
                    int productId = (Integer) product.get("id");
                    String productName = (String) product.get("name");
                    String description = (String) product.get("description");
                    double price = (Double) product.get("price");
                    int stock = (Integer) product.get("stock");
                    String image = (String) product.get("image");
                    String player = (String) product.get("player");
                    String team = (String) product.get("team");
                    String rarity = (String) product.get("rarity");
                    String category = (String) product.get("category");
                    
                    if (image == null || image.isEmpty()) {
                        image = "images/default_product.jpg";
                    }
                %>
                    <div class="product-card">
    <a href="product_detail.jsp?id=<%=productId%>" class="product-link">
        <div class="product-image">
            <img src="<%=image%>" alt="<%=productName%>" class="product-img" loading="lazy" onerror="this.src='images/default_product.jpg'">
        </div>
    </a>
    <div class="product-info">
        <div class="category-badge"><%=category != null ? category : "商品"%></div>
        <a href="product_detail.jsp?id=<%=productId%>" class="product-name-link">
            <h3 class="product-name"><%=productName%></h3>
        </a>
        <p class="product-description"><%=description != null ? description : ""%></p>
        <div class="product-price">NT$ <%=String.format("%,.0f", price)%></div>
        
        <% if (player != null && !player.isEmpty()) { %>
            <div class="product-player">球員：<%=player%></div>
        <% } %>
        
        <% if (rarity != null && !rarity.isEmpty()) { %>
            <div class="rarity-badge rarity-<%=rarity%>"><%=rarity%></div>
        <% } %>
        
        <div class="product-stock">
            <% if (stock > 5) { %>
                <span class="in-stock">庫存充足 (<%=stock%> 個)</span>
            <% } else { %>
                <span class="low-stock">庫存不多 (<%=stock%> 個)</span>
            <% } %>
        </div>
        
        <div class="product-actions">
            <% if (searchIsLoggedIn) { %>
                <form action="add_to_cart.jsp" method="post" style="display: inline;">
                    <input type="hidden" name="product_id" value="<%=productId%>">
                    <input type="hidden" name="quantity" value="1">
                    <button type="submit" class="btn btn-primary">加入購物車</button>
                </form>
            <% } else { %>
                <a href="member.jsp?redirect=search_results.jsp?query=<%=java.net.URLEncoder.encode(query, "UTF-8")%>" class="btn btn-secondary">登入購買</a>
            <% } %>
            <a href="product_detail.jsp?id=<%=productId%>" class="btn btn-success">查看詳情</a>
        </div>
    </div>
</div>

                <%
                }
                %>
            </div>

            <!-- 分頁導航 -->
            <% if (totalPages > 1) { %>
                <div class="pagination">
                    <% if (searchCurrentPage > 1) { %>
                        <a href="search_results.jsp?query=<%=java.net.URLEncoder.encode(query, "UTF-8")%>&page=<%=searchCurrentPage-1%>" class="page-btn">&laquo; 上一頁</a>
                    <% } %>
                    
                    <% 
                    int startPage = Math.max(1, searchCurrentPage - 2);
                    int endPage = Math.min(totalPages, searchCurrentPage + 2);
                    
                    for (int i = startPage; i <= endPage; i++) { 
                    %>
                        <% if (i == searchCurrentPage) { %>
                            <span class="page-btn current"><%=i%></span>
                        <% } else { %>
                            <a href="search_results.jsp?query=<%=java.net.URLEncoder.encode(query, "UTF-8")%>&page=<%=i%>" class="page-btn"><%=i%></a>
                        <% } %>
                    <% } %>
                    
                    <% if (searchCurrentPage < totalPages) { %>
                        <a href="search_results.jsp?query=<%=java.net.URLEncoder.encode(query, "UTF-8")%>&page=<%=searchCurrentPage+1%>" class="page-btn">下一頁 &raquo;</a>
                    <% } %>
                </div>
            <% } %>
        <% } %>
    </div>

    <!-- 引入統一的footer -->
    <%@ include file="footer.jsp" %>
</body>
</html> 