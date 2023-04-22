
--SP with Parameters
    --parameters except values from the users when we call the stored procedure 
    --So, accepting data from user, make them nuch more flexble, robust and reusable
    --how can we add parameter storage server procedures and make them much useful 
    --given value, given course 등 앞에 GIVEN이 붙으면 parameters임 

    Create Procedure ListOneStudent(@StudentID int)
    as 
    Select firstName, LastName from Student
    Where studentID = @studentID
    return 

    Execute ListOneStudent 199899200  --Ivy Kent
    go

    --More than one parameter
    Create procedure ListStudentsByName (@firstName varchar(25), @lastName varchar(25))
    as 
    Select studentID, FirstName, LastName, City from student
    where firstName = @firstName and lastName = @lastName
    return 

    Execute ListStudentsByName 'Thomas', 'Brown'


--Parameters are not optional
Exec ListOneStudent --Error you have to input @StudentID parameter 
go

--DEFAULT Parameters
--You can assign defaults to parameters
Alter Procedure ListOneStudent(@StudentID int = null) -- default를 null로 설정해 준다
as 
Select firstName, LastName from Student
Where studentID = @studentID
return 
go

Exec ListOneStudent 
GO


--Error message with 1 Parameters
    --if the SP is called and values are not passed to the parameters, let the user know they must be provided
   Alter Procedure ListOneStudent(@StudentID int = null)
    as 
    if @studentID is null 
        --let the user know
        BEGIN
        RaisError('You must supply a student ID', 16, 1) --16: 16 severe level will be cut as a runtime error. 1: state (13:00경 설명)
        END
    ELSE    
        BEGIN
        SELECT firstName, lastName from student
        Where studentID = @StudentID
        END
    return 

    Execute ListOneStudent 199899200  --Ivy Kent
    Execute ListOneStudent -- Msg 50000, Level 16, State 1, Procedure ListOneStudent, Line 6 You must supply a student ID
    go

-- Error message with 2 Parameters
Alter procedure ListStudentsByName (@firstName varchar(25)=null, @lastName varchar(25)=null)
    as 
    IF @firstName is null or @lastName is null 
        BEGIN
        RAISERROR('You must provide a firstName and lastName', 16, 1)
        END
    ELSE
        BEGIN
        SELECT studentID, FirstName, LastName, City from Student
        Where firstName = @firstName and lastName = @lastName
        END
    RETURN
GO





-- Stored Procedure EXERCISE – PARAMETERS
-- **Stored Procedure has to be the first statement in a batch so place GO in between each question to execute the previous batch (question) and start another. NOTE: all parameters are required. Raise an error message if a parameter is not passed to the procedure.

-- 1.Create a stored procedure called “GoodCourses” to select ALL the course names and averageMark that have averages greater than a Given value. 
Alter Procedure GoodCourses (@average decimal(5,2) = null)
AS
IF @average is null 
    BEGIN
    Raiserror ('Must provide an Average', 16, 1)
    END
ELSE
    BEGIN
    Select coursename, avg(mark)'AverageMark' from course 
    inner join offering on course.courseID = offering.courseID
    inner join registration on offering.offeringCode = registration.offeringcode
    group by course.courseID, CourseName 
    having avg(mark) >  @average
    END
RETURN

execute goodcourses 80
GO


-- 2.Create a stored procedure called “HonorCoursesForOneTerm” to select all the course names 
    --that have average > a given value in a given semester. 
    -- *can check parameters in one conditional expression and a common message printed if any of them are missing*

Create Procedure HonorCoursesForOneTerm (@average decimal(5,2) = null, @semester char(5) = null)
AS
IF @average is null or @semester is null
    BEGIN
    Raiserror ('Must provide an Average and a semester', 16, 1)
    END
ELSE
    BEGIN
    Select courseName from course 
    inner join offering on course.courseID = offering.courseID
    inner join registration on offering.offeringCode = registration.offeringcode
    Where semesterCode = @semester
    group by course.courseID, CourseName
    having avg(mark) > @average
    END
