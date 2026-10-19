<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品詳情 - NBA卡包商城</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/product_detail.css">
</head>
<body>
    <%
    // 檢查商品ID參數
    String productIdStr = request.getParameter("id");
    if (productIdStr == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    int productId = 0;
    try {
        productId = Integer.parseInt(productIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // 檢查登入狀態
    Integer memberId = (Integer) session.getAttribute("memberId");
    String memberName = (String) session.getAttribute("memberName");
    boolean isLoggedIn = memberId != null;
    
    // 後端檢測圖片文件是否存在
    String basePath = application.getRealPath("/images/");
    java.io.File imageDir = new java.io.File(basePath);
    
    // 獲取商品詳細資訊
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    String productName = "";
    String description = "";
    double price = 0.0;
    int stock = 0;
    String mainImage = "";
    String image2 = "";
    String image3 = "";
    String image4 = "";
    String playerName = "";
    String team = "";
    String cardYear = "";
    String cardSeries = "";
    String rarity = "";
    boolean isFeatured = false;
    int categoryId = 0;
    String categoryName = "";
    
    // 評論相關變數
    List<Map<String, Object>> reviews = new ArrayList<>();
    double averageRating = 0.0;
    int totalReviews = 0;
    boolean hasUserReviewed = false;
    
    try {
        conn = getConnection();
        String sql = "SELECT p.product_name, p.description, p.price, p.stock, p.main_image, " +
                   "p.image_2, p.image_3, p.image_4, p.player_name, p.team, p.card_year, " +
                   "p.card_series, p.rarity, p.is_featured, p.category_id, c.category_name " +
                   "FROM product p LEFT JOIN category c ON p.category_id = c.category_id " +
                   "WHERE p.product_id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, productId);
        rs = pstmt.executeQuery();
        
        if (!rs.next()) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        productName = rs.getString("product_name") != null ? rs.getString("product_name") : "";
        description = rs.getString("description") != null ? rs.getString("description") : "";
        price = rs.getDouble("price");
        stock = rs.getInt("stock");
        mainImage = rs.getString("main_image") != null ? rs.getString("main_image") : "images/nba-logo.png";
        image2 = rs.getString("image_2");
        image3 = rs.getString("image_3");
        image4 = rs.getString("image_4");
        playerName = rs.getString("player_name");
        team = rs.getString("team");
        cardYear = rs.getString("card_year");
        cardSeries = rs.getString("card_series");
        rarity = rs.getString("rarity") != null ? rs.getString("rarity") : "";
        isFeatured = rs.getBoolean("is_featured");
        categoryId = rs.getInt("category_id");
        categoryName = rs.getString("category_name") != null ? rs.getString("category_name") : "";
        
        rs.close();
        pstmt.close();
        
        // 獲取評論統計
        String ratingSQL = "SELECT COUNT(*) as total_reviews, COALESCE(AVG(rating), 0) as avg_rating FROM product_reviews WHERE product_id = ?";
        pstmt = conn.prepareStatement(ratingSQL);
        pstmt.setInt(1, productId);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            totalReviews = rs.getInt("total_reviews");
            averageRating = rs.getDouble("avg_rating");
        }
        rs.close();
        pstmt.close();
        
        // 檢查用戶是否已評論
        if (isLoggedIn) {
            String checkSQL = "SELECT COUNT(*) FROM product_reviews WHERE product_id = ? AND member_id = ?";
            pstmt = conn.prepareStatement(checkSQL);
            pstmt.setInt(1, productId);
            pstmt.setInt(2, memberId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                hasUserReviewed = rs.getInt(1) > 0;
            }
            rs.close();
            pstmt.close();
        }
        
        // 獲取評論列表
        String reviewSQL = "SELECT review_id, member_name, rating, comment, created_at FROM product_reviews " +
                          "WHERE product_id = ? ORDER BY created_at DESC";
        pstmt = conn.prepareStatement(reviewSQL);
        pstmt.setInt(1, productId);
        rs = pstmt.executeQuery();
        
        while (rs.next()) {
            Map<String, Object> review = new HashMap<>();
            review.put("id", rs.getInt("review_id"));
            review.put("memberName", rs.getString("member_name"));
            review.put("rating", rs.getInt("rating"));
            review.put("comment", rs.getString("comment"));
            review.put("createdAt", rs.getTimestamp("created_at"));
            reviews.add(review);
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("index.jsp");
        return;
    } finally {
        closeResources(conn, pstmt, rs);
    }
    
    // 處理訊息顯示
    String message = request.getParameter("message");
    String messageType = request.getParameter("type");
    %>

    <!-- 引入統一的header -->
    <%@ include file="header.jsp" %>

    <div class="main-container">
        <!-- 訊息顯示 -->
        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-<%=messageType != null ? messageType : "info"%>">
                <%=message%>
            </div>
        <% } %>

        <!-- 商品詳情區域 -->
        <section class="product-section">
            <div class="product-image">
                <img src="<%=mainImage%>" alt="<%=productName%>" onerror="this.src='images/nba-logo.png';">
                    <% if (isFeatured) { %>
                    <div class="featured-badge">精選商品</div>
                    <% } %>
            </div>

            <div class="product-info">
                <h1><%=productName%></h1>
                
                <div class="price-section">
                    <strong>價格: NT$ <%=String.format("%,.0f", price)%></strong>
                </div>
                
                <div class="rating-section">
                    <div class="stars">
                        <% 
                        int fullStars = (int) averageRating;
                        for (int i = 1; i <= 5; i++) {
                            if (i <= fullStars) {
                                out.print("★");
                            } else if (i == fullStars + 1 && averageRating % 1 >= 0.5) {
                                out.print("☆");
                            } else {
                                out.print("☆");
                            }
                        }
                        %>
                    </div>
                    <div class="rating-text">
                        <% if (totalReviews > 0) { %>
                            (<%=String.format("%.1f", averageRating)%>) - <%=totalReviews%> 則評論
                        <% } else { %>
                            (暫無評分)
                        <% } %>
                    </div>
                </div>
                
                <!-- 商品詳細資訊 -->
                <% if (playerName != null || team != null || cardYear != null || cardSeries != null) { %>
                <div class="product-meta">
                    <% if (playerName != null && !playerName.isEmpty()) { %>
                        <div class="meta-item">
                            <span class="meta-label">球員:</span>
                            <span class="meta-value"><%=playerName%></span>
                        </div>
                    <% } %>
                    <% if (team != null && !team.isEmpty()) { %>
                        <div class="meta-item">
                            <span class="meta-label">球隊:</span>
                            <span class="meta-value"><%=team%></span>
                        </div>
                    <% } %>
                    <% if (cardYear != null && !cardYear.isEmpty()) { %>
                        <div class="meta-item">
                            <span class="meta-label">年份:</span>
                            <span class="meta-value"><%=cardYear%></span>
                        </div>
                    <% } %>
                    <% if (cardSeries != null && !cardSeries.isEmpty()) { %>
                        <div class="meta-item">
                            <span class="meta-label">系列:</span>
                            <span class="meta-value"><%=cardSeries%></span>
                        </div>
                    <% } %>
                    <% if (!rarity.isEmpty()) { %>
                        <div class="meta-item">
                            <span class="meta-label">稀有度:</span>
                            <span class="meta-value rarity-<%=rarity%>"><%=rarity%></span>
                        </div>
                    <% } %>
                </div>
                <% } %>
                
                <div class="quantity-section">
                    <label for="quantity">數量:</label>
                    <input type="number" id="quantity" name="quantity" value="1" min="1" max="<%=Math.min(stock, 10)%>" class="quantity-input">
                    <div style="margin-top: 10px; color: #666;">
                        <% if (stock > 10) { %>
                            庫存充足 (<%=stock%> 件)
                        <% } else if (stock > 0) { %>
                            庫存不多 (<%=stock%> 件)
                        <% } else { %>
                            <span style="color: #dc3545;">缺貨中</span>
                        <% } %>
                    </div>
                </div>

                            <% if (stock > 0) { %>
                                <% if (isLoggedIn) { %>
                        <button class="add-to-cart-btn" onclick="addToCart(<%=productId%>)">加入購物車</button>
                                <% } else { %>
                        <a href="member.jsp?redirect=product_detail.jsp?id=<%=productId%>" class="add-to-cart-btn" style="text-decoration: none; display: inline-block;">登入購買</a>
                                <% } %>
                            <% } else { %>
                    <button class="add-to-cart-btn" disabled style="background: #6c757d; cursor: not-allowed;">缺貨中</button>
                            <% } %>
            </div>
        </section>

        <!-- 商品介紹 -->
        <section class="product-description">
            <h3>商品介紹</h3>
            <p><%=description%></p>
        </section>

        <!-- 評論區域 -->
        <section class="reviews-section">
            <h3>顧客評論</h3>
            
            <!-- 評論列表 -->
            <div class="review-list">
                <% if (reviews.isEmpty()) { %>
                    <div class="no-reviews">
                        <p>目前還沒有評論，成為第一個留下評論的人吧！</p>
                    </div>
                <% } else { %>
                    <% for (Map<String, Object> review : reviews) { %>
                        <div class="review-item">
                            <div class="review-header">
                                <span class="reviewer-name"><%=review.get("memberName")%></span>
                                <span class="review-date"><%=review.get("createdAt")%></span>
                            </div>
                            <div class="review-rating">
                                <% 
                                int rating = (Integer) review.get("rating");
                                for (int i = 1; i <= 5; i++) {
                                    if (i <= rating) {
                                        out.print("★");
                                    } else {
                                        out.print("☆");
                                    }
                                }
                                %>
                            </div>
                            <div class="review-comment"><%=review.get("comment")%></div>
                        </div>
                    <% } %>
                <% } %>
            </div>
            
            <!-- 評論表單 -->
            <% if (isLoggedIn) { %>
                <% if (!hasUserReviewed) { %>
                    <div class="review-form">
                        <h4>留下評論</h4>
                        <form action="add_review.jsp" method="post" id="reviewForm">
                            <input type="hidden" name="product_id" value="<%=productId%>">
                            
                            <div class="form-group">
                                <label for="rating">評分:</label>
                                <div class="star-rating" id="starRating">
                                    <span class="star" data-rating="1">☆</span>
                                    <span class="star" data-rating="2">☆</span>
                                    <span class="star" data-rating="3">☆</span>
                                    <span class="star" data-rating="4">☆</span>
                                    <span class="star" data-rating="5">☆</span>
                                </div>
                                <input type="hidden" id="rating" name="rating" value="">
                                <p id="ratingFeedback" class="rating-feedback">請選擇評分</p>
                            </div>
                            
                            <div class="form-group">
                                <label for="comment">評論:</label>
                                <textarea id="comment" name="comment" placeholder="分享您對這個商品的看法..." required></textarea>
                            </div>
                            
                            <button type="submit" class="submit-btn">送出評論</button>
                        </form>
                    </div>
                <% } else { %>
                    <div class="review-form">
                        <p style="text-align: center; color: #666;">您已經評論過此商品了</p>
                    </div>
                <% } %>
            <% } else { %>
                <div class="review-form">
                    <p style="text-align: center;">
                        <a href="member.jsp?redirect=product_detail.jsp?id=<%=productId%>">登入</a> 後即可留下評論
                    </p>
        </div>
            <% } %>
        </section>
    </div>

    <!-- 引入統一的footer -->
    <%@ include file="footer.jsp" %>

    <script>
        // 星級評分功能
        document.addEventListener('DOMContentLoaded', function() {
            initStarRating();
            initReviewForm();
        });
        
        function initStarRating() {
            const stars = document.querySelectorAll('.star');
            const ratingInput = document.getElementById('rating');
            const ratingFeedback = document.getElementById('ratingFeedback');
            
            if (!stars.length || !ratingInput) return;
            
            const ratingTexts = {
                1: '很差',
                2: '一般', 
                3: '還可以',
                4: '很好',
                5: '極佳'
            };
            
            stars.forEach(function(star) {
                star.addEventListener('click', function() {
                    const rating = parseInt(this.dataset.rating);
                    ratingInput.value = rating;
                    if (ratingFeedback) {
                        ratingFeedback.textContent = ratingTexts[rating];
                    }
                    
                    // 更新星星顯示
                    stars.forEach(function(s, index) {
                        if (index < rating) {
                            s.textContent = '★';
                            s.classList.add('active');
                        } else {
                            s.textContent = '☆';
                            s.classList.remove('active');
                        }
                    });
                });
                
                star.addEventListener('mouseover', function() {
                    const rating = parseInt(this.dataset.rating);
                    stars.forEach(function(s, index) {
                        if (index < rating) {
                            s.textContent = '★';
                        } else {
                            s.textContent = '☆';
                        }
                    });
                });
            });
        }
        
        function initReviewForm() {
            const reviewForm = document.getElementById('reviewForm');
            if (!reviewForm) return;
            
            reviewForm.addEventListener('submit', function(e) {
                const ratingInput = document.getElementById('rating');
                const commentInput = document.getElementById('comment');
                
                if (!ratingInput || !ratingInput.value) {
                    e.preventDefault();
                    alert('請選擇評分');
                    return false;
                }
                
                if (!commentInput || !commentInput.value.trim()) {
                    e.preventDefault();
                    alert('請輸入評論內容');
                    return false;
                }
                
                return true;
            });
        }
        
        // 加入購物車功能
        function addToCart(productId) {
            const quantityInput = document.getElementById('quantity');
            const quantity = quantityInput ? quantityInput.value : 1;
            
            if (confirm('確定要加入購物車嗎？')) {
                window.location.href = 'add_to_cart.jsp?product_id=' + productId + '&quantity=' + quantity;
            }
        }
    </script>
</body>
</html> 