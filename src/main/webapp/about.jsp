<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>關於我們 - NBA卡包商城</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/about.css">
</head>

<body>
    <!-- 引入統一的header -->
    <%@ include file="header.jsp" %>

    <div class="container">
        <div class="about-content">
            <div class="page-title">
                <h1>關於我們</h1>
                <p>專業的NBA球星卡收藏平台，傳承籃球文化的熱情</p>
            </div>

            <div class="about-section">
                <h2>我們的故事</h2>
                <p>
                    NBA卡包商城成立於2020年，是台灣首屈一指的NBA球星卡專業平台。我們的創立源自於對籃球運動的熱愛，
                    以及對收藏文化的深度理解。從最初的小型工作室，發展到今天擁有完整供應鏈和專業團隊的電商平台，
                    我們始終堅持為收藏家提供最優質的商品和服務。
                </p>
                <p>
                    在這個數位化的時代，我們深知每一張球星卡背後都承載著球迷的回憶與夢想。因此，我們不僅僅是商品的販售者，
                    更是籃球文化的傳播者，致力於為每一位收藏愛好者打造最完善的購物體驗。
                </p>
            </div>

            <div class="about-section">
                <h2>我們的使命</h2>
                <p>
                    「讓每一張球星卡都能找到它的歸宿，讓每一位收藏家都能實現他們的夢想。」
                    這是我們一直以來的使命。我們相信，每一張球星卡都不僅僅是一件商品，而是連接球迷與偶像、
                    過去與未來的珍貴橋樑。
                </p>
            </div>

            <div class="features-grid">
                <div class="feature-item">
                    <h3>🏆 品質保證</h3>
                    <p>所有商品均經過專業認證，確保真品品質，為您的收藏保駕護航。</p>
                </div>

                <div class="feature-item">
                    <h3>🚚 快速配送</h3>
                    <p>建立完善的物流體系，確保商品安全快速送達您手中。</p>
                </div>

                <div class="feature-item">
                    <h3>💝 專業包裝</h3>
                    <p>採用專業防護包裝，確保每一張卡片都以完美狀態抵達。</p>
                </div>

                <div class="feature-item">
                    <h3>🎯 精選商品</h3>
                    <p>嚴選NBA官方授權商品，從新秀卡到傳奇卡片，應有盡有。</p>
                </div>

                <div class="feature-item">
                    <h3>🤝 貼心服務</h3>
                    <p>專業客服團隊提供一對一諮詢，解決您的任何疑問。</p>
                </div>

                <div class="feature-item">
                    <h3>🔐 安全交易</h3>
                    <p>採用業界最高等級的安全加密技術，保護您的交易安全。</p>
                </div>
            </div>

            <div class="about-section">
                <h2>我們的創辦團隊</h2>
                <p>
                    我們的團隊由一群熱愛籃球與收藏文化的專業人士組成，每個人都有著獨特的專長與對NBA的深度熱情。
                    正是這樣的多元組合，讓我們能夠為收藏家提供最專業、最貼心的服務。
                </p>
                
                <div class="team-grid">
                    <div class="team-member">
                        <div class="member-photo">
                            <img src="images/founder_1.jpg" alt="創辦人 鄭翔元" onerror="this.src='images/nba-logo.png';">
                        </div>
                        <div class="member-info">
                            <h3>林晨</h3>
                            <p class="member-title">創辦人 & 執行長</p>
                            <p class="member-desc">這次專題是我第一次完整參與一個電商網站的開發，一開始對 JSP 和 SQL 語法不太熟悉，但在負責商品評論與搜尋模組的過程中，學會了怎麼用資料庫撈資料並動態顯示在網頁上。雖然中間遇到很多排版問題，但每次調整都讓我對 CSS 和前端結構更熟悉。這次經驗讓我覺得實作比上課更能理解概念，也更有成就感。</p>
                        </div>
                    </div>

                    <div class="team-member">
                        <div class="member-photo">
                            <img src="images/founder_2.jpg" alt="卡片專家 林晨" onerror="this.src='images/nba-logo.png';">
                        </div>
                        <div class="member-info">
                            <h3>吳振彥</h3>
                            <p class="member-title">卡片專家 & 商品總監</p>
                            <p class="member-desc">這次我負責整合購物車功能與資料庫連接以及各種JSP檔案的程式碼，也協助組員之間的模組對接。過程中遇到最多的是資料錯誤、Session 無法判斷登入狀態等問題。雖然 debug 過程很花時間，但每解決一個 bug 都讓我更理解整個 JSP 架構與邏輯運作。這次專題是很好的實戰經驗，也讓我學會如何帶領大家完成一個具體的專案。</p>
                        </div>
                    </div>

                    <div class="team-member">
                        <div class="member-photo">
                            <img src="images/founder_3.jpg" alt="社群經理 吳振彥" onerror="this.src='images/nba-logo.png';">
                        </div>
                        <div class="member-info">
                            <h3>鄭翔元</h3>
                            <p class="member-title">社群經理 & 客戶服務主管</p>
                            <p class="member-desc">我負責網站的首頁設計、廣告輪播與整體視覺風格調整。雖然以前有接觸過 HTML 和 CSS，但要讓整個網站有一致的風格還是有挑戰，尤其圖片比例很花時間。這次我學會了如何用 CSS 動畫和變化增強網頁吸引力，也體會到前端不是做得漂亮就好，更重要的是配合整體架構順暢運作。</p>
                        </div>
                    </div>
					<div class="team-member">
                        <div class="member-photo">
                            <img src="images/zongwei.jpg" alt="社群經理 吳振彥" onerror="this.src='images/nba-logo.png';">
                        </div>
                        <div class="member-info">
                            <h3>陳宗緯</h3>
                            <p class="member-title">社群經理 & 客戶服務主管</p>
                            <p class="member-desc">這次專題我主要負責的是網站完成後的功能測試與錯誤排除。我會不斷切換不同裝置與瀏覽器，例如桌機、Chrome、Edge 等，確認畫面是否跑版，連結是否正常，像是圖片沒載入、按鈕點了沒反應、輪播圖卡住等問題。我也有測試登入流程、頁面切換速度，以及廣告輪播區在不同畫面大小下的表現。雖然不寫主要程式碼，但透過這些實際操作，我學到怎麼用「使用者的角度」發現問題，也幫助組員快速修正 bug。測試看似簡單，其實是讓整個網站更穩定、流暢的一大關鍵。</p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="about-section">
                <h2>加入我們的大家庭</h2>
                <p>
                    無論您是剛入門的新手收藏家，還是經驗豐富的資深玩家，NBA卡包商城都歡迎您的加入。
                    我們不只提供商品，更建立了一個熱愛籃球、熱愛收藏的社群。在這裡，您可以：
                </p>
                <ul style="list-style-type: disc; padding-left: 30px; margin: 20px 0;">
                    <li>與其他收藏家交流心得</li>
                    <li>獲得最新的市場資訊</li>
                    <li>參與專屬的會員活動</li>
                    <li>享受VIP級別的購物體驗</li>
                </ul>
            </div>

            <div class="about-section">
                <h2>聯絡我們</h2>
                <p>
                    如果您有任何問題、建議或合作意向，歡迎隨時與我們聯繫。我們的專業團隊將竭誠為您服務，
                    讓我們一起在NBA球星卡的世界中，創造更多美好的回憶！
                </p>
            </div>
        </div>
    </div>

    <!-- 引入統一的footer -->
    <%@ include file="footer.jsp" %>
</body>
</html> 