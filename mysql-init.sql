-- MySQL Initialization Script
-- This script sets up users, database, and schema for the Mindful application

-- Fix authentication for all users
ALTER USER 'root'@'%' IDENTIFIED WITH mysql_native_password BY 'rootpassword';
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'rootpassword';
ALTER USER 'mindful'@'%' IDENTIFIED WITH mysql_native_password BY 'mindful2025';

-- Create additional user with native password as backup
CREATE USER IF NOT EXISTS 'mindful_native'@'%' IDENTIFIED WITH mysql_native_password BY 'mindful2025';
GRANT ALL PRIVILEGES ON *.* TO 'mindful_native'@'%' WITH GRANT OPTION;

-- Ensure mindful user has all privileges
GRANT ALL PRIVILEGES ON *.* TO 'mindful'@'%' WITH GRANT OPTION;

-- Create database if not exists
CREATE DATABASE IF NOT EXISTS productdb;

-- Grant specific database privileges
GRANT ALL PRIVILEGES ON productdb.* TO 'mindful'@'%';
GRANT ALL PRIVILEGES ON productdb.* TO 'mindful_native'@'%';

FLUSH PRIVILEGES;

-- Switch to the application database
USE productdb;

-- MySQL dump 10.13  Distrib 9.4.0, for macos15.4 (arm64)
--
-- Host: localhost    Database: productdb
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `assumptions`
--

DROP TABLE IF EXISTS `assumptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `assumptions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `assumption` text NOT NULL,
  `confidence` varchar(50) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `impact` varchar(50) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKt1jif556osd4uvqsr8wgpk84q` (`product_id`),
  CONSTRAINT `FKt1jif556osd4uvqsr8wgpk84q` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `backlog_epics`
--

DROP TABLE IF EXISTS `backlog_epics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `backlog_epics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epic_id` varchar(255) NOT NULL,
  `epic_name` varchar(255) NOT NULL,
  `epic_description` text,
  `theme_id` varchar(255) DEFAULT NULL,
  `theme_name` varchar(255) DEFAULT NULL,
  `theme_color` varchar(7) DEFAULT NULL,
  `initiative_id` varchar(255) DEFAULT NULL,
  `initiative_name` varchar(255) DEFAULT NULL,
  `track` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `product_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_epic_id` (`epic_id`),
  KEY `idx_theme_id` (`theme_id`),
  KEY `idx_initiative_id` (`initiative_id`),
  KEY `idx_track` (`track`),
  KEY `idx_backlog_epics_product_id` (`product_id`),
  CONSTRAINT `fk_backlog_epics_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `capacity_plans`
--

DROP TABLE IF EXISTS `capacity_plans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `capacity_plans` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `year` int NOT NULL,
  `quarter` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `effort_unit` varchar(10) NOT NULL DEFAULT 'SPRINTS',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_capacity_plans_product_year_quarter` (`product_id`,`year`,`quarter`),
  KEY `idx_capacity_plans_product` (`product_id`),
  KEY `idx_capacity_plans_year_quarter` (`year`,`quarter`),
  CONSTRAINT `capacity_plans_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `capacity_plans_chk_1` CHECK ((`quarter` between 1 and 4))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `effort_rating_configs`
--

DROP TABLE IF EXISTS `effort_rating_configs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `effort_rating_configs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `unit_type` varchar(255) NOT NULL,
  `star_1_max` int NOT NULL DEFAULT '2',
  `star_2_min` int NOT NULL DEFAULT '3',
  `star_2_max` int NOT NULL DEFAULT '4',
  `star_3_min` int NOT NULL DEFAULT '5',
  `star_3_max` int NOT NULL DEFAULT '6',
  `star_4_min` int NOT NULL DEFAULT '7',
  `star_4_max` int NOT NULL DEFAULT '8',
  `star_5_min` int NOT NULL DEFAULT '9',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_effort_rating_configs_product_unit` (`product_id`,`unit_type`),
  CONSTRAINT `fk_effort_rating_configs_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `epic_efforts`
--

