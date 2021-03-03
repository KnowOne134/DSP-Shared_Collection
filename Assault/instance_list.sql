-- MySQL dump 10.13  Distrib 5.6.15, for Win64 (x86_64)
--
-- Host: localhost    Database: dspdb
-- ------------------------------------------------------
-- Server version	5.6.15

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `instance_list`
--

DROP TABLE IF EXISTS `instance_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `instance_list` (
  `instanceid` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `instance_name` varchar(35) NOT NULL DEFAULT '',
  `entrance_zone` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `time_limit` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `start_x` float(7,3) NOT NULL DEFAULT '0.000',
  `start_y` float(7,3) NOT NULL DEFAULT '0.000',
  `start_z` float(7,3) NOT NULL DEFAULT '0.000',
  `start_rot` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `music_day` smallint(3) NOT NULL DEFAULT '-1',
  `music_night` smallint(3) NOT NULL DEFAULT '-1',
  `battlesolo` smallint(3) NOT NULL DEFAULT '-1',
  `battlemulti` smallint(3) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`instanceid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `instance_list`
--

LOCK TABLES `instance_list` WRITE;
/*!40000 ALTER TABLE `instance_list` DISABLE KEYS */;
INSERT INTO `instance_list` VALUES (1,'leujaoam_cleansing',79,30,280.000,-7.500,35.000,195,-1,-1,-1,-1);
INSERT INTO `instance_list` VALUES (2,'orichalcum_survey',79,30,-432.000,-27.627,169.000,131,-1,-1,-1,-1);

INSERT INTO `instance_list` VALUES (11,'imperial_agent_rescue',52,30,-20.000,2.276,-405.000,63,-1,-1,-1,-1);
INSERT INTO `instance_list` VALUES (12,'preemptive_strike',52,30,-60.35,-5.0,27.67,46,-1,-1,-1,-1);

INSERT INTO `instance_list` VALUES (21,'excavation_duty',61,30,124.999,-39.309,19.999,0,-1,-1,-1,-1);
INSERT INTO `instance_list` VALUES (22,'lebros_supplies',61,30,-333.000,-9.921,-259.999,270,-1,-1,-1,-1);
INSERT INTO `instance_list` VALUES (23,'troll_fugitives',61,30,-459.912,-9.860,342.319,0,-1,-1,-1,-1);

INSERT INTO `instance_list` VALUES (31,'seagull_grounded',79,30,-350.000,-15.245,380.000,0,-1,-1,-1,-1);
INSERT INTO `instance_list` VALUES (32,'requiem',79,30,-470.000,-9.964,-325.000,190,-1,-1,-1,-1);

INSERT INTO `instance_list` VALUES (41,'golden_salvage',54,30,386.000,-12.000,17.000,46,-1,-1,-1,-1);
INSERT INTO `instance_list` VALUES (42,'lamia_no_13',54,30,155.000,-7.000,-175.000,47,-1,-1,-1,-1);
INSERT INTO `instance_list` VALUES (43,'extermination',54,30,298.099,-3.943,135.234,149,-1,-1,-1,-1);

INSERT INTO `instance_list` VALUES (51,'nyzul_isle_investigation',72,30,-20.000,-4.000,-20.000,196,-1,-1,-1,-1);
/*!40000 ALTER TABLE `instance_list` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-05-28 15:42:27
