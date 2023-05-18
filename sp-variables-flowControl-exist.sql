
--Stored Procedure VARIABLES
--Variable is a named spot in memory. 
--Variables must start with @ and declared before using

--Declaring a Variable
Declare @firstname varchar(30)
GO

--USE SET or SELECT (subquery) to populate a variable
    --SET
    Declare @firstName varchar(30)
    Set @FirstName = 'Homer'
    print @firstname 
    go 

    --SELECT
    Declare @firstName varchar(30)
    Select @firstName = 'Homer'
    print @firstName 
    --Usually we are selecting from the DB to put into varialbes.


--if you need query or subquery you need a value. value = 'Homer' subquery = 'Homer'
--Data From the DB into a variable
--in most cases, we use the term Constance rather than Variable 
    --Using Set (not recommended)
    Declare @firstname varchar(30)
    Set @firstname = (Select firstName from staff where staffid = 1) --Donna
    print @firstname
    go

    --Using Select --better way than above 
    Declare @firstname varchar(30)
    Select @firstname = fristName from staff where staffid = 1 --Shorter
    print @firstname
    go 


--Select FirstName, LastName, PositionID for StaffID=1 into 3 variables. 
--Using SET  --recommended when hardcoding style
Declare @firstName varchar(30)
Declare @LastName varchar(30)
Declare @PositionId varchar(30)
Set @FirstName = (Select firstName from staff where staffID = 1) 
Set @lastName = (Select lastName from staff where staffID = 1)
Set @PositionID = (Select positionID from staff where staffID = 1) --3 queries 
print @firstname
print @lastname
print @positionID

--Using Select  --recommended when getting data from the DB
Declare @firstName varchar(30)
Declare @LastName varchar(30)
Declare @PositionId varchar(30)
Select 
    @FirstName = firstName, 
    @lastname = lastname, 
    @positionId = positionID 
    from staff where staffID = 1   --1 query 
print @firstname
print @lastname
print @positionID 


--Decisions(IF/ELSE)
Declare @firstname varchar(30)
set @firstname ='joe'
if @firstname = 'Joe'
    print'Hello Joe!'
else 
    print 'Hello, Whoever you are!'

--more that one line on the if/else
    --If you have one more line after the if/else you need code block delimiters (BEGIN/END)
Declare @firstname varchar(30)
set @firstname ='joes'
if @firstname = 'Joe'
    Begin
    print'Hello Joe!'
    print'How are you doing'
    End
else 
    Begin
    print 'Hello, Whoever you are!'
    print 'I am sure your name is nice too!'
    End

--Nested Decisions
Declare @City varchar(20)
Declare @StudentID INT
Set @StudentID = 199899200
Select @City = city from student where studentID = @StudentID
If @City = 'Edmonton'
    BEGIN
    Print'That is awesome!'
    End
Else 
    BEGIN
    if @City = 'Red Deer'
        BEGIN
        print 'That is ok too!'
        END
    ELSE  
        BEGIN  
        if @city = 'Calgary'
            BEGIN
            print 'I am so sorry.'
            END
        ELSE
            BEGIN
            Print 'That is a cool city as well.'
            END
        END
    END
GO



--We could remove extra code block delimiters (Begin/End)
If @City = 'Edmonton'
    Print'That is awesome!'
Else 
    if @City = 'Red Deer'
        print 'That is ok too!'
    ELSE  
        if @city = 'Calgary'
            print 'I am so sorry.'
        ELSE
            Print 'That is a cool city as well.'
GO



--EXISTS
    --Used to determine if there is at least ONE record that meets certain criteria
    --Use with if statements

    --if exists (query) if the query returns at least one record then it returns True

    --If there is a position that has no staff in it, print 'need more staff'
    If exists (Select * from position where positionID not in (select positionID from staff))
        BEGIN
        print 'Need More Staff'
        END
    go


-- Flow Control and Variables Exercise 
-- 1.	Create a stored procedure called StudentClubCount. 
    -- It will accept a clubID as a parameter. 
    -- If the count of students in that club is greater than 2, print ‘A successful club!’. 
    -- If the count is not greater than 2 print ‘Needs more members!’.

   --if 일 때 variable is null 인 경우 옴