DROP TABLE IF EXISTS `epic_efforts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `epic_efforts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `capacity_plan_id` bigint NOT NULL,
  `epic_id` varchar(255) NOT NULL,
  `epic_name` varchar(500) NOT NULL,
  `team_id` bigint NOT NULL,
  `effort_days` int NOT NULL DEFAULT '0',
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_epic_efforts_plan_epic_team` (`capacity_plan_id`,`epic_id`,`team_id`),
  KEY `idx_epic_efforts_capacity_plan` (`capacity_plan_id`),
  KEY `idx_epic_efforts_epic` (`epic_id`),
  KEY `idx_epic_efforts_team` (`team_id`),
  CONSTRAINT `epic_efforts_ibfk_1` FOREIGN KEY (`capacity_plan_id`) REFERENCES `capacity_plans` (`id`) ON DELETE CASCADE,
  CONSTRAINT `epic_efforts_ibfk_2` FOREIGN KEY (`team_id`) REFERENCES `teams` (`id`) ON DELETE CASCADE,
  CONSTRAINT `epic_efforts_chk_1` CHECK ((`effort_days` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `initiatives`
--

DROP TABLE IF EXISTS `initiatives`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `initiatives` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) NOT NULL,
  `description` text,
  `owner` varchar(255) DEFAULT NULL,
  `priority` varchar(50) NOT NULL,
  `timeline` varchar(255) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKq3h5pcvenuejdkx6w8dejprms` (`product_id`),
  CONSTRAINT `FKq3h5pcvenuejdkx6w8dejprms` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kanban_items`
--

DROP TABLE IF EXISTS `kanban_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kanban_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `assignee` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `description` text,
  `due_date` datetime(6) DEFAULT NULL,
  `epic_id` varchar(255) DEFAULT NULL,
  `labels` varchar(255) DEFAULT NULL,
  `position` int DEFAULT NULL,
  `priority` varchar(255) DEFAULT NULL,
  `status` varchar(255) NOT NULL,
  `story_points` int DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `product_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKekjnv94et0xlcfa4tu8ybkuee` (`product_id`),
  CONSTRAINT `FKekjnv94et0xlcfa4tu8ybkuee` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `market_competition`
--

DROP TABLE IF EXISTS `market_competition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `market_competition` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `market_size` text COLLATE utf8mb4_unicode_ci,
  `market_growth` text COLLATE utf8mb4_unicode_ci,
  `target_market` text COLLATE utf8mb4_unicode_ci,
  `competitors` text COLLATE utf8mb4_unicode_ci,
  `competitive_advantage` text COLLATE utf8mb4_unicode_ci,
  `market_trends` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_id` (`product_id`),
  KEY `idx_market_competition_product_id` (`product_id`),
  CONSTRAINT `market_competition_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modules`
--

DROP TABLE IF EXISTS `modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modules` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `icon` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `display_order` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_display_order` (`display_order`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organizations`
--

DROP TABLE IF EXISTS `organizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organizations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `description` varchar(1000) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_p9pbw3flq9hkay8hdx3ypsldy` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `resource` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `description` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_basics`
--

DROP TABLE IF EXISTS `product_basics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_basics` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `vision` text COLLATE utf8mb4_unicode_ci,
  `target_personas` text COLLATE utf8mb4_unicode_ci,
  `goals` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_product_basics` (`product_id`),
  KEY `idx_product_id` (`product_id`),
  CONSTRAINT `product_basics_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_hypothesis`
--

DROP TABLE IF EXISTS `product_hypothesis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_hypothesis` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `hypothesis_statement` text COLLATE utf8mb4_unicode_ci,
  `solution_approach` text COLLATE utf8mb4_unicode_ci,
  `success_metrics` text COLLATE utf8mb4_unicode_ci,
  `risks` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_id` (`product_id`),
  KEY `idx_product_hypothesis_product_id` (`product_id`),
  CONSTRAINT `product_hypothesis_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `product_modules`
--

DROP TABLE IF EXISTS `product_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_modules` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `module_id` bigint NOT NULL,
  `is_enabled` tinyint(1) NOT NULL DEFAULT '1',
  `completion_percentage` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_product_module` (`product_id`,`module_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_module_id` (`module_id`),
  KEY `idx_is_enabled` (`is_enabled`),
  CONSTRAINT `product_modules_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `product_modules_ibfk_2` FOREIGN KEY (`module_id`) REFERENCES `modules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `organization_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `FKcq2q5sr56he3idwu8yamusw04` (`organization_id`),
  CONSTRAINT `FKcq2q5sr56he3idwu8yamusw04` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`),
  CONSTRAINT `products_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `quarterly_roadmap`
--

DROP TABLE IF EXISTS `quarterly_roadmap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `quarterly_roadmap` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `product_id` bigint NOT NULL,
  `year` int NOT NULL,
  `quarter` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `published` tinyint(1) DEFAULT '0',
  `published_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_product_year_quarter` (`product_id`,`year`,`quarter`),
  CONSTRAINT `quarterly_roadmap_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `roadmap_items`
--

