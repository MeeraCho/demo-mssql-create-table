--Transactions
Create Table Account
(
    CustomerID int not null identity(1,1) constraint pk_Account primary key,
    AccountBalance smallmoney not null
)

insert into Account(AccountBalance)
VALUES
(500),
(500)

select * from account
--Move $200 from Customer1 to Customer2
    --step 1. Subtract $200 from customer1
    --step 2. add $200 to customer2

--SYNTAX
--Begin Transaction
    -- Starts a transaction
    -- Any changes to the data after the begin transaction are reversable
-- Rollback Transaction
    -- Reverse the changes to the data between  the rollback transaction and the Begin Transaction
-- Commit Transaction - Makes the changes to the data between the commit transaction and the rollback transaction permanent
    -- Your Begin Transaction MUST end in either a rollback transaction OR a commit transaction
-- Delete the registration Records and rollback           
 
--Delete the registration Records and Rollback 
Begin TRANSACTION
Select * from Registration 
Delete Registration
Select * from Registration 
Rollback Transaction 
Select * from Registration 
 
--Delete the registration Records and Commit 
-- 그냥 지워져버림 !! 조심 !!  
Begin TRANSACTION
Select * from Registration 
Delete Registration
Select * from Registration 
Commit Transaction 
Select * from Registration 
GO


Create Procedure TransferFunds(@FromCustomerID int = null, @ToCustomerID int = null, @Amount smallmoney = null)
AS
IF @FromCustomerID is null or @ToCustomerID is null or @Amount is null
    BEGIN
    RAISERROR('You must provide a FromCustiomerID and a ToCustiomerID and Amount', 16, 1)
    END
ELSE
    BEGIN
    IF not exists (select * from Account where CustomerID = @FromCustomerID) or not exists (Select * from Account where CustomerID = @ToCustomerID)
    RAISERROR('One or more customerID''s are not in the Account Table', 16, 1)
    ELSE
        BEGIN
        --Begin Transaction, It should be right before the first statement
            BEGIN TRANSACTION
            Update Account
            SET AccountBalance -= @Amount 
            Where CustomerID = @FromCustomerID 

            IF @@ERROR <> 0 
                BEGIN
                RAISERROR('Failed Subtracting Funds', 16, 1)
                ROLLBACK TRANSACTION
                END
            ELSE
                BEGIN
                Update Account
                Set AccountBalance += @amount
                where customerID = @ToCustomerID

                IF @@ERROR <> 0
                    BEGIN
                    RAISERROR('Failed Adding Funds', 16, 1)
                    ROLLBACK TRANSACTION -- 이 전까지의 모든 transaction이 다시 원상복구
                    END
                ELSE
                    BEGIN
                    COMMIT TRANSACTION
                    END
                END
        END    
    END
RETURN
GO


--Framework for transaction 
-- Begin Transaction
-- DML1
-- if @@errror <> 0
--     RAISERROR
--     ROLLBACK TRANSACTION
-- ELSE
--     DML2
--     if @@error<>0
--         RAISERROR
--         ROLLBACK TRANSACTION
--     ELSE
--         DML3
--         if @@error<>0
--             RAISERROR
--             ROLLBACK TRANSACTION
--         ELSE
--             commit transaction 




-- Transaction Exercise
-- 1.Create a stored procedure called 'RegisterStudentTransaction' that accepts StudentID and offering code as parameters. 
    -- If the number of students in that course and semester are not greater than the Max Students for that course, 
    -- add a record to the Registration table and add the cost of the course to the students balance. 
    -- If the registration would cause the course in that semester to have greater than MaxStudents for that course raise an error.
--선생님 코드 
Alter Procedure RegisterStudentTransaction (@studentID int = null, @offeringCode int = null)
AS
IF @studentID is null or @offeringCode is null 
    BEGIN
    RAISERROR('You must provide a student Id and an offering code ', 16, 1)
    END
