Drop table CheckConstraint

Create table CheckConstraint
(
ConstraintID int not null identity (1,1) constraint pk_CheckConstraint primary key clustered,
ConstraintType char (3) not null,
PurchaseDate datetime not null,
Cost smallmoney not null constraint ck_validCost check (Cost >= 0),
SellPrice smallmoney not null constraint ck_ValidSellPrice check (SellPrice between 0 and 100),
Active char(1) not null constraint ck_validActive check (active between 'a' and 'g' or active = 't' or active = 'x'),
Code varchar (30) not null constraint ck_validCode check (Code like 'a__r%'),
Identifier varchar (30) not null constraint ck_crazyIdentifier check (Identifier like '[g-k]___[6-8]%Hello[0-9][0-9]world'), 
PostalCode char(7) not null constraint ck_validPostCode check (PostalCode like '[a-z][0-9][a-z] [0-9][a-z][0-9]'), 
Phone char(13) not null constraint ck_validPhone check (Phone like '([1-9][0-9][0-9])[1-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'), 
constraint ck_validCostVsSellPrice check (SellPrice >= 2 * Cost)
)

insert into CheckConstraint(ConstraintType, PurchaseDate, Cost, SellPrice, Active, Code, Identifier, PostalCode, Phone)
values ('abc','jan 1 2021', 5, 10, 'x', 'abcrdefg', 'j6f#7heythereHello57World', 'T8T 1R0', '(780)234-1234')