RETURN
GO

-- 3.Create a stored procedure called “NotInACourse” that lists the full names of the staff that are not taught a given courseID.
Alter Procedure NotInACourse(@CourseID char(7) = null)
AS
IF @courseID is NULL
    BEGIN
    RAISERROR ('Must provide a course ID', 16, 1)
    END
ELSE
    BEGIN
    Select firstName +' '+ lastName 'StaffName' from Staff
    where staffID NOT IN (select staffID from offering where courseID = @courseID)
    END
RETURN

execute NotInACourse 'DMIT152'
go

-- 4.Create a stored procedure called “LowCourses” to select the course name of the course(s) that have had less than a given number of students in them.
Alter Procedure LowCourses (@StudentCount smallint = null)
AS
IF @StudentCount is null
    BEGIN
    Raiserror ('Must provide a student count', 16, 1)
    END
ELSE 
    BEGIN
    Select CourseName, Count(offering.courseID)'StudentCount' from course 
    left outer join offering on course.courseID = offering.courseID --학생이 0인 경우도 나와야하기에 outer
    left outer join Registration on offering.offeringCode = Registration.offeringCode
    group by course.courseID, CourseName
    having Count(offering.courseID) < @StudentCount
    END
RETURN

LowCourses 4
GO

-- 5.Create a stored procedure called “ListaProvince” to list all the students names that are in a given province.
Alter Procedure ListaProvince (@Province char(2) = null)
AS
IF @Province is NULL
    BEGIN
    Raiserror ('Must provide a Provice', 16, 1)
    END
ELSE
    BEGIN
    select firstName+' '+LastName 'StudentName' from student
    where province = @province 
    END
RETURN

Exec ListaProvince 'SK'
go

-- 6.Create a stored procedure called “transcript” to select the transcript for a given studentID. Select the StudentID, full name, course ID’s, course names, and marks.
Alter Procedure transcript (@studentID int = null)
AS
IF @studentID is null 
    BEGIN
    Raiserror ('Must provide a student id', 16, 1)
    END
ELSE
    BEGIN
    select student.studentID, firstName+' '+LastName 'StudentName', course.courseID, courseName, mark from student
    inner join Registration on student.studentid = registration.studentid
    inner join offering on registration.offeringcode = offering.offeringcode
    inner join course on offering.courseID = course.courseID
    where student.studentid = @studentID 
    END
RETURN

exec transcript 200312345
GO


-- 7.Create a stored procedure called “PaymentTypeCount” to select the count of payments made for a given payment type description. 
Create Procedure PaymentTypeCount (@PaymentTypeDescription varchar(40) = null)
AS
IF @PaymentTypeDescription is null
    BEGIN
    RAISERROR ('Must Provide a payment type description', 16, 1)
    END
ELSE
    BEGIN
    select count(*)'PaymentCount' from payment
    inner join paymentType on Payment.paymentTypeID = paymentType.paymentTypeID
    where paymentType.PaymentTypeDescription = @PaymentTypeDescription
    END
RETURN


exec PaymentTypeCount 'Cash'
GO



-- 8.Create stored procedure called “Class List” to select student Full names that are in a course for a given semesterCode and Coursename.
Create Procedure ClassList (@semester char(5) = null , @CourseName varchar(40) = null)
AS 
IF @semester is null or @CourseName is null
    BEGIN
    RAISERROR ('Must provide a semester code and a course name', 16, 1)
    END
ELSE
    BEGIN
    Select firstName+' '+LastName 'StudentName' from Student
    inner join registration on student.studentID = registration.studentID
    inner join offering on registration.offeringcode = offering.offeringcode
    inner join course on offering.courseID = course.courseID
    Where semestercode = @semester and courseName = @CourseName
    END
RETURN

Exec ClassList 'A600', 'DMIT221'

select * from offering