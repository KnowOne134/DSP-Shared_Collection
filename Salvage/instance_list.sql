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
INSERT INTO `instance_list` VALUES (62,'zhayolm_remnants',72,100,340.000,0.000,-592.000,192,-1,-1,-1,-1);

INSERT INTO `instance_list` VALUES (65,'arrapago_remnants',72,100,340.000,0.000,-246.000,63,-1,-1,-1,-1);

INSERT INTO `instance_list` VALUES (68,'bhaflau_remnants',72,100,340.000,19.000,-552.000,191,-1,-1,-1,-1);

INSERT INTO `instance_list` VALUES (71,'silver_sea_remnants',72,100,340.000,12.000,-165.500,63,-1,-1,-1,-1);

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
