-- DATABASE CREATION
-- Creating the Contact table
CREATE TABLE contact(
	-- Columns for the Contact table
	contact_id int identity,
	first_name varchar(30) not null,
	last_name varchar(30) not null,
	street varchar(100) not null,
	city varchar(30) not null,
	zipcode varchar(10) not null,
	email_address varchar(50),
	phone varchar(50),
	
	-- Contraints on the Contact Table
	CONSTRAINT PK_contact PRIMARY KEY (contact_id),
)
-- End Creating the Contact table

-- Creating the Research Fellows table
CREATE TABLE research_fellows(
	-- Columns for the Contact table
	fellow_id int identity,
	area_of_research varchar(50) not null,
	contact_id int,
	-- Contraints on the User Table
	CONSTRAINT PK_research_fellows PRIMARY KEY (fellow_id),
	CONSTRAINT FK1_research_fellows FOREIGN KEY (contact_id)
	 REFERENCES contact(contact_id),
)
-- End Creating the ResearchFellows table

-- Creating the Professors table
CREATE TABLE professors(
	-- Columns for the professors table
	professor_id int identity,
	school_name varchar(50),
	school_street varchar(100),
	school_city varchar(30),
	zipcode varchar(10),
	subject_title varchar(50),
	contact_id int,
	
	-- Contraints on the Professor Table
	CONSTRAINT PK_professors PRIMARY KEY (professor_id),
	CONSTRAINT FK1_professors FOREIGN KEY (contact_id)
	 REFERENCES contact(contact_id),
)
-- End Creating the Professors table

-- Creating the donations table
CREATE TABLE donations(
	-- Columns for the donation table
	check_id int identity,
	check_amount money,
	check_date datetime not null default GetDate(),
	contact_id int,
	
	-- Contraints on the donations Table
	CONSTRAINT PK_donations PRIMARY KEY (check_id),
	CONSTRAINT FK1_donations FOREIGN KEY (contact_id)
	 REFERENCES contact(contact_id),
)
-- End Creating the donations table

-- Creating the subscriber table
CREATE TABLE subscriber(
	-- Columns for the subscriber table
	subscriber_id int identity,
	subscriber_date datetime not null default GetDate(),
	contact_id int,
	
	-- Contraints on the subscriber Table
	CONSTRAINT PK_subscriber PRIMARY KEY (subscriber_id),
	CONSTRAINT FK1_subsriber FOREIGN KEY (contact_id)
	 REFERENCES contact(contact_id),
)
-- End Creating the subscriber table

-- INSERTING DATA
--Inserting Contact

INSERT INTO dbo.contact (first_name, last_name, street, city, zipcode, email_address, phone)
	VALUES('Harry', 'Potter', '4 Privet Drive', 'Surrey', '12345', 'dumbledoresarmy1@hogarts.edu', '1234567')

INSERT INTO dbo.contact (first_name, last_name, street, city, zipcode, email_address, phone)
	VALUES('Professor', 'Snape', '1 Snowy Ave', 'Hogwarts', '55555', 'professorsnape@hogarts.edu', '7654321')

INSERT INTO dbo.contact (first_name, last_name, street, city, zipcode, email_address, phone)
	VALUES('Leigh', 'Bardugo', 'Little Palace', 'Ravka', '43562', 'lb@grishaverse.com', '1111111')

INSERT INTO dbo.contact (first_name, last_name, street, city, zipcode, email_address, phone)
	VALUES('Loralei','Gilmore', '1 Blue House','Starshollow', '03333', 'dragonfly@xx.x', '6549876')

INSERT INTO dbo.contact (first_name, last_name, street, city, zipcode, email_address, phone)
	VALUES('J.K.','Rowling', '4 Yellow Ave','Dreamerville', '11111', 'rowlingjk@xx.x', '5433767')

INSERT INTO dbo.contact (first_name, last_name, street, city, zipcode, email_address, phone)
	VALUES('Mary','Johnson', '1 Mountain Lane', 'Bozeman', '59715', 'mountaingirl@xx.x', '4085765')

