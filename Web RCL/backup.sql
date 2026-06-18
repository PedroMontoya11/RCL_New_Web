-- MySQL dump 10.13  Distrib 8.0.45, for Linux (x86_64)
--
-- Host: localhost    Database: liga
-- ------------------------------------------------------
-- Server version	8.0.45-0ubuntu0.24.04.1

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
-- Table structure for table `equipos`
--

DROP TABLE IF EXISTS `equipos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipos` (
  `id_equipo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `victorias` int DEFAULT '0',
  `derrotas` int NOT NULL DEFAULT '0',
  `diferencia_mapas` int NOT NULL,
  `class_color` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id_equipo`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `equipos`
--

LOCK TABLES `equipos` WRITE;
/*!40000 ALTER TABLE `equipos` DISABLE KEYS */;
INSERT INTO `equipos` VALUES (1,'Brotes',5,2,6,'text-warning'),(2,'Icodense',0,7,0,'text-info-emphasis'),(3,'La Divina Papaya',2,5,-6,'text-success'),(4,'Team Sin Jungla',6,1,9,'text-primary'),(5,'Tomas y los Tomaseadores',3,4,-1,'text-danger'),(6,'Runic Fury',5,2,7,'text-morado'),(8,'Black Team',0,7,-14,'text-gris'),(9,'Norteños',3,4,-2,'text-nortenos');
/*!40000 ALTER TABLE `equipos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jornadas`
--

DROP TABLE IF EXISTS `jornadas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jornadas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `jornada` int NOT NULL,
  `local_id` int NOT NULL,
  `visitante_id` int NOT NULL,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_equipo_local` (`local_id`),
  KEY `fk_equipo_visitante` (`visitante_id`),
  CONSTRAINT `fk_equipo_local` FOREIGN KEY (`local_id`) REFERENCES `equipos` (`id_equipo`) ON DELETE CASCADE,
  CONSTRAINT `fk_equipo_visitante` FOREIGN KEY (`visitante_id`) REFERENCES `equipos` (`id_equipo`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jornadas`
--

LOCK TABLES `jornadas` WRITE;
/*!40000 ALTER TABLE `jornadas` DISABLE KEYS */;
INSERT INTO `jornadas` VALUES (1,1,8,6,'2026-02-05','19:00:00'),(2,1,5,9,'2026-02-08','17:00:00'),(3,1,4,3,'2026-02-08','21:15:00'),(4,1,1,2,'2026-02-06','22:00:00'),(5,2,1,4,'2026-02-15','00:00:00'),(6,2,2,5,'2026-02-15','20:00:00'),(7,2,3,6,'2026-02-15','19:00:00'),(8,2,9,8,'2026-02-15','16:00:00'),(9,3,1,5,'2026-02-21','23:00:00'),(10,3,4,6,'2026-02-18','19:00:00'),(11,3,2,8,'2026-02-18','21:30:00'),(12,3,3,9,'2026-02-22','17:00:00'),(13,4,1,6,'2026-03-01','19:00:00'),(14,4,5,8,'2026-03-06','23:30:00'),(15,4,4,9,'2026-02-22','21:15:00'),(16,4,3,2,'2026-03-01','21:00:00'),(17,5,1,8,'2026-03-08','19:00:00'),(18,5,6,9,'2026-03-04','17:00:00'),(19,5,5,3,'2026-03-08','21:30:00'),(20,5,4,2,'2026-03-06','17:00:00'),(21,6,1,9,'2026-03-15','17:00:00'),(22,6,8,3,'2026-03-15','17:00:00'),(23,6,6,2,'2026-03-15','12:00:00'),(24,6,5,4,'2026-03-15','19:00:00'),(25,7,1,3,'2026-03-21','23:00:00'),(26,7,9,2,NULL,NULL),(27,7,8,4,NULL,NULL),(28,7,6,5,'2026-03-20','23:00:00'),(29,8,6,5,'2026-03-28','20:00:00');
/*!40000 ALTER TABLE `jornadas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jugadores`
--

DROP TABLE IF EXISTS `jugadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `jugadores` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre_usuario` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `riot_tag` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `rol` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `equipo_id` int NOT NULL,
  `capi` enum('Sí','No') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `equipo_id` (`equipo_id`),
  CONSTRAINT `jugadores_ibfk_1` FOREIGN KEY (`equipo_id`) REFERENCES `equipos` (`id_equipo`)
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jugadores`
--

LOCK TABLES `jugadores` WRITE;
/*!40000 ALTER TABLE `jugadores` DISABLE KEYS */;
INSERT INTO `jugadores` VALUES (1,'LDP PedroM11','#2319','Top',3,'Sí'),(6,'Reejaas93','#ESP','Top',1,'Sí'),(7,'Ryan Sumouski','#BWIN','Mid',5,'No'),(8,'UsoppEidMubarak','#1824','ADC',5,'No'),(10,'aleineitor','#EUW','Jungla',3,'No'),(11,'G2 RickyDonut3','#donet','Mid',3,'No'),(13,'Alexdemon97','#EUW','Top',3,'No'),(14,'TSJ Kento','#TSJ','ADC',6,'No'),(15,'Ensalada de pote','#3333','Support',5,'Sí'),(16,'ADC masoca','#Spain','ADC',6,'No'),(27,'YoungDagga','#EUW','Top',9,'No'),(29,'Shisunosaske','#EUW','Mid',9,'No'),(30,'yaniarcheron','#4781','ADC',9,'Sí'),(31,'Carli00','#EUW','Support',9,'No'),(32,'KRNOENRIQUE','#KRNO','Top',1,'No'),(33,'Manolito47','#EUW','Jungla',1,'No'),(34,'culebrita','#9119','Mid',1,'No'),(35,'Serker02','#EUW','Mid',1,'No'),(36,'Silver','#Brrr','ADC',1,'No'),(37,'AlisterSG','#EUW','Mid',6,'No'),(39,'Mispa','#666','Support',6,'No'),(40,'Kaneki Ken','#990','Jungla',6,'No'),(42,'JhudeS','#3990','Jungla',5,'No'),(43,'Makushi','#248','Top',5,'No'),(44,'pochitaaaaaaaa','#69691','Top',6,'Sí'),(45,'mata uwus','#EUW','Support',3,'No'),(46,'Dracoviii','#2387','Top',5,'No'),(47,'LDP Uzi','#MRC','ADC',3,'No'),(49,'alexk','#3203','ADC',5,'No'),(50,'Sekky23','#S23','Support',1,'No'),(52,'Gabigoleador8','#6684','Support',3,'No'),(53,'Xehanort7','#KH2','Jungla',9,'No'),(54,'Buzz95','#EUW','Jungla',9,'No'),(55,'lGengisK','#EUW','Polivalente',9,'No'),(56,'JNickF','#EUW','Jungla',5,'No');
/*!40000 ALTER TABLE `jugadores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `match_stats`
--

DROP TABLE IF EXISTS `match_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `match_stats` (
  `id_jugador` int NOT NULL,
  `kills` int unsigned NOT NULL,
  `deaths` int unsigned NOT NULL,
  `assists` int unsigned NOT NULL,
  `cs` int unsigned NOT NULL,
  `dmg` int unsigned NOT NULL,
  `duracion_min` int unsigned NOT NULL,
  `lado` enum('Azul','Rojo') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `win` tinyint(1) NOT NULL,
  `mvp` tinyint(1) NOT NULL,
  KEY `id_jugador` (`id_jugador`),
  CONSTRAINT `fk_jugador` FOREIGN KEY (`id_jugador`) REFERENCES `jugadores` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_jugador_stats` FOREIGN KEY (`id_jugador`) REFERENCES `jugadores` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `match_stats_ibfk_1` FOREIGN KEY (`id_jugador`) REFERENCES `jugadores` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `match_stats`
--

LOCK TABLES `match_stats` WRITE;
/*!40000 ALTER TABLE `match_stats` DISABLE KEYS */;
INSERT INTO `match_stats` VALUES (44,8,2,8,178,21551,21,'Rojo',1,0),(40,5,1,3,192,11094,21,'Rojo',1,0),(16,8,0,3,167,12806,21,'Rojo',1,0),(39,2,3,14,19,5578,21,'Rojo',1,0),(44,7,6,13,158,18445,27,'Rojo',1,0),(40,13,1,17,241,23674,27,'Rojo',1,0),(16,11,2,13,178,23379,27,'Rojo',1,0),(39,2,2,31,22,8681,27,'Rojo',1,1),(33,7,3,6,304,57806,35,'Rojo',0,0),(33,7,7,4,212,37700,37,'Rojo',0,0),(34,2,5,5,286,17648,37,'Rojo',0,0),(34,2,7,3,212,12774,35,'Rojo',0,0),(35,1,7,3,309,16447,37,'Rojo',0,0),(35,2,7,5,278,25140,35,'Rojo',0,0),(36,3,6,1,374,28511,35,'Rojo',0,0),(36,5,4,5,218,19056,37,'Rojo',0,0),(6,0,6,3,26,5000,35,'Rojo',0,0),(6,1,10,4,50,6347,37,'Rojo',0,0),(27,8,9,12,228,35977,48,'Azul',0,0),(27,3,6,13,249,30903,48,'Rojo',0,0),(29,19,6,8,360,73710,48,'Rojo',0,0),(29,5,5,17,370,65089,48,'Azul',0,0),(30,2,3,10,312,20902,48,'Azul',0,0),(30,0,6,6,262,8477,48,'Rojo',0,0),(31,0,5,18,24,6318,48,'Rojo',0,0),(31,1,2,13,19,8376,48,'Azul',0,0),(7,5,4,5,347,33323,48,'Azul',1,0),(7,5,6,18,291,33249,48,'Rojo',1,0),(15,0,4,21,22,9446,48,'Rojo',1,0),(15,3,2,18,44,17034,48,'Azul',1,0),(43,4,10,8,297,23010,48,'Azul',1,0),(43,4,9,17,283,21340,48,'Rojo',1,0),(49,7,6,10,456,50980,48,'Azul',1,1),(49,12,3,15,382,65527,48,'Rojo',1,0),(46,12,5,6,246,38682,48,'Rojo',1,0),(46,6,8,9,286,40230,48,'Rojo',1,0),(14,6,4,8,301,26869,37,'Azul',0,0),(14,16,1,9,199,29100,25,'Rojo',1,0),(14,8,2,5,337,25093,35,'Azul',1,1),(1,4,2,11,244,21180,37,'Rojo',1,0),(1,0,4,0,174,9071,25,'Azul',0,0),(10,2,2,19,236,17876,37,'Rojo',1,0),(10,3,7,1,150,7559,25,'Azul',0,0),(10,1,4,3,192,5675,35,'Rojo',0,0),(11,15,3,6,265,52399,37,'Rojo',1,0),(11,2,2,1,368,17219,35,'Rojo',0,0),(13,2,7,2,193,16206,25,'Azul',0,0),(13,1,5,2,282,13898,35,'Rojo',0,0),(45,0,7,5,10,4233,25,'Azul',0,0),(45,0,5,4,29,4483,35,'Rojo',0,0),(47,2,5,1,273,10244,35,'Rojo',0,0),(32,2,0,5,166,17122,28,'Azul',1,0),(33,4,2,12,204,13963,28,'Azul',1,0),(35,3,2,12,248,16860,28,'Azul',1,0),(36,10,0,13,272,28246,28,'Azul',1,0),(6,6,2,11,40,11503,28,'Azul',1,0),(14,2,4,1,209,1959,28,'Rojo',0,0),(14,14,1,7,248,37554,30,'Azul',1,0),(32,1,7,2,200,16647,30,'Rojo',0,0),(33,2,6,3,197,13223,30,'Rojo',0,0),(35,3,5,2,240,19264,30,'Rojo',0,0),(36,2,6,2,222,17676,30,'Rojo',0,0),(6,0,6,4,45,4138,30,'Rojo',0,0),(32,6,1,6,225,15475,33,'Azul',1,0),(33,4,5,10,218,17837,33,'Azul',1,0),(35,3,2,1,226,9609,33,'Azul',1,0),(36,9,0,6,329,40550,33,'Azul',1,1),(6,0,2,18,26,3497,33,'Azul',1,0),(14,6,3,2,250,23633,33,'Rojo',0,0),(1,3,9,5,234,14965,41,'Rojo',0,0),(10,4,6,8,222,11503,41,'Rojo',0,0),(11,6,5,6,318,29404,41,'Rojo',0,0),(45,0,8,11,30,14461,41,'Rojo',0,0),(44,6,3,18,271,32207,41,'Azul',1,0),(40,16,1,10,336,32209,41,'Azul',1,1),(16,7,4,10,319,24491,41,'Azul',1,0),(39,0,3,28,42,6883,41,'Azul',1,0),(44,8,0,3,321,26293,31,'Rojo',1,0),(40,12,4,9,291,27982,31,'Azul',1,0),(16,4,5,12,197,12253,31,'Rojo',1,0),(39,0,7,18,23,2906,31,'Rojo',1,0),(1,1,3,7,167,28117,31,'Azul',0,0),(10,0,8,14,173,12321,31,'Azul',0,0),(11,2,4,5,265,21416,31,'Azul',0,0),(47,15,4,1,242,44849,31,'Azul',0,0),(45,0,6,13,17,9777,31,'Azul',0,0),(7,3,12,6,233,28791,33,'Rojo',0,0),(49,5,8,6,237,37714,33,'Rojo',0,0),(43,3,5,7,192,18011,33,'Rojo',0,0),(8,5,3,4,235,29168,33,'Rojo',0,0),(15,9,7,8,44,37064,33,'Rojo',0,0),(49,9,5,7,352,34187,39,'Rojo',0,0),(43,5,6,9,229,19514,39,'Rojo',0,0),(7,5,9,3,242,26102,39,'Rojo',0,0),(8,1,5,5,275,30538,39,'Rojo',0,0),(15,1,6,10,29,8968,39,'Rojo',0,0),(27,4,2,7,169,18291,26,'Azul',1,0),(29,5,2,8,236,16561,26,'Azul',1,1),(30,0,1,8,185,2689,26,'Azul',1,0),(31,2,1,10,35,9280,26,'Azul',1,0),(27,6,7,7,176,27144,28,'Rojo',1,0),(29,18,1,8,233,43283,28,'Rojo',1,0),(30,5,1,9,161,9802,28,'Rojo',1,0),(31,0,0,14,12,5087,28,'Rojo',1,0),(14,7,1,11,252,25815,27,'Rojo',1,0),(44,2,3,0,177,8798,27,'Azul',0,0),(40,0,4,5,160,9994,27,'Azul',0,0),(16,3,7,1,225,13104,27,'Azul',0,0),(39,1,6,5,32,4130,27,'Azul',0,0),(14,5,5,5,345,26538,38,'Azul',0,0),(44,7,3,10,288,31686,38,'Rojo',1,0),(40,10,3,8,273,34418,38,'Rojo',1,0),(16,6,2,13,258,28745,38,'Rojo',1,0),(39,0,4,12,24,4879,38,'Rojo',1,0),(14,15,3,8,247,49165,35,'Rojo',1,1),(44,1,4,13,227,29952,35,'Azul',0,0),(40,12,5,10,267,36522,35,'Azul',0,0),(16,6,6,7,248,21074,35,'Azul',0,0),(39,0,8,16,35,3870,35,'Azul',0,0),(32,4,1,10,247,24121,35,'Azul',1,1),(33,7,5,8,248,28016,35,'Azul',1,0),(35,5,3,10,241,25333,35,'Azul',1,0),(36,9,5,9,335,40932,35,'Azul',1,0),(6,0,3,17,28,3526,35,'Azul',1,0),(32,6,6,4,167,17216,29,'Azul',1,0),(33,6,3,14,206,16880,29,'Azul',1,0),(35,4,2,16,188,19418,29,'Azul',1,0),(36,6,2,22,218,34246,29,'Azul',1,0),(6,13,3,7,28,19256,29,'Azul',1,0),(42,1,4,4,310,18285,35,'Rojo',0,0),(43,4,5,8,217,17024,35,'Rojo',0,0),(7,8,7,1,261,24870,35,'Rojo',0,0),(46,3,5,5,223,21797,35,'Rojo',0,0),(15,1,4,10,30,5084,35,'Rojo',0,0),(42,9,8,4,181,26156,29,'Rojo',0,0),(43,3,6,5,165,9386,29,'Rojo',0,0),(7,3,4,5,195,21055,29,'Rojo',0,0),(46,1,10,2,146,8279,29,'Rojo',0,0),(15,0,7,10,20,8957,29,'Rojo',0,0),(14,8,1,3,223,20901,25,'Azul',1,0),(27,2,8,2,133,16284,25,'Rojo',0,0),(29,7,3,0,209,13916,25,'Rojo',0,0),(30,0,3,1,150,5074,25,'Rojo',0,0),(31,0,3,1,24,1364,25,'Rojo',0,0),(27,3,6,4,149,19136,23,'Azul',0,0),(29,4,10,1,156,14759,23,'Azul',0,0),(30,1,9,1,134,5392,23,'Azul',0,0),(31,0,5,4,43,6885,23,'Azul',0,0),(27,1,1,10,175,25909,29,'Azul',1,0),(29,5,0,8,258,23570,29,'Azul',1,0),(30,5,0,4,222,10266,29,'Azul',1,0),(31,3,1,9,31,14339,29,'Azul',1,0),(1,1,1,1,214,21638,29,'Rojo',0,0),(10,1,7,2,186,14627,29,'Rojo',0,0),(11,0,2,0,273,18913,29,'Rojo',0,0),(47,1,4,0,273,13824,29,'Rojo',0,0),(45,0,3,2,17,6928,29,'Rojo',0,0),(13,1,5,13,174,14552,32,'Azul',1,0),(10,3,1,12,205,12092,32,'Azul',1,0),(11,6,0,7,290,20647,32,'Azul',1,0),(45,1,1,16,28,12865,32,'Azul',1,0),(27,2,5,3,226,22286,32,'Rojo',0,0),(29,4,4,0,287,7716,32,'Rojo',0,0),(30,1,7,1,204,5507,32,'Rojo',0,0),(31,0,4,1,28,2370,32,'Rojo',0,0),(27,1,7,6,188,14200,35,'Azul',0,0),(29,4,1,4,351,35053,35,'Azul',0,0),(30,0,5,6,176,10773,35,'Azul',0,0),(31,0,6,7,26,2679,35,'Azul',0,0),(13,7,4,3,218,41367,35,'Rojo',1,0),(10,1,3,11,205,15722,35,'Rojo',1,0),(11,2,1,10,303,13852,35,'Rojo',1,0),(45,6,1,6,35,24133,35,'Rojo',1,0),(14,10,1,6,162,23697,23,'Rojo',1,0),(16,3,7,1,246,10663,30,'Rojo',0,0),(37,3,1,7,220,26443,30,'Rojo',0,0),(44,3,7,5,189,14777,30,'Rojo',0,0),(39,0,5,8,24,4519,30,'Rojo',0,0),(32,0,6,5,181,13001,30,'Azul',1,0),(33,10,1,14,232,17053,30,'Azul',1,1),(35,9,1,12,251,36368,30,'Azul',1,0),(6,0,2,22,24,2866,30,'Azul',1,0),(36,7,2,11,268,43962,30,'Azul',1,0),(1,0,6,1,194,9228,29,'Rojo',0,0),(10,1,6,3,176,5525,29,'Rojo',0,0),(11,2,2,2,269,23787,29,'Rojo',0,0),(47,2,2,3,241,10610,29,'Rojo',0,0),(45,0,2,4,29,3418,29,'Rojo',0,0),(11,2,0,15,368,19922,43,'Azul',0,0),(13,9,4,10,315,40793,43,'Azul',0,0),(10,3,7,8,238,17412,43,'Azul',0,0),(47,10,4,3,304,29688,43,'Azul',0,0),(45,2,5,13,44,24055,43,'Azul',0,0),(16,3,3,7,230,15291,32,'Azul',1,0),(44,2,3,6,203,15267,32,'Azul',1,0),(40,9,1,10,258,27050,32,'Azul',1,0),(39,4,2,12,26,8350,32,'Azul',1,0),(27,4,6,3,216,26356,32,'Rojo',0,0),(53,2,6,9,177,14086,32,'Rojo',0,0),(29,7,5,2,259,24514,32,'Rojo',0,0),(30,0,3,3,162,8980,32,'Rojo',0,0),(31,0,3,6,19,4984,32,'Rojo',0,0),(16,4,0,4,249,18196,27,'Rojo',1,0),(44,8,8,0,199,46399,27,'Rojo',1,1),(40,6,1,8,225,23580,27,'Rojo',1,0),(39,1,2,10,17,5885,27,'Rojo',1,0),(27,4,7,2,148,25247,27,'Azul',0,0),(55,1,3,1,166,9198,27,'Azul',0,0),(29,4,4,2,204,22614,27,'Azul',0,0),(30,2,2,1,200,9357,27,'Azul',0,0),(31,1,3,3,34,5228,27,'Azul',0,0),(14,11,4,6,268,40000,33,'Azul',1,0),(14,10,8,16,384,60828,51,'Rojo',1,0),(43,11,2,7,138,20423,27,'Rojo',1,0),(42,15,3,4,229,19731,27,'Rojo',1,0),(7,13,7,8,166,27658,27,'Rojo',1,1),(49,6,2,12,186,29936,27,'Rojo',1,0),(15,5,4,21,40,18260,27,'Rojo',1,0),(6,2,0,16,20,8513,22,'Rojo',1,0),(36,16,0,4,224,30832,22,'Rojo',1,0),(32,3,4,2,168,11659,22,'Rojo',1,0),(33,5,4,6,187,11047,22,'Rojo',1,0),(35,4,3,7,153,15102,22,'Rojo',1,0),(32,10,2,3,167,24396,21,'Azul',1,0),(33,8,0,2,156,13037,21,'Azul',1,1),(35,8,0,4,154,17638,21,'Azul',1,0),(36,4,0,9,190,15901,21,'Azul',1,0),(6,4,0,8,28,15783,21,'Azul',1,0),(16,0,9,0,32,5116,21,'Rojo',0,0),(1,0,3,6,200,14056,26,'Azul',0,0),(10,5,7,2,152,14030,26,'Azul',0,0),(11,1,1,2,247,6373,26,'Azul',0,0),(47,2,4,1,183,9405,26,'Azul',0,0),(52,0,6,6,16,4198,26,'Azul',0,0),(43,3,3,8,164,14144,26,'Rojo',1,0),(42,9,1,8,215,23489,26,'Rojo',1,0),(7,3,0,5,236,13491,26,'Rojo',1,0),(8,4,1,8,207,19011,26,'Rojo',1,0),(15,2,3,6,33,9684,26,'Rojo',1,0),(13,1,10,5,175,17561,28,'Rojo',0,0),(10,1,7,10,169,11056,28,'Rojo',0,0),(11,6,3,4,237,14697,28,'Rojo',0,0),(47,2,5,6,185,6178,28,'Rojo',0,0),(52,3,5,5,23,4061,28,'Rojo',0,0),(43,8,2,9,149,24623,28,'Azul',1,1),(42,6,5,18,194,22169,28,'Azul',1,0),(7,12,2,5,214,27973,28,'Azul',1,0),(8,4,1,7,227,18194,28,'Azul',1,0),(15,0,3,20,25,5234,28,'Azul',1,0),(44,3,6,12,204,27776,35,'Azul',1,0),(40,13,3,6,304,40777,35,'Azul',1,1),(37,2,3,7,209,21896,35,'Azul',1,0),(16,4,5,5,266,20381,35,'Azul',1,0),(39,1,5,15,25,7355,35,'Azul',1,0),(44,5,12,3,311,31434,43,'Azul',1,0),(40,8,5,9,284,28749,43,'Azul',1,0),(37,9,4,9,321,49294,43,'Azul',1,0),(16,8,2,11,329,37464,43,'Azul',1,0),(39,0,5,21,22,8567,43,'Azul',1,0),(54,2,7,9,222,14618,40,'Azul',0,0),(29,8,5,4,282,29348,40,'Azul',0,0),(55,9,9,7,277,35192,40,'Azul',0,0),(36,12,1,11,264,28963,40,'Rojo',1,0),(33,7,5,16,241,22248,40,'Rojo',1,0),(35,11,3,12,314,26257,40,'Rojo',1,0),(34,3,4,19,230,21404,40,'Rojo',1,0),(6,3,8,22,59,25268,40,'Rojo',1,0),(27,0,9,18,12,12171,40,'Azul',0,0),(54,1,2,17,169,12213,28,'Rojo',1,0),(29,9,0,7,283,20837,28,'Rojo',1,0),(55,8,0,5,229,20162,28,'Rojo',1,0),(27,0,3,19,23,8921,28,'Rojo',1,0),(36,3,4,1,200,16306,28,'Azul',0,0),(33,0,7,5,169,7461,28,'Azul',0,0),(35,2,4,1,210,13772,28,'Azul',0,0),(34,2,3,0,220,18938,28,'Azul',0,0),(6,0,4,4,23,2571,28,'Azul',0,0),(54,7,5,14,265,26084,41,'Azul',1,0),(29,6,5,10,250,31730,41,'Azul',1,0),(55,14,5,11,326,63995,41,'Azul',1,0),(36,3,3,11,311,31532,41,'Rojo',0,0),(33,6,5,12,257,28001,41,'Rojo',0,0),(35,9,5,9,266,38179,41,'Rojo',0,0),(34,4,7,11,242,36712,41,'Rojo',0,0),(6,2,9,11,26,8400,41,'Rojo',0,0),(14,6,6,12,321,54462,43,'Azul',1,0),(43,3,7,8,202,24647,43,'Rojo',0,0),(42,12,9,16,266,58718,43,'Rojo',0,0),(7,7,8,8,326,29140,43,'Rojo',0,0),(46,9,4,10,261,42703,43,'Rojo',0,0),(15,2,9,24,32,11674,43,'Rojo',0,0),(14,16,3,5,197,32530,29,'Azul',1,1),(43,3,8,3,137,17960,29,'Rojo',0,0),(42,6,9,6,158,23054,29,'Rojo',0,0),(7,1,7,9,203,26961,29,'Rojo',0,0),(46,3,10,4,225,15957,29,'Rojo',0,0),(15,2,3,9,15,8017,29,'Rojo',0,0),(37,4,3,10,219,18377,30,'Rojo',1,0),(44,5,3,4,253,37394,30,'Rojo',1,0),(40,7,5,11,229,26863,30,'Rojo',1,0),(39,0,3,8,19,2359,30,'Rojo',1,0),(43,2,5,2,119,37426,30,'Azul',0,0),(42,4,6,5,168,21215,30,'Azul',0,0),(7,2,5,3,211,23784,30,'Azul',0,0),(8,3,3,2,224,36346,30,'Azul',0,0),(15,3,3,4,24,11765,30,'Azul',0,0),(37,6,0,3,220,21777,28,'Azul',1,0),(44,6,3,8,156,22768,28,'Azul',1,1),(40,6,5,12,193,17596,28,'Azul',1,0),(39,1,2,20,17,6698,28,'Azul',1,0),(43,2,5,3,125,14244,28,'Rojo',0,0),(42,6,7,5,149,20049,28,'Rojo',0,0),(7,3,4,0,216,7710,28,'Rojo',0,0),(8,0,4,4,203,15655,28,'Rojo',0,0),(15,1,5,7,38,19134,28,'Rojo',0,0),(1,1,2,4,248,25988,32,'Azul',0,0),(10,2,3,10,187,11427,32,'Azul',0,0),(11,8,3,5,287,38234,32,'Azul',0,0),(47,6,8,6,220,15229,32,'Azul',0,0),(52,2,7,10,22,7364,32,'Azul',0,0),(6,0,2,7,262,23876,32,'Rojo',1,0),(33,6,2,6,228,16233,32,'Rojo',1,0),(35,8,3,5,284,24530,32,'Rojo',1,0),(36,8,4,6,250,25081,32,'Rojo',1,0),(50,1,8,16,34,8275,32,'Rojo',1,0),(1,1,3,0,282,9846,32,'Rojo',0,0),(10,1,5,3,198,10682,32,'Rojo',0,0),(11,2,2,1,303,25405,32,'Rojo',0,0),(47,2,4,2,215,7286,32,'Rojo',0,0),(52,0,5,3,51,14911,32,'Rojo',0,0),(6,3,1,2,286,13245,32,'Azul',1,0),(33,9,0,3,228,29817,32,'Azul',1,1),(35,4,2,4,265,20930,32,'Azul',1,0),(36,3,2,6,289,18727,32,'Azul',1,0),(50,0,1,10,33,3210,32,'Azul',1,0),(37,4,1,10,143,9238,26,'Azul',1,0),(44,6,2,11,176,24045,26,'Azul',1,0),(40,4,1,17,190,10661,26,'Azul',1,0),(14,12,1,10,194,31100,26,'Azul',1,1),(39,1,1,19,17,5996,26,'Azul',1,0),(43,2,6,1,142,7021,26,'Rojo',0,0),(56,2,6,1,104,11733,26,'Rojo',0,0),(7,1,3,1,196,10965,26,'Rojo',0,0),(46,0,8,0,174,6527,26,'Rojo',0,0),(15,0,4,2,26,7448,26,'Rojo',0,0),(37,4,1,8,151,16273,23,'Azul',1,0),(44,11,2,2,156,23593,23,'Azul',1,0),(40,7,0,9,172,6996,23,'Azul',1,0),(14,12,3,9,191,26468,23,'Azul',1,0),(39,4,0,19,27,7549,23,'Azul',1,0),(43,1,9,1,130,12132,23,'Rojo',0,0),(56,2,9,1,108,9436,23,'Rojo',0,0),(7,1,7,1,162,13573,23,'Rojo',0,0),(46,0,8,1,149,9049,23,'Rojo',0,0),(15,2,5,2,30,9802,23,'Rojo',0,0),(37,3,3,4,156,9062,22,'Azul',1,0),(44,10,1,3,169,28208,22,'Azul',1,0),(40,3,1,18,134,8942,22,'Azul',1,0),(14,12,2,3,173,25902,22,'Azul',1,0),(39,0,0,16,13,3311,22,'Azul',1,0),(46,2,7,0,138,9955,22,'Rojo',0,0),(56,1,10,3,90,7157,22,'Rojo',0,0),(7,3,3,1,149,11017,22,'Rojo',0,0),(15,0,4,2,146,4280,22,'Rojo',0,0),(43,1,4,5,30,8720,22,'Rojo',0,0);
/*!40000 ALTER TABLE `match_stats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `partidos`
--

DROP TABLE IF EXISTS `partidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `partidos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `equipo1_id` int NOT NULL,
  `equipo2_id` int NOT NULL,
  `fecha` date NOT NULL,
  `ganador_id` int NOT NULL,
  `resultado` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `equipo1_id` (`equipo1_id`),
  KEY `equipo2_id` (`equipo2_id`),
  KEY `ganador_id` (`ganador_id`),
  CONSTRAINT `partidos_ibfk_1` FOREIGN KEY (`equipo1_id`) REFERENCES `equipos` (`id_equipo`),
  CONSTRAINT `partidos_ibfk_2` FOREIGN KEY (`equipo2_id`) REFERENCES `equipos` (`id_equipo`),
  CONSTRAINT `partidos_ibfk_3` FOREIGN KEY (`ganador_id`) REFERENCES `equipos` (`id_equipo`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `partidos`
--

LOCK TABLES `partidos` WRITE;
/*!40000 ALTER TABLE `partidos` DISABLE KEYS */;
INSERT INTO `partidos` VALUES (1,8,6,'2026-02-05',6,'0-2'),(2,5,9,'2026-02-08',5,'2-0'),(3,1,2,'2026-02-06',2,'0-2'),(4,4,3,'2026-02-08',4,'2-1'),(5,1,4,'2026-02-15',1,'2-1'),(6,9,8,'2026-02-15',9,'2-0'),(7,3,6,'2026-02-15',6,'0-2'),(8,2,5,'2026-02-15',2,'2-0'),(9,4,6,'2026-02-18',4,'2-1'),(10,2,8,'2026-02-18',2,'2-0'),(11,1,5,'2026-02-21',1,'2-0'),(12,3,9,'2026-02-22',3,'2-1'),(13,4,9,'2026-02-22',4,'2-0'),(14,1,6,'2026-03-01',1,'2-0'),(15,3,2,'2026-03-01',2,'0-2'),(16,6,9,'2026-03-04',6,'2-0'),(17,4,2,'2026-03-06',4,'2-0'),(18,5,8,'2026-03-06',5,'2-0'),(19,1,8,'2026-03-08',1,'2-0'),(20,5,3,'2026-03-08',5,'2-0'),(21,6,2,'2026-03-15',6,'2-0'),(22,8,3,'2026-03-15',3,'0-2'),(23,8,4,'0000-00-00',4,'0-2'),(24,1,9,'2026-03-15',9,'1-2'),(25,5,4,'2026-03-15',4,'0-2'),(26,6,5,'2026-03-21',6,'2-0'),(27,9,2,'0000-00-00',9,'2-0'),(28,1,3,'2026-03-21',1,'2-0'),(29,6,5,'2026-03-28',6,'3-0');
/*!40000 ALTER TABLE `partidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `picks_equipos`
--

DROP TABLE IF EXISTS `picks_equipos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `picks_equipos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_equipo` int NOT NULL,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `win` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_equipo` (`id_equipo`),
  CONSTRAINT `fk_equipo_pick` FOREIGN KEY (`id_equipo`) REFERENCES `equipos` (`id_equipo`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=588 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `picks_equipos`
--

LOCK TABLES `picks_equipos` WRITE;
/*!40000 ALTER TABLE `picks_equipos` DISABLE KEYS */;
INSERT INTO `picks_equipos` VALUES (1,6,'Renekton',1),(2,6,'Viego',1),(3,6,'Orianna',1),(4,6,'Kai\'Sa',1),(5,6,'Rell',1),(6,6,'Camille',1),(7,6,'Nocturne',1),(8,6,'Galio',1),(9,6,'Ashe',1),(10,6,'Braum',1),(21,5,'Jax',1),(22,5,'Gwen',1),(23,5,'Ryze',1),(24,5,'Ashe',1),(25,5,'Milio',1),(26,5,'Akali',1),(27,5,'Jarvan',1),(28,5,'Orianna',1),(29,5,'Yunara',1),(30,5,'Braum',1),(31,9,'Xin Zhao',0),(32,9,'Poppy',0),(33,9,'Syndra',0),(34,9,'Sivir',0),(35,9,'Lulu',0),(36,9,'Pantheon',0),(37,9,'Ksante',0),(38,9,'Viktor',0),(39,9,'Smolder',0),(40,9,'Nautilus',0),(51,1,'Swain',0),(52,1,'Lee Sin',0),(53,1,'Yone',0),(54,1,'Seraphine',0),(55,1,'Nautilus',0),(56,1,'Ambessa',0),(57,1,'Xin Zhao',0),(58,1,'Azir',0),(59,1,'Yunara',0),(60,1,'Lulu',0),(76,3,'Malphite',1),(77,3,'Amumu',1),(78,3,'Rumble',1),(79,3,'Caitlyn',1),(80,3,'Nautilus',1),(81,3,'Ornn',0),(82,3,'Wukong',0),(83,3,'Syndra',0),(84,3,'Twitch',0),(85,3,'Lulu',0),(86,3,'Kayle',0),(87,3,'Jarvan',0),(88,3,'Veigar',0),(89,3,'Tristana',0),(90,3,'Leona',0),(96,1,'Malphite',1),(97,1,'Naafiri',1),(98,1,'Ryze',1),(99,1,'Jinx',1),(100,1,'Swain',1),(101,1,'Urgot',0),(102,1,'Gwen',0),(103,1,'Mel',0),(104,1,'Mel',0),(105,1,'Vayne',0),(106,1,'Lissandra',0),(117,1,'Volibear',1),(118,1,'Sylas',1),(119,1,'Ekko',1),(120,1,'Caitlyn',1),(121,1,'Milio',1),(122,3,'Ornn',0),(123,3,'Sejuani',0),(124,3,'Rumble',0),(125,3,'Jinx',0),(126,3,'Morgana',0),(127,6,'Camille',1),(128,6,'Pantheon',1),(129,6,'Orianna',1),(130,6,'Yunara',1),(131,6,'Rell',1),(132,3,'Kennen',0),(133,3,'Jarvan',0),(134,3,'Syndra',0),(135,3,'Miss Fortune',0),(136,3,'Leona',0),(137,6,'Dr. Mundo',1),(138,6,'Diana',1),(139,6,'Lissandra',1),(140,6,'Ashe',1),(141,6,'Braum',1),(147,5,'Irelia',0),(148,5,'Xin Zhao',0),(149,5,'Orianna',0),(150,5,'Ezreal',0),(151,5,'Lux',0),(157,5,'Yone',0),(158,5,'Vi',0),(159,5,'Sylas',0),(160,5,'Ziggs',0),(161,5,'Nautilus',0),(162,9,'Maokai',1),(163,9,'Malphite',1),(164,9,'Malzahar',1),(165,9,'Sivir',1),(166,9,'Zyra',1),(172,9,'Vi',1),(173,9,'Olaf',1),(174,9,'Ahri',1),(175,9,'Seraphine',1),(176,9,'Leona',1),(187,6,'Gwen',0),(188,6,'Sejuani',0),(189,6,'Orianna',0),(190,6,'Kai\'Sa',0),(191,6,'Nautilus',0),(197,6,'Sett',1),(198,6,'Jax',1),(199,6,'Malzahar',1),(200,6,'Smolder',1),(201,6,'Braum',1),(207,6,'Renekton',0),(208,6,'Pantheon',0),(209,6,'Lissandra',0),(210,6,'Sivir',0),(211,6,'Taric',0),(232,1,'Ornn',1),(233,1,'Viego',1),(234,1,'Ryze',1),(235,1,'Kai\'Sa',1),(236,1,'Milio',1),(237,5,'Cho Gath',0),(238,5,'Xin Zhao',0),(239,5,'Syndra',0),(240,5,'Ezreal',0),(241,5,'Rakan',0),(242,1,'Jax',1),(243,1,'Malphite',1),(244,1,'Orianna',1),(245,1,'Taliyah',1),(246,1,'Pantheon',1),(247,5,'Trundle',0),(248,5,'Wukong',0),(249,5,'Ahri',0),(250,5,'Xayah',0),(251,5,'Thresh',0),(281,9,'Rumble',0),(282,9,'Vi',0),(283,9,'Ahri',0),(284,9,'Sivir',0),(285,9,'Nautilus',0),(286,9,'Jayce',0),(287,9,'Dr. Mundo',0),(288,9,'Diana',0),(289,9,'Ashe',0),(290,9,'Seraphine',0),(291,9,'Dr. Mundo',1),(292,9,'Olaf',1),(293,9,'Viktor',1),(294,9,'Miss Fortune',1),(295,9,'Zyra',1),(296,3,'Poppy',0),(297,3,'Amumu',0),(298,3,'Vel Koz',0),(299,3,'Jinx',0),(300,3,'Soraka',0),(301,3,'Sivir',1),(302,3,'Zaahen',1),(303,3,'Nocturne',1),(304,3,'Rumble',1),(305,3,'Morgana',1),(306,9,'KSante',0),(307,9,'Sejuani',0),(308,9,'Cassiopeia',0),(309,9,'Seraphine',0),(310,9,'Leona',0),(311,3,'Kai\'Sa',1),(312,3,'Gnar',1),(313,3,'Maokai',1),(314,3,'Galio',1),(315,3,'Lux',1),(316,9,'Ornn',0),(317,9,'Kindred',0),(318,9,'Ziggs',0),(319,9,'Ashe',0),(320,9,'Milio',0),(322,1,'Mordekaiser',1),(323,1,'Rammus',1),(324,1,'Aurora',1),(325,1,'Caitlyn',1),(326,1,'Milio',1),(327,6,'Ornn',0),(328,6,'Briar',0),(329,6,'Orianna',0),(330,6,'Jinx',0),(331,6,'Rell',0),(332,3,'Gwen',0),(333,3,'Maokai',0),(334,3,'Rumble',0),(335,3,'Miss Fortune',0),(336,3,'Leona',0),(347,3,'Galio',0),(348,3,'Gnar',0),(349,3,'Nocturne',0),(350,3,'Yunara',0),(351,3,'Ahri',0),(352,6,'Ambessa',1),(353,6,'Ashe',1),(354,6,'Rek\'Sai',1),(355,6,'Malzahar',1),(356,6,'Thresh',1),(357,9,'Malphite',0),(358,9,'Jarvan',0),(359,9,'Syndra',0),(360,9,'Sivir',0),(361,9,'Nami',0),(362,6,'Kai\'Sa',1),(363,6,'Sett',1),(364,6,'Diana',1),(365,6,'Galio',1),(366,6,'Braum',1),(367,9,'Dr. Mundo',0),(368,9,'Sylas',0),(369,9,'Naafiri',0),(370,9,'Seraphine',0),(371,9,'Leona',0),(392,5,'Zaahen',1),(393,5,'Volibear',1),(394,5,'Yasuo',1),(395,5,'Yunara',1),(396,5,'Rakan',1),(402,5,'Akali',1),(403,5,'Darius',1),(404,5,'Graves',1),(405,5,'Ezreal',1),(406,5,'Ahri',1),(412,1,'Jax',1),(413,1,'Ambessa',1),(414,1,'Veigar',1),(415,1,'Aphelios',1),(416,1,'Nautilus',1),(422,1,'Yone',1),(423,1,'Viego',1),(424,1,'Anivia',1),(425,1,'Yasuo',1),(426,1,'Neeko',1),(432,3,'Ornn',0),(433,3,'Maokai',0),(434,3,'Vladimir',0),(435,3,'Jinx',0),(436,3,'Nami',0),(437,5,'Shen',1),(438,5,'Zaahen',1),(439,5,'Yasuo',1),(440,5,'Ziggs',1),(441,5,'Neeko',1),(442,3,'Gnar',0),(443,3,'Nocturne',0),(444,3,'Galio',0),(445,3,'Kai\'Sa',0),(446,3,'Nautilus',0),(447,5,'Ambessa',1),(448,5,'Jarvan',1),(449,5,'Ahri',1),(450,5,'Ezreal',1),(451,5,'Braum',1),(452,6,'Shen',1),(453,6,'Diana',1),(454,6,'Galio',1),(455,6,'Yunara',1),(456,6,'Nami',1),(462,6,'Gwen',1),(463,6,'Xin Zhao',1),(464,6,'Viktor',1),(465,6,'Ezreal',1),(466,6,'Braum',1),(472,9,'Gnar',0),(473,9,'Sejuani',0),(474,9,'Ahri',0),(475,9,'Mel',0),(476,9,'Leona',0),(477,1,'Riven',1),(478,1,'Kayn',1),(479,1,'Ryze',1),(480,1,'Seraphine',1),(481,1,'Swain',1),(482,9,'Renekton',1),(483,9,'Maokai',1),(484,9,'Malzahar',1),(485,9,'Kai\'Sa',1),(486,9,'Karma',1),(487,1,'Zaahen',0),(488,1,'Ambessa',0),(489,1,'Zed',0),(490,1,'Syndra',0),(491,1,'Milio',0),(492,9,'Ornn',1),(493,9,'Malphite',1),(494,9,'Viktor',1),(495,9,'Vayne',1),(496,9,'Soraka',1),(497,1,'Sion',0),(498,1,'Sylas',0),(499,1,'Orianna',0),(500,1,'Smolder',0),(501,1,'Nautilus',0),(506,5,'Ambessa',0),(507,5,'Volibear',0),(508,5,'Ahri',0),(509,5,'Xayah',0),(510,5,'Rakan',0),(515,5,'Ornn',0),(516,5,'Poppy',0),(517,5,'Orianna',0),(518,5,'Jinx',0),(519,5,'Lulu',0),(520,6,'Dr. Mundo',1),(521,6,'Rek\'Sai',1),(522,6,'Orianna',1),(523,6,'Lulu',1),(524,5,'Shen',0),(525,5,'Jarvan',0),(526,6,'Smolder',0),(527,5,'Ziggs',0),(528,5,'Renata Glasc',0),(529,6,'Viktor',1),(530,6,'K\'Sante',1),(531,6,'Trundle',1),(532,6,'Nami',1),(533,5,'Ambessa',0),(534,5,'Zaahen',0),(535,5,'Yasuo',0),(536,5,'Ezreal',0),(537,5,'Neeko',0),(538,1,'Ornn',1),(539,1,'Zaahen',1),(540,1,'Aurelion Sol',1),(541,1,'Aphelios',1),(542,1,'Thresh',1),(543,3,'Poppy',0),(544,3,'Sejuani',0),(545,3,'Veigar',0),(546,3,'Caitlyn',0),(547,3,'Nami',0),(548,3,'Irelia',0),(549,3,'Maokai',0),(550,3,'Vel\'Koz',0),(551,3,'Miss Fortune',0),(552,3,'Morgana',0),(553,1,'Cho\'Gath',1),(554,1,'Zed',1),(555,1,'Ryze',1),(556,1,'Yunara',1),(557,1,'Lulu',1),(558,6,'Ornn',1),(559,6,'Vladimir',1),(560,6,'Jarvan',1),(561,6,'Smolder',1),(562,6,'Nami',1),(563,5,'Vayne',0),(564,5,'Rammus',0),(565,5,'Azir',0),(566,5,'Draven',0),(567,5,'Renata Glasc',0),(568,6,'Rumble',1),(569,6,'K\'Sante',1),(570,6,'Zac',1),(571,6,'Yunara',1),(572,6,'Nautilus',1),(573,5,'Irelia',0),(574,5,'Warwick',0),(575,5,'Veigar',0),(576,5,'Caitlyn',0),(577,5,'Ashe',0),(578,6,'Malzahar',1),(579,6,'Gwen',1),(580,6,'Ivern',1),(581,6,'Jinx',1),(582,6,'Braum',1),(583,5,'Akali',0),(584,5,'Nunu y Willump',0),(585,5,'Tristana',0),(586,5,'Xayah',0),(587,5,'Morgana',0);
/*!40000 ALTER TABLE `picks_equipos` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-30 19:53:47
