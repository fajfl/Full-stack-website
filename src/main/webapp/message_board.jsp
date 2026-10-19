<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 檢查會員登入狀態
    Integer memberId = (Integer) session.getAttribute("memberId");
    String memberName = (String) session.getAttribute("memberName");
    boolean isLoggedIn = memberId != null;
    
    String message = "";
    String messageType = "";
    
    // 檢查資料庫連接狀態
    boolean dbAvailable = isDatabaseAvailable();
    
    // 獲取所有商品評論列表
    List<Map<String, Object>> allReviews = new ArrayList<>();
    int totalReviews = 0;
    
    if (dbAvailable) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            if (conn != null) {
                // 獲取所有評論，包含商品資訊
                pstmt = conn.prepareStatement(
                    "SELECT pr.review_id, pr.member_name, pr.rating, pr.comment, pr.created_at, " +
                    "       p.product_name, p.main_image, p.player_name " +
                    "FROM product_reviews pr " +
                    "JOIN product p ON pr.product_id = p.product_id " +
                    "WHERE pr.is_verified = 1 " +
                    "ORDER BY pr.created_at DESC LIMIT 50"
                );
                rs = pstmt.executeQuery();
                
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                while (rs.next()) {
                    Map<String, Object> review = new HashMap<>();
                    review.put("id", rs.getInt("review_id"));
                    review.put("memberName", rs.getString("member_name"));
                    review.put("rating", rs.getInt("rating"));
                    review.put("comment", rs.getString("comment"));
                    review.put("productName", rs.getString("product_name"));
                    review.put("productImage", rs.getString("main_image"));
                    review.put("playerName", rs.getString("player_name"));
                    review.put("date", sdf.format(rs.getTimestamp("created_at")));
                    allReviews.add(review);
                }
                rs.close();
                pstmt.close();
                
                // 獲取評論總數統計
                pstmt = conn.prepareStatement("SELECT COUNT(*) FROM product_reviews WHERE is_verified = 1");
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    totalReviews = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            System.err.println("Error loading reviews: " + e.getMessage());
            dbAvailable = false;
        } finally {
            closeResources(conn, pstmt, rs);
        }
    }
