--Adding a row to the vc_Status table
INSERT INTO vc_Status (StatusText)
VALUES ('Scheduled')

--The following line shows all of the rows in vc_Status
SELECT * FROM vc_Status

--Adding three more rows to the vc_Status table
INSERT iNTO vc_Status (StatusText)
VALUES ('Stated'), ('Finished'), ('On time')
 
SELECT * FROM vc_User WHERE UserName = 'Saul Hudson'
SELECT * FROM vc_Status WHERE StatusText = 'Finished'

INSERT INTO vc_VidCast
	(VidCastTitle, StartDateTime, EndDateTime, ScheduleDurationMinutes
	, RecordingURL, vc_UserID, vc_StatusID)
VALUES
	('December Snow', '3/1/2018 14:00', '3/1/2018 14:30', 30
	, '/XVF1234', '2', '3')

--Read all rows from vc_VidCast
SELECT *FROM vc_VidCast 

SELECT
	vc_User.Username,
	vc_User.EmailAddress,
	vc_VidCast.VidCastTitle,
	vc_VidCast.StartDateTime,
	vc_VidCast.EndDateTime,
	vc_VidCast.ScheduleDurationMinutes / 60.0 as ScheduledHours,
	vc_Status.StatusText
FROM vc_VidCast
JOIN vc_User ON vc_VidCast.vc_UserID = vc_User.vc_UserID
JOIN vc_Status ON vc_VidCast.vc_StatusID = vc_Status.vc_StatusID
WHERE vc_User.Username = 'SaulHudson'
ORDER BY vc_VidCast.StartDateTime

--Correcting a User's UserRegisteredDate
UPDATE vc_User SET UserRegisteredDate = '3/1/2018' WHERE Username = 'SaulHudson'

SELECT * FROM vc_User WHERE Username = 'SaulHudson'

--See what rows we have in Status
SELECT * FROM vc_Status

--Delete the On time status
DELETE vc_Status WHERE StatusText = 'On time'

--See the effect
SELECT * FROM vc_Status

INSERT INTO vc_Tag (TagText, TagDescription)
VALUES ('Personal', 'About people')
INSERT INTO vc_Tag (TagText, TagDescription)
VALUES ('Professional', 'Business, business, business')
INSERT INTO vc_Tag (TagText, TagDescription)
VALUES ('Sports', 'All manner of sports')
INSERT INTO vc_Tag (TagText, TagDescription)
VALUES ('Music', 'Music analysis, new, and thoughts')
INSERT INTO vc_Tag (TagText, TagDescription)
VALUES ('Games', 'Line stream our favorite games')

SELECT * FROM vc_Tag

INSERT INTO vc_User (Username, EmailAddress, UserDescription)
VALUES ('TheDoctor', 'tamBaker@nodomain.xzy', 'The definite article')
INSERT INTO vc_User (Username, EmailAddress, UserDescription)
VALUES ('HairCut', 'S.todd@nodomain.xzy', 'Fleet Street barber shop')
INSERT INTO vc_User (Username, EmailAddress, UserDescription)
VALUES ('DnDGal', 'dnd@nodomain.xzy', 'NULL')

SELECT * FROM vc_User

DROP TABLE If EXISTS vc_UserTagList

CREATE TABLE vc_UserTagList (
	vc_UserTagListID int identity primary key
	, vc_UserID int not null
	, vc_TagID int not null
	, CONSTRAINT U1_vc_UserTagList UNIQUE (vc_UserID, vc_TagID)
	)

INSERT INTO vc_UserTagList (vc_UserID, vc_TagID)
VALUES
	(6, 3),
	(6, 2),
	(1, 2),
	(2, 3),
	(3, 1),
	(6, 1),
	(3, 6),
	(5, 2),
	(4, 5),
	(6, 6),
	(2, 6),
	(3, 2),
	(5, 5),
	(4, 1)

	SELECT * FROM vc_UserTagList

	SELECT vc_User.Username, vc_User.EmailAddress, vc_Tag.TagText FROM vc_Tag
	JOIN vc_User ON vc_Tag.vc_UserID = vc_User.vc_UserID 
	ORDER BY vc_User.Username, vc_Tag.TagText
	SELECT * FROM vc_User