DROP TABLE IF EXISTS `roadmap_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roadmap_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `roadmap_id` bigint NOT NULL,
  `epic_id` varchar(255) NOT NULL,
  `epic_name` varchar(255) NOT NULL,
  `epic_description` text,
  `priority` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `estimated_effort` varchar(100) DEFAULT NULL,
  `assigned_team` varchar(255) DEFAULT NULL,
  `reach` int DEFAULT NULL,
  `impact` int DEFAULT NULL,
  `confidence` int DEFAULT NULL,
  `rice_score` double DEFAULT NULL,
  `effort_rating` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `initiative_name` varchar(255) DEFAULT NULL,
  `theme_name` varchar(255) DEFAULT NULL,
  `theme_color` varchar(7) DEFAULT NULL,
  `published` tinyint(1) DEFAULT '0',
  `published_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_roadmap_id` (`roadmap_id`),
  KEY `idx_epic_id` (`epic_id`),
  KEY `idx_start_date` (`start_date`),
  KEY `idx_end_date` (`end_date`),
  CONSTRAINT `roadmap_items_ibfk_1` FOREIGN KEY (`roadmap_id`) REFERENCES `quarterly_roadmap` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=86 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permissions` (
  `role_id` bigint NOT NULL,
  `permission_id` bigint NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `permission_id` (`permission_id`),
  CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `role_product_modules`
--

DROP TABLE IF EXISTS `role_product_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_product_modules` (
  `role_id` bigint NOT NULL,
  `product_module_id` bigint NOT NULL,
  PRIMARY KEY (`role_id`,`product_module_id`),
  KEY `product_module_id` (`product_module_id`),
  CONSTRAINT `role_product_modules_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_product_modules_ibfk_2` FOREIGN KEY (`product_module_id`) REFERENCES `product_modules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `teams`
--

DROP TABLE IF EXISTS `teams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teams` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `product_id` bigint NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_teams_product_name` (`product_id`,`name`),
  KEY `idx_teams_product_id` (`product_id`),
  CONSTRAINT `teams_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `themes`
--

DROP TABLE IF EXISTS `themes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `themes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `color` varchar(7) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `description` text,
  `name` varchar(255) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `product_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK18dqhqvfepn6c9r3dsbp0fvd5` (`product_id`),
  CONSTRAINT `FK18dqhqvfepn6c9r3dsbp0fvd5` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_stories`
--

DROP TABLE IF EXISTS `user_stories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_stories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `epic_id` varchar(255) NOT NULL,
  `product_id` bigint NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text,
  `acceptance_criteria` text,
  `priority` varchar(20) DEFAULT 'Medium',
  `story_points` int DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Draft',
  `display_order` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_epic_id` (`epic_id`),
  KEY `idx_product_id` (`product_id`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_user_stories_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_priority` CHECK ((`priority` in (_utf8mb4'High',_utf8mb4'Medium',_utf8mb4'Low'))),
  CONSTRAINT `chk_status` CHECK ((`status` in (_utf8mb4'Draft',_utf8mb4'Ready',_utf8mb4'In Progress',_utf8mb4'Done',_utf8mb4'Blocked')))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_superadmin` tinyint(1) NOT NULL DEFAULT '0',
  `role_id` bigint DEFAULT NULL,
  `is_global_superadmin` bit(1) NOT NULL,
  `organization_id` bigint DEFAULT NULL,
  `first_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_email` (`email`),
  KEY `FKqpugllwvyv37klq7ft9m8aqxk` (`organization_id`),
  KEY `FKp56c1712k691lhsyewcssf40f` (`role_id`),
  CONSTRAINT `FKp56c1712k691lhsyewcssf40f` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  CONSTRAINT `FKqpugllwvyv37klq7ft9m8aqxk` FOREIGN KEY (`organization_id`) REFERENCES `organizations` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping routines for database 'productdb'
--
/*!50003 DROP PROCEDURE IF EXISTS `MigrateRoadmapData` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`mindful`@`localhost` PROCEDURE `MigrateRoadmapData`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE roadmap_id_var BIGINT;
    DECLARE json_data TEXT;
    DECLARE cur CURSOR FOR 
        SELECT id, roadmap_items_json 
        FROM quarterly_roadmap 
        WHERE roadmap_items_json IS NOT NULL 
        AND roadmap_items_json != '' 
        AND roadmap_items_json != '[]';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO roadmap_id_var, json_data;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Insert each item from the JSON array into roadmap_items table
        -- We'll use a more direct approach with JSON_EXTRACT for MySQL 5.7+
        SET @sql = CONCAT('
        INSERT INTO roadmap_items (
            roadmap_id, epic_id, epic_name, epic_description, priority, status, 
            estimated_effort, assigned_team, reach, impact, confidence, rice_score, 
            effort_rating, start_date, end_date, created_at, updated_at
        )
        SELECT 
            ', roadmap_id_var, ' as roadmap_id,
            JSON_UNQUOTE(JSON_EXTRACT(item, ''$.epicId'')) as epic_id,
            JSON_UNQUOTE(JSON_EXTRACT(item, ''$.epicName'')) as epic_name,
            JSON_UNQUOTE(JSON_EXTRACT(item, ''$.epicDescription'')) as epic_description,
            JSON_UNQUOTE(JSON_EXTRACT(item, ''$.priority'')) as priority,
            JSON_UNQUOTE(JSON_EXTRACT(item, ''$.status'')) as status,
            JSON_UNQUOTE(JSON_EXTRACT(item, ''$.estimatedEffort'')) as estimated_effort,
            JSON_UNQUOTE(JSON_EXTRACT(item, ''$.assignedTeam'')) as assigned_team,
            CAST(JSON_UNQUOTE(JSON_EXTRACT(item, ''$.reach'')) AS SIGNED) as reach,
            CAST(JSON_UNQUOTE(JSON_EXTRACT(item, ''$.impact'')) AS SIGNED) as impact,
            CAST(JSON_UNQUOTE(JSON_EXTRACT(item, ''$.confidence'')) AS SIGNED) as confidence,
            CAST(JSON_UNQUOTE(JSON_EXTRACT(item, ''$.riceScore'')) AS DECIMAL(10,2)) as rice_score,
            CAST(JSON_UNQUOTE(JSON_EXTRACT(item, ''$.effortRating'')) AS SIGNED) as effort_rating,
            CASE 
                WHEN JSON_UNQUOTE(JSON_EXTRACT(item, ''$.startDate'')) IS NOT NULL 
                     AND JSON_UNQUOTE(JSON_EXTRACT(item, ''$.startDate'')) != ''null''
                     AND JSON_UNQUOTE(JSON_EXTRACT(item, ''$.startDate'')) != ''''
                THEN STR_TO_DATE(JSON_UNQUOTE(JSON_EXTRACT(item, ''$.startDate'')), ''%Y-%m-%d'')
                ELSE NULL 
            END as start_date,
            CASE 
                WHEN JSON_UNQUOTE(JSON_EXTRACT(item, ''$.endDate'')) IS NOT NULL 
                     AND JSON_UNQUOTE(JSON_EXTRACT(item, ''$.endDate'')) != ''null''
                     AND JSON_UNQUOTE(JSON_EXTRACT(item, ''$.endDate'')) != ''''
                THEN STR_TO_DATE(JSON_UNQUOTE(JSON_EXTRACT(item, ''$.endDate'')), ''%Y-%m-%d'')
                ELSE NULL 
            END as end_date,
            NOW() as created_at,
            NOW() as updated_at
        FROM JSON_TABLE(''', REPLACE(json_data, '''', ''''''), ''', ''$[*]'' COLUMNS (
            item JSON PATH ''$''
        )) as jt;');

        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;

    END LOOP;

    CLOSE cur;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-09-17 21:01:40

-- Insert default product management modules
INSERT INTO `modules` (`id`, `name`, `description`, `icon`, `is_active`, `display_order`, `created_at`, `updated_at`) VALUES
(1, 'Product Basics', 'Define product vision, goals, and target personas', 'lightbulb', 1, 1, NOW(), NOW()),
(2, 'Market & Competition', 'Analyze market size, competition, and positioning', 'trending-up', 1, 2, NOW(), NOW()),
(3, 'Product Hypothesis', 'Document hypothesis, solution approach, and success metrics', 'target', 1, 3, NOW(), NOW()),
(4, 'Roadmap Planning', 'Plan and visualize quarterly product roadmaps', 'map', 1, 4, NOW(), NOW()),
(5, 'User Stories & Backlog', 'Manage user stories and product backlog', 'list', 1, 5, NOW(), NOW()),
(6, 'Capacity Planning', 'Plan team capacity and effort allocation', 'calendar', 1, 6, NOW(), NOW()),
(7, 'Assumptions & Risks', 'Track product assumptions and associated risks', 'alert-triangle', 1, 7, NOW(), NOW()),
(8, 'Initiatives & Themes', 'Organize work into strategic initiatives and themes', 'folder', 1, 8, NOW(), NOW()),
(9, 'Kanban Board', 'Visual task management and workflow tracking', 'trello', 1, 9, NOW(), NOW());

-- Reset AUTO_INCREMENT to continue from ID 10 for future modules
ALTER TABLE `modules` AUTO_INCREMENT = 10;