--Inserting Professor
INSERT INTO dbo.professors (school_name, school_street, school_city, zipcode, subject_title, contact_id)
	VALUES('Hogwarts School of Witchcraft and Wizardry', '1 Magic Way', 'Hogwarts Castle', '55555', 'Environmental Economics', 2)
INSERT INTO dbo.professors (school_name, school_street, school_city, zipcode, subject_title, contact_id)
	VALUES('MSU', '1 Montana Way', 'Bozeman', '5975', 'Developmental Economics', 6)

--Inserting Research Fellow
INSERT INTO research_fellows (area_of_research, contact_id)
	VALUES('Applied Microeconomics',  1)

--Inserting Subscriber
INSERT INTO subscriber (subscriber_date, contact_id)
	VALUES('3/18/2019 15:06',  3)
INSERT INTO subscriber (subscriber_date, contact_id)
	VALUES('3/18/2019 15:06',  3)
INSERT INTO subscriber (subscriber_date, contact_id)
	VALUES('1/1/2016',  2)
INSERT INTO subscriber (subscriber_date, contact_id)
	VALUES('1/7/2017',  5)
	
--Inserting Subscriber with no date provided
INSERT INTO subscriber (subscriber_date, contact_id)
	VALUES(GetDate(),  1)


SELECT * FROM subscriber
JOIN contact ON subscriber.contact_id = contact.contact_id


--Inserting Donation
INSERT INTO donations (check_amount, check_date, contact_id)
	VALUES('300', '2/5/2019 08:00', 4)
INSERT INTO donations (check_amount, check_date, contact_id)
	VALUES('500', '3/1/2016 09:00', 3)
INSERT INTO donations (check_amount, check_date, contact_id)
	VALUES('1000', '9/1/2017 08:00', 5)
	INSERT INTO donations (check_amount, check_date, contact_id)
	VALUES('800', '7/16/2018 09:00', 3)
	INSERT INTO donations (check_amount, check_date, contact_id)
	VALUES('50', '9/9/2017 09:00', 4)

SELECT * FROM donations
JOIN contact ON donations. contact_id = contact.contact_id


-- MANIPULATING DATA
-- A recent issue of EERC's policy magazine was returned to sender. An employee discovered the corrected address and is now correcting the mistake.

UPDATE contact SET street = '2 Little Palace Drive' WHERE contact_id = 3

SELECT * FROM contact WHERE contact_id = 3

-- A subscriber has asked to be removed form the list. 
DELETE subscriber WHERE contact_id = 1
SELECT * FROM subscriber

-- However, we dont want to delete the contact all together. 
SELECT * FROM contact WHERE contact_id = 1

-- ANSWERING DATA QUESTIONS
-- The magazine director wants to double check the recent address change from an important subscriber.

SELECT * FROM contact WHERE contact_id = 3

-- The accountant wants to look at dontations from 2016.

SELECT 
contact.contact_id,
contact.first_name,
contact.last_name,
donations.check_amount,
donations.check_date
FROM donations

JOIN contact ON contact.contact_id = donations.contact_id
WHERE check_date < '1/1/2017'
ORDER BY contact.contact_id

-- An employee organizing an upcoming conference wants to check what research a particular fellow is concerned with. 

SELECT 
contact.contact_id,
contact.first_name,
contact.last_name,
research_fellows.area_of_research
FROM research_fellows
JOIN contact ON contact.contact_id = research_fellows.contact_id
WHERE fellow_id = 1

-- The accountant needs to check on total donations
SELECT 
COUNT(check_id) as totalchecks,
SUM(check_amount) as totaldontations
FROM donations

-- The accountant needs to check on total donations from 2017

SELECT 
COUNT(check_id) as totalchecks2017,
SUM(check_amount) as totaldontations2017
FROM donations
WHERE check_date > '12/31/2016'
	AND check_date < '1/1/2018'

	-- We want to check how many subscribers we have to date.

SELECT 
COUNT(subscriber_id) as TotalSubscribers
FROM subscriber

-- View to see top dontations
GO
CREATE VIEW 
     topdonations_ AS
	SELECT TOP 5 *
	FROM donations
	ORDER BY check_amount DESC
	GO

SELECT * FROM topdonations_