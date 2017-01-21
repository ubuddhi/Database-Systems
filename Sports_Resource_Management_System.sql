-- phpMyAdmin SQL Dump
-- version 4.0.10.10
-- http://www.phpmyadmin.net
--
-- Host: 127.10.143.130:3306
-- Generation Time: Dec 09, 2015 at 03:16 PM
-- Server version: 5.5.45
-- PHP Version: 5.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `SRMS-MOCK`
--
CREATE DATABASE IF NOT EXISTS `SRMS-MOCK` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `SRMS-MOCK`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`adminUyjKkrs`@`127.10.143.130` PROCEDURE `cancel_equip_proc`(IN `mem_id` INT, IN `e_id` INT)
BEGIN

Update SportingEquipmentReservation
set date_canceled=now()
where member_id=mem_id and equipment_id=e_id;

Update SportingEquipment
set availability=availability+1
where resource_id=a_id;
END$$

CREATE DEFINER=`adminUyjKkrs`@`127.10.143.130` PROCEDURE `cancel_proc`(IN `mem_id` INT, IN `a_id` INT)
BEGIN

Update SportingAreaReservation
set date_canceled=now()
where member_id=mem_id and area_id=a_id;

Update SportingArea
set availability='yes'
where resource_id=a_id;
END$$

CREATE DEFINER=`adminUyjKkrs`@`127.10.143.130` PROCEDURE `check_in_area_proc`(IN `mem_id` INT, IN `a_id` INT)
BEGIN

Update SportingAreaReservation 
set check_in_time= Now()
where member_id=mem_id and area=a_id;
END$$

CREATE DEFINER=`adminUyjKkrs`@`127.10.143.130` PROCEDURE `check_in_equipment_proc`(in  mem_id int, in e_id int)
BEGIN

Update SportingEquipmentReservation 
set check_in_time=now()
where member_id=mem_id and equipment_id=e_id;
END$$

CREATE DEFINER=`adminUyjKkrs`@`127.10.143.130` PROCEDURE `check_out_area_proc`(IN `mem_id` INT, IN `a_id` INT)
BEGIN

Update SportingAreaReservation 
set check_out_time=now()
where member_id=mem_id and area_id=a_id;
END$$

CREATE DEFINER=`adminUyjKkrs`@`127.10.143.130` PROCEDURE `check_out_equipment_proc`(in  mem_id int, in e_id int)
BEGIN

Update SportingEquipmentReservation 
set check_out_time=now()
where member_id=mem_id and equipment_id=e_id;
END$$

CREATE DEFINER=`adminUyjKkrs`@`127.10.143.130` PROCEDURE `num_misuse`(in  mem_id int,in a_id int, in s_end DATETIME, s_start DATETIME)
BEGIN
INSERT INTO SportingAreaReservation( area_id,date,member_id,schedule_start,schedule_end) VALUES ( a_id,currdate(),s_start,s_end);
Update SportingArea 
set availability='No'
where resource_id=a_id;
END$$

CREATE DEFINER=`adminUyjKkrs`@`127.10.143.130` PROCEDURE `num_msg`(in mem_id int)
BEGIN
Select count(*) from MisuseReport as mr
Where mr.member_id=mem_id;
END$$

CREATE DEFINER=`adminUyjKkrs`@`127.10.143.130` PROCEDURE `num_report`(IN `mem_id` INT)
BEGIN 
SELECT count( * ) 
FROM MisuseReport
WHERE `MisuseReport`.`member_id` = mem_id;
END$$

CREATE DEFINER=`adminUyjKkrs`@`127.10.143.130` PROCEDURE `num_reservations`( IN memid INT)
BEGIN
SELECT (

SELECT count( * ) 
FROM SportingAreaReservation where SportingAreaReservation.member_id=memid
) + ( 
SELECT count( * ) 
FROM SportingEquipmentReservation where SportingEquipmentReservation.member_id=memid )  AS num_reservation;
END$$

CREATE DEFINER=`adminUyjKkrs`@`127.10.143.130` PROCEDURE `reserve`(IN `mem_id` INT, IN `a_id` INT, IN `s_end` DATETIME, IN `s_start` DATETIME)
BEGIN
INSERT INTO SportingAreaReservation( area_id,date,member_id,schedule_start,schedule_end) VALUES ( a_id,now(),s_start,s_end);
Update SportingArea 
set availability='No'
where resource_id=a_id;
END$$

CREATE DEFINER=`adminUyjKkrs`@`127.10.143.130` PROCEDURE `reserve_equipment`(in  mem_id int,in e_id int, in s_end DATETIME, s_start DATETIME)
BEGIN
INSERT INTO SportingEquipmentReservation( equipment_id,date,member_id,schedule_start,schedule_end) VALUES ( e_id,cnow(),s_start,s_end);
Update SportingEquipment
set availability=availability-1
where resource_id=e_id;
END$$

