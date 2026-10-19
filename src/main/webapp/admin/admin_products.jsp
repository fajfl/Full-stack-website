<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="../dbConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>

<%
    // 權限檢查：只有管理員才能訪問此頁面
    String memberLevel = (String) session.getAttribute("memberLevel");
    if (memberLevel == null || !"管理員".equals(memberLevel)) {
        response.sendRedirect("../index.jsp"); // 重定向到首頁或錯誤頁面
        return;
    }

    // 獲取訊息參數
    String message = request.getParameter("msg");
    String messageType = request.getParameter("msgType");
%>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商品管理 - 管理後台</title>
    <link rel="stylesheet" href="../css/common.css">
    <link rel="stylesheet" href="../css/admin.css">
    <style>
        .admin-container {
            padding: 20px;
            max-width: 1400px;
            margin: 20px auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #003da5;
            text-align: center;
            margin-bottom: 25px;
            font-size: 2.2em;
        }
        .action-buttons {
            text-align: right;
            margin-bottom: 20px;
        }
        .action-buttons a {
            display: inline-block;
            background-color: #28a745;
            color: white;
            padding: 10px 18px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            transition: background-color 0.3s ease;
        }
        .action-buttons a:hover {
            background-color: #218838;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
            vertical-align: middle;
            font-size: 0.95em;
        }
        th {
            background-color: #f2f2f2;
            font-weight: bold;
            white-space: nowrap;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #e9e9e9;
        }
        .product-actions a, .product-actions button {
            display: inline-block;
            padding: 6px 10px;
            margin-right: 5px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 0.85em;
            font-weight: bold;
            cursor: pointer;
            border: none;
        }
        .product-actions a.edit {
            background-color: #007bff;
            color: white;
        }
        .product-actions a.edit:hover {
            background-color: #0056b3;
        }
        .product-actions button.delete {
            background-color: #dc3545;
            color: white;
        }
        .product-actions button.delete:hover {
            background-color: #c82333;
        }
        .product-actions button.toggle-status.on-shelf {
            background-color: #28a745;
            color: white;
        }
        .product-actions button.toggle-status.on-shelf:hover {
            background-color: #218838;
        }
        .product-actions button.toggle-status.off-shelf {
            background-color: #ffc107;
            color: #333;
        }
        .product-actions button.toggle-status.off-shelf:hover {
            background-color: #e0a800;
        }
        .no-products {
            text-align: center;
            padding: 30px;
            font-size: 1.1em;
            color: #666;
        }
        .product-image-thumb {
            width: 60px;
            height: 60px;
            object-fit: cover;
            border-radius: 4px;
            vertical-align: middle;
        }
        .message {
            padding: 15px;
            margin: 15px 0;
            border-radius: 4px;
            font-weight: bold;
        }
        .message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .status-badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.85em;
            font-weight: bold;
        }
        .status-badge.on-shelf {
            background-color: #28a745;
            color: white;
        }
        .status-badge.off-shelf {
            background-color: #ffc107;
            color: #333;
        }
    </style>
</head>
<body>
    <%@ include file="../header.jsp" %>
    
    <main class="admin-container">
        <div style="margin-bottom: 20px;">
            <a href="admin_panel.jsp" style="color: #0056b3; text-decoration: none; font-weight: bold;">← 返回管理後台</a>
        </div>
        <div class="admin-header">
            <h2>商品管理</h2>
        </div>
        
        <% if (message != null && !message.isEmpty()) { %>
            <div class="message <%= messageType %>">
                <%= message %>
            </div>
        <% } %>

        <% 
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            boolean hasProducts = false;

            try {
                conn = getConnection();
                String sql = "SELECT product_id, product_name, price, stock, status, main_image FROM product ORDER BY product_id DESC";
                pstmt = conn.prepareStatement(sql);
                rs = pstmt.executeQuery();
        %>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>圖片</th>
                    <th>商品名稱</th>
                    <th>價格</th>
                    <th>庫存</th>
                    <th>狀態</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                        hasProducts = true;
                        String statusText = rs.getString("status");
                        String statusClass = "";
                        String toggleAction = "";
                        String toggleButtonText = "";

                        if ("上架".equals(statusText)) {
                            statusClass = "on-shelf";
                            toggleAction = "下架";
                            toggleButtonText = "下架";
                        } else if ("下架".equals(statusText)) {
                            statusClass = "off-shelf";
                            toggleAction = "上架";
                            toggleButtonText = "上架";
                        }
                %>
                    <tr>
                        <td><%=rs.getInt("product_id")%></td>
                        <td><img src="../<%=rs.getString("main_image")%>" alt="<%=rs.getString("product_name")%>" class="product-image-thumb"></td>
                        <td><%=rs.getString("product_name")%></td>
                        <td>NT$<%=rs.getBigDecimal("price")%></td>
                        <td><%=rs.getInt("stock")%></td>
                        <td><span class="status-badge <%=statusClass%>"><%=statusText%></span></td>
                        <td class="product-actions">
                            <a href="admin_product_edit.jsp?product_id=<%=rs.getInt("product_id")%>" class="edit">編輯</a>
                            <a href="javascript:void(0)" 
                               onclick="updateStatus(<%=rs.getInt("product_id")%>, '<%=toggleAction%>')" 
                               class="toggle-status <%=statusClass%>">
                                <%=toggleButtonText%>
                            </a>
                        </td>
                    </tr>
                <%
                    }
                if (!hasProducts) {
        %>
                <tr>
                    <td colspan="7" class="no-products">目前沒有任何商品。</td>
                </tr>
        <%      }
            } catch (Exception e) {
                out.println("<p style=\"color: red; text-align: center;\">載入商品列表時發生錯誤: " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                closeResources(conn, pstmt, rs);
            }
        %>
            </tbody>
        </table>
    </main>

    <script>
        function confirmDelete(productId, productName) {
            if (confirm('確定要刪除商品「' + productName + '」嗎？此操作無法復原。')) {
                window.location.href = 'admin_product_delete.jsp?product_id=' + productId;
            }
        }
        
        function updateStatus(productId, newStatus) {
            if (confirm('確定要' + newStatus + '此商品嗎？')) {
                window.location.href = 'admin_product_status_update.jsp?product_id=' + productId + '&status=' + newStatus;
            }
        }
    </script>
</body>
</html> 