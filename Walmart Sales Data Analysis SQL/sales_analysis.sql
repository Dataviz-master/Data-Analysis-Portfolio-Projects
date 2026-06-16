--Data cleaning
select
* 
from WalmartSales_Staging



-- Add the time_of_day column
select 
    time,
	case when time between '00:00:00' and '12:00:00' then 'Morning'
	when time between '12:01:00' and '16:00:00' then 'Afternoon'
	else 'Evening'
	end as time_of_date
from WalmartSales_Staging




-- Add day_name column
select
date,
datename(weekday,date) as day_name
from WalmartSales_Staging




-- Add month_name column
select date,
datename(month,date) from WalmartSales_Staging


-- --------------------------------------------------------------------
-- ---------------------------- Generic ------------------------------
-- --------------------------------------------------------------------



-- How many unique cities does the data have?
select distinct(city) from WalmartSales_Staging




-- In which city is each branch?
select distinct city,
branch from WalmartSales_Staging





-- --------------------------------------------------------------------
-- ---------------------------- Product -------------------------------
-- --------------------------------------------------------------------



-- How many unique product lines does the data have?
select count(distinct [Product line]) from WalmartSales_Staging;




--What is the most common payment method?
select
payment ,
count(payment) as cnt
from WalmartSales_Staging
group by payment 
order by cnt desc;





-- What is the most selling product line
select [Product line],
count([Product line]) as cnt
from WalmartSales_Staging
group by [Product line]
order by cnt desc;





--What is the total revenue by month?
SELECT 
    DATENAME(month, CAST(date AS DATE)) AS mth,
    SUM(CAST(total AS FLOAT)) AS total_revenue
FROM WalmartSales_Staging
GROUP BY DATENAME(month, CAST(date AS DATE))
ORDER BY total_revenue DESC;




--What month had the largest COGS?
SELECT 
    DATENAME(month, CAST(date AS DATE)) AS mth,
    SUM(CAST(cogs AS FLOAT)) AS cogs
FROM WalmartSales_Staging
GROUP BY DATENAME(month, CAST(date AS DATE))
ORDER BY cogs DESC;







--What product line had the largest revenue?
SELECT
    [Product line],
    SUM(CAST(total AS FLOAT)) AS total_revenue
FROM WalmartSales_Staging
GROUP BY [Product line]
ORDER BY total_revenue DESC;






 --What is the city with the largest revenue?
 SELECT
    city,
    branch,
    SUM(CAST(total AS FLOAT)) AS total_revenue
FROM WalmartSales_Staging
GROUP BY city, branch
ORDER BY total_revenue DESC;






--What product line had the largest VAT?
 SELECT 
    [Product line],
    AVG(CAST([Tax 5%] AS FLOAT)) AS avg_tax 
FROM WalmartSales_Staging
GROUP BY [Product line]
ORDER BY avg_tax DESC;





 --Which branch sold more products than average product sold?
 SELECT 
    Branch,
    SUM(CAST(Quantity AS INT)) AS qty
FROM WalmartSales_Staging
GROUP BY Branch
HAVING SUM(CAST(Quantity AS INT)) > 
       (SELECT AVG(CAST(Quantity AS FLOAT)) FROM WalmartSales_Staging);



 --What is the most common product line by gender?
select
gender,
  [Product line],
count(gender) as total_cnt
from WalmartSales_Staging
group by gender, [Product line]
order by total_cnt desc;





--What is the average rating of each product line?
SELECT
    ROUND(AVG(CAST(rating AS FLOAT)), 2) AS avg_rating,
    [Product line]
FROM WalmartSales_Staging
GROUP BY [Product line]
ORDER BY avg_rating DESC;




-- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Sales -------------------------------
-- --------------------------------------------------------------------


 SELECT 
    time,
    CASE 
        WHEN DATEPART(HOUR, time) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, time) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day
FROM WalmartSales_Staging;

