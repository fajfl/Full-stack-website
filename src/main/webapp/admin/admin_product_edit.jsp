<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ include file="../dbConnection.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.math.BigDecimal" %>

<% 
    // 權限檢查：只有管理員才能訪問此頁面
    String memberLevel = (String) session.getAttribute("memberLevel");
    if (memberLevel == null || !"管理員".equals(memberLevel)) {
        response.sendRedirect("../index.jsp");
        return;
    }

    String productId = request.getParameter("product_id");
    if (productId == null || productId.trim().isEmpty()) {
        response.sendRedirect("admin_products.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>編輯商品 - 管理後台</title>
    <link rel="stylesheet" href="../css/common.css">
    <style>
        .admin-container {
            padding: 20px;
            min-width: 700px;
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
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #333;
        }
        input[type="text"],
        input[type="number"],
        textarea,
        select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }
        textarea {
            height: 100px;
            resize: vertical;
        }
        .button-group {
            text-align: center;
            margin-top: 30px;
        }
        .button-group button {
            padding: 10px 20px;
            margin: 0 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
        }
        .save-btn {
            background-color: #28a745;
            color: white;
        }
        .cancel-btn {
            background-color: #6c757d;
            color: white;
        }
        .preview-image {
            max-width: 200px;
            margin-top: 10px;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <%@ include file="../header.jsp" %>
    
    <main class="admin-container">
        <div style="margin-bottom: 20px;">
            <a href="admin_products.jsp" style="color: #0056b3; text-decoration: none; font-weight: bold;">← 返回商品列表</a>
        </div>
        <h2>編輯商品</h2>
        
        <%
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                conn = getConnection();
                String sql = "SELECT * FROM product WHERE product_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(productId));
                rs = pstmt.executeQuery();
                
                if (rs.next()) {
        %>
        <form action="admin_product_update.jsp" method="post">
            <input type="hidden" name="product_id" value="<%= rs.getInt("product_id") %>">
            
            <div class="form-group">
                <label for="product_name">商品名稱</label>
                <input type="text" id="product_name" name="product_name" value="<%= rs.getString("product_name") %>" required>
            </div>
            
            <div class="form-group">
                <label for="price">價格</label>
                <input type="number" id="price" name="price" value="<%= rs.getBigDecimal("price").toString() %>" min="0" step="0.01" required>
            </div>
            
            <div class="form-group">
                <label for="stock">庫存</label>
                <input type="number" id="stock" name="stock" value="<%= rs.getInt("stock") %>" min="0" required>
            </div>
            
            <div class="form-group">
                <label for="status">狀態</label>
                <select id="status" name="status">
                    <option value="上架" <%= "上架".equals(rs.getString("status")) ? "selected" : "" %>>上架</option>
                    <option value="下架" <%= "下架".equals(rs.getString("status")) ? "selected" : "" %>>下架</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="description">商品描述</label>
                <textarea id="description" name="description" required><%= rs.getString("description") != null ? rs.getString("description") : "" %></textarea>
            </div>
            
            <div class="form-group">
                <label>商品圖片</label>
                <img src="../<%= rs.getString("main_image") %>" alt="當前商品圖片" class="preview-image">
            </div>
            
            <div class="button-group">
                <button type="submit" class="save-btn">儲存修改</button>
                <button type="button" class="cancel-btn" onclick="window.location.href='admin_products.jsp'">取消</button>
            </div>
        </form>
        <%
                } else {
                    out.println("<p style='color: red; text-align: center;'>找不到指定的商品。</p>");
                }
            } catch (Exception e) {
                out.println("<p style='color: red; text-align: center;'>載入商品資料時發生錯誤: " + e.getMessage() + "</p>");
                e.printStackTrace();
            } finally {
                closeResources(conn, pstmt, rs);
            }
        %>
    </main>
</body>
</html> 