ELSE
    BEGIN
    DECLARE @MaxStudents SMALLINT
    DECLARE @CurrentCount SMALLINT
    DECLARE @CourseCost MONEY

    Select @MaxStudents = MaxStudents from Course 
        Inner Join Offering on Course.CourseId = Offering.CourseID
        Where OfferingCode = @offeringCode
    Select @CurrentCount = Count(*) from Offering   
        Inner Join Registration on Offering.OfferingCode = Registration.OfferingCode
        Where Offering.OfferingCode = @offeringCode and WithdrawYN <> 'Y'
    Select @CourseCost = CourseCost from Course
        inner join Offering on Course.CourseId = Offering.CourseID
        Where Offering.OfferingCode = @offeringCode
    IF @MaxStudents = @CurrentCount
        BEGIN
        RAISERROR('The Class is already full', 16, 1)
        END
    ELSE
        BEGIN
        BEGIN TRANSACTION -- 여기부터 데이터에 변화가 옴
        INSERT INTO Registration (StudentID, OfferingCode)
        VALUES (@studentID, @offeringCode)
        IF @@ERROR <> 0 
            BEGIN
            RAISERROR('Registration Insert Failed', 16, 1)
            ROLLBACK TRANSACTION -- 1번째 DML이 잘못된 경우 에러가 나서 데이터 변경이 된 것이 없어 rollback이 필요하지는 않지만 그래도 써준다. 
            END
        ELSE
            BEGIN
            UPDATE Student
            SET
            BalanceOwing = BalanceOwing + @CourseCost
            WHERE StudentID = @studentID

            IF @@ERROR <> 0 
                BEGIN
                RAISERROR('Balance Update failed', 16, 1)
                ROLLBACK TRANSACTION
                END
            ELSE
                BEGIN
                COMMIT TRANSACTION -- 
                END
            END
        END
    END
RETURN
GO


Exec RegisterStudentTransaction 198933540, 1007
GO



-- 2.Create a procedure called ‘StudentPaymentTransaction’ that accepts StudentID, paymentamount, PaymentTypeID as parameters. 
    -- Add the payment to the payment table and adjust the students balance owing to reflect the payment.
Create Procedure StudentPaymentTransaction (@StudentID int = null, @PaymentAmount money = null, @PaymentTypeID tinyint = null)
AS
IF @StudentID is null or @PaymentAmount is null or @PaymentTypeID is null
    BEGIN
    RAISERROR('You must provide a student ID, a payment amount and a payment Type ID', 16, 1)
    END
ELSE
    BEGIN
    BEGIN TRANSACTION
    Insert Into Payment(PaymentDate, Amount, PaymentTypeID, StudentID)
    Values (getDate(), @PaymentAmount, @PaymentTypeID,  @StudentID)
    IF @@ERROR <> 0 
        BEGIN
        RAISERROR('Payment failed', 16, 1)
        ROLLBACK TRANSACTION
        END
    ELSE
        BEGIN
        Update Student
        SET BalanceOwing = BalanceOwing - @PaymentAmount 
        WHERE StudentID = @StudentID
        IF @@ERROR <> 0
            BEGIN
            RAISERROR('Balance Update failed', 16, 1)
            ROLLBACK TRANSACTION
            END
        ELSE
            BEGIN
            COMMIT TRANSACTION
            END
        END
    END
RETURN
GO


-- 3.Create a stored procedure called ‘WithdrawStudentTransaction’ that accepts a StudentID and offeringcode as parameters.
    -- Withdraw the student by updating their Withdrawn value to ‘Y’ and 
    -- subtract ½ of the cost of the course from their balance. 
    -- If the result would be a negative balance set it to 0.
Alter Procedure WithdrawStudentTransaction (@studentID int = null, @offeringCode int = null)
AS
Declare @CourseCost decimal (6, 2)
Declare @Amount decimal (6, 2)
Declare @BalanceOwing decimal (6, 2)
Declare @Difference decimal (6, 2)
IF @StudentID is null or @offeringCode is null
    BEGIN
    RAISERROR('You must provide a student ID and a offering code', 16, 1)
    END
