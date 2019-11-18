-- phpMyAdmin SQL Dump
-- version 3.3.7
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Erstellungszeit: 30. März 2018 um 02:14
-- Server Version: 5.5.27
-- PHP-Version: 5.2.13

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Datenbank: `bdsdemo`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bdsarticle`
--

CREATE TABLE IF NOT EXISTS `bdsarticle` (
  `bdsarticleid` int(11) NOT NULL AUTO_INCREMENT,
  `bdsarticledesc` varchar(50) COLLATE latin1_general_ci NOT NULL,
  `bdsarticleprice` decimal(8,2) NOT NULL,
  PRIMARY KEY (`bdsarticleid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bdscstmr`
--

CREATE TABLE IF NOT EXISTS `bdscstmr` (
  `bdscstmrid` int(11) NOT NULL AUTO_INCREMENT,
  `bdscstmrname` varchar(80) COLLATE latin1_general_ci NOT NULL,
  `bdscstmrfirstname` varchar(80) COLLATE latin1_general_ci DEFAULT NULL,
  `bdscstmrdateofbirth` date DEFAULT NULL,
  `bdscstmrpostcode` varchar(5) COLLATE latin1_general_ci DEFAULT NULL,
  `bdscstmrcity` varchar(50) COLLATE latin1_general_ci DEFAULT NULL,
  `bdscstmrstreet` varchar(50) COLLATE latin1_general_ci DEFAULT NULL,
  `bdscstmrnotice` mediumtext COLLATE latin1_general_ci,
  `bdscstmrtypeid` int(11) DEFAULT NULL,
  `bdscstmrimage` longblob,
  `bdscstmrimageext` varchar(10) COLLATE latin1_general_ci DEFAULT NULL,
  PRIMARY KEY (`bdscstmrid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bdscstmrorder`
--

CREATE TABLE IF NOT EXISTS `bdscstmrorder` (
  `bdscstmrorderid` int(11) NOT NULL AUTO_INCREMENT,
  `bdscstmrordercstmrid` int(11) NOT NULL,
  `bdscstmrorderdate` date NOT NULL,
  PRIMARY KEY (`bdscstmrorderid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bdscstmrorderpos`
--

CREATE TABLE IF NOT EXISTS `bdscstmrorderpos` (
  `bdscstmrorderposid` int(11) NOT NULL AUTO_INCREMENT,
  `bdscstmrorderposorderid` int(11) NOT NULL,
  `bdscstmrorderposquantity` int(11) NOT NULL,
  `bdscstmrorderposartid` int(11) NOT NULL,
  PRIMARY KEY (`bdscstmrorderposid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `bdscstmrtype`
--

CREATE TABLE IF NOT EXISTS `bdscstmrtype` (
  `bdscstmrtypeid` int(11) NOT NULL AUTO_INCREMENT,
  `bdscstmrtypedesc` varchar(30) COLLATE latin1_general_ci NOT NULL,
  PRIMARY KEY (`bdscstmrtypeid`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci AUTO_INCREMENT=3 ;

--
-- Daten für Tabelle `bdscstmrtype`
--

INSERT INTO `bdscstmrtype` (`bdscstmrtypeid`, `bdscstmrtypedesc`) VALUES
(1, 'Supplier'),
(2, 'Customer');
