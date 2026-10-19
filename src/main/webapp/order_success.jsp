<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>訂單成功 - NBA卡包商城</title>
    <style>
        :root {
            --primary-color: #003da5;
            --secondary-color: #00c3ff;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --light-bg: #f8f9fa;
            --card-bg: #ffffff;
            --text-dark: #2c3e50;
            --text-muted: #6c757d;
            --shadow: 0 4px 12px rgba(0, 61, 165, 0.1);
            --shadow-hover: 0 8px 25px rgba(0, 61, 165, 0.15);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: var(--text-dark);
            overflow-x: hidden;
        }

        /* 成功背景動畫 */
        .success-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: 0;
        }

        .confetti {
            position: absolute;
            width: 10px;
            height: 10px;
            background: #ffd700;
            animation: confetti-fall 3s linear infinite;
        }

        .confetti:nth-child(odd) {
            background: #ff6b6b;
            width: 8px;
            height: 8px;
            animation-duration: 2.5s;
        }

        .confetti:nth-child(even) {
            background: #4ecdc4;
            width: 6px;
            height: 6px;
            animation-duration: 3.5s;
        }

        @keyframes confetti-fall {
            0% {
                transform: translateY(-100vh) rotate(0deg);
                opacity: 1;
            }
            100% {
                transform: translateY(100vh) rotate(720deg);
                opacity: 0;
            }
        }

        /* 導航列 */
        .navbar {
            background: var(--primary-color);
            padding: 1rem 0;
            box-shadow: var(--shadow);
            position: relative;
            z-index: 1000;
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 2rem;
        }

        .nav-brand a {
            color: white;
            text-decoration: none;
            font-size: 1.5rem;
            font-weight: bold;
        }

        .nav-links {
            display: flex;
            gap: 2rem;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
        }

        .nav-links a:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-2px);
        }

        /* 主容器 */
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem;
            position: relative;
            z-index: 10;
        }

        /* 成功區域 */
        .success-section {
            text-align: center;
            margin-bottom: 3rem;
            animation: bounceIn 1s ease-out;
        }

        @keyframes bounceIn {
            0% {
                opacity: 0;
                transform: scale(0.3);
            }
            50% {
                opacity: 1;
                transform: scale(1.05);
            }
            70% {
                transform: scale(0.9);
            }
            100% {
                opacity: 1;
                transform: scale(1);
            }
        }

        .success-icon {
            font-size: 5rem;
            margin-bottom: 1rem;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.1);
            }
            100% {
                transform: scale(1);
            }
        }

        .success-section h1 {
            font-size: 2.5rem;
            color: white;
            margin-bottom: 1rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }

        .success-section p {
            font-size: 1.2rem;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 2rem;
        }

        /* 結帳步驟完成 */
        .checkout-steps {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-bottom: 3rem;
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 1rem;
            box-shadow: var(--shadow);
        }

        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
            opacity: 0.8;
        }

        .step.completed {
            color: var(--success-color);
        }

        .step-number {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--success-color);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-bottom: 0.5rem;
            animation: checkmark 0.5s ease-in-out;
        }

        @keyframes checkmark {
            0% {
                transform: scale(0);
            }
            50% {
                transform: scale(1.2);
            }
            100% {
                transform: scale(1);
            }
        }

        .step-arrow {
            margin: 0 2rem;
            font-size: 1.5rem;
            color: var(--success-color);
        }

        .step-text {
            font-size: 0.9rem;
            font-weight: 500;
        }

        /* 訂單資訊卡片 */
        .order-cards {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 2rem;
            margin-bottom: 3rem;
        }

        .info-card {
            background: var(--card-bg);
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--shadow);
            animation: slideInUp 0.8s ease-out;
            transition: all 0.3s ease;
        }

        .info-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-hover);
        }

        @keyframes slideInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .card-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
        }

        .detail-row:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }

        .label {
            color: var(--text-muted);
            font-weight: 500;
        }

        .value {
            font-weight: 600;
            color: var(--text-dark);
        }

        .order-number {
            color: var(--primary-color);
            font-size: 1.1rem;
            font-family: monospace;
        }

        .status {
            padding: 0.25rem 0.75rem;
            border-radius: 0.5rem;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .status.待付款 {
            background: rgba(255, 193, 7, 0.1);
            color: var(--warning-color);
        }

        .status.處理中 {
            background: rgba(0, 123, 255, 0.1);
            color: #007bff;
        }

        .status.已完成 {
            background: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }

        /* 付款提醒卡片 */
        .payment-notice {
            background: linear-gradient(135deg, #ffeaa7, #fdcb6e);
            border-radius: 1rem;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow);
            animation: slideInLeft 1s ease-out;
        }

        @keyframes slideInLeft {
            from {
                opacity: 0;
                transform: translateX(-30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .payment-notice h3 {
            color: #d63031;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .bank-info {
            background: rgba(255, 255, 255, 0.8);
            padding: 1.5rem;
            border-radius: 0.75rem;
            margin: 1rem 0;
            font-family: monospace;
        }

        .bank-info p {
            margin-bottom: 0.5rem;
        }

        .notice-text {
            font-style: italic;
            color: #636e72;
            margin-top: 1rem;
        }

        /* 操作按鈕 */
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }

        .btn {
            padding: 1rem 2rem;
            border: none;
            border-radius: 0.75rem;
            font-size: 1rem;
            font-weight: 600;
            text-decoration: none;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: var(--shadow);
            min-width: 180px;
        }

        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
        }

        .btn-secondary {
            background: linear-gradient(135deg, #6c757d, #5a6268);
            color: white;
        }

        .btn:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-hover);
        }

        /* 倒數計時 */
        .countdown {
            text-align: center;
            margin: 2rem 0;
            animation: fadeIn 2s ease-in;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .countdown p {
            color: rgba(255, 255, 255, 0.8);
            font-size: 1rem;
        }

        .countdown-number {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--warning-color);
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }

        /* 響應式設計 */
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .order-cards {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }

            .success-section h1 {
                font-size: 2rem;
            }

            .checkout-steps {
                padding: 1rem;
            }

            .step-arrow {
                display: none;
            }

            .checkout-steps {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 0.5rem;
            }

            .nav-links {
                display: none;
            }
        }

        @media (max-width: 480px) {
            .success-section h1 {
                font-size: 1.5rem;
            }

            .success-icon {
                font-size: 3rem;
            }

            .info-card,
            .payment-notice {
                padding: 1rem;
            }

            .btn {
                padding: 0.75rem 1.5rem;
                min-width: auto;
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <%
    // 檢查登入狀態
    Integer memberId = (Integer) session.getAttribute("memberId");
    String memberName = (String) session.getAttribute("memberName");
    if (memberId == null) {
        response.sendRedirect("member.jsp");
        return;
    }
    
    String orderIdStr = request.getParameter("orderId");
    if (orderIdStr == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    int orderId = 0;
    try {
        orderId = Integer.parseInt(orderIdStr);
    } catch (NumberFormatException e) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    // 獲取訂單資訊
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    double totalAmount = 0;
    double shippingFee = 0;
    double finalAmount = 0;
    String paymentMethod = "";
    String paymentStatus = "";
    String orderStatus = "";
    String shippingName = "";
    String shippingPhone = "";
    String shippingAddress = "";
    String orderNote = "";
    String created_at = "";
    
    try {
        conn = getConnection();
        
        String orderSql = "SELECT total_amount, shipping_fee, final_amount, payment_method, payment_status, " +
                        "order_status, shipping_name, shipping_phone, shipping_address, order_note, created_at " +
                        "FROM orders WHERE order_id = ? AND member_id = ?";
        pstmt = conn.prepareStatement(orderSql);
        pstmt.setInt(1, orderId);
        pstmt.setInt(2, memberId);
        rs = pstmt.executeQuery();
        
        if (!rs.next()) {
            response.sendRedirect("index.jsp");
            return;
        }
        
        totalAmount = rs.getDouble("total_amount");
        shippingFee = rs.getDouble("shipping_fee");
        finalAmount = rs.getDouble("final_amount");
        paymentMethod = rs.getString("payment_method");
        paymentStatus = rs.getString("payment_status");
        orderStatus = rs.getString("order_status");
        shippingName = rs.getString("shipping_name");
        shippingPhone = rs.getString("shipping_phone");
        shippingAddress = rs.getString("shipping_address");
        orderNote = rs.getString("order_note");
        created_at = rs.getString("created_at");
        
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("index.jsp");
        return;
    } finally {
        closeResources(conn, pstmt, rs);
    }
    %>

    <!-- 成功背景動畫 -->
    <div class="success-bg" id="confettiContainer"></div>

        <!-- 導航列 -->
        <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand">
                <a href="index.jsp">🏀 NBA卡包商城</a>
            </div>
            <div class="nav-links">
                <a href="index.jsp">首頁</a>
                <a href="member_area.jsp">會員專區</a>
                <a href="member.jsp?action=logout">登出</a>
            </div>
            </div>
        </nav>

    <div class="container">
        <!-- 成功訊息 -->
        <div class="success-section">
            <div class="success-icon">🎉</div>
            <h1>訂單建立成功！</h1>
            <p>感謝您的購買，我們將盡快為您處理訂單</p>
        </div>

        <!-- 結帳步驟完成 -->
        <div class="checkout-steps">
            <div class="step completed">
                <div class="step-number">✓</div>
                <div class="step-text">購物車</div>
            </div>
            <div class="step-arrow">→</div>
            <div class="step completed">
                <div class="step-number">✓</div>
                <div class="step-text">結帳資訊</div>
            </div>
            <div class="step-arrow">→</div>
            <div class="step completed">
                <div class="step-number">✓</div>
                <div class="step-text">確認訂單</div>
            </div>
            <div class="step-arrow">→</div>
            <div class="step completed">
                <div class="step-number">✓</div>
                <div class="step-text">完成</div>
            </div>
        </div>

        <!-- 訂單資訊卡片 -->
        <div class="order-cards">
            <!-- 訂單詳情 -->
            <div class="info-card">
                <h2 class="card-title">📋 訂單詳情</h2>
                <div class="detail-row">
                    <span class="label">訂單編號</span>
                    <span class="value order-number">#<%=String.format("%06d", orderId)%></span>
                </div>
                <div class="detail-row">
                    <span class="label">訂單時間</span>
                    <span class="value"><%=created_at%></span>
                </div>
                <div class="detail-row">
                    <span class="label">付款方式</span>
                    <span class="value"><%=paymentMethod%></span>
                </div>
                <div class="detail-row">
                    <span class="label">付款狀態</span>
                    <span class="value status <%=paymentStatus%>"><%=paymentStatus%></span>
                </div>
                <div class="detail-row">
                    <span class="label">訂單狀態</span>
                    <span class="value status <%=orderStatus%>"><%=orderStatus%></span>
            </div>
        </div>

        <!-- 配送資訊 -->
            <div class="info-card">
                <h2 class="card-title">🚚 配送資訊</h2>
                <div class="detail-row">
                    <span class="label">收件人</span>
                    <span class="value"><%=shippingName%></span>
                </div>
                <div class="detail-row">
                    <span class="label">聯絡電話</span>
                    <span class="value"><%=shippingPhone%></span>
                </div>
                <div class="detail-row">
                    <span class="label">配送地址</span>
                    <span class="value"><%=shippingAddress%></span>
                </div>
                <% if (orderNote != null && !orderNote.trim().isEmpty()) { %>
                <div class="detail-row">
                    <span class="label">訂單備註</span>
                    <span class="value"><%=orderNote%></span>
                </div>
                <% } %>
            </div>
        </div>

        <!-- 費用明細 -->
        <div class="info-card">
            <h2 class="card-title">💰 費用明細</h2>
            <div class="detail-row">
                <span class="label">商品小計</span>
                <span class="value">NT$ <%=String.format("%,.0f", totalAmount)%></span>
                </div>
            <div class="detail-row">
                <span class="label">運費</span>
                <span class="value">
                        <% if (shippingFee == 0) { %>
                        <span style="color: var(--success-color);">免運費</span>
                        <% } else { %>
                            NT$ <%=String.format("%.0f", shippingFee)%>
                        <% } %>
                    </span>
                </div>
            <div class="detail-row" style="border-top: 2px solid var(--primary-color); padding-top: 1rem; margin-top: 1rem;">
                <span class="label" style="font-size: 1.1rem; font-weight: 600; color: var(--primary-color);">總計</span>
                <span class="value" style="font-size: 1.2rem; font-weight: 700; color: var(--primary-color);">NT$ <%=String.format("%,.0f", finalAmount)%></span>
            </div>
        </div>

        <!-- 付款提醒 -->
        <% if ("ATM轉帳".equals(paymentMethod)) { %>
            <div class="payment-notice">
                <h3>⚠️ 付款提醒</h3>
                <p>您選擇了ATM轉帳付款，請在3日內完成轉帳：</p>
                <div class="bank-info">
                    <p><strong>銀行：</strong>中國信託銀行</p>
                    <p><strong>帳號：</strong>123-456-789-012</p>
                    <p><strong>戶名：</strong>NBA卡包商城</p>
                    <p><strong>轉帳金額：</strong>NT$ <%=String.format("%,.0f", finalAmount)%></p>
                </div>
                <p class="notice-text">💡 轉帳完成後請保留收據，客服人員將於確認後盡快出貨。</p>
            </div>
        <% } else if ("貨到付款".equals(paymentMethod)) { %>
            <div class="payment-notice">
                <h3>📦 貨到付款提醒</h3>
                <p>您選擇了貨到付款，商品將在1-3個工作天內送達。</p>
                <p class="notice-text">💰 請準備現金 NT$ <%=String.format("%,.0f", finalAmount)%> 給送貨人員。</p>
            </div>
        <% } %>

        <!-- 倒數計時 -->
        <div class="countdown">
            <p>頁面將在 <span class="countdown-number" id="countdown">20</span> 秒後自動跳轉至首頁</p>
        </div>

        <!-- 操作按鈕 -->
        <div class="action-buttons">
            <a href="index.jsp" class="btn btn-primary">🛍️ 繼續購物</a>
            <a href="member_area.jsp" class="btn btn-secondary">📋 查看訂單</a>
        </div>
    </div>

    <script>
        // 生成慶祝動畫
        function createConfetti() {
            const container = document.getElementById('confettiContainer');
            const colors = ['#ffd700', '#ff6b6b', '#4ecdc4', '#45b7d1', '#f9ca24'];
            
            for (let i = 0; i < 50; i++) {
                const confetti = document.createElement('div');
                confetti.className = 'confetti';
                confetti.style.left = Math.random() * 100 + '%';
                confetti.style.backgroundColor = colors[Math.floor(Math.random() * colors.length)];
                confetti.style.animationDelay = Math.random() * 3 + 's';
                confetti.style.animationDuration = (Math.random() * 2 + 2) + 's';
                container.appendChild(confetti);
            }
            
            // 清理動畫元素
            setTimeout(() => {
                container.innerHTML = '';
            }, 5000);
        }

        // 倒數計時
        let countdown = 20;
        const countdownElement = document.getElementById('countdown');
        
        const interval = setInterval(() => {
            countdown -= 1;
            countdownElement.textContent = countdown;
            
            if (countdown <= 0) {
                clearInterval(interval);
                window.location.href = 'index.jsp';
            }
        }, 1000);

        // 頁面載入完成後開始動畫
        window.addEventListener('load', () => {
            createConfetti();
            
            // 延遲顯示卡片動畫
            setTimeout(() => {
                document.querySelectorAll('.info-card').forEach((card, index) => {
                    card.style.animationDelay = (index * 0.2) + 's';
                });
            }, 500);
        });

        // 添加按鈕點擊效果
        document.querySelectorAll('.btn').forEach(btn => {
            btn.addEventListener('click', function(e) {
                const ripple = document.createElement('span');
                ripple.style.position = 'absolute';
                ripple.style.borderRadius = '50%';
                ripple.style.background = 'rgba(255, 255, 255, 0.6)';
                ripple.style.transform = 'scale(0)';
                ripple.style.animation = 'ripple 0.6s linear';
                ripple.style.left = (e.pageX - this.offsetLeft) + 'px';
                ripple.style.top = (e.pageY - this.offsetTop) + 'px';
                
                this.style.position = 'relative';
                this.appendChild(ripple);
                
                setTimeout(() => {
                    ripple.remove();
                }, 600);
            });
        });

        // 添加漣漪動畫CSS
        const style = document.createElement('style');
        style.textContent = `
            @keyframes ripple {
                to {
                    transform: scale(4);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html> 