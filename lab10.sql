DROP DATABASE IF EXISTS `cableCompany`;
CREATE DATABASE `cableCompany`;
USE `cableCompany`;

#klientite
CREATE TABLE `cableCompany`.`customers` (
	`customerID` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
	`firstName` VARCHAR( 55 ) NOT NULL ,
	`middleName` VARCHAR( 55 ) NOT NULL ,
	`lastName` VARCHAR( 55 ) NOT NULL ,
	`email` VARCHAR( 55 ) NULL , 
	`phone` VARCHAR( 20 ) NOT NULL , 
	`address` VARCHAR( 255 ) NOT NULL ,
	PRIMARY KEY ( `customerID` )
) ENGINE = InnoDB;


#acauntite
CREATE TABLE `cableCompany`.`accounts` (
	`accountID` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY ,
	`amount` DOUBLE NOT NULL ,
	`customer_id` INT UNSIGNED NOT NULL ,
	CONSTRAINT FOREIGN KEY ( `customer_id` )
		REFERENCES `cableCompany`.`customers` ( `customerID` )
		ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB;

CREATE TABLE `cableCompany`.`plans` (
	`planID` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR(32) NOT NULL,
	`monthly_fee` DOUBLE NOT NULL
) ENGINE = InnoDB;

CREATE TABLE `cableCompany`.`payments`(
	`paymentID` INT AUTO_INCREMENT PRIMARY KEY ,
	`paymentAmount` DOUBLE NOT NULL ,
	`month` TINYINT NOT NULL ,
	`year` YEAR NOT NULL ,
	`dateOfPayment` DATETIME NOT NULL ,
	`customer_id` INT UNSIGNED NOT NULL ,
	`plan_id` INT UNSIGNED NOT NULL ,		
	CONSTRAINT FOREIGN KEY ( `customer_id` )
		REFERENCES `cableCompany`.`customers`( `customerID` ) ,
	CONSTRAINT FOREIGN KEY ( `plan_id` ) 
		REFERENCES `cableCompany`.`plans` ( `planID` ) ,
	UNIQUE KEY ( `customer_id`, `plan_id`,`month`,`year` )
)ENGINE = InnoDB;
 
 
 #dlujnici
CREATE TABLE `cableCompany`.`debtors`(
	`customer_id` INT UNSIGNED NOT NULL ,
	`plan_id` INT UNSIGNED NOT NULL ,
	`debt_amount` DOUBLE NOT NULL ,
	FOREIGN KEY ( `customer_id` )
		REFERENCES `cableCompany`.`customers`( `customerID` ) ,
	FOREIGN KEY ( `plan_id` )
		REFERENCES `cableCompany`.`plans`( `planID` ) ,
	PRIMARY KEY ( `customer_id`, `plan_id` )
) ENGINE = InnoDB;

INSERT INTO `customers` (`firstName`, `middleName`, `lastName`, `email`, `phone`, `address`) VALUES 
('John', 'Doe', 'Smith', 'johndoe@email.com', '555-1234', '123 Main St.'),
('Jane', 'Doe', 'Johnson', 'janedoe@email.com', '555-5678', '456 Oak St.');

INSERT INTO `accounts` (`amount`, `customer_id`) VALUES 
(100.00, 1),
(50.00, 2);

INSERT INTO `plans` (`name`, `monthly_fee`) VALUES 
('Basic', 29.99),
('Premium', 49.99);

INSERT INTO `payments` (`paymentAmount`, `month`, `year`, `dateOfPayment`, `customer_id`, `plan_id`) VALUES 
(29.99, 1, 2023, NOW(), 1, 1),
(49.99, 1, 2023, NOW(), 2, 2);

INSERT INTO `debtors` (`customer_id`, `plan_id`, `debt_amount`) VALUES 
(1, 1, 20.00),
(2, 2, 10.00);

#zad1.  Създайте процедура, всеки месец извършва превод от депозираната от клиента 
#сума, с който се заплаща месечната такса. Нека процедурата получава като 
#входни параметри id на клиента и сума за превод, ако преводът е успешен -
#третият изходен параметър от тип BIT да приема стойност 1, в противен случай 

drop procedure if exists transfer_money;
delimiter |
create procedure transfer_money(IN clientId int, IN money double, OUT success bit)
begin
declare account_balance double;
declare monthly_fee double;

select amount INTO account_balance 
from  accounts where customer_id = clientId;

select monthly_fee INTO monthly_fee from plans
join payments 
on plans.planID = payments.plan_id
where payments.customer_id = clientId
and payments.month = MONTH(NOW())
and payments.year = YEAR(NOW());


if account_balance>=monthly_fee then
UPDATE accounts SET amount = amount - monthly_fee WHERE customer_id = clientId;
        SET success = 1;
    ELSE
        SET success = 0;
    end IF;
 end;
 |
 delimiter ;

SET @success = 0;
CALL transfer_money(1, 29.99, @success);
SELECT @success;





#zad2 Създайте процедура, която извършва плащания в системата за потребителите, 
#депозирали суми. Ако някое плащане е неуспешно, трябва да се направи запис 
#в таблица длъжници. Използвайте трансакция и курсор


drop procedure if exists make_payments;
delimiter |
create procedure make_payments()
begin
declare finished int;
declare customer_id int;
declare depositAmount double;
declare current_balance double;
declare monthly_fee double;
declare planId int;
declare amountDebt double;
declare success int default 1;
declare cur cursor for select customerID, amount
from accounts join customers 
on accounts.customer_id = customers.customerID;
declare continue handler for not found set finished =1;
START transaction;
open cur;
read_loop:
begin
fetch cur into customer_id, depositAmount;
if finished = 1 then
leave read_loop;
else
select amount into current_balance from accounts where accounts.customer_id = customer_id;

select monthly_fee INTO monthly_fee from plans
join payments 
on plans.planID = payments.plan_id
where payments.customer_id = customer_id
and payments.month = MONTH(NOW())
and payments.year = YEAR(NOW());

select plan_id into planId from payments where customer_id = customer_id;
if current_balance >= monthly_fee then
update accounts set amount = amount - monthly_fee where customer_id = customer_id;
set success = 1;
else
set success =0;
set amountDebt = monthly_fee - current_balance;
insert into debtors(customer_id, plan_id, debt_amount)
values(customer_id, planId, amountDebt);
end if;
end if;
end read_loop;
close cur;
if success =1 then
commit;
else
rollback;
end if;
end;
|
delimiter ;

call make_payments();


#zad3 Създайте event, който се изпълнява на 28-я ден от всеки месец и извиква 
#втората процедура.

delimiter |
create event month_payment
on schedule every 1 month
STARTS CONCAT(DATE_FORMAT(NOW(), '%Y-%m-28'), ' 00:00:00')
DO
begin
call make_payments;
end;
|
delimiter ;

#zad4  Създайте VIEW, което да носи информация за трите имена на клиентите, дата 
# на подписване на договор, план, дължимите суми.


drop view if exists custInfo;
create view custInfo
AS
select concat(customers.firstName," ", customers.middleName, " ", customers.lastName) as customer, plans.name, debtors.debt_amount
from customers join debtors 
on customers.customerID = debtors.customer_id
join plans
on debtors.plan_id = plans.planID;

select * from custInfo;


#zad5 . Създайте тригер, който при добавяне на нов план, проверява дали въведената 
#такса е по-малка от 10 лева. Ако е по-малка, то добавянето се прекратява, ако 
#не, то се осъществява.

drop trigger if exists check_before_insert;
delimiter |
create trigger check_before_insert before insert on plans
for each row
begin
if(new.monthly_fee <10) then
signal sqlstate '45000' set message_text = 'Тhe fee must be at least BGN 10!';
end if;
end;
|
delimiter ;

insert into plans(name, monthly_fee)
values('Premium', 20);

insert into plans(name, monthly_fee)
values('Premium', 9);


#zad6. Създайте тригер, който при добавяне на сума в клиентска сметка проверява 
#дали сумата, която трябва да бъде добавена не е по-малка от дължимата сума.
#Ако е по-малка, то добавянето се прекратява, ако не, то се осъществява.

drop trigger if exists checkSum_before_insert;
delimiter |
create trigger checkSum_before_insert before insert on accounts
for each row
begin
declare debtAmount double;
select debt_amount into debtAmount from debtors
where customer_id = new.customer_id;

if(new.amount< debtAmount) then
signal sqlstate '45000' set message_text = 'The amount must be at least equal to the amount owed.';
end if;
end;
|
delimiter ;

insert into accounts (amount, customer_id)
values(10.50,1);



#zad7 Създайте процедура, която при подадени имена на клиент извежда всички 
#данни за клиента, както и извършените плащания

drop procedure if exists custAndPay;
delimiter |
create procedure custAndPay(IN fName varchar(200), IN lName varchar(200))
begin
declare custId int;
select customerID into custId 
from customers where firstName = fName and lastName = lName;

select* from customers
where customerID = custId;

select* from payments
where payments.customer_id = custId;
end;
|
delimiter ;

call custAndPay('John', 'Smith');


