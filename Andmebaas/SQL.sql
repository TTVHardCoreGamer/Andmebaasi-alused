--17.02.2026
--tund nr 1

-- teeme andmebaasi e db
create database IKT25tar

--andmebaasi valimine
use IKT25tar

--andmebaasi kustutamine koodiga
--otsida kood ülesse
drop database IKT25tar

--teeme uuesti andmebaasi IKT25tar
create database IKT25tar

--teeme tabeli
create table Gender
(
--Meil on muutuja Id,
--mis on täisarv andmetüüp,
--kui sisestad andmed, 
--siis see veerg peab olema täidetud,
--tegemist on primaarvõtmega
Id int not null primary key,
--veeru nimi on Gender,
--10 tähemärki on max pikkus,
--andmed peavad olema sisestatud e 
--ei tohi olla tühi
Gender nvarchar(10) not null
)

--andmete sisestamine Gender tabelisse
--proovige ise teha
-- Id = 1, Gender = Male
-- Id = 2, Gender = Female
insert into Gender (Id, Gender)
values (1, 'Male'),
(2, 'Female')

--vaatame tabeli sisu
-- * tähendab, et näita kõike seal sees olevat infot
select * from Gender

--teeme tabeli nimega Person
--veeru nimed: Id int not null primary key,
-- Name nvarchar (30)
-- Email nvarchar (30)
--GenderId int
create table Person
(
Id int not null primary key,
Name nvarchar(30),
Email nvarchar(30),
GenderId int
)

--18.02.2026
--tund nr 2

insert into Person (Id, Name, Email, GenderId)
values (1, 'Superman', 's@s.com', 2),
(2, 'Wonderwoman', 'w@w.com', 1),
(3, 'Batman', 'b@b.com', 2),
(4, 'Aquaman', 'a@a.com', 2),
(5, 'Catwoman', 'c@c.com', 1),
(6, 'Antman', 'ant"ant.com', 2),
(8, NULL, NULL, 2)

--näen tabelis olevat infot
select * from Person

--võõrvõtme ühenduse loomine kahe tabeli vahel
alter table Person add constraint tblPerson_GenderId_FK
foreign key (GenderId) references Gender(Id)

-- kui sisestad uue rea andmeid ja ei ole sisestanud GenderId alla 
-- väärtust, siis automaatselt sisestab sellele reale väärtuse 3
-- e unknown
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

--piirnagu kustutamine
alter table Person
drop constraint DF_Persons_GenderId

--kuidas lisada veergu tabelile Person
--veeru nimi on Age nvarchar(10)
alter table Person
add Age nvarchar(10)

alter table Person
add constraint CK_Person_Age check (Age > 0 and Age < 155)

-- kuidas uuendada andemeid
update Person
set Age = 159
where Id = 7

select * from Person

--soovin kustutada ühe rea
-- kuidas seda teha????
delete from Person where Id = 8

select * from Person

--lisame uue veeru City nvarchar(50)
alter table Person
add City nvarchar(50)

--kõik, kes elavad Gothami linnas
select * from Person where City = 'Gotham'
-- k]ik, kes ei ela Gothamis
select * from Person where City != 'Gotham'
-- variant nr 2. K]ik, kes ei ela Gothamis
select * from Person where City <> 'Gotham'

--näitab teatud vanusega inimesi
-- valime 151, 35, 26
select * from Person where Age in (151, 35, 26)
select * from Person where Age = 151 or Age = 35 or Age = 26

-- soovin näha inimesi vahemikus 22 kuni 41
select * from Person where Age between 22 and 41

--wildcard e näitab kõik g-tähega linnad
select * from Person where City like 'g%'
--otsib emailid @-märgiga
select * from Person where Email like '%@%'

--tahan näha, kellel on emailis ees ja peale @-märki üks täht
select * from Person where Email like '_@_.com'

--kõik, kelle nimes ei ole esimene täht W, A, S
select * from Person where Name like '[^WAS]%'

--k]ik, kes elavad Gothamis ja New Yorkis
select * from Person where (City = 'Gotham' or City = 'New York')

-- k]ik, kes elavad Gothamis ja New Yorkis ning peavad olema 
-- vanemad, kui 29
select * from Person where (City = 'Gotham' or City = 'New York')
and Age >= 30

--kuvab tähestikulises järjekorras inimesi ja võtab aluseks 
-- Name veeru
select * from Person
select * from Person order by Name

--võtab kolm esimest rida Person tabelist
select top 3 * from Person

--tund 3
--25.02.2026
--kolm esimest, aga tabeli järjestus on Age ja siis Name
select top 3 Age, Name from Person

