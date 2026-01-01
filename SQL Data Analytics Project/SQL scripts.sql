-- Analyse sales performance over time
-- Quick Date Functions
select 
year(order_date) as order_year,
MONTH(order_date) as order_month,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from [gold.fact_sales]
where order_date is not null
group by YEAR(order_date), MONTH(order_date)
order by YEAR(order_date), MONTH(order_date)


-- DATETRUNC()
select 
datetrunc(MONTH, order_date) as order_date,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from [gold.fact_sales]
where order_date is not null
group by datetrunc(MONTH, order_date)
order by datetrunc(MONTH, order_date)


-- FORMAT()
select 
format(order_date, 'yyyy-MMM') as order_date,
sum(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum(quantity) as total_quantity
from [gold.fact_sales]
where order_date is not null
group by format(order_date, 'yyyy-MMM') 
order by format(order_date, 'yyyy-MMM') 



---Cumulative Analysis
-- Calculate the total sales per month 
-- and the running total of sales over time 

select
order_date,
total_sales,
sum(total_sales) over (partition by order_date order by order_date) as running_total_sales,
avg(avg_price) over (partition by order_date order by order_date) as moving_average_price
from
(
select
datetrunc(YEAR, order_date) as order_date,
sum(sales_amount) as total_sales,
AVG(price) as avg_price
from [gold.fact_sales]
where order_date is not null
group by datetrunc(YEAR, order_date) 
) t



--Performance Analysis (Year-over-Year, Month-over-Month)
-- Analyze the yearly performance of products by comparing their sales 
--to both the average sales performance of the product and the previous year's sales 

with yearly_product_sales as (
select 
YEAR(f.order_date) as order_year,
p.product_name,
SUM(f.sales_amount) as current_sales
from [gold.fact_sales] f 
left join [gold.dim_products] p 
on f.product_key = p.product_key
where f.order_date is not null
group by YEAR(f.order_date),
p.product_name
)

select
order_year,
product_name,
current_sales,
AVG(current_sales) over (partition by product_name) as avg_sales,
current_sales - AVG(current_sales) over (partition by product_name) as diff_avg,
case when current_sales - AVG(current_sales) over (partition by product_name) > 0 then 'Above Avg'
 when current_sales - AVG(current_sales) over (partition by product_name) < 0 then 'Below Avg'
 else 'Avg'
 end as avg_change,

 -- Year-over-Year Analysis
 lag(current_sales) over (partition by product_name order by order_year)  py_sales,
 current_sales -  lag(current_sales) over (partition by product_name order by order_year) as diff_py,
 case when current_sales - lag(current_sales) over (partition by product_name order by order_year) > 0 then 'Increase'
      when current_sales - lag(current_sales) over (partition by product_name order by order_year) < 0 then 'Decrease'
      else 'No Change'
 end as py_change
 from yearly_product_sales
 order by product_name, order_year

 --Part-to-Whole Analysis
-- Which categories contribute the most to overall sales?

 with category_sales as ( 
 select 
 category,
 SUM(sales_amount) total_sales
 from [gold.fact_sales] f 
 left join [gold.dim_products] p 
 on p.product_key = f.product_key
 group by category)

 select 
 category,
 total_sales,
 SUM(total_sales) over () overall_sales,
 CONCAT(
 round(
 (cast (total_sales as float) / sum(total_sales) over ())*100, 2), '%') as percentage_of_total
 from category_sales
 order by total_sales desc

 
--Data Segmentation Analysis
--Segment products into cost ranges and 
--count how many products fall into each segment

 with product_segments as (
 select 
 product_key,
 product_name,
 cost,
 case when cost < 100 then 'Below 100'
      when cost between 100 and 500 then '100-500'
	  when cost between 500 and 1000 then '500-1000'
	  else 'Above 1000'
 end cost_range
 from [gold.dim_products])

 select 
 cost_range,
 count(product_key) as total_products 
 from product_segments
 group by  cost_range
 order by total_products desc


 --Group customers into three segments based on their spending behavior:
	-- VIP: Customers with at least 12 months of history and spending more than €5,000.
	-- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	-- New: Customers with a lifespan less than 12 months.
--And find the total number of customers by each group

 with customer_spending as (
 select 
 c.customer_key,
 sum(f.sales_amount) as total_spending,
 min(order_date) as first_order,
 max(order_date) as last_order,
 datediff(month, min(order_date), max(order_date)) as lifespan
 from [gold.fact_sales] f 
 left join [gold.dim_customers] c 
 on f.customer_key = c.customer_key
 group by c.customer_key
 )

 select
 customer_segment,
 count(customer_key) as total_customers
 from (
	 select 
	 customer_key,
	 case when lifespan >= 12 and total_spending > 5000 then 'VIP'
		  when lifespan >= 12 and total_spending <= 5000 then 'Regular'
		  else 'New'
	end customer_segment
	from  customer_spending ) t 
 group by customer_segment
 order by total_customers desc

 
--Customer Report
-- Create Report: gold.report_customers
 -- Step 1: Create the schema if it doesn't exist

IF NOT EXISTS (
    SELECT * 
    FROM sys.schemas 
    WHERE name = 'Sales'
)
BEGIN
    EXEC('CREATE SCHEMA Sales');
END;


 CREATE VIEW Sales.AllOrders AS
 
    WITH base_query AS (
--1) --Base Query: Retrieves core columns from table
	SELECT 
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        DATEDIFF(year, c.birthdate, GETDATE()) AS age
    FROM [gold.fact_sales] f 
    LEFT JOIN [gold.dim_customers] c 
        ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
)
   , customer_aggregation as (
 --2) Customer Aggregations: Summarizes key metrics at the customer level
   SELECT 
	 customer_key,
	 customer_number,
	 customer_name,
	 age,
	 count(distinct order_number) as total_orders,
	 sum(sales_amount) as total_sales,
	 sum(quantity) as total_quantity,
	 count(distinct product_key) as total_products,
	 max(order_date) as last_order_date,
	 datediff(month, min(order_date), max(order_date)) as lifespan
 FROM base_query
 group by 
	customer_key,
	customer_number,
	customer_name,
	age	
)
 select 
 customer_key,
 customer_number,
 customer_name,
 age,
 case 
		 when age < 20 then 'Under 20'
		 when age between 20 and 29 then '20-29'
		 when age between 30 and 39  then '30-39'
		 when age between 40 and 49 then '40-49'
		 else '50 and above'
  end as age_group,
  case 
		 when lifespan >= 12 and total_sales > 5000 then 'VIP'
		 when lifespan >= 12 and total_sales <= 5000 then 'Regular'
		 else 'New'
	 end customer_segment,
	 last_order_date,
	 DATEDIFF(month, last_order_date, getdate()) as recency,
	 total_orders,
	 total_sales,
	 total_quantity,
	 total_products,
     lifespan,

---- Compuate average order value (AVO)

	 case when total_sales = 0 then 0 
	      else total_sales / total_orders
	 end as  avg_order_value,

---- Compuate average monthly spend

	 case when lifespan = 0 then total_sales 
	      else total_sales / lifespan 
	 end as avg_monthly_spend
	 from customer_aggregation;
	 GO

 select 
	 customer_segment,
	 count(customer_number) as total_customers,
	 sum(total_sales) total_sales
from Sales.AllOrders
group by customer_segment




















