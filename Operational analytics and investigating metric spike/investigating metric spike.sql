use project3;

/* 1) weekly user engagement: calculate weekly user enagagement*/

# 1) 

select * from events;

SELECT 
    EXTRACT(WEEK FROM occurred_at) AS week_num,
    COUNT(DISTINCT user_id) AS users_engage
FROM
    events
WHERE
    event_type = 'engagement'
GROUP BY week_num
ORDER BY week_num;




/* 2) user growth analysis:Analyze the growth of users over time for a product.*/

select * from users;
select * from events;
select * from email_events;


select quarter_num, year, active_users,
	sum(active_users) over (order by year, quarter_num rows between unbounded preceding and current row) as
    growth_of_users
from (
	select extract(quarter from activated_at) as quarter_num,
		   extract(year from activated_at) as year,
		   count(distinct user_id) as active_users
	from users
	group by quarter_num, year
	order by quarter_num, year
    )as a;   
    
    
    
    
/* 3) Weekly Retention Analysis: Analyze the retention of users on a weekly 
basis after signing up for a product.*/

select * from events;
SELECT 
    EXTRACT(WEEK FROM occurred_at) AS week_num,
    COUNT(DISTINCT user_id) AS users_retained
FROM
    events
WHERE
    event_name = 'complete_signup'
        AND event_type = 'signup_flow'
GROUP BY week_num
ORDER BY week_num;




/* 4) Weekly Engagement Per Device: calculate the weekly engagement per device.*/

select distinct device from events;


SELECT 
    device,
    EXTRACT(WEEK FROM occurred_at) AS week_num,
    COUNT(DISTINCT user_id) AS users_engage
FROM
    events
WHERE
    event_type = 'engagement'
GROUP BY week_num , device
ORDER BY week_num;
    
    
/* 5) Email Engagement Analysis: Analyze how users are engaging with the email service.*/

select * from email_events;

select distinct action,count(action) from email_events group by action;


SELECT 
    (SUM(CASE
        WHEN email_category = 'opened' THEN 1
        ELSE 0
    END) / SUM(CASE
        WHEN email_category = 'email_sent' THEN 1
        ELSE 0
    END)) * 100 AS percentage_email_opened,
    (SUM(CASE
        WHEN email_category = 'clickthrough' THEN 1
        ELSE 0
    END) / SUM(CASE
        WHEN email_category = 'email_sent' THEN 1
        ELSE 0
    END)) * 100 AS percentage_email_clickthrough
FROM
    (SELECT *,
            CASE
                WHEN action IN ('email_clickthrough') THEN ('clickthrough')
                WHEN action IN ('email_open') THEN ('opened')
                WHEN action IN ('sent_weekly_digest' , 'sent_reengagement_email') THEN ('email_sent')
            END AS email_category
    FROM
        email_events) a;        