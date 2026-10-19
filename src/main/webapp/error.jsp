<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page isErrorPage="true" %>
<%
    String errorCode = request.getParameter("code");
    String errorMessage = request.getParameter("message");
    String errorType = request.getParameter("type");
    
    // 預設錯誤資訊
    if (errorCode == null) errorCode = "500";
    if (errorMessage == null) errorMessage = "系統發生未知錯誤";
    if (errorType == null) errorType = "system";
    
    // 根據錯誤代碼設定詳細資訊
    String errorTitle = "";
    String errorDescription = "";
    String suggestion = "";
    
    switch (errorCode) {
        case "404":
            errorTitle = "頁面找不到";
            errorDescription = "您要訪問的頁面不存在或已被移除";
            suggestion = "請檢查網址是否正確，或返回首頁重新導航";
            break;
        case "500":
            errorTitle = "伺服器錯誤";
            errorDescription = "伺服器內部發生錯誤，無法完成您的請求";
            suggestion = "請稍後再試，如果問題持續存在，請聯繫客服";
            break;
        case "403":
            errorTitle = "權限不足";
            errorDescription = "您沒有權限訪問此頁面";
            suggestion = "請確認您已登入並具有相應權限";
            break;
        case "db":
            errorTitle = "資料庫連線錯誤";
            errorDescription = "無法連接到資料庫伺服器";
            suggestion = "系統正在維護中，請稍後再試";
            break;
        default:
            errorTitle = "系統錯誤";
            errorDescription = errorMessage;
            suggestion = "請稍後再試或聯繫客服";
            break;
    }
%>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>錯誤 <%=errorCode%> - NBA卡包商城</title>
    <link rel="stylesheet" href="css/common.css">
    <style>
        .error-container {
            min-height: 60vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            padding: 40px 20px;
        }
        
        .error-content {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            max-width: 600px;
            width: 100%;
        }
        
        .error-icon {
            font-size: 4rem;
            margin-bottom: 20px;
        }
        
        .error-code {
            font-size: 3rem;
            font-weight: bold;
            color: var(--danger-color);
            margin-bottom: 10px;
        }
        
        .error-title {
            font-size: 1.8rem;
            color: var(--primary-blue);
            margin-bottom: 15px;
        }
        
        .error-description {
            color: #666;
            margin-bottom: 20px;
            line-height: 1.6;
        }
        
        .error-suggestion {
            background: var(--light-bg);
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            color: #555;
        }
        
        .error-actions {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .error-actions .btn {
            min-width: 120px;
        }
        
        @media (max-width: 480px) {
            .error-content {
                padding: 20px;
            }
            
            .error-code {
                font-size: 2rem;
            }
            
            .error-title {
                font-size: 1.5rem;
            }
            
            .error-actions {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
</head>

<body>
    <!-- 引入統一的header -->
    <%@ include file="header.jsp" %>
    
    <div class="container">
        <div class="error-container">
            <div class="error-content">
                <div class="error-icon">
                    <% if ("404".equals(errorCode)) { %>
                        🔍
                    <% } else if ("500".equals(errorCode) || "db".equals(errorCode)) { %>
                        ⚠️
                    <% } else if ("403".equals(errorCode)) { %>
                        🔒
                    <% } else { %>
                        ❌
                    <% } %>
                </div>
                
                <div class="error-code">錯誤 <%=errorCode%></div>
                <h1 class="error-title"><%=errorTitle%></h1>
                <p class="error-description"><%=errorDescription%></p>
                
                <div class="error-suggestion">
                    <strong>建議：</strong><%=suggestion%>
                </div>
                
                <div class="error-actions">
                    <a href="javascript:history.back()" class="btn btn-secondary">返回上頁</a>
                    <a href="index.jsp" class="btn btn-primary">返回首頁</a>
                    <% if (!"403".equals(errorCode)) { %>
                        <a href="help.jsp" class="btn btn-info">客服中心</a>
                    <% } %>
                </div>
                
                <!-- 錯誤詳情（僅開發模式顯示） -->
                <% if (exception != null && "development".equals(application.getInitParameter("mode"))) { %>
                    <details style="margin-top: 30px; text-align: left;">
                        <summary style="cursor: pointer; color: #666;">技術詳情</summary>
                        <pre style="background: #f8f9fa; padding: 15px; border-radius: 5px; overflow: auto; font-size: 12px;">
錯誤類型: <%=exception.getClass().getName()%>
錯誤訊息: <%=exception.getMessage()%>
                        </pre>
                    </details>
                <% } %>
            </div>
        </div>
    </div>
    
    <!-- 引入統一的footer -->
    <%@ include file="footer.jsp" %>
    
    <!-- 將錯誤代碼傳遞給JavaScript -->
    <script type="text/javascript">
        window.errorCode = '<%=errorCode%>';
        window.errorMessage = '<%=errorMessage%>';
    </script>
    
    <script>
        // 自動重試機制（針對資料庫錯誤）
        if (window.errorCode === 'db') {
            var retryCount = 0;
            var maxRetries = 3;
            
            function autoRetry() {
                if (retryCount < maxRetries) {
                    retryCount++;
                    setTimeout(function() {
                        window.location.reload();
                    }, 5000 * retryCount); // 遞增延遲
                }
            }
            
            // 5秒後開始自動重試
            setTimeout(autoRetry, 5000);
        }
        
        // 錯誤報告（可選）
        function reportError() {
            var errorData = {
                code: window.errorCode,
                message: window.errorMessage,
                url: window.location.href,
                userAgent: navigator.userAgent,
                timestamp: new Date().toISOString()
            };
            
            // 發送錯誤報告到後端（實現可選）
            fetch('report_error.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(errorData)
            }).catch(function() {
                // 忽略報告錯誤
            });
        }
        
        // 頁面載入完成後發送錯誤報告
        document.addEventListener('DOMContentLoaded', reportError);
    </script>
</body>
</html> 