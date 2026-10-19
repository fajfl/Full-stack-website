# NBA 卡包商城

2025 年網路程式設計期末專案，以 Java/JSP 搭配 MySQL，提供球員卡、卡盒與周邊商品商城。

包含商品瀏覽、搜尋、會員、購物車、結帳、留言、商品評價及管理後台。

## 原始碼

- [商城首頁](src/main/webapp/index.jsp)
- [網頁、JSP 後端、CSS 與圖片](src/main/webapp/)
- [管理後台](src/main/webapp/admin/)
- [資料庫結構與展示商品資料](src/main/sql/nba_database_final.sql)

## 執行設定

需要 Java、支援 JSP 的伺服器（例如 Apache Tomcat）、MySQL 和 MySQL Connector/J。資料庫匯出自 MySQL 8.4.0，原使用的 Java、Tomcat 與 JDBC 驅動版本尚未確認。此備份未包含伺服器、JDBC JAR 或建置設定。

1. 在專用的本機 MySQL 測試環境匯入 SQL。它會建立 `nba_db`，且包含 `DROP TABLE IF EXISTS`，不要對現有重要資料庫直接執行。
2. 在啟動 Tomcat 的環境設定下列變數：

   | 變數 | 用途 |
   | --- | --- |
   | `NBA_DB_URL` | JDBC 網址，例如 `jdbc:mysql://localhost:3306/nba_db?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Taipei` |
   | `NBA_DB_USER` | 本機 MySQL 使用者 |
   | `NBA_DB_PASSWORD` | 本機 MySQL 密碼 |

3. 將 `src/main/webapp/` 的內容部署到 Tomcat 應用程式目錄，透過應用程式網址開啟 `index.jsp`。
4. 歷史會員資料未附入，可由網站註冊測試會員。

## 備份範圍

- 保留找到的全部 139 個來源檔案，未重複放入 ZIP 備份、較早的純前端版本或無關課堂練習。
- 原本寫死的 MySQL 連線設定改由環境變數讀取，未上傳原密碼。
- 保留全部資料表結構與商品等展示資料，移除歷史會員、購物車、訂單、積分、留言、評論及相關紀錄，另移除歷史站台設定與統計資料。
- 原始本機檔案未被覆寫。

這是課程專案的原始碼備份，尚未重新啟動驗證。會員密碼處理、管理員權限與資料庫診斷及維護頁面沿用舊實作；正式對外部署前需另行檢查。
