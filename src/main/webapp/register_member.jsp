<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<%@ page import="java.sql.*" %>

<%
    String message = "";
    String messageType = ""; // success 或 error
    String registerAction = request.getParameter("action");
    
    // 處理註冊請求
    if ("register".equals(registerAction)) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        // 基本驗證
        if (username == null || password == null || email == null || 
            username.trim().isEmpty() || password.trim().isEmpty() || email.trim().isEmpty()) {
            message = "請填寫所有必填欄位！";
            messageType = "error";
        } else if (!password.equals(confirmPassword)) {
            message = "密碼確認不一致！";
            messageType = "error";
        } else if (password.length() < 4) {
            message = "密碼至少需要4個字元！";
            messageType = "error";
        } else if (!email.contains("@") || !email.contains(".")) {
            message = "請輸入有效的電子郵件地址！";
            messageType = "error";
        } else {
            // 清理輸入資料
            username = sanitizeInput(username.trim());
            password = sanitizeInput(password.trim());
            email = sanitizeInput(email.trim());
            phone = phone != null ? sanitizeInput(phone.trim()) : "";
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = getConnection();
                
                // 檢查帳號是否已存在
                pstmt = conn.prepareStatement("SELECT COUNT(*) as count FROM member WHERE username = ? OR email = ?");
                pstmt.setString(1, username);
                pstmt.setString(2, email);
                rs = pstmt.executeQuery();
                
                if (rs.next() && rs.getInt("count") > 0) {
                    message = "帳號或電子郵件已被註冊！";
                    messageType = "error";
                } else {
                    rs.close();
                    pstmt.close();
                    
                    // 新增會員
                    pstmt = conn.prepareStatement(
                        "INSERT INTO member (username, password, email, phone, member_level, created_at) VALUES (?, ?, ?, ?, '一般會員', NOW())"
                    );
                    pstmt.setString(1, username);
                    pstmt.setString(2, password);
                    pstmt.setString(3, email);
                    pstmt.setString(4, phone.isEmpty() ? null : phone);
                    
                    int result = pstmt.executeUpdate();
                    
                    if (result > 0) {
                        message = "註冊成功！請登入您的帳號。";
                        messageType = "success";
                        
                        // 清空表單資料
                        username = "";
                        email = "";
                        phone = "";
                    } else {
                        message = "註冊失敗，請稍後再試！";
                        messageType = "error";
                    }
                }
                
            } catch (Exception e) {
                message = "註冊過程發生錯誤: " + e.getMessage();
                messageType = "error";
            } finally {
                closeResources(conn, pstmt, rs);
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>會員註冊 - NBA卡包商城</title>
    <link rel="stylesheet" href="css/common.css">
    <style>
        .register-container {
            max-width: 600px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .register-form {
            background: white;
            padding: 40px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .register-title {
            text-align: center;
            margin-bottom: 30px;
        }

        .register-title h2 {
            color: var(--primary-blue);
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .register-title p {
            color: #666;
            font-size: 1rem;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: var(--dark-text);
        }

        .required {
            color: var(--danger-color);
            font-weight: bold;
        }

        .form-group input {
            width: 100%;
            padding: 15px;
            border: 2px solid #e9ecef;
            border-radius: var(--border-radius);
            font-size: 16px;
            box-sizing: border-box;
            transition: all 0.3s ease;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary-blue);
            box-shadow: 0 0 0 3px rgba(0, 61, 165, 0.1);
        }

        .form-hint {
            font-size: 0.85rem;
            color: #6c757d;
            margin-top: 5px;
        }

        .btn-register {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, var(--primary-blue), var(--primary-purple));
            color: white;
            border: none;
            border-radius: var(--border-radius);
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 61, 165, 0.3);
        }

        .login-link {
            text-align: center;
            margin-top: 25px;
            padding-top: 25px;
            border-top: 1px solid #e9ecef;
        }

        .login-link p {
            color: #666;
            margin: 0;
        }

        .login-link a {
            color: var(--primary-blue);
            text-decoration: none;
            font-weight: 600;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

        .alert {
            padding: 15px 20px;
            border-radius: var(--border-radius);
            margin-bottom: 25px;
            font-weight: 500;
        }

        .alert.success {
            background-color: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert.error {
            background-color: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        /* 輸入驗證樣式 */
        .form-group input.valid {
            border-color: #28a745;
        }

        .form-group input.invalid {
            border-color: #dc3545;
        }

        @media (max-width: 768px) {
            .register-container {
                margin: 20px auto;
                padding: 0 15px;
            }

            .register-form {
                padding: 30px 20px;
            }

            .register-title h2 {
                font-size: 1.7rem;
            }
        }
    </style>
</head>

<body>
    <!-- 引入統一的header -->
    <%@ include file="header.jsp" %>

    <div class="container">
        <div class="register-container">
            <div class="register-form">
                <div class="register-title">
                    <h2>會員註冊</h2>
                    <p>加入NBA卡包商城，享受專屬會員優惠</p>
                </div>
                
                <% if (!message.isEmpty()) { %>
                    <div class="alert <%= messageType %>">
                        <%= message %>
                    </div>
                <% } %>
                
                <form method="post" action="register_member.jsp" id="registerForm">
                    <input type="hidden" name="action" value="register">
                    
                    <div class="form-group">
                        <label for="username">會員帳號 <span class="required">*</span></label>
                        <input type="text" id="username" name="username" required maxlength="20" 
                               value="<%= request.getParameter("username") != null ? sanitizeInput(request.getParameter("username")) : "" %>"
                               placeholder="請輸入會員帳號">
                        <div class="form-hint">帳號需至少3個字元，僅能包含英文字母、數字和下底線</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">電子郵件 <span class="required">*</span></label>
                        <input type="email" id="email" name="email" required maxlength="100"
                               value="<%= request.getParameter("email") != null ? sanitizeInput(request.getParameter("email")) : "" %>"
                               placeholder="請輸入電子郵件地址">
                        <div class="form-hint">我們將使用此郵件地址發送重要通知</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="password">密碼 <span class="required">*</span></label>
                        <input type="password" id="password" name="password" required maxlength="50"
                               placeholder="請輸入密碼">
                        <div class="form-hint">密碼需至少4個字元</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="confirmPassword">確認密碼 <span class="required">*</span></label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required maxlength="50"
                               placeholder="請再次輸入密碼">
                        <div class="form-hint">請確保兩次輸入的密碼相同</div>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">手機號碼</label>
                        <input type="tel" id="phone" name="phone" maxlength="20" pattern="[0-9\-+]*"
                               value="<%= request.getParameter("phone") != null ? sanitizeInput(request.getParameter("phone")) : "" %>"
                               placeholder="請輸入手機號碼 (選填)">
                        <div class="form-hint">選填，格式：09xxxxxxxx</div>
                    </div>
                    
                    <button type="submit" class="btn-register">
                        🎯 立即註冊
                    </button>
                </form>
                
                <div class="login-link">
                    <p>已經是會員了嗎？ <a href="member.jsp">立即登入</a></p>
                </div>
            </div>
        </div>
    </div>

    <!-- 引入統一的footer -->
    <%@ include file="footer.jsp" %>

    <script>
        // 表單驗證
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const phone = document.getElementById('phone').value.trim();
            
            // 帳號驗證
            if (username.length < 3) {
                e.preventDefault();
                alert('帳號至少需要3個字元！');
                document.getElementById('username').focus();
                return false;
            }
            
            if (!/^[a-zA-Z0-9_]+$/.test(username)) {
                e.preventDefault();
                alert('帳號只能包含英文字母、數字和下底線！');
                document.getElementById('username').focus();
                return false;
            }
            
            // 密碼驗證
            if (password.length < 4) {
                e.preventDefault();
                alert('密碼至少需要4個字元！');
                document.getElementById('password').focus();
                return false;
            }
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('密碼確認不一致！');
                document.getElementById('confirmPassword').focus();
                return false;
            }
            
            // 電子郵件驗證
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                alert('請輸入有效的電子郵件地址！');
                document.getElementById('email').focus();
                return false;
            }
            
            // 手機號碼驗證（如果有填寫）
            if (phone && !/^09\d{8}$/.test(phone)) {
                e.preventDefault();
                alert('手機號碼格式錯誤！請輸入正確的台灣手機號碼格式（09xxxxxxxx）');
                document.getElementById('phone').focus();
                return false;
            }
            
            return true;
        });
        
        // 即時密碼確認檢查
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (password && confirmPassword) {
                if (password === confirmPassword) {
                    this.classList.remove('invalid');
                    this.classList.add('valid');
                } else {
                    this.classList.remove('valid');
                    this.classList.add('invalid');
                }
            }
        });

        // 即時帳號格式檢查
        document.getElementById('username').addEventListener('input', function() {
            const username = this.value;
            
            if (username.length >= 3 && /^[a-zA-Z0-9_]+$/.test(username)) {
                this.classList.remove('invalid');
                this.classList.add('valid');
            } else if (username.length > 0) {
                this.classList.remove('valid');
                this.classList.add('invalid');
            }
        });

        // 即時郵件格式檢查
        document.getElementById('email').addEventListener('input', function() {
            const email = this.value;
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            
            if (emailRegex.test(email)) {
                this.classList.remove('invalid');
                this.classList.add('valid');
            } else if (email.length > 0) {
                this.classList.remove('valid');
                this.classList.add('invalid');
            }
        });
    </script>
</body>
</html> 