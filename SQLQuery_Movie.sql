DROP TABLE MovieTheater
DROP TABLE MOVIE
DROP TABLE GENRE
DROP TABLE THEATER


-- parent table have to be before children tables --
CREATE TABLE GENRE
(
    GenreCode CHAR(1) not null constraint pk_Genre Primary Key, 
    GenreDescription VARCHAR NOT NULL
)

Create Table Movie
(
    MovieID int not null constraint pk_Movie Primary Key,
    Title VARCHAR(200) not null,
    Budget Money null,
    ReleaseDate DATE null, 
    GenreCode Char(1) not null constraint fk_MovieToGenre references Genre(GenreCode),
    Released bit null,
    MovieLength decimal(5,2) not null
)

CREATE TABLE THEATER
(
    TheaterID int not null constraint pk_Theater Primary Key, 
    TheaterName varchar(100) not null,
    Address varchar(50) not null, 
    City varchar(50) not null,
    Province char(2) not null constraint df_TheaterProvince default 'AB',
    PostalCode char(7) not null,
    Phone char(13) not null
)

--composite primary key, use Table Level Constraint --
Create Table MovieTheater
(
    MovieID int not null constraint fk_MovieTheaterToMovie references Movie(MovieID),
    TheaterID int not null constraint fk_MovieTheaterToTheater references Theater(TheaterID),
    StartDate date not null, 
    EndDate date null,
    constraint pk_MoveTheater Primary Key(MovieId, TheaterID)
)

--Test the constraints --
-- 이미 있는 벨류를 또 입력하니 에러 -- 
Insert into Genre(GenreCode, GenreDescription)
VALUES
('H', 'Horror'),
('R', 'Romance'),
('S', 'Science Fiction')

Insert into Genre(GenreCode, GenreDescription)
VALUES
('H', 'Horror')

--Testing FK--
--you get error when insert wrong id that parent table doesn't have. There is no 'K' in GenreCode --
Insert into Movie(MovieID, title, Budget, ReleaseDate, GenreCode, Released, MovieLength)
values (1, 'Star Wars', 1000000, 'Feb 1 1997', 'S', 1, 180)

Insert into Movie(MovieID, title, Budget, ReleaseDate, GenreCode, Released, MovieLength)
values (2, 'Empire Strikes Back', 2000000, 'Feb 1 1977', 'K', 1, 180)

-- Testing our default constraint -- 
Insert into THEATER(TheaterID, TheaterName, Address, City, Province, PostalCode, Phone)
values (1, 'Good Show', '111 street', 'Edmonton', 'AB', 'T8H 1F1', '(780)555-1111')

Insert into THEATER(TheaterID, TheaterName, Address, City, Province, PostalCode, Phone)
values (2, 'Good Show', '111 street', 'Edmonton', default, 'T8H 1F1', '(780)555-1111')

select * from Theater