-- MySQL dump 10.14  Distrib 5.5.44-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: boh
-- ------------------------------------------------------
-- Server version	5.5.44-MariaDB-1ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `group_id` (`group_id`,`permission_id`),
  KEY `auth_group_permissions_0e939a4f` (`group_id`),
  KEY `auth_group_permissions_8373b171` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `content_type_id` (`content_type_id`,`codename`),
  KEY `auth_permission_417f1b1c` (`content_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_user`
--

DROP TABLE IF EXISTS `auth_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(30) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(30) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_user_groups`
--

DROP TABLE IF EXISTS `auth_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`group_id`),
  KEY `auth_user_groups_e8701ad4` (`user_id`),
  KEY `auth_user_groups_0e939a4f` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auth_user_user_permissions`
--

DROP TABLE IF EXISTS `auth_user_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `user_id` (`user_id`,`permission_id`),
  KEY `auth_user_user_permissions_e8701ad4` (`user_id`),
  KEY `auth_user_user_permissions_8373b171` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `authtoken_token`
--

DROP TABLE IF EXISTS `authtoken_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `authtoken_token` (
  `key` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created` datetime NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`key`),
  UNIQUE KEY `user_id` (`user_id`),
  CONSTRAINT `authtoken_token_user_id_4eb355c53fa4d663_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_activity`
--

DROP TABLE IF EXISTS `boh_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_activity` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(7) NOT NULL,
  `description` longtext NOT NULL,
  `open_date` datetime DEFAULT NULL,
  `close_date` datetime DEFAULT NULL,
  `activity_type_id` int(11) NOT NULL,
  `engagement_id` int(11) NOT NULL,
  `duration` bigint(20),
  PRIMARY KEY (`id`),
  KEY `boh_activity_b6159b48` (`activity_type_id`),
  KEY `boh_activity_cd7ada3b` (`engagement_id`)
) ENGINE=InnoDB AUTO_INCREMENT=632 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_activity_users`
--

DROP TABLE IF EXISTS `boh_activity_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_activity_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `activity_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `activity_id` (`activity_id`,`user_id`),
  KEY `boh_activity_users_f8a3193a` (`activity_id`),
  KEY `boh_activity_users_e8701ad4` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=712 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_activitycomment`
--

DROP TABLE IF EXISTS `boh_activitycomment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_activitycomment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` longtext NOT NULL,
  `created_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `activity_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `boh_activitycomment_f8a3193a` (`activity_id`),
  KEY `boh_activitycomment_e8701ad4` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=457 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_activitytype`
--

DROP TABLE IF EXISTS `boh_activitytype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_activitytype` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `documentation` longtext NOT NULL,
  `created_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_application`
--

DROP TABLE IF EXISTS `boh_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_application` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` longtext NOT NULL,
  `platform` varchar(11) DEFAULT NULL,
  `lifecycle` varchar(8) DEFAULT NULL,
  `origin` varchar(19) DEFAULT NULL,
  `business_criticality` varchar(9) DEFAULT NULL,
  `user_records` int(10) unsigned DEFAULT NULL,
  `revenue` decimal(15,2) DEFAULT NULL,
  `external_audience` tinyint(1) NOT NULL,
  `internet_accessible` tinyint(1) NOT NULL,
  `override_dcl` int(11) DEFAULT NULL,
  `override_reason` longtext NOT NULL,
  `threadfix_application_id` int(10) unsigned DEFAULT NULL,
  `created_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `organization_id` int(11) NOT NULL,
  `threadfix_id` int(11) DEFAULT NULL,
  `threadfix_team_id` int(10) unsigned DEFAULT NULL,
  `requestable` tinyint(1),
  `asvs_doc_url` varchar(200) NOT NULL,
  `asvs_level` int(11),
  `asvs_level_percent_achieved` int(10) unsigned,
  `asvs_level_target` int(11),
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `boh_application_26b2345e` (`organization_id`),
  KEY `boh_application_10b0fcba` (`threadfix_id`)
) ENGINE=InnoDB AUTO_INCREMENT=227 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_application_data_elements`
--

DROP TABLE IF EXISTS `boh_application_data_elements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_application_data_elements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` int(11) NOT NULL,
  `dataelement_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_id` (`application_id`,`dataelement_id`),
  KEY `boh_application_data_elements_6bc0a4eb` (`application_id`),
  KEY `boh_application_data_elements_f6cf0fe7` (`dataelement_id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_application_regulations`
--

DROP TABLE IF EXISTS `boh_application_regulations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_application_regulations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` int(11) NOT NULL,
  `regulation_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_id` (`application_id`,`regulation_id`),
  KEY `boh_application_regulations_6bc0a4eb` (`application_id`),
  KEY `boh_application_regulations_2ceedb79` (`regulation_id`),
  CONSTRAINT `boh_applicati_regulation_id_38b004be87c8d97_fk_boh_regulation_id` FOREIGN KEY (`regulation_id`) REFERENCES `boh_regulation` (`id`),
  CONSTRAINT `boh_applic_application_id_603515e8eadc7f70_fk_boh_application_id` FOREIGN KEY (`application_id`) REFERENCES `boh_application` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_application_service_level_agreements`
--

DROP TABLE IF EXISTS `boh_application_service_level_agreements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_application_service_level_agreements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` int(11) NOT NULL,
  `servicelevelagreement_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_id` (`application_id`,`servicelevelagreement_id`),
  KEY `boh_application_service_level_agreements_6bc0a4eb` (`application_id`),
  KEY `boh_application_service_level_agreements_268dac3b` (`servicelevelagreement_id`),
  CONSTRAINT `b812d652310d20ae922ba57131fd214a` FOREIGN KEY (`servicelevelagreement_id`) REFERENCES `boh_servicelevelagreement` (`id`),
  CONSTRAINT `boh_applic_application_id_3776f299b6c40805_fk_boh_application_id` FOREIGN KEY (`application_id`) REFERENCES `boh_application` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_application_tags`
--

DROP TABLE IF EXISTS `boh_application_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_application_tags` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` int(11) NOT NULL,
  `tag_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_id` (`application_id`,`tag_id`),
  KEY `boh_application_tags_6bc0a4eb` (`application_id`),
  KEY `boh_application_tags_76f094bc` (`tag_id`)
) ENGINE=InnoDB AUTO_INCREMENT=220 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_application_technologies`
--

DROP TABLE IF EXISTS `boh_application_technologies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_application_technologies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `application_id` int(11) NOT NULL,
  `technology_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `application_id` (`application_id`,`technology_id`),
  KEY `boh_application_technologies_6bc0a4eb` (`application_id`),
  KEY `boh_application_technologies_71c5177e` (`technology_id`),
  CONSTRAINT `boh_applicat_technology_id_44894c44513cde24_fk_boh_technology_id` FOREIGN KEY (`technology_id`) REFERENCES `boh_technology` (`id`),
  CONSTRAINT `boh_applic_application_id_747f1311fdf44d7b_fk_boh_application_id` FOREIGN KEY (`application_id`) REFERENCES `boh_application` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_applicationfileupload`
