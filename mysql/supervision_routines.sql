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
-- Temporary table structure for view `view_host_option`
--

DROP TABLE IF EXISTS `view_host_option`;
/*!50001 DROP VIEW IF EXISTS `view_host_option`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `view_host_option` (
  `host_name_key` tinyint NOT NULL,
  `_WINDOWS_EXCLUDED_AUTO_SERVICES` tinyint NOT NULL,
  `_DOMAIN` tinyint NOT NULL,
  `_CHECK_HTTP_URI` tinyint NOT NULL,
  `_WINDOWS_MEM_WARN` tinyint NOT NULL,
  `_WINDOWS_MEM_CRIT` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `view_hosts`
--

DROP TABLE IF EXISTS `view_hosts`;
/*!50001 DROP VIEW IF EXISTS `view_hosts`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `view_hosts` (
  `host_name` tinyint NOT NULL,
  `alias` tinyint NOT NULL,
  `realm` tinyint NOT NULL,
  `address` tinyint NOT NULL,
  `use` tinyint NOT NULL,
  `hostgroups` tinyint NOT NULL,
  `notes` tinyint NOT NULL,
  `notes_url` tinyint NOT NULL,
  `host_name_key` tinyint NOT NULL,
  `_WINDOWS_EXCLUDED_AUTO_SERVICES` tinyint NOT NULL,
  `_DOMAIN` tinyint NOT NULL,
  `_CHECK_HTTP_URI` tinyint NOT NULL,
  `_WINDOWS_MEM_WARN` tinyint NOT NULL,
  `_WINDOWS_MEM_CRIT` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `view_host_option`
--

/*!50001 DROP TABLE IF EXISTS `view_host_option`*/;
/*!50001 DROP VIEW IF EXISTS `view_host_option`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `view_host_option` AS select `host_option`.`host_name_key` AS `host_name_key`,max(if((`host_option`.`option_name` = '_WINDOWS_EXCLUDED_AUTO_SERVICES'),`host_option`.`option_value`,NULL)) AS `_WINDOWS_EXCLUDED_AUTO_SERVICES`,max(if((`host_option`.`option_name` = '_DOMAIN'),`host_option`.`option_value`,NULL)) AS `_DOMAIN`,max(if((`host_option`.`option_name` = '_CHECK_HTTP_URI'),`host_option`.`option_value`,NULL)) AS `_CHECK_HTTP_URI`,max(if((`host_option`.`option_name` = '_WINDOWS_MEM_WARN'),`host_option`.`option_value`,NULL)) AS `_WINDOWS_MEM_WARN`,max(if((`host_option`.`option_name` = '_WINDOWS_MEM_CRIT'),`host_option`.`option_value`,NULL)) AS `_WINDOWS_MEM_CRIT` from `host_option` group by `host_option`.`host_name_key` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `view_hosts`
--

/*!50001 DROP TABLE IF EXISTS `view_hosts`*/;
/*!50001 DROP VIEW IF EXISTS `view_hosts`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `view_hosts` AS select `h`.`host_name` AS `host_name`,`h`.`alias` AS `alias`,`h`.`realm` AS `realm`,`h`.`address` AS `address`,group_concat(distinct `ht`.`template` separator ',') AS `use`,group_concat(distinct `hg`.`hostgroups` separator ',') AS `hostgroups`,`hi`.`notes` AS `notes`,`hi`.`notes_url` AS `notes_url`,`ho`.`host_name_key` AS `host_name_key`,`ho`.`_WINDOWS_EXCLUDED_AUTO_SERVICES` AS `_WINDOWS_EXCLUDED_AUTO_SERVICES`,`ho`.`_DOMAIN` AS `_DOMAIN`,`ho`.`_CHECK_HTTP_URI` AS `_CHECK_HTTP_URI`,`ho`.`_WINDOWS_MEM_WARN` AS `_WINDOWS_MEM_WARN`,`ho`.`_WINDOWS_MEM_CRIT` AS `_WINDOWS_MEM_CRIT` from ((((`hosts` `h` left join `host_template` `ht` on((`h`.`host_name` = `ht`.`host_name`))) left join `view_host_option` `ho` on((`h`.`host_name` = `ho`.`host_name_key`))) left join `host_groups` `hg` on((`h`.`host_name` = `hg`.`host_name`))) left join `hostextinfo` `hi` on((`h`.`host_name` = `hi`.`host_name`))) group by `h`.`host_name` */;
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

-- Dump completed on 2013-12-31 11:38:16
