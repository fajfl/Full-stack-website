<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="dbConnection.jsp" %>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>會員中心 - NBA卡包商城</title>
    <link rel="stylesheet" href="css/common.css">
    <link rel="stylesheet" href="css/member.css">
</head>
<body>
    <%
    String action = request.getParameter("action");
    String message = "";
    String messageType = "";
    boolean dbAvailable = isDatabaseAvailable();
    
    // 處理登出
    if ("logout".equals(action)) {
        session.invalidate();
        response.sendRedirect("index.jsp");
        return;
    }
    
    // 處理登入
    if ("login".equals(action) && "POST".equals(request.getMethod()) && dbAvailable) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (username != null && password != null && !username.trim().isEmpty() && !password.trim().isEmpty()) {
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = getConnection();
                String sql = "SELECT member_id, username, email, member_level FROM member WHERE username = ? AND password = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, username.trim());
                pstmt.setString(2, password.trim());
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
                    // 登入成功
                    session.setAttribute("memberId", rs.getInt("member_id"));
                    session.setAttribute("memberName", rs.getString("username"));
                    session.setAttribute("memberLevel", rs.getString("member_level"));
                    session.setAttribute("userEmail", rs.getString("email"));
                    
                    // 檢查用戶等級並重定向
                    String memberLevel = rs.getString("member_level");
                    if ("管理員".equals(memberLevel)) {
                        response.sendRedirect("admin/admin_panel.jsp");
                    } else {
                        // 檢查是否有重定向頁面
                        String redirectPage = request.getParameter("redirect");
                        if (redirectPage != null && !redirectPage.isEmpty()) {
                            response.sendRedirect(redirectPage);
                        } else {
                            response.sendRedirect("index.jsp");
                        }
                    }
                    return;
                } else {
                    message = "帳號或密碼錯誤！";
                    messageType = "error";
                }
            } catch (Exception e) {
                message = "登入時發生錯誤，請稍後再試。";
                messageType = "error";
                System.err.println("Login error: " + e.getMessage());
            } finally {
                closeResources(conn, pstmt, rs);
            }
        } else {
            message = "請輸入帳號和密碼！";
            messageType = "error";
        }
    }
    
    // 處理註冊
    if ("register".equals(action) && "POST".equals(request.getMethod()) && dbAvailable) {
        String username = request.getParameter("reg_username");
        String password = request.getParameter("reg_password");
        String email = request.getParameter("reg_email");
        String phone = request.getParameter("reg_phone");
        String address = request.getParameter("reg_address");
        
        if (username != null && password != null && email != null && 
            !username.trim().isEmpty() && !password.trim().isEmpty() && !email.trim().isEmpty()) {
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = getConnection();
                
                // 檢查帳號是否已存在
                String checkSql = "SELECT COUNT(*) FROM member WHERE username = ? OR email = ?";
                pstmt = conn.prepareStatement(checkSql);
                pstmt.setString(1, username.trim());
                pstmt.setString(2, email.trim());
                rs = pstmt.executeQuery();
                
                if (rs.next() && rs.getInt(1) > 0) {
                    message = "帳號或電子郵件已存在！";
                    messageType = "error";
                } else {
                    // 插入新會員
                    rs.close();
                    pstmt.close();
                    
                    String insertSql = "INSERT INTO member (username, password, email, phone, address, member_level) VALUES (?, ?, ?, ?, ?, '一般會員')";
                    pstmt = conn.prepareStatement(insertSql);
                    pstmt.setString(1, username.trim());
                    pstmt.setString(2, password.trim());
                    pstmt.setString(3, email.trim());
                    pstmt.setString(4, phone != null ? phone.trim() : "");
                    pstmt.setString(5, address != null ? address.trim() : "");
                    
                    int result = pstmt.executeUpdate();
                    if (result > 0) {
                        message = "註冊成功！請使用新帳號登入。";
                        messageType = "success";
                    } else {
                        message = "註冊失敗，請稍後再試！";
                        messageType = "error";
                    }
                }
            } catch (Exception e) {
                message = "註冊時發生錯誤，請稍後再試。";
                messageType = "error";
                System.err.println("Registration error: " + e.getMessage());
            } finally {
                closeResources(conn, pstmt, rs);
            }
        } else {
            message = "請填寫完整的註冊資訊！";
            messageType = "error";
        }
    }
    
    // 檢查是否已登入（使用不同變數名避免衝突）
    Integer memberPageId = (Integer) session.getAttribute("memberId");
    if (memberPageId != null) {
        response.sendRedirect("member_area.jsp");
        return;
    }
    %>

    <!-- 引入統一的header -->
    <%@ include file="header.jsp" %>

    <!-- 資料庫狀態提示 -->
    <% if (!dbAvailable) { %>
        <div class="alert alert-warning">
            <strong>⚠️ 系統提示：</strong>目前資料庫連接異常，登入和註冊功能暫時無法使用。
            <a href="db_status.jsp" style="color: #856404; text-decoration: underline;">檢查系統狀態</a>
        </div>
    <% } %>

    <!-- 訊息顯示 -->
    <% if (!message.isEmpty()) { %>
        <div class="alert alert-<%=messageType%>">
            <%=message%>
        </div>
    <% } %>

    <!-- 會員登入/註冊表單 -->
    <div class="auth-wrapper">
        <div class="auth-container">
            <!-- 漸變背景裝飾 -->
            <div class="auth-decoration">
                <div class="decoration-circle circle-1"></div>
                <div class="decoration-circle circle-2"></div>
                <div class="decoration-circle circle-3"></div>
            </div>
            
            <!-- 標題區域 -->
            <div class="auth-header">
                <div class="auth-logo">
                    <div class="logo-icon">🏀</div>
                    <h1>NBA卡包商城</h1>
                    <p>歡迎來到籃球卡收藏的專業平台</p>
                </div>
            </div>
            
            <!-- 標籤切換 -->
            <div class="auth-tabs">
                <button class="tab-btn active" onclick="showTab('login')" data-tab="login">
                    <i class="tab-icon">👤</i>
                    <span>會員登入</span>
                </button>
                <button class="tab-btn" onclick="showTab('register')" data-tab="register">
                    <i class="tab-icon">📝</i>
                    <span>會員註冊</span>
                </button>
            </div>

            <!-- 登入表單 -->
            <div id="login-form" class="auth-form active">
                <% if (dbAvailable) { %>
                    <form action="member.jsp" method="post" class="modern-form">
                        <input type="hidden" name="action" value="login">
                        <input type="hidden" name="redirect" value="<%=request.getParameter("redirect") != null ? sanitizeInput(request.getParameter("redirect")) : ""%>">
                        
                        <div class="form-group">
                            <div class="input-wrapper">
                                <i class="input-icon">👤</i>
                                <input type="text" id="username" name="username" required placeholder=" ">
                                <label for="username">帳號</label>
                                <div class="input-border"></div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="input-wrapper">
                                <i class="input-icon">🔒</i>
                                <input type="password" id="password" name="password" required placeholder=" ">
                                <label for="password">密碼</label>
                                <div class="input-border"></div>
                            </div>
                        </div>
                        
                        <button type="submit" class="btn-primary modern-btn">
                            <span class="btn-text">立即登入</span>
                            <span class="btn-icon">→</span>
                        </button>
                        
                        <div class="form-footer">
                            <p>還沒有帳號？<a href="#" onclick="showTab('register')">立即註冊</a></p>
                        </div>
                    </form>
                <% } else { %>
                    <div class="db-offline-form">
                        <div class="offline-icon">🔌</div>
                        <h3>系統維護中</h3>
                        <p>登入功能暫時無法使用，請稍後再試。</p>
                        <div class="offline-actions">
                            <a href="db_status.jsp" class="btn btn-outline">檢查系統狀態</a>
                            <a href="javascript:location.reload()" class="btn btn-primary">重新整理</a>
                        </div>
                    </div>
                <% } %>
            </div>

            <!-- 註冊表單 -->
            <div id="register-form" class="auth-form">
                <% if (dbAvailable) { %>
                    <form action="member.jsp" method="post" class="modern-form">
                        <input type="hidden" name="action" value="register">
                        
                        <div class="form-group">
                            <div class="input-wrapper">
                                <i class="input-icon">👤</i>
                                <input type="text" id="reg_username" name="reg_username" required placeholder=" ">
                                <label for="reg_username">帳號 *</label>
                                <div class="input-border"></div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="input-wrapper">
                                <i class="input-icon">🔒</i>
                                <input type="password" id="reg_password" name="reg_password" required placeholder=" ">
                                <label for="reg_password">密碼 *</label>
                                <div class="input-border"></div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="input-wrapper">
                                <i class="input-icon">📧</i>
                                <input type="email" id="reg_email" name="reg_email" required placeholder=" ">
                                <label for="reg_email">電子郵件 *</label>
                                <div class="input-border"></div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="input-wrapper">
                                <i class="input-icon">📱</i>
                                <input type="tel" id="reg_phone" name="reg_phone" placeholder=" ">
                                <label for="reg_phone">聯絡電話</label>
                                <div class="input-border"></div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <div class="input-wrapper textarea-wrapper">
                                <i class="input-icon">📍</i>
                                <textarea id="reg_address" name="reg_address" rows="3" placeholder=" "></textarea>
                                <label for="reg_address">地址</label>
                                <div class="input-border"></div>
                            </div>
                        </div>
                        
                        <button type="submit" class="btn-primary modern-btn">
                            <span class="btn-text">完成註冊</span>
                            <span class="btn-icon">✓</span>
                        </button>
                        
                        <div class="form-footer">
                            <p>已有帳號？<a href="#" onclick="showTab('login')">立即登入</a></p>
                        </div>
                    </form>
                <% } else { %>
                    <div class="db-offline-form">
                        <div class="offline-icon">🔌</div>
                        <h3>系統維護中</h3>
                        <p>註冊功能暫時無法使用，請稍後再試。</p>
                        <div class="offline-actions">
                            <a href="db_status.jsp" class="btn btn-outline">檢查系統狀態</a>
                            <a href="javascript:location.reload()" class="btn btn-primary">重新整理</a>
                        </div>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <!-- 引入統一的footer -->
    <%@ include file="footer.jsp" %>

    <script>
    function showTab(tabName) {
        // 隱藏所有表單
        document.querySelectorAll('.auth-form').forEach(form => {
            form.classList.remove('active');
        });
        
        // 移除所有按鈕的active狀態
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.remove('active');
        });
        
        // 顯示選中的表單
        document.getElementById(tabName + '-form').classList.add('active');
        
        // 添加選中按鈕的active狀態
        event.target.classList.add('active');
    }
    </script>

    <style>
    /* 警告訊息樣式 */
    .alert {
        padding: 12px 20px;
        margin: 0;
        border: none;
        text-align: center;
        font-size: 0.9rem;
    }
    
    .alert-warning {
        background: #fff3cd;
        color: #856404;
    }
    
    .alert-error {
        background: #f8d7da;
        color: #721c24;
    }
    
    .alert-success {
        background: #d1edff;
        color: #155724;
    }

    /* 主容器樣式 */
    .auth-wrapper {
        min-height: calc(100vh - 140px);
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 40px 20px;
        position: relative;
        overflow: hidden;
        box-sizing: border-box;
        width: 100%;
    }

    .auth-wrapper::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grid" width="10" height="10" patternUnits="userSpaceOnUse"><path d="M 10 0 L 0 0 0 10" fill="none" stroke="rgba(255,255,255,0.1)" stroke-width="1"/></pattern></defs><rect width="100" height="100" fill="url(%23grid)" /></svg>');
        opacity: 0.3;
    }

    .auth-container {
        position: relative;
        max-width: 550px;
        width: 100%;
        background: rgba(255, 255, 255, 0.95);
        backdrop-filter: blur(20px);
        border-radius: 20px;
        box-shadow: 
            0 25px 50px rgba(0, 0, 0, 0.15),
            0 0 0 1px rgba(255, 255, 255, 0.2);
        overflow: hidden;
        animation: slideUp 0.6s ease-out;
        margin: 0 auto;
        box-sizing: border-box;
        z-index: 10;
    }

    @keyframes slideUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* 裝飾性背景圓圈 */
    .auth-decoration {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        pointer-events: none;
        overflow: hidden;
        z-index: 1;
    }

    .decoration-circle {
        position: absolute;
        border-radius: 50%;
        background: linear-gradient(45deg, rgba(102, 126, 234, 0.1), rgba(118, 75, 162, 0.1));
        animation: float 6s ease-in-out infinite;
    }

    .circle-1 {
        width: 80px;
        height: 80px;
        top: -40px;
        right: -40px;
        animation-delay: 0s;
    }

    .circle-2 {
        width: 120px;
        height: 120px;
        bottom: -60px;
        left: -60px;
        animation-delay: 2s;
    }

    .circle-3 {
        width: 60px;
        height: 60px;
        top: 40%;
        right: -30px;
        animation-delay: 4s;
    }

    @keyframes float {
        0%, 100% { transform: translateY(0px) rotate(0deg); }
        50% { transform: translateY(-10px) rotate(180deg); }
    }

    /* 標題區域 */
    .auth-header {
        padding: 30px 25px 15px;
        text-align: center;
        position: relative;
        z-index: 10;
    }

    .auth-logo {
        position: relative;
        z-index: 10;
    }

    .logo-icon {
        font-size: 2.5rem;
        margin-bottom: 10px;
        animation: bounce 2s infinite;
        position: relative;
        z-index: 10;
    }

    @keyframes bounce {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-5px); }
    }

    .auth-logo h1 {
        font-size: 1.8rem;
        color: #333;
        margin: 0 0 8px 0;
        font-weight: 700;
        background: linear-gradient(135deg, #667eea, #764ba2);
        -webkit-background-clip: text;
        -webkit-text-fill-color: transparent;
        background-clip: text;
        line-height: 1.2;
        position: relative;
        z-index: 10;
    }

    .auth-logo p {
        color: #666;
        font-size: 0.85rem;
        margin: 0;
        opacity: 0.8;
        line-height: 1.4;
        position: relative;
        z-index: 10;
    }

    
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    /* 標籤樣式 */
    .auth-tabs {
        display: flex;
        background: rgba(248, 249, 250, 0.8);
        border-radius: 12px;
        margin: 0 20px 20px;
        padding: 4px;
        position: relative;
        z-index: 10;
    }

    .tab-btn {
        flex: 1;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 6px;
        padding: 12px 15px;
        border: none;
        background: transparent;
        border-radius: 10px;
        cursor: pointer;
        font-size: 0.9rem;
        font-weight: 600;
        color: #666;
        position: relative;
        overflow: hidden;
        white-space: nowrap;
        z-index: 10;
    }

    .tab-btn::before {
        content: '';
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(135deg, #667eea, #764ba2);
        opacity: 0;
        transition: opacity 0.3s ease;
        border-radius: 10px;
    }

    .tab-btn.active::before {
        opacity: 1;
    }

    .tab-btn.active {
        color: white;
        transform: translateY(-1px);
        box-shadow: 0 6px 15px rgba(102, 126, 234, 0.3);
    }

    .tab-icon {
        font-size: 1.1rem;
        position: relative;
        z-index: 1;
    }

    .tab-btn span {
        position: relative;
        z-index: 1;
    }

    /* 表單樣式 */
    .auth-form {
        display: none;
        padding: 0 25px 30px;
        position: relative;
        z-index: 10;
        animation: fadeIn 0.4s ease-out;
    }

    .auth-form.active {
        display: block;
    }

    
        to { opacity: 1; transform: translateY(0); }
    }

    .modern-form {
        width: 100%;
    }

    .form-group {
        margin-bottom: 25px;
    }

    .input-wrapper {
        position: relative;
        display: flex;
        align-items: center;
        width: 100%;
        box-sizing: border-box;
    }

    .input-icon {
        position: absolute;
        left: 12px;
        top: 50%;
        transform: translateY(-50%);
        font-size: 1rem;
        color: #999;
        z-index: 2;
    }

    .input-wrapper input,
    .input-wrapper textarea {
        width: 100%;
        padding: 18px 45px 18px 40px;
        border: 2px solid #e9ecef;
        border-radius: 10px;
        font-size: 1rem;
        background: rgba(255, 255, 255, 0.9);
        position: relative;
        z-index: 1;
        box-sizing: border-box;
    }

    .input-wrapper textarea {
        resize: vertical;
        min-height: 80px;
        font-family: inherit;
        padding-top: 15px;
    }

    .textarea-wrapper .input-icon {
        top: 20px;
        transform: none;
    }

    .input-wrapper label {
        position: absolute;
        left: 38px;
        top: 50%;
        transform: translateY(-50%);
        color: #999;
        font-size: 0.95rem;
        pointer-events: none;
        background: rgba(255, 255, 255, 0.9);
        padding: 0 4px;
        z-index: 2;
    }

    .textarea-wrapper label {
        top: 20px;
        transform: none;
    }

    .input-wrapper input:focus,
    .input-wrapper textarea:focus,
    .input-wrapper input:not(:placeholder-shown),
    .input-wrapper textarea:not(:placeholder-shown) {
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        outline: none;
    }

    .input-wrapper input:focus + label,
    .input-wrapper textarea:focus + label,
    .input-wrapper input:not(:placeholder-shown) + label,
    .input-wrapper textarea:not(:placeholder-shown) + label {
        top: -6px;
        left: 34px;
        font-size: 0.8rem;
        color: #667eea;
        font-weight: 600;
    }

    .input-wrapper input:focus ~ .input-icon,
    .input-wrapper textarea:focus ~ .input-icon {
        color: #667eea;
        transform: translateY(-50%) scale(1.05);
    }

    .textarea-wrapper input:focus ~ .input-icon {
        transform: scale(1.05);
    }

    .input-border {
        position: absolute;
        bottom: 0;
        left: 0;
        height: 2px;
        width: 0;
        background: linear-gradient(135deg, #667eea, #764ba2);
        transition: width 0.3s ease;
    }

    .input-wrapper input:focus ~ .input-border,
    .input-wrapper textarea:focus ~ .input-border {
        width: 100%;
    }

    /* 按鈕樣式 */
    .modern-btn {
        width: 100%;
        padding: 18px 20px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        border: none;
        border-radius: 10px;
        color: white;
        font-size: 1.1rem;
        font-weight: 600;
        cursor: pointer;
        position: relative;
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        margin-top: 15px;
        box-sizing: border-box;
        z-index: 10;
    }

    .modern-btn::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
        transition: left 0.5s;
    }

    .modern-btn:hover {
        transform: translateY(-1px);
        box-shadow: 0 12px 25px rgba(102, 126, 234, 0.4);
    }

    .modern-btn:hover::before {
        left: 100%;
    }

    .modern-btn:active {
        transform: translateY(0);
    }

    .btn-text {
        position: relative;
        z-index: 1;
    }

    .btn-icon {
        font-size: 1.1rem;
        transition: transform 0.3s ease;
    }

    .modern-btn:hover .btn-icon {
        transform: translateX(3px);
    }

    /* 表單底部 */
    .form-footer {
        text-align: center;
        margin-top: 20px;
        padding-top: 15px;
        border-top: 1px solid #e9ecef;
    }

    .form-footer p {
        margin: 0;
        color: #666;
        font-size: 0.85rem;
    }

    .form-footer a {
        color: #667eea;
        text-decoration: none;
        font-weight: 600;
        transition: color 0.3s ease;
    }

    .form-footer a:hover {
        color: #764ba2;
        text-decoration: underline;
    }

    /* 離線狀態樣式 */
    .db-offline-form {
        text-align: center;
        padding: 30px 15px;
        position: relative;
        z-index: 10;
    }

    .offline-icon {
        font-size: 3rem;
        margin-bottom: 15px;
        opacity: 0.7;
    }

    .db-offline-form h3 {
        color: #333;
        margin-bottom: 8px;
        font-size: 1.3rem;
    }

    .db-offline-form p {
        color: #666;
        margin-bottom: 20px;
        line-height: 1.5;
        font-size: 0.9rem;
    }

    .offline-actions {
        display: flex;
        gap: 10px;
        justify-content: center;
        flex-wrap: wrap;
    }

    .btn {
        padding: 10px 20px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: 500;
        border: none;
        cursor: pointer;
        font-size: 0.9rem;
        box-sizing: border-box;
    }

    .btn-outline {
        background: transparent;
        color: #667eea;
        border: 2px solid #667eea;
    }

    .btn-outline:hover {
        background: #667eea;
        color: white;
        transform: translateY(-1px);
    }

    .btn-primary {
        background: linear-gradient(135deg, #667eea, #764ba2);
        color: white;
        border: 2px solid transparent;
    }

    .btn-primary:hover {
        transform: translateY(-1px);
        box-shadow: 0 6px 15px rgba(102, 126, 234, 0.3);
    }

    /* 響應式設計 */
    @media (max-width: 768px) {
        .auth-wrapper {
            padding: 20px 15px;
            min-height: calc(100vh - 120px);
        }
        
        .auth-container {
            max-width: 100%;
        }
        
        .auth-header {
            padding: 25px 20px 10px;
        }
        
        .auth-logo h1 {
            font-size: 1.6rem;
        }
        
        .auth-tabs {
            margin: 0 15px 15px;
        }
        
        .tab-btn {
            padding: 10px 12px;
            font-size: 0.85rem;
        }
        
        .auth-form {
            padding: 0 20px 25px;
        }
        
        .input-wrapper input,
        .input-wrapper textarea {
            padding: 16px 40px 16px 35px;
            font-size: 0.95rem;
        }
        
        .modern-btn {
            padding: 16px 18px;
            font-size: 1rem;
        }
    }

    @media (max-width: 480px) {
        .auth-wrapper {
            padding: 15px 10px;
        }
        
        .auth-container {
            border-radius: 15px;
        }
        
        .tab-btn span {
            display: none;
        }
        
        .tab-btn {
            padding: 12px;
        }
        
        .tab-icon {
            font-size: 1.3rem;
        }
        
        .input-wrapper input,
        .input-wrapper textarea {
            padding: 13px 35px 13px 32px;
        }
    }

    /* 大螢幕優化 */
    @media (min-width: 1200px) {
        .auth-wrapper {
            padding: 60px 40px;
        }
        
        .auth-container {
            max-width: 600px;
        }
    }

    @keyframes containerFadeIn {
        from {
            opacity: 0;
        }
        to {
            opacity: 1;
        }
    }
    </style>
</body>
</html> 