--näita esimesed 50% tabelist
select top 50 percent * from Person
select * from Person

--järjestab vanuse järgi isikud
select * from Person order by Age desc

--muudab Age muutuja int-ks ja näitab vanuselises järjestuses
-- cast abil saab andmetüüpi muuta
select * from Person order by cast(Age as int) desc

-- kõikide isikute koondvanus e liidab kõik kokku
select sum(cast(Age as int)) from Person

--kõige noorem isik tuleb üles leida
select min(cast(Age as int)) from Person

--kõige vanem isik
select max(cast(Age as int)) from Person

--muudame Age muutuja int peale
-- näeme konkreetsetes linnades olevate isikute koondvanust
select City, sum(Age) as TotalAge from Person group by City

--kuidas saab koodiga muuta andmetüüpi ja selle pikkust
alter table Person 
alter column Name nvarchar(25)

-- kuvab esimeses reas välja toodud järjestuses ja kuvab Age-i 
-- TotalAge-ks
--järjestab City-s olevate nimede järgi ja siis Genderid järgi
--kasutada group by-d ja order by-d
select City, GenderId, sum(Age) as TotalAge from Person
group by City, GenderId
order by City

--näitab, et mitu rida andmeid on selles tabelis
select count(*) from Person

--näitab tulemust, et mitu inimest on Genderid väärtusega 2
--konkreetses linnas
--arvutab vanuse kokku selles linnas
select GenderId, City, sum(Age) as TotalAge, count(Id) as 
[Total Person(s)] from Person
where GenderId = '1'
group by GenderId, City

--näitab ära inimeste koondvanuse, mis on üle 41 a ja
--kui palju neid igas linnas elab
--eristab inimese soo ära
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
select sum(cast(Salary as int)) from Employees --arvutab kõikide palgad kokku
-- kõige väiksema palga saaja
select min(cast(Salary as int)) from Employees

--näitab veerge Location ja Palka. Palga veerg kuvatakse TotalSalary-ks
--teha left join Department tabeliga
--grupitab Locationiga
select Location, sum(cast(Salary as int)) as TotalSalary
from Employees
left join Department
on Employees.DepartmentId = Department.Id
group by Location


-- 4 tund
-- 03.03.26

select * from Employees
select sum(cast(Salary as int)) from Employees  --arvutab kõikide palgad kokku

-- lisame veeru City ja pikkus on 30
-- Employees tabelisse lisada
alter table Employees
add City nvarchar(30)

select City, Gender, sum(cast(Salary as int)) as TotalSalary 
from Employees
group by City, Gender

--peaaegu sama päring, aga linnad on tähestikulises järjestuses
select City, Gender, sum(cast(Salary as int)) as TotalSalary 
from Employees 
group by City, Gender 
order by City

select * from Employees
--on vaja teada, et mitu inimest on nimekirjas selles tabelis
select count (*) from Employees

--mitu töötajat on soo ja linna kaupa töötamas
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employee(s)]
from Employees 
group by Gender, City 

--kuvab kas naised või mehed linnade kaupa
--kasutage where
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employee(s)]
from Employees 
where Gender = 'Female'
group by Gender, City 

--sama tulemuse nagu eelmine kord, aga kasutage: having
select City, Gender, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employee(s)]
from Employees 
group by Gender, City 
having Gender = 'Female'

--kõik, kes teenivad rohkem, kui 4000
select * from Employees where sum(cast(Salary as int)) > 4000

--teeme variandi, kus saame tulemuse
select Gender, City, sum(cast(Salary as int)) as TotalSalary,
count (Id) as [Total Employee(s)]
from Employees 
group by Gender, City 
having sum(cast(Salary as int)) > 4000

--loome tabeli, milles hakatakse automaatselt nummerdama Id-d
create table Test1
(
Id int identity(1,1),
Value nvarchar(20)
)

insert into Test1 values('X')
select * from Test1


--5 tund
--04.03.26

--kustutame veeru nimega City Employee tabelist
alter table Employees
drop column City


--inner join 
--kuvab neid, kellel on DepartmentName all olemas väärtus
--mitte kattuvad read eemaldatakse tulemusest
-- ja sellepärast ei näidata Jamesi ja Russelit tabelis
--kuna neil on DepartmentId NULL
select Name, Gender, Salary, DepartmentName
from Employees
inner join Department
on Employees.DepartmentId = Department.Id

-- left join
select Name, Gender, Salary, DepartmentName
from Employees
left join Department  --võib kasutada ka LEFT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--uurige, mis on left join
--näitab andmeid, kus vasakpoolsest tabelist isegi, siis kui seal puudub
--võõrvõtme reas väärtus

