drop table student
drop table grade
drop table club
drop table COURSE
drop table Activity

Create TABLE Course
(
    CourseID CHAR(6) NOT NULL,
    CourseName VARCHAR(40) NOT NULL,
    Hours SMALLINT NULL,
    NoOfStudents SMALLINT NULL
)

create table Student
(
    StudentID int not null,
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
    StudentID int not null,
    CourseID char(6) not null,
    Mark SMALLINT null
)

create table Club
(
    ClubID int not null,
    ClubName VARCHAR(50) not null
)

create table Activity
(
    StudentID int not null,
    ClubID int not null
)


