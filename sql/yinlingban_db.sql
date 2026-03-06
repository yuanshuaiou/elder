/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80040 (8.0.40)
 Source Host           : localhost:3306
 Source Schema         : yinlingban_db

 Target Server Type    : MySQL
 Target Server Version : 80040 (8.0.40)
 File Encoding         : 65001

 Date: 06/03/2026 21:10:32
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for alert_level
-- ----------------------------
DROP TABLE IF EXISTS `alert_level`;
CREATE TABLE `alert_level`  (
  `aler_id` int NOT NULL AUTO_INCREMENT,
  `elder_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `family_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `alert_level` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '报警等级',
  `alert_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '报警类型',
  PRIMARY KEY (`aler_id` DESC) USING BTREE,
  INDEX `fk_alert_relation_elder`(`elder_id` ASC) USING BTREE,
  INDEX `fk_alert_relation_family`(`family_id` ASC) USING BTREE,
  CONSTRAINT `fk_alert_relation_elder` FOREIGN KEY (`elder_id`) REFERENCES `elder` (`elder_username`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_alert_relation_family` FOREIGN KEY (`family_id`) REFERENCES `family` (`family_username`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '家属端可自定义报警等级' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of alert_level
-- ----------------------------

-- ----------------------------
-- Table structure for elder
-- ----------------------------
DROP TABLE IF EXISTS `elder`;
CREATE TABLE `elder`  (
  `elder_username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `elder_password` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `elder_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `birth_date` date NOT NULL,
  `emergency_contact` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dialect_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `chronic_disease` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`elder_username`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of elder
-- ----------------------------

-- ----------------------------
-- Table structure for family
-- ----------------------------
DROP TABLE IF EXISTS `family`;
CREATE TABLE `family`  (
  `family_username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `family_password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `family_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`family_username`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of family
-- ----------------------------

-- ----------------------------
-- Table structure for family_elder_relation
-- ----------------------------
DROP TABLE IF EXISTS `family_elder_relation`;
CREATE TABLE `family_elder_relation`  (
  `relation_id` int NOT NULL COMMENT '确保同一关系不重复关联',
  `family_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `elder_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`relation_id`) USING BTREE,
  INDEX `fk_family_relation_family`(`family_id` ASC) USING BTREE,
  INDEX `fk_family_relation_elder`(`elder_id` ASC) USING BTREE,
  CONSTRAINT `fk_family_relation_elder` FOREIGN KEY (`elder_id`) REFERENCES `elder` (`elder_username`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_family_relation_family` FOREIGN KEY (`family_id`) REFERENCES `family` (`family_username`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '通过外键，确保数据库可以直接拒绝不合法插入操作，确保绑定的家属、老人都是真实存在的，不会出现绑定了一个不存在的人的情况。' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of family_elder_relation
-- ----------------------------

-- ----------------------------
-- Table structure for health_data
-- ----------------------------
DROP TABLE IF EXISTS `health_data`;
CREATE TABLE `health_data`  (
  `elder_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '每条健康数据关联到对应老人',
  `heart_rate` int NULL DEFAULT NULL,
  `breath_rate` int NULL DEFAULT NULL,
  `temperature` int NULL DEFAULT NULL,
  `health_id` int NOT NULL AUTO_INCREMENT COMMENT '唯一标识一条数据，持续更新健康数据，id自增',
  PRIMARY KEY (`health_id` DESC) USING BTREE,
  INDEX `fk_health_relation_elder`(`elder_id` ASC) USING BTREE,
  CONSTRAINT `fk_health_relation_elder` FOREIGN KEY (`elder_id`) REFERENCES `elder` (`elder_username`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of health_data
-- ----------------------------

-- ----------------------------
-- Table structure for voice_log
-- ----------------------------
DROP TABLE IF EXISTS `voice_log`;
CREATE TABLE `voice_log`  (
  `voice_id` int NOT NULL AUTO_INCREMENT,
  `elder_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `voice_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `response_content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `interact_time` datetime NOT NULL,
  PRIMARY KEY (`voice_id` DESC) USING BTREE,
  INDEX `fk_voice_relation_elder`(`elder_id` ASC) USING BTREE,
  CONSTRAINT `fk_voice_relation_elder` FOREIGN KEY (`elder_id`) REFERENCES `elder` (`elder_username`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '语音交互日志，记录下老人与AI对话内容，可调用聊天内容检查有无极端念头' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of voice_log
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