--right join
select Name, Gender, Salary, DepartmentName
from Employees
right join Department  --võib kasutada ka RIGHT OUTER JOIN-i
on Employees.DepartmentId = Department.Id
--right join näitab paremas (Department) tabelis olevaid väärtuseid,
--mis ei ühti vasaku (Employees) tabeliga

--outer join
select Name, Gender, Salary, DepartmentName
from Employees
full outer join Department
on Employees.DepartmentId = Department.Id
--mõlema tabeli read kuvab

--teha cross join
select Name, Gender, Salary, DepartmentName
from Employees
cross join Department
--korrutab kõik omavahel läbi

--teha left join, kus Employees tabelist DepartmentId on null
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
-- näitab ainult neid, kellel on vasakus tabelis (Employees)
-- DepartmentId null

select Name, Gender, Salary, DepartmentName
from Employees
right join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
--näitab ainult paremas tabelis olevat rida, 
--mis ei kattu Employees-ga.

--full join
--mõlema tabeli mitte-kattuvate väärtustega read kuvab välja
select Name, Gender, Salary, DepartmentName
from Employees
full join Department
on Employees.DepartmentId = Department.Id
where Employees.DepartmentId is null
or Department.Id is null

--teete AdventureWorksLT2019 andmebaasile join p'ringuid:
--inner join, left join, right join, cross join ja full join
--tabeleid sellesse andmebaasi juurde ei tohi teha

--Mõnikord peab muutuja ette kirjutama tabeli nimetuse nagu on Product.Name,
--et editor saaks aru, et kummma tabeli muutujat soovitakse kasutada ja ei tekiks
--segadust
select Product.Name as [Product Name], ProductNumber, ListPrice, 
ProductModel.Name as [Product Model Name], 
Product.ProductModelId, ProductModel.ProductModelId
--mõnikord peab ka tabeli ette kirjutama täpsustama info
--nagu on SalesLt.Product
from SalesLt.Product
inner join SalesLt.ProductModel
--antud juhul Producti tabelis ProductModelId võõrvõti,
--mis ProductModeli tabelis on primaarvõti
on Product.ProductModelId = ProductModel.ProductModelId

--rida 412
--6 tund
--12.03.26

--isnull funktsiooni kasutamine
select isnull('Ingvar', 'No Manager') as Manager

-- NULL asemel kuvab No Manager
select coalesce(NULL, 'No Manager') as Manager

alter table Employees
add ManagerId int

--neile, kellel ei ole ülemust, siis paneb neile No Manager teksti
--kasutage left joini
select  E.Name as Employee, isnull(M.Name, 'No Manager') as Manager
from Employees E
left join Employees M
on E.ManagerId = M.Id

--kasutame inner joini
--kuvab ainult ManagerId all olevate isikute väärtuseid
select E.Name as Employee, M.Name as Manager
from Employees E
inner join Employees M
on E.ManagerId = M.Id

--kõik saavad kõikide ülemused olla
select E.Name as Employee, M.Name as Manager
from Employees E
cross join Employees M

--lisame Employees tabelisse uued veerud
alter table Employees
add MiddleName nvarchar(30)

alter table Employees
add LastName nvarchar(30)

--muudame olemasoleva veeru nimetust
sp_rename 'Employees.Name', 'FirstName'

update Employees
set FirstName = 'Tom', MiddleName = 'Nick', LastName = 'Jones'
where Id = 1

update Employees
set FirstName = 'Pam', MiddleName = NULL, LastName = 'Anderson'
where Id = 2

update Employees
set FirstName = 'John', MiddleName = NULL, LastName = NULL
where Id = 3

update Employees
set FirstName = 'Sam', MiddleName = NULL, LastName = 'Smith'
where Id = 4

update Employees
set FirstName = NULL, MiddleName = 'Todd', LastName = 'Someone'
where Id = 5

update Employees
set FirstName = 'Ben', MiddleName = 'Ten', LastName = 'Sven'
where Id = 6

update Employees
set FirstName = 'Sara', MiddleName = NULL, LastName = 'Connor'
where Id = 7

update Employees
set FirstName = 'Valarie', MiddleName = 'Balerine', LastName = NULL
where Id = 8

update Employees
set FirstName = 'James', MiddleName = '007', LastName = 'Bond'
where Id = 9

update Employees
set FirstName = NULL, MiddleName = NULL, LastName = 'Crowe'
where Id = 10

