-- Declare a variable (we’ll talk about variables in a minute)
declare @isThisNull varchar(30) -- Starts out as NULL
SELECT @isThisNull, ISNULL(@isThisNull, 'Yep, it is null') -- See?
-- Set the variable to something other than NULL
SET @isThisNull = 'Nope. It is not NULL'
SELECT @isThisNull, ISNULL(@isThisNull, 'Yep, it is null') -- How about now?


GO
CREATE FUNCTION dbo.AddTwoInts(@firstNumber int, @secondNumber int)
RETURNS int AS
BEGIN
	-- Frist, declare the variable to temporarily hold the result
	DECLARE @returnValue int -- the data type matches the "RETURNS" clause

	-- Do whatever needs to be done to set that variable to the
	--   correct value
	SET @returnValue = @firstNumber + @secondNumber

	-- Return the value to the calling statement 
	RETURN @returnValue
END
GO

SELECT dbo.AddTwoInts(5,10)



-- Function to count the Vidcasts made by a given User
GO
CREATE FUNCTION dbo.vc_VidCastCount(@userID int)
RETURNS int AS -- COUNT() as an integer value, so return it as an int
BEGIN
	DECLARE @returnValue int -- matches the function's return type

	/*
		Get the count of the VidCasts for the provided userID and 
		assign that value to @returnValue. Note that we use the
		 @user ID parameter to the WHERE clause to limit our count
		 to that user's VidCast records.
	*/
	SELECT @returnValue = COUNT(vc_UserID) FROM vc_VidCast
	WHERE vc_VidCast.vc_UserID = @userID

	-- Return @returnvalue to the calling code.
	RETURN @returnValue
END
GO
SELECT TOP 10
	*
	, dbo.vc_VidCastCount(vc_UserID) as VidCastCount
FROM vc_User
ORDER BY VidCastCount DESC

GO
-- Function to retreive the vc_TagID for given tag's text
CREATE FUNCTION dbo.vc_TagIDLookup(@tagText varchar(20))
RETURNS int AS -- vc_TagID is an int, so we'll match that 
BEGIN 
	DECLARE @returnValue int -- Matches the function's return type

	/*
		Get the vc_TagID of the vc_Tag record whose TagText
		matches the parameter and assign that value to @returnvalue.
	*/
	SELECT @returnValue = vc_TagID FROM vc_Tag
	WHERE TagText = @tagText

	-- Send the vc_TagID back to the caller
	RETURN @returnValue
END
GO

SELECT dbo.vc_TagIDLookup('Music')
SELECT dbo.vc_TagIDLookup('Tunes')



--Create a view to retrieve the top 10 vc_Users and their
-- VidCast counts
CREATE VIEW vc_MostProlificUsers AS
	SELECT TOP 10
		*
		, dbo.vc_VidCastCount(vc_UserID) as VidCastCount
	FROM vc_User
	ORDER BY VidCastCount DESC
GO
SELECT *FROM vc_MostProlificUsers


-- Create a procedure to update a vc_User's email address
-- The first parameter is the user name for the user to change
-- The second is the new email address
CREATE PROCEDURE vc_ChangeUserEmail(@username varchar(20), @newEmail varchar(50))
AS
BEGIN
	UPDATE vc_User SET EmailAddress = @newEmail
	WHERE UserName = @username
END
GO

EXEC vc_ChangeUserEmail 'tardy', 'kmstudent@syr.edu'

SELECT * FROM vc_User Where UserName = 'tardy'

INSERT INTO vc_Tag (TagText) VALUES ('Cat Videos')
SELECT * FROM vc_Tag WHERE vc_TagID = @@identity


/* Create a procedure that adds a row to the UserLogin table
	This procedure is run when a user logs in and we need 
	to record who they are and from where they're logging in.
*/A
CREATE PROCEDURE vc_AddUserLogin(@username varchar(20), @loginFrom varchar(50))
AS
BEGIN
	-- We have the user name, but we need the ID for the login table
	-- First, declare a variable to hold the ID
	DECLARE @userID int

	--Get the vc_UserID for the UserName provided and store itin @userID
	SELECT @userID = vc_UserID FROM vc_User
	WHERE UserName = @username

	-- Now we can add the row using INSERT statement
	INSERT INTO vc_UserLogin (vc_UserID, LoginLocation)
	VALUES (@userID, @loginFrom)

	-- Now return the @@identity so the calling code know where
	-- the data ended up
	RETURN @@identity
END
GO

