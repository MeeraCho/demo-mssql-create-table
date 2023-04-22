--SP DML
--INSERT INTO 
--Create a Stored Procedure to insert a new club with Error check 

Create Procedure AddClub (@ClubID varchar(10) = null, @clubName varchar(50) = null)
AS
IF @ClubID is null or @clubname is NULL
    BEGIN
    RAISERROR ('You must provide a club ID and a Club Name', 16, 1)
    END
ELSE
    BEGIN
    insert into Club (ClubID, ClubName)
    values (@ClubID, @ClubName)
    IF @@ERROR <> 0
        BEGIN
        RAISERROR('Club insert failed', 16, 1)
        END
    END
RETURN
GO

Exec AddClub 'ACM'
GO


-- Auto generate PK to a new insert. @@identity
Create Procedure AddPaymentType (@PaymentTypeDescription varchar(40) = null)
AS
If @PaymentTypeDescription is NULL
    BEGIN
    RaisError('You must provide A Payment Description', 16, 1)
    END
ELSE
    BEGIN
    INSERT INTO PaymentType (PaymentTypeDescription)
    Values (@PaymentTypeDescription)
    If @@ERROR<>0
        BEGIN
        RAISERROR('Payment Type insert failed', 16, 1)
        END
    ELSE
        BEGIN
        Select @@identity 'New payment Type ID'
        END
    END
RETURN
GO


--DELETE with Error Message 
--get No Error message back, that's not an error conditions, but let the user know 
Create Procedure DeleteClub (@ClubID varchar(10)=null)
AS
IF @ClubID is NULL
    BEGIN
    Raiserror ('Must Provide a Club ID', 16, 1)
    END
ELSE
    BEGIN
    Delete Club where ClubID = @ClubID
    IF @@ERROR <> 0
        BEGIN
        RaisError('Delete Failed', 16, 1)
        END
    END
RETURN
GO


--delete after exist check
Create Procedure DeleteClub (@ClubID varchar(10)=null)
AS
IF @ClubID is NULL
    BEGIN
    Raiserror ('Must Provide a Club ID', 16, 1)
    END
ELSE
    BEGIN
    IF not Exists(Select * from Club where ClubID = @ClubID)
        BEGIN
        RaisError('That Club ID does not exist', 16, 1)
        END
    ELSE --if exist
        BEGIN
        Delete club where ClubID = @ClubID
        IF @@ERROR <> 0
            BEGIN
            RaisError('Delete failed', 16, 1)
            END
        END
    END
RETURN
GO



-- SP DML EXERCISE 
-- For this exercise you will need a local copy of the IQSchool database. 
-- 1.Create a stored procedure called ‘AddClub’ to add a new club record.
Create Procedure AddClub (@ClubId varchar(10) = null, @clubName varchar(30) = null)
AS
IF @ClubId = null or @clubName is null
    BEGIN
    RaisError('You must provide a club Id and a Club Name', 16, 1)
    END
ELSE
    BEGIN
    IF exists (select * from club where clubName = @clubName)
        BEGIN
        RAISERROR('The club with this name already exists', 16, 1)
        END
    ELSE
        BEGIN
        Insert Into Club (clubID, clubName)
        values (@clubId, @clubName)

        IF @@ERROR <> 0
            BEGIN
            RAISERROR('The Insert failed', 16, 1)
            END
        END
    END
RETURN
GO

-- 2.Create a stored procedure called ‘DeleteClub’ to delete a club record.
    -- 1. parameter 넣었는지? 2. 해당 데이터 있는지 없는지? 3. 내용 4. 마지막 에러난 거 없는지? 
Create Procedure DeleteClub (@ClubID char(10) = null)
AS
IF @clubID is null
    BEGIN
    RaisError ('Must provide a Club id', 16, 1)
    END
ELSE
    BEGIN
    IF NOT exists (select * from club where clubId = @clubID)
        BEGIN
        Raiserror('That Club does not exist', 16, 1)
        END
    ELSE
        BEGIN
        Delete Club where ClubId = @ClubID 
        IF @@Error <> 0 
            BEGIN
            RaisError ('Delete failed', 16, 1)
            END
        END
    END
RETURN
GO


