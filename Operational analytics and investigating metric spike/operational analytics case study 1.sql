create database if not exists operational_analytics;

use operational_analytics;

/* case study 1 - job data analysis*/

create table if not exists job_data (
index_num int primary key NOT NULL AUTO_INCREMENT,
job_id int,
actor_id int,
event varchar(255),
language varchar(255),
time_spent int,
org varchar(255),
ds date);


select * from job_data;


insert into job_data (index_num, ds, job_id, actor_id, event, language, time_spent, org)
values (1,'2020-11-30', 21, 1001, 'skip', 'English', 15, 'A'),
       (2,'2020-11-30', 22, 1006, 'transfer', 'Arabic', 25, 'B'),
       (3,'2020-11-29', 23, 1003, 'decision', 'Persian', 20, 'C'),
       (4,'2020-11-28', 23, 1005,'transfer', 'Persian', 22, 'D'),
       (5,'2020-11-28', 25, 1002, 'decision', 'Hindi', 11, 'B'),
       (6,'2020-11-27', 11, 1007, 'decision', 'French', 104, 'D'),
       (7,'2020-11-26', 23, 1004, 'skip', 'Persian', 56, 'A'),
       (8,'2020-11-25', 20, 1003, 'transfer', 'Italian', 45, 'C');
       



/* jobs reviwed overtime: calculate the number of jobs reviewed per hour for 
each day in November 2020*/

SELECT 
    ds AS date,
    ROUND((COUNT(job_id) / SUM(time_spent) * 3600),2) AS job_review_per_hour
FROM
    job_data
WHERE
    ds BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY ds
ORDER BY ds;
    


/* Throughput Analysis: Calculate the 7-day rolling average of 
throughput (number of events per second).*/

select * from job_data;

select count(distinct event)/sum(time_spent) from job_data;

select distinct event from job_data;

SELECT 
    ROUND((COUNT(event) / SUM(time_spent)), 2) AS weekly_throughput
FROM
    job_data;


SELECT 
    ds AS date,
    ROUND((COUNT(event) / SUM(time_spent)), 2) AS daily_throughput
FROM
    job_data
GROUP BY ds;



/* Language Share Analysis: calculate the percentage share of 
each language over the last 30 days.*/


select * from job_data;

select count(*) from job_data;

SELECT 
    language,
    COUNT(language) AS language_used,
    (COUNT(language) / (SELECT COUNT(*) FROM job_data)) * 100 AS perc_share_language
FROM
    job_data
WHERE
    ds BETWEEN '2020-11-01' AND '2020-11-30'
GROUP BY language
ORDER BY language DESC;


/* Duplicate Rows Detection: Identify duplicate rows in the data.*/

select * from job_data;

SELECT * 
FROM
(
SELECT *,
row_number()over(partition by job_id) as rownum 
FROM job_data
)a 
WHERE rownum>1
union
SELECT * from
(
SELECT *,
row_number()over(partition by actor_id) as rownum 
FROM job_data
)a 
WHERE rownum>1;
