--Outer Joins
--Outer Joins: Select ALL the things in the table even without records. 
--We use Outer Joins to get all the parents records, even if there are no related child records.
--Inner Joins: only return records that have related records in the other tables they are joined with. 

--Select ALL the position descriptions and the names of staff in them
--if we use inner join, one of the position descriptions doesn't return because there are no staff in that position. 
Select PositionDescription, FirstName, LastName from Position
inner join staff on position.PositionID = staff.positionID --10

--2 types of outer joins
-- in a 2 table join, you can use which ever one you want. You just need to write the query in the right order. 

--left joins: 
-- Retrieve ALL the records on the left side of the join statement even if there are no related records in the staff table 
Select PositionDescription, FirstName, LastName from Position
Left Outer join staff on position.PositionID = staff.positionID --11  position이 왼쪽에서 기준

--right joins: 
-- Retrieve ALL the records on the Right side of the join statement even if there are no related records in the staff table 
-- there's no child record 
Select PositionDescription, FirstName, LastName from Staff
right Outer join Position on position.PositionID = staff.positionID --11 position이 오른쪽에서 기준. 결과 같음

--In a 2 table outer join your join must Point to the Parent table

--Why does not make any sense?
Select PositionDescription, FirstName, LastName from Staff
left Outer join Position on position.PositionID = staff.positionID --10 staff이 왼쪽에서 기준. 포지션 하나 사라짐 
--Staff이 left로 와서 parent가 된 경우. staff은 10명 뿐이다. staff이 parent가 되면 자녀인 positiondescription 중  null로 된 것은 나오지 않는다. 
--This behaves like an inner join because all child records MUST have a related parent record (FK constraint enforces this)

--GENERAL RULE:
--Your outer joins must always point to the data you want to keep in your results.

-- 3 TABLES JOIN
--Select ALL the students names, their courseID's, and marks. 
--first two tables works first and then the other table runs next
Select FirstName + ' ' + LastName 'StudentName', CourseID, Mark from Student
left Outer join Registration on Registration.StudentID = Student.StudentID
left Outer join Offering on Registration.OfferingCode = Offering.OfferingCode

--위 3개 테이블 run 순서 
Select FirstName, LastName, Mark from Student -- step 1 
left outer Join Registration on Student.StudentID = Registration.StudentID

Select FirstName, LastName, CourseID, Mark from Student -- step 2 
left outer Join Registration on Student.StudentID = Registration.StudentID
left outer Join Offering on Offering.OfferingCode=Registration.OfferingCode
--ERD를 보면 offering이 parent table이다. 


-- Outer Joins Exercise
-- 1. Select All position descriptions and the staff ID's that are in those positions
Select PositionDescription, StaffID from Position 
left outer join Staff on position.PositionID = staff.PositionID

-- 2. Select the Position Description and the count of how many staff are in those positions. Return the count for ALL positions.
-- HINT: Count can use either count(*) which means records or a field name. Which gives the correct result in this question?
-- Count(StaffID)은 colunm 안의 칸을 셈
Select PositionDescription, count(StaffID)'StaffCount' from Position 
left outer join Staff on position.PositionID = staff.PositionID
group by Position.positionID, PositionDescription

-- Count(*)은 record가 있는 것만 셈
Select PositionDescription, count(*)'StaffCount' from Position 
left outer join Staff on position.PositionID = staff.PositionID
group by Position.positionID, PositionDescription

-- 3. Select the average mark of ALL the students. Show the student names and averages.
Select firstName + ' ' + LastName'StudentName', avg(mark)'Average' from Student
left outer join Registration on Student.StudentID = Registration.StudentID --17 / inner join: 10
group by Student.StudentID, firstName, lastName 

-- 4. Select the highest and lowest mark for each student. 
Select firstName + ' ' + LastName'StudentName', max(mark)'HighestMark', min(mark)'LowestMark' from Student
left outer join Registration on Student.StudentID = Registration.StudentID 
group by Student.StudentID, firstName, lastName 

-- 5. How many students are in each club? Display club name and count.
Select ClubName, Count(Activity.studentID)'StudentCount' from Club
left Outer join Activity on Club.ClubID = Activity.ClubId 
group by Club.ClubID, ClubName

