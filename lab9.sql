use school_sport_clubs;

#zad1 Създайте тригер, който при изтриване на информация от таблицата 
#salarypayments записва изтритата информация в таблицата 
#salarypayments_log.


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


#zad2 Изтрийте цялата информация от таблицата salarypayments и напишете 
#заявка, с която я възстановявате от таблицата salarypayments_log .


delete from salarypayments where id>0;

INSERT INTO salarypayments (id, coach_id, `month`, `year`, salaryAmount, dateOfPayment)
SELECT salary_id, old_coach_id, old_month, old_year, old_salaryAmount, old_dateOfPayment
FROM salarypayments_log
on duplicate key update
id = salary_id, coach_id = old_coach_id, month = old_month, year = old_year, salaryAmount = old_salaryAmount, dateOfPayment = old_dateOfPayment;


#zad3 Съгласно въведено ограничение всеки ученик може да тренира в не 
#повече от 2 групи. Напишете тригер, правещ съответната проверка при 
#добавяне, който при необходимост да извежда съобщение за 
#проблема.


drop trigger if exists check_countOfGroups;

delimiter |
create trigger check_countOfGroups before insert on student_sport
for each row
begin
DECLARE group_count int;
select count(sportGroup_id) into group_count from student_sport
where student_id = new.student_id;
if(group_count>=2) then
signal sqlstate '45000' set message_text = 'Error!';
end if;
end;
|
delimiter ;

INSERT INTO student_sport (student_id, sportGroup_id)
VALUES (2, 2);

select * from student_sport;

#zad4 Създайте VIEW, което да носи информация за трите имена на 
#учениците и броя на групите, в които тренират.

drop view if exists students_info;
create view students_info
AS
select students.name as studentName, count(student_sport.sportGroup_id) as countGroups
from students join student_sport
where students.id= student_sport.student_id
group by studentName;

select * from students_info;

#5Напишете процедура, с която по подадено име на спорт се извеждат 
#имената на треньорите, които водят съответните групи, мястото, часът 
#и денят на тренировка.

drop procedure if exists sportInfo;
delimiter |
create procedure sportInfo(IN nameSport varchar(200))
begin
declare sportId int;
select id into sportId from sports
where sports.name = nameSport;

select coaches.name, sp.location, sp.hourOfTraining, sp.dayOfWeek
from coaches join sportgroups as sp
on coaches.id =sp.coach_id
where sp.sport_id = sportID;
end;
|
delimiter ;

call sportInfo('Football');



