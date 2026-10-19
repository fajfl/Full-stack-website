<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>服務中心 - NBA卡包商城</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/help.css">
</head>

<body>
    <%
    // 檢查會員登入狀態
    Integer memberId = (Integer) session.getAttribute("memberId");
    String memberName = (String) session.getAttribute("memberName");
    boolean isLoggedIn = memberId != null;
    %>

    <!-- 引入統一的header -->
    <%@ include file="header.jsp" %>

    <div class="help-container">
        <div class="help-content">
            <div class="help-title">
                <h1>服務中心</h1>
                <p>我們致力於為您提供最完善的購物體驗與客戶服務</p>
            </div>

            <div class="help-sections-wrapper">
                <div class="help-section">
                    <h3>🛒 購物指南</h3>
                    <ul class="faq-list">
                        <li><div class="faq-question">如何註冊會員</div><div class="faq-answer">點擊右上角「登入 / 註冊」，填寫基本資料並驗證Email即可完成註冊。</div></li>
                        <li><div class="faq-question">如何搜尋商品</div><div class="faq-answer">使用頁面上方搜尋欄輸入球員名稱、商品類型或關鍵字即可快速查詢。</div></li>
                        <li><div class="faq-question">如何加入購物車</div><div class="faq-answer">進入商品頁後點選「加入購物車」按鈕，商品將會加入右上方的購物清單。</div></li>
                        <li><div class="faq-question">如何完成結帳</div><div class="faq-answer">至購物車確認商品與數量後，點選「結帳」，選擇付款方式完成下單。</div></li>
                        <li><div class="faq-question">付款方式說明</div><div class="faq-answer">目前支援信用卡、超商付款與 LINE PAY，付款流程皆有加密保護。</div></li>
                    </ul>
                </div>

                <div class="help-section">
                    <h3>📦 配送資訊</h3>
                    <ul class="faq-list">
                        <li><div class="faq-question">配送方式與時間</div><div class="faq-answer">使用宅配或超商取貨，付款後 1～2 工作日內出貨。</div></li>
                        <li><div class="faq-question">運費計算方式</div><div class="faq-answer">單筆滿 NT$1,000 免運，未滿酌收 NT$60 運費。</div></li>
                        <li><div class="faq-question">包裝與保護措施</div><div class="faq-answer">所有商品皆使用防壓盒、氣泡紙包裝，確保卡片安全。</div></li>
                        <li><div class="faq-question">配送狀態查詢</div><div class="faq-answer">登入會員後可至「訂單查詢」追蹤出貨與配送狀態。</div></li>
                        <li><div class="faq-question">配送地區限制</div><div class="faq-answer">目前僅配送至台灣本島與金門、澎湖，暫不支援海外地區。</div></li>
                    </ul>
                </div>

                <div class="help-section">
                    <h3>🔄 退換貨政策</h3>
                    <ul class="faq-list">
                        <li><div class="faq-question">退換貨條件</div><div class="faq-answer">商品有瑕疵、錯誤或配送損壞，皆可辦理退換貨。</div></li>
                        <li><div class="faq-question">退換貨流程</div><div class="faq-answer">請於收到商品 7 日內聯繫客服並附上照片證明。</div></li>
                        <li><div class="faq-question">退款處理時間</div><div class="faq-answer">確認退貨無誤後，約 3～5 工作日內退款至原付款方式。</div></li>
                        <li><div class="faq-question">商品狀態要求</div><div class="faq-answer">退貨商品需保持完整未使用、原包裝無損。</div></li>
                        <li><div class="faq-question">運費承擔方式</div><div class="faq-answer">若為我方責任（如瑕疵、寄錯），運費由我們負擔。</div></li>
                    </ul>
                </div>

                <div class="help-section">
                    <h3>🎯 會員權益</h3>
                    <ul class="faq-list">
                        <li><div class="faq-question">會員等級制度</div><div class="faq-answer">依累積消費金額分為銅牌、銀牌、金牌三等級。</div></li>
                        <li><div class="faq-question">積分兌換方案</div><div class="faq-answer">每消費 NT$10 可累積 1 點積分，積分可折抵現金。</div></li>
                        <li><div class="faq-question">專屬優惠活動</div><div class="faq-answer">會員可獲得每月專屬折扣碼與限時商品預購權。</div></li>
                        <li><div class="faq-question">生日特惠</div><div class="faq-answer">會員生日當月可領取一次 9 折券與免費運費券。</div></li>
                        <li><div class="faq-question">VIP專屬服務</div><div class="faq-answer">金牌會員以上享有客服專線與提前得知新品上市資訊。</div></li>
                    </ul>
                </div>
            </div>


            <div class="faq-section">
                <h2>常見問題 FAQ</h2>
                
                <div class="faq-item">
                    <div class="faq-question">
                        Q: 如何確認商品的真偽？
                    </div>
                    <div class="faq-answer">
                        A: 我們所有商品都經過專業認證，每張卡片都會提供真偽證明書。如有疑慮，可聯繫客服進行驗證。
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question">
                        Q: 訂單多久會出貨？
                    </div>
                    <div class="faq-answer">
                        A: 一般商品在確認付款後1-2個工作天內出貨，特殊商品可能需要3-5個工作天。
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question">
                        Q: 可以取消已下訂單嗎？
                    </div>
                    <div class="faq-answer">
                        A: 尚未出貨的訂單可以取消，請盡快聯繫客服。已出貨的訂單需等收到商品後依退貨流程處理。
                    </div>
                </div>

                <div class="faq-item">
                    <div class="faq-question">
                        Q: 忘記密碼怎麼辦？
                    </div>
                    <div class="faq-answer">
                        A: 請在登入頁面點選「忘記密碼」，輸入註冊時的Email，我們會寄送重設密碼的連結給您。
                    </div>
                </div>
            </div>


        </div>
    </div>

    <!-- 引入統一的footer -->
    <%@ include file="footer.jsp" %>

<script>
document.addEventListener('DOMContentLoaded', function () {
    // 函數：設定手風琴效果
    // containerSelector: 父容器的選擇器 (e.g., '.help-section')
    // questionSelector: 問題元素的選擇器 (e.g., '.faq-question')
    function setupAccordion(containerSelector, questionSelector) {
        const containers = document.querySelectorAll(containerSelector);

        containers.forEach(container => {
            const questions = container.querySelectorAll(questionSelector);

            questions.forEach(question => {
                question.addEventListener('click', function () {
                    const answer = this.nextElementSibling;
                    const wasActive = this.classList.contains('active');

                    // 1. 先關閉此容器內所有已開啟的答案
                    container.querySelectorAll(questionSelector).forEach(q => {
                        q.classList.remove('active');
                        const ans = q.nextElementSibling;
                        if (ans && ans.classList.contains('faq-answer')) {
                            ans.classList.remove('active');
                            ans.style.maxHeight = null; // 設為 null 以便 CSS transition 生效
                        }
                    });

                    // 2. 如果點擊的不是剛才已開啟的，就將它打開
                    if (!wasActive) {
                        this.classList.add('active');
                        answer.classList.add('active');
                        // 設定 max-height 為內容的實際高度，以觸發平滑動畫
                        answer.style.maxHeight = answer.scrollHeight+30 + 'px';
                    }
                });
            });
        });
    }

    // 應用手風琴效果到兩個不同的區塊
    setupAccordion('.help-section', '.faq-question');
    setupAccordion('.faq-section', '.faq-question');
});
</script>

</body>
</html> 