ALTER TABLE WalmartSales_Staging
ADD time_of_day VARCHAR(20);




UPDATE WalmartSales_Staging
SET time_of_day = 
    CASE 
        WHEN DATEPART(HOUR, time) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN DATEPART(HOUR, time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATEPART(HOUR, time) BETWEEN 17 AND 20 THEN 'Evening'
        ELSE 'Night'
    END;



--Number of sales made in each time of the day per weekday
 select time_of_day,
 count(*) as total_sales
 from WalmartSales_Staging
WHERE DATENAME(WEEKDAY, date) = 'Sunday'
 group by time_of_day
 order by total_sales desc;




 --Which of the customer types brings the most revenue?
 SELECT
    [Customer type],
    SUM(CAST(total AS FLOAT)) AS total_rev
FROM WalmartSales_Staging
GROUP BY [Customer type]
ORDER BY total_rev DESC;




 --Which city has the largest tax percent/ VAT (Value Added Tax)?
select 
 city,
 max([Tax 5%]) as VAT
 from WalmartSales_Staging
 group by city
 order by VAT desc;




 --Which customer type pays the most in VAT?
 SELECT 
    [Customer type],
    SUM(CAST([Tax 5%] AS FLOAT)) AS VAT
FROM WalmartSales_Staging
GROUP BY [Customer type]
ORDER BY VAT DESC;




  -- --------------------------------------------------------------------
-- --------------------------------------------------------------------

-- --------------------------------------------------------------------
-- -------------------------- Customers -------------------------------
-- --------------------------------------------------------------------


--How many unique customer types does the data have?
 select
 distinct [Customer type]
 from WalmartSales_Staging;


 --How many unique payment methods does the data have?
 select 
 distinct Payment 
 from WalmartSales_Staging;




 
 --What is the most common customer type?
 select 
 [Customer type],
 count(*) as cstm_cnt
from WalmartSales_Staging
group by [Customer type];



--What is the gender of most of the customers?
select 
Gender,
count(*) as gender_cnt
from WalmartSales_Staging
group by Gender
order by gender_cnt desc; 



--What is the gender distribution per branch?
select 
Gender,
count(*) as gender_cnt
from WalmartSales_Staging
where Branch = 'C'
group by Gender
order by gender_cnt desc; 



--Which time of the day do customers give most ratings?
select 
time_of_day,
count(rating) as total_ratings
from WalmartSales_Staging
group by time_of_day
order by total_ratings desc;



--Which time of the day do customers give most ratings per branch?
select 
time_of_day,
count(rating) as total_ratings
from WalmartSales_Staging
where Branch = 'C'
group by time_of_day
order by total_ratings desc;


--or


SELECT 
    branch,
    time_of_day,
    COUNT(rating) AS total_ratings
FROM WalmartSales_Staging
GROUP BY branch, time_of_day
ORDER BY branch, total_ratings DESC;




--Which day fo the week has the best avg ratings?
SELECT 
    DATENAME(weekday, CAST(Date AS DATE)) AS day_of_week,
    AVG(CAST(rating AS FLOAT)) AS avg_rating
FROM WalmartSales_Staging
GROUP BY DATENAME(weekday, CAST(Date AS DATE))
ORDER BY avg_rating DESC;



   
--Which day of the week has the best average ratings per branch?
WITH RankedDays AS (
    SELECT 
        branch,
        DATENAME(weekday, CAST(Date AS DATE)) AS day_of_week,
        AVG(CAST(rating AS FLOAT)) AS avg_rating,
        RANK() OVER (
            PARTITION BY branch 
            ORDER BY AVG(CAST(rating AS FLOAT)) DESC
        ) AS rnk
    FROM WalmartSales_Staging
    GROUP BY branch, DATENAME(weekday, CAST(Date AS DATE))
)
SELECT 
    branch,
    day_of_week,
    avg_rating
FROM RankedDays
WHERE rnk = 1;