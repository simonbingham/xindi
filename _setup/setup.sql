-- --------------------------------------------------------
-- Host:                         192.168.1.3
-- Server version:               5.1.44-community - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL version:             7.0.0.4053
-- Date/time:                    2012-04-19 14:04:40
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET FOREIGN_KEY_CHECKS=0 */;

-- Dumping structure for table xindi.pages
CREATE TABLE IF NOT EXISTS `pages` (
  `page_id` int(11) NOT NULL AUTO_INCREMENT,
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

-- Dumping data for table xindi.pages: ~1 rows (approximately)
/*!40000 ALTER TABLE `pages` DISABLE KEYS */;
INSERT INTO `pages` (`page_id`, `page_left`, `page_right`, `page_title`, `page_navigationtitle`, `page_content`, `page_metatitle`, `page_metadescription`, `page_metakeywords`, `page_created`, `page_updated`) VALUES
	(1, 1, 2, 'Welcome', 'Home', ' ', ' ', ' ', ' ', '2012-04-19 12:57:03', '2012-04-19 12:57:06');
/*!40000 ALTER TABLE `pages` ENABLE KEYS */;
/*!40014 SET FOREIGN_KEY_CHECKS=1 */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
