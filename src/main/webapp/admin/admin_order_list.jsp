<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="../dbConnection.jsp" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>訂單管理 - 管理後台</title>
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
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
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
        .status-badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.9em;
            font-weight: bold;
        }
        .status-processing {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-shipped {
            background-color: #d4edda;
            color: #155724;
        }
        .status-completed {
            background-color: #cce5ff;
            color: #004085;
        }
        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <%@ include file="../header.jsp" %>

    <main class="admin-container">
        <div style="margin-bottom: 20px;">
            <a href="admin_panel.jsp" style="color: #0056b3; text-decoration: none; font-weight: bold;">← 返回管理後台</a>
        </div>
        <h2>訂單管理</h2>
        
        <table>
            <tr>
                <th>訂單編號</th>
                <th>會員ID</th>
                <th>訂單日期</th>
                <th>總金額</th>
                <th>狀態</th>
                <th>操作</th>
            </tr>
            <%
                Connection conn = null;
                PreparedStatement pstmt = null;
                ResultSet rs = null;
                
                try {
                    conn = getConnection();
                    String sql = "SELECT order_id, member_id, created_at, final_amount, order_status FROM orders ORDER BY created_at DESC";
                    pstmt = conn.prepareStatement(sql);
                    rs = pstmt.executeQuery();
                    
                    while (rs.next()) {
                        String status = rs.getString("order_status");
                        String statusClass = "";
                        switch(status) {
                            case "處理中":
                                statusClass = "status-processing";
                                break;
                            case "已出貨":
                                statusClass = "status-shipped";
                                break;
                            case "已完成":
                                statusClass = "status-completed";
                                break;
                            case "已取消":
                                statusClass = "status-cancelled";
                                break;
                        }
            %>
                <tr>
                    <td><%= rs.getInt("order_id") %></td>
                    <td><%= rs.getInt("member_id") %></td>
                    <td><%= rs.getTimestamp("created_at") %></td>
                    <td>NT$<%= rs.getBigDecimal("final_amount") %></td>
                    <td><span class="status-badge <%= statusClass %>"><%= status %></span></td>
                    <td>
                        <a href="admin_order_detail.jsp?order_id=<%= rs.getInt("order_id") %>" style="color: #007bff; text-decoration: none;">查看詳情</a>
                    </td>
                </tr>
            <%
                    }
                } catch (Exception e) {
                    out.println("<tr><td colspan='6' style='color: red; text-align: center;'>載入訂單資料時發生錯誤: " + e.getMessage() + "</td></tr>");
                    e.printStackTrace();
                } finally {
                    closeResources(conn, pstmt, rs);
                }
            %>
        </table>
    </main>
</body>
</html> 