--igast reast võtab esimesena täidetud lahtri ja kuvab ainult seda
--coalesce
select * from Employees
select Id, coalesce(FirstName, MiddleName, LastName) as Name
from Employees

--loome kaks tabelit
create table IndianCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

create table UKCustomers
(
Id int identity(1,1),
Name nvarchar(25),
Email nvarchar(25)
)

--sisestame tabelisse andmeid
insert into IndianCustomers (Name, Email)
values ('Raj', 'R@R.com'),
('Sam', 'S@S.com')

insert into UKCustomers (Name, Email)
values ('Ben', 'B@B.com'),
('Sam', 'S@S.com')

select * from IndianCustomers
select * from UKCustomers

--kasutame union all, mis näitab kõiki ridu
--union all ühendab tabelid ja näitab sisu
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers

--korduvate väärtustega read pannakse ühte ja ei korrata
select Id, Name, Email from IndianCustomers
union
select Id, Name, Email from UKCustomers

--kasutad union all, aga sorteerid nime järgi
select Id, Name, Email from IndianCustomers
union all
select Id, Name, Email from UKCustomers
order by Name

--stored procedure
--tavaliselt pannakse nimetuse ette sp, mis tähendab stored procedure
create procedure spGetEmployees
as begin
	select FirstName, Gender from Employees
end

--nüüd saab kasutada selle nimelist sp-d
spGetEmployees
exec spGetEmployees
execute spGetEmployees

create proc spGetEmployeesByGenderAndDepartment
--@ tähendab muutujat
@Gender nvarchar(20),
@DepartmentId int
as begin
	select FirstName, Gender, DepartmentId from Employees where Gender = @Gender
	and DepartmentId = @DepartmentId
end

--kui nüüd allolevat käsklust käima panna, siis nõuab gender parameetrit
spGetEmployeesByGenderAndDepartment

--õige variant
spGetEmployeesByGenderAndDepartment 'Female', 1

--niimoodi saab sp kirja pandud j'rjekorrast mööda minna, kui ise paned muutuja paika
spGetEmployeesByGenderAndDepartment @DepartmentId = 1, @Gender = 'Male'

---saab vaadata sp sisu result vaates
sp_helptext spGetEmployeesByGenderAndDepartment

--kuidas muuta sp-d ja panna sinna v]ti peale, et keegi teine peale teie ei saaks muuta
--kuskile tuleb lisada with encryption
alter proc spGetEmployeesByGenderAndDepartment   
@Gender nvarchar(20),  
@DepartmentId int 
with encryption
as begin  
 select FirstName, Gender, DepartmentId from Employees where Gender = @Gender  
 and DepartmentId = @DepartmentId  
end

--sp tegemine
create proc spGetEmployeeCountByGender
@Gender nvarchar(20),
@EmployeeCount int output
as begin
	select @EmployeeCount = count(Id) from Employees where Gender = @Gender
end

--annab tulemuse, kus loendab ära nõuetele vastavad read
--prindib ka tulemuse kirja teel
--tuleb teha declare muutuja @TotlaCount, mis on int
declare @TotalCount int
--execute spGetEmployeeCountByGender sp, kus on parameetrid Male ja TotalCount
execute spGetEmployeeCountByGender 'Male', @TotalCount out
--if ja else, kui TotalCount = 0, siis tuleb tekst TotalCount is null
if(@TotalCount = 0)
	print '@TotalCount is null'
else
	print '@Total is not null'
print @TotalCount
--l]pus kasuta print @TotalCounti puhul

--- 7 tund
--- 17.03.2026
-- näitab ära, mitu rida vastab nõuetele

-- deklareerime muutuja @TotalCount, mis on int andmetüüp
declare @TotalCount int
-- käivitame stored procedure spGetEmployeeCountByGender, kus on parameetrid
-- @EmployeeCount = @TotalCount out ja @Gender 
execute spGetEmployeeCountByGender @EmployeeCount = @TotalCount out, @Gender = 'Female'
--prindib konsooli välja, kui TotalCount on null või mitte null
print @TotalCount

--sp sisu vaatamine
sp_help spGetEmployeeCountByGender
-- tabeli info vaatamine
sp_help Employees
--kui soovid sp teksti näha
sp_helptext spGetEmployeeCountByGender

-- vaatame, millest sõltub meie valitud sp
sp_depends spGetEmployeeCountByGender
-- näitab, et sp sõltub Employees tabelist, kuna seal on count(Id) 
-- ja Id on Employees tabelis

--vaatame tabelit
sp_depends Employees

