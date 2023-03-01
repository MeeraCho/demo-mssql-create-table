-- 1.  Select all the information from the club table
select ClubId, ClubName from club

-- 2. Select the FirstNames and LastNames of all the students
Select FirstName, LastName from Student

-- 3. Select all the CourseId and CourseName of all the coureses. Use the column aliases of Course ID and Course Name
Select CourseId 'Course ID', CourseName 'Course Name' from Course

-- 4. Select all the course information for courseID 'DMIT101'
Select CourseId, CourseName, CourseHours, MaxStudents, CourseCost from Course
Where CourseId = 'DMIT101'

-- 5. Select the Staff names who have positionID of 3
Select FirstName + ' '+ LastName 'StaffName' from Staff
Where PositionID = 3 

-- 6. select the CourseNames whos CourseHours are less than 96
Select CourseName from Course
Where CourseHours < 96 

-- 7. Select the studentID's, OfferingCode and mark where the Mark is between 70 and 80 from registration Table
Select StudentId, OfferingCode, Mark from Registration 
Where mark between 70 and 80
-- Where mark >= 70 and mark <= 80

-- 8. Select the studentID's, Offering Code and mark where the Mark is between 70 and 80 and the OfferingCode is 1001 or 1009
Select StudentId, OfferingCode, Mark from Registration 
Where (Mark between 70 and 80) and offeringCode in (1001, 1009)

-- 9. Select the students first and last names who have last names starting with S from Student
Select FirstName, LastName from Student
Where LastName like 's%'

-- 10. Select CourseId, Coursenames whose CourseID  have a 1 as the fifth character
Select CourseId, CourseName from Course
Where CourseID LIKE '____1%'

-- 11. Select the CourseID's and Coursenames where the CourseName contains the word 'programming'
Select CourseID, CourseName from Course
Where CourseName Like '%Programming%'

-- 12. Select all the ClubNames who start with N or C.
Select ClubName from Club
Where ClubName LIKE 'N%' or ClubName LIKE 'C%' --option 1
Where ClubName LIKE '[NC]%' -- bracket means the first character starts 'N' or 'C'

-- 13. Select Student Names, Street Address and City where the lastName has only 3 letters long.
Select FirstName, LastName, StreetAddress, City from Student
where lastName LIKE '___' 
where lastName LIKE '[a-z][a-z][a-z]'

-- 14. Select all the StudentID's where the PaymentAmount < 500 OR the PaymentTypeID is 5 from Payment Table 
Select StudentID from Payment
Where Amount < 500 or PaymentTypeID = 5 

