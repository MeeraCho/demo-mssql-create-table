--String and Date Function

--1. Today 
Select getdate() 'Now'

--2. Add 219 days to today's date
Select dateadd(dd, 219, getDate()) 'after219days'

-- Add 5 years from datehired from Staff
Select dateadd(yy, 5, datehired) 'Add5Years', datehired from Staff

--3. Difference between 2 dates
--How many days have staff that still work for the school worked there?
Select firstname, lastname, datediff(dd, datehired, getdate())'DaysWorked' from staff
where datereleased is null

--4. parts of a date
--DateName() - String Name
Select datename(dw, datehired) 'Day Hired', datehired from staff
Select datename(mm, datehired) 'Month Hired', datehired from staff

--5. Who was hired in June?
Select firstname, lastname, datehired from Staff
where datename(mm, datehired) = 'June' 

--6. Day of the week you were born
select datename(dw, 'Jan 20 1972')

--7. DatePart() --integer version
-- 1=Sun, 2=Mon 3= Tue 4=Wed 5=Thr 6=Fri 7=Sat
Select datePart(dw, datehired) 'Day Hired', datehired from staff 
Select datePart(mm, datehired) 'Month Hired', datehired from staff

Select datePart(yy, datehired) 'year Hired', datehired from staff
Select datePart(mm, datehired) 'Month Hired', datehired from staff 
Select datePart(dd, datehired) 'Day Hired', datehired from staff
--OR
Select year(datehired) 'year Hired', datehired from staff
Select month(datehired) 'Month Hired', datehired from staff 
Select day(datehired) 'Day Hired', datehired from staff


-- String and Date Functions Exercise
-- 1. Select the staff names and the name of the month they were hired
Select FirstName +' '+ LastName 'StaffName', datename(mm, datehired) 'HiredMonth' from Staff

-- 2. How many days did Tess Agonor work for the school?
Select datediff(dd, datehired, DateReleased) 'daysworked' from Staff
Where FirstName = 'Tess' and LastName = 'Agonor'

-- 3. Select the Names of all the students born in December.
Select FirstName + ' ' + LastName 'StudentName' from Student
where datename(mm, birthdate) = 'December'

-- 4. select last three characters of all the course.
Select right(coursename, 3) 'ThreeRight' from course

-- 5. Select the characters in the position description from characters 8 to 13 for PositionID 5
Select substring(PositionDescription, 8, 6) 'PartialDescription' from Position
Where positionId = 5

-- 6. Select all the Student First Names as upper case.
Select Upper(firstName) 'UpperCaseFirstName' from Student

-- 7. Select the First Names of students whose first names are 3 characters long.
Select firstName from Student
where len(firstName) = 3