--

DROP TABLE IF EXISTS `boh_applicationfileupload`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_applicationfileupload` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `file_type` varchar(13) NOT NULL,
  `application_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `boh_applicationfileupload_6bc0a4eb` (`application_id`),
  KEY `boh_applicationfileupload_e8701ad4` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_dataelement`
--

DROP TABLE IF EXISTS `boh_dataelement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_dataelement` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) NOT NULL,
  `description` longtext NOT NULL,
  `category` varchar(10) NOT NULL,
  `weight` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_engagement`
--

DROP TABLE IF EXISTS `boh_engagement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_engagement` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `status` varchar(7) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `description` longtext NOT NULL,
  `open_date` datetime DEFAULT NULL,
  `close_date` datetime DEFAULT NULL,
  `created_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `application_id` int(11) NOT NULL,
  `requestor_id` int(11) DEFAULT NULL,
  `duration` bigint(20),
  PRIMARY KEY (`id`),
  KEY `boh_engagement_6bc0a4eb` (`application_id`),
  KEY `boh_engagement_9cf0a9aa` (`requestor_id`)
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_engagementcomment`
--

DROP TABLE IF EXISTS `boh_engagementcomment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_engagementcomment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` longtext NOT NULL,
  `created_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `engagement_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `boh_engagementcomment_cd7ada3b` (`engagement_id`),
  KEY `boh_engagementcomment_e8701ad4` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_environment`
--

DROP TABLE IF EXISTS `boh_environment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_environment` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `environment_type` varchar(4) NOT NULL,
  `description` longtext NOT NULL,
  `testing_approved` tinyint(1) NOT NULL,
  `application_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `boh_environment_6bc0a4eb` (`application_id`)
) ENGINE=InnoDB AUTO_INCREMENT=169 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_environmentcredentials`
--

DROP TABLE IF EXISTS `boh_environmentcredentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_environmentcredentials` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(128) NOT NULL,
  `password` varchar(128) NOT NULL,
  `role_description` varchar(128) NOT NULL,
  `notes` longtext NOT NULL,
  `created_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `environment_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `boh_environmentcredentials_9e06e326` (`environment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_environmentlocation`
--

DROP TABLE IF EXISTS `boh_environmentlocation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_environmentlocation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `location` varchar(200) NOT NULL,
  `notes` longtext NOT NULL,
  `environment_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `boh_environmentlocation_9e06e326` (`environment_id`)
) ENGINE=InnoDB AUTO_INCREMENT=196 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_externalrequest`
--