--teeme sp, mis annab andmeid Id ja Name veergude kohta Employees tabelis
create proc spGetNameById
@Id int,
@Name nvarchar(20) output
as begin
	select @Id = Id, @Name = FirstName from Employees
end

--annab kogu tabeli ridade arvu
create proc spTotalCount2
@TotalCount int output
as begin
	select @TotalCount = count(Id) from Employees
end

-- on vaja teha uus päring, kus kasutame spTotalCount2 sp-d, 
-- et saada tabeli ridade arv

-- tuleb deklareerida muutuja @TotalCount, mis on int andmetüüp
declare @TotalEmployees int
--tuleb execute spTotalCount2, kus on parameeter @TotalEmployees
exec spTotalCount2 @TotalEmployees output
select @TotalEmployees

--mis Id all on keegi nime järgi
create proc spGetNameById1
@Id int,
@FirstName nvarchar(20) output
as begin
	select @FirstName = FirstName from Employees where Id = @Id
end

--annab tulemuse, kus id 1(seda numbrit saab muuta) real on keegi koos nimega
--print tuleb kasutada, et näidata tulemust
declare @FirstName nvarchar(20)
execute spGetNameById1 3, @FirstName output
print 'Name of the employee = ' + @FirstName

--- tehke sama, mis eelmine, aga kasutage spGetNameById sp-d
--FirstName lõpus on outdeclare 
declare @FirstName nvarchar(20)
execute spGetNameById 1, @FirstName out
print 'Name = ' + @FirstName

--output tagastab muudetud read kohe p'ringu tulemsuena
--see on salvestatud protseduuris ja ühe väärtuse tagastamine
--out ei anna mitte midagi, kui seda ei määra execute käsus

--rida 668
--tund 8

sp_help spGetNameById

create proc spGetNameById2
@Id int
--kui on begin, siis on ka end kuskil olemas
as begin 
return (select FirstName from Employees where Id = @Id)
end

--tuleb veateade kuna kutsusime välja int-i, aga Tom on nvarchar
declare @EmployeeName nvarchar(50)
execute @EmployeeName = spGetNameById2 1
print 'Name of the employee = ' + @EmployeeName


--sisseehitatud string funktsioonid
--see konverteerib ASCII tähe väärtuse numbriks
select ASCII('A')

select char(122)

--prindime kogu tähestiku välja
declare @start int = 97;
--kasutate while, et näidata kogu tähestik ette
while @start <= 122
begin
   print char(@start)
   set @start = @start + 1
end

--eemaldame tühjad kohad sulgudes
select ('                     Hello')
select LTRIM('                     Hello')

--tühikute eemaldamine veerust, mis on tabelis
select LTRIM(FirstName), MiddleName, LastName from Employees
--eemaldage tühikud FirstName veerust ära

--paremalt poolt tühjad stringid lõikab ära
select RTRIM('      Hello       ')

--keerab kooloni sees olevad andmed vastupidiseks
--vastavalt loweriga ja upperiga saan muuta märkide suurust
--reverse funktsioon pöörab kõk ümber
select REVERSE(upper(ltrim(FirstName))) as FirstName, MiddleName, lower(LastName),
RTRIM(LTRIM(FirstName)) + ' ' + MiddleName + ' ' + LastName as FullName
from Employees

--left, right substring
--vasakult poolt neil esimest tähte
select LEFT('ABCDEF', 4)
--paremalt poolt kolm tähte
select right('ABCDEF', 3)

--kuvab @-tähemärgi asetust e mitmes on esitatud tähemärk
select CHARINDEX('@', 'sara@aaa.com')

--esimene nr peale komakohta näitab, et mitmendast alustab ja 
--siis mitu nr peale seda kuvada
select SUBSTRING('pam@bbb.com', 5, 2)

--@ märgist kuvab kolm tähemärki. Viimase numbri saa määrata pikkust
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 1, 3)

--peale @ märki hakkab kuvama tulemust, nr saab kaugust seadistada
select SUBSTRING('pam@bbb.com', CHARINDEX('@', 'pam@bbb.com') + 2, 
LEN('pam@bbb.com') - CHARINDEX('@', 'pam@bbb.com'))

alter table Employees
add Email nvarchar(20)

update Employees set Email = 'Tom@aaa.com' where Id = 1;
update Employees set Email = 'Pam@bbb.com' where Id = 2;
update Employees set Email = 'John@aaa.com' where Id = 3;
update Employees set Email = 'Sam@bbb.com' where Id = 4;
update Employees set Email = 'Todd@bbb.com' where Id = 5;
update Employees set Email = 'Ben@ccc.com' where Id = 6;
update Employees set Email = 'Sara@ccc.com' where Id = 7;
update Employees set Email = 'Valarie@aaa.com' where Id = 8;
update Employees set Email = 'James@bbb.com' where Id = 9;
update Employees set Email = 'Russel@bbb.com' where Id = 10;

