--teeme andmebaasi e db
create database IKT25tar

--kus on db???
use IKT25tar

--andmebaasi kustutamine
drop database IKT25tar

--teeme uuesti andmebaasi IKT25tar
create database IKT25tar

--teeme tabeli
create table Gender
(
--Meil on muutja Id,
--mis on t‰isarv andmet¸¸p 
--kui sisestad andmed, 
--siis see veerg peab olema t‰idetud,
--tegemist on primaarvıtmega
Id int not null primary key,
--veeru nimi on Gender,
--10 t‰hem‰rki on max pikkus,
--andmed peavad olema sisestatud e
--ei tohi olla t¸hi
Gender nvarchar(10) not null
)

--andmete sisestamine
--Id 1, Gender Male
--Id 2, Gender Female
insert into Gender (Id, Gender)
values (1, 'Male'),
(2, 'Female')

--vaatame tabeli sisu
--* t‰hendab, et n‰ita kıike seal sees olevat infot
select * from Gender

--teeme tabeli nimega Person
--veeru nimed: Id int not null primary key,
--Name nvarchar (30)
--Email nvarchar (30)
--Genderid int
create table Persons
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'Aquaman', 'a@a.com', 2),
(5, 'Catwoman', 'c@c.com', 1),
(6, 'Antman', 'ant"ant.com', 2),
(8, NULL, NULL, 2)

--n‰en tabelis olevat infot
select * from Person

--vıırvıtme ¸henduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

--kui sisestad uue rea andmeid ja ei ole sisestanud GenderId alla
--v‰‰rtust, siis automaatselt sisestab sellele reale v‰‰rtuse 3
--e unknown
alter table Person 
add constraint DF_Persons_GenderId
default 3 for GenderId

insert into Gender (Id, Gender)
values (3, 'Unknown')

insert into Person (Id, Name, Email, GenderId)
values (7, 'Black Panther', 'b@b.com', NULL)

insert into Person (Id, Name, Email)
values (9, 'Spiderman', 'spider@man.com')

select * from Person

--piirangu kustutamine
alter table Person
drop constraint DF_Persons_GenderId

--kuidas lisada veergu tabelile Person 
--veeru nimi on Age nvarchar(10)
alter table Person
add Age nvarchar(10)

alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 155)

--kuidas uuendada andmeid
update Person
set Age = 159
where Id = 7

--soovin kustutada ¸he rea
--kuidas seda teha???

delete from Person where Id = 8

--lisame uue veeru City nvarchar(50)

alter table Person
add City nvarchar(50)

--kıik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
--kıik, kes ei ela Gothamis 
select * from Person where City != 'Gotham'
--variant number 2. Kıik, kes ei ela Gothamis
select * from Person where City <> 'Gotham'

--n‰itab teatud vanusega inimesi
select * from Person where Age in (151, 35, 26)
--teine variant
select * from Person where Age = 151 or Age = 35 or Age = 26

--soovin n‰ha inimesi vahemikus 22 kuni 41
select * from Person where Age between 22 and 41

--wildcard e n‰itab kıik g-t‰hega linnad
select * from Person where City like 'g%'
--otsib emailid @-m‰rgiga
select * from Person where Email like '%@%'

--tahan n‰ha, kellel on emailis ees ja peale @-m‰rki ¸ks t‰ht
select * from Person where Email like '_@_%'

--kıik, kellel nimes ei ole esimene t‰ht W, A, S
select * from Person where Name not like '[WAS]%'

--kıik, kes elavad Gothamis ja New Yorkis
select * from Person where (City = 'Gotham' or City = 'New York')

--kıik, kes elavad Gothamis ja New Yorkis ja ning peavad olema
--vanemad, kui 29
select * from Person where (City = 'Gotham' or City = 'New York') and Age >= 29

--kuvab t‰hestikulises j‰rjekorras inimesi ja vıtab aluseks
--Name veeru
select * from Person
select * from Person order by Name

