-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.19-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for dgdiary
DROP DATABASE IF EXISTS `dgdiary`;
CREATE DATABASE IF NOT EXISTS `dgdiary` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `dgdiary`;

-- Dumping structure for table dgdiary.captcha
DROP TABLE IF EXISTS `captcha`;
CREATE TABLE IF NOT EXISTS `captcha` (
  `captcha_id` bigint(13) unsigned NOT NULL AUTO_INCREMENT,
  `captcha_time` int(10) unsigned NOT NULL,
  `ip_address` varchar(16) NOT NULL DEFAULT '0',
  `word` varchar(20) NOT NULL,
  PRIMARY KEY (`captcha_id`),
  KEY `word` (`word`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- Dumping data for table dgdiary.captcha: 5 rows
/*!40000 ALTER TABLE `captcha` DISABLE KEYS */;
INSERT INTO `captcha` (`captcha_id`, `captcha_time`, `ip_address`, `word`) VALUES
	(1, 1385347163, '::1', '1SujK3kR'),
	(2, 1386468305, '::1', 'VAuiftTl'),
	(3, 1386468329, '::1', 'IEQXBTAl'),
	(4, 1386469414, '::1', 'N8OC9qjh'),
	(5, 1386471031, '::1', 'xn04okF1');
/*!40000 ALTER TABLE `captcha` ENABLE KEYS */;

-- Dumping structure for table dgdiary.ci_sessions
DROP TABLE IF EXISTS `ci_sessions`;
CREATE TABLE IF NOT EXISTS `ci_sessions` (
  `session_id` varchar(40) NOT NULL DEFAULT '0',
  `ip_address` varchar(45) NOT NULL DEFAULT '0',
  `user_agent` varchar(120) NOT NULL DEFAULT '0',
  `username` varchar(50) NOT NULL DEFAULT 'nobody',
  `firstname` varchar(50) NOT NULL DEFAULT '0',
  `lastname` varchar(50) NOT NULL DEFAULT '0',
  `logged_in` int(5) NOT NULL DEFAULT 0,
  `last_activity` int(10) unsigned NOT NULL DEFAULT 0,
  `user_data` text DEFAULT NULL,
  `passkey` varchar(34) DEFAULT NULL,
  PRIMARY KEY (`session_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Dumping data for table dgdiary.ci_sessions: 3 rows
/*!40000 ALTER TABLE `ci_sessions` DISABLE KEYS */;
INSERT INTO `ci_sessions` (`session_id`, `ip_address`, `user_agent`, `username`, `firstname`, `lastname`, `logged_in`, `last_activity`, `user_data`, `passkey`) VALUES
	('1c085e7800d531137535ab7583a8d094', '::1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36', 'nobody', '0', '0', 0, 1424345750, '', NULL),
	('9865a6a4e9d424106da6b820ca31c7f3', '::1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36', 'nobody', '0', '0', 0, 1424345750, '', NULL),
	('d43c6854bdef7d2869fd5a488837cb43', '::1', 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.63 Safari/537.36', 'nobody', '0', '0', 0, 1421429505, '', NULL);
/*!40000 ALTER TABLE `ci_sessions` ENABLE KEYS */;

-- Dumping structure for table dgdiary.contacts
DROP TABLE IF EXISTS `contacts`;
CREATE TABLE IF NOT EXISTS `contacts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `companyName` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `firstname1` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastname1` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `firstname2` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastname2` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phonenumber1` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phonenumber2` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email1` varchar(300) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email2` varchar(300) COLLATE utf8_unicode_ci DEFAULT NULL,
  `companyaddr1` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `companyaddr2` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `companyaddr3` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `companyaddr4` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping data for table dgdiary.contacts: 0 rows
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;

-- Dumping structure for table dgdiary.dailydiary
DROP TABLE IF EXISTS `dailydiary`;
CREATE TABLE IF NOT EXISTS `dailydiary` (
  `UniqueID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dailydate` datetime DEFAULT NULL,
  `dailybrief` varchar(512) COLLATE utf8_unicode_ci DEFAULT 'no entry',
  `dailyentry` longtext COLLATE utf8_unicode_ci DEFAULT NULL,
  `userid` int(10) unsigned DEFAULT NULL,
  `dailyprivateentry` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `private` int(11) DEFAULT NULL,
  `DateInserted` datetime DEFAULT NULL,
  `DateUpdated` datetime DEFAULT NULL,
  PRIMARY KEY (`UniqueID`)
) ENGINE=MyISAM AUTO_INCREMENT=4083 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping structure for table dgdiary.diaryusers
DROP TABLE IF EXISTS `diaryusers`;
CREATE TABLE IF NOT EXISTS `diaryusers` (
  `userid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `nickname` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `username` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'nobody',
  `firstname` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `lastname` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `emailaddress` varchar(512) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contactnumber` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `passkey` varchar(34) COLLATE utf8_unicode_ci NOT NULL,
  `created` datetime DEFAULT NULL,
  `updated` datetime DEFAULT NULL,
  `Permission` varchar(50) COLLATE utf8_unicode_ci DEFAULT 'VIEW',
  `Gender` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='This table will store all details about the diary user.';

-- Dumping data for table dgdiary.diaryusers: 2 rows
/*!40000 ALTER TABLE `diaryusers` DISABLE KEYS */;
INSERT INTO `diaryusers` (`userid`, `nickname`, `username`, `firstname`, `lastname`, `emailaddress`, `password`, `contactnumber`, `passkey`, `created`, `updated`, `Permission`, `Gender`) VALUES
	(1, 'Guest1', 'Guest1', 'Guest1', '', 'guest@someemail.com', '', 'phone number', '', NULL, NULL, 'VIEW', NULL);

DROP TABLE IF EXISTS `events`;
CREATE TABLE IF NOT EXISTS `events` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eventName` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `eventDatetime` datetime NOT NULL,
  `eventBrief` text COLLATE utf8_unicode_ci NOT NULL,
  `eventDetail` longtext COLLATE utf8_unicode_ci NOT NULL,
  `userid` int(10) unsigned NOT NULL DEFAULT 0,
  `contactid` int(10) unsigned NOT NULL DEFAULT 0,
  `dailyid` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping structure for table dgdiary.tbloperatorcomputers
DROP TABLE IF EXISTS `tbloperatorcomputers`;
CREATE TABLE IF NOT EXISTS `tbloperatorcomputers` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ComputerName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `WorkstationName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Location` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IPv4Addr` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IPv6Addr` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ComputerSpecification` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `Comments` text COLLATE utf8_unicode_ci DEFAULT NULL,
  `InUse` int(11) DEFAULT 0,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='This is a table that contains details of all the computers that are used to run the Asset Register software on it.';

-- Dumping structure for table dgdiary.tbloperatorsonline
DROP TABLE IF EXISTS `tbloperatorsonline`;
CREATE TABLE IF NOT EXISTS `tbloperatorsonline` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(10) unsigned DEFAULT 0,
  `Username` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `EmpNo` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Firstname` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `Lastname` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ComputerName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `WorkstationName` varchar(50) COLLATE utf8_unicode_ci DEFAULT '#',
  `Location` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IPv4Addr` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IPv6Addr` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SessionID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccessRights` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LogInDatetime` datetime DEFAULT '1900-01-01 01:00:00',
  `LogOffDatetime` datetime DEFAULT '1900-01-01 01:00:00',
  `IsLoggedIn` int(11) DEFAULT 0,
  `LoggedInDuration` varchar(50) COLLATE utf8_unicode_ci DEFAULT '0 Mins',
  `Comments` text COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table to record all Operators who are currently online with their log-in location / area and IP Address and Computer details such as name and workstation number.\r\nDate and Time of log in and log out. Emp No and NAME.';

-- Dumping structure for table dgdiary.tblsessions
DROP TABLE IF EXISTS `tblsessions`;
CREATE TABLE IF NOT EXISTS `tblsessions` (
  `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `UserID` int(10) unsigned DEFAULT 0,
  `Username` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ComputerName` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IPv4Addr` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `IPv6Addr` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `SessionID` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `AccessRights` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `LogInDateTime` datetime DEFAULT NULL,
  `LogOffDateTime` datetime DEFAULT NULL,
  `IsLoggedIn` int(11) DEFAULT NULL COMMENT '0 = NO and 1 = YES',
  `LoggedInDuration` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

/*!40000 ALTER TABLE `tblsessions` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
