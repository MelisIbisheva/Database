drop database if exists bug_tracker;
create database bug_tracker;
use bug_tracker;

create table error(
id int primary key auto_increment,
steps_to_reproduce text not null,
operating_system varchar(200) not null,
logs text not null
);

create table qa(
id int primary key auto_increment,
name varchar(200) not null
);

create table developer(
id int primary key auto_increment,
name varchar(200) not null
);

create table bug(
id int primary key auto_increment,
logged_datetime datetime not null,
priority ENUM('minor', 'medium', 'major', 'critical'),
status ENUM('new', 'addressed', 'failed', 'closed'),
error_id int not null,
qa_id int not null,
dev_id int not null,
constraint foreign key(error_id) references error(id),
constraint foreign key(qa_id) references qa(id),
constraint foreign key(dev_id) references developer(id)
);

create table project(
id int primary key auto_increment,
manager_name varchar(200) not null,
owner_id int not null,
constraint foreign key(owner_id) references developer(id),
description text not null
);

create table project_dev(
project_id int not null,
dev_id int not null,
constraint foreign key(project_id)references project(id),
constraint foreign key(dev_id)references developer(id),
primary key(project_id, dev_id)
);

create table project_qa(
project_id int not null,
qa_id int not null,
constraint foreign key(project_id)references project(id),
constraint foreign key(qa_id)references qa(id),
primary key(project_id, qa_id)
);


create table bug_project(
bug_id int not null,
project_id int not null,
constraint foreign key(bug_id)references bug(id),
constraint foreign key(project_id)references project(id),
primary key(bug_id, project_id)
);


INSERT INTO error (steps_to_reproduce, operating_system, logs)
VALUES
('Open the app and click the "Log in" button. Enter a valid username and password, and click "Submit".', 'Windows 10', 'Error message: "Authentication failed. Please try again."'),
('Navigate to the "Settings" page and click the "Save" button. Change the value of the "Dark Mode" option and click "Save".', 'macOS', 'Error message: "Unable to save settings. Please try again later."'),
('Click the "Send" button on the chat screen. Enter a message and click "Send". Wait for a response.', 'iOS 15', 'Error message: "Unable to connect to server. Please check your internet connection."'),
('Open the application.Click the "Settings" button.Click the "Save" button without changing any settings.', 'Windows 10', 'Error message: Settings not saved.'),
('Open the application.Click the "Logout" button.Click the "Cancel" button on the confirmation dialog.', 'macOS Mojave', 'Error message: Logout failed.');

select *
from error;

INSERT INTO qa (name) VALUES
('John Smith'),
('Jane Doe'),
('Bob Johnson'),
('Mary Chen'),
('David Kim');

select *
from qa;

INSERT INTO developer (name) VALUES
('Alice Lee'),
('Tom Brown'),
('Emily Davis'),
('Adam Smith'),
('Alex Brown');

INSERT INTO developer (name) VALUES
('Bob Grey'),
('Lilly Milar');

select *
from developer;

INSERT INTO bug (logged_datetime, priority, status, error_id, qa_id, dev_id)
VALUES
('2023-03-24 12:00:00', 'major', 'new', 4, 1, 3),
('2023-03-26 11:00:00', 'critical', 'addressed', 1, 5, 1),
('2023-03-27 17:00:00', 'medium', 'new', 5, 2, 1),
('2023-04-24 11:00:00', 'critical', 'failed', 1, 4, 4),
('2023-04-26 16:00:00', 'medium', 'closed', 2, 2, 5),
('2023-04-27 14:00:00', 'minor', 'new', 3, 3, 2),
('2023-04-28 11:30:00', 'critical', 'failed', 1, 4, 4),
('2023-04-29 14:30:00', 'medium', 'closed', 4, 1, 2),
('2023-04-30 15:00:00', 'minor', 'new', 3, 5, 5);

select *
from bug;

INSERT INTO project (manager_name, owner_id, description)
VALUES
('Elena Wilson', 2, 'Develop a new feature for the mobile app.'),
('Chris Lee', 1, 'Fix bugs and improve performance for the website.'),
('Helen Wang', 3, 'Create a new landing page for the product.');

select *
from project;

INSERT INTO project_dev (project_id, dev_id)
VALUES
(1, 1),
(1, 2),
(1, 4),
(2, 2),
(2, 3),
(2, 4),
(3, 1),
(3, 3),
(3, 5);

select *
from project_dev;

INSERT INTO project_qa (project_id, qa_id)
VALUES
(1, 1),
(1, 2),
(1, 4),
(2, 2),
(2, 3),
(2, 4),
(3, 1),
(3, 3),
(3, 5);

select *
from project_qa;

INSERT INTO bug_project (bug_id, project_id)
VALUES
(1, 1),
(2, 2),
(3, 2),
(4, 3),
(4, 1),
(9, 3),
(7, 3),
(1, 2),
(5, 3),
(6, 1),
(8, 2);

select *
from bug_project;

#2. Напишете заявка, в която демонстрирате SELECT с ограничаващо условие  по избор
# извеждаме информация за всички проблеми, които възникват, когато операционната система е Windows 10.

select * from error 
where operating_system = 'Windows 10';

#3. Напишете заявка, в която използвате агрегатна функция и GROUP BY по  ваш избор 
# ще изведе броя на бъговете, които са назначени на всеки програмист. Резултатът е сортиран в низходящ ред.

select dev.name as dev_name, COUNT(*) AS count_bugs
from bug
join developer as dev ON dev.id = bug.dev_id
group by dev.name
order by count_bugs desc;


