<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="../dbConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>訂單詳情 - 管理後台</title>
    <link rel="stylesheet" href="../css/common.css">
    <style>
        .admin-container {
            padding: 20px;
            max-width: 1200px;
            margin: 20px auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            color: #003da5;
            text-align: center;
            margin-bottom: 25px;
        }
        h3 {
            color: #0056b3;
            margin-top: 30px;
            margin-bottom: 15px;
            border-bottom: 2px solid #eee;
            padding-bottom: 5px;
        }
        p {
            margin-bottom: 8px;
            line-height: 1.6;
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
        }
        th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #e9e9e9;
        }
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #0056b3;
            text-decoration: none;
            font-weight: bold;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .status-form {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .status-form select {
            padding: 8px;
            border-radius: 5px;
            border: 1px solid #ccc;
            margin-right: 10px;
        }
        .status-form button {
            padding: 8px 15px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .status-form button:hover {
            background-color: #0056b3;
        }
        .alert {
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
</head>
<body>
    <%@ include file="../header.jsp" %>

    <main class="admin-container">
        <div style="margin-bottom: 20px;">
            <a href="admin_panel.jsp" style="color: #0056b3; text-decoration: none; font-weight: bold;">← 返回管理後台</a>
        </div>
        <% 
            String orderIdParam = request.getParameter("order_id");
            int orderId = -1; // Default to an invalid ID
            if (orderIdParam != null && !orderIdParam.isEmpty()) {
                try {
                    orderId = Integer.parseInt(orderIdParam);
                } catch (NumberFormatException e) {
                    // Handle invalid orderId parameter
                    out.println("<p style=\"color: red; text-align: center;\">無效的訂單編號。</p>");
                    return;
                }
            }
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rso = null;
            ResultSet rsd = null;

            try {
                conn = getConnection();

                // 獲取訂單主檔資訊
                String orderSql = "SELECT member_id, shipping_name, shipping_address, shipping_phone, order_status, payment_status, total_amount, shipping_fee, final_amount, order_note, created_at FROM orders WHERE order_id = ?";
                pstmt = conn.prepareStatement(orderSql);
                pstmt.setInt(1, orderId);
                rso = pstmt.executeQuery();
        %>

        <h2>訂單 #<%= orderId %> 詳情</h2>

        <h3>收件資訊</h3>
        <% 
                if (rso.next()) {
        %>
        <p><strong>訂單日期:</strong> <%= rso.getTimestamp("created_at") %></p>
        <p><strong>會員ID:</strong> <%= rso.getInt("member_id") %></p>
        <p><strong>收件人:</strong> <%= rso.getString("shipping_name") %></p>
        <p><strong>地址:</strong> <%= rso.getString("shipping_address") %></p>
        <p><strong>電話:</strong> <%= rso.getString("shipping_phone") %></p>
        <p><strong>訂單狀態:</strong> <%= rso.getString("order_status") %></p>
        <p><strong>付款狀態:</strong> <%= rso.getString("payment_status") %></p>
        <p><strong>商品總金額:</strong> NT$<%= rso.getBigDecimal("total_amount") %></p>
        <p><strong>運費:</strong> NT$<%= rso.getBigDecimal("shipping_fee") %></p>
        <p><strong>最終付款金額:</strong> NT$<%= rso.getBigDecimal("final_amount") %></p>
        <p><strong>訂單備註:</strong> <%= rso.getString("order_note") != null ? rso.getString("order_note") : "無" %></p>

        <!-- 訂單狀態更新表單 -->
        <h3 style="margin-top: 30px;">更新訂單狀態</h3>
        <form action="admin_order_status_update.jsp" method="post" class="status-form">
            <input type="hidden" name="order_id" value="<%= orderId %>">
            <div style="display: flex; align-items: center; gap: 10px;">
                <label for="orderStatus">選擇新狀態:</label>
                <select name="status" id="orderStatus">
                    <option value="處理中" <%= "處理中".equals(rso.getString("order_status")) ? "selected" : "" %>>處理中</option>
                    <option value="已出貨" <%= "已出貨".equals(rso.getString("order_status")) ? "selected" : "" %>>已出貨</option>
                    <option value="已完成" <%= "已完成".equals(rso.getString("order_status")) ? "selected" : "" %>>已完成</option>
                    <option value="已取消" <%= "已取消".equals(rso.getString("order_status")) ? "selected" : "" %>>已取消</option>
                </select>
                <button type="submit">更新狀態</button>
            </div>
        </form>

        <!-- 付款狀態更新表單 -->
        <h3>更新付款狀態</h3>
        <form action="admin_payment_status_update.jsp" method="post" class="status-form">
            <input type="hidden" name="order_id" value="<%= orderId %>">
            <div style="display: flex; align-items: center; gap: 10px;">
                <label for="paymentStatus">選擇付款狀態:</label>
                <select name="payment_status" id="paymentStatus">
                    <option value="未付款" <%= "未付款".equals(rso.getString("payment_status")) ? "selected" : "" %>>未付款</option>
                    <option value="已付款" <%= "已付款".equals(rso.getString("payment_status")) ? "selected" : "" %>>已付款</option>
                    <option value="已退款" <%= "已退款".equals(rso.getString("payment_status")) ? "selected" : "" %>>已退款</option>
                </select>
                <button type="submit">更新付款狀態</button>
            </div>
        </form>

        <h3>商品明細</h3>
        <table>
            <tr>
                <th>商品名稱</th>
                <th>數量</th>
                <th>單價</th>
                <th>小計</th>
            </tr>
        <% 
                // 獲取訂單明細
                String detailSql = "SELECT oi.quantity, oi.price, p.product_name FROM order_item oi JOIN product p ON oi.product_id = p.product_id WHERE oi.order_id = ?";
                pstmt = conn.prepareStatement(detailSql);
                pstmt.setInt(1, orderId);
                rsd = pstmt.executeQuery();
                
                boolean hasDetails = false;
                while (rsd.next()) {
                    hasDetails = true;
                    int qty = rsd.getInt("quantity");
                    BigDecimal price = rsd.getBigDecimal("price");
                    BigDecimal subtotal = price.multiply(new BigDecimal(qty));
        %>
            <tr>
                <td><%= rsd.getString("product_name") %></td>
                <td><%= qty %></td>
                <td>NT$<%= price %></td>
                <td>NT$<%= subtotal %></td>
            </tr>
        <% 
                }
                if (!hasDetails) {
        %>
            <tr>
                <td colspan="4" style="text-align: center; color: #666;">此訂單沒有商品明細。</td>
            </tr>
        <% 
                }
        %>
        </table>
        <%
                } else {
        %>
            <p style="color: red; text-align: center;">找不到訂單資料。</p>
        <%
                }
            } catch (Exception e) {
                out.println("<p style=\"color: red; text-align: center;\">載入訂單詳情時發生錯誤: " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                // 分別關閉 ResultSet 物件
                try {
                    if (rsd != null) rsd.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                try {
                    if (rso != null) rso.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                // 使用 closeResources 關閉 Connection 和 PreparedStatement
                closeResources(conn, pstmt, null);
            }
        %>
        <p><a href="admin_order_list.jsp" class="back-link">← 返回訂單列表</a></p>
    </main>
</body>
</html> 