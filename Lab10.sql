-- Creating a new table
CREATE TABLE lab_Test(
	lab_TestID int identity primary key,
	labtestText varchar(20) unique not null)

/*
	This will be a table to keep a log of
	created lab_Test records.
	WE don't want to add a row to this if
	the insert intp lab_Test fails
*/

CREATE TABLE lab_Log (
	lab_LogID int identity primary key,
	lab_logint int unique not null
	
INSERT INTO lab_Test (labtestText) VALUES ('One'),('Two'), ('Three')
INSERT INTO lab_Log (lab_logint) SELECT lab_TestID FROM lab_Test






--Step 1:Begin the transaction
BEGIN TRANSACTION
	--Step 2: Assess the state of things
	DECLARE @rc int
	SET @rc = @@ROWCOUNT -- Initially 0

	-- Step3: Make the change
	-- On success, @@ROWCOUNT is incremented by 1
	-- On failure, @@ROWCOUNT does not change
	INSERT INTO lab_Test (labtestText) VALUES ('Cassidy')

	-- Step 4: Check the new state of things
	IF(@rc = @@ROWCOUNT) -- If @@ROWCOUNT was not chnaged, fail
	BEGIN
		-- Step 5, if failed
		SELECT 'Bail out! It failed!'
		ROLLBACK
	END
	ELSE -- Success! Continue.
	BEGIN
		-- Step 5 if succeeded
		SELECT 'Yay! It worked!'
		INSERT INTO lab_Log (lab_logint) VALUES (@@IDENTITY)
		COMMIT
	END

SELECT * FROM lab_Log
SELECT * FROM lab_Test