DROP TABLE IF EXISTS `boh_externalrequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_externalrequest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `token` char(32) COLLATE utf8mb4_unicode_ci NOT NULL,
  `application_id` int(11) NOT NULL,
  `requestor_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `boh_externalrequest_6bc0a4eb` (`application_id`),
  KEY `boh_externalrequest_9cf0a9aa` (`requestor_id`),
  CONSTRAINT `boh_externalreque_requestor_id_13dd84cb002b7b6c_fk_boh_person_id` FOREIGN KEY (`requestor_id`) REFERENCES `boh_person` (`id`),
  CONSTRAINT `boh_extern_application_id_29188eac04852bb4_fk_boh_application_id` FOREIGN KEY (`application_id`) REFERENCES `boh_application` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_externalrequest_activities`
--

DROP TABLE IF EXISTS `boh_externalrequest_activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_externalrequest_activities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `externalrequest_id` int(11) NOT NULL,
  `activitytype_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `externalrequest_id` (`externalrequest_id`,`activitytype_id`),
  KEY `boh_exte_activitytype_id_25feacf441bcd96e_fk_boh_activitytype_id` (`activitytype_id`),
  CONSTRAINT `boh_exte_activitytype_id_25feacf441bcd96e_fk_boh_activitytype_id` FOREIGN KEY (`activitytype_id`) REFERENCES `boh_activitytype` (`id`),
  CONSTRAINT `boh__externalrequest_id_3c457e73151442_fk_boh_externalrequest_id` FOREIGN KEY (`externalrequest_id`) REFERENCES `boh_externalrequest` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_organization`
--

DROP TABLE IF EXISTS `boh_organization`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_organization` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `description` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_organization_people`
--

DROP TABLE IF EXISTS `boh_organization_people`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_organization_people` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `organization_id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `organization_id` (`organization_id`,`person_id`),
  KEY `boh_organization_people_26b2345e` (`organization_id`),
  KEY `boh_organization_people_a8452ca7` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_person`
--

DROP TABLE IF EXISTS `boh_person`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_person` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(64) NOT NULL,
  `last_name` varchar(64) NOT NULL,
  `email` varchar(128) NOT NULL,
  `phone_work` varchar(15) NOT NULL,
  `phone_mobile` varchar(15) NOT NULL,
  `job_title` varchar(128) NOT NULL,
  `role` varchar(17) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `boh_person_email_160cad19b772d273_uniq` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=122 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_regulation`
--

DROP TABLE IF EXISTS `boh_regulation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_regulation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(128) COLLATE utf8mb4_unicode_ci NOT NULL,
  `acronym` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(9) COLLATE utf8mb4_unicode_ci NOT NULL,
  `jurisdiction` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `acronym` (`acronym`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_relation`
--

DROP TABLE IF EXISTS `boh_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_relation` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` tinyint(1) NOT NULL,
  `notes` longtext NOT NULL,
  `application_id` int(11) NOT NULL,
  `person_id` int(11) NOT NULL,
  `emergency` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `boh_relation_person_id_2557cad6aa0f31f2_uniq` (`person_id`,`application_id`),
  KEY `boh_relation_6bc0a4eb` (`application_id`),
  KEY `boh_relation_a8452ca7` (`person_id`)
) ENGINE=InnoDB AUTO_INCREMENT=142 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_servicelevelagreement`
--

DROP TABLE IF EXISTS `boh_servicelevelagreement`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_servicelevelagreement` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_tag`
--

DROP TABLE IF EXISTS `boh_tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_tag` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `color` varchar(6) NOT NULL,
  `description` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_technology`
--

DROP TABLE IF EXISTS `boh_technology`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_technology` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) COLLATE utf8mb4_unicode_ci NOT NULL,
  `category` varchar(21) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `reference` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=109 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_threadfix`
--

DROP TABLE IF EXISTS `boh_threadfix`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_threadfix` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `host` varchar(200) NOT NULL,
  `api_key` varchar(50) NOT NULL,
  `verify_ssl` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `boh_threadfixmetrics`
--

DROP TABLE IF EXISTS `boh_threadfixmetrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `boh_threadfixmetrics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_date` datetime NOT NULL,
  `modified_date` datetime NOT NULL,
  `critical_count` int(10) unsigned NOT NULL,
  `high_count` int(10) unsigned NOT NULL,
  `medium_count` int(10) unsigned NOT NULL,
  `low_count` int(10) unsigned NOT NULL,
  `informational_count` int(10) unsigned NOT NULL,
  `application_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `boh_threadfixmetrics_6bc0a4eb` (`application_id`),
  CONSTRAINT `boh_thread_application_id_1dcf44545bc4dc9e_fk_boh_application_id` FOREIGN KEY (`application_id`) REFERENCES `boh_application` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26374 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_417f1b1c` (`content_type_id`),
  KEY `django_admin_log_e8701ad4` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=135 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_1f4ee9c715f7ee80_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_de54fa62` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-09-15 21:37:56
