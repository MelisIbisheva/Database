create database news_site;
use news_site;

create table categories(
id int auto_increment primary key,
descriptions varchar(50) not null
);

create table readers(
id int auto_increment primary key,
name varchar(50) not null
);


create table news (
id int auto_increment primary key,
title varchar(50) not null,
category_id int not null,
constraint foreign key (category_id) references categories(id)
);

create table comments(
id_comments int not null,
comment text not null,
news_id int not null,
reader_id int not null,
constraint foreign key (news_id) references news(id),
constraint foreign key(reader_id) references readers(id)
);

create table help_table(
news_id int not null,
comments_id int not null,
constraint foreign key(news_id) references news(id),
constraint foreign key(comments_id) references comments(id)
);

insert into news (title) 
values ('sport');

insert into news (content) 
values ('Спортът включва всички форми на конкурентна физическа активност и игри, които [1] посредством случайно или организирано участие имат за цел да използват, поддържат и подобряват физическите способности и умения на човека, като същевременно осигуряват наслада на участниците както и развлечения за зрителите');


update news 
set title = 'football'
where id =1;

insert into readers (name)
values ('Melis') ;

delete from news where id = 1;

select *
from news;