-- 3.Create a stored procedure called ‘Updateclub’ to update a club record. Do not update the primary key!
Create Procedure UpdateClub (@ClubId varchar(10) = null, @clubName varchar(30) = null)
AS
IF @ClubId is null or @clubName is null
    BEGIN
    RAISERROR('You must provide a club ID and a club name', 16, 1)
    END
ELSE
    BEGIN
    IF NOT exists(select * from club where clubID = @clubID)
        BEGIN   
        RAISERROR('The club does not exist', 16, 1)
        END
    ELSE
        BEGIN
        UPDATE Club
        SET
        clubName = @clubName 
        where clubid = @clubid

        IF @@ERROR <> 0 
            BEGIN
            RAISERROR('Update failed', 16, 1)
            END
        END
    END
RETURN
GO

-- 4.Create a stored procedure called ‘ClubMaintenance’. It will accept parameters for both ClubID and ClubName 
    -- as well as a parameter to indicate if it is an insert, update or delete. This parameter will be ‘I’, ‘U’ or ‘D’.  
    -- insert, update, or delete a record accordingly. 
    -- Focus on making your code as efficient and maintainable as possible.
Create Procedure ClubMaintenance (@clubId varchar(10) = null, @clubName varchar(30) = null, @Type char(1) = null)
AS
IF @clubId is null or @clubName is null or @Type is null
    BEGIN
    RAISERROR('You must provide a club id, a club name and a type of acttion', 16, 1)
    END
ELSE
    BEGIN
    IF @type = 'I'
        BEGIN
        insert into club (clubId, clubName)
        values (@clubID, @clubName)
        END
    ELSE 
        BEGIN
        IF not exists (select * from club where clubID = @clubID)
            BEGIN
            RAISERROR('This club does not exist ', 16, 1)
            END
        ELSE
            BEGIN
            IF @type = 'U'
                BEGIN
                Update Club
                SET ClubName = @ClubName 
                WHERE clubId = @clubID
                END
            ELSE
            IF @type = 'D'
                BEGIN
                Delete Club where ClubId = @clubID 
                END
            END
        END
    IF @@ERROR <> 0 
        BEGIN
        RAISERROR('The Operation failed', 16, 1)
        END
    END
RETURN
GO

exec ClubMaintenance 'GO', 'NAIT GO Club', 'I'
select * from club
GO


-- 5.Create a stored procedure called ‘RegisterStudent’ that accepts StudentID and OfferingCode as parameters. 
    -- If the number of students in that Offering are not greater than the Max Students for that course, 
    -- add a record to the Registration table and add the cost of the course to the students balance. 
    -- If the registration would cause the Offering to have greater than the MaxStudents raise an error. 
    -- 1. register student by adding registeration record

Alter Procedure RegisterStudent (@StudentID int = null, @offeringCode int = null)
AS
IF @StudentID is null or @offeringCode is null
    BEGIN
    RAISERROR('You must provide a Student ID and a offering Code', 16, 1)
    END
ELSE
    BEGIN
    Declare @MaxStudents smallint
    Declare @CurrentCount smallint 
    Declare @CourseCost money

    Select @MaxStudents = MaxStudents from Course -- 4명
        inner join offering on course.courseID = offering.courseID 
        where offeringcode = @offeringCode
    Select @CurrentCount = Count(*) from Registration  -- 9명 
        where OfferingCode = @offeringCode and WithdrawYN <> 'Y'
    Select @CourseCost = CourseCost from Course --$450 (DMIT163)
        inner join offering on course.courseID = offering.CourseID
        where offering.OfferingCode = @offeringCode
    
    IF @MaxStudents = @CurrentCount
        BEGIN
        RAISERROR('The course is already full', 16, 1)
        END
    ELSE
        BEGIN
        INSERT INTO Registration (StudentID, OfferingCode)
        Values (@StudentID, @offeringCode)
        IF @@ERROR <> 0 
            BEGIN
            RaisError ('Registration Insert Failed', 16, 1)
            END
        ELSE
            BEGIN
            --if not exists를 넣지 않는 이유는 위 insert에서 @studentID가 이상하면 studentID가 이상해지고 offering에서 studentID가 fk라서 에러가 발생되어 else는 실행되지 않는다. 
            UPDATE Student
            Set BalanceOwing = BalanceOwing + @CourseCost -- 0 + 450
            Where StudentID = @StudentID
            Print 'Update Completed, Check Student Table'

            IF @@error <> 0 
                BEGIN
                RaisError ('Balance update failed', 16, 1)
                END
            END
        END
    END
