drop table grade
drop table Activity
drop table student
drop table club
drop table COURSE

Create TABLE Course
(
    CourseID CHAR(6) NOT NULL constraint pk_Course Primary Key,
    CourseName VARCHAR(40) NOT NULL,
    Hours SMALLINT NULL,
    NoOfStudents SMALLINT NULL
)

create table Student
(
    StudentID int not null constraint pk_Student Primary Key,
    StudentFirstName VARCHAR(40) not null,
    StudentLastName VARCHAR(40) not null,
    GenderCode CHAR(1) not NULL,
    Address VARCHAR(30) NULL,
    Birthdate Datetime NULL,
    PostalCode Char(6) NULL,
    AvgMark DECIMAL(4,1) NULL,
    NoOfCourses SMALLINT NULL
)

create table Grade 
(
    StudentID int not null constraint fk_GradeToStudent references Student(StudentID),
    CourseID char(6) not null constraint fk_GradeToCourse references Course(CourseID),
    Mark SMALLINT null,
    constraint pk_Grade Primary Key(StudentID, CourseID)
)

create table Club
(
    ClubID int not null constraint pk_Club Primary Key,
    ClubName VARCHAR(50) not null
)

create table Activity
(
    StudentID int not null constraint fk_ActivityToStudent references Student(StudentID),
    ClubID int not null constraint fk_ActivityToClub references Club(ClubID),
    constraint pk_Activity Primary Key(StudentID, ClubID)
)

ALTER TABLE Club
    ADD 
    MeetingLocation varChar(50) null

-- Add a constraint to birthdate to ensure the value is <(less than) todays date
Alter Table Student 
    Add 
    Constraint CK_Birthdate 
    Check (birthdate < getDate())

-- Add a constraint to set a default of 80 to the Hours field
Alter Table Course
    Add 
    Constraint DF_Hours
    Default 80 for Hours

-- disable the check constraint for the birthdate field
Alter Table Student
    NoCheck Constraint ck_Birthdate

-- enable the check constraint for the Birthdate field
Alter Table Student 
    check constraint ck_Birthdate

-- Delete the default constraint for the Hours field 
Alter Table Course 
    Drop Constraint DF_Hours

-- create nonclustered index as CourseId in Marks table 
-- index을 ix_CourseId로 하면 다른 테이블에서도 같은 이름이 너무 많이 나옴. 
Create nonclustered index ix_Marks_CourseId
    on Marks (CourseId)

-- Drop nonclustered index as CourseId in Marks table 
Drop index ix_Marks_CourseId on Marks

-- setting FKs as non-clustered indexes
Create nonclustered index IX_Grade_StudentId on Grade(StudentId)
Create nonclustered index IX_Grade_CourseId on Grade(CourseId)
Create nonclustered index IX_Activity_StudentId on Activity(StudentId)
Create nonclustered index IX_Activity_ClubId on Activity(ClubId)