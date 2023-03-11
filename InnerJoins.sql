-- Inner Joins 
-- Allow us to work with data from more than one related table
-- Select the names of all the staff and the positionID they are in

Select * from staff --10 
select firstName, LastName, PositionID from Staff

-- Select the names of all the staff and the position description they are in. 
    Select * from staff --10 
    Select * from position --7 

    -- does not work, Every record in one table is being associated/related with every record in the other
    Select FirstName, LastName, PositionDescription from Staff, Position --70 -- NOT WORK 

    -- We need to identify how the tables are related (PK and FK) using inner join syntax
Select FirstName, LastName, PositionDescription from Staff
inner join position on staff.positionID=Position.PositionID 

Select FirstName, LastName, PositionDescription from Position 
inner join staff on staff.positionId = Position.PositionID

    --list all the position Descriptions and the names of staff in them
Select PositionDescription, FirstName, LastName from Staff
inner join position on staff.positionID=Position.PositionID 
    --Oh no! We are missing one position Description (Assistant Dean) Why? because there are no staff in that position
    --Inner joins only return records if there are related records in the child tables 


--Select the student full names (that are registered in at least one offering) and the offering codes they are registered in. 
Select FirstName + ' ' + LastName 'Student Name', OfferingCode from Student 
inner join registration on student.studentID = registration.StudentID

-- Select the names of students that have made at least one payment
    -- Long Way. (group by 다음 student.studentId로 오면 에러가 난다. 앞에서 사용하지 않아서)
    Select FirstName + ' ' + LastName 'Student Name' from student 
    inner join payment on student.StudentID = payment.studentID
    group by firstname, lastname
    having count(*) >= 1
    -- Short Way
    Select distinct firstname, lastname from Student
    inner join payment on Student.StudentID = Payment.StudentID

-- More than 2 tables 
-- Select the studentID, FullNames, Offering Codes, CourseID, CourseName, and Mark for all Students
Select student.StudentID, FirstName + ' ' + LastName 'StudentName', offering.OfferingCode, Course.CourseID, CourseName, Mark from Student 
Inner Join Registration on Student.StudentID = Registration.StudentID
Inner Join Offering on Offering.OfferingCode = Registration.OfferingCode
Inner Join Course on Course.CourseID = Offering.CourseID

-- Joins Exercise 1 
-- 1.	Select Student full names and the course ID's they are registered in.
Select firstName + ' ' + lastName'StudentName', courseID from student
inner join registration on Student.StudentID = Registration.StudentID
inner join offering on Registration.offeringCode = offering.offeringCode

-- 2.	Select the Staff full names and the Course ID’s they teach
-- 가르치는 것은 중복됨이 없도록 한다. 
Select distinct firstName + ' ' + lastName'StaffName', courseID from staff
inner join offering on offering.staffID = staff.StaffID

-- 3.	Select all the Club ID's and the Student full names that are in them
select clubID, firstName + ' ' + lastName'StudentName' from activity
inner join student on activity.studentID = student.studentID

-- 4.	Select the Student full name, courseID's and marks for studentID 199899200.
select firstName + ' ' + lastName'StudentName', courseID, mark from student 
inner join registration on registration.studentID = student.studentID
inner join offering on offering.offeringCode = registration.offeringCode
where student.studentID = 199899200

-- 5.	Select the Student full name, course names and marks for studentID 199899200.
select firstName + ' ' + lastName'StudentName', courseName, mark from student 
inner join registration on registration.studentID = student.studentID
inner join offering on offering.offeringCode = registration.offeringCode
inner join course on course.courseId = Offering.courseID
where student.studentID = 199899200

-- 6.	Select the CourseID, CourseNames, and the Semesters they have been taught in
select course.courseID, CourseName, semesterCode from offering
inner join course on course.courseId = offering.courseId

-- 7.	What Staff Full Names have taught Networking 1?
Select firstName + ' ' + lastName'StaffName' from staff
inner join offering on offering.staffID = staff.StaffID
inner join course on course.courseID = offering.courseID
where courseName = 'Networking 1'

-- 2개의 조건이 붙는 경우 
-- 8.	What is the course list for student ID 199912010 in semestercode A100. Select the Students Full Name and the CourseNames.
select firstName + ' ' + lastName'StudentName', courseName from student 
inner join registration on registration.studentID = student.studentID
inner join offering on offering.offeringCode = registration.offeringCode
inner join course on course.courseId = Offering.courseID
where semesterCode = 'A100' and student.studentID = 199912010

-- 9. What are the Student Names, courseID's that have Marks > 80?
select firstName + ' ' + lastName'StudentName', courseID, mark from student 
inner join registration on registration.studentID = student.studentID
inner join offering on offering.offeringCode = registration.offeringCode
where mark > 80 


