--TRIGGERS--
-- A bunch of code that execute in response to a specific DML statement(s) on a specific table

--Example: we can create a trigger that will execute automatically when we perform an insert on the student table. 
--Triggers are not called by name. They do not have parameters. 
--Trigger code is stored in the DB (like SP's and views)
--We maintain triggers in the same manner as SP's and Views (sp_helptext, Alter trigger, Drop trigger)
    --helptext: using retrieve the data
--A Trigger can have more than one DML statement that will cause it to execute

--Why? 
--Complex validations that cannot be done with check constraints
--Logging, archiving, backups 

--SYNTAX--
--Create Trigger NAME
--ON TableName
--For DML Statements
--AS 
--SQL Code
--Return 


--Simple Trigger
CREATE Trigger TR_Agent_Update 
On Agent
For update 
AS 
RAISERROR('Yah, I''m a trigger', 16, 1)
RETURN

--Test the Trigger 
Update Agent
set 
AgentFee = 70 
where AgentID = 1
    --트리거로 인한 에러발생 


--Won't work for other DML Statements on the table 
Insert into Agent(AgentName, AgentFee)
Values('Shane', 500)
    --update가 아니라 insert라서 trigger가 안된다. 
go


-- Alter Trigger
    --update랑 insert도 같이 추가 
Alter Trigger TR_Agent_Update
ON Agent
For UPDATE, INSERT
AS
RaisError('Yay! I''m a trigger!', 16, 1)
Return 

--Test the trigger
-- 이제 insert에도 trigger가 동작한다
Insert into Agent(AgentName, AgentFee)
Values('Shane', 100)
go

Select * from Agent

delete agent where agentname = 'shane'




--INSERTED AND DELETED TABLES
--Are created for us by SQL for us to use in our triggers
--Both tables have the same structure(attributes) as the table the trigger is on (base table)
--But they contain different data

--INSERTED - contains only the affected/changed records as they look AFTER the DML statement has executed 
--DELETED - contains only the affected/changed reocords as they look BEFORE the DML statement has executed

--For an insert trigger the INSERTED table contains the inserted records, the DELETED table is empty
--For a delete trigger the INSERTED table is empty and the DELETE table contains the deleted records


Update Agent
Set AgentFee = 10 --was 60
Where AgentID = 1 
GO
--INSERTED
--AgentID               AgentName           AgentFee
--1                   Bob The Agent             10

--DELETED
--AgentID             Bob The Agent          AgentFee
--1                   Bob The Agent             60

--Trigger to demonstrate what is inside the inserted/deleted tables
Create Trigger TR_MovieCharacter_Insert_Update_Delete
on MovieCharacter 
For Insert, Update, Delete 
As 
Select * from Inserted 
Select * from Deleted
Select * from MovieCharacter --new value 들어가 있음 
Rollback Transaction 
Select * from Inserted --empty
Select * from Deleted --empty
Select * from MovieCharacter -- 다시 원래대로 돌아옴 
RETURN


--Triggers must work properly if 0, 1 or many records are affected
--Single Record
update MovieCharacter
set CharacterRating = 5
where CharacterID = 1 


--Multiple records
Update MovieCharacter
Set CharacterRating = 5

-- 0 Records
update MovieCharacter
set CharacterRating = 1
where CharacterID = 100 

Insert into MovieCharacter(CharacterName, CharacterMovie, CharacterRating, Characterwage, AgentID)
Values ('Shane the great!', 'Shane crushes the SQL Monster', 4, 120, 1)
--insert 됐다가 다시 지워짐 

Delete MovieCharacter where CharacterID = 5
GO





--테이블 백업 시키고 강의 시작 
--Create a trigger to enforce a rule that a character's wage must be >= 0
--Insert, Update on MovieCharacter
Create Trigger TR_MovieCharacter_Insert_Updates
on MovieCharacter
for insert, UPDATE
as 
if exists (Select * from inserted where characterwage < 0)
    BEGIN
    RAISERROR('Character wage cannot be less than 0', 16, 1)
    ROLLBACK TRANSACTION
    END
RETURN



Update MovieCharacter 
Set CharacterWage = -1000
where characterID = 1 

--Why would I want to run the IF EXISTS if no records were affected? 
Update MovieCharacter 
Set CharacterWage = 1000
where characterID = 1000
GO
    --0 row affected. in this case, so we need to use @@rowcount


Create Trigger TR_MovieCharacter_Insert_Updates
on MovieCharacter
for insert, UPDATE
as 
IF @@rowcount > 0 
    Begin
    if exists (Select * from inserted where characterwage < 0)
        BEGIN
        RAISERROR('Character wage cannot be less than 0', 16, 1)
        ROLLBACK TRANSACTION
        END
    END
RETURN


--What if we did not update/insert CharacterWage. Just updated other columns...? 
Update MovieCharacter
SET
CharacterName = 'Bob',
CharacterMovie = 'Sponge Bob'
Where characterID = 1
go


--If we did not change the characterwage, why check it? 
Alter Trigger TR_MovieCharacter_Insert_Updates
on MovieCharacter
for insert, UPDATE
as 
IF @@rowcount > 0 and update(CharacterWage)
    Begin
    if exists (Select * from inserted where characterwage < 0)
        BEGIN
        RAISERROR('Character wage cannot be less than 0', 16, 1)
        ROLLBACK TRANSACTION
        END
    END
RETURN

--update() returns true/false. It returns TRUE if the column is part of the DML statement that caused the trigger to execute
--Returns false otherwise 
Update MovieCharacter
SET
CharacterName = 'Bob',
CharacterMovie = 'Sponge Bob',
Characterwage = 100
Where characterID = 1
go

--Update() does not check to see if the value actually changes values
--Update() returns TRUE for an insert



--Homework 
--Q1: Create a trigger that ensure and AgentsFee is between 0 and 500. Make sure your trigger works if 0, 1, or many records are affected. 
go
Create Trigger TR_Agent_Insert_Update
on Agent
For Insert, UPDATE
as 
IF @@rowcount > 0 AND UPDATE(AgentFee) -- 아니 왜 insert(agentFee)는 안적어줌? 
    BEGIN
    if exists(select * from inserted where agentFee < 0 or agentFee > 500)
        BEGIN
        RAISERROR('invalid agent fee', 16, 1)
        ROLLBACK TRANSACTION
        END
    END
RETURN

UPDATE Agent
Set AgentFee -= 300
where agentID = 1
go


--Q2: Create a Trigger that enforces a rule that an AgentsFee cannot be increased by more than 100% in one update
Create Trigger TR_Agent_Update
on Agent 
For UPDATE
AS
if @@rowcount > 0 and update(AgentFee)
    BEGIN
    IF exists(select * from inserted inner join deleted on inserted.agentid = deleted.agentID where inserted.agentFee > deleted.agentFee * 2)
        BEGIN
        RAISERROR('Cannot increase more than 100 percent', 16, 1)
        ROLLBACK TRANSACTION
        END
    END
RETURN

GO
Alter Trigger TR_Agent_Update
On Agent
For UPDATE
AS
IF @@rowcount > 0 and update(AgentFee)
    BEGIN
    If exists(Select * from inserted inner join deleted on Inserted.agentID = deleted.AgentID where inserted.AgentFee > deleted.AgentFee * 2)
        begin
        rollback TRANSACTION --왜 rollback이 앞에 오는 거임? 
        RAISERROR('cannot increase by more than 100 percent', 16, 1)
        END
    END
RETURN

update agent
set agentFee = 401
where agentID = 1

update agent
set agentfee += 300
where agentid = 1 
GO


--Create a trigger that enforces a rule that a movie character cannot be deleted if their related agents fee is < 250
--Rules being checked by a trigger should only be enforced from the time the trigger has been created. DO NOT check the rule against OLD data
drop trigger if exists TR_MovieCharacter_Delete
go

Create Trigger TR_MovieCharacter_Delete
on MovieCharacter
for DELETE
AS
if @@RowCount > 0 
    Begin
    -- if exists(select * from agent where agentfee < 250) 이렇게 쓰면 모든 agent fee를 체크해야한다. 
    -- agentfee < 250 이라서 일단 select 는 agent 테이블에서 뽑아온다 
    if exists(Select * from agent inner join deleted on agent.AgentID = deleted.AgentID where agentfee < 250)
        BEGIN
        RAISERROR('Agent charges less than $250. Cannot delete', 16, 1)
        ROLLBACK TRANSACTION
        END
    END
RETURN


Delete MovieCharacter
where characterID = 1

Delete MovieCharacter
where charactermovie = 'Star Wars'
GO

--Question: Trigger to enforce a rule that insert or update an agent cannot be related to more than 2 movie character records. 
    -- 한 agentID는 2개 까지만 캐릭터를 받을 수 있고 그 이상은 못받는다.
    -- parents record doesn't have more than 2 child records. 
    --break the rule case 1. insert 해서 모든 내용 다 넣고 나서 agentID에서 1이 이미 2개가 있는데 또 넣으면 break the rule 
    --case 2: update에서 agentID3을 이미 2개난 있는 1로 바꿀려고 하면 break rule이 됨 

    --how many movie characters are there for each agent 
    --Select agentID, count(*) from MovieCharacter group by agentID 
    --Select agentID, count(*) from MovieCharacter group by agentID having count(*) > 2
    --Select * from inserted group by agentID having count(*) > 2 - inserted로 하지 않는 이유는 inserted는 딱 해당하는 데이터만 들어있기에 전체를 분류 시키지 못한다. 

Create Trigger TR_MovieCharacter_Insert_Update
on MovieCharacter
for insert, UPDATE
AS
if @@rowcount > 0 and update(agentID)
    BEGIN
    if exists(Select * from MovieCharacter inner join inserted on MovieCharacter.AgentID = Inserted.AgentID group by movieCharacter.agentID having count(*) > 2)
    RAISERROR('Too many related records', 16, 1)
    END
RETURN



insert into MovieCharacter(characterName, charactermovie, characterRating, CharacterWage, AgentID)
Values('Shane the great!', 'Shane slays the SQL monster', 2, 5, 3)

update MovieCharacter
set agentID = 1
where characterID = 4
go


-- Triggers Exercise -- (Use IQSchool Database)
-- NOTE: These questions are not in order of increasing difficulty

-- 1.	In order to be fair to all students, a student can only belong to a maximum of 3 clubs. Create a trigger to enforce this rule.
    --parents 
drop Trigger TR_Activity_Insert_Update 
go

Create Trigger TR_Activity_Insert_Update 
on Activity
for insert, UPDATE
As 
if @@rowcount > 0 and update(studentID) --studentID 가 이미 3개가 있으면 아웃
    BEGIN
    if exists(select * from Activity inner join inserted on Activity.studentID = inserted.studentId group by activity.studentID having count(*) > 3 )
    RAISERROR('Too many clubs', 16, 1)
    ROLLBACK TRANSACTION
    END
return
    --select studentID, count(clubid) from activity group by studentID

update activity
set studentID = 199912010
where studentid = 200495500 and clubid = 'chess'


insert into activity(StudentID, ClubId)
values (199899200, 'CHESS')

select * from activity 
go


-- 2. The Education Board is concerned with rising course costs! 
    -- Create a trigger to ensure that a course cost does not get increased by more than 20% at any one time.
drop trigger if exists TR_Course_Update 
go

Create Trigger TR_Course_Update
on Course 
for UPDATE
AS
IF @@rowcount > 0 and update(CourseCost) 
    BEGIN
    if exists(select * from inserted inner join deleted on inserted.courseID = deleted.courseID where inserted.courseCost > deleted.courseCost * 1.2)
        BEGIN
        RAISERROR('Too much increase', 16, 1)
        ROLLBACK TRANSACTION
        END
    END
RETURN


update course 
set coursecost = 800
where courseID = 'dmit104'

update course 
set coursecost += 50
where courseID = 'dmit101'

Select * from Course
GO

-- 3. Too many students owe us money and keep registering for more courses! 
    -- Create a trigger to ensure that a student cannot register for any more courses if they have a balance owing of more than $500.
Create Trigger TR_registration_Insert_Update 
On Registration
For Update, INSERT
AS
if @@rowcount > 0 and update(StudentID) 
    BEGIN
    if exists(select * from student inner join inserted on student.studentID = inserted.studentID where balanceowing > 500)
        BEGIN
        RAISERROR('Owe too much', 16, 1)
        ROLLBACK TRANSACTION
        END
    END
RETURN
    --trigger 되는 테이블이랑 if exists로 체크하는 테이블이 다름 

insert into registration (studentID, offeringCode)
values (199899200, 1009)




--LOGGING TRIGGERS
    --Create a trigger to add a record to the logging table whenever a course cost is changed
     Create table CourseChanges
    (
        LogID int identity(1, 1) not null constraint pk_CourseChanges Primary Key, 
        ChangeDateTime DateTime not null constraint df_Date default getdate(), 
        OldCourseCost money not null, 
        NewCourseCost money not null,
        CourseID char(7) not null
    )
    GO

    select * from CourseChanges
    go

    Create Trigger TR_Course_Update
    on Course 
    for UPDATE
    AS
    if @@rowcount > 0 and update(CourseCost)
        Begin   
        --INSERT Statement to insert into CourseChanges the data from the courses that have had their coursecost updated. Could be one or many courses. 
        insert into CourseChanges (OldCourseCost, NewCourseCost, CourseID)
        Select Deleted.CourseCost, inserted.CourseCost, Inserted.CourseID from inserted inner join deleted on inserted.courseID = deleted.courseID
        --We do not check @@error in a trigger. When a DML statement fails in a trigger the ends/stops. 
        END
    RETURN

    select * from course
    select * from CourseChanges

    Update course
    set courseCost = 1000
    where courseID = 'dmit101'

    --Multiple record test
    update course
    set coursecost += 10

    --Update all the courses to $460 
    update course 
    set coursecost = 460 



    --Updating all the courses to 460 added 16 records to the coursechanges table. Even though only 2 of the courses actually changed cost.
    --Alter your trigger so that when records are updated, only the ones that actually changed values are inserted into the coursechanges table. 
    --CurrentcourseCost     NewCourseCost   LOG?
    --100                   200             Y
    --200                   200             N
    --150                   200             Y
    --85                    200             Y

    Update Course
    Set CourseCost = 200 
    --We only want 3 records added to courseChanges. Only the ones that actually changed values. 
    go

    Alter Trigger TR_Course_Update
    on Course 
    for UPDATE
    AS
    if @@rowcount > 0 and update(CourseCost)
        Begin 
        insert into CourseChanges (OldCourseCost, NewCourseCost, CourseID)
        Select Deleted.CourseCost, inserted.CourseCost, Inserted.CourseID from inserted inner join deleted on inserted.courseID = deleted.courseID 
        where inserted.courseCost != deleted.courseCost
        END
    RETURN

    go
    Alter Trigger TR_Course_Update 
    on Course
    for UPDATE
    AS 
    if @@rowcount > 0 and update(coursecost)
        BEGIN
        insert into courseChanges (oldcoursecost, newcoursecost, courseID)
        select deleted.coursecost, inserted.coursecost, inserted.courseID from inserted inner join deleted on inserted.courseID = deleted.courseID 
        where inserted.coursecost != deleted.coursecost
        END
    return

    update course 
    set coursecost = 460

    select * FROM course


-- 4.	Our network security officer suspects our system has a virus that is allowing students to alter their Balance Owing! 
    -- In order to track down what is happening we want to create a logging table that will log any changes to the BalanceOwing column in the student table. 
    -- You must create the logging table and the trigger to populate it when a balance owing is updated. 
    -- LogID is the primary key and will have Identity (1,1).

-- BalanceOwingLog
-- LogID	  int
-- StudentID	Int
-- ChangeDateTime	datetime
-- OldBalance	decimal (7,2)
-- NewBalance	decimal (7,2)


Create Table BalanceOwingLog
(
	LogID			int  identity (1,1)	not null 
										constraint PK_BalanceOwingLog_LogID
											Primary Key clustered,
	StudentID		int					not null,
	ChangeDateTime	datetime			not null,
	OldBalance		decimal (7,2)		not null,
	NewBalance		decimal (7,2)		not null
)
Go


Create Trigger TR_BalanceOwingChangeLog_Update
on Student
For Update
As
If @@RowCount > 0 and Update (BalanceOwing)
	Begin
		Insert Into BalanceOwingLog (StudentID, ChangeDateTime, OldBalance, NewBalance)
		Select	Inserted.StudentID, GetDate(), Deleted.BalanceOwing, Inserted.BalanceOwing 
		From	Deleted
					Inner Join Inserted
						On Deleted.StudentID = Inserted.StudentID
                        -- where deleted.balanceowing != inserted.balanceOwing 이 걸 왜 안적어 줬을까? 
		If @@Error != 0 
			Begin
				RaisError('Insert into BalanceOwingLog Failed', 16, 1)
			End	
	End
Return
Go

-- testing example
-- all updates should insert a record into the BalanceOwingLog table
Select	LogID, StudentID, ChangeDateTime, OldBalance, NewBalance From BalanceOwingLog
Select	StudentID, FirstName, LastName, BalanceOwing From Student Where	StudentID = 198933540

Update	Student
Set		BalanceOwing = 1000
Where	StudentID = 198933540

Select	LogID, StudentID, ChangeDateTime, OldBalance, NewBalance From BalanceOwingLog

Select	StudentID, FirstName, LastName, BalanceOwing
From	Student
Where	StudentID = 198933540

Update	Student
Set		BalanceOwing = 0
Where	StudentID = 198933540

Select	StudentID, FirstName, LastName, BalanceOwing
From	Student
Where	StudentID = 198933540

Select	LogID, StudentID, ChangeDateTime, OldBalance, NewBalance
From	BalanceOwingLog


-- 5.	We have learned it is a bad idea to update primary keys. 
    -- Yet someone keeps trying to update the Club tables ClubID column and the Course tables CourseID column! 
    -- Create a trigger(s) to stop this from happening! You are authorized to use whatever force is necessary! Well, in your triggers, anyways !
go  

Create Trigger TR_NoClubPKUpdate_Update --clubID check
On Club
For Update
As
If @@RowCount > 0 and Update(ClubID)
	Begin
		Rollback Transaction
		RaisError('You cannot update the Club ID!', 16, 1)
	End
Return
Go

Create Trigger TR_NoCoursePKUpdate_Update --CourseID check 
On Course
For Update
As
If @@RowCount > 0 and Update(CourseID)
	Begin
		Rollback Transaction
		RaisError('You cannot update the Course ID!', 16, 1)
	End
Return
Go


-- Testing Club table
-- should work
Select	ClubId, ClubName
From	Club
Where	ClubID = 'CSS'

Update	Club
Set		ClubName = 'updated club name'
Where	ClubID = 'CSS'

Select	ClubId, ClubName
From	Club
Where	ClubID = 'CSS'

-- should not work
Select	ClubId, ClubName
From	Club
Where	ClubID = 'CIPS'

Update	Club
Set		ClubID = 'ZZZZ'
Where	ClubID = 'CIPS'

Select	ClubId, ClubName
From	Club
Where	ClubID = 'CIPS'

-- Testing Course table
-- should work
Select	CourseId, CourseName, CourseHours, MaxStudents, CourseCost
From	Course
Where	CourseID = 'DMIT103'

Update	Course
Set		CourseName = 'updated course name'
Where	CourseID = 'DMIT103'

Select	CourseId, CourseName, CourseHours, MaxStudents, CourseCost
From	Course
Where	CourseID = 'DMIT103'

-- should not work
Select	CourseId, CourseName, CourseHours, MaxStudents, CourseCost
From	Course
Where	CourseID = 'DMIT108'

Update	Course
Set		CourseID = 'DMIT999'
Where	CourseID = 'DMIT108'

Select	CourseId, CourseName, CourseHours, MaxStudents, CourseCost
From	Course
Where	CourseID = 'DMIT108'







--  Source Data
Drop Table if exists MovieCharacter
Drop Table if exists Agent
Go

Create Table Agent
(
	AgentID			int identity(1,1)	not null
										constraint PK_Agent primary key clustered,
	AgentName		varchar(70)			not null,
	AgentFee		money				not null
)

Create Table MovieCharacter
(
	CharacterID		int identity(1,1)	not null
										constraint PK_Character primary key clustered,
	CharacterName	varchar(70)			not null,
	CharacterMovie	varchar(70)			not null,
	CharacterRating	char(1)				null 
										constraint DF_characterRating default 3,
	Characterwage	smallmoney			null,
	AgentID			int null			constraint FK_MovieCharacterToAgent
											references Agent(AgentID)
)
Go

Insert Into Agent
	(AgentName, AgentFee)
Values
	('Bob the agent', 50)
Insert Into Agent
	(AgentName, AgentFee)
Values
	('Good Acting For U', 125)
Insert Into Agent
	(AgentName, AgentFee)
Values
	('I represent anyone', 5)

Insert Into MovieCharacter	
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('ET', 'ET The Extraterrestrial', '4', 20000, 3)
Insert Into MovieCharacter
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('Luke Skywalker', 'Star Wars', '5', 12000, 2)
Insert Into MovieCharacter
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('R2D2', 'Star Wars', '4', 0, 1)
Insert Into MovieCharacter
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('Winnie The Pooh', 'Heffalump', '1', 20000, 2)
Insert Into MovieCharacter
	(CharacterName, CharacterMovie, CharacterRating, CharacterWage, AgentID)
Values
	('Guy in red uniform', 'Star Trek II', '4', 20000, 1)
Go