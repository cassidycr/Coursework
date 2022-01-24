-- Guestuser's tab
SELECT * FROM vc_User

SELECT * FROM vc_MostProlificUsers

DECLARE @addedValue int
EXEC @addedValue = vc_AddUserLogin 'TheDoctor', 'Gallifrey'

DECLARE @newVC int
INSERT INTO vc_VidCast
(VidCastTitle, StartDateTime, ScheduleDurationMinutes, vc_UserID,
vc_StatusID)
VALUES (
'Rock Your Way To Success'
, DATEADD(n, -45, GETDATE())
, 45
, (SELECT vc_UserID FROM vc_User WHERE UserName = 'TheDoctor')
, (SELECT vc_StatusID FROM vc_Status WHERE StatusText='Stated')
)
SET @newVC = @@identity
SELECT * FROM vc_VidCast WHERE vc_VidCastID = @newVC
EXEC vc_FinishVidCast @newVC SELECT * FROM vc_VidCast WHERE vc_VidCastID = @newVC

SELECT * FROM vc_UserLogin

SELECT * FROM vc_Vidcast
WHERE vc_VidCast.vc_VidCastID = 1005