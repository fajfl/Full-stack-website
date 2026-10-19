<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="../dbConnection.jsp" %>

<% 
    // 權限檢查：只有管理員才能訪問此頁面
    String memberLevel = (String) session.getAttribute("memberLevel");
    if (memberLevel == null || !"管理員".equals(memberLevel)) {
        response.sendRedirect("../index.jsp"); // 重定向到首頁或錯誤頁面
        return;
    }
%>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>管理員後台 - NBA卡包商城</title>
    <link rel="stylesheet" href="../css/common.css">
    <style>
        .admin-container {
            padding: 20px;
            max-width: 900px;
            margin: 20px auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        h2 {
            color: #003da5;
            margin-bottom: 30px;
            font-size: 2.2em;
        }
        .admin-nav ul {
            list-style: none;
            padding: 0;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
        }
        .admin-nav li {
            background-color: #f2f2f2;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            flex: 1 1 calc(33% - 40px); /* 三個項目一行，減去gap */
            min-width: 280px; /* 最小寬度 */
            max-width: 350px;
        }
        .admin-nav li:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .admin-nav a {
            display: block;
            padding: 25px 20px;
            text-decoration: none;
            color: #333;
            font-size: 1.3em;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
        }
        .admin-nav a:hover {
            background-color: #e6e6e6;
            color: #003da5;
        }
        .admin-nav .icon {
            font-size: 1.5em;
            color: #003da5;
        }

        @media (max-width: 768px) {
            .admin-nav li {
                flex: 1 1 calc(50% - 40px); /* 兩項目一行 */
            }
        }
        @media (max-width: 480px) {
            .admin-nav li {
                flex: 1 1 100%; /* 一項目一行 */
                max-width: none;
            }
        }
    </style>
</head>
<body>
    <%@ include file="../header.jsp" %>
    
    <main class="admin-container">
        <h2>管理員後台</h2>
        <nav class="admin-nav">
            <ul>
                <li><a href="admin_products.jsp"><span class="icon">📦</span>商品管理</a></li>
                <li><a href="admin_order_list.jsp"><span class="icon">📝</span>訂單管理</a></li>
                <!-- 未來可以新增更多管理功能連結 -->
            </ul>
        </nav>
    </main>
</body>
</html> 