<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>特別商品 - NBA卡包商城</title>
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
            background: linear-gradient(135deg, rgba(255,215,0,0.1), rgba(255,140,0,0.1));
            padding: 40px 20px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border: 2px solid rgba(255, 215, 0, 0.3);
        }

        .page-title {
            font-size: 3rem;
            font-weight: bold;
            background: linear-gradient(135deg, #ffd700, #ff8c00);
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
            gap: 35px;
            margin: 30px 0;
            min-height: 400px;
        }

        .card-box {
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 35px rgba(0,0,0,0.15);
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
            background: linear-gradient(135deg, #ffd700, #ff8c00, #ff6b6b);
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
            box-shadow: 0 25px 50px rgba(0,0,0,0.25), 0 0 30px rgba(255,255,255,0.3);
            z-index: 10;
        }

        .card-box img {
            width: 100%;
            height: 320px;
            object-fit: contain;
            background: linear-gradient(135deg, #fafafa, #f0f0f0);
            padding: 1.5rem;
            transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            z-index: 1;
            position: relative;
        }

        .card-box:hover img {
            transform: scale(1.1) rotate(1deg);
            filter: brightness(1.1) contrast(1.1);
        }

        .card-info {
            padding: 30px;
            position: relative;
            z-index: 3;
        }

        .card-info h3 {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary-blue);
            margin-bottom: 15px;
            line-height: 1.3;
            min-height: 2.6rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .product-description {
            color: #666;
            font-size: 1rem;
            line-height: 1.6;
            margin-bottom: 18px;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            min-height: 4.2rem;
        }

        .category-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: linear-gradient(135deg, #ffd700, #ff8c00);
            color: white;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: bold;
            box-shadow: 0 6px 20px rgba(255, 215, 0, 0.5);
            z-index: 4;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
        }

        .price {
            font-size: 1.8rem;
            font-weight: bold;
            color: #e74c3c;
            margin: 15px 0;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.1);
        }

        .stock {
            font-size: 1rem;
            color: #666;
            margin-bottom: 25px;
            padding: 10px 15px;
            background: #f8f9fa;
            border-radius: 10px;
            text-align: center;
            font-weight: 500;
        }

        .stock.in-stock {
            color: #28a745;
            background: rgba(40, 167, 69, 0.1);
            border: 2px solid rgba(40, 167, 69, 0.2);
        }

        .stock.low-stock {
            color: #ffc107;
            background: rgba(255, 193, 7, 0.1);
            border: 2px solid rgba(255, 193, 7, 0.3);
            animation: pulse 2s infinite;
        }

        .stock.out-of-stock {
            color: #dc3545;
            background: rgba(220, 53, 69, 0.1);
            border: 2px solid rgba(220, 53, 69, 0.2);
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.8; transform: scale(1.02); }
        }

        .card-actions {
            display: flex;
            gap: 15px;
            margin-top: 25px;
        }

        .add-to-cart-btn {
            flex: 1;
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
            color: white;
            border: none;
            padding: 16px 24px;
            border-radius: 12px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 8px 25px rgba(0, 61, 165, 0.4);
            font-size: 1rem;
            text-decoration: none;
            text-align: center;
            line-height: 1;
        }

        .add-to-cart-btn:hover {
            background: linear-gradient(135deg, var(--accent-blue), var(--primary-blue));
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(0, 61, 165, 0.5);
        }

        .add-to-cart-btn:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        .detail-btn {
            width: 55px;
            height: 55px;
            border: 2px solid var(--primary-blue);
            background: white;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            text-decoration: none;
            color: var(--primary-blue);
        }

        .detail-btn:hover {
            background: var(--primary-blue);
            color: white;
            transform: scale(1.15);
            box-shadow: 0 6px 20px rgba(0, 61, 165, 0.4);
        }

        .featured-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: linear-gradient(135deg, #ff6b6b, #ffa500);
            color: white;
            padding: 8px 14px;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: bold;
            z-index: 2;
            box-shadow: 0 6px 20px rgba(255, 107, 107, 0.5);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .special-effect {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.1) 50%, transparent 70%);
            transform: translateX(-100%);
            transition: transform 0.6s ease;
        }

        .card-box:hover .special-effect {
            transform: translateX(100%);
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

        /* 分頁樣式 */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
            margin: 50px 0;
            padding: 20px;
        }

        .page-btn {
            padding: 12px 18px;
            border: 2px solid var(--primary-blue);
            background: white;
            color: var(--primary-blue);
            text-decoration: none;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s ease;
            font-size: 1rem;
        }

        .page-btn:hover {
            background: var(--primary-blue);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(0, 61, 165, 0.4);
        }

        .page-btn.current {
            background: var(--primary-blue);
            color: white;
            box-shadow: 0 6px 20px rgba(0, 61, 165, 0.4);
        }

        @media (max-width: 768px) {
            .products-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 25px;
            }
            
            .page-title {
                font-size: 2.5rem;
            }
            
            .card-actions {
                flex-direction: column;
            }
            
            .detail-btn {
                width: 100%;
                height: 50px;
            }
        }

        @media (max-width: 480px) {
            .products-grid {
                grid-template-columns: 1fr;
                gap: 20px;
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
    Integer specialMemberId = (Integer) session.getAttribute("memberId");
    String specialMemberName = (String) session.getAttribute("memberName");
    boolean specialPageIsLoggedIn = (specialMemberId != null);
    
    // 分頁參數
    int currentPage = 1;
    int itemsPerPage = 8;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    
    int offset = (currentPage - 1) * itemsPerPage;
    
    // 處理訊息顯示
    String message = request.getParameter("message");
    String messageType = request.getParameter("type");
    
    // 檢查資料庫連接狀態
    boolean dbAvailable = isDatabaseAvailable();
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
            <h1 class="page-title">特別商品</h1>
            <p class="page-subtitle">珍稀限量收藏品，每一件都是獨特的藝術品</p>
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
                    String countSql = "SELECT COUNT(*) as total FROM product WHERE category_id = 4 AND status = '上架'";
                    countStmt = conn.prepareStatement(countSql);
                    countRs = countStmt.executeQuery();
                    int totalItems = 0;
                    if (countRs.next()) {
                        totalItems = countRs.getInt("total");
                    }
                    
                    // 查詢商品資料
                    String sql = "SELECT product_id, product_name, description, price, stock, main_image " +
                               "FROM product WHERE category_id = 4 AND status = '上架' " +
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
                            mainImage = "images/default_special.jpg";
                        }
                        
                        // 判斷是否為熱門商品
                        boolean isFeatured = productName != null && 
                            (productName.contains("限量") || productName.contains("簽名") || 
                             productName.contains("特別") || price > 5000);
            %>
                <div class="card-box" data-price="<%=price%>" data-stock="<%=stock%>" data-name="<%=productName.replaceAll("\"", "&quot;").replaceAll("'", "&#39;")%>">
                    <div class="special-effect"></div>
                    
                    <% if (isFeatured) { %>
                        <div class="featured-badge">限量</div>
                    <% } %>
                    
                    <div class="category-badge">特別</div>
                    
                    <img src="<%=mainImage%>" alt="<%=productName%>" onerror="this.src='images/default_special.jpg'">
                    
                    <div class="card-info">
                        <h3><%=productName%></h3>
                        <div class="product-description"><%=description != null ? description : "珍稀特別版商品，限量發售，收藏價值極高"%></div>
                        <div class="price">NT$ <%=String.format("%,.0f", price)%></div>
                        <div class="stock <%=stock <= 3 ? (stock > 0 ? "low-stock" : "out-of-stock") : "in-stock"%>">
                            <% if (stock > 5) { %>
                                庫存充足 (<%=stock%> 件)
                            <% } else if (stock > 0) { %>
                                庫存稀少 (僅剩 <%=stock%> 件)
                            <% } else { %>
                                已售完
                            <% } %>
                        </div>
                        
                        <div class="card-actions">
                            <% if (stock > 0) { %>
                                <% if (specialPageIsLoggedIn) { %>
                                    <button class="add-to-cart-btn" data-product-id="<%=productId%>" onclick="addToCart(this.dataset.productId)">立即收藏</button>
                                <% } else { %>
                                    <a href="member.jsp?redirect=special.jsp" class="add-to-cart-btn">登入購買</a>
                                <% } %>
                            <% } else { %>
                                <button class="add-to-cart-btn" disabled>已售完</button>
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
                                <h2>暫無特別商品</h2>
                                <p>目前沒有可用的特別商品，請稍後再來查看！</p>
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
                    <% if (currentPage > 1) { %>
                        <a href="special.jsp?page=<%=currentPage-1%>" class="page-btn">&laquo; 上一頁</a>
                    <% } %>
                    
                    <% 
                    int startPage = Math.max(1, currentPage - 2);
                    int endPage = Math.min(totalPages, currentPage + 2);
                    
                    for (int i = startPage; i <= endPage; i++) { 
                    %>
                        <% if (i == currentPage) { %>
                            <span class="page-btn current"><%=i%></span>
                        <% } else { %>
                            <a href="special.jsp?page=<%=i%>" class="page-btn"><%=i%></a>
                        <% } %>
                    <% } %>
                    
                    <% if (currentPage < totalPages) { %>
                        <a href="special.jsp?page=<%=currentPage+1%>" class="page-btn">下一頁 &raquo;</a>
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
            if (confirm('確定要收藏這件特別商品嗎？')) {
                window.location.href = 'add_to_cart.jsp?product_id=' + productId + '&quantity=1';
            }
        }

        // 頁面載入動畫
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.card-box');
            cards.forEach((card, index) => {
                card.style.opacity = '0';
                card.style.transform = 'translateY(50px)';
                setTimeout(() => {
                    card.style.transition = 'opacity 0.8s ease, transform 0.8s ease';
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 150);
            });
        });
    </script>
</body>
</html> 