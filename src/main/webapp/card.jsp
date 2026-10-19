<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>

<%
    // 檢查會員登入狀態（使用不同變數名避免衝突）
    Integer cardPageMemberId = (Integer) session.getAttribute("memberId");
    String cardPageMemberName = (String) session.getAttribute("memberName");
    boolean cardPageIsLoggedIn = cardPageMemberId != null;
    
    // 分頁參數
    int pageSize = 12;
    int cardPageCurrentPage = 1;
    try {
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            cardPageCurrentPage = Integer.parseInt(pageParam);
        }
        if (cardPageCurrentPage < 1) cardPageCurrentPage = 1;
    } catch (Exception e) {
        cardPageCurrentPage = 1;
    }
    
    int offset = (cardPageCurrentPage - 1) * pageSize;
    List<Map<String, Object>> products = new ArrayList<>();
    int totalProducts = 0;
    boolean dbAvailable = isDatabaseAvailable();
    
    // 處理訊息顯示
    String message = request.getParameter("message");
    String messageType = request.getParameter("type");
    
    if (dbAvailable) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = getConnection();
            if (conn != null) {
                // 計算總商品數量
                pstmt = conn.prepareStatement("SELECT COUNT(*) as total FROM product WHERE category_id = 1 AND status = '上架'");
                rs = pstmt.executeQuery();
                if (rs.next()) {
                    totalProducts = rs.getInt("total");
                }
                rs.close();
                pstmt.close();
                
                // 查詢商品資料
                String sql = "SELECT product_id, product_name, description, price, stock, main_image, " +
                           "player_name, team, card_year, card_series, rarity, is_featured " +
                           "FROM product WHERE category_id = 1 AND status = '上架' " +
                           "ORDER BY is_featured DESC, created_at DESC LIMIT ? OFFSET ?";
                
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, pageSize);
                pstmt.setInt(2, offset);
                rs = pstmt.executeQuery();
                
                while (rs.next()) {
                    int productId = rs.getInt("product_id");
                    String productName = rs.getString("product_name");
                    String description = rs.getString("description");
                    double price = rs.getDouble("price");
                    int stock = rs.getInt("stock");
                    String mainImage = rs.getString("main_image");
                    String playerName = rs.getString("player_name");
                    String team = rs.getString("team");
                    String cardYear = rs.getString("card_year");
                    String cardSeries = rs.getString("card_series");
                    String rarity = rs.getString("rarity");
                    boolean isFeatured = rs.getBoolean("is_featured");
                    
                    Map<String, Object> product = new HashMap<>();
                    product.put("id", productId);
                    product.put("name", productName);
                    product.put("price", price);
                    product.put("stock", stock);
                    product.put("image", mainImage != null ? mainImage : "images/default_card.jpg");
                    product.put("description", description);
                    product.put("player", playerName != null ? playerName : "NBA球員");
                    product.put("rarity", rarity != null ? rarity : "稀有");
                    product.put("team", team);
                    product.put("year", cardYear);
                    product.put("series", cardSeries);
                    product.put("featured", isFeatured);
                    
                    products.add(product);
                }
            }
            
        } catch (Exception e) {
            System.err.println("Database error in card.jsp: " + e.getMessage());
            dbAvailable = false;
        } finally {
            closeResources(conn, pstmt, rs);
        }
    }
    
    // 計算總頁數
    int totalPages = totalProducts > 0 ? (int) Math.ceil((double) totalProducts / pageSize) : 0;