RETURN
GO

Exec RegisterStudent '199899200', '1100'
GO


-- 6.Create a procedure called ‘StudentPayment’ that accepts PaymentID, Student ID, paymentamount, and paymentTypeID as parameters. 
    -- Add the payment to the payment table and adjust the students balance owing to reflect the payment. 
Create Procedure StudentPayment (@PaymentID int = null, @StudentID int = null, @paymentAmount smallmoney = null, @PaymentTypeID tinyint = null)
AS
IF @PaymentID is null or @StudentID is null or @paymentAmount is null or @PaymentTypeID is null
    BEGIN
    RAISERROR ('You must provide a payment ID, Student ID, Payment Amount and a Payment Type ID ', 16, 1)
    END
ELSE
    BEGIN
    insert into Payment(paymentDate, paymentID, Amount, PaymentTypeID, StudentID)
    Values (getdate(), @paymentID, @paymentAmount, @paymentTypeID, @StudentID)
    IF @@error <> 0
        BEGIN
        RAISERROR('Insert failed', 16, 1)
        END
    ELSE
        BEGIN
        --do not need to check for exists since the previous insert would have failed if the studentID was not a valid student
        Update Student
        SET
        BalanceOwing = BalanceOwing - @paymentAmount
        Where StudentID = @StudentID
        IF @@error <> 0
            BEGIN
            RAISERROR('Update failed', 16, 1)
            END
        END
    END
RETURN
GO


-- 7.Create a stored procedure called ‘FireStaff’ that will accept a StaffID as a parameter. 
    -- Fire the staff member by updating the record for that staff and entering todays date as the DateReleased. 
Create Procedure FireStaff (@staffID int = null)
AS
IF @StaffId is null
    BEGIN
    RAISERROR ('You must provide a staff ID', 16, 1)
    END
ELSE
    BEGIN
    IF Not Exists (Select * from Staff where StaffID = @StaffID)
        BEGIN
        RAISERROR('This Staff does not exist', 16, 1)
        END
    ELSE
        BEGIN
        UPDATE Staff
        SET
        DateReleased = getdate() where StaffID = @StaffID
        IF @@ERROR <> 0 
            BEGIN
            RAISERROR('Firing failed', 16, 1)
            END
        END
    END
RETURN
GO

-- 8.Create a stored procedure called ‘WithdrawStudent’ that accepts a StudentID, and OfferingCode as parameters. 
    -- Withdraw the student by updating their Withdrawn value to ‘Y’ and subtract ½ of the cost of the course from their balance. 
    -- If the result would be a negative balance set it to 0.
Alter Procedure WithdrawStudent (@StudentID int = null, @offeringCode int = null)
AS
Declare @CourseCost decimal (6,2)
Declare @Amount decimal (6,2)
Declare @BalanceOwing decimal (6,2)
Declare @Difference decimal (6,2)

IF @StudentID is null or @offeringCode is NULL  
    BEGIN
    RAISERROR('You must provide a student ID and an offering Code', 16, 1)
    END
ELSE
    BEGIN
    IF not exists (Select * from Registration where StudentID = @StudentID and offeringCode = @offeringCode)
        BEGIN
        RAISERROR('That Student does not exist in that registration', 16, 1)
        END
    ELSE
        BEGIN
        UPDATE Registration
        SET WithdrawYN = 'Y'
        WHERE StudentID = @StudentID and OfferingCode = @offeringCode
        IF @@ERROR <> 0
            BEGIN
            RAISERROR('Registration update failed', 16, 1)
            END
        ELSE
            BEGIN
            Select @CourseCost = courseCost from Course 
                inner join offering on course.courseID = offering.courseID
                WHERE offering.OfferingCode = @offeringCode
            Select @BalanceOwing = BalanceOwing from Student   
                WHERE studentID = @studentID 
            Select @Difference = @BalanceOwing - @CourseCost/2

            IF @difference > 0 
                set @amount = @difference
            ELSE
                set @amount = 0 

            Update Student
            Set BalanceOwing = @amount
            Where StudentID = @StudentID 

            IF @@ERROR <> 0 
                BEGIN
                RAISERROR('Balance Update Failed', 16, 1)
                END
            END
        END
    END