Create Procedure StudentClubCount(@clubID varchar(10) = null)
AS
IF @clubID is null 
    BEGIN
    print 'Must provide ClubID'
    raiserror ('Must provide ClubID', 16, 1)
    END
ELSE
    BEGIN
    declare @count INT
    select @count = count(*) from activity where clubID = @clubID
    IF count(*) > 2 
        Begin
        print 'A successful club'
        END
    ELSE
        BEGIN
        print 'Needs more members!'
        END
    END
RETURN

Exec StudentClubCount "NAITSA"
go

-- 2.Create a stored procedure called BalanceOrNoBalance. 
    --It will accept a studentID as a parameter. 
    --Each course has a cost. 
    --If the total of the costs for the courses the student is registered in is more than 
    --the total of the payments that student has made then print ‘balance owing !’ otherwise print ‘Paid in full! Welcome to School 158!’
    -- Do Not use the BalanceOwing field in your solution. 
    Create Procedure BalanceOrNoBalance (@studentID int = null)
    AS
    IF @studentID is null
        BEGIN
        print 'Must Provide StudentID'
        Raiserror ('Must Provide StudentID', 16, 1)
        END
    ELSE
        BEGIN
        Declare @fees decimal(6,2), @Payments money
        Select @fees = sum(courseCost) from course 
            inner join offering on course.courseID = offering.CourseID
            inner join registration on offering.offeringCode = registration.offeringcode
            where studentID = @studentID
        Select @payments = sum(amount)from payment where studentID = @studentID

        IF @fees > @Payments    
            BEGIN
            print 'balance owing !'
            END
        ELSE
            BEGIN
            print 'Paid in full! Welcome to School 158!'
            END
        END
    Return

    Exec BalanceOrNoBalance 199899200
    go

-- 3.Create a stored procedure called ‘DoubleOrNothin’. 
    --It will accept a students first name and last name as parameters. 
    --If the student name already is in the table then print ‘We already have a student with the name firstname lastname!’ 
    --Other wise print ‘Welcome firstname lastname!’
    Create Procedure DoubleOrNothin (@StudentFirstName varchar(25)=null, @StudentLastName varchar(35)=null)
    AS
    IF @StudentFirstName is null or @StudentLastName is null 
        BEGIN
        print 'Must provide first name and last name'
        Raiserror ('Must provide first name and last name', 16, 1)
        END
    ELSE
        BEGIN
        IF Exists (Select * from Student where FirstName = @StudentFirstName and LastName = @StudentLastName)
            BEGIN
            print 'We already have a student with the name' + @StudentFirstName + ' ' + @StudentLastName
            END
        ELSE
            BEGIN
            print 'Welcome ' +  @StudentFirstName + ' ' + @StudentLastName + '!'
            END
        END
    RETURN
    GO


-- 4.Create a procedure called '‘StaffRewards’'. 
    -- It will accept a staffID as a parameter. 
    -- If the number of students (include students taught several times) the staff member has ever taught is between 0 and 10, print ‘Well done!’, 
    -- if it is between 11` and 20 print ‘Exceptional effort!’, if the number is greater than 20 print ‘Totally Awesome Dude!’
    Create Procedure StaffRewards (@StaffID smallint = null)
    AS
    IF @StaffID is null
        BEGIN
        print 'Must Provide StaffID'
        Raiserror ('Must Provide StaffID', 16, 1)
        END
    ELSE
        BEGIN
        Declare @StaffCount smallint        
        Select @StaffCount = count(*) from offering 
            inner join Registration on offering.OfferingCode = Registration.OfferingCode
            where staffID = @staffID
        IF @StaffCount between 0 and 10 
            BEGIN
            print 'Well Done !'
            END
        ELSE 
            BEGIN
            IF @StaffCount between 11 and 20 
                BEGIN
                print 'Exceptional effort!'
                END
            ELSE
                BEGIN
                print 'Totally Awesome Dude!'
                END
            END
        END
    RETURN    
