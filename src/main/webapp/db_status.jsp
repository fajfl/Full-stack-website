<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="dbConnection.jsp" %>
<%@ page import="java.sql.*" %>

<%
    String dbStatus = getDatabaseStatus();
    boolean isDbConnected = "正常".equals(dbStatus);
%>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>資料庫狀態檢查 - NBA卡包商城</title>
    <link rel="stylesheet" href="css/common.css">
    <style>
        .status-container {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
        }
        
        .status-card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .status-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .status-header h1 {
            color: var(--primary-blue);
            margin-bottom: 10px;
        }
        
        .status-indicator {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            font-size: 1.2rem;
            font-weight: 600;
        }
        
        .status-connected {
            background: #d4edda;
            color: #155724;
            border: 2px solid #28a745;
        }
        
        .status-error {
            background: #f8d7da;
            color: #721c24;
            border: 2px solid #dc3545;
        }
        
        .status-icon {
            font-size: 2rem;
        }
        
        .db-details {
            background: var(--light-bg);
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        
        .db-details h3 {
            color: var(--primary-blue);
            margin-bottom: 15px;
        }
        
        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #dee2e6;
        }
        
        .detail-row:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            font-weight: 600;
            color: #666;
        }
        
        .detail-value {
            color: #333;
        }
        
        .table-check {
            background: white;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            overflow: hidden;
        }
        
        .table-check h3 {
            background: var(--primary-blue);
            color: white;
            padding: 15px 20px;
            margin: 0;
        }
        
        .table-list {
            padding: 0;
            margin: 0;
            list-style: none;
        }
        
        .table-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
            border-bottom: 1px solid #f8f9fa;
        }
        
        .table-item:last-child {
            border-bottom: none;
        }
        
        .table-name {
            font-weight: 500;
        }
        
        .table-status {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }
        
        .status-exists {
            background: #d4edda;
            color: #155724;
        }
        
        .status-missing {
            background: #f8d7da;
            color: #721c24;
        }
        
        .action-buttons {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 30px;
        }
        
        .refresh-btn {
            background: var(--primary-blue);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .refresh-btn:hover {
            background: var(--accent-blue);
            transform: translateY(-2px);
        }
        
        @media (max-width: 768px) {
            .status-container {
                margin: 20px auto;
                padding: 15px;
            }
            
            .status-card {
                padding: 20px;
            }
            
            .detail-row {
                flex-direction: column;
                gap: 5px;
            }
            
            .action-buttons {
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
        <div class="status-container">
            <div class="status-card">
                <div class="status-header">
                    <h1>資料庫連接狀態檢查</h1>
                    <p>檢查系統資料庫連接狀態和必要資料表</p>
                </div>
                
                <!-- 連接狀態指示器 -->
                <div class="status-indicator <%= isDbConnected ? "status-connected" : "status-error" %>">
                    <span class="status-icon"><%= isDbConnected ? "✅" : "❌" %></span>
                    <span>資料庫狀態：<%=dbStatus%></span>
                </div>
                
                <!-- 資料庫詳細資訊 -->
                <div class="db-details">
                    <h3>📊 連接資訊</h3>
                    <div class="detail-row">
                        <span class="detail-label">資料庫URL:</span>
                        <span class="detail-value">jdbc:mysql://localhost:3306/nba_db</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">用戶名:</span>
                        <span class="detail-value">root</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">字符編碼:</span>
                        <span class="detail-value">UTF-8</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">SSL:</span>
                        <span class="detail-value">已停用</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">檢查時間:</span>
                        <span class="detail-value"><%= new java.util.Date() %></span>
                    </div>
                </div>
                
                <!-- 資料表檢查 -->
                <div class="table-check">
                    <h3>🗃️ 必要資料表檢查</h3>
                    <ul class="table-list">
                        <%
                            String[] requiredTables = {"member", "product", "category", "cart_item", "orders", "order_item"};
                            for (String tableName : requiredTables) {
                                boolean tableExists = checkTableExists(tableName);
                        %>
                        <li class="table-item">
                            <span class="table-name"><%=tableName%></span>
                            <span class="table-status <%= tableExists ? "status-exists" : "status-missing" %>">
                                <%= tableExists ? "✓ 存在" : "✗ 缺失" %>
                            </span>
                        </li>
                        <% } %>
                    </ul>
                </div>
                
                <!-- 建議和說明 -->
                <% if (!isDbConnected) { %>
                <div class="alert alert-error" style="margin-top: 20px;">
                    <h4>🚨 資料庫連接問題</h4>
                    <p><strong>可能原因：</strong></p>
                    <ul>
                        <li>MySQL伺服器未啟動</li>
                        <li>資料庫名稱或連接參數錯誤</li>
                        <li>用戶名或密碼不正確</li>
                        <li>防火牆阻擋連接</li>
                        <li>MySQL JDBC驅動程式未安裝</li>
                    </ul>
                    <p><strong>解決方案：</strong></p>
                    <ul>
                        <li>確保MySQL伺服器正在運行</li>
                        <li>檢查資料庫連接參數</li>
                        <li>驗證用戶權限設定</li>
                        <li>確認防火牆設定</li>
                    </ul>
                </div>
                <% } else { %>
                <div class="alert alert-success" style="margin-top: 20px;">
                    <h4>✅ 資料庫連接正常</h4>
                    <p>系統已成功連接到資料庫，所有功能正常運作。</p>
                </div>
                <% } %>
                
                <!-- 操作按鈕 -->
                <div class="action-buttons">
                    <button onclick="location.reload()" class="refresh-btn">🔄 重新檢查</button>
                    <a href="index.jsp" class="btn btn-primary">返回首頁</a>
                    <% if (isDbConnected) { %>
                        <a href="card.jsp" class="btn btn-success">瀏覽商品</a>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
    
    <!-- 引入統一的footer -->
    <%@ include file="footer.jsp" %>
    
    <!-- 將狀態傳遞給JavaScript -->
    <script type="text/javascript">
        window.dbConnected = <%= isDbConnected ? "true" : "false" %>;
    </script>
    
    <script>
        // 自動刷新（每30秒檢查一次）
        if (!window.dbConnected) {
            setTimeout(function() {
                location.reload();
            }, 30000);
        }
        
        // 顯示重新檢查提示
        document.addEventListener('DOMContentLoaded', function() {
            if (!window.dbConnected) {
                console.log('資料庫連接失敗，將在30秒後自動重新檢查...');
            }
        });
    </script>
</body>
</html> 