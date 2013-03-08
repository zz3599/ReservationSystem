-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Mar 08, 2013 at 02:58 AM
-- Server version: 5.5.29
-- PHP Version: 5.3.10-1ubuntu3.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `IndividualProject`
--

-- --------------------------------------------------------

--
-- Table structure for table `EventAssignments`
--

CREATE TABLE IF NOT EXISTS `EventAssignments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `eventid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `adminid` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `done` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `eventid_2` (`eventid`,`userid`),
  KEY `eventid` (`eventid`),
  KEY `userid` (`userid`),
  KEY `adminid` (`adminid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `EventAssignments`
--

INSERT INTO `EventAssignments` (`id`, `eventid`, `userid`, `adminid`, `timestamp`, `done`) VALUES
(1, 1, 4, 1, '2013-03-08 07:50:38', 0),
(2, 2, 4, 1, '2013-03-08 07:51:50', 0),
(3, 2, 3, 1, '2013-03-08 07:53:30', 0);

-- --------------------------------------------------------

--
-- Table structure for table `Events`
--

CREATE TABLE IF NOT EXISTS `Events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `startTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `endTime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `duration` int(11) NOT NULL,
  `numslots` int(11) NOT NULL,
  `location` varchar(30) NOT NULL,
  `supervisor` varchar(20) NOT NULL,
  `title` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `startTime` (`startTime`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `Events`
--

INSERT INTO `Events` (`id`, `startTime`, `endTime`, `duration`, `numslots`, `location`, `supervisor`, `title`) VALUES
(1, '2013-03-09 15:00:00', '2013-03-09 23:00:00', 30, 16, 'CS 2311', 'Michael TA', 'CSE308 Grading'),
(2, '2013-03-08 12:00:00', '2013-03-08 22:00:00', 45, 13, 'CS 2900', 'Howard Taft', '380 Grading');

-- --------------------------------------------------------

--
-- Table structure for table `Reservations`
--

CREATE TABLE IF NOT EXISTS `Reservations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `eventid` int(11) DEFAULT NULL,
  `timereserved` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `startTime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `slotnum` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_event_key` (`userid`,`eventid`),
  KEY `eventid` (`eventid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `Reservations`
--

INSERT INTO `Reservations` (`id`, `userid`, `eventid`, `timereserved`, `startTime`, `slotnum`) VALUES
(1, 3, 2, '2013-03-08 07:54:14', '2013-03-08 21:00:00', 12),
(2, 4, 2, '2013-03-08 07:54:52', '2013-03-08 12:00:00', 0),
(3, 4, 1, '2013-03-08 07:55:00', '2013-03-09 22:30:00', 15);

-- --------------------------------------------------------

--
-- Table structure for table `Users`
--

CREATE TABLE IF NOT EXISTS `Users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(20) DEFAULT NULL,
  `password` varchar(20) DEFAULT NULL,
  `fullname` varchar(50) DEFAULT NULL,
  `usertype` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `Users`
--

INSERT INTO `Users` (`id`, `username`, `password`, `fullname`, `usertype`) VALUES
(1, 'admin', 'admin', 'Administrator', 0),
(2, 'viewer', 'viewer', 'Michael Viewer', 1),
(3, 'user', 'user', 'Joey User', 2),
(4, 'user2', 'user2', 'Kenny User2', 2);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `EventAssignments`
--
ALTER TABLE `EventAssignments`
  ADD CONSTRAINT `EventAssignments_ibfk_1` FOREIGN KEY (`eventid`) REFERENCES `Events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `EventAssignments_ibfk_2` FOREIGN KEY (`userid`) REFERENCES `Users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `EventAssignments_ibfk_3` FOREIGN KEY (`adminid`) REFERENCES `Users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `Reservations`
--
ALTER TABLE `Reservations`
  ADD CONSTRAINT `Reservations_ibfk_4` FOREIGN KEY (`userid`) REFERENCES `Users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `Reservations_ibfk_5` FOREIGN KEY (`eventid`) REFERENCES `Events` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
