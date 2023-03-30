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
-- 1. Select the Payment dates and payment amount for ALL payments that were 'Cash'
select PaymentDate, Amount from Payment
where paymentTypeID = (select paymentTypeId from paymenttype where PaymentTypeDescription = 'cash')

Select paymentdate, amount from Payment
inner join paymenttype on paymenttype.paymentTypeID = Payment.paymentTypeID
where PaymentTypeDescription = 'cash'

-- 2. Select The Student ID's of all the students that are in the 'Association of Computing Machinery' club
Select studentID from activity 
where clubid = (select clubid from club where clubName = 'Association of Computing Machinery')

Select studentID from activity 
inner join club on activity.clubId = club.clubid
where clubName = 'Association of Computing Machinery'

-- 3. Select All the staff full names that have taught a course.
Select firstName + ' ' + LastName 'StaffName' from staff
where staffid IN (select distinct staffID from offering)

Select distinct firstName + ' ' + LastName 'StaffName' from staff
inner join offering on staff.staffId = offering.staffId 

-- 4. Select All the staff full names that taught DMIT172.
Select distinct firstName + ' ' + LastName 'StaffName' from staff
where staffid IN (select staffId from offering where courseId = 'DMIT172')

Select distinct firstName + ' ' + LastName 'StaffName' from staff
inner join offering on staff.staffId = offering.staffId 
where courseid = 'DMIT172'

-- 5. Select All the staff full names that have NEVER taught a course
Select firstName + ' ' + lastName 'StaffName' from staff
left outer join offering on staff.staffID = offering.staffID
where offeringcode is null

Select firstName + ' ' + lastName 'StaffName' from staff
left outer join offering on staff.staffID = offering.staffID
group by staff.staffid, firstName, LastName
having count(offeringCode) = 0 

-- 6. What is the total avg mark for the students from Edmonton?
select avg(mark)'AvgMark' from registration 
where studentID in (select studentID from student where city = 'edmonton')

Select avg(mark)'AvgMark' from Registration 
inner join Student on registration.studentID = Student.StudentID
where city = 'Edmonton'


-- 7. What is the avg mark for each of the students from Edmonton? Display their StudentID and avg(mark)
--Good Solution
select studentID, avg(mark)'AvgMark' from registration 
where studentID in (select studentID from student where city = 'edmonton')
group by studentID
--먼저 학생 3명을 뽑아낸 후 그 3명만 계산을 함 


Select student.studentID, avg(mark)'AvgMark' from Registration 
inner join Student on registration.studentID = Student.StudentID
where city = 'Edmonton'
group by student.studentID

--BAD SOLUTION because It's completely inefficient !!
select studentID, avg(mark)'AvgMark' from registration 
group by studentID
having studentID in (select studentID from student where city = 'edmonton')
--1. Having should only EVER have Min, Max, Sum,Count, Avg after it. That's only for aggregate column. 
--500,000 registration 400,000 student가 있고 Edmonton에 사는 학생은 3명만 있다고 할 때 
--코드는 위에서 아래로 실행되기에 각 400,000명의 학생을 group by해서 avg를 낸 후 having으로 3명을 걸러낸다. It's completely inefficient !!


