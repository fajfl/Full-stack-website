<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>結帳頁面 - NBA卡包商城</title>
    <style>
        :root {
            --primary-color: #003da5;
            --secondary-color: #00c3ff;
            --accent-color: #ffd700;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --light-bg: #f8f9fa;
            --card-bg: #ffffff;
            --text-dark: #2c3e50;
            --text-muted: #6c757d;
            --border-color: #e9ecef;
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
        }

        /* 導航列 */
        .navbar {
            background: var(--primary-color);
            padding: 1rem 0;
            box-shadow: var(--shadow);
            position: sticky;
            top: 0;
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
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        /* 頁面標題 */
        .page-title {
            text-align: center;
            margin-bottom: 3rem;
            color: white;
        }

        .page-title h1 {
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
        }

        .page-title p {
            font-size: 1.1rem;
            opacity: 0.9;
        }

        /* 結帳步驟 */
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
            opacity: 0.5;
            transition: all 0.3s ease;
        }

        .step.active {
            opacity: 1;
            transform: scale(1.1);
        }

        .step.completed {
            opacity: 0.8;
            color: var(--success-color);
        }

        .step-number {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: var(--border-color);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-bottom: 0.5rem;
            transition: all 0.3s ease;
        }

        .step.active .step-number {
            background: var(--primary-color);
            color: white;
            animation: pulse 2s infinite;
        }

        .step.completed .step-number {
            background: var(--success-color);
            color: white;
        }

        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .step-arrow {
            margin: 0 2rem;
            font-size: 1.5rem;
            color: var(--text-muted);
        }

        .step-text {
            font-size: 0.9rem;
            font-weight: 500;
        }

        /* 結帳容器 */
        .checkout-container {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
            margin-bottom: 3rem;
        }

        /* 表單區域 */
        .checkout-form {
            background: var(--card-bg);
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--shadow);
            animation: slideInLeft 0.6s ease-out;
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

        .form-section {
            margin-bottom: 2rem;
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid var(--border-color);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text-dark);
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid var(--border-color);
            border-radius: 0.5rem;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
        }

        .form-group input:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(0, 61, 165, 0.1);
            transform: translateY(-2px);
        }

        /* 付款選項 */
        .payment-options {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .payment-option {
            position: relative;
            cursor: pointer;
        }

        .payment-option input {
            position: absolute;
            opacity: 0;
        }

        .payment-card {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            border: 2px solid var(--border-color);
            border-radius: 0.75rem;
            transition: all 0.3s ease;
            background: white;
        }

        .payment-option:hover .payment-card {
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
            border-color: var(--secondary-color);
        }

        .payment-option input:checked + .payment-card {
            border-color: var(--primary-color);
            background: linear-gradient(135deg, rgba(0, 61, 165, 0.05) 0%, rgba(0, 195, 255, 0.05) 100%);
            box-shadow: var(--shadow-hover);
        }

        .payment-icon {
            font-size: 2rem;
            width: 60px;
            text-align: center;
        }

        .payment-info h4 {
            margin-bottom: 0.25rem;
            color: var(--primary-color);
            font-weight: 600;
        }

        .payment-info p {
            color: var(--text-muted);
            font-size: 0.9rem;
        }

        /* 訂單摘要 */
        .order-summary {
            background: var(--card-bg);
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: var(--shadow);
            height: fit-content;
            position: sticky;
            top: 120px;
            animation: slideInRight 0.6s ease-out;
        }

        @keyframes slideInRight {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }

        .order-items {
            max-height: 300px;
            overflow-y: auto;
            margin-bottom: 1.5rem;
        }

        .order-item {
            display: flex;
            gap: 1rem;
            padding: 1rem 0;
            border-bottom: 1px solid var(--border-color);
        }

        .order-item:last-child {
            border-bottom: none;
        }

        .item-image {
            width: 80px;
            height: 80px;
            border-radius: 0.5rem;
            object-fit: contain;
            background: #f8f9fa;
            padding: 0.25rem;
            border: 1px solid var(--border-color);
        }

        .item-details {
            flex: 1;
        }

        .item-details h4 {
            font-size: 0.9rem;
            margin-bottom: 0.25rem;
            color: var(--text-dark);
        }

        .item-details p {
            font-size: 0.8rem;
            color: var(--text-muted);
        }

        .item-total {
            font-weight: 600;
            color: var(--primary-color);
        }

        /* 摘要計算 */
        .summary-calculations {
            border-top: 2px solid var(--border-color);
            padding-top: 1rem;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.75rem;
            font-size: 0.95rem;
        }

        .summary-row.total {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary-color);
            border-top: 1px solid var(--border-color);
            padding-top: 0.75rem;
            margin-top: 0.75rem;
        }

        /* 免運費進度條 */
        .free-shipping {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            padding: 1rem;
            border-radius: 0.75rem;
            margin-bottom: 1.5rem;
            text-align: center;
        }

        .shipping-progress {
            margin-top: 0.5rem;
        }

        .progress-bar {
            width: 100%;
            height: 8px;
            background: rgba(255, 255, 255, 0.3);
            border-radius: 4px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: white;
            border-radius: 4px;
            transition: width 0.5s ease;
        }

        /* 結帳按鈕 */
        .checkout-btn {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border: none;
            border-radius: 0.75rem;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: var(--shadow);
            margin-top: 1rem;
        }

        .checkout-btn:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: var(--shadow-hover);
        }

        .checkout-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
        }

        /* 訊息提示 */
        .alert {
            padding: 1rem;
            border-radius: 0.5rem;
            margin-bottom: 2rem;
            animation: slideInDown 0.5s ease-out;
        }

        @keyframes slideInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-success {
            background: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
            border: 1px solid rgba(40, 167, 69, 0.2);
        }

        .alert-error {
            background: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
            border: 1px solid rgba(220, 53, 69, 0.2);
        }

        .alert-info {
            background: rgba(0, 61, 165, 0.1);
            color: var(--primary-color);
            border: 1px solid rgba(0, 61, 165, 0.2);
        }

        /* 響應式設計 */
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            .checkout-container {
                grid-template-columns: 1fr;
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

            .form-row {
                grid-template-columns: 1fr;
            }

            .nav-links {
                display: none;
            }

            .page-title h1 {
                font-size: 2rem;
            }
        }

        @media (max-width: 480px) {
            .page-title h1 {
                font-size: 1.5rem;
            }

            .checkout-form,
            .order-summary {
                padding: 1rem;
            }

            .payment-card {
                flex-direction: column;
                text-align: center;
            }
        }

        /* 載入動畫 */
        .loading {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(255,255,255,.3);
            border-radius: 50%;
            border-top-color: #fff;
            animation: spin 1s ease-in-out infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <%
    // 檢查登入狀態
    Integer memberId = (Integer) session.getAttribute("memberId");
    String memberName = (String) session.getAttribute("memberName");
    
    if (memberId == null) {
        response.sendRedirect("member.jsp?redirect=checkout.jsp");
        return;
    }
    
    // 處理訊息顯示
    String message = request.getParameter("msg");
    String messageType = request.getParameter("type");
    %>

        <!-- 導航列 -->
        <nav class="navbar">
        <div class="nav-container">
            <div class="nav-brand">
                <a href="index.jsp">🏀 NBA卡包商城</a>
            </div>
            <div class="nav-links">
                <a href="index.jsp">首頁</a>
                <a href="cart.jsp">購物車</a>
                <a href="member_area.jsp">會員專區</a>
                <a href="member.jsp?action=logout">登出</a>
            </div>
            </div>
        </nav>

    <div class="container">
        <!-- 頁面標題 -->
        <div class="page-title">
            <h1>🛒 結帳頁面</h1>
            <p>請填寫您的訂單資訊</p>
        </div>

        <!-- 訊息顯示 -->
        <% if (message != null && !message.isEmpty()) { %>
            <div class="alert alert-<%=messageType != null ? messageType : "info"%>">
                <%=message%>
            </div>
        <% } %>

        <!-- 結帳步驟 -->
        <div class="checkout-steps">
            <div class="step completed">
                <div class="step-number">✓</div>
                <div class="step-text">購物車</div>
            </div>
            <div class="step-arrow">→</div>
            <div class="step active">
                <div class="step-number">2</div>
                <div class="step-text">結帳資訊</div>
            </div>
            <div class="step-arrow">→</div>
            <div class="step">
                <div class="step-number">3</div>
                <div class="step-text">確認訂單</div>
            </div>
            <div class="step-arrow">→</div>
            <div class="step">
                <div class="step-number">4</div>
                <div class="step-text">完成</div>
            </div>
        </div>

        <div class="checkout-container">
            <!-- 表單區域 -->
            <div class="checkout-form">
                    <form action="order_confirm.jsp" method="post" id="checkoutForm">
                        <%
                        // 獲取會員資料
                        Connection conn = null;
                        PreparedStatement pstmt = null;
                        ResultSet rs = null;
                        String memberEmail = "";
                        String memberPhone = "";
                        String memberAddress = "";
                        
                        try {
                            conn = getConnection();
                            String memberSql = "SELECT email, phone, address FROM member WHERE member_id = ?";
                            pstmt = conn.prepareStatement(memberSql);
                            pstmt.setInt(1, memberId);
                            rs = pstmt.executeQuery();
                            
                            if (rs.next()) {
                                memberEmail = rs.getString("email") != null ? rs.getString("email") : "";
                                memberPhone = rs.getString("phone") != null ? rs.getString("phone") : "";
                                memberAddress = rs.getString("address") != null ? rs.getString("address") : "";
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            closeResources(conn, pstmt, rs);
                        }
                        %>
                        
                    <!-- 收件資訊 -->
                    <section class="form-section">
                        <h3 class="section-title">📋 收件資訊</h3>
                        <div class="form-row">
                        <div class="form-group">
                            <label for="shipping_name">收件人姓名 *</label>
                            <input type="text" id="shipping_name" name="shipping_name" 
                                   value="<%=memberName != null ? memberName : ""%>" required>
                        </div>
                            <div class="form-group">
                                <label for="shipping_phone">聯絡電話 *</label>
                                <input type="tel" id="shipping_phone" name="shipping_phone" 
                                       value="<%=memberPhone%>" required pattern="[0-9\-\+\s]+">
                            </div>
                            </div>
                            <div class="form-group">
                                <label for="shipping_email">電子郵件</label>
                                <input type="email" id="shipping_email" name="shipping_email" 
                                       value="<%=memberEmail%>">
                            </div>
                        <div class="form-group">
                            <label for="shipping_address">配送地址 *</label>
                            <textarea id="shipping_address" name="shipping_address" 
                                      rows="3" required placeholder="請填寫完整地址，包含縣市、區域、街道、門牌號碼"><%=memberAddress%></textarea>
                        </div>
                    </section>
                        
                        <!-- 付款方式 -->
                    <section class="form-section">
                        <h3 class="section-title">💳 付款方式</h3>
                        <div class="payment-options">
                            <label class="payment-option">
                                <input type="radio" name="payment_method" value="信用卡" checked>
                                <div class="payment-card">
                                    <div class="payment-icon">💳</div>
                                    <div class="payment-info">
                                        <h4>信用卡付款</h4>
                                        <p>支援Visa、MasterCard、JCB</p>
                                    </div>
                                </div>
                            </label>
                            
                            <label class="payment-option">
                                <input type="radio" name="payment_method" value="ATM轉帳">
                                <div class="payment-card">
                                    <div class="payment-icon">🏦</div>
                                    <div class="payment-info">
                                        <h4>ATM轉帳</h4>
                                        <p>3日內完成轉帳，逾期自動取消</p>
                                    </div>
                                </div>
                            </label>
                            
                            <label class="payment-option">
                                <input type="radio" name="payment_method" value="貨到付款">
                                <div class="payment-card">
                                    <div class="payment-icon">📦</div>
                                    <div class="payment-info">
                                        <h4>貨到付款</h4>
                                        <p>收貨時現金付款，需加收30元手續費</p>
                                    </div>
                                </div>
                            </label>
                        </div>
                    </section>
                    
                    <!-- 訂單備註 -->
                    <section class="form-section">
                        <h3 class="section-title">📝 訂單備註</h3>
                        <div class="form-group">
                            <textarea id="order_note" name="order_note" 
                                      rows="3" placeholder="有任何特殊需求請在此說明（選填）"></textarea>
                        </div>
                    </section>
                    </form>
            </div>

            <!-- 訂單摘要 -->
                <div class="order-summary">
                <h3 class="section-title">📄 訂單摘要</h3>
                    
                    <%
                    conn = null;
                    pstmt = null;
                    rs = null;
                    double totalAmount = 0.0;
                    int itemCount = 0;
                double shippingFee = 100.0; // 預設運費
                    
                    try {
                        conn = getConnection();
                        String cartSql = "SELECT c.quantity, p.product_name, p.price, p.main_image, p.stock " +
                                       "FROM cart_item c " +
                                       "JOIN product p ON c.product_id = p.product_id " +
                                       "WHERE c.member_id = ?";
                        pstmt = conn.prepareStatement(cartSql);
                        pstmt.setInt(1, memberId);
                        rs = pstmt.executeQuery();
                %>
                        
                <div class="order-items">
                <%
                        while (rs.next()) {
                            int quantity = rs.getInt("quantity");
                            String productName = rs.getString("product_name");
                            double price = rs.getDouble("price");
                            String mainImage = rs.getString("main_image");
                            double itemTotal = price * quantity;
                            totalAmount += itemTotal;
                        itemCount += quantity;
                    %>
                        <div class="order-item">
                            <img src="<%=mainImage%>" alt="<%=productName%>" class="item-image">
                            <div class="item-details">
                            <h4><%=productName%></h4>
                            <p>NT$ <%=String.format("%.0f", price)%> × <%=quantity%></p>
                        </div>
                        <div class="item-total">NT$ <%=String.format("%.0f", itemTotal)%></div>
                        </div>
                    <%
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    } finally {
                        closeResources(conn, pstmt, rs);
                    }
                    
                // 計算免運費進度
                double freeShippingThreshold = 2000.0;
                double shippingProgress = Math.min(totalAmount / freeShippingThreshold * 100, 100);
                if (totalAmount >= freeShippingThreshold) {
                    shippingFee = 0.0;
                }
                %>
                </div>
                
                <!-- 免運費進度條 -->
                <% if (totalAmount < freeShippingThreshold) { %>
                    <div class="free-shipping">
                        <p>再消費 NT$ <%=String.format("%.0f", freeShippingThreshold - totalAmount)%> 即可免運費！</p>
                        <div class="shipping-progress">
                            <div class="progress-bar">
                                <div class="progress-fill" style="width: <%=shippingProgress%>%"></div>
                            </div>
                        </div>
                    </div>
                <% } else { %>
                    <div class="free-shipping">
                        <p>🎉 恭喜！您已享有免運費優惠</p>
                    </div>
                <% } %>
                
                <!-- 費用計算 -->
                <div class="summary-calculations">
                    <div class="summary-row">
                        <span>商品小計 (<%=itemCount%> 件)</span>
                        <span>NT$ <%=String.format("%.0f", totalAmount)%></span>
                    </div>
                    <div class="summary-row">
                            <span>運費</span>
                        <span>
                                <% if (shippingFee == 0) { %>
                                <span style="color: var(--success-color);">免運費</span>
                                <% } else { %>
                                    NT$ <%=String.format("%.0f", shippingFee)%>
                                <% } %>
                            </span>
                        </div>
                    <div class="summary-row total">
                            <span>總計</span>
                        <span>NT$ <%=String.format("%.0f", totalAmount + shippingFee)%></span>
                    </div>
                </div>
                
                <button type="submit" form="checkoutForm" class="checkout-btn" id="submitBtn">
                    <span id="btnText">💳 確認結帳</span>
                    <span id="btnLoading" style="display: none;"><span class="loading"></span> 處理中...</span>
                </button>
            </div>
        </div>
    </div>

    <script>
        // 表單提交處理
        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            const submitBtn = document.getElementById('submitBtn');
            const btnText = document.getElementById('btnText');
            const btnLoading = document.getElementById('btnLoading');
            
            // 顯示載入狀態
            submitBtn.disabled = true;
            btnText.style.display = 'none';
            btnLoading.style.display = 'inline';
            
            // 驗證表單
            const requiredFields = this.querySelectorAll('[required]');
            let isValid = true;
            
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    field.style.borderColor = 'var(--danger-color)';
                    field.focus();
                } else {
                    field.style.borderColor = 'var(--border-color)';
                }
            });
            
            if (!isValid) {
                e.preventDefault();
                submitBtn.disabled = false;
                btnText.style.display = 'inline';
                btnLoading.style.display = 'none';
                alert('請填寫所有必填欄位');
            }
        });

        // 付款方式選擇動畫
    document.querySelectorAll('input[name="payment_method"]').forEach(radio => {
            radio.addEventListener('change', function() {
                document.querySelectorAll('.payment-card').forEach(card => {
                    card.style.transform = 'scale(1)';
                });
                
                if (this.checked) {
                    const card = this.nextElementSibling;
                    card.style.transform = 'scale(1.02)';
                    
                    setTimeout(() => {
                        card.style.transform = 'scale(1)';
                    }, 200);
                }
            });
        });

        // 輸入框焦點效果
        document.querySelectorAll('.form-group input, .form-group textarea').forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.style.transform = 'translateY(-2px)';
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.style.transform = 'translateY(0)';
            });
    });
    </script>
</body>
</html>