--soovime teada saada deomeeninimesid emailides
select SUBSTRING(Email, CHARINDEX('@', Email) + 1,
len(Email) - charindex('@', Email)) as EmailDomain
from Employees

--alates teisest tähest emailis kuni @ märgini on tärnid
SELECT FirstName, LastName,
substring(Email, 1, 2) + replicate('*', 5) +
substring(Email, charindex('@', Email), len(Email) - charindex('@', Email)+1) as Email
from Employees

--kolm korda näitab stringis olevat väärtust
select REPLICATE('asd', 3)

--tühiku sisestamine
select SPACE(5)

--tühiku sisestamine FirstName ja LastName vahele
select FirstName + SPACE(25) + LastName as FullName
from Employees

--PATINDEX
--sama, mis charindex, aga dünaamilisem ja saab kasutada wildcardi
select Email, PATINDEX('%@aaa.com', Email) as FirstOccurence
from Employees
where PATINDEX('%@aaa.com', Email) > 0
--leian kõik selle domeeni esindajad ja alates mitmendas märgist algab @

--kõik .com emailid asendab .net
SELECT Email, REPLACE(Email, '.com', '.net') as ConvertedEmail
FROM Employees

--soovin asendada peale esimest märki kolm tähte viie tärniga
SELECT FirstName, LastName, Email,
STUFF(Email, 2, 3, '*****') as StuffedEmail
from Employees

create table DateTime
(
c_time time,
c_date date,
c_smalldatetime smalldatetime,
c_datetime datetime,
c_datetime2 datetime2,
c_datetimeoffset datetimeoffset
)

select * from DateTime

--konkreetse masina kellaaeg
select getdate(), 'GETDATE'

insert into DateTime
values (GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE(), GETDATE())
select * from DateTime

update DateTime set c_datetimeoffset = '2026-04-08 14:49:28.1933333 +10:00'
where c_datetimeoffset = '2026-03-19 14:25:09.8900000 +00:00'

select CURRENT_TIMESTAMP, ' CURRENT_TIMESTAMP' --aja päring
select SYSDATETIME(), 'SYSDATETIME' --veel täpsem aja päring
SELECT SYSDATETIMEOFFSET(), 'SYSDATETIMEOFFSET' --täpne aeg koos ajalise nihkega
select GETUTCDATE(), 'GETUTCDATE' --UTC aeg

--saab kontrollida, kas on õige andmetüüp
select ISDATE('asd') --tagastab 0 kuna string ei ole date
select ISDATE(GETDATE()) --kuidas saada vastuseks 1 isdate puhul?
select ISDATE('2026-04-08 14:49:28.1933333') --tagastab 0 kuna max kolm komakohta võib olla
select ISDATE('2026-04-08 14:49:28.193') --tagastab 1
select DAY(GETDATE()) --annab tänase päeva nr
select DAY('01/24/2026') --annab stringis oleva kp ja järjestus peab olema õige
select month(GETDATE()) --annab jooksva kuu nr
select month('01/24/2026') --annab stringis oleva kuu ja järjestus peab olema õige
select year(GETDATE()) --annab tänase aasta nr
select year('01/24/2026') --annab stringis oleva aasta ja järjestus peab olema õige

select DATENAME(DAY, '2026-04-08 14:49:28.1933333') --annab stringis oleva päeva nr
select DATENAME(WEEKDAY, '2026-04-08 14:49:28.1933333') --annab stringis oleva päeva sõnana
select DATENAME(MONTH, '2026-04-08 14:49:28.1933333') --annab stringis oleva kuu sõnana

create table EmployeesWithDates
(
Id nvarchar(2),
Name nvarchar(20),
DateOfBirth datetime
)

INSERT INTO EmployeesWithDates (Id, Name, DateOfBirth) VALUES 
('1', 'Sam', '1980-12-30 00:00:00'),
('2', 'Pam', '1982-03-21 3:38:26'),
('3', 'John', '1985-08-21 20:33:36'),
('4', 'Sara', '1979-11-29 12:59:30.67'),
('5', 'Todd', '1978-11-29 12:59:30.67')

select * from EmployeesWithDates                                                                              
truncate table EmployeesWithDates
-- tund 9

--kuidas võtta ühest veerust andmeid ja selle abil luua uued veerud

