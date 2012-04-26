-- --------------------------------------------------------
-- Host:                         192.168.1.3
-- Server version:               5.1.44-community - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL version:             7.0.0.4053
-- Date/time:                    2012-04-26 13:04:50
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;

-- Dumping database structure for xindi
CREATE DATABASE IF NOT EXISTS `xindi` /*!40100 DEFAULT CHARACTER SET utf8 */;
USE `xindi`;


-- Dumping structure for table xindi.pages
CREATE TABLE IF NOT EXISTS `pages` (
  `page_id` int(11) NOT NULL AUTO_INCREMENT,
  `page_uuid` varchar(150) DEFAULT NULL,
  `page_left` int(11) DEFAULT NULL,
  `page_right` int(11) DEFAULT NULL,
  `page_title` varchar(150) DEFAULT NULL,
  `page_navigationtitle` varchar(150) DEFAULT NULL,
  `page_content` longtext,
  `page_metatitle` varchar(200) DEFAULT NULL,
  `page_metadescription` varchar(200) DEFAULT NULL,
  `page_metakeywords` varchar(200) DEFAULT NULL,
  `page_created` datetime DEFAULT NULL,
  `page_updated` datetime DEFAULT NULL,
  PRIMARY KEY (`page_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table xindi.pages: ~0 rows (approximately)
/*!40000 ALTER TABLE `pages` DISABLE KEYS */;
INSERT INTO `pages` (`page_id`, `page_uuid`, `page_left`, `page_right`, `page_title`, `page_navigationtitle`, `page_content`, `page_metatitle`, `page_metadescription`, `page_metakeywords`, `page_created`, `page_updated`) VALUES
	(1, 'home', 1, 2, 'Welcome to Xindi', 'Home', '<p>\r\n	You&#39;ve successfully installed Xindi.</p>\r\n<p>\r\n	All the key elements are here, but this public facing site is a bit ugly. You&#39;ll need to find a designer to make it look nice.</p>\r\n<p>\r\n	The content management system on the other hand is a different story - it&#39;s very sexy and can be <a href="/xindi/admin" target="_blank">accessed here</a> (the username and password are both &#39;admin&#39;).</p>\r\n', 'Welcome to Xindi', 'You&#39;ve successfully installed Xindi. All the key elements are here, but this public facing site is incredibly ugly. You&#39;ll need to find a designer to make this look good. The content managemen', '', '2012-04-22 08:35:17', '2012-04-26 12:46:32');
/*!40000 ALTER TABLE `pages` ENABLE KEYS */;


-- Dumping structure for table xindi.users
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_firstname` varchar(50) DEFAULT NULL,
  `user_lastname` varchar(50) DEFAULT NULL,
  `user_email` varchar(150) DEFAULT NULL,
  `user_username` varchar(50) DEFAULT NULL,
  `user_password` varchar(50) DEFAULT NULL,
  `user_created` datetime DEFAULT NULL,
  `user_updated` datetime DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- Dumping data for table xindi.users: ~0 rows (approximately)
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` (`user_id`, `user_firstname`, `user_lastname`, `user_email`, `user_username`, `user_password`, `user_created`, `user_updated`) VALUES
	(1, 'Simon', 'Bingham', 'me@simonbingham.me.uk', 'admin', 'admin', '2012-04-22 08:39:07', '2012-04-22 08:39:09');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
/*!40014 SET FOREIGN_KEY_CHECKS=1 */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
