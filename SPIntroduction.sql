--STORED PROCEDURES INTRODUCTION
--Stored procedure is a basically a method or a function in SQL
--A bunch of SQL code that is given a name and called by that name (like a method/function)
    --reusable, modular way of writing your code 
--You can pass values to them (argument/parameters)
--can contain VARIABLES
--can have decisions (IF/ELSE)
--Can contain QUERIES, DML statements, transactions
--Source Code is stored in the DB and can be retrieved



--BASIC SYNTAX
--Create Procedure or Proc NAME
--AS
--SQL CODE
--RETURN --return a value from a method
Create Procedure ListAllStudents
as
Select FirstName, LastName from Student
return

--Execute a SP 
Execute ListAllStudents
go
Exec ListAllStudents
go
ListAllStudents --This only works in SSMS(sql server menual studio) and if there are no parameters
go

--Retrieve the Source Code from the DB
sp_helptext ListAllStudents
go

--Make changes to a SP 
Alter Procedure ListAllStudents
as
Select FirstName, LastName, city from Student
REturn
go

--Drop a SP
Drop Procedure ListAllStudents
go


-- SIMPLE Stored Procedure EXERCISE
-- **Stored Procedure has to be the first statement in a batch so place GO in between each question to execute the previous batch (question) and start another. **

-- 1.Create a stored procedure called “HonorCourses” to select all the course names that have averages >80%. 
Create Procedure HonorCourses 
as 
Select courseName from course 
inner join offering on offering.courseID = course.courseID 
inner join registration on registration.offeringCode = offering.offeringCode
group by course.courseID, courseName
having avg(mark) > 80
return 
GO 

execute HonorCourses
GO


-- 2.Create a stored procedure called “HonorCoursesOneTerm” to select all the course names that have average >80% in semester A100.
    --option 1. where가 group by보다 앞에 오는 경우 
    Create Procedure HonorCourseOneTerm 
    AS
    Select courseName from course 
    inner join offering on offering.courseID = course.courseID 
    inner join registration on registration.offeringCode = offering.offeringCode
    where semesterCode = 'A100'
    group by course.courseID, courseName
    having avg(mark) > 80
    return 
    GO 

    --option 2.  where 없애고, having에 조건 추가한 경우 
        --같은 결과가 나오지만 BAD. 
        --1. Efficiency Problem. where 대신 group by로 500,000 코스를 semestercode를 정리한 후 마지막에 having으로 5개의 코스만 찾는 경우 불필요한 일처리를 하게 된다.
        --2. having에는 avg, count, max, min, sum 이 5가지만 써야 한다.
    CREATE Procedure HonorCourseOneTerm 
    AS
    Select courseName from course 
    inner join offering on offering.courseID = course.courseID 
    inner join registration on registration.offeringCode = offering.offeringCode
    group by course.courseID, courseName, semesterCode
    having avg(mark) > 80 and semesterCode = 'A200'
    return 
    GO 

-- 3.Oops, made a mistake! For question 2, it should have been for semester A200. Write the code to change the procedure accordingly. 
ALTER Procedure HonorCourseOneTerm 
AS
Select courseName from course 
inner join offering on offering.courseID = course.courseID 
inner join registration on registration.offeringCode = offering.offeringCode
where semesterCode = 'A200'
group by course.courseID, courseName
having avg(mark) > 80
return 
GO 


-- 4.Create a stored procedure called “NotInDMIT221” that lists the full names of the staff that have not taught DMIT221.
CREATE Procedure NotInDMIT221
AS
Select FirstName +' '+ LastName 'StaffName' from Staff
Where StaffID NOT IN (Select StaffID from offering where courseID = 'DMIT221') --inner join 안해도 됨 
RETURN
GO

-- 5.Create a stored procedure called “Provinces” to list all the students provinces.
Create Procedure Province 
AS
Select distinct Province from student
RETURN
GO

-- 6.OK, question 6 was ridiculously simple and serves no purpose. Lets remove that stored procedure from the database.
DROP Procedure Province
GO

-- 7.Create a stored procedure called StudentPaymentTypes that lists All the student names and their payment type Description. Ensure all the student names are listed.
    -- 아직 결제 안했으면 null도 나와야함 
Create Procedure StudentPaymentTypes 
AS
select distinct firstName+' '+lastName'Student', paymenttypeDescription from Student
left outer join payment on student.studentID = payment.studentID 
left outer join paymenttype on paymenttype.paymentTypeID = payment.paymentTypeID
RETURN
GO


-- 8.Modify the procedure from question 7 to return only the student names that have made payments.
Alter Procedure StudentPaymentTypes 
AS
select distinct firstName+' '+lastName'Student' from Student
inner join payment on student.studentID = payment.studentID 
inner join paymenttype on paymenttype.paymentTypeID = payment.paymentTypeID
RETURN
GO