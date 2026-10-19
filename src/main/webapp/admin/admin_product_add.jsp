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

    // 獲取所有商品分類
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html lang="zh-TW">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>新增商品 - 管理後台</title>
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
            display: none;
        }
        .form-row {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        .form-row .form-group {
            flex: 1;
            margin-bottom: 0;
        }
        /* 新增圖片預覽相關樣式 */
        .image-preview-container {
            margin-top: 10px;
            text-align: center;
        }
        .preview-image {
            max-width: 300px;
            max-height: 300px;
            border-radius: 4px;
            display: none;
            margin: 10px auto;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        input[type="file"] {
            padding: 10px;
            border: 1px dashed #ccc;
            border-radius: 4px;
            width: 100%;
            box-sizing: border-box;
        }
        input[type="file"]:hover {
            border-color: #0056b3;
        }
    </style>
</head>
<body>
    <%@ include file="../header.jsp" %>
    
    <main class="admin-container">
        <div style="margin-bottom: 20px;">
            <a href="admin_products.jsp" style="color: #0056b3; text-decoration: none; font-weight: bold;">← 返回商品列表</a>
        </div>
        <h2>新增商品</h2>
        
        <form action="admin_product_add_process.jsp" method="post" enctype="multipart/form-data">
            <div class="form-row">
                <div class="form-group">
                    <label for="category_id">商品分類</label>
                    <select id="category_id" name="category_id" required>
                        <%
                            try {
                                conn = getConnection();
                                String sql = "SELECT category_id, category_name FROM category ORDER BY category_id";
                                pstmt = conn.prepareStatement(sql);
                                rs = pstmt.executeQuery();
                                while (rs.next()) {
                        %>
                        <option value="<%= rs.getInt("category_id") %>"><%= rs.getString("category_name") %></option>
                        <%
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            } finally {
                                closeResources(conn, pstmt, rs);
                            }
                        %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="product_name">商品名稱</label>
                    <input type="text" id="product_name" name="product_name" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="price">價格</label>
                    <input type="number" id="price" name="price" min="0" step="0.01" required>
                </div>
                
                <div class="form-group">
                    <label for="stock">庫存</label>
                    <input type="number" id="stock" name="stock" min="0" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="player_name">球員姓名</label>
                    <input type="text" id="player_name" name="player_name">
                </div>
                
                <div class="form-group">
                    <label for="team">球隊</label>
                    <input type="text" id="team" name="team">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="card_year">卡片年份</label>
                    <input type="text" id="card_year" name="card_year">
                </div>
                
                <div class="form-group">
                    <label for="card_series">卡片系列</label>
                    <input type="text" id="card_series" name="card_series">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="rarity">稀有度</label>
                    <select id="rarity" name="rarity">
                        <option value="一般">一般</option>
                        <option value="稀有">稀有</option>
                        <option value="超稀有">超稀有</option>
                        <option value="傳奇">傳奇</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="card_condition">卡片狀況</label>
                    <select id="card_condition" name="card_condition">
                        <option value="Mint">Mint</option>
                        <option value="Near Mint">Near Mint</option>
                        <option value="Excellent">Excellent</option>
                        <option value="Very Good">Very Good</option>
                        <option value="Good">Good</option>
                    </select>
                </div>
            </div>
            
            <div class="form-group">
                <label for="status">狀態</label>
                <select id="status" name="status">
                    <option value="上架">上架</option>
                    <option value="下架">下架</option>
                </select>
            </div>
            
            <div class="form-group">
                <label for="description">商品描述</label>
                <textarea id="description" name="description" required></textarea>
            </div>
            
            <div class="form-group">
                <label for="productImage">商品圖片</label>
                <input type="file" id="productImage" name="productImage" accept="image/*" required 
                       onchange="previewImage(this)">
                <div class="image-preview-container">
                    <img id="imagePreview" class="preview-image" alt="預覽圖片">
                </div>
            </div>
            
            <div class="button-group">
                <button type="submit" class="save-btn">新增商品</button>
                <button type="button" class="cancel-btn" onclick="window.location.href='admin_products.jsp'">取消</button>
            </div>
        </form>
    </main>

    <script>
        function previewImage(input) {
            var preview = document.getElementById('imagePreview');
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.style.display = 'none';
            }
        }
    </script>
</body>
</html> 