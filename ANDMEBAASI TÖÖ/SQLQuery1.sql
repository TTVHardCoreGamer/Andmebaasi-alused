--1
create table Liikmed
(
Id int primary key,
Eesnimi nvarchar(50),
Perenimi nvarchar(50),
Vanus int,
Liitumise_aasta int
)

--2
insert into Liikmed (Id, Eesnimi, Perenimi, Vanus, Liitumise_aasta)
values (1, 'Mari', 'Puusepp', 15, 2012),
(2, 'Joosep', 'Kandik', 23, 2022),
(3, 'Janar', 'Tool', 11, 2001),
(4, 'Egert', 'Kuusk', 32, 2009),
(5, 'Einar', 'Salu', 18, 2015),
(6, 'Lauri', 'Kask', 17, 1999)

--3
update Liikmed
set Vanus = 55
where Id = 1

update Liikmed
set Perenimi = 'Otsapuu'
where Id = 2

--4
alter table Liikmed
add Kuutasu decimal(5,2)

update Liikmed
set Kuutasu = 22.99
where Id = 2

update Liikmed
set Kuutasu = 15.85
where Id = 5

update Liikmed
set Kuutasu = 39.99
where Id = 3

--5
alter table Liikmed
drop column Liitumise_aasta

--6
delete from Liikmed where Id = 4
