use mysql;
create user 'smruthi' identified by 'smruthip';
grant all privileges on *.* to 'smruthi';
flush privileges;

show databases;
create database insurance_database;
use  insurance_database;

create table person(driver_id varchar(10),
name varchar(20),
address varchar(30),
primary key(driver_id));

create table car(reg_num varchar(10),
model varchar(10),
year int,
primary key(reg_num));

create table accident(report_num int, accident_date date, location varchar(20), primary key(report_num));

create table owns(driver_id varchar(10), reg_num varchar(10), 
primary key(driver_id, reg_num),
foreign key(driver_id) references person(driver_id),
foreign key(reg_num) references car(reg_num));

create table participated(driver_id varchar(10), reg_num varchar(10), report_num int, damage_amount int,
primary key(driver_id, reg_num, report_num),
foreign key(driver_id) references person(driver_id),
foreign key(report_num) references accident(report_num));

 
  insert into person values
  ('A01','Richard','Srinivas Nagar'), 
  ('A02','Anthony','Malleshwaram'),
  ('A03','Shipra','Vasanth Nagar'),
  ('A04','Riya','UB city'),
  ('A05','Nitesh','Hosahalli');
 
  insert into car values
  ('KA052250','Indica', 2008),
  ('KA034560','Honda', 2010),
  ('KA045678','Mecedes', 2023),
  ('KA042690','Maruthi', 2011),
  ('KA019650','Mahindra', 2020);
  
  insert into accident values
  (11,'2003-02-24','Mysore Road'),
  (12,'2004-02-02', 'Southend Circle'),
  (13,'2003-03-27', 'Bulltemple Road'),
  (14,'2006-02-17','Mysore Road'),
  (15,'2020-04-07','Kanakpura Road');
  
  insert into owns values
  ('A01','KA052250'),
  ('A02','KA034560'),
  ('A03','KA045678'),
  ('A04','KA042690'),
  ('A05','KA019650');
  
  
   insert into participated values
   ('A01','KA052250',11,10000),
   ('A02','KA034560',12,200000), 
   ('A03','KA045678',13,350000),
   ('A04','KA042690',14, 450000),
   ('A05','KA019650',15, 60000);
   
    select accident_date, location
    from accident;
   
    select p.name 
    from person p, participated pd
	where p.driver_id=pd.driver_id and pd.damage_amount>25000;
 
	select p.name, c.model
    from person p, car c, owns o
    where p.driver_id=o.driver_id and c.reg_num=o.reg_num;
    
    select p.name, a.accident_date, a.location, pd.damage_amount
    from person p, accident a, participated pd
    where p.driver_id=pd.driver_id and a.report_num=pd.report_num;
    
    select p.name
    from person p, participated pd
    where p.driver_id=pd.driver_id
    group by pd.driver_id
    having count(*)>1;

	select o.reg_num
	from owns o
	where o.reg_num not in(select pd.reg_num
                         from participated pd);
                         
	select*
	from accident 
	where accident_date>=all(select accident_date from accident);

	select p.name, avg(pd.damage_amount) as Avg_damage_amt
	from person p, participated pd
	where p.driver_id=pd.driver_id
	group by pd.driver_id;

	update participated
	set damage_amount=25000
	where driver_id='A05';

	select*from participated;

	select pd.driver_id, p.p.name, pd.damage_amount
	from person p, participated pd
	where p.driver_id=pd.driver_id and pd.damage_amount>=ALL(select damage_amount from participated);
    
    select model
	from car c,participated pd
	where c.reg_num=pd.reg_num
	group by pd.reg_num
	having sum(pd.damage_amount)>20000;
    
    create view summary_accidents as select 
    a.report_num as Acc_ReportNum,
    a.location as Acc_Location,
    a.accident_date as Acc_date,
    COUNT(p.driver_id) AS NumberOfParticipants,
    SUM(p.damage_amount) AS TotalDamage
	from accident as a,participated as p
	where a.report_num=p.report_num
	group by a.report_num;                              
                                                             
    select * from summary_accidents;
    
    

 







