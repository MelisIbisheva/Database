use school_sport_clubs;

#zad1

create view allInfozad1
as select coaches.name, sportgroups.location as groupInfo, sports.name as sport, salarypayments.year, salarypayments.month, salarypayments.salaryAmount
from coaches join sportgroups
on coaches.id = sportgroups.coach_id
join sports
on sports.id = sportgroups.sport_id
join salarypayments 
on salarypayments.coach_id = coaches.id;

select * from allInfozad1;


#zad2
drop table if exists salarypayments_log;
CREATE TABLE school_sport_clubs.salarypayments_log(
	id INT AUTO_INCREMENT PRIMARY KEY,
    salary_id int not null,
	old_coach_id INT NOT NULL,
	old_month TINYINT,
	old_year YEAR,
	old_salaryAmount double,
	old_dateOfPayment datetime not null
);


drop trigger if exists salarypayments_delete;

DELIMITER //

CREATE TRIGGER salarypayments_delete
AFTER DELETE ON salaryPayments
FOR EACH ROW
BEGIN
    INSERT INTO salarypayments_log(salary_id, old_coach_id, old_month, old_year, old_salaryAmount, old_dateOfPayment)
    VALUES (OLD.id, OLD.coach_id, OLD.month, OLD.year, OLD.salaryAmount, OLD.dateOfPayment);
END //

DELIMITER ;

DELETE from salarypayments
where id = 4;

select * from salarypayments;
select * from salarypayments_log;


#zad3

delete from salarypayments where id >0;

INSERT INTO salarypayments (id, coach_id, `month`, `year`, salaryAmount, dateOfPayment)
SELECT salary_id, old_coach_id, old_month, old_year, old_salaryAmount, old_dateOfPayment
FROM salarypayments_log
on duplicate key update
id = salary_id, coach_id = old_coach_id, month = old_month, year = old_year, salaryAmount = old_salaryAmount, dateOfPayment = old_dateOfPayment;

#zad4

use transaction_test;

drop procedure if exists convert_and_transfer;
delimiter |
create procedure convert_and_transfer(IN money decimal(10,2), IN fromID int, IN cunvFrom varchar(10), IN cunvTo varchar(10), IN toId int)
begin
if (cunvFrom = "BGN" and cunvTo = "BGN") then
update customer_accounts as ca
set amount = amount - money
where ca.id = fromId and ca.currency = cunvFrom;
update customer_accounts as ca
set amount = amount + money
where ca.id = toId and ca.currency = cunvTo;

elseif (cunvFrom = "BGN" and cunvTo = "EUR") then
update customer_accounts as ca
set amount = amount - money
where ca.id = fromId and ca.currency = cunvFrom;
update customer_accounts as ca
set amount = amount + money/ 1.95583
where ca.id = toId and ca.currency = cunvTo;

elseif (cunvFrom = "EUR" and cunvTo = "BGN") then
update customer_accounts as ca
set amount = amount - money
where ca.id = fromId and ca.currency = cunvFrom;
update customer_accounts as ca
set amount = amount + money * 1.95583
where ca.id = toId and ca.currency = cunvTo;
else
update customer_accounts as ca
set amount = amount - money
where ca.id = fromId and ca.currency = cunvFrom;
update customer_accounts as ca
set amount = amount + money
where ca.id = toId and ca.currency = cunvTo;
end if;

end;
|
delimiter ;

select * from customer_accounts;
call convert_and_transfer(10,1,"BGN", "EUR", 2);
select * from customer_accounts;




#zad5 
drop procedure if exists transfer_money;
delimiter |
create procedure transfer_money(IN fromId int, IN toId int, IN money decimal(10,2))
begin
declare fromCurr varchar(10);
declare toCurr varchar(10);
declare currentAmount decimal(10,2);

select currency INTO fromCurr from customer_accounts where id = fromId ;
select currency INTO toCurr from customer_accounts where id = toId;
select amount INTO currentAmount
 from customer_accounts where id = fromId;
 if currentAmount<money then
 signal sqlstate '45000' set message_text = 'Insufficient funds';
 end if;
if(fromCurr = toCurr) then
   call convert_and_transfer(money, fromId, fromCurr, toCurr, toId );
   elseif (fromCurr = "BGN" and toCurr= "EUR") or  (fromCurr = "EUR" and toCurr= "BGN")  then
    call convert_and_transfer(money, fromId, fromCurr, toCurr, toId );
    else 
    signal sqlstate '45000' set message_text = 'Invalid currency!';
end if;
end;
|
delimiter ;


select * from customer_accounts;
call transfer_money(1,3,10);
select * from customer_accounts;   