RETURN
GO

Exec WithdrawStudent 199899200, 1002
go



drop Procedure PracticeWithdrawStudent 
go


Create Procedure PracticeWithdrawStudent (@StudentID int = null, @offeringCode int = null)
AS
IF @StudentID is null or @offeringCode is NULL  
    BEGIN
    RAISERROR('You must provide a student ID and an offering Code', 16, 1)
    END
ELSE
    BEGIN
    IF not exists (Select * from Registration where StudentID = @StudentID and offeringCode = @offeringCode)
        BEGIN
        RAISERROR('That Student does not exist in that registration', 16, 1)
        END
    ELSE
        BEGIN
        UPDATE Registration
        SET WithdrawYN = 'Y'
        WHERE StudentID = @StudentID and OfferingCode = @offeringCode
        IF @@ERROR <> 0
            BEGIN
            RAISERROR('Registration update failed', 16, 1)
            END
        ELSE
            BEGIN
            Declare @CourseCost decimal (6,2)
            Declare @Amount decimal (6,2)
            Declare @BalanceOwing decimal (6,2)
            Declare @Difference decimal (6,2)

            Select @CourseCost = courseCost from Course
                inner join offering on course.courseID = offering.courseID
                WHERE offering.OfferingCode = @offeringCode
            Select @BalanceOwing = BalanceOwing from Student   
                WHERE studentID = @studentID 
            Select @Difference = @BalanceOwing - @CourseCost/2

            print(@CourseCost)
            print(@Amount)
            print(@BalanceOwing)
            print(@Difference)

            IF @@ERROR <> 0 
                BEGIN
                RAISERROR('Balance Update Failed', 16, 1)
                END
            END
        END
    END
RETURN
GO

Exec PracticeWithdrawStudent 199899200, 1002


select * from Student
select * from Offering
select * from Registration






go

-- 내가 한 솔루션 ---
    -- * 수업 하나에 대한 withdraw임. 수업료 얼마인지? 
    -- offering/offeringcode로 courseId 알아냄 
    -- course/ CourseID로 courseCost 알아냄 
    -- CourseCost의 절반 가격 획득
    -- @halfCourseCost  

    -- * 해당 학생의 balance 알아내기 
        --@balance를 만들어 지금까지 학생이 낸 balance 입력
        --payment/amount where studentID

    -- * @balance - @halfCourseCost 를 빼기 

    -- * WithdrawYN을 Y로 바꾸기
        --registration - offeringCode, StudentID --> WithdrawYN을 Y로 바꾸기 

Create Procedure WithdrawStudent (@StudentID int = null, @offeringCode int = null)
AS 
IF @StudentID is null or @offeringCode is null
    BEGIN
    RAISERROR('Must Provide a student ID and a offering Code', 16, 1)
    END
ELSE 
    BEGIN
    Declare @halfCourseCost money
    Declare @StudentBalance money

    Select @halfCourseCost = CourseCost / 2 from Course
        inner join offering on course.courseID = offering.CourseID
        where OfferingCode = @offeringCode
    Select @StudentBalance = sum(amount) from Payment
        where studentID = @studentID

    IF not exists (select * from student where studentID = @studentID) or (Select * from offering from OfferingID = @offeringCode)
        BEGIN
        RAISERROR('Does not exist StudentID or OfferingCode', 16, 1)
        END
    ELSE
        BEGIN 
        @StudentBalance - @halfCourseCost 
        where studentID = @studentID
        IF @@ERROR <> 0
            BEGIN
            RAISERROR('Withdrawal failed', 16, 1)
            END
        ELSE
            BEGIN
            UPDATE Registration
            set
            withdrawYN = 'Y'
            IF @@error <> 0
                BEGIN
                RAISERROR('Withdraw Student failed', 16, 1)
                END
            END
        END
    END
RETURN 








select * from offering
select * from student