--
-- Functions
--
CREATE DEFINER=`adminUyjKkrs`@`127.10.143.130` FUNCTION `cancel_policy_1`(member_id INT) RETURNS decimal(10,0)
begin
	declare refund_amount decimal default 0.0;
	
	select t.amount*0.7 into refund_amount
	from Transaction t,SportingAreaReservation s where 
TIMESTAMPDIFF(HOUR,s.date_canceled,s.check_in_time)>24
and t.member_id=s.member_id;

return refund_amount;
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `AccountLock`
--

CREATE TABLE IF NOT EXISTS `AccountLock` (
  `member_id` int(11) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `type` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`member_id`,`start_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `AccountLock`
--

INSERT INTO `AccountLock` (`member_id`, `start_date`, `end_date`, `type`) VALUES
(555555551, '2015-07-28 00:00:00', '2015-08-13 00:00:00', 'TwoMisuses'),
(555555552, '2015-04-16 00:00:00', '2015-05-01 00:00:00', 'Twomisuses'),
(555555555, '2015-11-02 00:00:00', '2015-12-17 00:00:00', 'Twomisuses'),
(800555553, '2015-12-09 00:00:01', '2015-12-27 00:00:02', 'twomisuses'),
(800555554, '2015-12-03 00:00:00', '2015-12-18 00:00:00', 'Twomisuses'),
(800555557, '2015-11-01 00:00:00', '2015-11-15 00:00:00', 'twomisuses'),
(800555558, '2015-11-04 00:00:00', '2015-12-19 00:00:00', 'Twomisuses');

-- --------------------------------------------------------

--
-- Stand-in structure for view `All_Members`
--
CREATE TABLE IF NOT EXISTS `All_Members` (
`ID` int(11)
,`Name` varchar(91)
,`Email_ID` varchar(45)
,`Phone No.` varchar(45)
,`Type` varchar(16)
);
-- --------------------------------------------------------

--
-- Table structure for table `Damage`
--

CREATE TABLE IF NOT EXISTS `Damage` (
  `equipment_id` int(11) NOT NULL,
  `date` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `description` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`equipment_id`,`date`),
  KEY `fk_Damage_Sporting_Equipment_idx` (`equipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Damage`
--

INSERT INTO `Damage` (`equipment_id`, `date`, `description`) VALUES
(1, '2015-10-08 00:00:00', 'cross strings pulled quickly'),
(2, '2015-07-24 00:00:00', 'Lost two of the balls.. now a 8 ball set.'),
(3, '2015-04-12 00:00:00', 'He got to slappin to hard and made a hole'),
(7, '2015-12-01 12:22:43', 'Dude roughed up the stick, made major scratch');

-- --------------------------------------------------------

--
-- Table structure for table `ExternalMember`
--

CREATE TABLE IF NOT EXISTS `ExternalMember` (
  `member_id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `middle_name` varchar(45) DEFAULT NULL,
  `address_1` varchar(45) DEFAULT NULL,
  `address_2` varchar(45) DEFAULT NULL,
  `city` varchar(45) DEFAULT NULL,
  `state` varchar(45) DEFAULT NULL,
  `zip_code` int(11) DEFAULT NULL,
  `phone_num` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `date_of_birth` varchar(45) NOT NULL,
  `registration_date` datetime DEFAULT NULL,
  `card_number` varchar(16) NOT NULL,
  `name_of_card_holder` varchar(50) NOT NULL,
  `cvv` varchar(45) NOT NULL,
  `expiry_date` datetime NOT NULL,
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `member_id_UNIQUE` (`member_id`),
  UNIQUE KEY `ext_mem_idx` (`member_id`),
  KEY `last_name_idx` (`last_name`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=555555560 ;

--
-- Dumping data for table `ExternalMember`
--

INSERT INTO `ExternalMember` (`member_id`, `first_name`, `last_name`, `middle_name`, `address_1`, `address_2`, `city`, `state`, `zip_code`, `phone_num`, `email`, `date_of_birth`, `registration_date`, `card_number`, `name_of_card_holder`, `cvv`, `expiry_date`) VALUES
(555555550, 'hindu', 'gary', 'p', '78 alture road', NULL, 'charlotte', 'NC', 28269, '555-0001', 'hindu@gary.com', '', '2015-03-19 00:00:00', '1011111111111111', 'hindu', '001', '2019-02-01 00:00:00'),
(555555551, 'greg', 'thomp', 'hey', '78 barton creek', NULL, 'charlotte', 'NC', 28262, '555-1111', 'greg@thomp.com', '', '2015-08-04 00:00:00', '1111111111111111', 'greg', '111', '2017-12-06 00:00:00'),
(555555552, 'jery', 'row', 'egg', '89 grig lane', NULL, 'charlotte', 'NC', 28262, '555-1112', 'jery@row.com', '', '2015-08-04 00:00:00', '2111111111111111', 'jery', '222', '2017-12-06 00:00:00'),
(555555553, 'tery', 'brook', 'rye', '09 guty ave', NULL, 'charlotte', 'NC', 28262, '555-1212', 'tery@brook.com', '', '2015-08-02 00:00:00', '3111111111111111', 'tery', '333', '2018-11-02 00:00:00'),
(555555554, 'tom', 'jord', 'pum', '889 geli lane', NULL, 'charlotte', 'NC', 28262, '555-1892', 'tom@jord.com', '', '2015-07-02 00:00:00', '4111111111111111', 'tom', '444', '2019-11-02 00:00:00'),
(555555555, 'john', 'mc', 'desy', '67 kittansett drive', NULL, 'charlotte', 'NC', 28262, '555-5555', 'john@mc.com', '', '2015-01-14 00:00:00', '5111111111111111', 'john', '555', '2018-12-22 00:00:00'),
(555555556, 'happy', 'singh', 'k', '56 tryon street', NULL, 'charlotte', 'NC', 28262, '555-6666', 'happy@singh.com', '', '2015-02-02 00:00:00', '6111111111111111', 'happy', '666', '2019-12-29 00:00:00'),
(555555557, 'john', 'rhode', 'kit', '887 longine drive', NULL, 'charlotte', 'NC', 28262, '555-7777', 'john@rhode.com', '', '2015-02-14 00:00:00', '7111111111111111', 'john', '777', '2019-12-22 00:00:00'),
(555555558, 'brad', 'pitt', 'ary', '544 burham street', NULL, 'charlotte', 'NC', 28262, '555-8888', 'brad@pitt.com', '', '2015-01-02 00:00:00', '8111111111111111', 'brad', '888', '2019-12-29 00:00:00'),
(555555559, 'harry', 'potter', 'james', '89 burling ave', NULL, 'charlotte', 'NC', 28269, '555-9999', 'harry@potter.com', '', '2014-01-23 00:00:00', '9111111111111111', 'harry', '999', '2017-04-18 00:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `InternalMember`
--

CREATE TABLE IF NOT EXISTS `InternalMember` (
  `university_id` int(11) NOT NULL,
  `type` varchar(16) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `middle_name` varchar(45) DEFAULT NULL,
  `last_name` varchar(45) NOT NULL,
  `address_1` varchar(45) DEFAULT NULL,
  `address_2` varchar(45) DEFAULT NULL,
  `city` varchar(45) DEFAULT NULL,
  `state` varchar(45) DEFAULT NULL,
  `zip_code` int(11) DEFAULT NULL,
  `phone_num` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `date_of_birth` date NOT NULL,
  PRIMARY KEY (`university_id`),
  UNIQUE KEY `university_id_UNIQUE` (`university_id`),
  UNIQUE KEY `int_mem_idx` (`university_id`),
  KEY `fk_InternalMember_Member1_idx` (`university_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `InternalMember`
--

INSERT INTO `InternalMember` (`university_id`, `type`, `first_name`, `middle_name`, `last_name`, `address_1`, `address_2`, `city`, `state`, `zip_code`, `phone_num`, `email`, `date_of_birth`) VALUES
(800555551, 'student', 'bob', 'ans', 'evens', '878 kittansett road', NULL, 'charlotte', 'NC', 28269, '555-5990', 'bob@g.com', '0000-00-00'),
(800555552, 'student', 'sarah', 'mc', 'mcDoble', '8909 hyper drive', NULL, 'charlotte', 'NC', 28269, '555-9909', 'sarah@h.com', '0000-00-00'),
(800555553, 'faculty', 'ryan', 'andy', 'smith', '555 madeup ave', NULL, 'charlotte', 'NC', 28269, '555-5501', 'ryan@m.com', '0000-00-00'),
(800555554, 'faculty', 'min', 'wan', 'shin', '555 mcraze ave', NULL, 'charlotte', 'NC', 28269, '555-5588', 'min@w.com', '0000-00-00');

-- --------------------------------------------------------

--
-- Table structure for table `Member`
--

CREATE TABLE IF NOT EXISTS `Member` (
  `member_id` int(11) NOT NULL,
  `account_type` varchar(10) NOT NULL,
  `password` varchar(16) NOT NULL,
  PRIMARY KEY (`member_id`),
  UNIQUE KEY `member_id_UNIQUE` (`member_id`),
  UNIQUE KEY `mem_id_idx` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Member`
--

INSERT INTO `Member` (`member_id`, `account_type`, `password`) VALUES
(555555550, 'external', 'hippo'),
(555555551, 'external', 'kitypo'),
(555555552, 'external', 'lmaos'),
(555555553, 'external', 'lindty'),
(555555554, 'external', 'linkin'),
(555555555, 'external', 'lalala'),
(555555556, 'external', 'kitten'),
(555555557, 'external', 'kolly'),
(555555558, 'external', 'cutten'),
(555555559, 'external', 'kerrty'),
(800555551, 'internal', 'lalala'),
(800555552, 'internal', 'lololo'),
(800555553, 'internal', 'lippy'),
(800555554, 'internal', 'penta'),
(800555555, 'staff', 'lmaoli'),
(800555556, 'staff', 'lallol'),
(800555557, 'staff', 'lakihk'),
(800555558, 'staff', 'kiyte'),
(800555559, 'staff', 'lakery');

-- --------------------------------------------------------

--
-- Table structure for table `Message`
--

CREATE TABLE IF NOT EXISTS `Message` (
  `message_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `reciever_id` int(11) NOT NULL,
  `msg_title` varchar(45) NOT NULL,
  PRIMARY KEY (`message_id`),
  UNIQUE KEY `message_id_UNIQUE` (`message_id`),
  KEY `fk_Message_Member2_idx` (`reciever_id`),
  KEY `fk_Message_Member1` (`sender_id`),
  KEY `msg_idx` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Message`
--

INSERT INTO `Message` (`message_id`, `sender_id`, `reciever_id`, `msg_title`) VALUES
(1, 555555554, 800555555, 'Would like to know about the equipment for sl'),
(2, 555555552, 800555557, 'When is the intramural tournament starting??');

-- --------------------------------------------------------

--
-- Table structure for table `MessageContent`
--

CREATE TABLE IF NOT EXISTS `MessageContent` (
  `associated_message_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `content` varchar(256) NOT NULL,
  `read_status` varchar(10) NOT NULL,
  PRIMARY KEY (`associated_message_id`,`date`),
  KEY `fk_MessageContent_Message1_idx` (`associated_message_id`),
  KEY `msg_content_idx` (`associated_message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `MessageContent`
--

INSERT INTO `MessageContent` (`associated_message_id`, `date`, `content`, `read_status`) VALUES
(1, '2015-06-02 00:00:00', 'There are additional equipment for tournaments but not for regular practice. The equipment for reserving is available on the website.', 'read'),
(1, '2015-06-08 00:00:00', 'I would really appreciate for the concern. Thank you ', 'delivered'),
(2, '2015-04-01 00:00:00', 'It will be starting on 9 September.', ''),
(2, '2015-04-07 00:00:00', 'When will it be out on the website.', 'read');

-- --------------------------------------------------------

--
-- Table structure for table `MisuseReport`
--

CREATE TABLE IF NOT EXISTS `MisuseReport` (
  `description` varchar(128) NOT NULL,
  `date` datetime NOT NULL,
  `member_id` int(11) NOT NULL,
  `university_id` int(11) NOT NULL,
  PRIMARY KEY (`member_id`,`university_id`,`date`),
  KEY `fk_MisuseReport_Staff1_idx` (`university_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `MisuseReport`
--

INSERT INTO `MisuseReport` (`description`, `date`, `member_id`, `university_id`) VALUES
('Lost two of the balls.. now a 8 ball set.', '2015-07-27 00:00:00', 555555551, 800555557),
('He got to slappin to hard and made a hole', '2015-04-14 00:00:00', 555555552, 800555556),
('The shuttlecocks are damaged', '2015-08-01 10:00:00', 555555556, 800555558),
('The tennis racquet strings are broken', '2015-07-07 12:00:00', 555555557, 800555559),
('cross strings pulled quickly', '2015-10-14 00:00:00', 555555559, 800555558);

-- --------------------------------------------------------

--
-- Table structure for table `Repair`
--

CREATE TABLE IF NOT EXISTS `Repair` (
  `area_id` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `description` varchar(45) DEFAULT NULL,
  `cost` double DEFAULT NULL,
  PRIMARY KEY (`area_id`,`date`),
  KEY `fk_Repair_Sporting_Area1_idx` (`area_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Repair`
--

INSERT INTO `Repair` (`area_id`, `date`, `description`, `cost`) VALUES
(1, '2015-04-17 12:15:00', 'Someone got to slappin to hard and made a hol', 224.75),
(3, '2015-06-02 16:32:00', 'Mr. Jordon came by and broke the rim dunking ', 86.74),
(4, '2015-08-01 09:08:00', 'The strings of the tennis racquet are broken', 75),
(5, '2015-04-02 10:18:11', 'The shuttlecocks are damaged ', 50),
(5, '2015-07-29 11:11:00', 'Broken 8 ball set', 70);

-- --------------------------------------------------------

--
-- Table structure for table `SportingArea`
--

CREATE TABLE IF NOT EXISTS `SportingArea` (
  `resource_id` int(11) NOT NULL,
  `maximum_reservation_duration` int(11) NOT NULL,
  `resource_name` varchar(45) NOT NULL,
  `description_long` varchar(128) DEFAULT NULL,
  `description_short` varchar(30) DEFAULT NULL,
  `reservation_cost` double DEFAULT NULL,
  `date_added` datetime DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `availability` varchar(3) DEFAULT 'yes',
  PRIMARY KEY (`resource_id`),
  UNIQUE KEY `resource_id_UNIQUE` (`resource_id`),
  KEY `fk_Sporting_Area_SportingCategory1_idx` (`category_id`),
  KEY `sport_ar_idx` (`resource_id`,`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `SportingArea`
--

INSERT INTO `SportingArea` (`resource_id`, `maximum_reservation_duration`, `resource_name`, `description_long`, `description_short`, `reservation_cost`, `date_added`, `category_id`, `availability`) VALUES
(1, 60, 'SlapStick_Arena1', 'The tournament size slap stick showdown arena', 'slap stick showdown arena', 5, '0000-00-00 00:00:00', 2, 'yes'),
(2, 120, 'SlapStick_Arena2', 'Normal size slap stick arena for moderate slapping action', 'normal slap stick arena', 2.5, '0000-00-00 00:00:00', 2, 'yes'),
(3, 120, 'BBall_Arena1', 'Your normal everyday basketball court', 'normal basketball court', 2.5, '0000-00-00 00:00:00', 3, 'yes'),
(4, 120, 'BBall_Arena2', 'Your (slight worn in) normal everyday basketball court', 'normal (worn in) basketball co', 2.5, '0000-00-00 00:00:00', 3, 'yes'),
(5, 120, 'Tennis_Arena1', 'Your normal everyday tennis court', 'normal tennis court', 2.5, '0000-00-00 00:00:00', 1, 'yes'),
(6, 61, 'Tennis_Arena2', 'Your (slight worn in) normal everyday tennis court', 'normal (worn in) tennis court', 2.5, '0000-00-00 00:00:00', 1, 'yes'),
(7, 30, 'VBall-Arena 1', 'Normal volleyball court with limited time', 'The first volleyball court', 3, '2014-02-01 00:00:00', 4, 'yes'),
(8, 45, 'VBall_Arena 2', 'Volleyball regular court with an extended time', 'Game with some more time', 5, '2014-06-01 00:00:00', 4, 'yes'),
(9, 90, 'Badminton', 'The only badminton court', 'Play it out here', 5, '2013-09-07 00:00:00', 5, 'yes');

-- --------------------------------------------------------

--
-- Table structure for table `SportingAreaReservation`
--

CREATE TABLE IF NOT EXISTS `SportingAreaReservation` (
  `member_id` int(11) NOT NULL,
  `area_id` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `check_in_time` datetime DEFAULT NULL,
  `check_out_time` datetime DEFAULT NULL,
  `scheduled_start` datetime NOT NULL,
  `scheduled_end` datetime DEFAULT NULL,
  `date_canceled` datetime DEFAULT NULL,
  PRIMARY KEY (`member_id`,`area_id`,`scheduled_start`),
  KEY `fk_SportingAreaReservation_SportingArea1_idx` (`area_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `SportingAreaReservation`
--

INSERT INTO `SportingAreaReservation` (`member_id`, `area_id`, `date`, `check_in_time`, `check_out_time`, `scheduled_start`, `scheduled_end`, `date_canceled`) VALUES
(555555552, 4, '2015-10-06 06:10:00', '2015-10-07 11:10:00', '2015-10-07 12:10:00', '2015-10-07 11:15:00', '2015-10-07 12:17:00', '0000-00-00 00:00:00'),
(555555559, 3, '2015-08-15 00:00:00', '2015-08-17 07:00:00', '2015-08-17 08:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '2015-08-16 00:00:00'),
(800555551, 1, '2015-09-16 00:00:00', '2015-09-18 10:00:00', '2015-09-18 12:00:00', '2015-09-16 10:10:00', '2015-09-16 11:55:00', NULL),
(800555555, 8, '2015-11-25 00:00:00', '2015-11-27 12:00:00', '2015-11-27 02:00:00', '2015-11-27 12:30:00', '2015-11-25 01:50:00', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `SportingCategory`
--

CREATE TABLE IF NOT EXISTS `SportingCategory` (
  `category_id` int(11) NOT NULL,
  `name` varchar(45) NOT NULL,
  `description` varchar(45) DEFAULT NULL,
  `governing_staff_id` int(11) NOT NULL,
  PRIMARY KEY (`category_id`),
  KEY `fk_SportingCategory_Staff1_idx` (`governing_staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `SportingCategory`
--

INSERT INTO `SportingCategory` (`category_id`, `name`, `description`, `governing_staff_id`) VALUES
(1, 'Tennis', 'Tennis is a lovely game of wit', 800555555),
(2, 'Slap Stick', 'You take a stick and you slap with it', 800555558),
(3, 'Basketball', 'He shoot... HE SCORES!!', 800555556),
(4, 'Volley Ball', 'strike or push the ball and score points', 800555559),
(5, 'Badminton', 'Aim the projectile to eran points..!!', 800555557);

-- --------------------------------------------------------

--
-- Table structure for table `SportingEquipment`
--

CREATE TABLE IF NOT EXISTS `SportingEquipment` (
  `resource_id` int(11) NOT NULL,
  `maximum_reservation_duration` int(11) NOT NULL,
  `resource_name` varchar(45) NOT NULL,
  `description_long` varchar(128) DEFAULT NULL,
  `description_short` varchar(30) DEFAULT NULL,
  `reservation_cost` double DEFAULT NULL,
  `date_added` datetime DEFAULT NULL,
  `replacement_cost` double DEFAULT NULL,
  `category_id` int(11) NOT NULL,
  `availability` int(2) NOT NULL DEFAULT '5',
  PRIMARY KEY (`resource_id`),
  UNIQUE KEY `resource_id_UNIQUE` (`resource_id`),
  KEY `fk_Sporting_Equipment_SportingCategory1_idx` (`category_id`),
  KEY `sp_equip_idx` (`resource_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `SportingEquipment`
--

INSERT INTO `SportingEquipment` (`resource_id`, `maximum_reservation_duration`, `resource_name`, `description_long`, `description_short`, `reservation_cost`, `date_added`, `replacement_cost`, `category_id`, `availability`) VALUES
(1, 120, 'tennisball_set1', ' a set of balls designed for the sport of tennis, contains 10', '10 tennis ball set', 1, '2014-02-01 06:07:00', 35, 1, 0),
(2, 120, 'tennisball_set2', ' a set of balls designed for the sport of tennis, contains 8', '8 tennis ball set', 1, '2014-08-10 16:59:09', 25, 1, 0),
(3, 120, 'tennisRacket_pair1', 'a pair of tennis rackets (NOT TO BE USED FOR SLAP STICK!)', 'a pair of tennis rackets', 2, '2015-05-01 19:09:04', 80, 1, 0),
(4, 120, 'tennisRacket_single1', 'a tennis racket (NOT TO BE USED FOR SLAP STICK!)', 'a tennis racket', 1, '2014-10-09 09:10:59', 40, 1, 0),
(5, 60, 'basketball1', 'The best basketball we have in stock', 'a basketball', 1, '2014-12-01 19:08:10', 20, 3, 0),
(6, 60, 'basketball2', 'The (second...) best basketball we have in stock', 'a basketball', 1, '2014-05-08 12:09:01', 20, 3, 0),
(7, 90, 'stickOfSlap1', 'A russian made stick of slap (NOT TO BE USED FOR TENNIS!)', 'A single slapstick ', 10, '2014-07-01 10:02:00', 100, 2, 0),
(8, 90, 'stickOfSlap2', 'A russian made stick of slap (NOT TO BE USED FOR TENNIS!)', 'A slapstick', 10, '2014-10-01 11:07:00', 100, 2, 0),
(9, 90, 'ShuttleCock', 'Shuttle cocks for Badminton', 'Shuttle Cock set of 6', 1, '2014-01-02 00:00:00', 25, 5, 0),
(10, 90, 'Badminton Racquet', 'Badminton racquets for doubles', 'Set of 2 Racquets', 2, '2014-02-01 00:00:00', 66, 5, 0),
(11, 45, 'VolleyBall', 'Ball for playing Volleyball', 'A VolleyBall', 2, '2014-05-01 00:00:00', 20, 4, 0),
(12, 50, 'VolleyBall', 'A better Volleyball for professionals ', 'Professional VolleyBall', 4, '2014-04-15 00:00:00', 35, 4, 0),
(13, 100, 'ShuttleCock', 'ShuttleCock for Badminton pro players', 'Set of 10 Shttlecocks', 5, '2014-06-08 00:00:00', 40, 5, 0);

-- --------------------------------------------------------

--
-- Table structure for table `SportingEquipmentReservation`
--

CREATE TABLE IF NOT EXISTS `SportingEquipmentReservation` (
  `member_id` int(11) NOT NULL,
  `equipment_id` int(11) NOT NULL,
  `date` datetime DEFAULT NULL,
  `check_in_time` datetime DEFAULT NULL,
  `check_out_time` datetime DEFAULT NULL,
  `scheduled_start` datetime NOT NULL,
  `scheduled_end` datetime DEFAULT NULL,
  `date_canceled` datetime DEFAULT NULL,
  PRIMARY KEY (`member_id`,`equipment_id`,`scheduled_start`),
  KEY `fk_SportingEquipmentReservation_SportingEquipment1_idx` (`equipment_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `SportingEquipmentReservation`
--

INSERT INTO `SportingEquipmentReservation` (`member_id`, `equipment_id`, `date`, `check_in_time`, `check_out_time`, `scheduled_start`, `scheduled_end`, `date_canceled`) VALUES
(555555552, 5, '0000-00-00 00:00:00', '2020-01-01 00:00:00', '0000-00-00 00:00:00', '0000-00-00 00:00:00', '2020-01-01 00:00:00', '0000-00-00 00:00:00'),
(555555555, 10, '2015-10-15 00:00:00', '2015-10-15 10:00:00', '2015-10-15 10:55:08', '2015-10-15 10:05:00', '2015-10-15 11:05:00', NULL),
(555555555, 13, '2015-10-15 00:00:00', '2015-10-15 10:00:00', '2015-10-15 10:55:08', '2015-10-15 10:05:00', '2015-10-15 11:05:00', NULL),
(800555551, 8, '0000-00-00 00:00:00', NULL, '0000-00-00 00:00:00', '0000-00-00 00:00:00', '2020-01-01 00:00:00', '0000-00-00 00:00:00');

-- --------------------------------------------------------

--
-- Stand-in structure for view `Sport_Description`
--
CREATE TABLE IF NOT EXISTS `Sport_Description` (
`Equipment Name` varchar(45)
,`Sport Category` varchar(45)
,`Area Description` varchar(30)
,`Equipment Description` varchar(30)
);
-- --------------------------------------------------------

--
-- Table structure for table `Staff`
--

CREATE TABLE IF NOT EXISTS `Staff` (
  `university_id` int(11) NOT NULL,
  `role` varchar(10) NOT NULL,
  `password` varchar(16) NOT NULL,
  `first_name` varchar(45) NOT NULL,
  `last_name` varchar(45) NOT NULL,
  `middle_name` varchar(45) DEFAULT NULL,
  `address_1` varchar(45) DEFAULT NULL,
  `address_2` varchar(45) DEFAULT NULL,
  `city` varchar(45) DEFAULT NULL,
  `state` varchar(45) DEFAULT NULL,
  `zip_code` int(11) DEFAULT NULL,
  `phone_num` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `date_of_birth` varchar(45) NOT NULL,
  PRIMARY KEY (`university_id`),
  UNIQUE KEY `university_id_UNIQUE` (`university_id`),
  UNIQUE KEY `staff_idx` (`university_id`),
  KEY `fk_Staff_Member1_idx` (`university_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Staff`
--

INSERT INTO `Staff` (`university_id`, `role`, `password`, `first_name`, `last_name`, `middle_name`, `address_1`, `address_2`, `city`, `state`, `zip_code`, `phone_num`, `email`, `date_of_birth`) VALUES
(800555555, 'staff', 'lmaoli', 'lyte', 'boy', 'amby', '555 madeup ave', NULL, 'charlotte', 'NC', 28269, '555-9009', 'lyte@boy.com', 'Now()'),
(800555556, 'staff', 'lallol', 'boy', 'kity', 'anmp', '555 kirty ju', NULL, 'charlotte', 'NC', 28269, '555-5890', 'boy@kity.com', 'Now()'),
(800555557, 'staff', 'lakihk', 'ricky', 'martin', 'anot', '556 greg ave', NULL, 'charlotte', 'NC', 28269, '555-4789', 'ricky@m.com', 'Now()'),
(800555558, 'manager', 'kiyte', 'rick', 'sanchez', 'poli', '908 hyper lane', NULL, 'charlotte', 'NC', 28269, '555-6132', 'rick@s.com', 'Now()'),
(800555559, 'admin', 'lakery', 'morty', 'mort', 'lake', '508 kirant lane', NULL, 'charlotte', 'NC', 28269, '555-6534', 'morty@m.com', 'Now()');

-- --------------------------------------------------------

--
-- Table structure for table `Transaction`
--

CREATE TABLE IF NOT EXISTS `Transaction` (
  `transaction_id` int(11) NOT NULL,
  `member_id` int(11) NOT NULL,
  `amount` double NOT NULL,
  `date` datetime NOT NULL,
  `type` int(11) DEFAULT NULL,
  `description` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`transaction_id`,`member_id`),
  UNIQUE KEY `transaction_id_UNIQUE` (`transaction_id`),
  KEY `fk_Transaction_Member1_idx` (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Transaction`
--

INSERT INTO `Transaction` (`transaction_id`, `member_id`, `amount`, `date`, `type`, `description`) VALUES
(1, 555555552, 3.5, '0000-00-00 00:00:00', 1, 'External resv fee (1 items, 1 area)'),
(2, 555555559, 20, '2015-08-18 04:17:25', 1, 'Reservation payment'),
(3, 800555555, 86.74, '2015-06-08 10:45:12', 2, 'Jordon came by and broke the rim dunking and '),
(4, 555555551, 70, '2015-08-01 00:00:00', 2, 'The 8 ball set is being replaced'),
(6, 555555552, 224.75, '2015-04-25 00:00:00', 2, 'Someone got to slappin to hard and made a hol');

-- --------------------------------------------------------

--
-- Structure for view `All_Members`
--
DROP TABLE IF EXISTS `All_Members`;

CREATE ALGORITHM=UNDEFINED DEFINER=`adminUyjKkrs`@`127.10.143.130` SQL SECURITY DEFINER VIEW `All_Members` AS select `InternalMember`.`university_id` AS `ID`,concat(`InternalMember`.`first_name`,' ',`InternalMember`.`last_name`) AS `Name`,`InternalMember`.`email` AS `Email_ID`,`InternalMember`.`phone_num` AS `Phone No.`,`InternalMember`.`type` AS `Type` from `InternalMember` union all select `ExternalMember`.`member_id` AS `ID`,concat(`ExternalMember`.`first_name`,' ',`ExternalMember`.`last_name`) AS `Name`,`ExternalMember`.`email` AS `Email_ID`,`ExternalMember`.`phone_num` AS `Phone No.`,(select 'external') AS `Type` from `ExternalMember`;

-- --------------------------------------------------------

--
-- Structure for view `Sport_Description`
--
DROP TABLE IF EXISTS `Sport_Description`;

CREATE ALGORITHM=UNDEFINED DEFINER=`adminUyjKkrs`@`127.10.143.130` SQL SECURITY DEFINER VIEW `Sport_Description` AS select `se`.`resource_name` AS `Equipment Name`,`sc`.`name` AS `Sport Category`,`sa`.`description_short` AS `Area Description`,`se`.`description_short` AS `Equipment Description` from ((`SportingEquipment` `se` join `SportingCategory` `sc`) join `SportingArea` `sa` on(((`se`.`category_id` = `sc`.`category_id`) and (`sa`.`resource_id` = `se`.`resource_id`)))) group by `se`.`resource_name` order by 2,1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `AccountLock`
--
ALTER TABLE `AccountLock`
  ADD CONSTRAINT `fk_AccountLock_Member1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`member_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Damage`
--
ALTER TABLE `Damage`
  ADD CONSTRAINT `fk_Damage_Sporting_Equipment` FOREIGN KEY (`equipment_id`) REFERENCES `SportingEquipment` (`resource_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `ExternalMember`
--
ALTER TABLE `ExternalMember`
  ADD CONSTRAINT `fk_ExternalMember_Member1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`member_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `InternalMember`
--
ALTER TABLE `InternalMember`
  ADD CONSTRAINT `fk_member_id` FOREIGN KEY (`university_id`) REFERENCES `Member` (`member_id`) ON UPDATE NO ACTION;

--
-- Constraints for table `Message`
--
ALTER TABLE `Message`
  ADD CONSTRAINT `fk_Message_Member1` FOREIGN KEY (`sender_id`) REFERENCES `Member` (`member_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_Message_Member2` FOREIGN KEY (`reciever_id`) REFERENCES `Member` (`member_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `MessageContent`
--
ALTER TABLE `MessageContent`
  ADD CONSTRAINT `fk_MessageContent_Message1` FOREIGN KEY (`associated_message_id`) REFERENCES `Message` (`message_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `MisuseReport`
--
ALTER TABLE `MisuseReport`
  ADD CONSTRAINT `fk_MisuseReport_Member1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`member_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_MisuseReport_Staff1` FOREIGN KEY (`university_id`) REFERENCES `Staff` (`university_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Repair`
--
ALTER TABLE `Repair`
  ADD CONSTRAINT `fk_Repair_Sporting_Area1` FOREIGN KEY (`area_id`) REFERENCES `SportingArea` (`resource_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `SportingArea`
--
ALTER TABLE `SportingArea`
  ADD CONSTRAINT `fk_Sporting_Area_SportingCategory1` FOREIGN KEY (`category_id`) REFERENCES `SportingCategory` (`category_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `SportingAreaReservation`
--
ALTER TABLE `SportingAreaReservation`
  ADD CONSTRAINT `fk_SportingAreaReservation_Member1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`member_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_SportingAreaReservation_SportingArea1` FOREIGN KEY (`area_id`) REFERENCES `SportingArea` (`resource_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `SportingCategory`
--
ALTER TABLE `SportingCategory`
  ADD CONSTRAINT `fk_SportingCategory_Staff1` FOREIGN KEY (`governing_staff_id`) REFERENCES `Staff` (`university_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `SportingEquipment`
--
ALTER TABLE `SportingEquipment`
  ADD CONSTRAINT `fk_Sporting_Equipment_SportingCategory1` FOREIGN KEY (`category_id`) REFERENCES `SportingCategory` (`category_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `SportingEquipmentReservation`
--
ALTER TABLE `SportingEquipmentReservation`
  ADD CONSTRAINT `fk_SportingAreaReservation_Member10` FOREIGN KEY (`member_id`) REFERENCES `Member` (`member_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_SportingEquipmentReservation_SportingEquipment1` FOREIGN KEY (`equipment_id`) REFERENCES `SportingEquipment` (`resource_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Staff`
--
ALTER TABLE `Staff`
  ADD CONSTRAINT `fk_Staff_Member1` FOREIGN KEY (`university_id`) REFERENCES `Member` (`member_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `Transaction`
--
ALTER TABLE `Transaction`
  ADD CONSTRAINT `fk_Transaction_Member1` FOREIGN KEY (`member_id`) REFERENCES `Member` (`member_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
