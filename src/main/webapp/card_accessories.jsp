<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>卡片周邊商品 - NBA卡包商城</title>
    <link rel="stylesheet" href="css/common.css">
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .page-header {
            text-align: center;
            margin-bottom: 40px;
            background: linear-gradient(135deg, rgba(255,255,255,0.9), rgba(248,249,250,0.9));
            padding: 40px 20px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .page-title {
            font-size: 3rem;
            font-weight: bold;
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 15px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }

        .page-subtitle {
            font-size: 1.2rem;
            color: #666;
            margin: 0;
            font-style: italic;
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
            margin: 30px 0;
            min-height: 400px;
        }

        .card-box {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
            transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            border: 3px solid transparent;
            background-clip: padding-box;
            cursor: pointer;
        }

        .card-box::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue), #ff6b6b);
            border-radius: 20px;
            padding: 3px;
            mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
            mask-composite: exclude;
            opacity: 0;
            transition: opacity 0.3s ease;
            z-index: 2;
            pointer-events: none;
        }

        .card-box:hover::before {
            opacity: 1;
        }

        .card-box:hover {
            transform: translateY(-15px) scale(1.03);
            box-shadow: 0 25px 50px rgba(0,0,0,0.2), 0 0 30px rgba(255,255,255,0.3);
            z-index: 10;
        }

        .card-box img {
            width: 100%;
            height: 300px;
            object-fit: contain;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            padding: 1rem;
            transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            z-index: 1;
            position: relative;
        }

        .card-box:hover img {
            transform: scale(1.1) rotate(1deg);
            filter: brightness(1.1) contrast(1.1);
        }

        .card-info {
            padding: 25px;
            position: relative;
            z-index: 3;
        }

        .card-info h3 {
            font-size: 1.4rem;
            font-weight: bold;
            color: var(--primary-blue);
            margin-bottom: 12px;
            line-height: 1.3;
            min-height: 2.6rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .product-description {
            color: #666;
            font-size: 0.9rem;
            line-height: 1.5;
            margin-bottom: 15px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            min-height: 2.8rem;
        }

        .category-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.4);
            z-index: 4;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .price {
            font-size: 1.5rem;
            font-weight: bold;
            color: #e74c3c;
            margin: 12px 0;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        .stock {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 20px;
            padding: 8px 12px;
            background: #f8f9fa;
            border-radius: 8px;
            text-align: center;
        }

        .stock.in-stock {
            color: #28a745;
            background: rgba(40, 167, 69, 0.1);
            border: 1px solid rgba(40, 167, 69, 0.2);
        }

        .stock.low-stock {
            color: #ffc107;
            background: rgba(255, 193, 7, 0.1);
            border: 1px solid rgba(255, 193, 7, 0.2);
            animation: pulse 2s infinite;
        }

        .stock.out-of-stock {
            color: #dc3545;
            background: rgba(220, 53, 69, 0.1);
            border: 1px solid rgba(220, 53, 69, 0.2);
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.7; }
        }

        .card-actions {
            display: flex;
            gap: 12px;
            margin-top: 20px;
        }

        .add-to-cart-btn {
            flex: 1;
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
            color: white;
            border: none;
            padding: 14px 20px;
            border-radius: 12px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 6px 20px rgba(0, 61, 165, 0.3);
            font-size: 0.9rem;
            text-decoration: none;
            text-align: center;
            line-height: 1;
        }

        .add-to-cart-btn:hover {
            background: linear-gradient(135deg, var(--accent-blue), var(--primary-blue));
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 61, 165, 0.4);
        }

        .add-to-cart-btn:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .detail-btn {
            width: 50px;
            height: 50px;
            border: 2px solid var(--primary-blue);
            background: white;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            text-decoration: none;
            color: var(--primary-blue);
        }

        .detail-btn:hover {
            background: var(--primary-blue);
            color: white;
            transform: scale(1.1);
            box-shadow: 0 4px 15px rgba(0, 61, 165, 0.3);
        }

        .featured-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: linear-gradient(135deg, #ff6b6b, #ffa500);
            color: white;
            padding: 6px 12px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: bold;
            z-index: 2;
            box-shadow: 0 4px 15px rgba(255, 107, 107, 0.4);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .no-products, .db-offline {
            grid-column: 1 / -1;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 400px;
            text-align: center;
        }
        
        .no-products-content, .db-offline-content {
            background: white;
            border-radius: 20px;
            padding: 50px 40px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.1);
            max-width: 500px;
        }
        
        .no-products h2, .db-offline h2 {
            color: var(--primary-blue);
            margin-bottom: 20px;
            font-size: 2rem;
        }
        
        .no-products p, .db-offline p {
            color: #666;
            margin-bottom: 25px;
            line-height: 1.6;
            font-size: 1.1rem;
        }

        /* Shimmer效果 */
        .shimmer {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 200% 100%;
            animation: shimmer 2s infinite;
        }

        @keyframes shimmer {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }

        /* 分頁樣式 */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin: 40px 0;
            padding: 20px;
        }

        .page-btn {
            padding: 10px 15px;
            border: 2px solid var(--primary-blue);
            background: white;
            color: var(--primary-blue);
            text-decoration: none;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .page-btn:hover {
            background: var(--primary-blue);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 61, 165, 0.3);
        }

        .page-btn.current {
            background: var(--primary-blue);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 61, 165, 0.3);
        }

        @media (max-width: 768px) {
            .products-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 20px;
            }
            
            .page-title {
                font-size: 2.5rem;
            }
            
            .card-actions {
                flex-direction: column;
            }
            
            .detail-btn {
                width: 100%;
                height: 45px;
            }
        }

        @media (max-width: 480px) {
            .products-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }
            
            .page-title {
                font-size: 2rem;
            }
        }
    </style>
