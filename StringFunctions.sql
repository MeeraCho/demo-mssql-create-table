--String Functions
--Examples
Select len(FirstName)'length', FirstName from Student -- length of firstName, FirstName
Select left(FirstName, 4) 'FirstFour' from Student -- first 4 characters of FirstName
Select right(FirstName, 4) 'LastFour' from Student -- Last 4 Characters of FirstName
-- SubString(where, First Point, how many characters)
Select SubString(CourseName, 4, 6) 'Middle', CourseName from Course 

-- Select All the courses (CourseID, CourseName) where the second character of the coursename is y
Select CourseID, CourseName 'SecondYCourse' from Course 
Where Substring(CourseName, 2, 1) = 'y' 

Select reverse('Leonardo DiCaprio') 'NameReverse'

Select upper(firstName)'UpperCase', lower(LastName)'LowerCase' from Student