#4. Напишете заявка, в която демонстрирате INNER JOIN по ваш избор
#извеждаме информация за проектите и съответно името на програмиста, който е owner на даден проект. Информацията се съхранява в таблиците Project и Developer.

select project.id,
project.manager_name, 
developer.name as owner_name, 
project.description
from project join developer
on project.owner_id = developer.id;


#5. Напишете заявка, в която демонстрирате OUTER JOIN по ваш избор 
# Извеждаме информация за бъговете и програмистите, които трябва да ги оправят. Информацията се съхранява в таблиците Bug и Developer .
# За свързването използваме RIGHT OUTHER JOIN, и по този начин ако има програмисти, на които все още не е възложена задача, би трябвало да присъстват в резултатите.

select bug.id,
bug.logged_datetime, 
bug.priority, 
bug.status, 
developer.name as developer
from bug right join developer
on bug.dev_id = developer.id;

#6. Напишете заявка, в която демонстрирате вложен SELECT по ваш избор
#Създаваме заявка, с която извеждаме id на проектите, описанието им, имената на програмистите, които участват в тях.

select distinct project.id, 
project.description,
developer.name as programer
from project join developer
on developer.id in(
select dev_id
from project_dev
where project.id = project_dev.project_id
 );
 
#7. Напишете заявка, в която демонстрирате едновременно JOIN и агрегатна  функция.
#с тази заявка извличаме описание на проектите и  броя на бъговете, в даден проект.
 
select project.id as project_id, 
project.description,
project.manager_name, 
COUNT(bug.id) AS bug_count
from project
join bug_project on project.id = bug_project.project_id
join bug on bug_project.bug_id = bug.id
group by project.id;

#8. Създайте тригер по ваш избор- създаваме trigger, който прави log на всички промени в таблица bug
#създаваме trigger, който прави log на всички промени в таблица bug


# създаваме таблица bug_log

drop table if exists bug_log;
create table bug_log(
id int auto_increment primary key,
old_logged_datetime datetime,
new_logged_datetime datetime,
old_priority ENUM('minor', 'medium', 'major', 'critical'),
new_priority ENUM('minor', 'medium', 'major', 'critical'),
old_status ENUM('new', 'addressed', 'failed', 'closed'),
new_status ENUM('new', 'addressed', 'failed', 'closed'),
old_error_id int,
new_error_id int,
old_qa_id int,
new_qa_id int,
old_dev_id int,
new_dev_id int 
);

#създаваме тригера

delimiter |
create trigger after_bug_update after update on bug
for each row
begin
insert into bug_log(old_logged_datetime,
new_logged_datetime,
old_priority,
new_priority,
old_status,
new_status,
old_error_id,
new_error_id,
old_qa_id,
new_qa_id,
old_dev_id,
new_dev_id)
values(old.logged_datetime,
case new.logged_datetime when old.logged_datetime then null else new.logged_datetime end,
old.priority,
case new.priority when old.priority then null else new.priority end,
old.status,
case new.status when old.status then null else new.status end,
old.error_id,
case new.error_id when old.error_id then null else new.error_id end,
old.qa_id,
case new.qa_id when old.qa_id then null else new.qa_id end,
old.dev_id,
case new.dev_id when old.dev_id then null else new.dev_id end);
end;
|
delimiter ;


# правим update na статуса
update bug 
set status ='closed' where id = 2;

select*
from bug_log;


#9. Създайте процедура, в която демонстрирате използване на курсор.
#Създаваме процедура, която приема като параметър операционна система
# и извлича цялата информация от таблицата с грешки „error“, възникнали при дадената операционна система с помощта на курсор.


delimiter |
create procedure get_errors_by_os(os_name varchar(200))
begin
  declare finished int;
  declare error_id int;
  declare steps_to_reproduce1 text;
  declare operating_system1 varchar(200);
  declare logs1 TEXT;
  declare cur cursor for select id, steps_to_reproduce, operating_system, logs 
  from error where operating_system = os_name;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
  set finished=0;
  OPEN cur;
  read_loop: begin
	while(finished = 0)
    do
    FETCH cur INTO error_id, steps_to_reproduce1, operating_system1, logs1;
      if (finished=1)
      THEN
       LEAVE read_loop;
      END IF;
      select error_id, steps_to_reproduce1, operating_system1, logs1;
   END while;  
    
  END read_loop;
  CLOSE cur;
  SET finished = 0;
END
|
DELIMITER ;
CALL get_errors_by_os('macOS Mojave');





#vtori opit
delimiter |
create procedure get_errors_by_osy(os_name varchar(200))
begin
  declare finished int;
  declare error_id int;
  declare steps_to_reproduce1 text;
  declare operating_system1 varchar(200);
  declare logs1 TEXT;
  declare cur cursor for select id, steps_to_reproduce, operating_system, logs 
  from error where operating_system = os_name;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

  drop table if exists temp_results;
  create temporary table temp_results (
    id int,
    steps_to_reproduce TEXT,
    operating_system VARCHAR(200),
    logs TEXT
  )engine=MEMORY;

  OPEN cur;
  set finished = 0;
  read_loop: begin
	while(finished = 0)
    do
    FETCH cur INTO error_id, steps_to_reproduce1, operating_system1, logs1;
      if (finished=1)
      THEN
       LEAVE read_loop;
      END IF;
      INSERT INTO temp_results (id, steps_to_reproduce, operating_system, logs)
	   VALUES (error_id, steps_to_reproduce1, operating_system1, logs1);
    END while;  
    
  END read_loop;
  CLOSE cur;

  select * from temp_results;
  drop table temp_results;
END
|
DELIMITER ;

CALL get_errors_by_osy('Windows 10'); 
