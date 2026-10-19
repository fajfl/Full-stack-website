<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="中原第一家NBA球員卡專業商城，提供最優質的球員卡收藏品">
    <meta name="keywords" content="NBA,球員卡,籃球卡,收藏品,交易卡,運動卡片">
    <meta name="author" content="NBA Card Team">
    
    <!-- Open Graph 標籤 -->
    <meta property="og:title" content="NBA卡包商城">
    <meta property="og:description" content="中原第一家NBA球員卡專業商城">
    <meta property="og:type" content="website">
    <meta property="og:url" content="">
    <meta property="og:image" content="images/nba-logo.png">
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="images/favicon.ico">
    <link rel="apple-touch-icon" href="images/apple-touch-icon.png">
    
    <title><%=request.getParameter("pageTitle") != null ? request.getParameter("pageTitle") + " - " : ""%>NBA卡包商城</title>
    
    <!-- CSS 引入 -->
    <link rel="stylesheet" href="css/common.css">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+TC:wght@300;400;500;700;900&display=swap">
    
    <!-- 頁面專用CSS -->
    <% if (request.getParameter("customCSS") != null) { %>
        <style><%= request.getParameter("customCSS") %></style>
    <% } %>
</head>

<body>
    <!-- 資料庫狀態指示器 -->
    <%@ include file="dbConnection.jsp" %>
    <div class="db-status <%=isDatabaseAvailable() ? "connected" : "disconnected"%>">
        <span>●</span>
        <%=isDatabaseAvailable() ? "資料庫已連接" : "資料庫離線"%>
    </div>

    <!-- 統一Header -->
    <%@ include file="header.jsp" %>

    <!-- 主要內容區域 -->
    <main>
        <!-- 這裡是頁面特定內容 -->
        <jsp:include page="<%=request.getParameter("contentPage")%>" />
    </main>

    <!-- 統一Footer -->
    <%@ include file="footer.jsp" %>

    <!-- 全域JavaScript -->
    <script>
        // 通用功能
        document.addEventListener('DOMContentLoaded', function() {
            // 平滑滾動效果
            var links = document.querySelectorAll('a[href^="#"]');
            links.forEach(function(link) {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    var target = document.querySelector(this.getAttribute('href'));
                    if (target) {
                        target.scrollIntoView({
                            behavior: 'smooth',
                            block: 'start'
                        });
                    }
                });
            });

            // 表單驗證增強
            var forms = document.querySelectorAll('form');
            forms.forEach(function(form) {
                form.addEventListener('submit', function(e) {
                    var inputs = form.querySelectorAll('input[required], select[required], textarea[required]');
                    var isValid = true;
                    
                    inputs.forEach(function(input) {
                        if (!input.value.trim()) {
                            input.style.borderColor = '#dc3545';
                            isValid = false;
                        } else {
                            input.style.borderColor = '#28a745';
                        }
                    });
                    
                    if (!isValid) {
                        e.preventDefault();
                        alert('請填寫所有必填欄位！');
                    }
                });
            });

            // 圖片懶加載
            var images = document.querySelectorAll('img[data-src]');
            var imageObserver = new IntersectionObserver(function(entries, observer) {
                entries.forEach(function(entry) {
                    if (entry.isIntersecting) {
                        var img = entry.target;
                        img.src = img.dataset.src;
                        img.removeAttribute('data-src');
                        imageObserver.unobserve(img);
                    }
                });
            });
            
            images.forEach(function(img) {
                imageObserver.observe(img);
            });

            // 通知系統
            window.showNotification = function(message, type) {
                var notification = document.createElement('div');
                notification.className = 'notification notification-' + (type || 'info');
                notification.innerHTML = '<span>ℹ</span> ' + message;
                notification.style.cssText = `
                    position: fixed;
                    top: 20px;
                    right: 20px;
                    background: white;
                    border-left: 4px solid #17a2b8;
                    padding: 15px 20px;
                    border-radius: 8px;
                    box-shadow: 0 4px 12px rgba(0,0,0,0.15);
                    z-index: 10000;
                    transform: translateX(400px);
                    transition: transform 0.3s ease;
                `;
                
                document.body.appendChild(notification);
                
                setTimeout(function() {
                    notification.style.transform = 'translateX(0)';
                }, 100);
                
                setTimeout(function() {
                    notification.style.transform = 'translateX(400px)';
                    setTimeout(function() {
                        if (notification.parentNode) {
                            notification.parentNode.removeChild(notification);
                        }
                    }, 300);
                }, 3000);
            };
        });

        // 全域錯誤處理
        window.addEventListener('error', function(e) {
            console.error('頁面錯誤:', e.error);
            // 可以在這裡添加錯誤回報機制
        });
    </script>

    <!-- 頁面專用JavaScript -->
    <% if (request.getParameter("customJS") != null) { %>
        <script><%= request.getParameter("customJS") %></script>
    <% } %>
</body>
</html>