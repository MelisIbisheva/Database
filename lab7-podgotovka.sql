use school_sport_clubs;
# zad1
drop procedure zadacha1;

delimiter |
create procedure zadacha1(IN coach_name varchar(200))
begin
select sports.name as sport, sportgroups.location, sportgroups.dayOfWeek, sportgroups.hourOfTraining, students.name as student, students.phone
from sportgroups join sports 
on sportgroups.sport_id = sports.id 
join coaches
on sportgroups.coach_id = coaches.id
join student_sport
on sportgroups.id = student_sport.sportGroup_id
join students
on students.id = student_sport.student_id
where coaches.name = coach_name;
end;
|
delimiter ;

call zadacha1("Ivan Todorov Petkov");
call zadacha1("georgi Ivanov Todorov");


#zad2 

delimiter |
create procedure zadacha2(IN sId int)
begin 
select sports.name as sport, students.name as student, coaches.name as coach
from sports join sportgroups
on sports.id= sportgroups.sport_id
join coaches 
on coaches.id = sportgroups.coach_id
join student_sport 
on student_sport.sportGroup_id = sportgroups.id
join students 
on students.id = student_sport.student_id
where sports.id = sId;
end;
|
delimiter ;

call zadacha2(1);

#zad3

delimiter |
create procedure zadacha3(IN student_name varchar(255), IN ye year)
begin 
select avg(taxespayments.paymentAmount) as allmoney
from taxespayments join students
on taxespayments.student_id = students.id
where students.name = student_name
and taxespayments.year = ye;
end;
|
delimiter ;

call zadacha3('Iliyan Ivanov', '2022');


# create database transaction_test



create database if not exists transaction_test;
use transaction_test;

drop table if exists customer_accounts;

drop table if exists customers;
create table customers(
id int auto_increment primary key,
name varchar(255) not null,
address varchar(255)
);



create table if not exists customer_accounts(
id int  auto_increment primary key,
amount double not null,
currency varchar(10),
customer_id int not null,
constraint foreign key  (customer_id) references customers(id) on delete restrict on update cascade
);

INSERT INTO `transaction_test`.`customers` (`name`, `address`) VALUES ('Ivan Petrov Iordanov', 'Sofia, Krasno selo 1000');
INSERT INTO `transaction_test`.`customers` (`name`, `address`) VALUES ('Stoyan Pavlov Pavlov', 'Sofia, Liuylin 7, bl. 34');
INSERT INTO `transaction_test`.`customers` (`name`, `address`) VALUES ('Iliya Mladenov Mladenov', 'Sofia, Nadezhda 2, bl 33');

INSERT INTO `transaction_test`.`customer_accounts` (`amount`, `currency`, `customer_id`) VALUES ('5000', 'BGN', '1');
INSERT INTO `transaction_test`.`customer_accounts` (`amount`, `currency`, `customer_id`) VALUES ('10850', 'EUR', '1');
INSERT INTO `transaction_test`.`customer_accounts` (`amount`, `currency`, `customer_id`) VALUES ('1450000', 'BGN', '2');
INSERT INTO `transaction_test`.`customer_accounts` (`amount`, `currency`, `customer_id`) VALUES ('17850', 'EUR', '2');


#zad4 transaction

use transaction_test;

delimiter |
create procedure zadacha4(IN sendId int, IN recId int, IN money decimal)
begin
declare currentBalance decimal;

start transaction;
select amount INTO currentBalance
from customer_accounts
where id = sendId;
if currentBalance < money 
then 
signal SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient funds';
end if;

update customer_accounts
set amount = amount - money
where id = sendId;

if row_count() = 0
then
signal SQLSTATE '45000' SET MESSAGE_TEXT = 'Transfer failed';
end if;

update customer_accounts
set amount = amount + money
where id = recId;
if row_count() = 0
then
signal SQLSTATE '45000' SET MESSAGE_TEXT = 'Transfer failed';
end if;
commit;
end;
|
delimiter ;

select * from customer_accounts;
call zadacha4(1,4,500);
select * from customer_accounts;