--vaatab DoB veerust päeva ja kuvab päeva nimetuse sõnana
select Name, DateOfBirth, DATENAME(WEEKDAY, DateOfBirth) as [Day],

--vaatab VoB veerust kuupäevasid ja kuvab kuu nr
month(DateOfBirth) as MoNtNumber,

--vaatab DoB veerust kuud ja kuvab sõnana
DATENAME(MONTH, DateOfBirth) as [MonthName],

--võtab DoB veerust aasta
YEAR(DateOfBirth) as [Year]
from EmployeesWithDates

--kuvab 3 kuna USA nädal algab pühapäevaga
select DATEPART(WEEKDAY, '2026-03-24 13:13:30.67')
--tehke sama, aga kasutage kuud
select DATEPART(month, '2026-03-24 13:13:30.67')
--lidab stringis olevale kp 20 päeva juurde
select dateadd(DAY, 20,  '2026-03-24 13:13:30.67')
--sama asi, aga lahutab 20 päeva
select dateadd(DAY, -20,  '2026-03-24 13:13:30.67')  
--kuvab kahe stringis oleva kuudevahelist aega numbrina
select datediff(month, '11/20/2026', '01/20/2024')
--tehke sama, aga kasutage aastat
select datediff(year, '11/20/2026', '01/20/2028')

--alguses uurite mis on funktsioon MS SQL
-- eelkirjutatud toimingud, alvestatud tegevus
--miks seda on vaja
--pakkuda DB korduvkasutatud funktsionaalsust
--mis on selle eelised ja puudused
--saad kiiresti kasutada toiminguid ja ei pea uuesti koodi kirjutama
--funktsioon ei tohi muuta DB olekut

create function fnComputeAge(@DOB datetime)
returns nvarchar(50)
as begin
    declare @tempdate datetime, @years int, @months int, @days int
    select @tempdate = @DOB

	select @years = DATEDIFF(YEAR, @tempdate, GETDATE()) - case when (MONTH(@DOB) >
	MONTH(getdate())) or (MONTH(@DOB) = MONTH(getdate()) and DAY(@DOB) > DAY(GETDATE()))
	then 1 else 0 end
	select @tempdate = DATEADD(YEAR, @Years, @tempdate)

	select @months = DATEDIFF(MONTH, @tempdate, GETDATE()) - case when DAY(@DOB) > DAY(GETDATE()) then 1 else 0 end
	select @tempdate = DATEADD(MONTH, @months, @tempdate)

	select @days = DATEDIFF(DAY, @tempdate, GETDATE())

	declare @Age nvarchar(50)
	    set @Age = CAST(@years as nvarchar(4)) + ' Years ' + CAST(@months as nvarchar(2))
		+ ' Months ' + CAST(@days as nvarchar(2)) + ' Days old '
		return @Age
end

select Id, Name, DateOfBirth, dbo.fnComputeAge(DateOfBirth) as Age from EmployeesWithDates

--tund 10

--kui kasutame seda funktsiooni, siis saame teada tänase päeva vahet stringis välja tooduga
select dbo.fnComputeAge('02/24/2010') as age

--nr peale DOB muutujat näitab, et mismoodi kuvada DOB-d
select Id, Name, DateOfBirth,
CONVERT(nvarchar, DateOfBirth, 109) as ConvertedDOB
from EmployeesWithDates

select Id, Name, Name + ' - ' + CAST(Id as nvarchar) as [Name-Id] 
from EmployeesWithDates

select CAST(GETDATE() as date) --tänane kp

--tänane kp, aga kasutate convert-i, et kuvada stringi
select CONVERT(date, GETDATE())

--matemaatilised funktsioonid
select ABS(-5) --abs on absoluutväärtusega number ja tulemuseks saame positiivse arvu
select CEILING(4.2) --ceiling on funktsioon, mis ümardab ülespoole ja tulemuseks saame 5
select CEILING(-4.2) --ceiling ümardab ka miinus numbrid ülespoole, mis tähendab, et saame -4
select FLOOR(15.2) --floor on funktsioon, mis ümardab alla, mis tähendab, et saame 15
select FLOOR(-15.2) --floor on funktsioon, mis ümardab alla, mis tähendab, et saame -15
select POWER(2, 4) --kaks astems 4 ehk siis ruudus
select SQUARE(9) --antud juhul 9 ruudus 
select SQRT(16) --antud juhul 16 ruutjuur

select RAND() --rand on funktsioon, mis genereerib
--juhusliku numbri vahemikus 0 kuni 1

--kuidas saada täisnumber iga kord
select FLOOR(RAND() * 100) --korrutab 100 iga numbri ja ümardab

