<%@ page pageEncoding="UTF-8" %>
<%
    // 檢查會員登入狀態（使用局部變數避免衝突）
    Integer headerMemberId = (Integer) session.getAttribute("memberId");
    String headerMemberName = (String) session.getAttribute("memberName");
    boolean headerIsLoggedIn = headerMemberId != null;
    
    // 獲取當前頁面名稱用於設定active狀態
    String headerCurrentPage = request.getRequestURI();
    headerCurrentPage = headerCurrentPage.substring(headerCurrentPage.lastIndexOf("/") + 1);
    
    // 判斷是否在admin目錄下
    boolean isAdminPage = headerCurrentPage.startsWith("admin_");
    
    // 根據是否在admin目錄下設定路徑前綴
    String pathPrefix = isAdminPage ? "../" : "";
    
    // 錯誤處理：確保圖片路徑安全
    String logoPath = pathPrefix + "images/NBA_card_pack_logo_transparent.png";
    String memberIconPath = pathPrefix + "images/member_icon.png";
    String cartIconPath = pathPrefix + "images/cart_icon.png";
%>

<!-- Header -->
<header>
    <div class="header-container">
        <div class="logo">
            <img src="<%=logoPath%>" alt="網站標誌" onerror="this.style.display='none'">
            <h1>NBA卡包商城</h1>
        </div>
        <div class="nav-right">
            <div class="search-bar">
                <form action="<%=pathPrefix%>search_results.jsp" method="get" onsubmit="return validateSearch()">
                    <input type="text" name="query" id="searchInput" placeholder="你想查詢甚麼相關商品?" required maxlength="100">
                    <button type="submit">🔍</button>
                </form>
            </div>
            <div class="member-section">
                <% if (headerIsLoggedIn) { %>
                    <div class="member-dropdown">
                        <a href="<%=pathPrefix%>member_area.jsp" class="member-info">
                            <img src="<%=memberIconPath%>" alt="會員圖示" onerror="this.style.display='none'">
                            <span><%=headerMemberName != null ? headerMemberName : "會員"%></span>
                        </a>
                        <div class="dropdown-menu">
                            <a href="<%=pathPrefix%>member_area.jsp">會員專區</a>
                            <a href="<%=pathPrefix%>cart.jsp">購物車</a>
                            <a href="<%=pathPrefix%>member.jsp?action=logout">登出</a>
                        </div>
                    </div>
                <% } else { %>
                    <a href="<%=pathPrefix%>member.jsp">
                        <img src="<%=memberIconPath%>" alt="會員圖示" onerror="this.style.display='none'">
                        <span>登入</span>
                    </a>
                <% } %>
            </div>
            <a href="<%=pathPrefix%>cart.jsp" class="cart-link">
                <img src="<%=cartIconPath%>" alt="購物車圖示" onerror="this.style.display='none'">
                <span class="cart-count" id="cartCount">0</span>
            </a>
        </div>
    </div>
    
    <!-- 簡化的導航菜單 -->
    <nav class="nav-menu">
        <ul>
            <li><a href="<%=pathPrefix%>index.jsp" <%= "index.jsp".equals(headerCurrentPage) ? "class=\"active\"" : "" %>>首頁</a></li>
            <li><a href="<%=pathPrefix%>card.jsp" <%= "card.jsp".equals(headerCurrentPage) ? "class=\"active\"" : "" %>>單卡</a></li>
            <li><a href="<%=pathPrefix%>card_box.jsp" <%= "card_box.jsp".equals(headerCurrentPage) ? "class=\"active\"" : "" %>>卡盒</a></li>
            <li><a href="<%=pathPrefix%>card_accessories.jsp" <%= "card_accessories.jsp".equals(headerCurrentPage) ? "class=\"active\"" : "" %>>卡片周邊商品</a></li>
            <li><a href="<%=pathPrefix%>special.jsp" <%= "special.jsp".equals(headerCurrentPage) ? "class=\"active\"" : "" %>>特別商品</a></li>
            <li><a href="<%=pathPrefix%>help.jsp" <%= "help.jsp".equals(headerCurrentPage) ? "class=\"active\"" : "" %>>服務中心</a></li>
            <li><a href="<%=pathPrefix%>about.jsp" <%= "about.jsp".equals(headerCurrentPage) ? "class=\"active\"" : "" %>>關於我們</a></li>
            <li><a href="<%=pathPrefix%>member_area.jsp" <%= "member_area.jsp".equals(headerCurrentPage) ? "class=\"active\"" : "" %>>會員專區</a></li>
            <li><a href="<%=pathPrefix%>message_board.jsp" <%= "message_board.jsp".equals(headerCurrentPage) ? "class=\"active\"" : "" %>>留言板</a></li>
            <% String userEmail = (String) session.getAttribute("userEmail");
               if ("admin@example.com".equals(userEmail)) { %>
                <li><a href="<%=isAdminPage ? "admin_panel.jsp" : "admin/admin_panel.jsp"%>" style="color: red; font-weight: bold;">🔧 管理</a></li>
            <% } %>
        </ul>
    </nav>
</header>

<script>
// 全域變數：從伺服器端獲取的登入狀態
var isUserLoggedIn = <%= headerIsLoggedIn ? "true" : "false" %>;
var pathPrefix = "<%=pathPrefix%>";

// 搜尋驗證
function validateSearch() {
    var query = document.getElementById('searchInput').value.trim();
    if (query.length < 1) {
        alert('請輸入搜尋關鍵字');
        return false;
    }
    // 防止XSS攻擊
    if (query.includes('<') || query.includes('>') || query.includes('script')) {
        alert('搜尋內容包含非法字符');
        return false;
    }

    // 儲存搜尋關鍵字到 Cookie
    if (query !== "") {
        document.cookie = "lastSearch=" + encodeURIComponent(query) + "; max-age=" + 60 * 60 * 24 * 7 + "; path=/";
    }

    return true;
}

// 更新購物車數量
function updateCartCount() {
    if (isUserLoggedIn) {
        fetch(pathPrefix + 'get_cart_count.jsp')
            .then(function(response) {
                if (!response.ok) {
                    throw new Error('網路響應錯誤');
                }
                return response.json();
            })
            .then(function(data) {
                var cartCountElement = document.getElementById('cartCount');
                if (cartCountElement) {
                    cartCountElement.textContent = data.count || 0;
                }
            })
            .catch(function(error) {
                console.error('更新購物車數量失敗:', error);
                // 如果API失敗，仍顯示0
                var cartCountElement = document.getElementById('cartCount');
                if (cartCountElement) {
                    cartCountElement.textContent = '0';
                }
            });
    } else {
        // 未登入用戶顯示0
        var cartCountElement = document.getElementById('cartCount');
        if (cartCountElement) {
            cartCountElement.textContent = '0';
        }
    }
}

// 讀取 cookie 中指定名稱的值
function getCookieValue(name) {
    const cookies = document.cookie.split("; ");
    for (let c of cookies) {
        const [k, v] = c.split("=");
        if (k === name) return decodeURIComponent(v);
    }
    return "";
}

// 頁面加載時更新購物車數量並填入上次搜尋關鍵字
document.addEventListener('DOMContentLoaded', function() {
    updateCartCount();

    // 頁面載入時自動填入上次搜尋關鍵字
    const lastSearch = getCookieValue("lastSearch");
    if (lastSearch) {
        document.getElementById("searchInput").value = lastSearch;
    }
});
</script> 