-- SubQueries
-- A query inside another satement (query, insert, update, delete)
-- A subquery is a full query that can be executed, tested on it's own
-- Can usually be used anywhere a value is used 
-- A subquery can often be used insted of a join. BUT, joins are faster. 

--The subquery executes first, and then the results of the subquery are used by the outer statement

--Join-- Select ALL the staff names that are in the 'Dean' position
    Select FirstName + ' ' + LastName 'StaffName' from Position
    inner Join Staff on Position.PositionID = Staff.PositionID
    where PositionDescription = 'Dean' 

--Subquery--
    --Step 1-- 
    -- the case above we don't know positionID but we know positionName. 
    -- give me the positionID where positionDescription = 'Dean' 
    (Select positionID from position where PositionDescription='Dean')

    --Step 2-- 
    --() 안 subquery가 먼저 실행되고 나서 나머지 실행 
    Select FirstName + ' ' + LastName 'StaffName' from Staff
    where positionid = (Select positionID from position where PositionDescription='Dean')

--Select the StudentID and names of students that have made payments
--Join-- 
    Select distinct Student.StudentID, FirstName + ' ' + LastName 'StudentName' from Student
    Inner join Payment on payment.studentID = Student.StudentID

--SubQuery--
--In order to find students who made payments, Student 테이블의 studentID 와 서로 매치되는 payment 테이블의 studentID를 찾으면 된다
--일단 payment 테이블에서 studentID을 뽑아낸 후 
    (Select StudentID from payment)
--Student 테이블의 studentID와 매치가 되는지 확인한다 
    Select studentID, FirstName + ' ' + LastName 'StudentName' from Student
    Where studentID IN (Select StudentID from payment) 

    Where studentID = (Select StudentID from payment) 
    --ERROR. Because the subquery returned more than one value. 
    --IF your subquery returns more than one value you MUST use IN instead of = 

--StudentID, names of students that have made NO payments
--outer join--
Select student.StudentID, FirstName + ' ' + LastName 'StudentName', paymentID from Student
left outer join payment on payment.studentID = student.studentID
where paymentID IS null

--outer join with aggregate--
Select student.StudentID, FirstName + ' ' + LastName 'StudentName', count(paymentID)'PaymentIDCount' from Student
left outer join payment on payment.studentID = student.studentID
group by student.studentID,firstName,LastName
having count(paymentID) = 0

--Subquery--
Select studentID, FirstName + ' ' + LastName 'StudentName' from Student
Where studentID NOT IN (Select StudentID from payment) 

-- Exercise 
-- 1. Select the Payment dates and payment amount for all payments that were Cash


-- 2. Select The Student ID's of all the students that are in the 'Association of Computing Machinery' club


-- 3. Select All the staff full names that have taught a course.


-- 4. Select All the staff full names that taught DMIT172.


-- 5. Select All the staff full names that have never taught a course


-- 6. Select the Payment TypeID(s) that have the highest number of Payments made.


-- 7. Select the Payment Type Description(s) that have the highest number of Payments made.


-- 8. What is the total avg mark for the students from Edmonton?


-- 9. What is the avg mark for each of the students from Edmonton? Display their StudentID and avg(mark)




