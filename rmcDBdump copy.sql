CREATE DATABASE  IF NOT EXISTS `rmc` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `rmc`;
-- MySQL dump 10.13  Distrib 8.0.33, for macos13 (x86_64)
--
-- Host: localhost    Database: rmc
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company` (
  `comp_id` int NOT NULL AUTO_INCREMENT,
  `comp_name` varchar(100) DEFAULT NULL,
  `address` int DEFAULT NULL,
  PRIMARY KEY (`comp_id`),
  KEY `address` (`address`),
  CONSTRAINT `company_ibfk_1` FOREIGN KEY (`address`) REFERENCES `location` (`location_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company`
--

LOCK TABLES `company` WRITE;
/*!40000 ALTER TABLE `company` DISABLE KEYS */;
INSERT INTO `company` VALUES (1,'JP Morgan Chase & Co.',6),(2,'Accenture',7),(3,'Empire Management Group',8),(4,'Santa Clara Valley Medical Center',9),(5,'Google',10);
/*!40000 ALTER TABLE `company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interview`
--

DROP TABLE IF EXISTS `interview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interview` (
  `interview_id` int NOT NULL AUTO_INCREMENT,
  `int_date` date DEFAULT NULL,
  `position_for` int DEFAULT NULL,
  PRIMARY KEY (`interview_id`),
  KEY `position_for` (`position_for`),
  CONSTRAINT `interview_ibfk_1` FOREIGN KEY (`position_for`) REFERENCES `student_pos` (`position_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interview`
--

LOCK TABLES `interview` WRITE;
/*!40000 ALTER TABLE `interview` DISABLE KEYS */;
INSERT INTO `interview` VALUES (1,'2022-12-06',1),(2,'2024-05-30',2),(3,'2020-12-13',3),(4,'2024-06-10',4),(5,'2024-03-18',5);
/*!40000 ALTER TABLE `interview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job`
--

DROP TABLE IF EXISTS `job`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job` (
  `coop_id` int NOT NULL AUTO_INCREMENT,
  `student_pos` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `company_id` int NOT NULL,
  `salary` float DEFAULT NULL,
  PRIMARY KEY (`coop_id`),
  KEY `student_pos` (`student_pos`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `job_ibfk_1` FOREIGN KEY (`student_pos`) REFERENCES `student_pos` (`position_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `job_ibfk_2` FOREIGN KEY (`company_id`) REFERENCES `company` (`comp_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job`
--

LOCK TABLES `job` WRITE;
/*!40000 ALTER TABLE `job` DISABLE KEYS */;
INSERT INTO `job` VALUES (1,1,'2023-01-03','2023-06-24',1,100432),(2,2,'2024-07-01','2024-12-30',2,104410),(3,3,'2021-01-05','2021-06-26',3,56534),(4,4,'2024-07-02','2024-12-20',4,69521),(5,5,'2024-05-07','2024-08-30',5,76836);
/*!40000 ALTER TABLE `job` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `location` (
  `location_id` int NOT NULL AUTO_INCREMENT,
  `street` varchar(30) DEFAULT NULL,
  `city` varchar(30) DEFAULT NULL,
  `state` char(2) DEFAULT NULL,
  `zip` char(5) DEFAULT NULL,
  PRIMARY KEY (`location_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES (1,'360 Huntington Ave','Boston','MA','2115'),(2,'Massachusetts Hall','Cambridge','MA','2138'),(3,'3141 Chestnut St','Philadelphia','PA','19104'),(4,'450 Serra Mall','Stanford','CA','94305'),(5,'105 Sikes Hall','Clemson','SC','29634'),(6,'270 Park Avenue','New York','NY','10017'),(7,' 888 Boylston St #12','Boston','MA','2199'),(8,'1 Winding Dr STE 202','Philadelphia','PA','19131'),(9,'751 S Bascom Ave','San Jose','CA','95128'),(10,'450 Brickell Ave','Miami','FL','33131');
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `school`
--

DROP TABLE IF EXISTS `school`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `school` (
  `school_id` int NOT NULL AUTO_INCREMENT,
  `school_name` varchar(30) DEFAULT NULL,
  `address` int DEFAULT NULL,
  PRIMARY KEY (`school_id`),
  KEY `address` (`address`),
  CONSTRAINT `school_ibfk_1` FOREIGN KEY (`address`) REFERENCES `location` (`location_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `school`
--

LOCK TABLES `school` WRITE;
/*!40000 ALTER TABLE `school` DISABLE KEYS */;
INSERT INTO `school` VALUES (1,'Northeastern University',1),(2,'Harvard University',2),(3,'Drexel University',3),(4,'Stanford University',4),(5,'Clemson University',5);
/*!40000 ALTER TABLE `school` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `student_id` int NOT NULL,
  `first_name` varchar(30) DEFAULT NULL,
  `last_name` varchar(30) DEFAULT NULL,
  `grad_year` char(4) DEFAULT NULL,
  `major` varchar(60) DEFAULT NULL,
  `school_attending` int DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  KEY `school_attending` (`school_attending`),
  CONSTRAINT `student_ibfk_1` FOREIGN KEY (`school_attending`) REFERENCES `school` (`school_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES (1111,'Mary','Smith','2025','Business Administration',2),(2222,'John','Collins','2026','Computer Science',3),(3333,'Sarah','Hunt','2024','Communications',5),(4444,'David','Lee','2025','Biology',4),(5555,'Jacob','Kelly','2026','Computer Engineering',1);
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_company_review`
--

DROP TABLE IF EXISTS `student_company_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_company_review` (
  `company_rev_id` int NOT NULL AUTO_INCREMENT,
  `company_id` int DEFAULT NULL,
  `reviewed_by` int DEFAULT NULL,
  `location_rating` int DEFAULT NULL,
  `facilities_rating` int DEFAULT NULL,
  `work_env_rating` int DEFAULT NULL,
  `food_rating` int DEFAULT NULL,
  `safety_rating` int DEFAULT NULL,
  `community_rating` int DEFAULT NULL,
  `overall_rating` int DEFAULT NULL,
  `comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`company_rev_id`),
  KEY `company_id` (`company_id`),
  KEY `reviewed_by` (`reviewed_by`),
  CONSTRAINT `student_company_review_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`comp_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `student_company_review_ibfk_2` FOREIGN KEY (`reviewed_by`) REFERENCES `student` (`student_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_company_review`
--

LOCK TABLES `student_company_review` WRITE;
/*!40000 ALTER TABLE `student_company_review` DISABLE KEYS */;
INSERT INTO `student_company_review` VALUES (1,1,1111,7,9,8,10,8,9,9,'Really enjoyed working here. The team was great and I learned a lot. I made a lot of good connections and would like to continue working for this company if I had the chance.'),(2,2,2222,9,8,6,9,7,7,8,'I feel like I learned a lot from this opportunity, both about the work I wanted to do and the team I wanted to work with. Although we got the work done, I didn’t LOVE my team.'),(3,3,3333,6,9,7,8,8,8,7,'The job itself was great but I think it showed me what I didn’t want to do in the future which made it a little less enjoyable for me.'),(4,4,4444,8,8,7,5,5,6,6,'I learned a lot but the hours were long and sometimes I felt like I was left with all the grunt work.'),(5,5,5555,10,10,9,9,10,9,10,'I LOVED this job! I felt like it gave me really good insight into what my career path could look like and I felt like I gained a lot of skills from this job.');
/*!40000 ALTER TABLE `student_company_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_coop_tracker`
--

DROP TABLE IF EXISTS `student_coop_tracker`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_coop_tracker` (
  `pid` int DEFAULT NULL,
  `sid` int DEFAULT NULL,
  KEY `pid` (`pid`),
  KEY `sid` (`sid`),
  CONSTRAINT `student_coop_tracker_ibfk_1` FOREIGN KEY (`pid`) REFERENCES `student_pos` (`position_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `student_coop_tracker_ibfk_2` FOREIGN KEY (`sid`) REFERENCES `student` (`student_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_coop_tracker`
--

LOCK TABLES `student_coop_tracker` WRITE;
/*!40000 ALTER TABLE `student_coop_tracker` DISABLE KEYS */;
INSERT INTO `student_coop_tracker` VALUES (1,1111),(2,2222),(3,3333),(4,4444),(5,5555);
/*!40000 ALTER TABLE `student_coop_tracker` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_interview_review`
--

DROP TABLE IF EXISTS `student_interview_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_interview_review` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `interview_id` int DEFAULT NULL,
  `difficulty_rating` int DEFAULT NULL,
  `casual_rating` int DEFAULT NULL,
  `length` varchar(15) DEFAULT NULL,
  `overall_rating` int DEFAULT NULL,
  `interviewed_by` varchar(30) DEFAULT NULL,
  `reviewed_by` int DEFAULT NULL,
  `comments` varchar(500) DEFAULT NULL,
  `position_id` int DEFAULT NULL,
  PRIMARY KEY (`review_id`),
  KEY `interview_id` (`interview_id`),
  KEY `position_id` (`position_id`),
  KEY `reviewed_by` (`reviewed_by`),
  CONSTRAINT `student_interview_review_ibfk_1` FOREIGN KEY (`interview_id`) REFERENCES `interview` (`interview_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `student_interview_review_ibfk_2` FOREIGN KEY (`position_id`) REFERENCES `student_pos` (`position_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `student_interview_review_ibfk_3` FOREIGN KEY (`reviewed_by`) REFERENCES `student` (`student_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_interview_review`
--

LOCK TABLES `student_interview_review` WRITE;
/*!40000 ALTER TABLE `student_interview_review` DISABLE KEYS */;
INSERT INTO `student_interview_review` VALUES (1,1,10,3,'9',8,'Alex Russo',1111,'The interview was pretty hard. You definitely need to be prepared with answers and have practiced interview questions for your field. They are looking for not only smart candidates on paper, but in person too.',1),(2,2,9,3,'7',9,'Harry Muggle',2222,'I really enjoyed speaking with my interviewer. I felt like they challenged me with the questions but I also felt like I was prepared to answer them. Overall, I think I did well on connecting with the interviewer.',2),(3,3,7,5,'7',9,'Morgan Wallace',3333,'The interview was more relaxed and I felt like I was able to chat with the interviewer more. Definitely come with questions!!',3),(4,4,7,4,'9',8,'Morgan Richard',4444,'The interviewer asked a lot about my past experience so make sure you can talk it up.',4),(5,5,10,2,'9',8,'Ollie Jordan',5555,'I had to prepare A LOT for this interview. Especially for the technical aspect of it. I needed to practice for that part so that I wouldn’t freeze in person. If you’re going for a technical role, you will definitely have to do a technical interview as well.',5),(6,1,10,4,'6',6,'Bella Jeffords',1111,'Very terrifying process-- three rounds of behavioral, then two technical. Definitely research the company first.',5),(7,2,1,10,'1',10,'Ellen Claremont',2222,'Super laid back interview. One round, and she basically just wanted walkthroughs of my past research.',4),(8,4,5,8,'6',5,'Ricki Mongom',4444,'Interview was fine. Business casual dress for sure, through.',7);
/*!40000 ALTER TABLE `student_interview_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_pos`
--

DROP TABLE IF EXISTS `student_pos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_pos` (
  `position_id` int NOT NULL,
  `position_name` varchar(30) DEFAULT NULL,
  `company` int DEFAULT NULL,
  `supervisor` int DEFAULT NULL,
  `pos_desc` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`position_id`),
  KEY `company` (`company`),
  KEY `supervisor` (`supervisor`),
  CONSTRAINT `student_pos_ibfk_1` FOREIGN KEY (`company`) REFERENCES `company` (`comp_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `student_pos_ibfk_2` FOREIGN KEY (`supervisor`) REFERENCES `supervisor` (`supervisor_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_pos`
--

LOCK TABLES `student_pos` WRITE;
/*!40000 ALTER TABLE `student_pos` DISABLE KEYS */;
INSERT INTO `student_pos` VALUES (1,'Equity Research Analyst',1,5,'Analyzes and provides financial insights on publicly-traded companies and/or sectors to facilitate investment decisions within fund allocations.'),(2,'Data Analyst',2,4,'Responsibilities include the deep analysis of data and then determining the best way to represent it visually to managers and stakeholders.'),(3,'Human Resources',3,2,'Interns maintain the accuracy of employee files, organize and screen CVs and resumes, manage job ads, and assist in the implementation of company policies.'),(4,'Oral Health Coordinator',4,3,'Help people develop goals to improve their oral health. Coordinate care in accordance with a dentists instructions. Help patients navigate the complexities of the health care system. Provide appropriate clinical services, including screenings, fluoride treatments and radiographs.'),(5,'Software Engineer',5,1,'Responsible for contributing to software design and software development. Software Engineer Intern collaborates with other team members in creating secure and reliable software solutions.'),(7,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `student_pos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_position_review`
--

DROP TABLE IF EXISTS `student_position_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_position_review` (
  `position_rev_id` int NOT NULL AUTO_INCREMENT,
  `company_for` int DEFAULT NULL,
  `position_for` int DEFAULT NULL,
  `reviewed_by` int NOT NULL,
  `supervisor` int DEFAULT NULL,
  `supervisor_rating` int DEFAULT NULL,
  `colleague_rating` int DEFAULT NULL,
  `collaborative_rating` int DEFAULT NULL,
  `pay_satisfaction_rating` int DEFAULT NULL,
  `productivity_rating` int DEFAULT NULL,
  `satisfaction_rating` int DEFAULT NULL,
  `overall_rating` int DEFAULT NULL,
  `comments` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`position_rev_id`),
  KEY `company_for` (`company_for`),
  KEY `reviewed_by` (`reviewed_by`),
  KEY `supervisor` (`supervisor`),
  KEY `position_for` (`position_for`),
  CONSTRAINT `student_position_review_ibfk_1` FOREIGN KEY (`company_for`) REFERENCES `company` (`comp_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `student_position_review_ibfk_2` FOREIGN KEY (`reviewed_by`) REFERENCES `student` (`student_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `student_position_review_ibfk_3` FOREIGN KEY (`supervisor`) REFERENCES `supervisor` (`supervisor_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `student_position_review_ibfk_4` FOREIGN KEY (`position_for`) REFERENCES `student_pos` (`position_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_position_review`
--

LOCK TABLES `student_position_review` WRITE;
/*!40000 ALTER TABLE `student_position_review` DISABLE KEYS */;
INSERT INTO `student_position_review` VALUES (1,1,1,1111,5,8,9,10,7,8,9,9,'Felt really supported by my team which was great. I do feel like I could have been paid a little more though for the amount of work I was expected to do.'),(2,2,2,2222,4,9,9,9,8,8,10,9,'My team and I worked really well together and constantly collaborated with eachother on tasks and projects. It made me feel like I had a good community around me.'),(3,3,3,3333,2,9,9,8,8,7,7,8,'The team and my manager were great but I just feel like the position wasn’t the right fit for me so I didn’t fully love what I was doing all the time.'),(4,4,4,4444,3,9,9,8,8,8,8,9,'I really liked the work that my position was meant to do. I just felt a little burnt out towards the end of the program because of the long hours we had.'),(5,5,5,5555,1,10,10,10,9,10,10,10,'My manager was amazing and really guided me with the work I was doing. I felt like I had a mentor looking out for me and also guiding me with my passions and interests in the field.');
/*!40000 ALTER TABLE `student_position_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supervisor`
--

DROP TABLE IF EXISTS `supervisor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supervisor` (
  `supervisor_id` int NOT NULL AUTO_INCREMENT,
  `supervisor_name` varchar(50) DEFAULT NULL,
  `can_contact` tinyint DEFAULT NULL,
  `contact_info` varchar(500) DEFAULT NULL,
  `company_id` int DEFAULT NULL,
  PRIMARY KEY (`supervisor_id`),
  KEY `company_id` (`company_id`),
  CONSTRAINT `supervisor_ibfk_1` FOREIGN KEY (`company_id`) REFERENCES `company` (`comp_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supervisor`
--

LOCK TABLES `supervisor` WRITE;
/*!40000 ALTER TABLE `supervisor` DISABLE KEYS */;
INSERT INTO `supervisor` VALUES (1,'Bella Jeffords',1,'bella.jeffords@google.com',5),(2,'Jacob Grey',0,NULL,4),(3,'Ellen Claremont',0,'ellen_c@accenture.net',2),(4,'Morgan Richard',1,NULL,3),(5,'Alex Russo',1,'999-099-9909, a.russo@jpmcc.com',1);
/*!40000 ALTER TABLE `supervisor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'rmc'
--

--
-- Dumping routines for database 'rmc'
--
/*!50003 DROP PROCEDURE IF EXISTS `reviewComp` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `reviewComp`(
    cid INT,
    rev_by INT,
    location INT,
    facilities INT,
    work_env INT,
    food INT,
    safety INT,
    community INT,
    overall INT,
    comments VARCHAR(500))
BEGIN
		-- insert into company table
        IF ( SELECT comp_id FROM company WHERE comp_id = cid) IS NULL
			THEN INSERT INTO company(comp_id)
            VALUES(cid);
            END IF;
		-- insert into student table
        IF ( SELECT student_id FROM student WHERE student_id = rev_by) IS NULL
			THEN INSERT INTO student(student_id)
            VALUES(rev_by);
            END IF;
		-- insert into student_company_review table
        INSERT INTO student_company_review(company_id, reviewed_by, location_rating, facilities_rating, 
		work_env_rating, food_rating, safety_rating, community_rating, overall_rating, comments)
        VALUES ((SELECT comp_id FROM company WHERE comp_id = cid), 
        (SELECT student_id FROM student WHERE student_id = rev_by), 
        location, facilities, work_eng, food, safety, community, overall, comments);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `reviewCoop` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `reviewCoop`(
    cid INT,
    pos INT, 
    rev_by INT, 
    sup INT,
    sup_rating INT,
    coll_rating INT,
    collaboration INT,
    pay_satisf INT,
    productivity INT,
    satisfaction INT,
    overall INT,
    comments VARCHAR(500))
BEGIN
		-- insert into company table
        IF ( SELECT comp_id FROM company WHERE comp_id = cid) IS NULL
			THEN INSERT INTO company(comp_id)
            VALUES(cid);
            END IF;
        -- insert into supervisor table
        IF ( SELECT supervisor_id FROM supervisor WHERE supervisor_id = sup) IS NULL
			THEN INSERT INTO supervisor(supervisor_id, company_id)
            VALUES(sup, cid);
            END IF;
		-- insert into student table
        IF ( SELECT student_id FROM student WHERE student_id = rev_by) IS NULL
			THEN INSERT INTO student(student_id)
            VALUES(rev_by);
            END IF;
		-- insert into student_coop_tracker table
		INSERT INTO student_coop_tracker(pid, sid)
			VALUES(pos, rev_by);
		-- insert into student_position_review table
        INSERT INTO student_position_review(company_for, position_for, reviewed_by, supervisor, supervisor_rating, 
		colleague_rating, collaborative_rating, pay_satisfaction_rating, productivity_rating, satisfaction_rating, overall_rating, comments)
        VALUES ((SELECT comp_id FROM company WHERE comp_id = cid), 
        (SELECT position_id FROM student_pos WHERE position_id = pos), 
        (SELECT student_id FROM student WHERE student_id = rev_by), 
        (SELECT supervisor_id FROM supervisor WHERE supervisor_id = sup), 
        sup_rating, coll_rating, collaboration, pay_satisf, productivity, satisfaction, overall, comments);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `reviewInt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `reviewInt`(
	int_id INT,
    difficulty INT,
    casual INT, 
    length INT,
    overall INT,
    interviewer VARCHAR(50),
    rev_by INT,
    comments VARCHAR(500),
    pos_id INT)
BEGIN
		-- insert into position table
        IF ( SELECT position_id FROM student_pos WHERE position_id = pos_id) IS NULL
			THEN INSERT INTO student_pos(position_id)
            VALUES(pos_id);
            END IF;
		-- insert into student table
        IF ( SELECT student_id FROM student WHERE student_id = rev_by) IS NULL
			THEN INSERT INTO student(student_id)
            VALUES(rev_by);
            END IF;
		-- insert into interview table
        IF ( SELECT interview_id FROM interview WHERE interview_id = int_id) IS NULL
			THEN INSERT INTO interview(interview_id, position_for)
            VALUES(int_id, pos_id);
            END IF;
		-- insert into student_interview_review table
        INSERT INTO student_interview_review(interview_id, difficulty_rating, casual_rating, length, overall_rating, interviewed_by, reviewed_by, comments, position_id)
        VALUES ((SELECT interview_id FROM interview WHERE interview_id = int_id), difficulty, casual, length, overall, interviewer, 
        (SELECT student_id FROM student WHERE student_id = rev_by), comments, 
        (SELECT position_id FROM student_pos WHERE position_id = pos_id));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-06-21 21:14:04