--vıtab kolm esimest rida Person tabelist
select top 3 * from Person

--kolm esimest, aga tabeli j‰rjestus on Age ja siis Name
select top 3 Age, Name from Person

--tund 3
--n‰ita esimesed 50% tabelist
select top 50 percent * from Person
select * from Person

--j‰rjestab vanuse j‰rgi isikud
select * from Person order by Age desc

--muudab Age muutuja int-ks ja n‰itab vanuselises j‰rjestuses
-- cast abil saab andmet¸¸pi muuta
select * from Person order by cast(Age as int) desc

-- kıikide isikute koondvanus e liidab kıik kokku
select sum(cast(Age as int)) from Person

--kıige noorem isik tuleb ¸les leida
select min(cast(Age as int)) from Person

--kıige vanem isik
select max(cast(Age as int)) from Person

--muudame Age muutuja int peale
-- n‰eme konkreetsetes linnades olevate isikute koondvanust
select City, sum(Age) as TotalAge from Person group by City

--kuidas saab koodiga muuta andmet¸¸pi ja selle pikkust
alter table Person 
alter column Name nvarchar(25)

-- kuvab esimeses reas v‰lja toodud j‰rjestuses ja kuvab Age-i 
-- TotalAge-ks
--j‰rjestab City-s olevate nimede j‰rgi ja siis Genderid j‰rgi
--kasutada group by-d ja order by-d
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId
order by City

--n‰itab, et mitu rida andmeid on selles tabelis
select count(*) from Person

--n‰itab tulemust, et mitu inimest on Genderid v‰‰rtusega 2
--konkreetses linnas
--arvutab vanuse kokku selles linnas
select GenderId, City, sum(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person
where GenderId = '1'
group by GenderId, City

--n‰itab ‰ra inimeste koondvanuse, mis on ¸le 41 a ja
--kui palju neid igas linnas elab
--eristab inimese soo ‰ra
select GenderId, City, sum(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person
where GenderId = '2'
group by GenderId, City having sum(Age) > 41

--loome tabelid Employees ja Department
create table Department
(
Id int primary key,
DepartmentName nvarchar(50),
Location nvarchar(50),
DepartmentHead nvarchar(50)
)

create table Employees
(
Id int primary key,
Name nvarchar(50),
Gender nvarchar(50),
Salary nvarchar(50),
DepartmentId int
)

insert into Employees (Id, Name, Gender, Salary, DepartmentId)
values (1, 'Tom', 'Male', 4000, 1),
(2, 'Pam', 'Female', 3000, 3),
(3, 'John', 'Male', 3500, 1),
(4, 'Sam', 'Male', 4500, 2),
(5, 'Todd', 'Male', 2800, 2),
(6, 'Ben', 'Male', 7000, 1),
(7, 'Sara', 'Female', 4800, 3),
(8, 'Valarie', 'Female', 5500, 1),
(9, 'James', 'Male', 6500, NULL),
(10, 'Russell', 'Male', 8800, NULL)

insert into Department(Id, DepartmentName, Location, DepartmentHead)
values 
(1, 'IT', 'London', 'Rick'),
(2, 'Payroll', 'Delhi', 'Ron'),
(3, 'HR', 'New York', 'Christie'),
(4, 'Other Department', 'Sydney', 'Cindrella')

select * from Department
select * from Employees

---
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
---

--arvutab k]ikide palgad kokku Employees tabelist
select sum(cast(Salary as int)) from Employees --arvutab kıikide palgad kokku
-- kıige v‰iksema palga saaja
select min(cast(Salary as int)) from Employees

--n‰itab veerge Location ja Palka. Palga veerg kuvatakse TotalSalary-ks
--teha left join Department tabeliga
--grupitab Locationiga
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentId = Department.Id
group by Location

select * from Employees
select sum(cast(Salary as int)) from Employees --arvutab kıikide palgad kokku

--muudame veeru City pikkust 30 peale
--Employees tabelisse lisada
alter table Employees
add City nvarchar(30)

select City, Gender, sum(cast(Salary as int)) as TotalSalary
from Employees
group by City, Gender

--peaaegu sama p‰ring, aga linnad on t‰hestikulises j‰rjestuses
select City, Gender, sum(cast(Salary as int)) as TotalSalary
from Employees
group by City, Gender
order by City

--on vaja teada, et mitu inimest on nimekirjas selles tabelis
select count (*) from Employees

--mitu tˆˆtajat on soo ja linna kaupa tˆˆtamas
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employee(s)]
from Employees
group by City, Gender

