-- 2. Aggregate Functions
-- Retuen a single result from many values
-- In SQL, we use Sum, Min, Max, Avg, Count

-- Sum() - Returns the sum of the selected values
-- How much money would it cost to take all the courses once? 
Select sum(coursecost) 'SumOfCourseCost' from course 

-- How much would it cost to take all the programming courses (have programming in their course name)
Select sum(courseCost) 'SumOFProgrammingCourseCost' from Course
Where CourseName like '%programming%'

--Min - Returns the lowest value
Select min(CourseCost) 'LowestCost' from course

--Max - Returns the heightest value
Select max(CourseCost) 'HeightestCost' from course

--Avg - Returns the average
Select avg(courseCost) 'Average' from Course

-- Count - count(*), count(columnName)
-- * means 'records' when used in a count founction. It does not mean all columns 
Select * from Staff -- all columns
Select count(*) 'StaffCount' from Staff --10 조건에 해당되는 records들 다

select count(staffID) 'StaffCount' from staff --10
select count(firstName) 'StaffCount' from staff --10
select count(LastName) 'StaffCount' from staff --10
select count(DateHired) 'StaffCount' from staff --10
select count(DateReleased) 'StaffCount' from staff --1 there is only ONE record in this column
select count(loginID) 'StaffCount' from staff --0 there is NO record in this column

--Count(columnName) counts the number of values in that column(not nulls)
-- I recommend you use count(*) or count(PK attribute) when possible 
Select * from Staff

--GOOD
Select count(*) 'Smiths' from Staff -- 1
Where lastName = 'Smith'

--BAD
Select count(datereleased) 'Smiths' from Staff -- 0 column을 잘못 골라서 정확한 갯수가 안나옴. 그래서 * 이나 pk로 선정하기 
Where lastName = 'Smith'

--NULLs
--Count the number of staff that still work for the school from Staff Table

--BAD
Select count(*) 'StillWork' from Staff
Where datereleased = null -- 0 
--Returns 0 because nothing is ever equal to null

--GOOD
--To evalute null you must use IS
Select count(*) 'StillWork' from Staff
Where datereleased is null 

-- How many students have made at least one payment? 
select * from Payment
Select Count(distinct StudentID) 'StudentPaymentCount' from payment 


-- Simple Select Exercise 2
-- Use IQSCHOOL Database
Select * from Payment

-- 1.	Select the average Mark from all the Marks in the registration table
Select Avg(Mark) 'AvgMark' from Registration 

-- 2.	Select how many students are there in the Student Table
Select Count(*) 'StudentCount' from Student

-- 3.	Select the average payment amount for payment type 5
Select Avg(Amount) 'AvgAmountOfPaymentType5'from Payment
Where PaymentTypeID = 5 

-- 4. Select the highest payment amount
Select Max(Amount) 'Highest' from Payment

-- 5.	 Select the lowest payment amount
Select Min(Amount) 'Lowest' from Payment

-- 6. Select the total of all the payments that have been made
Select sum(amount) 'TotalPayment' from Payment

-- 7. How many different payment types does the school accept?
Select count(*) 'PaymentTypeCount' from PaymentType --Correct Answer, this answer can get a new PaymentType if we insert a new paymenttype.
Select Count(distinct PaymentTypeID) 'PaymentTypeCount' from Payment --Wrong: this answer is 'how many different payment types have been used on payments

-- 8. How many students are in club 'CSS'?
Select Count(*) 'CSSCount' from Activity
Where ClubID = 'CSS'