</head>
<body>
    <%
    // 檢查登入狀態
    Integer accessoriesMemberId = (Integer) session.getAttribute("memberId");
    String accessoriesMemberName = (String) session.getAttribute("memberName");
    boolean accessoriesPageIsLoggedIn = (accessoriesMemberId != null);
    
    // 檢查資料庫連接狀態
    boolean dbAvailable = isDatabaseAvailable();
    
    // 分頁參數
    int accessoriesCurrentPage = 1;
    int itemsPerPage = 12;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            accessoriesCurrentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            accessoriesCurrentPage = 1;
        }
    }
    
    int offset = (accessoriesCurrentPage - 1) * itemsPerPage;
    
    // 處理訊息顯示
    String message = request.getParameter("message");
    String messageType = request.getParameter("type");
    %>

    <!-- 引入統一的header -->
    <%@ include file="header.jsp" %>

    <div class="container">
        <!-- 資料庫狀態提示 -->
        <% if (!dbAvailable) { %>
            <div class="alert alert-warning">
                <strong>⚠️ 系統提示：</strong>目前資料庫連接異常，可能無法顯示最新商品資訊。
                <a href="test_db.jsp" style="color: #856404; text-decoration: underline;">檢查系統狀態</a>
            </div>
        <% } %>

        <!-- 訊息顯示 -->
        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-<%=messageType != null ? messageType : "info"%>">
                <%=message%>
            </div>
        <% } %>

        <!-- 頁面標題和介紹 -->
        <div class="page-header">
            <h1 class="page-title">卡片周邊商品</h1>
            <p class="page-subtitle">精美周邊配件，讓你的收藏更完美</p>
        </div>

        <!-- 商品展示區域 -->
        <div class="products-grid" id="cardContainer">
            <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            PreparedStatement countStmt = null;
            ResultSet rs = null;
            ResultSet countRs = null;
            
            if (dbAvailable) {
                try {
                    conn = getConnection();
                    
                    // 計算總商品數量
                    String countSql = "SELECT COUNT(*) as total FROM product WHERE category_id = 3 AND status = '上架'";
                    countStmt = conn.prepareStatement(countSql);
                    countRs = countStmt.executeQuery();
                    int totalItems = 0;
                    if (countRs.next()) {
                        totalItems = countRs.getInt("total");
                    }
                    
                    // 查詢商品資料
                    String sql = "SELECT product_id, product_name, description, price, stock, main_image " +
                               "FROM product WHERE category_id = 3 AND status = '上架' " +
                               "ORDER BY price DESC LIMIT ? OFFSET ?";
                    
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, itemsPerPage);
                    pstmt.setInt(2, offset);
                    rs = pstmt.executeQuery();
                    
                    boolean hasProducts = false;
                    while (rs.next()) {
                        hasProducts = true;
                        String productId = rs.getString("product_id");
                        String productName = rs.getString("product_name");
                        String description = rs.getString("description");
                        double price = rs.getDouble("price");
                        int stock = rs.getInt("stock");
                        String mainImage = rs.getString("main_image");
                        
                        // 設定預設圖片
                        if (mainImage == null || mainImage.isEmpty()) {
                            mainImage = "images/default_accessory.jpg";
                        }
                        
                        // 判斷是否為熱門商品
                        boolean isFeatured = productName != null && 
                            (productName.contains("限量") || productName.contains("特別版") || 
                             productName.contains("收藏") || productName.contains("精裝"));
            %>
                <div class="card-box" data-price="<%=price%>" data-stock="<%=stock%>" data-name="<%=productName.replaceAll("\"", "&quot;").replaceAll("'", "&#39;")%>">
                    <% if (isFeatured) { %>
                        <div class="featured-badge">熱門</div>
                    <% } %>
                    
                    <div class="category-badge">周邊</div>
                    
                    <img src="<%=mainImage%>" alt="<%=productName%>" onerror="this.src='images/default_accessory.jpg'">
                    
                    <div class="card-info">
                        <h3><%=productName%></h3>
                        <div class="product-description"><%=description != null ? description : "精美NBA卡片周邊配件，收藏愛好者必備"%></div>
                        <div class="price">NT$ <%=String.format("%,.0f", price)%></div>
                        <div class="stock <%=stock <= 5 ? (stock > 0 ? "low-stock" : "out-of-stock") : "in-stock"%>">
                            <% if (stock > 10) { %>
                                庫存充足 (<%=stock%> 件)
                            <% } else if (stock > 0) { %>
                                庫存不多 (<%=stock%> 件)
                            <% } else { %>
                                缺貨中
                            <% } %>
                        </div>
                        
                        <div class="card-actions">
                            <% if (stock > 0) { %>
                                <% if (accessoriesPageIsLoggedIn) { %>
                                    <button class="add-to-cart-btn" data-product-id="<%=productId%>" onclick="addToCart(this.dataset.productId)">加入購物車</button>
                                <% } else { %>
                                    <a href="member.jsp?redirect=card_accessories.jsp" class="add-to-cart-btn">登入購買</a>
                                <% } %>
                            <% } else { %>
                                <button class="add-to-cart-btn" disabled>缺貨中</button>
                            <% } %>
                            
                            <a href="product_detail.jsp?id=<%=productId%>" class="detail-btn" title="查看詳情">
                                ℹ️
                            </a>
                        </div>
                    </div>
                </div>
            <%
                    }
                    
                    if (!hasProducts) {
            %>
                        <div class="no-products">
                            <div class="no-products-content">
                                <h2>暫無周邊商品</h2>
                                <p>目前沒有可用的周邊商品，請稍後再來查看或瀏覽其他商品！</p>
                                <div style="margin-top: 25px;">
                                    <a href="index.jsp" class="btn btn-primary">返回首頁</a>
                                    <a href="card.jsp" class="btn btn-secondary">瀏覽球員卡</a>
                                </div>
                            </div>
                        </div>
            <%
                    } else {
                        // 計算分頁資訊
                        int totalPages = (int) Math.ceil((double) totalItems / itemsPerPage);
            %>
            
            <!-- 分頁導航 -->
            <% if (totalPages > 1) { %>
                <div class="pagination">
                    <% if (accessoriesCurrentPage > 1) { %>
                        <a href="card_accessories.jsp?page=<%=accessoriesCurrentPage-1%>" class="page-btn">&laquo; 上一頁</a>
                    <% } %>
                    
                    <% 
                    int startPage = Math.max(1, accessoriesCurrentPage - 2);
                    int endPage = Math.min(totalPages, accessoriesCurrentPage + 2);
                    
                    for (int i = startPage; i <= endPage; i++) { 
                    %>
                        <% if (i == accessoriesCurrentPage) { %>
                            <span class="page-btn current"><%=i%></span>
                        <% } else { %>
                            <a href="card_accessories.jsp?page=<%=i%>" class="page-btn"><%=i%></a>
                        <% } %>
                    <% } %>
                    
                    <% if (accessoriesCurrentPage < totalPages) { %>
                        <a href="card_accessories.jsp?page=<%=accessoriesCurrentPage+1%>" class="page-btn">下一頁 &raquo;</a>
                    <% } %>
                </div>
            <% } %>
            <%
                    }
                    
                } catch (SQLException e) {
                    out.println("<div class='db-offline'>");
                    out.println("<div class='db-offline-content'>");
                    out.println("<h2>資料載入失敗</h2>");
                    out.println("<p>抱歉，目前無法載入商品資料。請稍後再試或聯繫客服。</p>");
                    out.println("<div style='margin-top: 25px;'>");
                    out.println("<a href='test_db.jsp' class='btn btn-info'>檢查系統狀態</a>");
                    out.println("<a href='javascript:location.reload()' class='btn btn-primary'>重新整理</a>");
                    out.println("<a href='index.jsp' class='btn btn-secondary'>返回首頁</a>");
                    out.println("</div>");
                    out.println("</div>");
                    out.println("</div>");
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                    if (countRs != null) try { countRs.close(); } catch (SQLException ignored) {}
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
                    if (countStmt != null) try { countStmt.close(); } catch (SQLException ignored) {}
                    if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
                }
            } else {
            %>
                <div class="db-offline">
                    <div class="db-offline-content">
                        <h2>資料庫連接中斷</h2>
                        <p>目前無法連接到資料庫，請稍後再試。</p>
                        <div style="margin-top: 25px;">
                            <a href="test_db.jsp" class="btn btn-info">檢查系統狀態</a>
                            <a href="javascript:location.reload()" class="btn btn-primary">重新整理</a>
                            <a href="index.jsp" class="btn btn-secondary">返回首頁</a>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    </div>

    <!-- 引入統一的footer -->
    <%@ include file="footer.jsp" %>

    <script>
        function addToCart(productId) {
            if (confirm('確定要加入購物車嗎？')) {
                window.location.href = 'add_to_cart.jsp?product_id=' + productId + '&quantity=1';
            }
        }

        // 頁面載入動畫
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.card-box');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(30px)';
                setTimeout(() => {
                    card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html> 