DECLARE @addedValue int
EXEC @addedValue = vc_AddUserLogin 'tardy', 'localhost'
SELECT
	vc_User.vc_UserID
	, vc_User.UserName
	, vc_UserLogin.UserLoginTimestamp
	, vc_UserLogin.LoginLocation
FROM vc_User
JOIN vc_UserLogin on vc_User.vc_UserID = vc_UserLogin.vc_UserID
WHERE vc_UserLoginID = @addedValue


/*
	Create a function to retrieve a vc_UserID for a given user name
*/
CREATE FUNCTION dbo.vc_UserIDLookup(@username varchar(20))
RETURNS int AS
BEGIN
	DECLARE @returnValue int

	-- TODO: Write the code to assign the correct vc_UserID
	--		 to @returnValue

	RETURN @returnValue
END
GO
SELECT 'Trying the vc_UserIDLookup function.', dbo.vc_UserIDLookup('tardy')
BEGIN
	DROP FUNCTION vc_TagVidCastCount
END
GO
CREATE FUNCTION  dbo.vc_TagVidCastCount(@tagID int)
RETURNS int AS
BEGIN
	DECLARE @returnValue int
	SELECT @returnValue = COUNT(vc_TagID) FROM vc_VidCastTagList
	WHERE vc_VidCastTagList.vc_TagID = @tagID

	-- Return @returnvalue to the calling code.
	RETURN @returnValue
END
GO

SELECT
vc_Tag.TagText
, dbo.vc_TagVidCastCount(vc_Tag.vc_TagID) as VidCasts
FROM vc_Tag

BEGIN
	DROP FUNCTION vc_VidCastDuration
END
GO
CREATE FUNCTION vc_VidCastDuration(@userID int)
RETURNS int AS 
BEGIN
	DECLARE @returnValue int
	SELECT @returnValue=SUM(DATEDIFF(n, StartDateTime, EndDateTime)) FROM vc_VidCast
	WHERE vc_VidCast.vc_UserID =@userID
	RETURN @returnValue
END
GO

SELECT
*
, dbo.vc_VidCastDuration(vc_UserID) as TotalMinutes
FROM vc_User

CREATE VIEW vc_TagReport AS
	SELECT
		vc_Tag.TagText
	, dbo.vc_TagVidCastCount(vc_Tag.vc_TagID) as VidCasts
FROM vc_Tag

GO
SELECT *FROM vc_TagReport ORDER BY VidCasts DESC
GO
ALTER VIEW vc_MostProlificUsers AS
	SELECT TOP 10
		*
		, dbo.vc_VidCastCount(vc_UserID) as VidCastCount
		, dbo.vc_VidCastDuration(vc_UserID) as TotalMinutes
	FROM vc_User
	ORDER BY VidCastCount DESC
GO
SELECT UserName, VidCastCount, TotalMinutes FROM vc_MostProlificUsers





/*
	Create a stored procedure to add a new Tag to the database
	Inputs:
		@tagText : the text of the new tag
		@description : a brief description of the tag (nullable)
		Returns:
			@@identity with the value inserted
*/
CREATE PROCEDURE vc_AddTag(@tagText varchar(20), @description varchar(100)=NULL) AS
BEGIN
	INSERT INTO vc_Tag(TagText,TagDescription)
	VALUES (@tagText, @description)

	RETURN @@identity
END
GO

DECLARE @newTagID int
EXEC @newTagID = vc_AddTag 'SQL', 'Finally, a SQL Tag'
SELECT * FROM vc_Tag where vc_TagID = @newTagID

GO
CREATE PROCEDURE vc_FinishVidCast(@vidcastID int)
AS
BEGIN
	UPDATE vc_VidCast SET EndDateTime = GetDate()
	WHERE vc_VidCast.vc_VidCastID = @vidcastID
END
GO
DECLARE @newVC int
INSERT INTO vc_VidCast
(VidCastTitle, StartDateTime, ScheduleDurationMinutes, vc_UserID,
vc_StatusID)
VALUES (
'Finally done with sprocs'
, DATEADD(n, -45, GETDATE())
, 45
, (SELECT vc_UserID FROM vc_User WHERE UserName = 'tardy')
, (SELECT vc_StatusID FROM vc_Status WHERE StatusText='Started')
)
SET @newVC = @@identity
SELECT * FROM vc_VidCast WHERE vc_VidCastID = @newVC
EXEC vc_FinishVidCast @newVC
SELECT * FROM vc_VidCast WHERE vc_VidCastID = @newVC