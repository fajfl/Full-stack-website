<%@ page pageEncoding="UTF-8" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>

<!-- 統一頁腳 -->
<footer class="site-footer">
    <div class="footer-content">
        <div class="container">
            <div class="footer-sections">
                <!-- 商店資訊 -->
                <div class="footer-section">
                    <h3>NBA卡包商城</h3>
                    <p class="footer-description">
                        中原第一家NBA球員卡專業商城<br>
                        提供最優質的球員卡收藏品<br>
                        所有商品均為正品保證
                    </p>
                    <div class="social-links">
                        <a href="#" title="Facebook"><span>📘</span></a>
                        <a href="#" title="Instagram"><span>📷</span></a>
                        <a href="#" title="YouTube"><span>▶</span></a>
                        <a href="#" title="LINE"><span>💬</span></a>
                    </div>
                </div>

                <!-- 快速連結 -->
                <div class="footer-section">
                    <h3>快速連結</h3>
                    <ul class="footer-links">
                        <li><a href="index.jsp">首頁</a></li>
                        <li><a href="card.jsp">球員卡</a></li>
                        <li><a href="card_box.jsp">卡盒</a></li>
                        <li><a href="card_accessories.jsp">周邊商品</a></li>
                        <li><a href="special.jsp">特別商品</a></li>
                        <li><a href="about.jsp">關於我們</a></li>
                    </ul>
                </div>

                <!-- 會員服務 -->
                <div class="footer-section">
                    <h3>會員服務</h3>
                    <ul class="footer-links">
                        <li><a href="member.jsp">會員登入</a></li>
                        <li><a href="member_area.jsp">會員專區</a></li>
                        <li><a href="cart.jsp">購物車</a></li>
                        <li><a href="message_board.jsp">留言板</a></li>
                        <li><a href="help.jsp">常見問題</a></li>
                    </ul>
                </div>

                <!-- 客服資訊 -->
                <div class="footer-section">
                    <h3>客服資訊</h3>
                    <div class="contact-info">
                        <div class="contact-item">
                            <span>📞</span>
                            <span>客服專線：(03) 265-9999</span>
                        </div>
                        <div class="contact-item">
                            <span>✉</span>
                            <span>service@nbacard.com</span>
                        </div>
                        <div class="contact-item">
                            <span>🕒</span>
                            <span>服務時間：週一至週五 9:00-18:00</span>
                        </div>
                        <div class="contact-item">
                            <span>📍</span>
                            <span>桃園市中壢區中大路300號</span>
                        </div>
                    </div>
                </div>

                <!-- 安全認證 -->
                <div class="footer-section">
                    <h3>安全認證</h3>
                    <div class="certifications">
                        <div class="cert-item">
                            <span>🛡</span>
                            <span>SSL安全認證</span>
                        </div>
                        <div class="cert-item">
                            <span>💳</span>
                            <span>安全金流</span>
                        </div>
                        <div class="cert-item">
                            <span>🏆</span>
                            <span>正品保證</span>
                        </div>
                        <div class="cert-item">
                            <span>🚚</span>
                            <span>快速出貨</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- 版權資訊 -->
    <div class="footer-bottom">
        <div class="container">
            <div class="footer-bottom-content">
                <div class="copyright">
                    <p>&copy; <%= new SimpleDateFormat("yyyy").format(new Date()) %> NBA卡包商城. 版權所有.</p>
                    <p>網站設計與開發：NBA Card Team</p>
                </div>
                <div class="footer-links-bottom">
                    <a href="help.jsp">隱私權政策</a>
                    <a href="help.jsp">服務條款</a>
                    <a href="help.jsp">退換貨政策</a>
                    <a href="help.jsp">聯絡我們</a>
                </div>
            </div>
        </div>
    </div>
</footer>

<!-- 返回頂部按鈕 -->
<button id="backToTop" class="back-to-top" title="回到頂部">
    <span>⬆</span>
</button>

<!-- Cookie 同意通知條 -->
<div class="cookie-banner" id="cookieBanner">
  <div class="cookie-text">
    <h3>We value your privacy</h3>
    <p>We use cookies to enhance your browsing experience, serve personalized ads or content, and analyze our traffic. 
      By clicking "Accept All", you consent to our use of cookies.</p>
  </div>
  <div class="cookie-buttons">
    <button onclick="rejectCookies()">Reject All</button>
    <button class="accept" onclick="acceptCookies()">Accept All</button>
  </div>
</div>

<script>
// 返回頂部功能
document.addEventListener('DOMContentLoaded', function() {
    var backToTopBtn = document.getElementById('backToTop');
    
    // 監聽滾動事件
    window.addEventListener('scroll', function() {
        if (window.pageYOffset > 300) {
            backToTopBtn.style.display = 'flex';
        } else {
            backToTopBtn.style.display = 'none';
        }
    });
    
    // 點擊返回頂部
    backToTopBtn.addEventListener('click', function() {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });

    // 判斷是否已經同意或拒絕 cookies
    const consent = getCookie("cookieConsent");
    if (consent === "accepted" || consent === "rejected") {
      document.getElementById("cookieBanner").classList.add("hidden");
    }
});

function acceptCookies() {
    setCookie("cookieConsent", "accepted", 365);
    document.getElementById("cookieBanner").classList.add("hidden");
}

function rejectCookies() {
    setCookie("cookieConsent", "rejected", 365);
    document.getElementById("cookieBanner").classList.add("hidden");
}

function setCookie(name, value, days) {
    const d = new Date();
    d.setTime(d.getTime() + days * 24 * 60 * 60 * 1000);
    document.cookie = name + "=" + value + "; path=/; expires=" + d.toUTCString();
}

function getCookie(name) {
    const cookies = document.cookie.split("; ");
    for (let c of cookies) {
      const [k, v] = c.split("=");
      if (k === name) return decodeURIComponent(v);
    }
    return "";
}
</script> 