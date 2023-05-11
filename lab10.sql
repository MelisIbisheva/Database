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
#третият изходен параметър от тип BIT да приема стойност 1, в противен случай 0

drop procedure if exists transfer_money;
delimiter |
create procedure transfer_money(in customerId int, in sum double, out result bit)
	begin
		declare curSum double;
        
		start transaction;
		
			select amount into curSum 
			from accounts
			where customer_id = customerId;
			
			if curSum < sum then 
			set result = 0;
			rollback;
            else 
            update accounts
            set amount = amount - sum
            where customer_id = customerId;
            set result = 1;
			end if;
    commit;
end |
delimiter ;

select * from accounts;

call transfer_money(1, 29.99, @res);
select @res;

select * from accounts;





#zad2 Създайте процедура, която извършва плащания в системата за потребителите, 
#депозирали суми. Ако някое плащане е неуспешно, трябва да се направи запис 
#в таблица длъжници. Използвайте трансакция и курсор


drop procedure if exists make_payments;
delimiter |
create procedure make_payments(in customerId int, in plan_id int)
	begin
		declare fee double;
        declare isThere bool default false;
		declare finished int;
        declare currCus, currPlan int;
        declare curDebts cursor for select customer_id, plan_id from debtors;
        declare continue handler for not found set finished = 1;
        set finished = 0;
		start transaction;
        
			select monthly_fee into fee from plans where planID = plan_id;
			
			if (select amount from accounts where customer_id = customerId) >= fee then
            update accounts
            set amount = amount - fee
            where customer_id = customerId;
            else
				open curDebts;
				getRecords: loop
					fetch curDebts into currCus, CurrPlan;
                    if finished = 1 then leave getRecords;
                    end if;
                    if currCus = customerId and currPlan = plan_id then set isThere = true;
                    update debtors
                    set debt_amount = debt_amount + fee
                    where currCus = customer_id and currPlan = plan_id;
                    end if;
                end loop getRecords;
                
                if isThere = false then 
                insert into debtors(customer_id, plan_id, debt_amount)
                values(customerId, plan_id, fee);
                end if;
			end if;
		commit;
end |
delimiter ;

call make_payments(1, 1);
call make_payments(2, 2);
select * from customers;
select * from accounts;
select * from plans;
select * from debtors;


#zad3 Създайте event, който се изпълнява на 28-я ден от всеки месец и извиква 
#втората процедура.

delimiter |
create event month_payment
on schedule every 1 month
STARTS CONCAT(DATE_FORMAT(NOW(), '%Y-%m-28'), ' 00:00:00')
DO
begin
call make_payments(1, 1);
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


