-- Rate My Co-op (RMC) Database

DROP DATABASE IF EXISTS rmc;
CREATE DATABASE rmc;

USE rmc;

-- create the tables for the database --

CREATE TABLE location
	( location_id INT PRIMARY KEY AUTO_INCREMENT,
	street VARCHAR(30),
    city VARCHAR(30),
    state CHAR(2),
    zip CHAR(5)
    );

CREATE TABLE school
	( school_id INT PRIMARY KEY AUTO_INCREMENT,
    school_name VARCHAR(30),
	address INT,
    FOREIGN KEY (address) REFERENCES location(location_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
    );

CREATE TABLE student
	( student_id INT PRIMARY KEY,
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    grad_year CHAR(4),
    major VARCHAR(60),
    school_attending INT, 
    FOREIGN KEY (school_attending) REFERENCES school(school_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
    );
    
CREATE TABLE company
	( comp_id INT PRIMARY KEY AUTO_INCREMENT,
    comp_name VARCHAR(100),
    address INT,
    FOREIGN KEY (address) REFERENCES location(location_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
    );
    
CREATE TABLE supervisor
	( supervisor_id INT PRIMARY KEY AUTO_INCREMENT,
    supervisor_name VARCHAR(50),
    can_contact TINYINT,
    contact_info VARCHAR(500),
    company_id INT,
    FOREIGN KEY (company_id) REFERENCES company(comp_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
    );
    
CREATE TABLE student_pos
	( position_id INT PRIMARY KEY,
    position_name VARCHAR(30),
    company INT,
    supervisor INT,
    pos_desc VARCHAR(500),
    FOREIGN KEY (company) REFERENCES company(comp_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (supervisor) REFERENCES supervisor(supervisor_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
    );

CREATE TABLE job
	( coop_id INT PRIMARY KEY AUTO_INCREMENT,
    student_pos INT,
    start_date DATE,
    end_date DATE,
    company_id INT NOT NULL,
    salary FLOAT,
    FOREIGN KEY (student_pos) REFERENCES student_pos(position_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (company_id) REFERENCES company(comp_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
    );
    
CREATE TABLE student_coop_tracker
	( pid INT,
    sid INT,
    FOREIGN KEY (pid) REFERENCES student_pos(position_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (sid) REFERENCES student(student_id));
    
CREATE TABLE interview
	( interview_id INT PRIMARY KEY AUTO_INCREMENT,
    int_date DATE,
    position_for INT,
    FOREIGN KEY (position_for) REFERENCES student_pos(position_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
    );
    
CREATE TABLE student_company_review
	( company_rev_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT,
    reviewed_by INT, 
    location_rating INT,
    facilities_rating INT,
    work_env_rating INT,
    food_rating INT,
    safety_rating INT,
    community_rating INT,
    overall_rating INT,
    comments VARCHAR(500),
    FOREIGN KEY (company_id) REFERENCES company(comp_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (reviewed_by) REFERENCES student(student_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
    );
    
CREATE TABLE student_interview_review
	( review_id INT PRIMARY KEY AUTO_INCREMENT,
    interview_id INT,
    difficulty_rating INT,
    casual_rating INT,
    length VARCHAR(15),
    overall_rating INT,
    interviewed_by VARCHAR(30),
    reviewed_by INT, 
    comments VARCHAR(500),
    position_id INT,
    FOREIGN KEY (interview_id) REFERENCES interview(interview_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (position_id) REFERENCES student_pos(position_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (reviewed_by) REFERENCES student(student_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
    );

CREATE TABLE student_position_review
	( position_rev_id INT PRIMARY KEY AUTO_INCREMENT,
    company_for INT,
    position_for INT, 
    reviewed_by INT NOT NULL, 
    supervisor INT,
    supervisor_rating INT(1),
    colleague_rating INT(1),
    collaborative_rating INT(1),
    pay_satisfaction_rating INT(1),
    productivity_rating INT(1),
    satisfaction_rating INT(1),
    overall_rating INT(1),
    comments VARCHAR(500),
    FOREIGN KEY (company_for) REFERENCES company(comp_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (reviewed_by) REFERENCES student(student_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (supervisor) REFERENCES supervisor(supervisor_id)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY (position_for) REFERENCES student_pos(position_id)
		ON UPDATE CASCADE ON DELETE RESTRICT
    );

-- insert (example) data into the tables --

INSERT INTO location(location_id, street, city, state, zip)
	VALUES(1, '360 Huntington Ave', 'Boston', 'MA', 02115),
    (2, 'Massachusetts Hall', 'Cambridge', 'MA', 02138),
    (3, '3141 Chestnut St', 'Philadelphia', 'PA', 19104),
	(4, '450 Serra Mall', 'Stanford', 'CA', 94305),
	(5, '105 Sikes Hall', 'Clemson', 'SC', 29634),
    (6, '270 Park Avenue', 'New York', 'NY', 10017),
    (7, ' 888 Boylston St #12', 'Boston', 'MA', 02199),
	(8, '1 Winding Dr STE 202', 'Philadelphia', 'PA', 19131),
	(9, '751 S Bascom Ave', 'San Jose', 'CA', 95128),
	(10, '450 Brickell Ave', 'Miami', 'FL', 33131);
    
INSERT INTO school(school_id, school_name, address)
	VALUES(1, 'Northeastern University', 1),
    (2, 'Harvard University', 2),
    (3, 'Drexel University', 3),
    (4, 'Stanford University', 4),
    (5, 'Clemson University', 5);
    
INSERT INTO student(student_id, first_name, last_name, grad_year, major, school_attending)
	VALUES(1111, 'Mary', 'Smith', 2025, 'Business Administration', 2),
    (2222, 'John', 'Collins', 2026, 'Computer Science', 3),
    (3333, 'Sarah', 'Hunt', 2024, 'Communications', 5),
    (4444, 'David', 'Lee', 2025, 'Biology', 4),
    (5555, 'Jacob', 'Kelly', 2026, 'Computer Engineering', 1);
    
INSERT INTO company(comp_id, comp_name, address)
	VALUES(1, 'JP Morgan Chase & Co.', 6),
    (2, 'Accenture', 7),
    (3, 'Empire Management Group', 8),
    (4, 'Santa Clara Valley Medical Center', 9),
    (5, 'Google', 10);

INSERT INTO supervisor(supervisor_id, supervisor_name, can_contact, contact_info, company_id)
	VALUES(1, 'Bella Jeffords', 1, 'bella.jeffords@google.com', 5),
    (2, 'Jacob Grey', 0, NULL, 4),
    (3, 'Ellen Claremont', 0, 'ellen_c@accenture.net', 2),
    (4, 'Morgan Richard', 1, NULL, 3),
    (5, 'Alex Russo', 1, '999-099-9909, a.russo@jpmcc.com', 1);
    
INSERT INTO student_pos(position_id, position_name, company, supervisor, pos_desc)
	VALUES(1, 'Equity Research Analyst', 1, 5, 'Analyzes and provides financial insights on publicly-traded companies and/or sectors to facilitate investment decisions within fund allocations.'),
	(2, 'Data Analyst', 2, 4, 'Responsibilities include the deep analysis of data and then determining the best way to represent it visually to managers and stakeholders.'),
	(3, 'Human Resources', 3, 2, 'Interns maintain the accuracy of employee files, organize and screen CVs and resumes, manage job ads, and assist in the implementation of company policies.'),
	(4, 'Oral Health Coordinator', 4, 3, 'Help people develop goals to improve their oral health. Coordinate care in accordance with a dentists instructions. Help patients navigate the complexities of the health care system. Provide appropriate clinical services, including screenings, fluoride treatments and radiographs.'),
	(5, 'Software Engineer', 5, 1, 'Responsible for contributing to software design and software development. Software Engineer Intern collaborates with other team members in creating secure and reliable software solutions.');
    
INSERT INTO job(coop_id, student_pos, start_date, end_date, company_id, salary)
	VALUES(1, 1, '2023-01-03', '2023-06-24', 1, 100432),
	(2, 2, '2024-07-01', '2024-12-30', 2, 104410),
	(3, 3, '2021-01-05', '2021-06-26', 3, 56534),
	(4, 4, '2024-07-02', '2024-12-20', 4, 69521),
	(5, 5, '2024-05-07', '2024-08-30', 5, 76836);

INSERT INTO interview(interview_id, int_date, position_for)
	VALUES(1, '2022-12-06', 1),
	(2, '2024-05-30', 2),
	(3, '2020-12-13', 3),
	(4, '2024-06-10', 4),
	(5, '2024-03-18', 5);
    
INSERT INTO student_company_review(company_rev_id, company_id, reviewed_by, location_rating, facilities_rating, 
	work_env_rating, food_rating, safety_rating, community_rating, overall_rating, comments)
    VALUES(1, 1, 1111, 7, 9, 8, 10, 8, 9, 9, 'Really enjoyed working here. The team was great and I learned a lot. I made a lot of good connections and would like to continue working for this company if I had the chance.'),
	(2, 2, 2222, 9, 8, 6, 9, 7, 7, 8, 'I feel like I learned a lot from this opportunity, both about the work I wanted to do and the team I wanted to work with. Although we got the work done, I didn’t LOVE my team.'),
	(3, 3, 3333, 6, 9, 7, 8, 8, 8, 7, 'The job itself was great but I think it showed me what I didn’t want to do in the future which made it a little less enjoyable for me.'),
	(4, 4, 4444, 8, 8, 7, 5, 5, 6, 6, 'I learned a lot but the hours were long and sometimes I felt like I was left with all the grunt work.'),
	(5, 5, 5555, 10, 10, 9, 9, 10, 9, 10, 'I LOVED this job! I felt like it gave me really good insight into what my career path could look like and I felt like I gained a lot of skills from this job.');
    
INSERT INTO student_position_review(position_rev_id, company_for, position_for, reviewed_by, supervisor, supervisor_rating, 
colleague_rating, collaborative_rating, pay_satisfaction_rating, productivity_rating, satisfaction_rating, overall_rating, comments)
    VALUES(1, 1, 1, 1111, 5, 8, 9, 10, 7, 8, 9, 9, 'Felt really supported by my team which was great. I do feel like I could have been paid a little more though for the amount of work I was expected to do.'),
	(2, 2, 2, 2222, 4, 9, 9, 9, 8, 8, 10, 9, 'My team and I worked really well together and constantly collaborated with eachother on tasks and projects. It made me feel like I had a good community around me.'),
	(3, 3, 3, 3333, 2, 9, 9, 8, 8, 7, 7, 8, 'The team and my manager were great but I just feel like the position wasn’t the right fit for me so I didn’t fully love what I was doing all the time.'),
	(4, 4, 4, 4444, 3, 9, 9, 8, 8, 8, 8, 9, 'I really liked the work that my position was meant to do. I just felt a little burnt out towards the end of the program because of the long hours we had.'),
	(5, 5, 5, 5555, 1, 10, 10, 10, 9, 10, 10, 10, 'My manager was amazing and really guided me with the work I was doing. I felt like I had a mentor looking out for me and also guiding me with my passions and interests in the field.');
    
INSERT INTO student_interview_review(review_id, interview_id, difficulty_rating, casual_rating, length, overall_rating, interviewed_by, reviewed_by, comments, position_id)
	VALUES(1, 1, 10, 3, 9, 8, 'Alex Russo', 1111, 'The interview was pretty hard. You definitely need to be prepared with answers and have practiced interview questions for your field. They are looking for not only smart candidates on paper, but in person too.', 1),
	(2, 2, 9, 3, 7, 9, 'Harry Muggle', 2222, 'I really enjoyed speaking with my interviewer. I felt like they challenged me with the questions but I also felt like I was prepared to answer them. Overall, I think I did well on connecting with the interviewer.', 2), 
	(3, 3, 7, 5, 7, 9, 'Morgan Wallace', 3333, 'The interview was more relaxed and I felt like I was able to chat with the interviewer more. Definitely come with questions!!', 3),
	(4, 4, 7, 4, 9, 8, 'Morgan Richard', 4444, 'The interviewer asked a lot about my past experience so make sure you can talk it up.', 4),
	(5, 5, 10, 2, 9, 8, 'Ollie Jordan', 5555, 'I had to prepare A LOT for this interview. Especially for the technical aspect of it. I needed to practice for that part so that I wouldn’t freeze in person. If you’re going for a technical role, you will definitely have to do a technical interview as well.', 5);
    
INSERT INTO student_coop_tracker(pid, sid)
	VALUES(1, 1111),
    (2, 2222),
    (3, 3333),
    (4, 4444),
    (5, 5555);
    
-- Rate My Co-op (RMC) PROCEDURES

-- Procedure to add a co-op review
DROP PROCEDURE IF EXISTS reviewCoop;

DELIMITER //
CREATE PROCEDURE reviewCoop(
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
END //

CALL reviewCoop(6, 6, 1111, 2, 4, 4, 9, 10, 8, 6, 6, 'Supervisor was not great, but I loved my team.');
CALL reviewCoop(6, 6, 5555, 9, 8, 8, 7, 7, 9, 8, 8, 'Definitely reach out to people at the start-- it helps later.');
CALL reviewCoop(3, 4, 6666, 2, 1, 1, 2, 2, 2, 2, 1, 'Terrible team, terrible leadership.');

DELIMITER;

SELECT * FROM student_position_review;
SELECT * FROM company;
SELECT * FROM student_pos;
SELECT * FROM student;
SELECT * FROM supervisor;

-- Procedure to add a company review
DROP PROCEDURE IF EXISTS reviewComp;

DELIMITER //
CREATE PROCEDURE reviewComp(
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
END //

CALL review_Comp(1, 1111, 10, 10, 8, 5, 8, 7, 8, 'Need to bring your own lunch, but there are snacks provided. Company culture is great.')
CALL review_Comp(3, 3333, 3, 3, 4, 4, 3, 6, 4, 'All of the full-timers are incredibly condescending. Save your time, unless you want to work overtime for no benefits.')
CALL review_Comp(5, 5555, 5, 5, 6, 4, 4, 6, 5, 'A fine place to work. Not great, but not terrible. I would do it again.')

DELIMITER;

-- Procedure to add a interview review
DROP PROCEDURE IF EXISTS reviewInt;

DELIMITER //
CREATE PROCEDURE reviewInt(
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
END //

CALL reviewInt(1, 10, 4, 6, 6, 'Bella Jeffords', 1111, 'Very terrifying process-- three rounds of behavioral, then two technical. Definitely research the company first.', 5);
CALL reviewInt(2, 1, 10, 1, 10, 'Ellen Claremont', 2222, 'Super laid back interview. One round, and she basically just wanted walkthroughs of my past research.', 4);
CALL reviewInt(4, 5, 8, 6, 5, 'Ricki Mongom', 4444, 'Interview was fine. Business casual dress for sure, through.', 7);

DELIMITER;