--kuvab kas naised vıi mehed linnade kaupa
--kasutage where
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employee(s)]
from Employees
where Gender = 'Female'
group by City, Gender

--sama tulemus nagu eelmine kord, aga kasutage having
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employee(s)]
from Employees
group by City, Gender
having Gender = 'Female'

--kıik, kes teenivad rohkem kui 4000
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employee(s)]
from Employees
group by City, Gender
having sum(cast(Salary as int)) > 4000

--loome tabeli, milles hakatakse automaatselt nummerdama Id-d
create table Test1
(
Id int identity(1,1),
Value nvarchar(20)
)

insert into Test1 values('X')
select * from Test1

--kustutame veeru nimega City Employees tabelist
alter table Employees
drop column City

--inner join
--kuvab neid, kellel on DepartmentName all olemas v‰‰rtus
--mitte kattuvad read eemaldatakse tulemusest
--ja sellep‰rast ei n‰idata Jamesi ja Russelit
--kuna neil on DepartmentId NULL
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

--left join
select Name, Gender, Salary, DepartmentName
from Employees
left join Department --vıib kasutada ka LEFT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--uurige, mis on left join
--n‰itab andmeid, kus vasakpoolsest tabelist isegi, siis kui seal puudub
--vıırvıtme reas v‰‰rtus

--right join
select Name, Gender, Salary, DepartmentName
from Employees
right join Department --vıib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--right join n‰itab paremas (Department) tabelis olevaid v‰‰rtuseid,
--mis ei ¸hti vasaku (Employees) tabeliga

--outer join
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department
on Employees.DepartmentId = Department.Id
--mılema tabeli read kuvab

--teha cross join
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department
--korrutab kıik omavahel l‰bi

--teha left join, kus Employee tabelist DepartmentId on null
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null

--teine variant ja sama tulemus
select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Department.Id is null
--n‰itab ainult neid, kellel on asakus tabelis (Employees)
--DepartmentId null

select Name, Gender, Salary, DepartmentName
from Employees
left join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
--n‰itab ainult paremas tabelis olevat rida, 
--mis ei kattu Employees-ga

--full join
--mılema tabeli mitte kattuvate v‰‰rtustega read kuvab v‰lja
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
or Department.Id is null

--teete AdventureWorksLT2019 andmebaasile join p‰ringud
--inner join, left join, right join, cross join ja full join
--tabeleid sellesse andmebaasi juurde ei tohi teha

--inner join
--Mınikord peab muutuja ette kirjutama taebli nimetuse nagu on Product.Name,
--et editor saaks aru, et kumma tabeli muutujat soovitakse kasutada ja ei tekiks
--segadust
select Product.Name as [Product Name], ProductNumber, ListPrice, 
ProductModel.Name as [Product Model Name], 
Product.ProductModelId, ProductModel.ProductModelId
--mınikord peab ka tabeli ette kirjutama t‰psustava info
--nagu on SalesLt.Product
from SalesLt.Product
inner join SalesLt.ProductModel
--antud juhul Producti tabelis ProductModelId vıırvıti,
--mis ProductModeli tabelis on primaarvıti
on Product.ProductModelId = ProductModel.ProductModelId




