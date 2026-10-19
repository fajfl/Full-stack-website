<%@ page import="java.sql.*" %>
<%!
    // 資料庫連接參數
    private static final String DB_URL = System.getenv("NBA_DB_URL");
    private static final String DB_USER = System.getenv("NBA_DB_USER");
    private static final String DB_PASSWORD = System.getenv("NBA_DB_PASSWORD");
    
    // 資料庫連接狀態
    private static boolean dbDriverLoaded = false;
    
    // 初始化驅動程式
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            dbDriverLoaded = true;
            System.out.println("MySQL JDBC Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found: " + e.getMessage());
            dbDriverLoaded = false;
        }
    }
    
    // 獲取資料庫連接
    public Connection getConnection() throws SQLException {
        if (!dbDriverLoaded) {
            throw new SQLException("MySQL JDBC Driver not loaded");
        }
        
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            // 測試連接是否有效
            if (conn != null && !conn.isClosed()) {
                conn.createStatement().execute("SELECT 1");
            }
        } catch (SQLException e) {
            System.err.println("Database connection failed: " + e.getMessage());
            throw e;
        }
        return conn;
    }
    
    // 獲取安全的資料庫連接（不拋出異常，返回null）
    public Connection getSafeConnection() {
        try {
            return getConnection();
        } catch (Exception e) {
            System.err.println("Safe connection failed: " + e.getMessage());
            return null;
        }
    }
    
    // 檢查資料庫連接狀態
    public boolean isDatabaseAvailable() {
        if (!dbDriverLoaded) {
            return false;
        }
        
        Connection conn = null;
        try {
            conn = getConnection();
            return conn != null && !conn.isClosed();
        } catch (Exception e) {
            System.err.println("Database availability check failed: " + e.getMessage());
            return false;
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception e) {}
            }
        }
    }
    
    // 執行查詢並處理錯誤
    public ResultSet executeQuery(Connection conn, String sql, Object... params) throws SQLException {
        PreparedStatement pstmt = conn.prepareStatement(sql);
        for (int i = 0; i < params.length; i++) {
            pstmt.setObject(i + 1, params[i]);
        }
        return pstmt.executeQuery();
    }
    
    // 執行更新並處理錯誤
    public int executeUpdate(Connection conn, String sql, Object... params) throws SQLException {
        PreparedStatement pstmt = conn.prepareStatement(sql);
        for (int i = 0; i < params.length; i++) {
            pstmt.setObject(i + 1, params[i]);
        }
        return pstmt.executeUpdate();
    }
    
    // 關閉資源
    public void closeResources(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            System.err.println("Error closing ResultSet: " + e.getMessage());
        }
        try {
            if (pstmt != null) pstmt.close();
        } catch (SQLException e) {
            System.err.println("Error closing PreparedStatement: " + e.getMessage());
        }
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            System.err.println("Error closing Connection: " + e.getMessage());
        }
    }
    
    // 防止SQL注入的安全函數
    public String sanitizeInput(String input) {
        if (input == null) return "";
        return input.replaceAll("[<>\"'%;()&+]", "");
    }
    
    // 驗證數據庫表是否存在
    public boolean checkTableExists(String tableName) {
        Connection conn = null;
        try {
            conn = getSafeConnection();
            if (conn == null) return false;
            
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet rs = metaData.getTables(null, null, tableName, new String[]{"TABLE"});
            return rs.next();
        } catch (Exception e) {
            System.err.println("Error checking table existence: " + e.getMessage());
            return false;
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception e) {}
            }
        }
    }
    
    // 資料庫健康檢查
    public String getDatabaseStatus() {
        if (!dbDriverLoaded) {
            return "驅動程式未載入";
        }
        
        Connection conn = null;
        try {
            conn = getConnection();
            if (conn != null && !conn.isClosed()) {
                // 檢查主要資料表
                String[] requiredTables = {"member", "product", "category", "cart_item"};
                for (String table : requiredTables) {
                    if (!checkTableExists(table)) {
                        return "缺少必要資料表: " + table;
                    }
                }
                return "正常";
            } else {
                return "連接失敗";
            }
        } catch (Exception e) {
            return "錯誤: " + e.getMessage();
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception e) {}
            }
        }
    }
%> 