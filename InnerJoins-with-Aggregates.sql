--Inner Joins with Aggregates
Select * from Registration -- 70
Select * from Student -- 17

-- 70 Registrations
-- 17 Students
-- 8 Students are taking Courses
-- 9 Students are not taking any Course

-- How many Students are taking Courses? 
Select Count(distinct StudentID) 'Count' from Registration

-- Select The student names and the average for each student
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
 
-- 2. Select the average mark for each course. Display the CourseName and the average mark

-- 3. How many payments where made for each payment type. Display the PaymentTypeDescription and the count
 

-- 4. Select the average Mark for each student. Display the Student Name and their average mark
 

-- 5. Select the same data as question 4 but only show the student names and averages that are > 80
 
 
-- 6.what is the highest, lowest and average payment amount for each payment type Description? 
 

-- 7. How many students are there in each club? Show the clubName and the count
 
-- 8. Which clubs have 3 or more students in them? Display the Club Names.
