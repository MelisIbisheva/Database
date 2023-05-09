drop database if exists clubs_sports;
create database clubs_sports;
use clubs_sports;

CREATE TABLE clubs_sports.sports(
	id INT AUTO_INCREMENT PRIMARY KEY ,
	name VARCHAR(255) NOT NULL
);

CREATE TABLE clubs_sports.coaches(
	id INT AUTO_INCREMENT PRIMARY KEY ,
	name VARCHAR(255) NOT NULL ,
	egn VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE clubs_sports.students(
	id INT AUTO_INCREMENT PRIMARY KEY ,
	name VARCHAR(255) NOT NULL ,
	egn VARCHAR(10) NOT NULL UNIQUE ,
	address VARCHAR(255) NOT NULL ,
	phone VARCHAR(20) NULL DEFAULT NULL ,
	class VARCHAR(10) NULL DEFAULT NULL   
);

CREATE TABLE clubs_sports.sportGroups(
	id INT AUTO_INCREMENT PRIMARY KEY ,
	location VARCHAR(255) NOT NULL ,
	dayOfWeek ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') ,
	hourOfTraining TIME NOT NULL ,
	sport_id INT NULL ,
	coach_id INT NULL ,
	UNIQUE KEY(location,dayOfWeek,hourOfTraining)  ,
	CONSTRAINT FOREIGN KEY(sport_id) 
		REFERENCES sports(id) ,
	CONSTRAINT FOREIGN KEY (coach_id) 
		REFERENCES coaches(id)
);

CREATE TABLE clubs_sports.student_sport(
	student_id INT NOT NULL , 
	sportGroup_id INT NOT NULL ,  
	CONSTRAINT FOREIGN KEY (student_id) 
		REFERENCES students(id) ,	
	CONSTRAINT FOREIGN KEY (sportGroup_id) 
		REFERENCES sportGroups(id) ,
	PRIMARY KEY(student_id,sportGroup_id)
);

CREATE TABLE taxesPayments(
	id INT AUTO_INCREMENT PRIMARY KEY,
	student_id INT NOT NULL,
	group_id INT NOT NULL,
	paymentAmount DOUBLE NOT NULL,
	month TINYINT,
	year YEAR,
	dateOfPayment DATETIME NOT NULL ,
	CONSTRAINT FOREIGN KEY (student_id) 
		REFERENCES students(id),
	CONSTRAINT FOREIGN KEY (group_id) 
		REFERENCES sportgroups(id)
);

CREATE TABLE salaryPayments(
	id INT AUTO_INCREMENT PRIMARY KEY,
	coach_id INT NOT NULL,
	month TINYINT,
	year YEAR,
	salaryAmount double,
	dateOfPayment datetime not null,
	CONSTRAINT FOREIGN KEY (coach_id) 
		REFERENCES coaches(id),
	UNIQUE KEY(`coach_id`,`month`,`year`)
);

INSERT INTO sports
VALUES 	(NULL, 'Football') ,
		(NULL, 'Volleyball') ,
		(NULL, 'Tennis') ,
		(NULL, 'Karate') ,
		(NULL, 'Taekwon-do');
		
INSERT INTO coaches  
VALUES 	(NULL, 'Ivan Todorov Petkov', '7509041245') ,
		(NULL, 'georgi Ivanov Todorov', '8010091245') ,
		(NULL, 'Ilian Todorov Georgiev', '8407106352') ,
		(NULL, 'Petar Slavkov Yordanov', '7010102045') ,
		(NULL, 'Todor Ivanov Ivanov', '8302160980') , 
		(NULL, 'Slavi Petkov Petkov', '7106041278');
		
INSERT INTO students (name, egn, address, phone, class) 
VALUES 	('Iliyan Ivanov', '9401150045', 'Sofia-Mladost 1', '0893452120', '10') ,
		('Ivan Iliev Georgiev', '9510104512', 'Sofia-Liylin', '0894123456', '11') ,
		('Elena Petrova Petrova', '9505052154', 'Sofia-Mladost 3', '0897852412', '11') ,
		('Ivan Iliev Iliev', '9510104542', 'Sofia-Mladost 3', '0894123457', '11') ,
		('Maria Hristova Dimova', '9510104547', 'Sofia-Mladost 4', '0894123442', '11') ,
		('Antoaneta Ivanova Georgieva', '9411104547', 'Sofia-Krasno selo', '0874526235', '10');
		
INSERT INTO sportGroups
VALUES 	(NULL, 'Sofia-Mladost 1', 'Monday', '08:00:00', 1, 1 ) ,
		(NULL, 'Sofia-Mladost 1', 'Monday', '09:30:00', 1, 2 ) ,
		(NULL, 'Sofia-Liylin 7', 'Sunday', '08:00:00', 2, 1) ,
		(NULL, 'Sofia-Liylin 2', 'Sunday', '09:30:00', 2, 2) ,	
		(NULL, 'Sofia-Liylin 3', 'Tuesday', '09:00:00', NULL, NULL) ,			
		(NULL, 'Plovdiv', 'Monday', '12:00:00', '1', '1');
		
INSERT INTO student_sport 
VALUES 	(1, 1),
		(2, 1),
		(3, 1),
		(4, 2),
		(5, 2),
		(6, 2),
		(1, 3),
		(2, 3),
		(3, 3);
		
INSERT INTO `school_sport_clubs`.`taxespayments` 
VALUES	(NULL, '1', '1', '200', '1', 2022, now()),
		(NULL, '1', '1', '200', '2', 2022, now()),
		(NULL, '1', '1', '200', '3', 2022, now()),
		(NULL, '1', '1', '200', '4', 2022, now()),
		(NULL, '1', '1', '200', '5', 2022, now()),
		(NULL, '1', '1', '200', '6', 2022, now()),
		(NULL, '1', '1', '200', '7', 2022, now()),
		(NULL, '1', '1', '200', '8', 2022, now()),
		(NULL, '1', '1', '200', '9', 2022, now()),
		(NULL, '1', '1', '200', '10', 2022, now()),
		(NULL, '1', '1', '200', '11', 2022, now()),
		(NULL, '1', '1', '200', '12', 2022, now()),
		(NULL, '2', '1', '250', '1', 2022, now()),
		(NULL, '2', '1', '250', '2', 2022, now()),
		(NULL, '2', '1', '250', '3', 2022, now()),
		(NULL, '2', '1', '250', '4', 2022, now()),
		(NULL, '2', '1', '250', '5', 2022, now()),
		(NULL, '2', '1', '250', '6', 2022, now()),
		(NULL, '2', '1', '250', '7', 2022, now()),
		(NULL, '2', '1', '250', '8', 2022, now()),
		(NULL, '2', '1', '250', '9', 2022, now()),
		(NULL, '2', '1', '250', '10', 2022, now()),
		(NULL, '2', '1', '250', '11', 2022, now()),
		(NULL, '2', '1', '250', '12', 2022, now()),
		(NULL, '3', '1', '250', '1', 2022, now()),
		(NULL, '3', '1', '250', '2', 2022, now()),
		(NULL, '3', '1', '250', '3', 2022, now()),
		(NULL, '3', '1', '250', '4', 2022, now()),
		(NULL, '3', '1', '250', '5', 2022, now()),
		(NULL, '3', '1', '250', '6', 2022, now()),
		(NULL, '3', '1', '250', '7', 2022, now()),
		(NULL, '3', '1', '250', '8', 2022, now()),
		(NULL, '3', '1', '250', '9', 2022, now()),
		(NULL, '3', '1', '250', '10', 2022, now()),
		(NULL, '3', '1', '250', '11', 2022, now()),
		(NULL, '3', '1', '250', '12', 2022, now()),
		(NULL, '1', '2', '200', '1', 2022, now()),
		(NULL, '1', '2', '200', '2', 2022, now()),
		(NULL, '1', '2', '200', '3', 2022, now()),
		(NULL, '1', '2', '200', '4', 2022, now()),
		(NULL, '1', '2', '200', '5', 2022, now()),
		(NULL, '1', '2', '200', '6', 2022, now()),
		(NULL, '1', '2', '200', '7', 2022, now()),
		(NULL, '1', '2', '200', '8', 2022, now()),
		(NULL, '1', '2', '200', '9', 2022, now()),
		(NULL, '1', '2', '200', '10', 2022, now()),
		(NULL, '1', '2', '200', '11', 2022, now()),
		(NULL, '1', '2', '200', '12', 2022, now()),
		(NULL, '4', '2', '200', '1', 2022, now()),
		(NULL, '4', '2', '200', '2', 2022, now()),
		(NULL, '4', '2', '200', '3', 2022, now()),
		(NULL, '4', '2', '200', '4', 2022, now()),
		(NULL, '4', '2', '200', '5', 2022, now()),
		(NULL, '4', '2', '200', '6', 2022, now()),
		(NULL, '4', '2', '200', '7', 2022, now()),
		(NULL, '4', '2', '200', '8', 2022, now()),
		(NULL, '4', '2', '200', '9', 2022, now()),
		(NULL, '4', '2', '200', '10', 2022, now()),
		(NULL, '4', '2', '200', '11', 2022, now()),
		(NULL, '4', '2', '200', '12', 2022, now()),
		/**2021**/
		(NULL, '1', '1', '200', '1', 2021, now()),
		(NULL, '1', '1', '200', '2', 2021, now()),
		(NULL, '1', '1', '200', '3', 2021, now()),
		(NULL, '1', '1', '200', '4', 2021, now()),
		(NULL, '1', '1', '200', '5', 2021, now()),
		(NULL, '1', '1', '200', '6', 2021, now()),
		(NULL, '1', '1', '200', '7', 2021, now()),
		(NULL, '1', '1', '200', '8', 2021, now()),
		(NULL, '1', '1', '200', '9', 2021, now()),
		(NULL, '1', '1', '200', '10', 2021, now()),
		(NULL, '1', '1', '200', '11', 2021, now()),
		(NULL, '1', '1', '200', '12', 2021, now()),
		(NULL, '2', '1', '250', '1', 2021, now()),
		(NULL, '2', '1', '250', '2', 2021, now()),
		(NULL, '2', '1', '250', '3', 2021, now()),
		(NULL, '2', '1', '250', '4', 2021, now()),
		(NULL, '2', '1', '250', '5', 2021, now()),
		(NULL, '2', '1', '250', '6', 2021, now()),
		(NULL, '2', '1', '250', '7', 2021, now()),
		(NULL, '2', '1', '250', '8', 2021, now()),
		(NULL, '2', '1', '250', '9', 2021, now()),
		(NULL, '2', '1', '250', '10', 2021, now()),
		(NULL, '2', '1', '250', '11', 2021, now()),
		(NULL, '2', '1', '250', '12', 2021, now()),
		(NULL, '3', '1', '250', '1', 2021, now()),
		(NULL, '3', '1', '250', '2', 2021, now()),
		(NULL, '3', '1', '250', '3', 2021, now()),
		(NULL, '3', '1', '250', '4', 2021, now()),
		(NULL, '3', '1', '250', '5', 2021, now()),
		(NULL, '3', '1', '250', '6', 2021, now()),
		(NULL, '3', '1', '250', '7', 2021, now()),
		(NULL, '3', '1', '250', '8', 2021, now()),
		(NULL, '3', '1', '250', '9', 2021, now()),
		(NULL, '3', '1', '250', '10', 2021, now()),
		(NULL, '3', '1', '250', '11', 2021, now()),
		(NULL, '3', '1', '250', '12', 2021, now()),
		(NULL, '1', '2', '200', '1', 2021, now()),
		(NULL, '1', '2', '200', '2', 2021, now()),
		(NULL, '1', '2', '200', '3', 2021, now()),
		(NULL, '1', '2', '200', '4', 2021, now()),
		(NULL, '1', '2', '200', '5', 2021, now()),
		(NULL, '1', '2', '200', '6', 2021, now()),
		(NULL, '1', '2', '200', '7', 2021, now()),
		(NULL, '1', '2', '200', '8', 2021, now()),
		(NULL, '1', '2', '200', '9', 2021, now()),
		(NULL, '1', '2', '200', '10', 2021, now()),
		(NULL, '1', '2', '200', '11', 2021, now()),
		(NULL, '1', '2', '200', '12', 2021, now()),
		(NULL, '4', '2', '200', '1', 2021, now()),
		(NULL, '4', '2', '200', '2', 2021, now()),
		(NULL, '4', '2', '200', '3', 2021, now()),
		(NULL, '4', '2', '200', '4', 2021, now()),
		(NULL, '4', '2', '200', '5', 2021, now()),
		(NULL, '4', '2', '200', '6', 2021, now()),
		(NULL, '4', '2', '200', '7', 2021, now()),
		(NULL, '4', '2', '200', '8', 2021, now()),
		(NULL, '4', '2', '200', '9', 2021, now()),
		(NULL, '4', '2', '200', '10', 2021, now()),
		(NULL, '4', '2', '200', '11', 2021, now()),
		(NULL, '4', '2', '200', '12', 2021, now()),
		/**2020**/
		(NULL, '1', '1', '200', '1', 2020, now()),
		(NULL, '1', '1', '200', '2', 2020, now()),
		(NULL, '1', '1', '200', '3', 2020, now()),
		(NULL, '2', '1', '250', '1', 2020, now()),
		(NULL, '3', '1', '250', '1', 2020, now()),
		(NULL, '3', '1', '250', '2', 2020, now()),
		(NULL, '1', '2', '200', '1', 2020, now()),
		(NULL, '1', '2', '200', '2', 2020, now()),
		(NULL, '1', '2', '200', '3', 2020, now()),
		(NULL, '4', '2', '200', '1', 2020, now()),
		(NULL, '4', '2', '200', '2', 2020, now());
        
SELECT id, name,egn,address,phone,class
FROM students;

SELECT sportgroups.location,
sportgroups.dayOfWeek,
sportgroups.hourOfTraining,
sportgroups.dayOfWeek,
sports.name
FROM sportgroups JOIN sports
ON sportgroups.sport_id = sports.id;


SELECT students.name, students.class, sportgroups.id
 FROM students JOIN sportgroups
 ON students.id IN (
	SELECT student_id
	FROM student_sport
	WHERE student_sport.sportGroup_id = sportgroups.id
 )
 WHERE sportgroups.id IN(
	SELECT sportgroup_id
    FROM student_sport
    WHERE sportGroup_id IN(
		SELECT id
		FROM sportgroups
		WHERE dayOfWeek = 'Monday'
		AND hourOfTraining = '08:00:00'
		AND coach_id IN(
			SELECT id
			FROM coaches
			WHERE name = 'Иван Тодоров Петров'
		)
        AND sport_id =(
			SELECT id
			FROM sports
            WHERE name = 'Football'
		)
    )
 );
 -- zad 1 --
 
 insert into students(name, egn, address, phone, class)
 values ("Ivan Ivanov Ivanov", "9307186371", "София-Сердика","0888892950", "10");
 
 -- zad 2 --
 
 select *
 from students
 order by name;
 
 -- zad3 --
 
 delete from students
 where egn ='9307186371';
 
 -- zad4 --
 
 select students.name, sports.name
 from students join sportgroups
 on students.id in(
 select student_sport.student_id
 from student_sport
 where student_sport.sportGroup_id=sportgroups.id)
 join sports
 on sports.id = sportgroups.sport_id;
 
 
-- zad 4 variant 2

select students.name, sports.name
from students join student_sport 
on students.id=student_sport.student_id
join sportgroups 
on student_sport.sportGroup_id=sportgroups.id
join sports
on sportgroups.sport_id=sports.id;

-- zad 5

select students.name, students.class, sg.id
from students join student_sport as sp
on students.id=sp.student_id
join sportgroups as sg
on sp.sportGroup_id=sg.id
where sg.dayOfWeek = 'Sunday';

-- zad 6 --
select coaches.name, sports.name as sport
from coaches join sportgroups
on coaches.id=sportgroups.coach_id
join sports
on sports.id = sportgroups.sport_id
where sports.name='Football';

-- zad 7--
select sportgroups.location, sportgroups.hourOfTraining, sportgroups.dayOfWeek
from sportgroups 
where sportgroups.sport_id in(
select sports.id
from sports
where sports.name = 'Volleyball');

-- zad 8 --
select sports.name
from sports join sportgroups
on sports.id = sportgroups.sport_id
join student_sport
on student_sport.student_id in(
select students.id
from students
where students.name = "Iliyan Ivanov")
where student_sport.sportGroup_id=sportgroups.id;


-- zad 9 --
select distinct students.name
from students join student_sport
on students.id = student_sport.student_id
join sportgroups
on student_sport.sportGroup_id = sportgroups.id
where sportgroups.coach_id in(
select coaches.id
from coaches
where coaches.name = "Ivan Todorov Petkov");

-- zad 10 --
select students.name, sum(taxespayments.paymentAmount) as pay_year, taxespayments.year
from taxespayments join students
on taxespayments.student_id = students.id
group by year, student_id;

----------------------------------- Drugi zadachi------------------------------------------------------------------------------------------------------
-- zad 1

select students.name, students.class, students.phone
from students join student_sport
on students.id = student_sport.student_id
where student_sport.sportGroup_id in(
select sportgroups.id
from sportgroups
where sport_id in(select sports.id
from sports
where sports.name = "football"));

-- zad 2 --
select coaches.name
from coaches join sportgroups
on coaches.id = sportgroups.coach_id
join sports
on sports.id = sportgroups.sport_id
where sports.name = "Volleyball";

-- zad 3 --
select coaches.name as coach, sports.name as sport
from coaches join sportgroups
on coaches.id = sportgroups.coach_id
join sports
on sports.id = sportgroups.sport_id
where sportgroups.id in(
select student_sport.sportGroup_id
from student_sport
where student_sport.student_id in(
select students.id
from students
where students.name = "Iliyan Ivanov"));

-- zad 4 --
select sum(taxespayments.paymentAmount) as SumOfAllPymentPerGroup
from taxespayments 
join sportgroups on sportgroups.id = taxespayments.group_id
join coaches on coaches.id=sportgroups.coach_id
where coaches.egn = '7509041245'
group by month
having SumOfAllPymentPerGroup > 700;

-- zad 5 --
select count(student_id) as countStudentsInGroup
from students join student_sport
on students.id = student_sport.student_id
group by student_sport.sportGroup_id;

-- zad 6 --