%>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NBA球員卡 - NBA卡包商城</title>
    <link rel="stylesheet" href="css/common.css">
    <style>
        /* 稀有度顏色主題 */
        .rarity-common { 
            background: linear-gradient(135deg, #6c757d, #868e96);
            color: white;
        }
        .rarity-稀有 { 
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
        }
        .rarity-超稀有 { 
            background: linear-gradient(135deg, #007bff, #6610f2);
            color: white;
        }
        .rarity-傳奇 { 
            background: linear-gradient(135deg, #fd7e14, #ffc107);
            color: white;
        }
        .rarity-神話 { 
            background: linear-gradient(135deg, #dc3545, #e83e8c);
            color: white;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        /* 商品網格 */
        .card-boxes {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
            margin: 30px 0;
            min-height: 400px;
        }

        /* 商品卡片增強樣式 */
        .card-box {
            background: white;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
            overflow: hidden;
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
            box-shadow: 
                0 30px 60px rgba(0,0,0,0.25),
                0 0 40px rgba(0, 61, 165, 0.15);
            z-index: 10;
        }

        .card-box img {
            width: 100%;
            height: 300px;
            object-fit: contain;
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            padding: 1rem;
            transition: all 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            z-index: 1;
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

        .card-box h3 {
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

        .player-name {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .rarity-badge {
            display: inline-block;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
            margin-bottom: 15px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
            z-index: 2;
        }

        .category-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: linear-gradient(135deg, var(--primary-blue), var(--accent-blue));
            color: white;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: bold;
            box-shadow: 0 4px 15px rgba(0, 61, 165, 0.4);
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

        .stock.out-of-stock {
            color: #dc3545;
            background: rgba(220, 53, 69, 0.1);
            border: 1px solid rgba(220, 53, 69, 0.2);
        }

        .stock.low-stock {
            color: #ffc107;
            background: rgba(255, 193, 7, 0.1);
            border: 1px solid rgba(255, 193, 7, 0.2);
            animation: pulse 2s infinite;
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

        /* 篩選和排序區域 */
        .filter-section {
            background: white;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
        }

        .filter-controls {
            display: flex;
            gap: 20px;
            align-items: center;
            flex-wrap: wrap;
        }

        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .filter-group label {
            font-weight: 600;
            color: var(--primary-blue);
            white-space: nowrap;
        }

        .filter-group select {
            padding: 8px 12px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            background: white;
            min-width: 120px;
        }

        /* 分頁資訊 */
        .page-info {
            text-align: center;
            margin-bottom: 20px;
            color: #666;
            font-size: 1rem;
        }

        /* 空狀態樣式 */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #666;
        }

        .empty-state h3 {
            color: var(--primary-blue);
            margin-bottom: 15px;
            font-size: 1.8rem;
        }

        /* 特色商品標籤 */
        .featured-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: linear-gradient(135deg, #ff6b6b, #ffa500);
            color: white;
            padding: 5px 10px;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: bold;
            z-index: 4;
            box-shadow: 0 2px 8px rgba(255, 107, 107, 0.4);
        }

        /* 響應式設計 */
        @media (max-width: 768px) {
            .card-boxes {
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
            }
            
            .filter-controls {
                flex-direction: column;
                align-items: stretch;
            }
            
            .filter-group {
                justify-content: space-between;
            }
            
            .filter-group select {
                min-width: auto;
                flex: 1;
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
            .card-boxes {
                grid-template-columns: 1fr;
                gap: 15px;
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

        <!-- 頁面標題 -->
        <div class="page-title">
            <h1>NBA球員卡</h1>
            <p>收藏您最愛的NBA球星卡片</p>
        </div>

        <!-- 篩選和排序 -->
        <div class="filter-section">
            <div class="filter-controls">
                <div class="filter-group">
                    <label for="rarityFilter">稀有度:</label>
                    <select id="rarityFilter" onchange="filterCards()">
                        <option value="">全部</option>
                        <option value="傳奇">傳奇</option>
                        <option value="超稀有">超稀有</option>
                        <option value="稀有">稀有</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="sortBy">排序:</label>
                    <select id="sortBy" onchange="sortCards()">
                        <option value="default">預設</option>
                        <option value="price-low">價格由低到高</option>
                        <option value="price-high">價格由高到低</option>
                        <option value="name">名稱</option>
                    </select>
                </div>
                
                <div class="filter-group">
                    <label for="stockFilter">庫存狀態:</label>
                    <select id="stockFilter" onchange="filterCards()">
                        <option value="">全部</option>
                        <option value="in-stock">有庫存</option>
                        <option value="low-stock">庫存不足</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- 分頁資訊 -->
        <div class="page-info">
            顯示第 <%=(offset + 1)%> - <%=Math.min(offset + pageSize, totalProducts)%> 項，共 <%=totalProducts%> 項商品
        </div>

        <!-- 商品網格 -->
        <div class="card-boxes" id="cardContainer">
            <% if (!dbAvailable) { %>
                <div class="empty-state">
                    <h3>🔌 系統維護中</h3>
                    <p>目前無法連接到資料庫，暫時無法顯示商品資訊。</p>
                    <div style="margin-top: 20px;">
                        <a href="test_db.jsp" class="btn btn-info">檢查系統狀態</a>
                        <a href="javascript:location.reload()" class="btn btn-primary">重新整理</a>
                        <a href="index.jsp" class="btn btn-secondary">返回首頁</a>
                    </div>
                </div>
            <% } else if (products.isEmpty()) { %>
                <div class="empty-state">
                    <h3>暫無商品</h3>
                    <p>目前沒有可用的球員卡商品，請稍後再來查看。</p>
                    <div style="margin-top: 20px;">
                        <a href="index.jsp" class="btn btn-primary">返回首頁</a>
                        <a href="card_box.jsp" class="btn btn-secondary">瀏覽卡盒</a>
                    </div>
                </div>
            <% } else { %>
                <% for (Map<String, Object> product : products) { %>
                    <div class="card-box" data-rarity="<%=product.get("rarity")%>" data-price="<%=product.get("price")%>" data-stock="<%=product.get("stock")%>" data-name="<%=((String)product.get("name")).replaceAll("\"", "&quot;").replaceAll("'", "&#39;")%>">
                        <% 
                        String productName = (String) product.get("name");
                        if (productName != null && (productName.contains("Jordan") || productName.contains("LeBron") || productName.contains("Kobe"))) { 
                        %>
                            <div class="featured-badge">熱門</div>
                        <% } %>
                        
                        <div class="category-badge">球員卡</div>
                        
                        <img src="<%=product.get("image")%>" alt="<%=product.get("name")%>" onerror="handleImageError(this, '<%=product.get("name")%>')">
                        
                        <div class="card-info">
                            <div class="rarity-badge rarity-<%=product.get("rarity")%>"><%=product.get("rarity")%></div>
                            <h3><%=product.get("name")%></h3>
                            <div class="player-name">球員：<%=product.get("player")%></div>
                            <div class="price">NT$ <%=String.format("%,.0f", (Double)product.get("price"))%></div>
                            <div class="stock <%=(Integer)product.get("stock") <= 5 ? (((Integer)product.get("stock") > 0) ? "low-stock" : "out-of-stock") : "in-stock"%>">
                                <% if ((Integer)product.get("stock") > 10) { %>
                                    庫存充足 (<%=product.get("stock")%> 張)
                                <% } else if ((Integer)product.get("stock") > 0) { %>
                                    庫存不多 (<%=product.get("stock")%> 張)
                                <% } else { %>
                                    缺貨中
                                <% } %>
                            </div>
                            
                            <div class="card-actions">
                                <% if ((Integer)product.get("stock") > 0) { %>
                                    <% if (cardPageIsLoggedIn) { %>
                                        <button class="add-to-cart-btn" data-product-id="<%=product.get("id")%>" onclick="addToCart(this.dataset.productId)">加入購物車</button>
                                    <% } else { %>
                                        <a href="member.jsp?redirect=card.jsp" class="add-to-cart-btn">登入購買</a>
                                    <% } %>
                                <% } else { %>
                                    <button class="add-to-cart-btn" disabled>缺貨中</button>
                                <% } %>
                                
                                <a href="product_detail.jsp?id=<%=product.get("id")%>" class="detail-btn" title="查看詳情">
                                    ℹ️
                                </a>
                            </div>
                        </div>
                    </div>
                <% } %>
            <% } %>
        </div>

        <!-- 分頁導航 -->
        <% if (totalPages > 1) { %>
            <div class="pagination">
                <% if (cardPageCurrentPage > 1) { %>
                    <a href="card.jsp?page=<%=cardPageCurrentPage-1%>" class="page-btn">&laquo; 上一頁</a>
                <% } %>
                
                <% 
                int startPage = Math.max(1, cardPageCurrentPage - 2);
                int endPage = Math.min(totalPages, cardPageCurrentPage + 2);
                
                for (int i = startPage; i <= endPage; i++) { 
                %>
                    <% if (i == cardPageCurrentPage) { %>
                        <span class="page-btn current"><%=i%></span>
                    <% } else { %>
                        <a href="card.jsp?page=<%=i%>" class="page-btn"><%=i%></a>
                    <% } %>
                <% } %>
                
                <% if (cardPageCurrentPage < totalPages) { %>
                    <a href="card.jsp?page=<%=cardPageCurrentPage+1%>" class="page-btn">下一頁 &raquo;</a>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- 引入統一的footer -->
    <%@ include file="footer.jsp" %>

    <script>
        // 智能圖片錯誤處理函數
        function handleImageError(img, productName) {
            // 防止無限循環
            if (img.getAttribute('data-fallback-attempted') === 'true') {
                img.src = 'images/nba-logo.png';
                return;
            }
            img.setAttribute('data-fallback-attempted', 'true');
            
            // 根據產品名稱智能選擇備用圖片
            if (productName && productName.toLowerCase().includes('giannis')) {
                img.src = 'images/card_giannis_1.jpg';
            } else if (productName && productName.toLowerCase().includes('yao')) {
                img.src = 'images/card_yao_1.jpg';
            } else if (productName && productName.toLowerCase().includes('edwards')) {
                img.src = 'images/card_edwards_1.jpg';
            } else if (productName && productName.toLowerCase().includes('booker')) {
                img.src = 'images/card_booker_1.jpg';
            } else if (productName && productName.toLowerCase().includes('mitchell')) {
                img.src = 'images/card_mitchell_1.jpg';
            } else if (productName && productName.toLowerCase().includes('lin')) {
                img.src = 'images/card_lin_1.jpg';
            } else if (productName && productName.toLowerCase().includes('luka')) {
                img.src = 'images/card_luka_1.jpg';
            } else if (productName && (productName.toLowerCase().includes('sga') || productName.toLowerCase().includes('gilgeous'))) {
                img.src = 'images/card_sga_1.jpg';
            } else {
                // 通用備用圖片
                img.src = 'images/nba-logo.png';
            }
        }

        function addToCart(productId) {
            if (confirm('確定要加入購物車嗎？')) {
                window.location.href = 'add_to_cart.jsp?product_id=' + productId + '&quantity=1';
            }
        }

        // 頁面載入動畫
        function initializeCards() {
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
        }

        function filterCards() {
            var rarity = document.getElementById('rarityFilter').value;
            var stock = document.getElementById('stockFilter').value;
            var cards = document.querySelectorAll('.card-box');
            
            for (var i = 0; i < cards.length; i++) {
                var card = cards[i];
                var show = true;
                
                if (rarity && card.getAttribute('data-rarity') !== rarity) {
                    show = false;
                }
                
                if (stock) {
                    var stockValue = parseInt(card.getAttribute('data-stock'));
                    if (stock === 'in-stock' && stockValue <= 5) {
                        show = false;
                    } else if (stock === 'low-stock' && stockValue > 5) {
                        show = false;
                    }
                }
                
                card.style.display = show ? 'block' : 'none';
            }
        }

        function sortCards() {
            var sortBy = document.getElementById('sortBy').value;
            var container = document.getElementById('cardContainer');
            var cards = container.querySelectorAll('.card-box');
            var cardArray = Array.prototype.slice.call(cards);
            
            cardArray.sort(function(a, b) {
                var aValue, bValue;
                
                switch (sortBy) {
                    case 'price-low':
                        aValue = parseFloat(a.getAttribute('data-price'));
                        bValue = parseFloat(b.getAttribute('data-price'));
                        return aValue - bValue;
                    case 'price-high':
                        aValue = parseFloat(a.getAttribute('data-price'));
                        bValue = parseFloat(b.getAttribute('data-price'));
                        return bValue - aValue;
                    case 'name':
                        aValue = a.getAttribute('data-name');
                        bValue = b.getAttribute('data-name');
                        return aValue.localeCompare(bValue);
                    default:
                        return 0;
                }
            });
            
            for (var i = 0; i < cardArray.length; i++) {
                container.appendChild(cardArray[i]);
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            initializeCards();
        });
    </script>
</body>
</html> 