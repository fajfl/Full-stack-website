CREATE DATABASE  IF NOT EXISTS `nba_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `nba_db`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: nba_db
-- ------------------------------------------------------
-- Server version	8.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `announcements`
--

DROP TABLE IF EXISTS `announcements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `announcements` (
  `announcement_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`announcement_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `announcements`
--

LOCK TABLES `announcements` WRITE;
/*!40000 ALTER TABLE `announcements` DISABLE KEYS */;
INSERT INTO `announcements` VALUES (1,'歡迎來到NBA卡包商城！','我們專營NBA球星卡片收藏，提供最優質的收藏品','2025-06-04 19:46:49',1),(2,'2024新品到貨通知','2024 Panini Prizm系列已經到貨，限量發售中！','2025-06-04 19:46:49',1),(3,'VIP會員優惠活動','成為VIP會員享受9折優惠，年費僅需$2000','2025-06-04 19:46:49',1);
/*!40000 ALTER TABLE `announcements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banner_ads`
--

DROP TABLE IF EXISTS `banner_ads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banner_ads` (
  `ad_id` int NOT NULL AUTO_INCREMENT,
  `title` varchar(100) NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `link_url` varchar(255) DEFAULT NULL,
  `description` text,
  `is_active` tinyint(1) DEFAULT '1',
  `sort_order` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ad_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banner_ads`
--

LOCK TABLES `banner_ads` WRITE;
/*!40000 ALTER TABLE `banner_ads` DISABLE KEYS */;
INSERT INTO `banner_ads` VALUES (1,'限量版球員卡','images/product_2_1.jpg','card.jsp','限量版球員卡現正熱賣中！',1,1,'2025-06-04 19:57:27'),(2,'會員註冊優惠','images/box_curry_1.jpg','card_box.jsp','新會員註冊即享88折優惠！',1,2,'2025-06-04 19:57:27'),(3,'經典喬丹系列','images/special_olympic_1.jpg','special.jsp','經典喬丹系列卡片重新上架！',1,3,'2025-06-04 19:57:27');
/*!40000 ALTER TABLE `banner_ads` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_item`
--

DROP TABLE IF EXISTS `cart_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_item` (
  `member_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`member_id`,`product_id`),
  KEY `fk_cart_product` (`product_id`),
  CONSTRAINT `fk_cart_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_cart_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_item`
--

LOCK TABLES `cart_item` WRITE;
/*!40000 ALTER TABLE `cart_item` DISABLE KEYS */;
-- Historical cart_item records omitted from this source backup.
/*!40000 ALTER TABLE `cart_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) NOT NULL,
  `description` text,
  `category_image` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'單卡','各種球星單卡收藏','images/category/single_cards.jpg'),(2,'卡盒','完整卡包盒裝商品','images/category/card_boxes.jpg'),(3,'周邊','卡片收藏相關周邊商品','images/category/accessories.jpg'),(4,'特別商品','限量版和特殊收藏品','images/category/special_items.jpg');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member`
--

DROP TABLE IF EXISTS `member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member` (
  `member_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `address` text,
  `member_level` enum('一般會員','VIP會員','管理員') DEFAULT '一般會員',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `avatar` varchar(255) DEFAULT 'images/images__1_-removebg-preview.png' COMMENT '會員頭像路徑，預設為預設頭像，可選擇購買過的卡包圖片',
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member`
--

LOCK TABLES `member` WRITE;
/*!40000 ALTER TABLE `member` DISABLE KEYS */;
-- Historical member records omitted from this source backup.
/*!40000 ALTER TABLE `member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_activities`
--

DROP TABLE IF EXISTS `member_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_activities` (
  `activity_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `activity_name` varchar(100) NOT NULL,
  `activity_type` enum('簽到','分享','評價','推薦','生日','特殊活動') NOT NULL,
  `points_earned` int DEFAULT '0' COMMENT '獲得積分',
  `participation_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`activity_id`),
  KEY `member_id` (`member_id`),
  CONSTRAINT `member_activities_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_activities`
--

LOCK TABLES `member_activities` WRITE;
/*!40000 ALTER TABLE `member_activities` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_coupons`
--

DROP TABLE IF EXISTS `member_coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_coupons` (
  `coupon_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `coupon_type` enum('折扣券','免運券','生日券','VIP專屬券','積分兌換券') NOT NULL,
  `coupon_name` varchar(100) NOT NULL COMMENT '優惠券名稱',
  `discount_type` enum('percentage','fixed','free_shipping') NOT NULL COMMENT '折扣類型',
  `discount_value` decimal(10,2) NOT NULL COMMENT '折扣值',
  `min_amount` decimal(10,2) DEFAULT '0.00' COMMENT '最低消費金額',
  `is_used` tinyint(1) DEFAULT '0' COMMENT '是否已使用',
  `issued_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '發放日期',
  `expire_date` timestamp NOT NULL COMMENT '過期日期',
  `used_date` timestamp NULL DEFAULT NULL COMMENT '使用日期',
  `order_id` int DEFAULT NULL COMMENT '使用的訂單ID',
  PRIMARY KEY (`coupon_id`),
  KEY `member_id` (`member_id`),
  CONSTRAINT `member_coupons_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_coupons`
--

LOCK TABLES `member_coupons` WRITE;
/*!40000 ALTER TABLE `member_coupons` DISABLE KEYS */;
/*!40000 ALTER TABLE `member_coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_level_config`
--

DROP TABLE IF EXISTS `member_level_config`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_level_config` (
  `level_id` int NOT NULL AUTO_INCREMENT,
  `level_name` varchar(50) NOT NULL COMMENT '等級名稱',
  `min_spent` decimal(10,2) NOT NULL COMMENT '最低消費金額',
  `max_spent` decimal(10,2) DEFAULT NULL COMMENT '最高消費金額',
  `discount_rate` decimal(5,2) DEFAULT '0.00' COMMENT '折扣率（如0.05表示5%折扣）',
  `free_shipping_threshold` decimal(10,2) DEFAULT '1000.00' COMMENT '免運門檻',
  `birthday_discount` decimal(5,2) DEFAULT '0.10' COMMENT '生日折扣率',
  `points_rate` decimal(5,2) DEFAULT '0.01' COMMENT '積分回饋率（每消費1元可得積分）',
  `level_color` varchar(20) DEFAULT '#666666' COMMENT '等級顏色',
  `level_icon` varchar(255) DEFAULT NULL COMMENT '等級圖示',
  PRIMARY KEY (`level_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_level_config`
--

LOCK TABLES `member_level_config` WRITE;
/*!40000 ALTER TABLE `member_level_config` DISABLE KEYS */;
INSERT INTO `member_level_config` VALUES (1,'銅牌會員',0.00,4999.99,0.02,1000.00,0.10,0.01,'#CD7F32','?'),(2,'銀牌會員',5000.00,14999.99,0.05,800.00,0.12,0.02,'#C0C0C0','?'),(3,'金牌會員',15000.00,29999.99,0.08,500.00,0.15,0.02,'#FFD700','?'),(4,'鑽石會員',30000.00,NULL,0.12,0.00,0.20,0.03,'#B9F2FF','?');
/*!40000 ALTER TABLE `member_level_config` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `member_points`
--

DROP TABLE IF EXISTS `member_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `member_points` (
  `member_id` int NOT NULL,
  `total_points` int DEFAULT '0' COMMENT '總積分',
  `available_points` int DEFAULT '0' COMMENT '可用積分',
  `used_points` int DEFAULT '0' COMMENT '已使用積分',
  `total_spent` decimal(10,2) DEFAULT '0.00' COMMENT '累積消費金額',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`member_id`),
  CONSTRAINT `member_points_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `member_points`
--

LOCK TABLES `member_points` WRITE;
/*!40000 ALTER TABLE `member_points` DISABLE KEYS */;
-- Historical member_points records omitted from this source backup.
/*!40000 ALTER TABLE `member_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `message_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int DEFAULT NULL,
  `author_name` varchar(50) NOT NULL,
  `title` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_visible` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`message_id`),
  KEY `fk_messages_member` (`member_id`),
  CONSTRAINT `fk_messages_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
-- Historical messages records omitted from this source backup.
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_details`
--

DROP TABLE IF EXISTS `order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_details` (
  `detail_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int DEFAULT NULL,
  `product_id` int DEFAULT NULL,
  `product_name` varchar(100) DEFAULT NULL,
  `quantity` int DEFAULT NULL,
  `price` int DEFAULT NULL,
  PRIMARY KEY (`detail_id`),
  KEY `order_id` (`order_id`),
  CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_details`
--

LOCK TABLES `order_details` WRITE;
/*!40000 ALTER TABLE `order_details` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_item` (
  `order_id` int NOT NULL,
  `item_sequence` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  PRIMARY KEY (`order_id`,`item_sequence`),
  KEY `fk_orderitem_product` (`product_id`),
  CONSTRAINT `fk_orderitem_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_orderitem_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
-- Historical order_item records omitted from this source backup.
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `shipping_fee` decimal(10,2) DEFAULT '0.00',
  `final_amount` decimal(10,2) NOT NULL,
  `payment_method` enum('信用卡','ATM轉帳','貨到付款') NOT NULL,
  `payment_status` enum('未付款','已付款','已退款') DEFAULT '未付款',
  `order_status` enum('處理中','已出貨','已完成','已取消') DEFAULT '處理中',
  `shipping_name` varchar(50) NOT NULL,
  `shipping_phone` varchar(20) NOT NULL,
  `shipping_address` text NOT NULL,
  `order_note` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  KEY `fk_orders_member` (`member_id`),
  CONSTRAINT `fk_orders_member` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
-- Historical orders records omitted from this source backup.
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `points_history`
--

DROP TABLE IF EXISTS `points_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `points_history` (
  `history_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `points_change` int NOT NULL COMMENT '積分變化（正數為獲得，負數為使用）',
  `transaction_type` enum('消費獲得','積分兌換','生日贈送','註冊贈送','活動贈送','系統調整') NOT NULL,
  `description` varchar(255) NOT NULL COMMENT '變化描述',
  `order_id` int DEFAULT NULL COMMENT '相關訂單ID',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`history_id`),
  KEY `member_id` (`member_id`),
  CONSTRAINT `points_history_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `points_history`
--

LOCK TABLES `points_history` WRITE;
/*!40000 ALTER TABLE `points_history` DISABLE KEYS */;
-- Historical points_history records omitted from this source backup.
/*!40000 ALTER TABLE `points_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `product_id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `product_name` varchar(150) NOT NULL,
  `description` text,
  `price` decimal(10,2) NOT NULL,
  `stock` int NOT NULL DEFAULT '0',
  `main_image` varchar(255) DEFAULT NULL,
  `image_2` varchar(255) DEFAULT NULL,
  `image_3` varchar(255) DEFAULT NULL,
  `image_4` varchar(255) DEFAULT NULL,
  `player_name` varchar(100) DEFAULT NULL,
  `team` varchar(100) DEFAULT NULL,
  `card_year` varchar(50) DEFAULT NULL,
  `card_series` varchar(150) DEFAULT NULL,
  `rarity` enum('一般','稀有','超稀有','傳奇') DEFAULT '一般',
  `is_featured` tinyint(1) DEFAULT '0',
  `card_type` varchar(100) DEFAULT NULL,
  `card_condition` varchar(50) DEFAULT 'Mint',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) DEFAULT '上架',
  PRIMARY KEY (`product_id`),
  KEY `idx_product_category` (`category_id`),
  KEY `idx_product_name` (`product_name`),
  KEY `idx_product_player` (`player_name`),
  KEY `idx_product_rarity` (`rarity`),
  KEY `idx_product_featured` (`is_featured`),
  CONSTRAINT `fk_product_category` FOREIGN KEY (`category_id`) REFERENCES `category` (`category_id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,1,'Yao Ming 經典收藏卡','姚明NBA生涯經典收藏卡片，中國籃球巨星代表作',1500.00,9,'images/card_yao_1.jpg',NULL,NULL,NULL,'Yao Ming','Houston Rockets','2002-03','Topps Chrome','稀有',1,'Rookie Card','Mint','2025-06-05 14:42:49','上架'),(2,1,'Anthony Edwards 新秀卡','Anthony Edwards NBA新秀年度最佳表現紀念卡',1200.00,4,'images/card_edwards_1.jpg',NULL,NULL,NULL,'Anthony Edwards','Minnesota Timberwolves','2020-21','Panini Prizm','稀有',1,'Rookie Card','Mint','2025-06-05 14:42:49','上架'),(3,1,'Devin Booker 高分卡','Devin Booker 70分比賽紀念收藏卡',1300.00,14,'images/card_booker_1.jpg',NULL,NULL,NULL,'Devin Booker','Phoenix Suns','2016-17','Panini Select','稀有',0,'Performance Card','Mint','2025-06-05 14:42:49','上架'),(4,1,'Donovan Mitchell 爵士時期卡','Donovan Mitchell 爵士隊時期經典表現卡',1400.00,12,'images/card_mitchell_1.jpg',NULL,NULL,NULL,'Donovan Mitchell','Utah Jazz','2017-18','Panini Prizm','稀有',0,'Base Card','Mint','2025-06-05 14:42:49','上架'),(5,1,'Giannis Antetokounmpo MVP卡','Giannis MVP年度獲獎紀念限量卡',1800.00,5,'images/card_giannis_1.jpg',NULL,NULL,NULL,'Giannis Antetokounmpo','Milwaukee Bucks','2018-19','Panini National Treasures','超稀有',1,'MVP Card','Mint','2025-06-05 14:42:49','上架'),(6,1,'Jeremy Lin 豪小子經典卡','Jeremy Lin NBA生涯紀念收藏卡',1100.00,20,'images/card_lin_1.jpg',NULL,NULL,NULL,'Jeremy Lin','New York Knicks','2011-12','Topps Chrome','一般',0,'Base Card','Mint','2025-06-05 14:42:49','上架'),(7,1,'Shai Gilgeous-Alexander 明星卡','SGA 全明星級別表現紀念卡',1600.00,9,'images/card_sga_1.jpg',NULL,NULL,NULL,'Shai Gilgeous-Alexander','Oklahoma City Thunder','2021-22','Panini Select','稀有',1,'All-Star Card','Mint','2025-06-05 14:42:49','上架'),(8,1,'Luka Dončić 歐洲之王卡','Luka Dončić 歐洲籃球天才收藏卡',2000.00,5,'images/card_luka_1.jpg',NULL,NULL,NULL,'Luka Dončić','Dallas Mavericks','2018-19','Panini Prizm','超稀有',1,'Rookie Card','Mint','2025-06-05 14:42:49','上架'),(9,2,'Irving 經典卡盒','Kyrie Irving 主題卡包盒，包含多張精美卡片',3500.00,15,'images/box_irving_1.jpg',NULL,NULL,NULL,NULL,NULL,'2021','Irving Collection','稀有',1,'Theme Box','Sealed','2025-06-05 14:42:49','上架'),(11,2,'Curry 三分王卡盒','Stephen Curry 三分紀錄主題卡盒',3800.00,8,'images/box_curry_1.jpg',NULL,NULL,NULL,NULL,NULL,'2022','Three Point King','稀有',1,'Record Box','Sealed','2025-06-05 14:42:49','上架'),(12,2,'WNBA 女籃聯盟卡盒','WNBA 女子籃球聯盟主題卡盒',2800.00,20,'images/box_wnba_1.jpg',NULL,NULL,NULL,NULL,NULL,'2023','WNBA Collection','一般',0,'League Box','Sealed','2025-06-05 14:42:49','上架'),(13,2,'Kobe Bryant 紀念卡盒','Kobe Bryant 傳奇生涯紀念限量卡盒',5500.00,5,'images/box_kobe_1.jpg',NULL,NULL,NULL,NULL,NULL,'2020','Mamba Legacy','傳奇',1,'Memorial Box','Sealed','2025-06-05 14:42:49','上架'),(14,2,'Edwards 新秀卡盒','Anthony Edwards 新秀年主題卡盒',3200.00,10,'images/box_edwards_1.jpg',NULL,NULL,NULL,NULL,NULL,'2021','Rookie Year','稀有',0,'Rookie Box','Sealed','2025-06-05 14:42:49','上架'),(15,2,'Luka Dončić 歐洲之星卡盒','Luka Dončić 歐洲籃球巨星主題卡盒',4800.00,7,'images/box_luka_1.jpg',NULL,NULL,NULL,NULL,NULL,'2019','European Star','超稀有',1,'Star Box','Sealed','2025-06-05 14:42:49','上架'),(16,2,'LeBron James 國王卡盒','LeBron James 籃球之王主題豪華卡盒',6000.00,5,'images/box_lebron_1.jpg',NULL,NULL,NULL,NULL,NULL,'2023','King James','傳奇',1,'Luxury Box','Sealed','2025-06-05 14:42:49','上架'),(17,3,'卡片保護套','高品質透明卡片保護套，100入裝',150.00,50,'images/acc_protector_1.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'一般',0,'Protection','New','2025-06-05 14:42:49','上架'),(18,3,'卡片收納盒','大容量卡片收納整理盒，可放置500張卡片',800.00,20,'images/acc_storage_1.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'一般',0,'Storage','New','2025-06-05 14:42:49','上架'),(19,3,'卡片展示架','壓克力材質卡片展示架，完美展示收藏',1200.00,15,'images/acc_display_1.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'一般',0,'Display','New','2025-06-05 14:42:49','上架'),(20,3,'卡片收納本','專業卡片收納本，皮革封面高級材質',600.00,30,'images/acc_album_1.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'一般',0,'Album','New','2025-06-05 14:42:49','上架'),(21,3,'清潔套件','專業卡片清潔保養套件組',300.00,40,'images/acc_cleaning_1.jpg',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'一般',0,'Cleaning','New','2025-06-05 14:42:49','上架'),(22,4,'詹杜柯巴黎奧運紀念卡','LeBron、Durant、Curry 巴黎奧運金牌紀念限量卡',8800.00,3,'images/special_olympic_1.jpg',NULL,NULL,NULL,'LeBron, Durant, Curry','Team USA','2024','Olympic Gold','傳奇',1,'Olympic Card','Mint','2025-06-05 14:42:49','上架'),(23,4,'King James 40000分豪華紀念卡','LeBron James 40000分里程碑豪華紀念卡',12000.00,2,'images/special_40k_1.jpg',NULL,NULL,NULL,'LeBron James','Los Angeles Lakers','2023','Milestone Series','傳奇',1,'Milestone Card','Mint','2025-06-05 14:42:49','上架'),(24,4,'Curry 親簽紀念卡','Stephen Curry 親筆簽名限量紀念卡',15000.00,1,'images/special_curry_1.jpg',NULL,NULL,NULL,'Stephen Curry','Golden State Warriors','2023','Autograph Series','傳奇',1,'Autograph Card','Mint','2025-06-05 14:42:49','上架'),(25,4,'黑曼巴奪冠紀念卡','Kobe Bryant 總冠軍生涯紀念限量卡',20000.00,0,'images/special_mamba_1.jpg',NULL,NULL,NULL,'Kobe Bryant','Los Angeles Lakers','2010','Championship Legacy','傳奇',1,'Legacy Card','Mint','2025-06-05 14:42:49','上架'),(26,4,'Jordan 傳奇簽名卡','Michael Jordan 傳奇生涯親筆簽名超限量卡',50000.00,2,'images/special_jordan_1.jpg',NULL,NULL,NULL,'Michael Jordan','Chicago Bulls','1996','Legend Autograph','傳奇',1,'Legend Card','Mint','2025-06-05 14:42:49','上架');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `product_rating_stats`
--

DROP TABLE IF EXISTS `product_rating_stats`;
/*!50001 DROP VIEW IF EXISTS `product_rating_stats`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `product_rating_stats` AS SELECT 
 1 AS `product_id`,
 1 AS `product_name`,
 1 AS `total_reviews`,
 1 AS `average_rating`,
 1 AS `five_star_count`,
 1 AS `four_star_count`,
 1 AS `three_star_count`,
 1 AS `two_star_count`,
 1 AS `one_star_count`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `product_reviews`
--

DROP TABLE IF EXISTS `product_reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `member_id` int DEFAULT NULL,
  `member_name` varchar(100) DEFAULT NULL,
  `rating` int NOT NULL,
  `comment` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_verified` tinyint(1) DEFAULT '0',
  `helpful_count` int DEFAULT '0',
  PRIMARY KEY (`review_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_member_id` (`member_id`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `product_reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`product_id`) ON DELETE CASCADE,
  CONSTRAINT `product_reviews_chk_1` CHECK (((`rating` >= 1) and (`rating` <= 5)))
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_reviews`
--

LOCK TABLES `product_reviews` WRITE;
/*!40000 ALTER TABLE `product_reviews` DISABLE KEYS */;
-- Historical product_reviews records omitted from this source backup.
/*!40000 ALTER TABLE `product_reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_likes`
--

DROP TABLE IF EXISTS `review_likes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_likes` (
  `like_id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `member_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`like_id`),
  UNIQUE KEY `unique_member_review` (`review_id`,`member_id`),
  CONSTRAINT `review_likes_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `product_reviews` (`review_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_likes`
--

LOCK TABLES `review_likes` WRITE;
/*!40000 ALTER TABLE `review_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_likes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_replies`
--

DROP TABLE IF EXISTS `review_replies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_replies` (
  `reply_id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `member_id` int DEFAULT NULL,
  `member_name` varchar(100) DEFAULT NULL,
  `reply_content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reply_id`),
  KEY `idx_review_id` (`review_id`),
  KEY `idx_member_id` (`member_id`),
  CONSTRAINT `review_replies_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `product_reviews` (`review_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_replies`
--

LOCK TABLES `review_replies` WRITE;
/*!40000 ALTER TABLE `review_replies` DISABLE KEYS */;
-- Historical review_replies records omitted from this source backup.
/*!40000 ALTER TABLE `review_replies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_settings`
--

DROP TABLE IF EXISTS `site_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_settings` (
  `setting_id` int NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(50) NOT NULL,
  `setting_value` text,
  `description` varchar(200) DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_settings`
--

LOCK TABLES `site_settings` WRITE;
/*!40000 ALTER TABLE `site_settings` DISABLE KEYS */;
-- Historical site_settings records omitted from this source backup.
/*!40000 ALTER TABLE `site_settings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `site_stats`
--

DROP TABLE IF EXISTS `site_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `site_stats` (
  `stat_id` int NOT NULL AUTO_INCREMENT,
  `stat_name` varchar(50) NOT NULL,
  `stat_value` varchar(100) NOT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`stat_id`),
  UNIQUE KEY `stat_name` (`stat_name`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `site_stats`
--

LOCK TABLES `site_stats` WRITE;
/*!40000 ALTER TABLE `site_stats` DISABLE KEYS */;
-- Historical site_stats records omitted from this source backup.
/*!40000 ALTER TABLE `site_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vip_services`
--

DROP TABLE IF EXISTS `vip_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vip_services` (
  `service_id` int NOT NULL AUTO_INCREMENT,
  `member_id` int NOT NULL,
  `service_type` enum('專線客服','新品預購','獨家活動','專屬折扣','免費鑑定') NOT NULL,
  `service_name` varchar(100) NOT NULL,
  `service_description` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`service_id`),
  KEY `member_id` (`member_id`),
  CONSTRAINT `vip_services_ibfk_1` FOREIGN KEY (`member_id`) REFERENCES `member` (`member_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vip_services`
--

LOCK TABLES `vip_services` WRITE;
/*!40000 ALTER TABLE `vip_services` DISABLE KEYS */;
/*!40000 ALTER TABLE `vip_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'nba_db'
--

--
-- Dumping routines for database 'nba_db'
--

--
-- Final view structure for view `product_rating_stats`
--

/*!50001 DROP VIEW IF EXISTS `product_rating_stats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `product_rating_stats` AS select `p`.`product_id` AS `product_id`,`p`.`product_name` AS `product_name`,count(`pr`.`review_id`) AS `total_reviews`,coalesce(avg(`pr`.`rating`),0) AS `average_rating`,count((case when (`pr`.`rating` = 5) then 1 end)) AS `five_star_count`,count((case when (`pr`.`rating` = 4) then 1 end)) AS `four_star_count`,count((case when (`pr`.`rating` = 3) then 1 end)) AS `three_star_count`,count((case when (`pr`.`rating` = 2) then 1 end)) AS `two_star_count`,count((case when (`pr`.`rating` = 1) then 1 end)) AS `one_star_count` from (`product` `p` left join `product_reviews` `pr` on((`p`.`product_id` = `pr`.`product_id`))) group by `p`.`product_id`,`p`.`product_name` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-06-08 20:55:35
