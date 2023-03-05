--Group By and Having
--1. Group By
--Group By works with aggregate functions
--Never use Group by without an aggregate function

Select * from staff --10
Select * from position --7
--How many staff in the staff table? 
Select count(*) 'StaffCount' from Staff
--How many Staff are there in each positionID? Show the positionID and the count
--PositionID 1: 1
--PositionID 2: 1
--PositionID 3: 2
--PositionID 4: 4
--PositionID 5: 1
--PositionID 6: 1
--PositionID 7: 0

--Group By performs subtotals for each different value you are grouping on. 
Select PositionID, Count(*) 'StaffCount' from Staff
Group by positionID

--Group by can be used with any aggregate function
--All Columns in a query that has a group by/Aggregate function, must be in the group by clause or the aggregate function.
Select PositionID, Count(*) 'StaffCount' from Staff --error

--When you have the words 'for each', 'in each' in the question it often means you need a group by 
--How much money has each student paid?
Select StudentID, Sum(Amount) 'PaymentTotal' from Payment
group by StudentID 

--What is the average amount each student has made? Show the studentID and the amount
Select StudentID, avg(Amount) 'PaymentTotal' from Payment
group by StudentID 

--You can have multiple aggregates in one query
Select StudentID, Sum(Amount)'Paid', avg(Amount)'Average', Count(*)'Count' from Payment
group by StudentID

--You do not need to select the column that you are grouping on
-- 앞에 있는 StudentID 지워도 됨. 하지만 어느 학생인지 헷갈림. 
Select Sum(Amount)'Paid', avg(Amount)'Average', Count(*)'Count' from Payment 
group by StudentID

--2. Having
--Having works with group by
--Aggregate --> group by --> Having
--Having is like a where clause, But it only evaluates/looks at the results of a group by AND only looks at aggregate function columns
--Having will only Ever have min, max, avg, sum, count 

--Which positions have MORE THAN ONE staff member in them? Show positionID and the count
Select positionID, Count(*)'StaffCount' from Staff
Group By PositionID
Having Count(*) > 1 

--You don't need to select the aggregate column your having works with
Select Count(*)'StaffCount' from Staff
Group By PositionID
Having Count(*) > 1 

--Which positions have MORE THAN ONE staff member in them? Only include the staff that still work at the school. Show positionID and the count
Select PositionID, Count(*) 'StaffCount' from Staff
where DateReleased is null
Group By PositionID
Having Count(*) > 1

-- Simple Select Exercise 3
-- 1. Select the average mark for each offeringCode. Display the OfferingCode and the average mark.
select offeringcode, avg(mark) 'AverageMark' from Registration
group by offeringcode

-- 2. How many payments where made for each payment type. Display the Payment typeID and the count
select PaymentTypeID, Count(*) 'PaymentTypeCount' from Payment
group by PaymentTypeID

-- 3. Select the average Mark for each studentID. Display the StudentId and their average mark
Select StudentID, avg(Mark) 'AverageMark' from Registration
group by StudentID

-- 4. Select the same data as question 3 but only show the studentID's and averages that are > 80
Select StudentID, avg(Mark) 'AverageMark' from Registration
group by StudentID
having avg(Mark) > 80

-- 5. How many students are from each city? Display the City and the count.
select city, count(*) 'cityCount' from Student 
group by city 

-- 6. Which cities have 2 or more students from them? (HINT, remember that fields that we use in the where or having do not need to be selected.....)
select city, count(*) 'cityCount' from Student 
group by city 
having count(city) >= 2

-- 7.what is the highest, lowest and average payment amount for each payment type? 
select paymentTypeID, max(amount)'max', min(amount)'min', avg(amount)'average' from payment
group by paymentTypeID 

-- 8. How many students are there in each club? Show the clubID and the count
select ClubID, count(*) 'StudentCount' from activity
group by clubID

-- 9. Which clubs have 3 or more students in them?
select ClubID, count(*) 'StudentCount' from activity
group by clubID
having count(*) >= 3 