%>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>留言板 - NBA卡包商城</title>
    <link rel="stylesheet" href="css/common.css">
    <style>
        .message-board {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .board-title {
            text-align: center;
            margin-bottom: 30px;
        }

        .board-title h1 {
            color: var(--primary-blue);
            font-size: 2.5rem;
            margin-bottom: 10px;
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .board-title p {
            color: #666;
            font-size: 1.1rem;
        }

        .stats-info {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
        }

        .stats-info h3 {
            color: var(--primary-blue);
            margin-bottom: 10px;
        }

        .stats-number {
            font-size: 2rem;
            font-weight: bold;
            color: var(--accent-blue);
        }

        .reviews-list {
            margin-top: 30px;
        }

        .reviews-list h3 {
            color: var(--primary-blue);
            margin-bottom: 25px;
            font-size: 1.5rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .reviews-list h3::before {
            content: '💬';
            font-size: 1.2em;
        }

        .review-item {
            background: white;
            border: 2px solid #f0f0f0;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .review-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-blue), var(--accent-blue));
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .review-item:hover {
            border-color: var(--primary-blue);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }

        .review-item:hover::before {
            opacity: 1;
        }

        .review-header {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }

        .product-image {
    width: 60px;
    height: 60px;
    border-radius: 8px;
    border: 2px solid #e9ecef;
    object-fit: contain;      /* ✅ 不切圖 */
    background-color: white;  /* ✅ 加白底避免透明背景圖片不好看 */
    padding: 4px;              /* ✅ 加內距避免太貼邊 */
}


        .review-info {
            flex: 1;
        }

        .product-name {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--primary-blue);
            margin-bottom: 5px;
            line-height: 1.3;
        }

        .reviewer-name {
            font-weight: 600;
            color: #28a745;
            font-size: 0.95rem;
            margin-bottom: 5px;
        }

        .review-rating {
            color: #ffc107;
            font-size: 1.2rem;
            text-shadow: 0 1px 3px rgba(255, 193, 7, 0.3);
            margin-bottom: 5px;
        }

        .review-date {
            color: #666;
            font-size: 0.9rem;
        }

        .review-comment {
            color: #333;
            line-height: 1.7;
            white-space: pre-wrap;
            font-size: 1rem;
            margin-top: 10px;
        }

        .no-reviews {
            text-align: center;
            padding: 60px 20px;
            color: #666;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            border-radius: 15px;
        }

        .no-reviews h3 {
            color: var(--primary-blue);
            margin-bottom: 15px;
            font-size: 1.5rem;
        }

        .no-reviews::before {
            content: '📝';
            font-size: 3rem;
            display: block;
            margin-bottom: 20px;
        }

        .db-offline {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .browse-products {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            margin-top: 30px;
            border-left: 5px solid var(--accent-blue);
        }

        .browse-products h3 {
            color: var(--primary-blue);
            margin-bottom: 15px;
        }

        .category-links {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .category-links a {
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 61, 165, 0.2);
        }

        .category-links a:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 61, 165, 0.3);
            text-decoration: none;
            color: white;
        }

        @media (max-width: 768px) {
            .review-header {
                flex-direction: column;
                gap: 10px;
            }
            
            .product-image {
                width: 50px;
                height: 50px;
            }
            
            .category-links {
                flex-direction: column;
                align-items: center;
            }
            
            .category-links a {
                width: 200px;
            }
        }
    </style>
</head>

<body>
    <!-- 引入統一的header -->
    <%@ include file="header.jsp" %>

    <div class="container">
        <!-- 資料庫狀態提示 -->
        <% if (!dbAvailable) { %>
            <div class="alert alert-warning">
                <strong>⚠️ 系統提示：</strong>目前資料庫連接異常，留言功能可能無法正常使用。
                <a href="test_db.jsp" style="color: #856404; text-decoration: underline;">檢查系統狀態</a>
            </div>
        <% } %>

        <!-- 訊息顯示 -->
        <% if (!message.isEmpty()) { %>
            <div class="alert alert-<%=messageType%>">
                <%=message%>
            </div>
        <% } %>

        <div class="message-board">
            <div class="board-title">
                <h1>商品評論留言板</h1>
                <p>查看所有商品的評論與分享</p>
            </div>

            <!-- 統計資訊 -->
            <% if (dbAvailable) { %>
                <div class="stats-info">
                    <h3>📊 評論統計</h3>
                    <div class="stats-number"><%=totalReviews%></div>
                    <p>位顧客分享了他們的購買體驗</p>
                </div>
            <% } %>

            <!-- 評論列表 -->
            <div class="reviews-list">
                <h3>最新評論</h3>
                
                <% if (!dbAvailable) { %>
                    <div class="db-offline">
                        <h3>🔌 系統維護中</h3>
                        <p>目前無法連接到資料庫，暫時無法顯示評論。</p>
                        <div style="margin-top: 20px;">
                            <a href="test_db.jsp" class="btn btn-info">檢查系統狀態</a>
                            <a href="javascript:location.reload()" class="btn btn-primary">重新整理</a>
                        </div>
                    </div>
                <% } else if (allReviews.isEmpty()) { %>
                    <div class="no-reviews">
                        <h3>還沒有評論</h3>
                        <p>成為第一個分享購買體驗的顧客！</p>
                    </div>
                <% } else { %>
                    <% for (Map<String, Object> review : allReviews) { %>
                        <div class="review-item">
                            <div class="review-header">
                                <img src="<%=review.get("productImage")%>" alt="<%=review.get("productName")%>" 
                                     class="product-image" onerror="this.src='images/nba-logo.png';">
                                <div class="review-info">
                                    <div class="product-name"><%=review.get("productName")%></div>
                                    <div class="reviewer-name"><%=review.get("memberName")%></div>
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
                                    <div class="review-date"><%=review.get("date")%></div>
                                </div>
                            </div>
                            <div class="review-comment"><%=review.get("comment")%></div>
                        </div>
                    <% } %>
                <% } %>
            </div>

            <!-- 瀏覽商品區域 -->
            <% if (dbAvailable) { %>
                <div class="browse-products">
                    <h3>🛍️ 想要評論商品嗎？</h3>
                    <p>瀏覽我們的商品並留下您的評論</p>
                    <div class="category-links">
                        <a href="card.jsp">單卡商品</a>
                        <a href="card_box.jsp">卡盒商品</a>
                        <a href="card_accessories.jsp">周邊商品</a>
                        <a href="special.jsp">特別商品</a>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <!-- 引入統一的footer -->
    <%@ include file="footer.jsp" %>
</body>
</html>