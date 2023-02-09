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

