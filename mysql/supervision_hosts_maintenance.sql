CREATE DATABASE  IF NOT EXISTS `supervision` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_general_ci */;
USE `supervision`;
-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: stru-shinken-s012.group.vedior.fr    Database: supervision
-- ------------------------------------------------------
-- Server version	5.5.34-0ubuntu0.12.04.1

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
-- Table structure for table `hosts_maintenance`
--

DROP TABLE IF EXISTS `hosts_maintenance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hosts_maintenance` (
  `host_name` varchar(250) CHARACTER SET latin1 NOT NULL,
  `Sem_1_Maint_xMarxxxx_10-12` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_1_Maint_xMarxxxx_12-14` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_1_Maint_xMarxxx_14-17` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_1_Maint_xMarxxx_22-04` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_1_Maint_xxMerxx_10-12` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_1_Maint_xxMerxx_12-14` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_1_Maint_xxMerxx_14-17` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_1_Maint_xxMerxx_22-04` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_1_Maint_xxxJeux_10-12` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_1_Maint_xxxJeux_12-14` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_1_Maint_xxxJeux_14-17` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_1_Maint_xxxJeux_22-04` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_2_Maint_xMarxxxx_10-12` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_2_Maint_xMarxxxx_12-14` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_2_Maint_xMarxxx_14-17` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_2_Maint_xMarxxx_22-04` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_2_Maint_xxMerxx_10-12` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_2_Maint_xxMerxx_12-14` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_2_Maint_xxMerxx_14-17` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_2_Maint_xxMerxx_22-04` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_2_Maint_xxxJeux_10-12` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_2_Maint_xxxJeux_12-14` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_2_Maint_xxxJeux_14-17` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_2_Maint_xxxJeux_22-04` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_3_Maint_xMarxxxx_12-14` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_3_Maint_xMarxxxx_10-12` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_3_Maint_xMarxxx_14-17` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_3_Maint_xMarxxx_22-04` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_3_Maint_xxMerxx_10-12` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_3_Maint_xxMerxx_12-14` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_3_Maint_xxMerxx_14-17` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_3_Maint_xxMerxx_22-04` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_3_Maint_xxxJeux_10-12` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_3_Maint_xxxJeux_12-14` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_3_Maint_xxxJeux_14-17` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_3_Maint_xxxJeux_22-04` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_4_Maint_xMarxxx_14-17` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_4_Maint_xMarxxx_22-04` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_4_Maint_xMarxxxx_10-12` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_4_Maint_xxMerxx_10-12` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_4_Maint_xxMerxx_12-14` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_4_Maint_xxMerxx_14-17` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_4_Maint_xxMerxx_22-04` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_4_Maint_xxxJeux_10-12` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_4_Maint_xxxJeux_12-14` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_4_Maint_xxxJeux_14-17` tinyint(4) NOT NULL DEFAULT '0',
  `Sem_4_Maint_xxxJeux_22-04` tinyint(4) NOT NULL DEFAULT '0',
  `Maint_ WeekEnd` tinyint(4) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-12-31 11:38:15
