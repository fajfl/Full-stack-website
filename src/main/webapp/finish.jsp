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
            --card-bg: #ffffff;
            --text-dark: #2c3e50;
            --text-muted: #6c757d;
            --shadow: 0 4px 12px rgba(0, 61, 165, 0.1);
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

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 2rem;
            position: relative;
            z-index: 10;
        }

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
            box-shadow: 0 8px 25px rgba(0, 61, 165, 0.15);
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
            box-shadow: 0 8px 25px rgba(0, 61, 165, 0.15);
        }

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

            .info-card {
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
                    <span class="value"><%=new java.util.Date()%></span>
                </div>
                <div class="detail-row">
                    <span class="label">付款狀態</span>
                    <span class="value">待付款</span>
                </div>
                <div class="detail-row">
                    <span class="label">訂單狀態</span>
                    <span class="value">處理中</span>
                </div>
            </div>

            <!-- 配送資訊 -->
            <div class="info-card">
                <h2 class="card-title">🚚 配送資訊</h2>
                <div class="detail-row">
                    <span class="label">收件人</span>
                    <span class="value"><%=memberName%></span>
                </div>
                <div class="detail-row">
                    <span class="label">預計送達</span>
                    <span class="value">3-5個工作天</span>
                </div>
                <div class="detail-row">
                    <span class="label">配送方式</span>
                    <span class="value">宅配到府</span>
                </div>
            </div>
        </div>

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