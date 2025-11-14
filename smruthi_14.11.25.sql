create database supplierdb;
use supplierdb;

create table supplier (
  sid varchar(5) primary key,
  sname varchar(50),
  city varchar(50)
);

create table parts (
  pid varchar(5) primary key,
  pname varchar(50),
  color varchar(20)
);

create table catalog (
  sid varchar(5),
  pid varchar(5),
  cost decimal(10,2),
  primary key (sid, pid),
  foreign key (sid) references supplier(sid),
  foreign key (pid) references parts(pid)
);

insert into supplier values
('s1', 'acme widget suppliers', 'new york'),
('s2', 'global parts ltd', 'london'),
('s3', 'zenith components', 'tokyo'),
('s4', 'universal supplies', 'delhi'),
('s5', 'prime industries', 'berlin');

insert into parts values
('p1', 'bolt', 'red'),
('p2', 'nut', 'blue'),
('p3', 'screw', 'green'),
('p4', 'washer', 'red'),
('p5', 'gear', 'black');

insert into catalog values
('s1', 'p1', 120.00),
('s1', 'p2', 150.00),
('s2', 'p1', 130.00),
('s2', 'p3', 100.00),
('s3', 'p4', 140.00),
('s3', 'p5', 200.00),
('s4', 'p2', 160.00),
('s4', 'p3', 110.00),
('s5', 'p1', 125.00),
('s5', 'p5', 220.00);

select* from supplier;

select* from parts;

select* from catalog; 


select distinct p.pname
from parts p, catalog c
where p.pid = c.pid;

select s.sname
from supplier s
where not exists (
  select *
  from parts p
  where not exists (
    select *
    from catalog c
    where c.sid = s.sid
    and c.pid = p.pid
  )
);

select p.pname
from parts p, catalog c, supplier s
where s.sid = c.sid
and c.pid = p.pid
and s.sname = 'acme widget suppliers'
and p.pid not in (
  select c2.pid
  from catalog c2, supplier s2
  where c2.sid = s2.sid
  and s2.sname <> 'acme widget suppliers'
);

select distinct c1.sid
from catalog c1
where c1.cost > (
  select avg(c2.cost)
  from catalog c2
  where c2.pid = c1.pid
);

select p.pname, s.sname
from supplier s, catalog c, parts p
where s.sid = c.sid
and p.pid = c.pid
and c.cost = (
  select max(c2.cost)
  from catalog c2
  where c2.pid = p.pid
);