ELSE
    BEGIN
    IF NOT EXISTS (Select * from Registration where studentID = @StudentID and OfferingCode = @OfferingCode)
        BEGIN
        RAISERROR('That Student does not exist in that registration', 16, 1)
        END
    ELSE
        BEGIN
        BEGIN TRANSACTION
        UPDATE Registration
        SET
        WithdrawYN = 'Y'
        Where OfferingCode = @offeringCode and StudentID = @studentID

        IF @@ERROR <> 0 
            BEGIN
            RAISERROR('Registration update failed', 16, 1)
            ROLLBACK TRANSACTION
            END
        ELSE
            BEGIN
            Select @CourseCost = Coursecost from Course
                inner join offering on Course.courseID = offering.CourseID
                Where offering.offeringCode = @offeringCode
            Select @BalanceOwing = BalanceOwing from Student    
                Where StudentID = @StudentID
            Select @Difference = @BalanceOwing - @CourseCost/2

            IF @Difference > 0 
                Set @Amount = @Difference
            ELSE
                set @Amount = 0 
        UPDATE Student
        Set BalanceOwing = @Amount
        Where StudentID = @StudentID
        IF @@ERROR <> 0
            BEGIN
            RAISERROR('Balance updated failed', 16, 1)
            ROLLBACK TRANSACTION
            END
        ELSE
            BEGIN
            COMMIT TRANSACTION
            END
        END
    END
RETURN
GO

    
-- 4.Create a stored procedure called ‘DisappearingStudent’ that accepts a studentID as a parameter and deletes all records pertaining to that student. 
    -- It should look like that student was never in IQSchool! 
    -- Child table 먼저 지워야 
Create Procedure DisappearingStudent (@StudentID int = null)
AS
IF @StudentID is null 
    BEGIN
    RAISERROR('You must provide a student ID', 16, 1)
    END
ELSE
    BEGIN
    BEGIN TRANSACTION
    Delete Registration where StudentID = @StudentID
    IF @@ERROR <> 0
        BEGIN
        RAISERROR('Grade delete Filed', 16, 1)
        ROLLBACK TRANSACTION
        END
    ELSE
        BEGIN
        DELETE Payment where StudentID = @StudentID
        IF @@ERROR <> 0
            BEGIN
            RAISERROR('Payment delete Filed', 16, 1)
            ROLLBACK TRANSACTION
            END
        ELSE
            BEGIN
            Delete Activity where StudentID = @StudentID
            IF @@ERROR <> 0
                BEGIN
                RAISERROR('Activity delete Filed', 16, 1)
                ROLLBACK TRANSACTION
                END
            ELSE
                BEGIN
                Delete Student where StudentID = @StudentID
                IF @@ERROR <> 0
                    BEGIN
                    RAISERROR('Student delete Filed', 16, 1)
                    ROLLBACK TRANSACTION
                    END
                ELSE
                    BEGIN
                    COMMIT TRANSACTION
                    END
                END
            END
        END
    END
RETURN

-- 5.Create a stored procedure that will accept a year and will archive all registration records from that year (startdate is that year) 
    -- from the registration table to an archiveregistration table. 
    -- Copy all the appropriate records from the registration table to the archiveregistration table and delete them from the registration table. 
    -- The archiveregistration table will have the same definition as the registration table but will not have any constraints.

--ARCHIVE TABLE 먼저 Registration과 같은 테이블을 만든다
Create Table ArchiveRegistration
(
    OfferingCode int,
    StudentID int,
    Mark decimal(5, 2),
    WithdrawYN char(1)
)
GO



Create Procedure Archive (@recordyear char(4) = null)
AS
IF @recordyear is NULL  
    BEGIN
    RaisError('You must provide a recordyear', 16, 1)
    END
ELSE
    BEGIN
    BEGIN TRANSACTION
    insert into archiveRegistration (offeringcode, studentid, mark, withdrawYN)
    SELECT Offering.OfferingCode, studentID, mark, withdrawYN from Registration 
        inner join Offering on registration.OfferingCode = offering.OfferingCode
        inner join semester on semester.SemesterCode = offering.SemesterCode
        where DATEPART(yy.startdate) = @recordyear
    
    IF @@ERROR <> 0
        BEGIN
        RAISERROR('Archive failed', 16, 1)
        ROLLBACK TRANSACTION
        END
    ELSE
        BEGIN
        delete Registration 
            where offeringcode in(select offeringcode from offering where semestercode in (select semestercode from semester where datepart(yy, startdate) = @recordyear))
        IF @@ERROR <> 0
            BEGIN
            RAISERROR('Archive failed', 16, 1)
            ROLLBACK TRANSACTION
            END
        ELSE
            BEGIN
            COMMIT TRANSACTION
            END
        END
    END






Select * from student
Select * from offering
Select * from Course
Select * from registration
Select * from payment

