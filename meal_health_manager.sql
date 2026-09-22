-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1:3306
-- Thời gian đã tạo: Th9 22, 2026 lúc 06:57 AM
-- Phiên bản máy phục vụ: 8.4.7
-- Phiên bản PHP: 8.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `meal_health_manager`
--
CREATE DATABASE IF NOT EXISTS `meal_health_manager` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `meal_health_manager`;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ai_generated_meal_plans`
--

DROP TABLE IF EXISTS `ai_generated_meal_plans`;
CREATE TABLE IF NOT EXISTS `ai_generated_meal_plans` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `source_type` enum('theo_mua','theo_muc_tieu','theo_nguyen_lieu') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `goal_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `input_params` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mùa hoặc danh sách nguyên liệu người dùng nhập, tuỳ nguồn',
  `days` tinyint UNSIGNED NOT NULL DEFAULT '1',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'JSON chứa danh sách món/thực đơn từng ngày',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_ai_generated_meal_plans_user` (`user_id`),
  KEY `idx_ai_generated_meal_plans_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chatbot_usage_logs`
--

DROP TABLE IF EXISTS `chatbot_usage_logs`;
CREATE TABLE IF NOT EXISTS `chatbot_usage_logs` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `usage_date` date NOT NULL,
  `request_count` int UNSIGNED NOT NULL DEFAULT '0',
  `total_tokens` int UNSIGNED NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_chatbot_usage_user_date` (`user_id`,`usage_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chat_conversations`
--

DROP TABLE IF EXISTS `chat_conversations`;
CREATE TABLE IF NOT EXISTS `chat_conversations` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'Cuộc trò chuyện mới',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_chat_conversations_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `chat_conversations`
--

INSERT INTO `chat_conversations` (`id`, `user_id`, `title`, `created_at`, `updated_at`) VALUES
(42, 1, 'ssss', '2026-09-20 14:11:16', '2026-09-20 14:11:16'),
(43, 1, 'ssss', '2026-09-20 14:11:18', '2026-09-20 14:11:18'),
(44, 1, 'sss', '2026-09-20 14:11:25', '2026-09-20 14:11:25'),
(45, 1, 'sss', '2026-09-20 14:12:38', '2026-09-20 14:12:38'),
(46, 1, 'ss', '2026-09-20 14:21:06', '2026-09-20 14:21:06'),
(47, 1, 'tôi muốn ăn tối hãy gợi ý cho tôi món ăn phù hợp', '2026-09-20 14:21:38', '2026-09-20 14:21:38'),
(48, 4, 'Tôi nên ăn gì để giảm cân?', '2026-09-22 06:18:40', '2026-09-22 06:18:44');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `chat_messages`
--

DROP TABLE IF EXISTS `chat_messages`;
CREATE TABLE IF NOT EXISTS `chat_messages` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `conversation_id` bigint UNSIGNED NOT NULL,
  `sender` enum('user','assistant','system') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokens_used` int UNSIGNED NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_chat_messages_conversation` (`conversation_id`),
  KEY `idx_chat_messages_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `chat_messages`
--

INSERT INTO `chat_messages` (`id`, `conversation_id`, `sender`, `message`, `tokens_used`, `created_at`) VALUES
(89, 42, 'user', 'ssss', 0, '2026-09-20 14:11:16'),
(90, 42, 'assistant', 'Mình có thể hỗ trợ về calories hôm nay, gợi ý bữa ăn, giảm cân, tăng cân, protein và dinh dưỡng sau tập. Bạn hãy cho mình biết mục tiêu hoặc món ăn cụ thể nhé.', 0, '2026-09-20 14:11:16'),
(91, 43, 'user', 'ssss', 0, '2026-09-20 14:11:18'),
(92, 43, 'assistant', 'Mình có thể hỗ trợ về calories hôm nay, gợi ý bữa ăn, giảm cân, tăng cân, protein và dinh dưỡng sau tập. Bạn hãy cho mình biết mục tiêu hoặc món ăn cụ thể nhé.', 0, '2026-09-20 14:11:18'),
(93, 44, 'user', 'sss', 0, '2026-09-20 14:11:25'),
(94, 44, 'assistant', 'Mình có thể hỗ trợ về calories hôm nay, gợi ý bữa ăn, giảm cân, tăng cân, protein và dinh dưỡng sau tập. Bạn hãy cho mình biết mục tiêu hoặc món ăn cụ thể nhé.', 0, '2026-09-20 14:11:25'),
(95, 45, 'user', 'sss', 0, '2026-09-20 14:12:38'),
(96, 45, 'assistant', 'Chào bạn! Có vẻ bạn đang thử xem mình có ở đây không. Mình là Gemini Dinh Dưỡng, sẵn sàng hỗ trợ bạn về thực đơn, tính toán calories, thói quen ăn uống hoặc bất cứ điều gì liên quan đến sức khỏe.\n\nHôm nay bạn cần mình giúp gì không? Ví dụ như gợi ý món ăn cho buổi tối, giải đáp về thành phần dinh dưỡng hay cách cân bằng macro cho ngày mai chẳng hạn?', 0, '2026-09-20 14:12:40'),
(97, 46, 'user', 'ss', 0, '2026-09-20 14:21:06'),
(98, 46, 'assistant', 'Chào bạn! Có vẻ như bạn đang muốn kiểm tra xem mình có đang hoạt động không, hoặc có thể bạn đang định viết gì đó mà bị ngắt quãng.\n\nHôm nay bạn đã nạp vào khoảng 830 kcal với lượng protein khá tốt (61g). Bạn đang có dự định gì cho bữa tiếp theo không, hay cần mình hỗ trợ tính toán dinh dưỡng, gợi ý món ăn hay giải đáp thắc mắc nào về sức khỏe không?', 0, '2026-09-20 14:21:10'),
(99, 47, 'user', 'tôi muốn ăn tối hãy gợi ý cho tôi món ăn phù hợp', 0, '2026-09-20 14:21:38'),
(100, 47, 'assistant', 'Dựa trên dữ liệu dinh dưỡng hôm nay của bạn (đã nạp 830 kcal, khá giàu đạm và chất béo nhưng lại hơi thiếu chất xơ), mình gợi ý bữa tối nên tập trung vào **rau xanh** để cân bằng hệ tiêu hóa và bổ sung thêm một chút tinh bột phức hợp để ngủ ngon hơn.\n\nDưới đây là 2 gợi ý món ăn cân bằng:\n\n**Lựa chọn 1: Ức gà áp chảo ăn kèm salad trộn dầu giấm**\n*   **Thành phần:** 100g ức gà, 2 bát rau xà lách, dưa chuột, cà chua bi, 1/2 củ hành tây.\n*   **Tinh bột:** 1/2 bắp ngô luộc hoặc 1 lát bánh mì đen nhỏ.\n*   **Lợi ích:** Cung cấp thêm protein nạc, rất nhiều chất xơ và vitamin, ít chất béo, giúp bạn nhẹ bụng trước khi ngủ.\n\n**Lựa chọn 2: Cá hồi (hoặc cá trắng) hấp gừng với bông cải xanh**\n*   **Thành phần:** 100g cá, 150g bông cải xanh (súp lơ) luộc hoặc hấp.\n*   **Tinh bột:** 1/2 bát cơm gạo lứt.\n*   **Lợi ích:** Cá cung cấp Omega-3 tốt cho não bộ và phục hồi cơ thể, bông cải xanh giàu chất xơ giúp no lâu mà không gây tích mỡ.\n\n**Lưu ý nhỏ:**\n*   Vì hôm nay bạn đã nạp 55g chất béo, hãy ưu tiên các món hấp, luộc hoặc áp chảo với rất ít dầu để kiểm soát lượng chất béo tổng thể trong ngày.\n*   Bạn có đang theo chế độ ăn kiêng cụ thể nào (như Low-carb, Eat Clean, hay chay) không, hoặc có thực phẩm nào bạn đặc biệt không thích không để mình điều chỉnh gợi ý phù hợp hơn?', 0, '2026-09-20 14:21:44'),
(101, 48, 'user', 'Tôi nên ăn gì để giảm cân?', 0, '2026-09-22 06:18:40'),
(102, 48, 'assistant', 'Gợi ý nguyên tắc cho bữa ăn giảm cân:\n- 1/2 đĩa là rau củ.\n- 1/4 là đạm nạc như ức gà, cá, trứng hoặc đậu hũ.\n- 1/4 là tinh bột ít tinh chế như gạo lứt hoặc khoai.\n- Ưu tiên nước lọc và theo dõi tổng calories trong nhật ký.', 0, '2026-09-22 06:18:40'),
(103, 48, 'user', 'Hôm nay tôi còn bao nhiêu calories?', 0, '2026-09-22 06:18:44'),
(104, 48, 'assistant', 'Hôm nay bạn đã nạp khoảng **0 kcal**, còn **1815 kcal** so với mục tiêu **1815 kcal**.', 0, '2026-09-22 06:18:44');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `classes`
--

DROP TABLE IF EXISTS `classes`;
CREATE TABLE IF NOT EXISTS `classes` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `class_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `class_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `stt` int UNSIGNED DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_classes_code` (`class_code`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `classes`
--

INSERT INTO `classes` (`id`, `class_code`, `class_name`, `stt`, `created_at`, `updated_at`) VALUES
(1, 'CD24TT1', 'KIểm thử phầm mềm', 1, '2026-08-22 19:10:05', '2026-08-22 19:10:05'),
(3, 'CD24TT2', 'LỚP 2', 2, '2026-08-22 19:40:15', '2026-08-22 19:40:15'),
(4, 'CD24TT3', 'Kiểm Thử', 3, '2026-08-22 19:40:44', '2026-08-22 19:40:44');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `contact_messages`
--

DROP TABLE IF EXISTS `contact_messages`;
CREATE TABLE IF NOT EXISTS `contact_messages` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `full_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `subject` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('new','read','replied') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'new',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_contact_messages_status` (`status`),
  KEY `idx_contact_messages_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `contact_messages`
--

INSERT INTO `contact_messages` (`id`, `full_name`, `email`, `subject`, `message`, `status`, `created_at`) VALUES
(6, 'kim thuyền', 't@gmail.com', 'không có chủ đề', 'hôm nay bạn thế nào', 'read', '2026-09-22 06:20:39');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `favorite_meal_plans`
--

DROP TABLE IF EXISTS `favorite_meal_plans`;
CREATE TABLE IF NOT EXISTS `favorite_meal_plans` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `meal_plan_id` bigint UNSIGNED NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_favorite_user_plan` (`user_id`,`meal_plan_id`),
  KEY `fk_favorite_meal_plans_plan` (`meal_plan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `foods`
--

DROP TABLE IF EXISTS `foods`;
CREATE TABLE IF NOT EXISTS `foods` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id` bigint UNSIGNED DEFAULT NULL,
  `name` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ingredients` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `instructions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `serving_size` decimal(8,2) NOT NULL DEFAULT '100.00',
  `serving_unit` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'g',
  `calories` decimal(8,2) NOT NULL DEFAULT '0.00',
  `protein` decimal(8,2) NOT NULL DEFAULT '0.00',
  `carbs` decimal(8,2) NOT NULL DEFAULT '0.00',
  `fat` decimal(8,2) NOT NULL DEFAULT '0.00',
  `fiber` decimal(8,2) NOT NULL DEFAULT '0.00',
  `sugar` decimal(8,2) NOT NULL DEFAULT '0.00',
  `sodium` decimal(10,2) NOT NULL DEFAULT '0.00',
  `diet_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'normal',
  `season` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mùa phù hợp: xuan,he,thu,dong (phân tách bằng dấu phẩy)',
  `goals` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estimated_price` int DEFAULT '35000',
  `is_premium` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_by` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `fk_foods_created_by` (`created_by`),
  KEY `idx_foods_name` (`name`),
  KEY `idx_foods_category` (`category_id`),
  KEY `idx_foods_status` (`status`),
  KEY `idx_foods_premium` (`is_premium`),
  KEY `idx_foods_season` (`season`)
) ENGINE=InnoDB AUTO_INCREMENT=178 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `foods`
--

INSERT INTO `foods` (`id`, `category_id`, `name`, `slug`, `image`, `description`, `ingredients`, `instructions`, `serving_size`, `serving_unit`, `calories`, `protein`, `carbs`, `fat`, `fiber`, `sugar`, `sodium`, `diet_type`, `season`, `goals`, `estimated_price`, `is_premium`, `status`, `created_by`, `created_at`, `updated_at`) VALUES
(56, 23, 'Phở bò Hà Nội', 'ph-b-o-h-a-ni-1789826630-921', NULL, 'Phở bò tái truyền thống với nước dùng thanh ngọt', 'bánh phở, thịt bò, xương bò, gừng, hành tây, hoa hồi, quế, hành lá', NULL, 1.00, 'bát', 450.00, 25.00, 60.00, 12.00, 3.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(57, 22, 'Cơm gà sốt mật ong', 'cm-g-a-st-mt-ong-1789826630-339', NULL, 'Cơm gạo tấm thơm kèm gà ướp sốt mật ong', 'thịt gà, mật ong, gạo tấm, tỏi, dầu hào, tiêu, dưa leo', NULL, 1.00, 'đĩa', 580.00, 35.00, 70.00, 15.00, 2.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 45000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(58, 24, 'Salad ức gà sốt mè rang', 'salad-c-g-a-st-m-e-rang-1789826630-553', NULL, 'Salad xà lách, cà chua bi, dưa chuột và ức gà', 'ức gà, xà lách, cà chua bi, dưa chuột, mè rang, sốt mè', NULL, 1.00, 'đĩa', 320.00, 32.00, 14.00, 8.00, 4.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 40000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(59, 22, 'Cơm sườn nướng', 'cm-sn-nng-1789826630-671', NULL, 'Cơm trắng ăn kèm sườn heo nướng', 'sườn heo, gạo tấm, sả, tỏi, hành tím, mật ong, mỡ hành', NULL, 1.00, 'đĩa', 620.00, 32.00, 72.00, 22.00, 2.00, 0.00, 0.00, 'normal', 'thu,dong,he', NULL, 45000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(60, 65, 'Bún thịt nướng', 'b-un-tht-nng-1789826630-627', NULL, 'Bún tươi với thịt nướng, rau sống và nước mắm', 'thịt heo, bún tươi, đậu phộng, rau sống, dưa leo, giá đỗ, nước mắm chua ngọt', NULL, 1.00, 'tô', 520.00, 28.00, 62.00, 18.00, 4.00, 0.00, 0.00, 'normal', 'thu,dong,he', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(61, 23, 'Canh chua cá', 'canh-chua-c-a-1789826630-903', NULL, 'Canh chua cá với cà chua, dứa và rau thơm', 'cá, cà chua, dứa, đậu bắp, giá đỗ, me, rau ngò gai, ớt', NULL, 1.00, 'tô', 210.00, 24.00, 16.00, 7.00, 4.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(62, 39, 'Cơm cá kho tộ', 'cm-c-a-kho-t-1789826630-931', NULL, 'Cá kho đậm đà dùng cùng cơm trắng', 'cá lóc, thịt ba chỉ, nước hàng, tiêu xanh, hành tím, ớt, nước mắm', NULL, 1.00, 'đĩa', 560.00, 30.00, 65.00, 18.00, 3.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 45000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(63, 64, 'Gỏi cuốn tôm', 'gi-cun-t-om-1789826630-743', NULL, 'Bánh tráng cuốn tôm, bún và rau sống', 'tôm tươi, thịt heo, bánh tráng, bún tươi, xà lách, rau thơm, hẹ', NULL, 3.00, 'cuốn', 270.00, 20.00, 32.00, 6.00, 4.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(64, 33, 'Bún bò Huế', 'b-un-b-o-hu-1789826630-975', NULL, 'Bún bò cay nhẹ với thịt bò và chả', 'bún tươi, bắp bò, giò heo, chả cua, sả, mắm ruốc, hành tây, hoa chuối', NULL, 1.00, 'tô', 480.00, 28.00, 55.00, 16.00, 3.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(65, 41, 'Cơm chiên trứng', 'cm-chi-en-trng-1789826630-115', NULL, 'Cơm chiên với trứng và rau củ', 'cơm nguội, trứng gà, cà rốt, đậu cô ve, hành lá, tiêu, dầu ăn', NULL, 1.00, 'đĩa', 510.00, 16.00, 68.00, 18.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(66, 68, 'Cháo gà', 'ch-ao-g-a-1789826630-642', NULL, 'Cháo gạo nấu cùng thịt gà xé', 'thịt gà, gạo tẻ, gạo nếp, hành lá, gừng, tía tô, tiêu', NULL, 1.00, 'tô', 290.00, 24.00, 38.00, 6.00, 2.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(67, 67, 'Mì xào bò rau củ', 'm-i-x-ao-b-o-rau-c-1789826630-521', NULL, 'Mì xào bò cùng cải xanh, cà rốt và hành tây', 'mì sợi, thịt bò, cải ngọt, cà rốt, hành tây, tỏi, dầu hào', NULL, 1.00, 'đĩa', 540.00, 29.00, 63.00, 17.00, 5.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(68, 24, 'Salad cá ngừ', 'salad-c-a-ng-1789826630-843', NULL, 'Salad cá ngừ, xà lách, bắp và cà chua', 'cá ngừ ngâm dầu, xà lách, bắp ngọt, cà chua bi, trứng luộc, sốt mayonnaise', NULL, 1.00, 'đĩa', 300.00, 30.00, 18.00, 11.00, 5.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 40000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(69, 59, 'Ức gà áp chảo', 'c-g-a-ap-cho-1789826630-512', NULL, 'Ức gà áp chảo thảo mộc, giàu protein', 'ức gà, dầu ô liu, tỏi, lá hương thảo, muối tiêu, chanh', NULL, 1.00, 'đĩa', 330.00, 42.00, 8.00, 12.00, 2.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(70, 39, 'Cá hồi áp chảo', 'c-a-hi-ap-cho-1789826630-315', NULL, 'Cá hồi áp chảo dùng kèm rau củ', 'cá hồi phi lê, bơ lạt, măng tây, cà rốt, chanh vàng, tiêu đen', NULL, 1.00, 'miếng', 410.00, 34.00, 5.00, 28.00, 1.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(71, 37, 'Bò lúc lắc', 'b-o-l-uc-lc-1789826630-972', NULL, 'Thịt bò áp chảo cùng hành tây và ớt chuông', 'thịt bò thăn, hành tây, ớt chuông, cà chua, tỏi, bơ lạt, dầu hào', NULL, 1.00, 'đĩa', 460.00, 36.00, 20.00, 25.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(72, 58, 'Gà nướng mật ong', 'g-a-nng-mt-ong-1789826630-556', NULL, 'Đùi gà nướng sốt mật ong', 'đùi gà, mật ong, tỏi, sả, dầu hào, tiêu đen, ớt', NULL, 1.00, 'đĩa', 430.00, 38.00, 22.00, 19.00, 2.00, 0.00, 0.00, 'normal', 'thu,dong,he', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(73, 61, 'Thịt heo luộc', 'tht-heo-luc-1789826630-485', NULL, 'Thịt heo luộc mềm dùng cùng rau sống', 'thịt ba chỉ, gừng, hành tím, muối, rau sống, dưa leo', NULL, 1.00, 'đĩa', 390.00, 29.00, 2.00, 29.00, 0.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(74, 42, 'Rau củ luộc', 'rau-c-luc-1789826630-735', NULL, 'Bông cải, cà rốt và đậu que luộc', 'bông cải xanh, cà rốt, đậu que, bắp non, muối', NULL, 1.00, 'đĩa', 120.00, 5.00, 18.00, 3.00, 6.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(75, 43, 'Đậu phụ sốt cà chua', 'du-ph-st-c-a-chua-1789826630-674', NULL, 'Đậu phụ mềm nấu sốt cà chua', 'đậu phụ, cà chua, hành lá, hành tím, nước mắm, tiêu', NULL, 1.00, 'đĩa', 220.00, 14.00, 15.00, 11.00, 4.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(76, 41, 'Trứng cuộn rau củ', 'trng-cun-rau-c-1789826630-865', NULL, 'Trứng cuộn cà rốt, hành lá và nấm', 'trứng gà, cà rốt, nấm mèo, hành lá, tiêu, dầu ăn', NULL, 1.00, 'đĩa', 260.00, 18.00, 10.00, 16.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(77, 23, 'Canh bí đỏ thịt bằm', 'canh-b-i-d-tht-bm-1789826630-451', NULL, 'Canh bí đỏ nấu thịt bằm', 'bí đỏ, thịt heo xay, hành lá, ngò rí, tiêu, hạt nêm', NULL, 1.00, 'tô', 190.00, 15.00, 20.00, 7.00, 4.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(78, 69, 'Súp gà nấm', 's-up-g-a-nm-1789826630-222', NULL, 'Súp gà với nấm và rau củ', 'thịt ức gà, nấm hương, nấm rơm, bắp ngọt, trứng gà, bột năng, ngò rí', NULL, 1.00, 'tô', 240.00, 23.00, 18.00, 8.00, 2.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(79, 67, 'Nui xào bò', 'nui-x-ao-b-o-1789826630-748', NULL, 'Nui xào thịt bò và rau củ', 'nui ống, thịt bò băm, cà rốt, bông cải xanh, hành tây, dầu hào', NULL, 1.00, 'đĩa', 500.00, 30.00, 58.00, 17.00, 4.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(80, 62, 'Cơm thịt kho trứng', 'cm-tht-kho-trng-1789826630-980', NULL, 'Thịt kho trứng đậm đà dùng cùng cơm', 'thịt ba chỉ, trứng vịt, nước dừa tươi, nước mắm, tỏi, ớt', NULL, 1.00, 'đĩa', 650.00, 32.00, 68.00, 27.00, 2.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(81, 65, 'Bún cá', 'b-un-c-a-1789826630-197', NULL, 'Bún cá với rau và nước dùng thanh nhẹ', 'cá phi lê, bún tươi, thì là, cà chua, dọc mùng, hành lá', NULL, 1.00, 'tô', 390.00, 27.00, 50.00, 9.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(82, 66, 'Phở gà', 'ph-g-a-1789826630-139', NULL, 'Phở gà truyền thống với thịt gà xé', 'bánh phở, thịt gà, gừng, hành tây, lá chanh, hành lá, rau mùi', NULL, 1.00, 'bát', 420.00, 30.00, 58.00, 8.00, 3.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 45000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(83, 67, 'Miến gà', 'min-g-a-1789826630-143', NULL, 'Miến nước với thịt gà và rau thơm', 'miến dong, thịt gà, nấm hương, mộc nhĩ, hành lá, rau răm', NULL, 1.00, 'tô', 360.00, 28.00, 45.00, 8.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(84, 68, 'Cháo cá', 'ch-ao-c-a-1789826630-447', NULL, 'Cháo cá mềm nhẹ, dễ tiêu', 'cá hồi phi lê, gạo tẻ, gừng, hành lá, thì là, tiêu', NULL, 1.00, 'tô', 280.00, 23.00, 39.00, 5.00, 2.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(85, 44, 'Cháo yến mạch thịt bằm', 'ch-ao-yn-mch-tht-bm-1789826630-804', NULL, 'Yến mạch nấu cùng thịt bằm và rau củ', 'yến mạch cán dẹt, thịt heo băm, cà rốt, nấm đông cô, hành lá', NULL, 1.00, 'tô', 310.00, 21.00, 38.00, 8.00, 5.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(86, 44, 'Yến mạch sữa chua trái cây', 'yn-mch-sa-chua-tr-ai-c-ay-1789826630-922', NULL, 'Yến mạch, sữa chua và trái cây tươi', 'yến mạch, sữa chua không đường, chuối, dâu tây, việt quất, hạt chia', NULL, 1.00, 'bát', 340.00, 14.00, 45.00, 11.00, 7.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 20000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(87, 26, 'Bánh mì trứng', 'b-anh-m-i-trng-1789826630-610', NULL, 'Bánh mì kèm trứng chiên và rau', 'bánh mì, trứng gà, dưa leo, ngò rí, tương ớt, bơ lạt', NULL, 1.00, 'ổ', 390.00, 17.00, 48.00, 15.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(88, 26, 'Bánh mì ức gà', 'b-anh-m-i-c-g-a-1789826630-160', NULL, 'Bánh mì nguyên cám kèm ức gà và rau', 'bánh mì nguyên cám, ức gà áp chảo, xà lách, cà chua, dưa leo, sốt mè', NULL, 1.00, 'ổ', 410.00, 31.00, 45.00, 12.00, 4.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(89, 26, 'Xôi gà', 'x-oi-g-a-1789826630-284', NULL, 'Xôi nếp ăn kèm thịt gà xé', 'gạo nếp, thịt gà xé, hành phi, mỡ gà, dưa chuột muối', NULL, 1.00, 'phần', 520.00, 27.00, 67.00, 16.00, 2.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(90, 65, 'Bún riêu cua', 'b-un-ri-eu-cua-1789826630-801', NULL, 'Bún riêu cua với cà chua và rau sống', 'bún tươi, cua đồng, cà chua, đậu phụ chiên, giấm bỗng, hành lá, rau sống', NULL, 1.00, 'tô', 430.00, 25.00, 55.00, 13.00, 4.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 45000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(91, 32, 'Bún chả Hà Nội', 'b-un-ch-h-a-ni-1789826630-678', NULL, 'Bún với chả nướng, rau sống và nước mắm', 'thịt ba chỉ, thịt băm, bún tươi, đu đủ xanh, cà rốt, nước mắm, tỏi, ớt', NULL, 1.00, 'phần', 560.00, 30.00, 58.00, 23.00, 4.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 45000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(92, 26, 'Bánh cuốn thịt', 'b-anh-cun-tht-1789826630-294', NULL, 'Bánh cuốn mềm với thịt bằm và hành phi', 'bột gạo, thịt heo băm, mộc nhĩ, hành tím phi, chả lụa, giá đỗ, rau thơm', NULL, 1.00, 'đĩa', 380.00, 20.00, 52.00, 10.00, 2.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(93, 34, 'Bánh xèo tôm thịt', 'b-anh-x-eo-t-om-tht-1789826630-411', NULL, 'Bánh xèo giòn với tôm, thịt và giá', 'bột bánh xèo, tôm tươi, thịt ba chỉ, giá đỗ, xà lách, rau cải, nước mắm chua ngọt', NULL, 1.00, 'cái', 520.00, 24.00, 48.00, 25.00, 4.00, 0.00, 0.00, 'normal', 'thu,dong,he', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(94, 34, 'Cá lóc nướng trui', 'c-a-l-oc-nng-trui-1789826630-998', NULL, 'Cá lóc nướng thơm, dùng cùng rau sống', 'cá lóc đồng, rơm nướng, bánh tráng, bún tươi, chuối chát, khế chua, mắm nêm', NULL, 1.00, 'con', 430.00, 42.00, 5.00, 25.00, 1.00, 0.00, 0.00, 'normal', 'thu,dong,he', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(95, 40, 'Tôm hấp sả', 't-om-hp-s-1789826630-125', NULL, 'Tôm hấp sả giữ vị ngọt tự nhiên', 'tôm sú, sả cây, lá chanh, muối tiêu chanh, ớt', NULL, 1.00, 'đĩa', 220.00, 42.00, 3.00, 4.00, 1.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(96, 40, 'Tôm rang me', 't-om-rang-me-1789826630-263', NULL, 'Tôm rang sốt me chua ngọt', 'tôm sú, nước cốt me, tỏi, ớt, đường, nước mắm, hành lá', NULL, 1.00, 'đĩa', 330.00, 32.00, 22.00, 12.00, 2.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(97, 35, 'Mực hấp gừng', 'mc-hp-gng-1789826630-669', NULL, 'Mực hấp gừng thơm nhẹ', 'mực nang tươi, gừng tươi, ớt sừng, sả cây, hành lá, muối ớt chanh', NULL, 1.00, 'đĩa', 250.00, 34.00, 5.00, 9.00, 1.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(98, 35, 'Cua hấp', 'cua-hp-1789826630-577', NULL, 'Cua hấp giữ vị ngọt tự nhiên', 'cua biển tươi, gừng, sả, bia, muối tiêu chanh', NULL, 1.00, 'con', 280.00, 38.00, 2.00, 12.00, 0.00, 0.00, 0.00, 'normal', 'thu,dong,he', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(99, 39, 'Cá basa kho tiêu', 'c-a-basa-kho-ti-eu-1789826630-415', NULL, 'Cá basa kho tiêu đậm vị', 'cá basa phi lê, tiêu đen, tỏi, ớt hiểm, nước màu dừa, nước mắm', NULL, 1.00, 'đĩa', 360.00, 31.00, 12.00, 20.00, 2.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(100, 39, 'Cá thu sốt cà', 'c-a-thu-st-c-a-1789826630-628', NULL, 'Cá thu nấu sốt cà chua', 'cá thu tươi, cà chua, hành tây, hành lá, thì là, ớt', NULL, 1.00, 'đĩa', 390.00, 33.00, 14.00, 21.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(101, 60, 'Gà hấp hành', 'g-a-hp-h-anh-1789826630-252', NULL, 'Gà hấp hành mềm thơm, ít dầu', 'thịt gà ta, hành hoa, gừng tươi, tiêu sọ, muối lá chanh', NULL, 1.00, 'đĩa', 370.00, 39.00, 4.00, 22.00, 1.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(102, 63, 'Gà xào sả ớt', 'g-a-x-ao-s-t-1789826630-647', NULL, 'Thịt gà xào sả ớt thơm cay', 'thịt gà, sả băm, ớt sừng, tỏi, nghệ tươi, nước mắm', NULL, 1.00, 'đĩa', 430.00, 37.00, 12.00, 24.00, 2.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(103, 63, 'Bò xào bông cải', 'b-o-x-ao-b-ong-ci-1789826630-930', NULL, 'Bò xào bông cải xanh giàu chất xơ', 'thịt bò thăn, bông cải xanh, tỏi băm, dầu hào, tiêu', NULL, 1.00, 'đĩa', 410.00, 35.00, 18.00, 21.00, 5.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(104, 57, 'Bò hầm rau củ', 'b-o-hm-rau-c-1789826630-580', NULL, 'Bò hầm mềm cùng cà rốt và khoai tây', 'thịt bò nạm, cà rốt, khoai tây, cà chua, hành tây, quế, hoa hồi', NULL, 1.00, 'tô', 450.00, 34.00, 25.00, 20.00, 5.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(105, 58, 'Heo nướng sả', 'heo-nng-s-1789826630-220', NULL, 'Thịt heo nướng sả thơm', 'thịt heo nạc, sả băm, tỏi, mật ong, dầu màu điều, tiêu', NULL, 1.00, 'đĩa', 440.00, 31.00, 10.00, 28.00, 2.00, 0.00, 0.00, 'normal', 'thu,dong,he', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(106, 63, 'Thịt heo xào cải chua', 'tht-heo-x-ao-ci-chua-1789826630-537', NULL, 'Thịt heo xào dưa cải chua', 'thịt ba chỉ, dưa cải chua, tỏi, ớt, hành tím, nước mắm', NULL, 1.00, 'đĩa', 420.00, 27.00, 12.00, 27.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(107, 30, 'Đậu phụ hấp nấm', 'du-ph-hp-nm-1789826630-355', NULL, 'Đậu phụ hấp cùng nấm và hành', 'đậu phụ non, nấm đông cô, nấm kim châm, hành lá, dầu mè, nước tương', NULL, 1.00, 'đĩa', 210.00, 16.00, 13.00, 11.00, 5.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(108, 30, 'Nấm xào rau củ', 'nm-x-ao-rau-c-1789826630-226', NULL, 'Nấm xào cùng bông cải và cà rốt', 'nấm đùi gà, nấm rơm, bông cải xanh, cà rốt, ớt chuông, tỏi', NULL, 1.00, 'đĩa', 180.00, 7.00, 20.00, 8.00, 7.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(109, 73, 'Cơm gạo lứt rau củ', 'cm-go-lt-rau-c-1789826630-244', NULL, 'Cơm gạo lứt kết hợp nhiều loại rau củ', 'gạo lứt đỏ, đậu Hà Lan, cà rốt, bắp ngọt, nấm hương', NULL, 1.00, 'đĩa', 360.00, 10.00, 55.00, 10.00, 8.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(110, 48, 'Cơm gạo lứt ức gà', 'cm-go-lt-c-g-a-1789826630-478', NULL, 'Gạo lứt và ức gà giàu protein', 'gạo lứt, ức gà luộc, bông cải xanh, trứng gà luộc, mè đen', NULL, 1.00, 'đĩa', 430.00, 38.00, 42.00, 12.00, 6.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(111, 24, 'Salad bơ trứng', 'salad-b-trng-1789826630-673', NULL, 'Bơ, trứng và rau xanh tươi', 'trái bơ sáp, trứng gà luộc, xà lách romaine, cà chua bi, dầu ô liu', NULL, 1.00, 'đĩa', 350.00, 14.00, 16.00, 25.00, 7.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(112, 24, 'Salad tôm bơ', 'salad-t-om-b-1789826630-119', NULL, 'Tôm, bơ và rau xanh trộn nhẹ', 'tôm sú luộc, trái bơ, xà lách, dưa leo, sốt chanh leo, mè rang', NULL, 1.00, 'đĩa', 330.00, 28.00, 15.00, 18.00, 6.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(113, 24, 'Salad cá hồi', 'salad-c-a-hi-1789826630-565', NULL, 'Cá hồi cùng rau xanh và cà chua', 'cá hồi xông khói, xà lách, cà chua bi, hành tây tím, sốt mù tạt mật ong', NULL, 1.00, 'đĩa', 390.00, 30.00, 13.00, 23.00, 5.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(114, 29, 'Khoai lang nướng', 'khoai-lang-nng-1789826630-889', NULL, 'Khoai lang nướng thơm, giàu chất xơ', 'khoai lang mật, mật ong, dầu ô liu, muối biển', NULL, 1.00, 'củ', 180.00, 3.00, 41.00, 1.00, 6.00, 0.00, 0.00, 'normal', 'thu,dong,he', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(115, 29, 'Bắp luộc', 'bp-luc-1789826630-759', NULL, 'Bắp luộc ngọt tự nhiên', 'bắp nếp ngọt, muối loãng', NULL, 1.00, 'trái', 150.00, 5.00, 32.00, 2.00, 4.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(116, 29, 'Trứng luộc', 'trng-luc-1789826630-935', NULL, 'Trứng luộc đơn giản, giàu protein', 'trứng gà ta, muối tiêu, chanh', NULL, 2.00, 'quả', 140.00, 12.00, 1.00, 10.00, 0.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(117, 25, 'Sữa chua trái cây', 'sa-chua-tr-ai-c-ay-1789826630-318', NULL, 'Sữa chua kết hợp trái cây tươi', 'sữa chua Hy Lạp, kiwi, xoài chín, táo xanh, hạt hạnh nhân', NULL, 1.00, 'ly', 180.00, 7.00, 28.00, 5.00, 3.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 20000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(118, 70, 'Sinh tố chuối', 'sinh-t-chui-1789826630-648', NULL, 'Sinh tố chuối xay cùng sữa', 'chuối chín, sữa tươi không đường, mật ong, đá viên', NULL, 1.00, 'ly', 220.00, 6.00, 38.00, 6.00, 4.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 20000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(119, 70, 'Sinh tố bơ', 'sinh-t-b-1789826630-219', NULL, 'Sinh tố bơ béo thơm', 'trái bơ sáp, sữa tươi, sữa đặc, đá viên', NULL, 1.00, 'ly', 280.00, 6.00, 25.00, 18.00, 7.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 20000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(120, 70, 'Sinh tố xoài', 'sinh-t-xo-ai-1789826630-943', NULL, 'Sinh tố xoài tươi mát', 'xoài cát chín, sữa chua, sữa tươi, đá viên', NULL, 1.00, 'ly', 210.00, 4.00, 43.00, 3.00, 4.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 20000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(121, 70, 'Nước ép cam', 'nc-ep-cam-1789826630-226', NULL, 'Nước ép cam giàu vitamin C', 'cam sành tươi, mật ong, đá viên', NULL, 1.00, 'ly', 120.00, 2.00, 27.00, 0.00, 1.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 20000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(122, 70, 'Nước ép cà rốt', 'nc-ep-c-a-rt-1789826630-733', NULL, 'Nước ép cà rốt tươi', 'cà rốt tươi, táo đỏ, gừng, đá viên', NULL, 1.00, 'ly', 110.00, 2.00, 25.00, 0.00, 3.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 20000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(123, 25, 'Chè đậu đỏ', 'ch-e-du-d-1789826630-263', NULL, 'Chè đậu đỏ ngọt nhẹ', 'đậu đỏ, đường phèn, nước cốt dừa, lá dứa', NULL, 1.00, 'ly', 260.00, 8.00, 48.00, 4.00, 7.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 20000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(124, 25, 'Chè hạt sen', 'ch-e-ht-sen-1789826630-723', NULL, 'Chè hạt sen thanh nhẹ', 'hạt sen tươi, đường phèn, lá dứa, táo đỏ', NULL, 1.00, 'ly', 230.00, 7.00, 40.00, 5.00, 4.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 20000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(125, 25, 'Trái cây thập cẩm', 'tr-ai-c-ay-thp-cm-1789826630-538', NULL, 'Đĩa trái cây tươi nhiều màu sắc', 'dưa hấu, xoài, thanh long, nho, dâu tây, muối ớt', NULL, 1.00, 'đĩa', 150.00, 2.00, 34.00, 1.00, 5.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(126, 71, 'Bánh chuối yến mạch', 'b-anh-chui-yn-mch-1789826630-682', NULL, 'Bánh chuối kết hợp yến mạch', 'chuối chín, bột yến mạch, trứng gà, mật ong, bột quế', NULL, 1.00, 'miếng', 240.00, 7.00, 35.00, 8.00, 4.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 20000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(127, 71, 'Bánh mì nguyên cám', 'b-anh-m-i-nguy-en-c-am-1789826630-511', NULL, 'Bánh mì nguyên cám giàu chất xơ', 'bột mì nguyên cám, men nở, mật ong, dầu ô liu, muối', NULL, 2.00, 'lát', 160.00, 7.00, 27.00, 3.00, 5.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(128, 30, 'Đậu hũ non sốt nấm', 'du-h-u-non-st-nm-1789826630-915', NULL, 'Đậu hũ non sốt nấm thanh nhẹ', 'đậu hũ non, nấm đùi gà, nấm hương, hành lá, dầu hào chay, tiêu', NULL, 1.00, 'đĩa', 190.00, 15.00, 10.00, 10.00, 4.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(129, 30, 'Cà ri rau củ', 'c-a-ri-rau-c-1789826630-745', NULL, 'Cà ri rau củ nấu nước cốt dừa', 'khoai tây, cà rốt, đậu cô ve, nước cốt dừa, bột cà ri, sả', NULL, 1.00, 'tô', 300.00, 8.00, 35.00, 13.00, 7.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(130, 23, 'Canh rau ngót thịt bằm', 'canh-rau-ng-ot-tht-bm-1789826630-630', NULL, 'Canh rau ngót nấu thịt bằm', 'rau ngót tươi, thịt heo nạc băm, hành tím, tiêu, muối', NULL, 1.00, 'tô', 170.00, 15.00, 10.00, 7.00, 4.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(131, 23, 'Canh cải thịt bằm', 'canh-ci-tht-bm-1789826630-192', NULL, 'Canh cải xanh nấu thịt bằm', 'cải bẹ xanh, thịt heo nạc băm, gừng tươi, hành lá, hạt nêm', NULL, 1.00, 'tô', 160.00, 14.00, 8.00, 7.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(132, 23, 'Canh rong biển đậu phụ', 'canh-rong-bin-du-ph-1789826630-408', NULL, 'Canh rong biển với đậu phụ', 'rong biển khô, đậu phụ non, thịt bò băm, tỏi phi, dầu mè', NULL, 1.00, 'tô', 130.00, 10.00, 8.00, 6.00, 3.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(133, 69, 'Súp bí đỏ', 's-up-b-i-d-1789826630-465', NULL, 'Súp bí đỏ xay mịn', 'bí đỏ hồ lô, kem tươi (whipping cream), bơ lạt, hành tây, sữa tươi', NULL, 1.00, 'tô', 180.00, 5.00, 27.00, 6.00, 5.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(134, 69, 'Súp hải sản', 's-up-hi-sn-1789826630-502', NULL, 'Súp hải sản với tôm, mực và rau củ', 'tôm sú, mực ống, thanh cua, bắp ngọt, nấm tuyết, trứng gà, ngò rí', NULL, 1.00, 'tô', 260.00, 25.00, 18.00, 9.00, 2.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(135, 67, 'Mì udon bò', 'm-i-udon-b-o-1789826630-622', NULL, 'Mì udon nước dùng bò và rau', 'mì udon Nhật, thịt bò lát mỏng, nấm kim châm, cải thìa, hành boa-rô', NULL, 1.00, 'tô', 470.00, 27.00, 61.00, 13.00, 3.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(136, 67, 'Mì trộn gà', 'm-i-trn-g-a-1789826630-860', NULL, 'Mì trộn thịt gà và rau xanh', 'mì trứng, thịt ức gà, cải ngọt, dưa leo, sốt tương tỏi mè', NULL, 1.00, 'tô', 450.00, 29.00, 54.00, 14.00, 4.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(137, 67, 'Nui nấu rau củ', 'nui-nu-rau-c-1789826630-124', NULL, 'Nui nấu cùng rau củ', 'nui xoắn, sườn heo, cà rốt, khoai tây, nấm rơm, hành lá', NULL, 1.00, 'tô', 300.00, 9.00, 47.00, 8.00, 6.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(138, 64, 'Cơm cuộn rong biển', 'cm-cun-rong-bin-1789826630-765', NULL, 'Cơm cuộn rong biển với trứng và rau', 'cơm dẻo, lá rong biển gim, trứng chiên, cà rốt, dưa leo, xúc xích', NULL, 1.00, 'cuộn', 390.00, 15.00, 55.00, 12.00, 4.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(139, 64, 'Kimbap gà', 'kimbap-g-a-1789826630-125', NULL, 'Kimbap nhân gà, trứng và rau củ', 'cơm dẻo, lá rong biển, thịt gà xé, trứng cuộn, dưa leo, cà rốt', NULL, 1.00, 'cuộn', 430.00, 24.00, 55.00, 13.00, 5.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(140, 24, 'Gỏi gà bắp cải', 'gi-g-a-bp-ci-1789826630-248', NULL, 'Gỏi gà xé với bắp cải và cà rốt', 'thịt ức gà, bắp cải trắng, bắp cải tím, cà rốt, rau răm, đậu phộng, nước mắm tỏi ớt', NULL, 1.00, 'đĩa', 290.00, 29.00, 16.00, 12.00, 6.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(141, 24, 'Gỏi đu đủ tôm', 'gi-du-d-t-om-1789826630-597', NULL, 'Gỏi đu đủ xanh với tôm', 'đu đủ xanh bào sợi, tôm sú luộc, đậu phộng rang, rau húng lủi, nước mắm chua ngọt', NULL, 1.00, 'đĩa', 250.00, 24.00, 20.00, 8.00, 5.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(142, 42, 'Rau muống xào tỏi', 'rau-mung-x-ao-ti-1789826630-242', NULL, 'Rau muống xào tỏi đơn giản', 'rau muống non, tỏi ta băm, dầu ăn, nước mắm, ớt tươi', NULL, 1.00, 'đĩa', 140.00, 5.00, 12.00, 7.00, 5.00, 0.00, 0.00, 'normal', 'he,xuan', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(143, 42, 'Bông cải xào nấm', 'b-ong-ci-x-ao-nm-1789826630-565', NULL, 'Bông cải xanh xào nấm', 'bông cải xanh, bông cải trắng, nấm rơm, cà rốt, tỏi băm, dầu hào', NULL, 1.00, 'đĩa', 160.00, 7.00, 15.00, 8.00, 6.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(144, 42, 'Đậu que xào trứng', 'du-que-x-ao-trng-1789826630-792', NULL, 'Đậu que xào cùng trứng', 'đậu que non, trứng gà ta, tỏi băm, tiêu đen, dầu ăn', NULL, 1.00, 'đĩa', 210.00, 11.00, 14.00, 12.00, 5.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(145, 29, 'Khoai tây nghiền', 'khoai-t-ay-nghin-1789826630-591', NULL, 'Khoai tây nghiền mềm mịn', 'khoai tây vàng, bơ lạt, sữa tươi không đường, muối, tiêu trắng', NULL, 1.00, 'phần', 220.00, 5.00, 34.00, 8.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(146, 50, 'Ức gà luộc rau củ', 'c-g-a-luc-rau-c-1789826630-107', NULL, 'Ức gà luộc kèm rau củ hấp', 'ức gà phi lê, bông cải xanh, cà rốt, bắp ngọt, muối tiêu chanh', NULL, 1.00, 'đĩa', 300.00, 40.00, 15.00, 9.00, 6.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(147, 60, 'Cá hấp gừng', 'c-a-hp-gng-1789826630-644', NULL, 'Cá hấp gừng thanh nhẹ', 'cá chẽm phi lê, gừng tươi sợi, hành lá, thì là, ớt sừng, nước tương', NULL, 1.00, 'đĩa', 320.00, 38.00, 5.00, 15.00, 2.00, 0.00, 0.00, 'normal', 'dong,thu,xuan', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(148, 63, 'Tôm xào rau củ', 't-om-x-ao-rau-c-1789826630-249', NULL, 'Tôm xào cùng ớt chuông và bông cải', 'tôm sú bóc vỏ, ớt chuông đỏ vàng, bông cải xanh, hành tây, tỏi, dầu hào', NULL, 1.00, 'đĩa', 300.00, 30.00, 18.00, 10.00, 5.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(149, 50, 'Gà xé trộn rau', 'g-a-x-e-trn-rau-1789826630-400', NULL, 'Ức gà xé trộn rau củ tươi', 'ức gà luộc xé sợi, xà lách, dưa leo, cà chua, hành tây, sốt dầu giấm', NULL, 1.00, 'đĩa', 280.00, 38.00, 12.00, 9.00, 6.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(150, 46, 'Bò cuộn nấm', 'b-o-cun-nm-1789826630-657', NULL, 'Thịt bò cuộn nấm áp chảo', 'thịt ba chỉ bò Mỹ, nấm kim châm, hành tây, tỏi băm, sốt tiêu đen', NULL, 1.00, 'đĩa', 380.00, 34.00, 10.00, 23.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(151, 46, 'Cá hồi nướng rau củ', 'c-a-hi-nng-rau-c-1789826630-479', NULL, 'Cá hồi nướng dùng cùng rau củ', 'cá hồi phi lê, măng tây, cà rốt baby, khoai tây, bơ tỏi, chanh vàng', NULL, 1.00, 'đĩa', 460.00, 37.00, 18.00, 25.00, 6.00, 0.00, 0.00, 'normal', 'thu,dong,he', NULL, 65000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(152, 60, 'Trứng hấp', 'trng-hp-1789826630-797', NULL, 'Trứng hấp mềm mịn, dễ ăn', 'trứng gà ta, nấm hương, thịt băm, hành lá, nước tương, dầu mè', NULL, 1.00, 'chén', 180.00, 15.00, 4.00, 11.00, 1.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(153, 30, 'Đậu phụ chiên áp chảo', 'du-ph-chi-en-ap-cho-1789826630-331', NULL, 'Đậu phụ áp chảo ít dầu', 'đậu phụ miếng, dầu ô liu, hành lá, nước tương tỏi ớt', NULL, 1.00, 'đĩa', 240.00, 17.00, 9.00, 15.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 25000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-20 12:19:04'),
(154, 30, 'Cơm chay rau củ', 'cm-chay-rau-c-1789826630-165', NULL, 'Cơm chay kết hợp rau củ và nấm', 'cơm trắng dẻo, nấm đông cô, cà rốt, đậu que, ngô ngọt, hạt sen', NULL, 1.00, 'đĩa', 380.00, 12.00, 60.00, 10.00, 7.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(155, 30, 'Bún chay', 'b-un-chay-1789826630-698', NULL, 'Bún chay với đậu phụ, nấm và rau', 'bún tươi, đậu phụ chiên, nấm rơm, nấm đùi gà, chả chay, cà rốt, ngò gai', NULL, 1.00, 'tô', 320.00, 12.00, 48.00, 8.00, 6.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', NULL, '2026-09-19 14:03:50', '2026-09-19 18:07:40'),
(156, 26, 'mì tương cà', 'm-i-tng-c-a-1790058322', '/uploads/foods/1790058322_061fe630e5cd9de2.jpg', 'Mì trộn tương cà là món ăn nhanh gọn, có vị chua ngọt dễ ăn, kết hợp từ mì tôm hoặc mì Ý cùng sốt tương cà', '2 đến 3 muỗng canh tương cà1 quả trứng gàTỏi băm, hành lá, dầu ăn, đường và một ít tiêu xay', 'Đun sôi khoảng 400ml nước, cho vắt mì vào luộc trong 2-3 phút cho vừa chín tới.Vớt mì ra, xả nhanh qua nước lạnh để sợi mì dai rồi để ráo', 500.00, 'gram', 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:22', '2026-09-22 06:25:22'),
(157, 22, 'Cơm gà nướng mật ong', 'cm-g-a-nng-mt-ong-1790058352-611', NULL, 'Cơm gạo tám dẻo thơm kèm đùi gà ướp sốt mật ong nướng vàng giòn', 'Gạo tám, đùi gà góc tư, mật ong nguyên chất, dầu hào, nước tương, tỏi, ớt, dưa leo, cà chua', '1. Ướp gà với mật ong, dầu hào, tỏi băm 30 phút.\\n2. Nướng chín vàng hai mặt ở nhiệt độ 180°C.\\n3. Ăn kèm cơm nóng, dưa leo và nước sốt.', 1.00, 'đĩa', 580.00, 35.00, 70.00, 15.00, 2.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:52', '2026-09-22 06:25:52'),
(158, 74, 'Bánh tráng nướng', 'b-anh-tr-ang-nng-1790058352-219', NULL, 'Bánh tráng nướng giòn rụm phủ trứng, hành, bò khô và sốt me chua ngọt', 'Bánh tráng, trứng gà, hành lá, bò khô, đậu phộng rang, sốt me, ớt bột', '1. Phết trứng lên bánh tráng rồi nướng trên bếp than hoặc máy nướng.\\n2. Rắc hành lá, bò khô, đậu phộng lên trên.\\n3. Thêm sốt me và ớt bột theo khẩu vị rồi cuộn lại ăn nóng.', 1.00, 'cái', 280.00, 6.00, 45.00, 8.00, 2.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:52', '2026-09-22 06:25:52'),
(159, 74, 'Bánh mì nướng muối ớt', 'b-anh-m-i-nng-mui-t-1790058353-254', NULL, 'Bánh mì nướng giòn tan với bơ, pate, muối ớt và chà bông thơm lừng', 'Bánh mì, bơ, pate, muối ớt, chà bông, tương ớt, dưa leo', '1. Cắt bánh mì theo chiều dài, phết bơ và pate.\\n2. Nướng trên than hoặc lò đến khi vàng giòn.\\n3. Rắc muối ớt, chà bông và thêm tương ớt, dưa leo khi ăn.', 1.00, 'cái', 320.00, 8.00, 48.00, 10.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(160, 74, 'Khoai tây chiên', 'khoai-t-ay-chi-en-1790058353-762', NULL, 'Khoai tây chiên vàng giòn rụm, ăn kèm sốt mayonnaise hoặc tương cà', 'Khoai tây, dầu ăn, muối, bột chiên giòn, tương cà, mayonnaise', '1. Gọt vỏ khoai, cắt que và ngâm nước lạnh 15 phút.\\n2. Để ráo, lăn bột chiên rồi chiên ngập dầu đến vàng giòn.\\n3. Vớt ra, rắc muối và ăn kèm sốt.', 1.00, 'phần', 350.00, 4.00, 45.00, 18.00, 4.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(161, 74, 'Bắp xào bơ', 'bp-x-ao-b-1790058353-794', NULL, 'Bắp ngọt xào bơ thơm béo, thêm hành lá và tép khô đậm đà', 'Bắp ngọt, bơ, hành lá, tép khô, nước mắm, đường, tiêu', '1. Tách hạt bắp hoặc dùng bắp cắt khúc.\\n2. Phi bơ với tép khô, cho bắp vào xào nhanh.\\n3. Nêm nước mắm, đường, tiêu và rắc hành lá trước khi tắt bếp.', 1.00, 'phần', 290.00, 7.00, 38.00, 12.00, 5.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(162, 74, 'Trứng cút lộn', 'trng-c-ut-ln-1790058353-630', NULL, 'Trứng cút lộn luộc chín, ăn kèm muối tiêu chanh và rau răm', 'Trứng cút lộn, muối, tiêu, chanh, rau răm, gừng', '1. Luộc trứng cút lộn khoảng 8-10 phút với gừng.\\n2. Bóc vỏ, chấm muối tiêu chanh.\\n3. Ăn kèm rau răm tươi.', 5.00, 'quả', 180.00, 14.00, 2.00, 12.00, 0.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(163, 74, 'Nem rán (Chả giò)', 'nem-r-an-ch-gi-o-1790058353-720', NULL, 'Nem rán giòn rụm nhân thịt heo, tôm, mộc nhĩ và rau củ', 'Bánh tráng, thịt heo xay, tôm, mộc nhĩ, cà rốt, hành tây, trứng, dầu ăn', '1. Trộn nhân thịt, tôm, mộc nhĩ, cà rốt, hành tây với trứng.\\n2. Cuốn chặt bằng bánh tráng.\\n3. Chiên ngập dầu đến vàng giòn, để ráo dầu và chấm nước mắm chua ngọt.', 4.00, 'cái', 320.00, 12.00, 28.00, 18.00, 2.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(164, 74, 'Bánh tráng trộn', 'b-anh-tr-ang-trn-1790058353-718', NULL, 'Bánh tráng cắt sợi trộn với bò khô, trứng cút, rau răm và sốt me', 'Bánh tráng, bò khô, trứng cút, rau răm, đậu phộng, sốt me, ớt', '1. Cắt bánh tráng thành sợi nhỏ.\\n2. Trộn với bò khô, trứng cút luộc, rau răm, đậu phộng.\\n3. Chan sốt me và ớt rồi trộn đều trước khi ăn.', 1.00, 'phần', 250.00, 8.00, 35.00, 8.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(165, 74, 'Khoai lang chiên', 'khoai-lang-chi-en-1790058353-569', NULL, 'Khoai lang chiên vàng giòn bên ngoài, bùi mềm bên trong', 'Khoai lang, dầu ăn, đường, muối', '1. Gọt vỏ khoai lang, cắt khoanh hoặc que.\\n2. Chiên ngập dầu đến vàng đều hai mặt.\\n3. Vớt ra, rắc chút đường hoặc muối tùy khẩu vị.', 1.00, 'phần', 280.00, 3.00, 48.00, 9.00, 5.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(166, 74, 'Xôi chiên phồng', 'x-oi-chi-en-phng-1790058353-424', NULL, 'Xôi nếp chiên phồng giòn rụm, ăn kèm chà bông và tương ớt', 'Gạo nếp, dầu ăn, chà bông, tương ớt, hành phi', '1. Nấu xôi nếp chín dẻo, để nguội và nén thành khối.\\n2. Cắt miếng vừa ăn rồi chiên ngập dầu đến phồng vàng.\\n3. Rắc chà bông, hành phi và chấm tương ớt.', 1.00, 'phần', 380.00, 8.00, 55.00, 14.00, 2.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(167, 74, 'Bánh bột lọc', 'b-anh-bt-lc-1790058353-621', NULL, 'Bánh bột lọc trong veo nhân tôm thịt, chấm nước mắm chua ngọt', 'Bột năng, tôm, thịt heo, hành lá, nước mắm, đường, tỏi, ớt', '1. Nhồi bột năng với nước nóng tạo bột dẻo.\\n2. Gói nhân tôm thịt vào bột rồi hấp chín.\\n3. Rắc hành lá và chấm nước mắm pha chua ngọt.', 6.00, 'cái', 220.00, 6.00, 40.00, 4.00, 1.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(168, 74, 'Gỏi cuốn tôm thịt', 'gi-cun-t-om-tht-1790058353-313', NULL, 'Gỏi cuốn tươi mát với tôm, thịt, bún và rau sống, chấm mắm nêm hoặc tương', 'Bánh tráng, tôm, thịt heo luộc, bún tươi, xà lách, húng quế, giá đỗ', '1. Luộc tôm và thịt, chuẩn bị bún và rau sống.\\n2. Trải bánh tráng, xếp nguyên liệu rồi cuốn chặt.\\n3. Chấm với mắm nêm hoặc tương đậu phộng.', 2.00, 'cuốn', 180.00, 12.00, 22.00, 5.00, 2.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(169, 74, 'Bánh rán đường', 'b-anh-r-an-dng-1790058353-137', NULL, 'Bánh rán nhân đậu xanh hoặc không nhân, phủ đường trắng giòn ngọt', 'Bột mì, đậu xanh, đường, men, dầu ăn', '1. Nhào bột với men, ủ nở rồi chia viên.\\n2. Chiên ngập dầu đến vàng đều.\\n3. Lăn qua đường trắng khi còn nóng.', 3.00, 'cái', 260.00, 4.00, 42.00, 9.00, 1.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(170, 74, 'Đậu phộng rang muối', 'du-phng-rang-mui-1790058353-394', NULL, 'Đậu phộng rang muối thơm bùi, giòn tan, món nhắm hoặc ăn vặt phổ biến', 'Đậu phộng, muối, dầu ăn', '1. Rửa sạch đậu phộng, để ráo.\\n2. Rang trên chảo với chút dầu và muối đến vàng thơm.\\n3. Để nguội rồi bảo quản trong hộp kín.', 1.00, 'gói', 160.00, 7.00, 6.00, 13.00, 2.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(171, 74, 'Mực khô nướng', 'mc-kh-o-nng-1790058353-222', NULL, 'Mực khô nướng thơm lừng, giòn dai, chấm tương ớt hoặc mayonnaise', 'Mực khô, tương ớt, mayonnaise, chanh', '1. Nướng mực khô trên than hoặc lò đến khi phồng và thơm.\\n2. Vỗ nhẹ cho giòn.\\n3. Ăn kèm tương ớt hoặc mayonnaise pha chanh.', 1.00, 'con', 150.00, 22.00, 3.00, 5.00, 0.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(172, 74, 'Bánh xèo mini', 'b-anh-x-eo-mini-1790058353-212', NULL, 'Bánh xèo giòn tan nhân tôm thịt, giá đỗ, ăn kèm rau sống và nước mắm', 'Bột bánh xèo, tôm, thịt heo, giá đỗ, hành lá, dầu ăn, rau sống', '1. Pha bột bánh xèo loãng.\\n2. Đổ bột vào chảo nóng, thêm nhân tôm thịt giá rồi đậy nắp.\\n3. Gập đôi khi vàng giòn, ăn kèm rau sống và nước mắm chua ngọt.', 2.00, 'cái', 300.00, 10.00, 35.00, 14.00, 3.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(173, 74, 'Chè đậu xanh', 'ch-e-du-xanh-1790058353-641', NULL, 'Chè đậu xanh bùi ngọt thanh mát, thêm nước cốt dừa béo ngậy', 'Đậu xanh, đường, nước cốt dừa, bột báng, lá dứa', '1. Ngâm đậu xanh, nấu chín nhừ với lá dứa.\\n2. Thêm đường và bột báng nấu đến sệt.\\n3. Múc ra ly, chan nước cốt dừa và thưởng thức nóng hoặc lạnh.', 1.00, 'ly', 220.00, 6.00, 42.00, 3.00, 4.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(174, 74, 'Bánh flan caramel', 'b-anh-flan-caramel-1790058353-139', NULL, 'Bánh flan mềm mịn, vị caramel đắng nhẹ, món tráng miệng ngọt ngào', 'Trứng gà, sữa tươi, đường, vani', '1. Nấu caramel đường đến vàng nâu rồi đổ vào khuôn.\\n2. Đánh trứng với sữa và đường, lọc rồi đổ vào khuôn.\\n3. Hấp cách thủy khoảng 30-40 phút đến khi đông.', 1.00, 'cái', 190.00, 6.00, 28.00, 6.00, 0.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(175, 74, 'Há cảo chiên', 'h-a-co-chi-en-1790058353-471', NULL, 'Há cảo chiên giòn vàng nhân tôm thịt thơm ngon, chấm nước tương', 'Vỏ há cảo, tôm, thịt heo xay, hành lá, gừng, nước tương', '1. Trộn nhân tôm thịt với hành và gừng.\\n2. Gói vào vỏ há cảo.\\n3. Chiên ngập dầu đến vàng giòn, chấm nước tương pha.', 4.00, 'cái', 280.00, 11.00, 32.00, 12.00, 2.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(176, 74, 'Bánh căn', 'b-anh-can-1790058353-646', NULL, 'Bánh căn nhỏ xinh từ miền Trung, nhân trứng hoặc tôm, chấm nước mắm', 'Bột gạo, trứng cút, tôm, hành lá, nước mắm, đậu xanh', '1. Pha bột gạo loãng, đổ vào khuôn bánh căn nóng.\\n2. Thêm trứng cút hoặc tôm, đậy nắp nướng chín.\\n3. Ăn kèm nước mắm chua ngọt và đậu xanh xay.', 6.00, 'cái', 240.00, 8.00, 28.00, 10.00, 1.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53'),
(177, 74, 'Sữa chua mít', 'sa-chua-m-it-1790058353-892', NULL, 'Sữa chua mát lạnh kết hợp mít thơm ngọt, món ăn vặt giải nhiệt', 'Sữa chua, mít chín, sữa đặc, đá', '1. Cắt mít thành miếng nhỏ.\\n2. Cho sữa chua vào hộp, thêm mít và sữa đặc.\\n3. Trộn đều hoặc để nguyên lớp, thưởng thức lạnh.', 1.00, 'hộp', 170.00, 5.00, 28.00, 4.00, 2.00, 0.00, 0.00, 'normal', 'xuan,he,thu,dong', NULL, 35000, 0, 'active', 3, '2026-09-22 06:25:53', '2026-09-22 06:25:53');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `food_categories`
--

DROP TABLE IF EXISTS `food_categories`;
CREATE TABLE IF NOT EXISTS `food_categories` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `status` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_food_categories_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `food_categories`
--

INSERT INTO `food_categories` (`id`, `name`, `slug`, `description`, `status`, `created_at`, `updated_at`) VALUES
(22, 'Món Cơm', 'mon-com', 'Các món cơm dinh dưỡng dùng trong bữa ăn hằng ngày', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(23, 'Món Nước & Canh', 'mon-nuoc-canh', 'Các món bún, phở, mì và canh thanh mát', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(24, 'Món Salad & Healthy', 'mon-salad-healthy', 'Salad rau củ quả và các món ăn ít calo', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(25, 'Tráng Miệng & Sinh Tố', 'trang-mieng-sinh-to', 'Trái cây tươi, sinh tố và đồ ngọt bổ dưỡng', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(26, 'Món Ăn Sáng', 'mon-an-sang', 'Các món ăn giàu năng lượng phù hợp cho bữa sáng', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(27, 'Món Ăn Trưa', 'mon-an-trua', 'Các món ăn cân bằng dinh dưỡng cho bữa trưa', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(28, 'Món Ăn Tối', 'mon-an-toi', 'Các món ăn nhẹ nhàng và đầy đủ dinh dưỡng cho bữa tối', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(29, 'Món Ăn Vặt', 'mon-an-vat', 'Các món ăn nhẹ dùng giữa các bữa chính', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(30, 'Món Chay', 'mon-chay', 'Các món ăn chay từ rau củ, đậu và ngũ cốc', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(31, 'Món Thuần Việt', 'mon-thuan-viet', 'Các món ăn truyền thống quen thuộc của Việt Nam', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(32, 'Món Miền Bắc', 'mon-mien-bac', 'Các món ăn đặc trưng của khu vực miền Bắc', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(33, 'Món Miền Trung', 'mon-mien-trung', 'Các món ăn đặc trưng của khu vực miền Trung', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(34, 'Món Miền Nam', 'mon-mien-nam', 'Các món ăn đặc trưng của khu vực miền Nam', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(35, 'Món Hải Sản', 'mon-hai-san', 'Các món ăn chế biến từ cá, tôm, cua và hải sản', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(36, 'Món Gà', 'mon-ga', 'Các món ăn giàu đạm được chế biến từ thịt gà', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(37, 'Món Bò', 'mon-bo', 'Các món ăn chế biến từ thịt bò giàu protein', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(38, 'Món Heo', 'mon-heo', 'Các món ăn chế biến từ thịt heo phổ biến', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(39, 'Món Cá', 'mon-ca', 'Các món ăn từ cá giàu protein và chất béo tốt', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(40, 'Món Tôm', 'mon-tom', 'Các món ăn chế biến từ tôm giàu protein', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(41, 'Món Trứng', 'mon-trung', 'Các món ăn đơn giản và giàu protein từ trứng', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(42, 'Món Rau Củ', 'mon-rau-cu', 'Các món ăn từ rau củ giàu chất xơ và vitamin', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(43, 'Món Đậu & Đậu Phụ', 'mon-dau-dau-phu', 'Các món ăn từ đậu, đậu phụ và thực phẩm thực vật', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(44, 'Món Ngũ Cốc', 'mon-ngu-coc', 'Các món ăn sử dụng gạo, yến mạch, ngũ cốc và hạt', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(45, 'Món Ít Calo', 'mon-it-calo', 'Các món ăn kiểm soát năng lượng phù hợp với chế độ ăn nhẹ', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(46, 'Món Giàu Protein', 'mon-giau-protein', 'Các món ăn có hàm lượng protein cao hỗ trợ xây dựng cơ bắp', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(47, 'Món Giàu Chất Xơ', 'mon-giau-chat-xo', 'Các món giàu chất xơ hỗ trợ tiêu hóa và sức khỏe đường ruột', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(48, 'Món Low Carb', 'mon-low-carb', 'Các món hạn chế carbohydrate phù hợp với chế độ ăn low carb', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(49, 'Món Tăng Cân', 'mon-tang-can', 'Các món giàu năng lượng hỗ trợ tăng cân lành mạnh', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(50, 'Món Giảm Cân', 'mon-giam-can', 'Các món kiểm soát calo hỗ trợ chế độ giảm cân', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(51, 'Món Cho Người Tập Gym', 'mon-cho-nguoi-tap-gym', 'Các món giàu protein và dinh dưỡng phù hợp người tập luyện', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(52, 'Món Ăn Trước Khi Tập', 'mon-an-truoc-khi-tap', 'Các món cung cấp năng lượng phù hợp trước khi tập luyện', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(53, 'Món Ăn Sau Khi Tập', 'mon-an-sau-khi-tap', 'Các món giàu protein và dinh dưỡng hỗ trợ phục hồi sau tập', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(54, 'Món Cho Trẻ Em', 'mon-cho-tre-em', 'Các món dễ ăn và cung cấp dinh dưỡng phù hợp cho trẻ', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(55, 'Món Cho Người Lớn Tuổi', 'mon-cho-nguoi-lon-tuoi', 'Các món mềm, dễ tiêu và cân bằng dinh dưỡng', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(56, 'Món Ăn Gia Đình', 'mon-an-gia-dinh', 'Các món dễ chế biến phù hợp cho bữa cơm gia đình', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(57, 'Món Một Nồi', 'mon-mot-noi', 'Các món có thể chế biến đơn giản trong một nồi', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(58, 'Món Nướng', 'mon-nuong', 'Các món được chế biến bằng phương pháp nướng thơm ngon', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(59, 'Món Áp Chảo', 'mon-ap-chao', 'Các món chế biến nhanh bằng phương pháp áp chảo', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(60, 'Món Hấp', 'mon-hap', 'Các món hấp giữ được hương vị và giá trị dinh dưỡng', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(61, 'Món Luộc', 'mon-luoc', 'Các món luộc đơn giản, ít dầu mỡ và dễ chế biến', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(62, 'Món Kho', 'mon-kho', 'Các món kho đậm đà phù hợp với bữa cơm Việt', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(63, 'Món Xào', 'mon-xao', 'Các món xào kết hợp thịt, hải sản và rau củ', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(64, 'Món Cuốn', 'mon-cuon', 'Các món cuốn kết hợp rau, thịt và nguyên liệu tươi', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(65, 'Món Bún', 'mon-bun', 'Các món bún đa dạng từ bún nước đến bún trộn', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(66, 'Món Phở', 'mon-pho', 'Các món phở truyền thống và các biến tấu dinh dưỡng', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(67, 'Món Mì & Nui', 'mon-mi-nui', 'Các món mì, nui dễ chế biến cho nhiều bữa ăn', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(68, 'Món Cháo', 'mon-chao', 'Các món cháo mềm, dễ tiêu và phù hợp nhiều đối tượng', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(69, 'Món Súp', 'mon-sup', 'Các món súp nóng, nhẹ bụng và giàu dinh dưỡng', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(70, 'Sinh Tố & Nước Ép', 'sinh-to-nuoc-ep', 'Các loại sinh tố và nước ép từ rau củ quả tươi', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(71, 'Bánh & Đồ Ăn Nhẹ', 'banh-do-an-nhe', 'Các loại bánh và món ăn nhẹ phù hợp dùng trong ngày', 'active', '2026-09-19 13:56:45', '2026-09-19 13:56:45'),
(72, 'Bánh & Đồ Ăn Nhẹ.', 'banh-do-an-nhe-1', NULL, 'active', '2026-09-19 13:59:36', '2026-09-19 13:59:36'),
(73, 'Món Healthy', 'm-on-healthy', NULL, 'active', '2026-09-19 14:03:50', '2026-09-19 14:03:50'),
(74, 'Ăn vặt', 'an-vt', NULL, 'active', '2026-09-22 06:25:52', '2026-09-22 06:25:52');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `food_goals`
--

DROP TABLE IF EXISTS `food_goals`;
CREATE TABLE IF NOT EXISTS `food_goals` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `food_id` bigint UNSIGNED NOT NULL,
  `goal_type` enum('lose_weight','gain_weight','maintain_weight','gain_muscle','cooling','warming','vegetarian') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'cooling = thanh mát, warming = giữ ấm',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_food_goal` (`food_id`,`goal_type`),
  KEY `idx_food_goals_goal` (`goal_type`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `food_ingredients`
--

DROP TABLE IF EXISTS `food_ingredients`;
CREATE TABLE IF NOT EXISTS `food_ingredients` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `food_id` bigint UNSIGNED NOT NULL,
  `ingredient_id` bigint UNSIGNED NOT NULL,
  `quantity` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Số lượng gợi ý, ví dụ: 200g, 2 quả',
  `is_optional` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Nguyên liệu có thể bỏ qua/thay thế mà vẫn ra món',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_food_ingredient` (`food_id`,`ingredient_id`),
  KEY `idx_food_ingredients_ingredient` (`ingredient_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `health_hourly_logs`
--

DROP TABLE IF EXISTS `health_hourly_logs`;
CREATE TABLE IF NOT EXISTS `health_hourly_logs` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `log_date` date NOT NULL,
  `log_hour` tinyint UNSIGNED NOT NULL,
  `water_ml` int UNSIGNED NOT NULL DEFAULT '0',
  `steps` int UNSIGNED NOT NULL DEFAULT '0',
  `active_minutes` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `calories_burned` decimal(8,2) UNSIGNED NOT NULL DEFAULT '0.00',
  `heart_rate` smallint UNSIGNED DEFAULT NULL,
  `sleep_minutes` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `mood_level` tinyint UNSIGNED DEFAULT NULL,
  `note` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_health_hourly_user_date_hour` (`user_id`,`log_date`,`log_hour`),
  KEY `idx_health_hourly_user_date` (`user_id`,`log_date`)
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `ingredients`
--

DROP TABLE IF EXISTS `ingredients`;
CREATE TABLE IF NOT EXISTS `ingredients` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(140) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `idx_ingredients_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `meal_logs`
--

DROP TABLE IF EXISTS `meal_logs`;
CREATE TABLE IF NOT EXISTS `meal_logs` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `log_date` date NOT NULL,
  `meal_type` enum('breakfast','morning_snack','lunch','afternoon_snack','dinner','evening_snack') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `consumed_at` time DEFAULT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_meal_logs_user_date_type` (`user_id`,`log_date`,`meal_type`),
  KEY `idx_meal_logs_user_date` (`user_id`,`log_date`),
  KEY `idx_meal_logs_date` (`log_date`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `meal_logs`
--

INSERT INTO `meal_logs` (`id`, `user_id`, `log_date`, `meal_type`, `consumed_at`, `note`, `created_at`, `updated_at`) VALUES
(7, 1, '2026-09-20', 'lunch', '20:33:25', NULL, '2026-09-20 13:33:25', '2026-09-20 13:33:25'),
(8, 3, '2026-09-21', 'dinner', '20:43:21', NULL, '2026-09-21 13:43:21', '2026-09-21 13:43:21'),
(9, 3, '2026-09-22', 'lunch', '13:02:51', NULL, '2026-09-22 06:02:51', '2026-09-22 06:02:51');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `meal_log_items`
--

DROP TABLE IF EXISTS `meal_log_items`;
CREATE TABLE IF NOT EXISTS `meal_log_items` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `meal_log_id` bigint UNSIGNED NOT NULL,
  `food_id` bigint UNSIGNED NOT NULL,
  `quantity` decimal(10,2) NOT NULL DEFAULT '1.00',
  `unit` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'g',
  `calculated_grams` decimal(10,2) NOT NULL DEFAULT '0.00',
  `calories` decimal(10,2) NOT NULL DEFAULT '0.00',
  `protein` decimal(10,2) NOT NULL DEFAULT '0.00',
  `carbs` decimal(10,2) NOT NULL DEFAULT '0.00',
  `fat` decimal(10,2) NOT NULL DEFAULT '0.00',
  `fiber` decimal(10,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_meal_log_items_log` (`meal_log_id`),
  KEY `idx_meal_log_items_food` (`food_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `meal_log_items`
--

INSERT INTO `meal_log_items` (`id`, `meal_log_id`, `food_id`, `quantity`, `unit`, `calculated_grams`, `calories`, `protein`, `carbs`, `fat`, `fiber`, `created_at`, `updated_at`) VALUES
(17, 7, 106, 1.00, 'đĩa', 1.00, 420.00, 27.00, 12.00, 27.00, 3.00, '2026-09-20 13:49:44', '2026-09-20 13:49:44'),
(19, 7, 70, 1.00, 'miếng', 1.00, 410.00, 34.00, 5.00, 28.00, 1.00, '2026-09-20 13:49:46', '2026-09-20 13:49:46'),
(20, 8, 139, 1.00, 'cuộn', 1.00, 430.00, 24.00, 55.00, 13.00, 5.00, '2026-09-21 13:43:21', '2026-09-21 13:43:21'),
(21, 9, 64, 1.00, 'tô', 1.00, 480.00, 28.00, 55.00, 16.00, 3.00, '2026-09-22 06:02:51', '2026-09-22 06:02:51');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `meal_plans`
--

DROP TABLE IF EXISTS `meal_plans`;
CREATE TABLE IF NOT EXISTS `meal_plans` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `goal_type` enum('lose_weight','gain_weight','maintain_weight','gain_muscle') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `diet_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'normal',
  `total_calories` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_protein` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_carbs` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_fat` decimal(10,2) NOT NULL DEFAULT '0.00',
  `total_fiber` decimal(10,2) NOT NULL DEFAULT '0.00',
  `image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_premium` tinyint(1) NOT NULL DEFAULT '0',
  `status` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_by` bigint UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `slug` (`slug`),
  KEY `fk_meal_plans_created_by` (`created_by`),
  KEY `idx_meal_plans_goal` (`goal_type`),
  KEY `idx_meal_plans_status` (`status`),
  KEY `idx_meal_plans_premium` (`is_premium`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `meal_plans`
--

INSERT INTO `meal_plans` (`id`, `name`, `slug`, `description`, `goal_type`, `diet_type`, `total_calories`, `total_protein`, `total_carbs`, `total_fat`, `total_fiber`, `image`, `is_premium`, `status`, `created_by`, `created_at`, `updated_at`) VALUES
(3, 'giảm cân', 'gim-c-an', 'ấu trúc chuẩn khớp hoàn toàn với mẫu cũ của bạn (bao gồm đầy đủ các cột: STT, Tên Món Ăn, Tên Danh Mục, Khẩu Phần, Đơn Vị, Dinh dưỡn', 'lose_weight', 'healthy', 0.00, 0.00, 0.00, 0.00, 0.00, NULL, 0, 'active', 3, '2026-09-22 06:26:43', '2026-09-22 06:26:43');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `meal_plan_items`
--

DROP TABLE IF EXISTS `meal_plan_items`;
CREATE TABLE IF NOT EXISTS `meal_plan_items` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `meal_plan_meal_id` bigint UNSIGNED NOT NULL,
  `food_id` bigint UNSIGNED NOT NULL,
  `quantity` decimal(10,2) NOT NULL DEFAULT '1.00',
  `unit` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'g',
  `calculated_grams` decimal(10,2) NOT NULL DEFAULT '0.00',
  `calories` decimal(10,2) NOT NULL DEFAULT '0.00',
  `protein` decimal(10,2) NOT NULL DEFAULT '0.00',
  `carbs` decimal(10,2) NOT NULL DEFAULT '0.00',
  `fat` decimal(10,2) NOT NULL DEFAULT '0.00',
  `fiber` decimal(10,2) NOT NULL DEFAULT '0.00',
  `sort_order` int UNSIGNED NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_meal_plan_items_meal` (`meal_plan_meal_id`),
  KEY `idx_meal_plan_items_food` (`food_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `meal_plan_meals`
--

DROP TABLE IF EXISTS `meal_plan_meals`;
CREATE TABLE IF NOT EXISTS `meal_plan_meals` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `meal_plan_id` bigint UNSIGNED NOT NULL,
  `meal_type` enum('breakfast','morning_snack','lunch','afternoon_snack','dinner','evening_snack') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `time_frame` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sort_order` int UNSIGNED NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_meal_plan_meals_plan` (`meal_plan_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `mystery_box_history`
--

DROP TABLE IF EXISTS `mystery_box_history`;
CREATE TABLE IF NOT EXISTS `mystery_box_history` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `session_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `food_id` bigint UNSIGNED NOT NULL,
  `meal_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `health_goal` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `budget` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `spin_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_date` (`user_id`,`spin_date`),
  KEY `idx_session_date` (`session_id`,`spin_date`),
  KEY `fk_mystery_box_food` (`food_id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `mystery_box_history`
--

INSERT INTO `mystery_box_history` (`id`, `user_id`, `session_id`, `food_id`, `meal_type`, `health_goal`, `budget`, `spin_date`, `created_at`) VALUES
(1, NULL, 'a8ec958d57ad4efff26e32bbca2b42a7', 98, 'lunch', 'muscle_gain', '30k_50k', '2026-09-20', '2026-09-20 12:20:27'),
(2, 3, '3j8ui9lgeihovs52siakqkuguk', 93, 'lunch', 'all', 'all', '2026-09-20', '2026-09-20 12:25:02'),
(3, 3, '3j8ui9lgeihovs52siakqkuguk', 147, 'lunch', 'all', 'all', '2026-09-20', '2026-09-20 12:25:08'),
(4, 3, '3j8ui9lgeihovs52siakqkuguk', 76, 'snack', 'all', 'all', '2026-09-20', '2026-09-20 12:25:17'),
(5, 1, '52774996307ca6e10cd729ef646a529a', 77, 'lunch', 'weight_loss', NULL, '2026-09-20', '2026-09-20 12:27:53'),
(6, NULL, 'pt65l9doohskpursidd13r7qng', 147, 'lunch', 'all', NULL, '2026-09-20', '2026-09-20 12:33:28'),
(7, NULL, 'pt65l9doohskpursidd13r7qng', 112, 'lunch', 'all', NULL, '2026-09-20', '2026-09-20 12:33:39'),
(8, NULL, 'o87kjle61ttfr3et8iecfg6fbs', 81, 'dinner', 'eat_clean', NULL, '2026-09-20', '2026-09-20 12:36:26'),
(9, NULL, 'pt65l9doohskpursidd13r7qng', 80, 'lunch', 'all', NULL, '2026-09-20', '2026-09-20 13:32:04'),
(10, 112, '2rgr9v8rhmo1gogf6bhhbfjvgs', 89, 'lunch', 'all', NULL, '2026-09-20', '2026-09-20 13:33:21'),
(11, NULL, 'e0g88qa6i243imcdgqiqqscn96', 79, 'lunch', 'all', NULL, '2026-09-20', '2026-09-20 13:35:58'),
(12, 112, '2rgr9v8rhmo1gogf6bhhbfjvgs', 138, 'lunch', 'all', NULL, '2026-09-20', '2026-09-20 13:36:12'),
(13, 112, '2rgr9v8rhmo1gogf6bhhbfjvgs', 70, 'lunch', 'all', NULL, '2026-09-20', '2026-09-20 13:38:27'),
(14, NULL, 'e0g88qa6i243imcdgqiqqscn96', 60, 'dinner', 'all', NULL, '2026-09-20', '2026-09-20 13:46:25'),
(15, 112, '2rgr9v8rhmo1gogf6bhhbfjvgs', 88, 'lunch', 'all', NULL, '2026-09-20', '2026-09-20 13:46:38'),
(16, 112, '2rgr9v8rhmo1gogf6bhhbfjvgs', 106, 'lunch', 'all', NULL, '2026-09-20', '2026-09-20 13:46:43'),
(17, 112, '2rgr9v8rhmo1gogf6bhhbfjvgs', 95, 'dinner', 'all', NULL, '2026-09-20', '2026-09-20 13:57:44'),
(18, 112, '2rgr9v8rhmo1gogf6bhhbfjvgs', 83, 'dinner', 'all', NULL, '2026-09-20', '2026-09-20 13:58:02'),
(19, 112, '2rgr9v8rhmo1gogf6bhhbfjvgs', 65, 'dinner', 'all', NULL, '2026-09-20', '2026-09-20 13:58:25'),
(20, 112, '2rgr9v8rhmo1gogf6bhhbfjvgs', 67, 'dinner', 'weight_gain', NULL, '2026-09-20', '2026-09-20 13:58:40'),
(21, 112, '2rgr9v8rhmo1gogf6bhhbfjvgs', 92, 'dinner', 'all', NULL, '2026-09-20', '2026-09-20 14:05:09'),
(22, NULL, 'vpjik37hdjjnnk1nirincubnlu', 92, 'dinner', 'all', NULL, '2026-09-20', '2026-09-20 15:05:35'),
(23, NULL, 'bcvnasb95h3lk72bjn7f985dg3', 84, 'dinner', 'all', NULL, '2026-09-21', '2026-09-21 13:41:56'),
(24, NULL, 'bcvnasb95h3lk72bjn7f985dg3', 69, 'dinner', 'all', NULL, '2026-09-21', '2026-09-21 13:42:51'),
(25, NULL, 'bcvnasb95h3lk72bjn7f985dg3', 119, 'dinner', 'all', NULL, '2026-09-21', '2026-09-21 13:43:01'),
(26, 3, 'd0ks86fhenp7rhihi3od7bjs10', 139, 'dinner', 'all', NULL, '2026-09-21', '2026-09-21 13:43:18'),
(27, NULL, 'a76got9g1rellk1e0pc3qk5bju', 148, 'afternoon_snack', 'all', NULL, '2026-09-22', '2026-09-22 05:59:30'),
(28, NULL, 'a76got9g1rellk1e0pc3qk5bju', 90, 'dinner', 'all', NULL, '2026-09-22', '2026-09-22 05:59:37'),
(29, NULL, 'a76got9g1rellk1e0pc3qk5bju', 154, 'lunch', 'all', NULL, '2026-09-22', '2026-09-22 05:59:50'),
(30, NULL, 'a76got9g1rellk1e0pc3qk5bju', 58, 'lunch', 'all', NULL, '2026-09-22', '2026-09-22 05:59:57'),
(31, 3, 'mo6vismpn0k3kecitj0mn9bl8n', 64, 'lunch', 'all', NULL, '2026-09-22', '2026-09-22 06:02:46'),
(32, NULL, 'qmqtbo2cketn9agvjv2qo3h390', 66, 'dinner', 'all', NULL, '2026-09-22', '2026-09-22 06:13:38'),
(33, NULL, 'qmqtbo2cketn9agvjv2qo3h390', 73, 'lunch', 'all', NULL, '2026-09-22', '2026-09-22 06:14:00');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `notifications`
--

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `title` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` enum('info','success','warning','danger') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'info',
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_notifications_user_read` (`user_id`,`is_read`),
  KEY `idx_notifications_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `type`, `is_read`, `created_at`) VALUES
(47, 3, '🎉 Hoàn thành Thực đơn AI (Ngày 1)', 'Chúc mừng! Bạn đã hoàn thành xuất sắc thực đơn dinh dưỡng của ngày 1. Hãy tiếp tục duy trì thói quen ăn uống lành mạnh này nhé!', 'success', 1, '2026-09-22 06:02:18'),
(48, 1, '💬 Tin nhắn mới từ user', '[UID:4] tôi muốn báo lỗi trang web', 'info', 0, '2026-09-22 06:18:57'),
(49, 3, '💬 Tin nhắn mới từ user', '[UID:4] tôi muốn báo lỗi trang web', 'info', 1, '2026-09-22 06:18:57'),
(50, 4, '🎉 Hoàn thành Thực đơn AI (Ngày 1)', 'Chúc mừng! Bạn đã hoàn thành xuất sắc thực đơn dinh dưỡng của ngày 1. Hãy tiếp tục duy trì thói quen ăn uống lành mạnh này nhé!', 'success', 1, '2026-09-22 06:19:27'),
(51, 1, '📩 Thư liên hệ mới: không có chủ đề', '[MID:6] [Từ kim thuyền (t@gmail.com)]: hôm nay bạn thế nào', 'info', 0, '2026-09-22 06:20:39'),
(52, 3, '📩 Thư liên hệ mới: không có chủ đề', '[MID:6] [Từ kim thuyền (t@gmail.com)]: hôm nay bạn thế nào', 'info', 1, '2026-09-22 06:20:39'),
(53, 4, '💬 Phản hồi từ Ban quản trị', 'xin chào chạo', 'info', 0, '2026-09-22 06:21:51'),
(54, 4, '💬 Phản hồi từ Ban quản trị', 'xui lòng nên rõ yêu cầu', 'info', 0, '2026-09-22 06:22:03');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `password_resets`
--

DROP TABLE IF EXISTS `password_resets`;
CREATE TABLE IF NOT EXISTS `password_resets` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `email` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `expires_at` datetime NOT NULL,
  `used_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `idx_password_resets_email` (`email`),
  KEY `idx_password_resets_expires_at` (`expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `password_resets`
--

INSERT INTO `password_resets` (`id`, `email`, `token`, `expires_at`, `used_at`, `created_at`) VALUES
(1, 'anh2482006@gmail.com', '5bddaf85181b613665ce7ad0f71c82cba3f86e73cd5bd7c9cc4c2885a9139506', '2026-09-19 23:36:32', NULL, '2026-09-19 16:06:32');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `personal_notes`
--

DROP TABLE IF EXISTS `personal_notes`;
CREATE TABLE IF NOT EXISTS `personal_notes` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `note_date` date NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `mood` enum('very_bad','bad','normal','good','very_good') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'normal',
  `hunger_level` tinyint UNSIGNED DEFAULT NULL,
  `exercise_status` enum('none','light','moderate','hard') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'none',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_personal_notes_user_date` (`user_id`,`note_date`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `personal_notes`
--

INSERT INTO `personal_notes` (`id`, `user_id`, `note_date`, `content`, `mood`, `hunger_level`, `exercise_status`, `created_at`, `updated_at`) VALUES
(6, 4, '2026-09-22', 'hôm nay không tốt', 'normal', 1, 'none', '2026-09-22 06:19:53', '2026-09-22 06:20:05');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reminders`
--

DROP TABLE IF EXISTS `reminders`;
CREATE TABLE IF NOT EXISTS `reminders` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `reminder_type` enum('breakfast','lunch','dinner','snack','weight','water','custom') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'custom',
  `title` varchar(180) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `reminder_time` time NOT NULL,
  `repeat_type` enum('once','daily','weekdays','weekly') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'daily',
  `status` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `last_triggered_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_reminders_user_status` (`user_id`,`status`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `subscription_plans`
--

DROP TABLE IF EXISTS `subscription_plans`;
CREATE TABLE IF NOT EXISTS `subscription_plans` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `code` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `price` decimal(12,2) NOT NULL DEFAULT '0.00',
  `duration_days` int UNSIGNED NOT NULL DEFAULT '0',
  `features` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `chatbot_limit_per_day` int UNSIGNED NOT NULL DEFAULT '5',
  `status` enum('active','inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `support_chats`
--

DROP TABLE IF EXISTS `support_chats`;
CREATE TABLE IF NOT EXISTS `support_chats` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `status` enum('open','closed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `support_chats`
--

INSERT INTO `support_chats` (`id`, `user_id`, `status`, `created_at`, `updated_at`) VALUES
(2, 1, 'open', '2026-08-22 19:16:07', '2026-08-22 19:16:07'),
(3, 2, 'open', '2026-09-17 04:04:57', '2026-09-17 04:04:57'),
(4, 3, 'open', '2026-09-19 14:27:20', '2026-09-19 14:27:20'),
(5, 4, 'open', '2026-09-22 06:18:57', '2026-09-22 06:18:57');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `support_messages`
--

DROP TABLE IF EXISTS `support_messages`;
CREATE TABLE IF NOT EXISTS `support_messages` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `chat_id` bigint UNSIGNED NOT NULL,
  `sender_type` enum('user','admin') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `chat_id` (`chat_id`)
) ENGINE=MyISAM AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `support_messages`
--

INSERT INTO `support_messages` (`id`, `chat_id`, `sender_type`, `message`, `is_read`, `created_at`) VALUES
(16, 2, 'admin', 'dvdd', 0, '2026-08-22 19:16:07'),
(17, 3, 'user', 'chào nhá', 1, '2026-09-17 04:04:57'),
(18, 3, 'admin', 'oke', 1, '2026-09-17 04:16:07'),
(19, 3, 'admin', 'oeke', 1, '2026-09-17 04:16:30'),
(20, 3, 'admin', 'hahah', 1, '2026-09-17 04:16:49'),
(21, 3, 'admin', 'heheh', 1, '2026-09-17 04:16:55'),
(22, 3, 'admin', 'ủa kì dậy', 1, '2026-09-17 04:17:10'),
(23, 3, 'admin', 'kì ghê ta', 1, '2026-09-17 04:17:26'),
(24, 3, 'admin', 'bị lâu á', 1, '2026-09-17 04:17:38'),
(25, 3, 'admin', 'có đó hoq', 1, '2026-09-17 04:18:38'),
(26, 3, 'admin', 'ăn cơm chưa', 1, '2026-09-17 04:18:41'),
(27, 3, 'admin', 'lỗi j kì dậy', 1, '2026-09-17 04:19:02'),
(28, 3, 'admin', 'ê nha', 1, '2026-09-17 04:19:25'),
(29, 3, 'admin', 'lỗi này bt nói sao', 1, '2026-09-17 04:19:31'),
(30, 3, 'user', 'chịu', 1, '2026-09-17 04:19:56'),
(31, 3, 'admin', 'có j k', 1, '2026-09-17 04:20:43'),
(32, 3, 'admin', 'ăn j thế', 1, '2026-09-17 04:20:46'),
(33, 3, 'admin', 'đói bụng quá', 1, '2026-09-17 04:20:51'),
(34, 3, 'admin', 'thèm mì cay', 1, '2026-09-17 04:20:54'),
(35, 3, 'admin', 'hhhh', 1, '2026-09-17 04:25:40'),
(36, 3, 'admin', 'alalo', 1, '2026-09-17 04:25:42'),
(37, 3, 'admin', 'aloha', 1, '2026-09-17 04:25:44'),
(38, 3, 'admin', 'chơi game k', 1, '2026-09-17 04:25:48'),
(39, 3, 'admin', '1 ngày lướt tt 190p', 1, '2026-09-17 04:25:58'),
(40, 3, 'admin', 'có đâu ai ngờ', 1, '2026-09-17 04:27:01'),
(41, 3, 'admin', 'uống ts k', 1, '2026-09-17 04:27:35'),
(42, 3, 'admin', 'đ', 1, '2026-09-17 04:28:08'),
(43, 3, 'admin', 'jjhnh', 1, '2026-09-17 04:28:09'),
(44, 3, 'admin', 'fgfcb', 1, '2026-09-17 04:28:10'),
(45, 3, 'admin', 'ddd', 1, '2026-09-17 04:28:26'),
(46, 3, 'admin', 'có đps k', 1, '2026-09-17 04:28:32'),
(47, 3, 'admin', '324345', 1, '2026-09-17 04:28:37'),
(48, 3, 'admin', 'ẻwrtwt', 1, '2026-09-19 14:17:51'),
(49, 3, 'user', 'đ', 1, '2026-09-19 14:18:40'),
(50, 3, 'user', 'rtrt', 1, '2026-09-19 14:18:46'),
(51, 4, 'user', 'sss', 1, '2026-09-19 14:27:20'),
(54, 4, 'user', 'ssss', 1, '2026-09-19 14:42:21'),
(55, 4, 'user', 'sssssss', 1, '2026-09-19 14:42:28'),
(53, 4, 'user', 'sss', 1, '2026-09-19 14:42:15'),
(56, 4, 'user', 'ssss', 1, '2026-09-19 14:42:31'),
(57, 4, 'user', 'sssss', 1, '2026-09-19 14:42:34'),
(58, 4, 'admin', 'ssss', 1, '2026-09-19 14:45:11'),
(59, 4, 'admin', 'ssss', 1, '2026-09-19 14:45:15'),
(60, 4, 'admin', 'ssss', 1, '2026-09-19 14:45:20'),
(61, 4, 'admin', 'ssss', 1, '2026-09-19 14:45:23'),
(62, 4, 'admin', 'sssss', 1, '2026-09-19 14:45:27'),
(63, 4, 'admin', 'sssss', 1, '2026-09-19 14:45:29'),
(64, 4, 'admin', 'sssss', 1, '2026-09-19 14:50:08'),
(65, 4, 'admin', 'sss', 1, '2026-09-19 14:50:12'),
(66, 4, 'admin', 'sssss', 1, '2026-09-19 14:50:17'),
(67, 4, 'admin', 'sss', 1, '2026-09-19 14:53:22'),
(68, 4, 'admin', 'ssss', 1, '2026-09-19 14:54:49'),
(69, 4, 'user', 'sss', 1, '2026-09-19 14:56:12'),
(70, 4, 'admin', 'ddddd', 1, '2026-09-19 14:56:50'),
(71, 4, 'admin', 'ssss', 0, '2026-09-19 15:30:50'),
(72, 5, 'user', 'tôi muốn báo lỗi trang web', 1, '2026-09-22 06:18:57'),
(73, 5, 'admin', 'xin chào chạo', 0, '2026-09-22 06:21:51'),
(74, 5, 'admin', 'xui lòng nên rõ yêu cầu', 0, '2026-09-22 06:22:03');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `system_settings`
--

DROP TABLE IF EXISTS `system_settings`;
CREATE TABLE IF NOT EXISTS `system_settings` (
  `setting_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `setting_value` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `system_settings`
--

INSERT INTO `system_settings` (`setting_key`, `setting_value`, `description`, `updated_at`) VALUES
('gemini_model', 'gemini-3.1-flash-lite', 'Gemini AI Model identifier', '2026-09-20 14:21:04');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `transactions`
--

DROP TABLE IF EXISTS `transactions`;
CREATE TABLE IF NOT EXISTS `transactions` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `plan_id` bigint UNSIGNED NOT NULL,
  `transaction_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(12,2) NOT NULL DEFAULT '0.00',
  `payment_method` enum('visa','mastercard','ewallet','bank_transfer') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_reference` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` enum('pending','success','failed','cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `started_at` datetime DEFAULT NULL,
  `expired_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_code` (`transaction_code`),
  KEY `fk_transactions_plan` (`plan_id`),
  KEY `idx_transactions_user` (`user_id`),
  KEY `idx_transactions_status` (`status`),
  KEY `idx_transactions_created_at` (`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `full_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `avatar` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mssv` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `class_id` bigint UNSIGNED DEFAULT NULL,
  `stt` int UNSIGNED DEFAULT '0',
  `role` enum('user','admin') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user',
  `status` enum('active','inactive','locked') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `email_verified_at` datetime DEFAULT NULL,
  `last_login_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `uk_users_mssv` (`mssv`),
  KEY `idx_users_role` (`role`),
  KEY `idx_users_status` (`status`),
  KEY `idx_users_created_at` (`created_at`),
  KEY `fk_users_class` (`class_id`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `password`, `avatar`, `mssv`, `birth_date`, `class_id`, `stt`, `role`, `status`, `email_verified_at`, `last_login_at`, `created_at`, `updated_at`) VALUES
(1, 'Root Admin', 'kimthuyen@gmail.com', '$2y$12$WEpvs1yGKKA87EAfJZ5rJOgsW0KE6ON/FxfUKKRTt1WVBhqWyQ94y', NULL, NULL, NULL, NULL, 0, 'admin', 'active', NULL, NULL, '2026-09-19 17:12:48', '2026-09-20 17:11:06'),
(2, 'kimthuyen', 'thuyen@gmail.com', '$2y$10$SoOa/bpsJ62r5mwRkkWveOs7MCk/GSLE.QF5iHPxsPLMxGx3ARAQC', NULL, '224', '2006-03-10', 1, 2, 'user', 'active', NULL, NULL, '2026-09-19 13:50:03', '2026-09-20 17:11:18'),
(3, 'admin', 'admin@example.com', '$2y$10$HgBy6zOTgPcaqKunyBu99.iBYFshchJ/cz67FrzlPWJhIUXtExMSi', NULL, NULL, NULL, NULL, 0, 'admin', 'active', NULL, NULL, '2026-09-20 17:12:06', '2026-09-20 17:13:36'),
(4, 'user', 'user@example.com', '$2y$10$D8cOgFK0M6YGgGIA971WFO3GrQNX0pkwa.E30P1UFIeRyyenHtIRS', NULL, NULL, NULL, NULL, 0, 'user', 'active', NULL, NULL, '2026-09-20 17:12:37', '2026-09-22 06:15:24'),
(5, 'thuen', 'thuen@gmail.com', '$2y$10$j0A14m350ypsoVfUs9qzG.77jd3dM6JDXdiB/ZUino1TmQ8ktsExC', NULL, NULL, NULL, NULL, 0, 'user', 'active', NULL, NULL, '2026-09-20 17:15:51', '2026-09-22 06:51:38');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_profiles`
--

DROP TABLE IF EXISTS `user_profiles`;
CREATE TABLE IF NOT EXISTS `user_profiles` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `date_of_birth` date DEFAULT NULL,
  `age` tinyint UNSIGNED DEFAULT NULL,
  `gender` enum('male','female','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `height_cm` decimal(5,2) DEFAULT NULL,
  `current_weight_kg` decimal(6,2) DEFAULT NULL,
  `target_weight_kg` decimal(6,2) DEFAULT NULL,
  `activity_level` enum('sedentary','light','moderate','very_active','extra_active') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'sedentary',
  `health_goal` enum('lose_weight','gain_weight','maintain_weight','gain_muscle') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'maintain_weight',
  `goal_pace` enum('slow','moderate','fast') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'moderate',
  `diet_type` enum('normal','vegetarian','vegan','low_carb','low_sugar','gluten_free','high_protein') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'normal',
  `allergies` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `disliked_foods` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `meals_per_day` tinyint UNSIGNED NOT NULL DEFAULT '3',
  `bmr` decimal(8,2) DEFAULT NULL,
  `tdee` decimal(8,2) DEFAULT NULL,
  `bmi` decimal(5,2) DEFAULT NULL,
  `calorie_target` decimal(8,2) DEFAULT NULL,
  `protein_target` decimal(8,2) DEFAULT NULL,
  `carb_target` decimal(8,2) DEFAULT NULL,
  `fat_target` decimal(8,2) DEFAULT NULL,
  `fiber_target` decimal(8,2) DEFAULT '25.00',
  `water_target_ml` int UNSIGNED DEFAULT '2000',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `user_profiles`
--

INSERT INTO `user_profiles` (`id`, `user_id`, `date_of_birth`, `age`, `gender`, `height_cm`, `current_weight_kg`, `target_weight_kg`, `activity_level`, `health_goal`, `goal_pace`, `diet_type`, `allergies`, `disliked_foods`, `meals_per_day`, `bmr`, `tdee`, `bmi`, `calorie_target`, `protein_target`, `carb_target`, `fat_target`, `fiber_target`, `water_target_ml`, `created_at`, `updated_at`) VALUES
(8, 2, '2006-10-03', 19, 'male', 145.00, 44.00, NULL, 'sedentary', 'lose_weight', 'moderate', 'normal', '', '', 3, 1256.25, 1507.50, NULL, 1007.50, 75.56, 100.75, 33.58, 25.00, 2000, '2026-09-19 13:51:30', '2026-09-19 13:51:30'),
(9, 4, '2006-03-10', 20, 'female', 166.00, 67.00, NULL, 'light', 'maintain_weight', 'moderate', 'low_sugar', '', '', 3, 1320.25, 1815.34, NULL, 1815.34, 136.15, 181.53, 60.51, 25.00, 2000, '2026-09-22 06:16:44', '2026-09-22 06:18:13');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_smart_menus`
--

DROP TABLE IF EXISTS `user_smart_menus`;
CREATE TABLE IF NOT EXISTS `user_smart_menus` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `menu_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `completed_days` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT '[]',
  `status` enum('active','completed','cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `user_smart_menus`
--

INSERT INTO `user_smart_menus` (`id`, `user_id`, `menu_data`, `completed_days`, `status`, `created_at`) VALUES
(14, 3, '[{\"ngay\":1,\"buoi\":[{\"ten_bua\":\"S\\u00e1ng\",\"mon\":\"2 qu\\u1ea3 tr\\u1ee9ng \\u1ed1p la + 2 l\\u00e1t b\\u00e1nh m\\u00ec nguy\\u00ean c\\u00e1m + 1 ly s\\u1eefa t\\u01b0\\u01a1i nguy\\u00ean kem\",\"calo\":455,\"protein\":23},{\"ten_bua\":\"Tr\\u01b0a\",\"mon\":\"200g th\\u1ecbt b\\u00f2 x\\u00e0o \\u1edbt chu\\u00f4ng + 1 ch\\u00e9n c\\u01a1m \\u0111\\u1ea7y + canh b\\u00ed \\u0111\\u1ecf\",\"calo\":650,\"protein\":42},{\"ten_bua\":\"Ph\\u1ee5 chi\\u1ec1u\",\"mon\":\"1 ly s\\u1eefa t\\u01b0\\u01a1i nguy\\u00ean kem + v\\u00e0i c\\u00e1i b\\u00e1nh quy\",\"calo\":195,\"protein\":8},{\"ten_bua\":\"T\\u1ed1i\",\"mon\":\"200g g\\u00e0 kho g\\u1eebng + 1 ch\\u00e9n c\\u01a1m + rau x\\u00e0o\",\"calo\":546,\"protein\":39}],\"tong_calo\":1846,\"tong_protein\":112,\"ghi_chu\":\"T\\u0103ng kh\\u1ea9u ph\\u1ea7n, \\u01b0u ti\\u00ean m\\u00f3n gi\\u00e0u n\\u0103ng l\\u01b0\\u1ee3ng, \\u0111\\u1ea1m v\\u00e0 ch\\u1ea5t b\\u00e9o t\\u1ed1t \\u0111\\u1ec3 t\\u0103ng c\\u00e2n l\\u00e0nh m\\u1ea1nh.\"},{\"ngay\":2,\"buoi\":[{\"ten_bua\":\"S\\u00e1ng\",\"mon\":\"1 b\\u00e1t ph\\u1edf b\\u00f2 t\\u00e1i n\\u1ea1m \\u0111\\u1ea7y \\u0111\\u1ee7 + 1 ly s\\u1eefa \\u0111\\u1eadu n\\u00e0nh\",\"calo\":455,\"protein\":23},{\"ten_bua\":\"Tr\\u01b0a\",\"mon\":\"200g g\\u00e0 kho g\\u1eebng + 1 ch\\u00e9n c\\u01a1m + rau mu\\u1ed1ng x\\u00e0o t\\u1ecfi\",\"calo\":650,\"protein\":42},{\"ten_bua\":\"Ph\\u1ee5 chi\\u1ec1u\",\"mon\":\"Chu\\u1ed1i chi\\u00ean ho\\u1eb7c khoai lang chi\\u00ean\",\"calo\":195,\"protein\":8},{\"ten_bua\":\"T\\u1ed1i\",\"mon\":\"200g b\\u00f2 x\\u00e0o \\u1edbt chu\\u00f4ng + 1 ch\\u00e9n c\\u01a1m + canh rau\",\"calo\":546,\"protein\":39}],\"tong_calo\":1846,\"tong_protein\":112,\"ghi_chu\":\"T\\u0103ng kh\\u1ea9u ph\\u1ea7n, \\u01b0u ti\\u00ean m\\u00f3n gi\\u00e0u n\\u0103ng l\\u01b0\\u1ee3ng, \\u0111\\u1ea1m v\\u00e0 ch\\u1ea5t b\\u00e9o t\\u1ed1t \\u0111\\u1ec3 t\\u0103ng c\\u00e2n l\\u00e0nh m\\u1ea1nh.\"},{\"ngay\":3,\"buoi\":[{\"ten_bua\":\"S\\u00e1ng\",\"mon\":\"B\\u00e1nh m\\u00ec tr\\u1ee9ng \\u1ed1p la, pate + 1 ly s\\u1eefa t\\u01b0\\u01a1i c\\u00f3 \\u0111\\u01b0\\u1eddng\",\"calo\":455,\"protein\":23},{\"ten_bua\":\"Tr\\u01b0a\",\"mon\":\"200g c\\u00e1 basa kho t\\u1ed9 + 1 ch\\u00e9n c\\u01a1m + canh chua\",\"calo\":650,\"protein\":42},{\"ten_bua\":\"Ph\\u1ee5 chi\\u1ec1u\",\"mon\":\"1 \\u1ed5 b\\u00e1nh m\\u00ec th\\u1ecbt nh\\u1ecf\",\"calo\":195,\"protein\":8},{\"ten_bua\":\"T\\u1ed1i\",\"mon\":\"L\\u1ea9u n\\u1ea5m chay \\u0111\\u1ea7y \\u0111\\u1ee7 topping + b\\u00fan\",\"calo\":546,\"protein\":39}],\"tong_calo\":1846,\"tong_protein\":112,\"ghi_chu\":\"T\\u0103ng kh\\u1ea9u ph\\u1ea7n, \\u01b0u ti\\u00ean m\\u00f3n gi\\u00e0u n\\u0103ng l\\u01b0\\u1ee3ng, \\u0111\\u1ea1m v\\u00e0 ch\\u1ea5t b\\u00e9o t\\u1ed1t \\u0111\\u1ec3 t\\u0103ng c\\u00e2n l\\u00e0nh m\\u1ea1nh.\"}]', '[1]', 'active', '2026-09-22 13:02:11'),
(15, 4, '[{\"ngay\":1,\"buoi\":[{\"ten_bua\":\"S\\u00e1ng\",\"mon\":\"1 b\\u00e1t y\\u1ebfn m\\u1ea1ch n\\u1ea5u s\\u1eefa t\\u01b0\\u01a1i kh\\u00f4ng \\u0111\\u01b0\\u1eddng + 1\\/2 qu\\u1ea3 chu\\u1ed1i + 1 th\\u00eca h\\u1ea1t chia\",\"calo\":298,\"protein\":15},{\"ten_bua\":\"Tr\\u01b0a\",\"mon\":\"150g \\u1ee9c g\\u00e0 \\u00e1p ch\\u1ea3o + 1\\/2 ch\\u00e9n c\\u01a1m g\\u1ea1o l\\u1ee9t + 1 \\u0111\\u0129a b\\u00f4ng c\\u1ea3i xanh lu\\u1ed9c\",\"calo\":425,\"protein\":27},{\"ten_bua\":\"Ph\\u1ee5 chi\\u1ec1u\",\"mon\":\"1 h\\u0169 s\\u1eefa chua kh\\u00f4ng \\u0111\\u01b0\\u1eddng + 5 h\\u1ea1t h\\u1ea1nh nh\\u00e2n\",\"calo\":128,\"protein\":5},{\"ten_bua\":\"T\\u1ed1i\",\"mon\":\"150g c\\u00e1 l\\u00f3c h\\u1ea5p g\\u1eebng + 1 b\\u00e1t canh rau ng\\u00f3t th\\u1ecbt b\\u0103m (kh\\u00f4ng \\u0103n c\\u01a1m)\",\"calo\":357,\"protein\":26}],\"tong_calo\":1208,\"tong_protein\":73,\"ghi_chu\":\"\\u01afu ti\\u00ean m\\u00f3n \\u00edt calo, nhi\\u1ec1u ch\\u1ea5t x\\u01a1, h\\u1ea1n ch\\u1ebf d\\u1ea7u m\\u1ee1 v\\u00e0 tinh b\\u1ed9t tinh ch\\u1ebf.\"},{\"ngay\":2,\"buoi\":[{\"ten_bua\":\"S\\u00e1ng\",\"mon\":\"2 qu\\u1ea3 tr\\u1ee9ng \\u1ed1p la (d\\u00f9ng \\u00edt d\\u1ea7u olive) + 1 l\\u00e1t b\\u00e1nh m\\u00ec nguy\\u00ean c\\u00e1m + 1\\/2 qu\\u1ea3 b\\u01a1\",\"calo\":298,\"protein\":15},{\"ten_bua\":\"Tr\\u01b0a\",\"mon\":\"150g th\\u1ecbt th\\u0103n heo lu\\u1ed9c + 1 c\\u1ee7 khoai lang lu\\u1ed9c + salad d\\u01b0a leo c\\u00e0 chua tr\\u1ed9n gi\\u1ea5m olive\",\"calo\":425,\"protein\":27},{\"ten_bua\":\"Ph\\u1ee5 chi\\u1ec1u\",\"mon\":\"1 qu\\u1ea3 \\u1ed5i ho\\u1eb7c 1 qu\\u1ea3 t\\u00e1o gi\\u00f2n\",\"calo\":128,\"protein\":5},{\"ten_bua\":\"T\\u1ed1i\",\"mon\":\"150g \\u0111\\u1eadu h\\u0169 d\\u1ed3n th\\u1ecbt s\\u1ed1t c\\u00e0 chua \\u00edt d\\u1ea7u + 1 b\\u00e1t canh m\\u1ed3ng t\\u01a1i n\\u1ea5u t\\u00f4m\",\"calo\":357,\"protein\":26}],\"tong_calo\":1208,\"tong_protein\":73,\"ghi_chu\":\"\\u01afu ti\\u00ean m\\u00f3n \\u00edt calo, nhi\\u1ec1u ch\\u1ea5t x\\u01a1, h\\u1ea1n ch\\u1ebf d\\u1ea7u m\\u1ee1 v\\u00e0 tinh b\\u1ed9t tinh ch\\u1ebf.\"},{\"ngay\":3,\"buoi\":[{\"ten_bua\":\"S\\u00e1ng\",\"mon\":\"Sinh t\\u1ed1 1 qu\\u1ea3 chu\\u1ed1i + 1 n\\u1eafm rau bina + 1 th\\u00eca b\\u01a1 \\u0111\\u1eadu ph\\u1ee5ng + 150ml s\\u1eefa t\\u01b0\\u01a1i kh\\u00f4ng \\u0111\\u01b0\\u1eddng\",\"calo\":298,\"protein\":15},{\"ten_bua\":\"Tr\\u01b0a\",\"mon\":\"150g th\\u1ecbt b\\u00f2 x\\u00e0o \\u1edbt \\u0110\\u00e0 L\\u1ea1t + 1\\/2 ch\\u00e9n c\\u01a1m g\\u1ea1o l\\u1ee9t + canh c\\u1ea3i c\\u00fac\",\"calo\":425,\"protein\":27},{\"ten_bua\":\"Ph\\u1ee5 chi\\u1ec1u\",\"mon\":\"1 ly s\\u1eefa h\\u1ea1t kh\\u00f4ng \\u0111\\u01b0\\u1eddng (\\u00f3c ch\\u00f3\\/h\\u1ea1nh nh\\u00e2n)\",\"calo\":128,\"protein\":5},{\"ten_bua\":\"T\\u1ed1i\",\"mon\":\"150g c\\u00e1 h\\u1ed3i (ho\\u1eb7c c\\u00e1 ng\\u1eeb) \\u00e1p ch\\u1ea3o + m\\u0103ng t\\u00e2y\\/\\u0111\\u1eadu que lu\\u1ed9c\",\"calo\":357,\"protein\":26}],\"tong_calo\":1208,\"tong_protein\":73,\"ghi_chu\":\"\\u01afu ti\\u00ean m\\u00f3n \\u00edt calo, nhi\\u1ec1u ch\\u1ea5t x\\u01a1, h\\u1ea1n ch\\u1ebf d\\u1ea7u m\\u1ee1 v\\u00e0 tinh b\\u1ed9t tinh ch\\u1ebf.\"}]', '[1]', 'active', '2026-09-22 13:19:22');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `user_subscriptions`
--

DROP TABLE IF EXISTS `user_subscriptions`;
CREATE TABLE IF NOT EXISTS `user_subscriptions` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `plan_id` bigint UNSIGNED NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime DEFAULT NULL,
  `status` enum('active','expired','cancelled') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_user_subscriptions_plan` (`plan_id`),
  KEY `idx_user_subscriptions_user` (`user_id`),
  KEY `idx_user_subscriptions_status` (`status`),
  KEY `idx_user_subscriptions_end_date` (`end_date`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `weight_logs`
--

DROP TABLE IF EXISTS `weight_logs`;
CREATE TABLE IF NOT EXISTS `weight_logs` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` bigint UNSIGNED NOT NULL,
  `weight_kg` decimal(6,2) NOT NULL,
  `height_cm` decimal(5,1) DEFAULT NULL,
  `bmi` decimal(5,2) DEFAULT NULL,
  `log_date` date NOT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_weight_logs_user_date` (`user_id`,`log_date`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Đang đổ dữ liệu cho bảng `weight_logs`
--

INSERT INTO `weight_logs` (`id`, `user_id`, `weight_kg`, `height_cm`, `bmi`, `log_date`, `note`, `created_at`, `updated_at`) VALUES
(22, 4, 56.00, 166.0, 20.32, '2026-09-21', 'khi mới ngủ dậy', '2026-09-21 11:20:00', '2026-09-22 06:17:46'),
(23, 4, 45.00, 166.0, 16.33, '2026-09-20', '', '2026-09-20 06:17:00', '2026-09-22 06:18:02'),
(24, 4, 67.00, 166.0, 24.31, '2026-09-08', '', '2026-09-08 06:18:00', '2026-09-22 06:18:13');

--
-- Ràng buộc đối với các bảng kết xuất
--

--
-- Ràng buộc cho bảng `ai_generated_meal_plans`
--
ALTER TABLE `ai_generated_meal_plans`
  ADD CONSTRAINT `fk_ai_generated_meal_plans_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `chatbot_usage_logs`
--
ALTER TABLE `chatbot_usage_logs`
  ADD CONSTRAINT `fk_chatbot_usage_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `chat_conversations`
--
ALTER TABLE `chat_conversations`
  ADD CONSTRAINT `fk_chat_conversations_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `chat_messages`
--
ALTER TABLE `chat_messages`
  ADD CONSTRAINT `fk_chat_messages_conversation` FOREIGN KEY (`conversation_id`) REFERENCES `chat_conversations` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `favorite_meal_plans`
--
ALTER TABLE `favorite_meal_plans`
  ADD CONSTRAINT `fk_favorite_meal_plans_plan` FOREIGN KEY (`meal_plan_id`) REFERENCES `meal_plans` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_favorite_meal_plans_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `foods`
--
ALTER TABLE `foods`
  ADD CONSTRAINT `fk_foods_category` FOREIGN KEY (`category_id`) REFERENCES `food_categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_foods_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `food_goals`
--
ALTER TABLE `food_goals`
  ADD CONSTRAINT `fk_food_goals_food` FOREIGN KEY (`food_id`) REFERENCES `foods` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `food_ingredients`
--
ALTER TABLE `food_ingredients`
  ADD CONSTRAINT `fk_food_ingredients_food` FOREIGN KEY (`food_id`) REFERENCES `foods` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_food_ingredients_ingredient` FOREIGN KEY (`ingredient_id`) REFERENCES `ingredients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `health_hourly_logs`
--
ALTER TABLE `health_hourly_logs`
  ADD CONSTRAINT `fk_health_hourly_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `meal_logs`
--
ALTER TABLE `meal_logs`
  ADD CONSTRAINT `fk_meal_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `meal_log_items`
--
ALTER TABLE `meal_log_items`
  ADD CONSTRAINT `fk_meal_log_items_food` FOREIGN KEY (`food_id`) REFERENCES `foods` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_meal_log_items_log` FOREIGN KEY (`meal_log_id`) REFERENCES `meal_logs` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `meal_plans`
--
ALTER TABLE `meal_plans`
  ADD CONSTRAINT `fk_meal_plans_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `meal_plan_items`
--
ALTER TABLE `meal_plan_items`
  ADD CONSTRAINT `fk_meal_plan_items_food` FOREIGN KEY (`food_id`) REFERENCES `foods` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_meal_plan_items_meal` FOREIGN KEY (`meal_plan_meal_id`) REFERENCES `meal_plan_meals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `meal_plan_meals`
--
ALTER TABLE `meal_plan_meals`
  ADD CONSTRAINT `fk_meal_plan_meals_plan` FOREIGN KEY (`meal_plan_id`) REFERENCES `meal_plans` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `mystery_box_history`
--
ALTER TABLE `mystery_box_history`
  ADD CONSTRAINT `fk_mystery_box_food` FOREIGN KEY (`food_id`) REFERENCES `foods` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `personal_notes`
--
ALTER TABLE `personal_notes`
  ADD CONSTRAINT `fk_personal_notes_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `reminders`
--
ALTER TABLE `reminders`
  ADD CONSTRAINT `fk_reminders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `fk_transactions_plan` FOREIGN KEY (`plan_id`) REFERENCES `subscription_plans` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_transactions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `fk_users_class` FOREIGN KEY (`class_id`) REFERENCES `classes` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `user_profiles`
--
ALTER TABLE `user_profiles`
  ADD CONSTRAINT `fk_user_profiles_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `user_smart_menus`
--
ALTER TABLE `user_smart_menus`
  ADD CONSTRAINT `user_smart_menus_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ràng buộc cho bảng `user_subscriptions`
--
ALTER TABLE `user_subscriptions`
  ADD CONSTRAINT `fk_user_subscriptions_plan` FOREIGN KEY (`plan_id`) REFERENCES `subscription_plans` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_user_subscriptions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ràng buộc cho bảng `weight_logs`
--
ALTER TABLE `weight_logs`
  ADD CONSTRAINT `fk_weight_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