--iga kord näitab 10 suvalist numbrit
declare @counter int
set @counter = 1
while (@counter <= 10)
begin
    print floor(rand() * 100)
    set @counter = @counter + 1
end

select ROUND(850.556, 2) --round on funktsioon, mis ümardab kaks komakohta
--ja tulemuseks saame 850.56
select ROUND(850.556, 2, 1) --round on funktsioon, mis ümardab kaks komakohta ja
--kui kolmas parameeter on 1, siis ümardab alla
select ROUND(850.556, 1) --ümardab ühe komakoha
select ROUND(850.556, 1, 1) --ümardab alla ühe komakoha pealt
select ROUND(850.556, -2) --ümardab täisnr ülessepoole
select ROUND(850.556, -1) --ümardab täisnr alla

---
create function dbo.CalculateAge(@DOB date)
returns int
as begin 
declare @Age int

set @Age = DATEDIFF(YEAR, @DOB, GETDATE()) - 
case 
    when (MONTH(@DOB) > MONTH(GETDATE())) or
	     (MONTH(@DOB) = MONTH(GETDATE()) and DAY(@DOB) > DAY(GETDATE()))
	then 1 else 0 end
	return @Age
end

--kui tehtud, siis proovige funktsiooni ja vaadake, kas annab õige vanuse
exec dbo.CalculateAge '1980-12-30'

--arvutab välja, kui vana on isik ja võtab arvesse kuud ning päevad
--antud juhul näitab kõike, kes on üle 36 a vanad
select Id, dbo.CalculateAge(DateOfBirth) as Age from EmployeesWithDates
where dbo.CalculateAge(DateOfBirth) > 36

--tund 11
--02.04.2026

-- inline table valued functions
alter table EmployeesWithDates
add DepartmentId int
alter table EmployeesWithDates
add Gender nvarchar(10)

select * from EmployeesWithDates

update EmployeesWithDates
set DepartmentId = 1,
    Gender = 'Male'
where Id = 5;

--scalar funktsioon annab mingis vahemikus olevaid andmeid,
--inline table values ei kasuta begin ja end funktsioone
--scalar annab väärtused ja inline annab tabeli

create function fn_EmployeesByGender(@Gender nvarchar(10))
returns table
as
return (select Id, Name, DateOfbirth, DepartmentId, Gender
from EmployeesWithDates
where Gender = @Gender)

--kuidas leida kõik naised tabelis EmployeesWithDates
--ja kasutada funktsiooni fn_EmployeeByGender

select * from fn_EmployeesByGender('Female')

--tahaks ainult Pami nime näha

select * from fn_EmployeesByGender('Female')
where Name = 'Pam'

select * from Department

--kahest erinevast tabelist andmete võtmine ja 
--koos kuvamine
--esimene on funktsioon ja teine tabel

select Name, Gender, DepartmentName
from fn_EmployeesByGender('Male') E
join Department D on D.Id = E.DepartmentId

--multi tabel statement
--inline funktsioon
create function fn_GetEmployees()
returns table as
return (Select Id, Name, CAST(DateOfBirth as date)
       as DOB
       from EmployeesWithDates)

select * from fn_GetEmployees()

--multi-state puhul peab defineerima uue tabeli veerud koos muutujatega
--funktsiooni nimi on fn_MS_GetEmployees()
--peab edastama meile Id, Name, DOB tabelist EmployeesWithDates
create function fn_MS_GetEmployees()
returns @Table Table (Id int, Name nvarchar(20), DOB date)
as begin
insert into @Table
select Id, Name, CAST(DateOfBirth as date) from EmployeesWithDates
return
end

select * from fn_MS_GetEmployees()

--inline tabeli funktsioonid on paremini töötamas kuna käsitletakse vaatena
--multi puhul on pm tegemist stored proceduriga ja kulutab ressurssi rohkem

--muudame andmeid ja vaatame, kas inline funktsioonis on muutused kajastatud
update fn_GetEmployees() set Name = 'Sam1' where Id = 1
select * from fn_GetEmployees() --saab muuta

update fn_Ms_GetEmployees() set Name = 'Sam2' where Id = 1
--ei saa muuta andmeid multi state funktsionis,
--kuna see on nagu stored procedure

--deterministic vs non-deterministic functions
--deterministic funktsioonid annavad alati sama tulemuse, kui sisend on sama
select COUNT(*) from EmployeesWithDates
select SQUARE(4)

--non-deterministic funktsioonid annavad erineva tulemuse, kui sisend on sama
select GETDATE()
select CURRENT_TIMESTAMP
select RAND()
