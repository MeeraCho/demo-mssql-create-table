--Inner Joins with Aggregates
Select * from Registration -- 70
Select * from Student -- 17

-- 70 Registrations
-- 17 Students
-- 8 Students are taking Courses
-- 9 Students are not taking any Course

-- How many Students are taking Courses? 
Select Count(distinct StudentID) 'Count' from Registration

-- Select The student names and the average mark for each student
Select FirstName + ' ' + LastName 'StudentName', Avg(Mark) 'Average' from Student
Inner Join Registration on Student.StudentID = Registration.StudentID
group by Student.studentID, firstName, LastName
--group by는 위에 있는 포메이션 그대로가 아니라 FirstName + ' ' + LastName(x) 데이터만 적어주면 된다. firstName, LastName (O) 
--group by에서 studentID만 써주면 squiggle line이 생기는데 parent table로 지정해 주면 된다. 


--What is the average payment amount for each payment type? Show the payment type description and the average amount
Select PaymentTypeDescription, avg(amount) 'AvgPaymentAmount' from PaymentType
Inner Join Payment on PaymentType.PaymentTypeID = Payment.PaymentTypeID
group by PaymentType.PaymentTypeID, PaymentTypeDescription


-- Inner Joins With Aggregates Exercises
-- 1. How many staff are there in each position? Select the number and Position Description
select positionDescription, count(*)'StaffCount' from Staff
inner join Position on Position.PositionID = Staff.PositionID
group by Position.PositionID, positionDescription

-- 2. Select the average mark for each course. Display the CourseName and the average mark
Select courseName, avg(mark)'AverageMark' from course
inner join offering on offering.courseID = course.courseID
inner join registration on registration.offeringCode = offering.offeringCode
group by course.courseID, courseName
--group by course.courseID 는 uniquely identified 위해 

-- 3. How many payments where made for each payment type. Display the PaymentTypeDescription and the count
Select PaymentTypeDescription, Count(*)'PaymentCount' from payment
inner join PaymentType on PaymentType.PaymentTypeID = Payment.PaymentTypeID
group by PaymentType.PaymentTypeID, PaymentTypeDescription
 
-- 4. Select the average Mark for each student. Display the Student Name and their average mark
Select FirstName + ' ' + LastName 'StudentName', Avg(Mark)'AverageMark' from Student
inner join Registration on student.studentID = Registration.studentID
group by  student.studentID, firstName, lastName

-- 5. Select the same data as question 4 but only show the student names and averages that are > 80
Select FirstName + ' ' + LastName 'StudentName', Avg(Mark)'AverageMark' from Student
inner join Registration on student.studentID = Registration.studentID
group by  student.studentID, firstName, lastName
having avg(mark) > 80
 
-- 6.what is the highest, lowest and average payment amount for each payment type Description? 
Select paymentTypeDescription, max(amount)'MaxAmount', min(amount)'MinAmount', avg(amount)'AvgAmount' from Payment
inner join paymentType on paymentType.paymentTypeID = Payment.PaymentTypeID
group by paymentType.PaymentTypeID, PaymentTypeDescription 

-- 7. How many students are there in each club? Show the clubName and the count
Select clubName, count(*)'StudentCount' from club
inner join activity on Activity.clubID = Club.clubID
Group by Club.ClubID, clubName 

-- 8. Which clubs have 3 or more students in them? Display the Club Names.
Select clubName from club
inner join activity on Activity.clubID = Club.clubID
Group by Club.ClubID, clubName
having count(*) >= 3