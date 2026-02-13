
--data cleaning

--1)--treating null values
delete from dbo.sales 
where transaction_id is null
or customer_id is null
or customer_name is null
or customer_age is null
or gender is null
or product_id is null
or prodUct_name is null
or product_category is null
or quantity is null
or price is null
or payment_mode is null
or purchase_date is null
or time_of_purchase is null
or status is null;

--2
select
  case
     when gender = 'M' then 'Male'
	 when gender = 'F' then 'Female'
	 else gender
	 end as gender
	 from dbo.sales

	 update dbo.sales
	 set gender = case
     when gender = 'M' then 'Male'
	 when gender = 'F' then 'Female'
	 else gender
	 end;



select * from dbo.sales

--Data Analysis

-- 1. what are the top 5 most sellling products by quantity?
select  top 5 product_name,
sum(quantity) as total_quantity_sold
from dbo.sales
where status = 'delivered'
group by product_name
order by total_quantity_sold desc

select * from dbo.sales

--2. which products are most frequently cancelled?
select top 5 product_name, count(*) as total_cancelled
from dbo.sales
where status = 'cancelled'
group by product_name
order by total_cancelled desc

--3. what time of the day is highest number of purchases
select 
case 
when datepart(hour,time_of_purchase) between 0 and 5 then 'NIGHT'
when datepart(hour,time_of_purchase) between 6 and 11 then 'MORNING'
when datepart(hour,time_of_purchase) between 12 and 17 then 'AFTERNOON'
when datepart(hour,time_of_purchase) between 18 and 23 then 'EVENING'
END AS time_of_day,
count(*) as total_orders
from dbo.sales
group by 
case 
when datepart(hour,time_of_purchase) between 0 and 5 then 'NIGHT'
when datepart(hour,time_of_purchase) between 6 and 11 then 'MORNING'
when datepart(hour,time_of_purchase) between 12 and 17 then 'AFTERNOON'
when datepart(hour,time_of_purchase) between 18 and 23 then 'EVENING'
end
order by total_orders desc

select * from dbo.sales

--4. what are the top 5 highest spending customers?
select top 5 customer_name,
format(sum(price*quantity), 'C0', 'en-IN')  as total_spend
from dbo.sales
group by customer_name
order by sum(price*quantity) desc

--5. which product categories generate the highest revenue?
select product_category, 
format(sum(price*quantity), 'C0', 'en-IN')  as highest_revenue
from dbo.sales
group by product_category
order by sum(price*quantity) desc


select * from dbo.sales

--6. what is the returned and cancellation rate per product category?
--cancellation
select product_category,
format(count(case when status = 'cancelled' then 1 end)*100.0/count(*),'N3') + ' % ' as cancelled_percent
from dbo.sales
group by  product_category
order by cancelled_percent desc


--returned
select product_category,
format(count(case when status = 'returned' then 1 end)*100.0/count(*),'N3') + ' % ' as returned_percent
from dbo.sales
group by  product_category
order by returned_percent desc

select * from dbo.sales

--7. what is the most preferred payment mode?
select payment_mode,
count(payment_mode) as total_count
from dbo.sales
group by payment_mode
order by  total_count desc

--8. how does age group affect purchasing behaviour?
select
    case
	     when customer_age between 18 and 25 then '18-25'
		 when customer_age between 26 and 35 then '26-35'
		 when customer_age between 36 and 50 then '36-50'
		 else '51+'
		 end as customer_age,
		 format(sum(price*quantity),'C0') as total_purchase
		 from dbo.sales
		 group by case
		 when customer_age between 18 and 25 then '18-25'
		 when customer_age between 26 and 35 then '26-35'
		 when customer_age between 36 and 50 then '36-50'
		 else '51+'
		 end
		 order by sum(price*quantity) desc

--9.what is the monthly sales trend?
select
month(purchase_date) as months,
format(sum(price*quantity),'C0') as total_sales,
sum(quantity) as total_quantity
from dbo.sales
group by month(purchase_date)
order by months

select * from dbo.sales

--10. are certain age groups buying more specific product categories
--method 1.
select gender,product_category, count(product_category) as total_purchase
from dbo.sales
group by gender,product_category
order by gender desc

--method 2.		
select * 
from (
select gender,product_category
 from dbo.sales
) as source_table
 pivot ( 
         count(gender) 
		 for gender in ([Male],[Female])
		 ) as pivot_table
 order by product_category






























--data cleaning
--1)--treating null values
delete from sales 
where transaction_id is null
or customer_id is null
or customer_name is null
or customer_age is null
or gender is null
or product_id is null
or prodUct_name is null
or product_category is null
or quantity is null
or price is null
or payment_mode is null
or purchase_date is null
or time_of_purchase is null
or status is null;

--2
select
  case
     when gender = 'M' then 'Male'
	 when gender = 'F' then 'Female'
	 else gender
	 end as gender
	 from sales

	 update sales
	 set gender = case
     when gender = 'M' then 'Male'
	 when gender = 'F' then 'Female'
	 else gender
	 end;

--creating copy of dataset
select * from sales_store
select * into sale from sales_store
select * from sales


select * from sales

--Data Analysis

-- 1. what are the top 5 most sellling products by quantity?
select  top 5 product_name,
sum(quantity) as total_quantity_sold
from sales
where status = 'delivered'
group by product_name
order by total_quantity_sold desc

select * from sales

--2. which products are most frequently cancelled?
select top 5 product_name, count(*) as total_cancelled
from sales
where status = 'cancelled'
group by product_name
order by total_cancelled desc

--3. what time of the day is highest number of purchases
select 
case 
when datepart(hour,time_of_purchase) between 0 and 5 then 'NIGHT'
when datepart(hour,time_of_purchase) between 6 and 11 then 'MORNING'
when datepart(hour,time_of_purchase) between 12 and 17 then 'AFTERNOON'
when datepart(hour,time_of_purchase) between 18 and 23 then 'EVENING'
END AS time_of_day,
count(*) as total_orders
from sales 
group by 
case 
when datepart(hour,time_of_purchase) between 0 and 5 then 'NIGHT'
when datepart(hour,time_of_purchase) between 6 and 11 then 'MORNING'
when datepart(hour,time_of_purchase) between 12 and 17 then 'AFTERNOON'
when datepart(hour,time_of_purchase) between 18 and 23 then 'EVENING'
end
order by total_orders desc

select * from sales

--4. what are the top 5 highest spending customers?
select top 5 customer_name,
format(sum(price*quantity), 'C0', 'en-IN')  as total_spend
from sales
group by customer_name
order by sum(price*quantity) desc

--5. which product categories generate the highest revenue?
select product_category, 
format(sum(price*quantity), 'C0', 'en-IN')  as highest_revenue
from sales
group by product_category
order by sum(price*quantity) desc


select * from sales

--6. what is the returned and cancellation rate per product category?
--cancellation
select product_category,
format(count(case when status = 'cancelled' then 1 end)*100.0/count(*),'N3') + ' % ' as cancelled_percent
from sales
group by  product_category
order by cancelled_percent desc


--returned
select product_category,
format(count(case when status = 'returned' then 1 end)*100.0/count(*),'N3') + ' % ' as returned_percent
from sales
group by  product_category
order by returned_percent desc

select * from sales

--7. what is the most preferred payment mode?
select payment_mode,
count(payment_mode) as total_count
from sales
group by payment_mode
order by  total_count desc

--8. how does age group affect purchasing behaviour?
select
    case
	     when customer_age between 18 and 25 then '18-25'
		 when customer_age between 26 and 35 then '26-35'
		 when customer_age between 36 and 50 then '36-50'
		 else '51+'
		 end as customer_age,
		 format(sum(price*quantity),'C0') as total_purchase
		 from sales
		 group by case
		 when customer_age between 18 and 25 then '18-25'
		 when customer_age between 26 and 35 then '26-35'
		 when customer_age between 36 and 50 then '36-50'
		 else '51+'
		 end
		 order by sum(price*quantity) desc

--9.what is the monthly sales trend?
select
month(purchase_date) as months,
format(sum(price*quantity),'C0') as total_sales,
sum(quantity) as total_quantity
from sales
group by month(purchase_date)
order by months

select * from sales

--10. are certain age groups buying more specific product categories
--method 1.
select gender,product_category, count(product_category) as total_purchase
from sales
group by gender,product_category
order by gender desc

--method 2.		
select * 
from (
select gender,product_category
 from sales
) as source_table
 pivot ( 
         count(gender) 
		 for gender in ([Male],[Female])
		 ) as pivot_table
 order by product_category












 --data import
set dateformat dmy
bulk insert sales_store
from 'C:\Users\DDC\Downloads\archive\sales.csv'
with (
firstrow=2,
fieldterminator=',',
rowterminator='\n'
);

--data cleaning
--1)--treating null values
delete from sales 
where transaction_id is null
or customer_id is null
or customer_name is null
or customer_age is null
or gender is null
or product_id is null
or prodUct_name is null
or product_category is null
or quantity is null
or price is null
or payment_mode is null
or purchase_date is null
or time_of_purchase is null
or status is null;

--2
select
  case
     when gender = 'M' then 'Male'
	 when gender = 'F' then 'Female'
	 else gender
	 end as gender
	 from sales

	 update sales
	 set gender = case
     when gender = 'M' then 'Male'
	 when gender = 'F' then 'Female'
	 else gender
	 end;

--creating copy of dataset
select * from sales_store
select * into sale from sales_store
select * from sales


select * from sales

--Data Analysis

-- 1. what are the top 5 most sellling products by quantity?
select  top 5 product_name,
sum(quantity) as total_quantity_sold
from sales
where status = 'delivered'
group by product_name
order by total_quantity_sold desc

select * from sales

--2. which products are most frequently cancelled?
select top 5 product_name, count(*) as total_cancelled
from sales
where status = 'cancelled'
group by product_name
order by total_cancelled desc

--3. what time of the day is highest number of purchases
select 
case 
when datepart(hour,time_of_purchase) between 0 and 5 then 'NIGHT'
when datepart(hour,time_of_purchase) between 6 and 11 then 'MORNING'
when datepart(hour,time_of_purchase) between 12 and 17 then 'AFTERNOON'
when datepart(hour,time_of_purchase) between 18 and 23 then 'EVENING'
END AS time_of_day,
count(*) as total_orders
from sales 
group by 
case 
when datepart(hour,time_of_purchase) between 0 and 5 then 'NIGHT'
when datepart(hour,time_of_purchase) between 6 and 11 then 'MORNING'
when datepart(hour,time_of_purchase) between 12 and 17 then 'AFTERNOON'
when datepart(hour,time_of_purchase) between 18 and 23 then 'EVENING'
end
order by total_orders desc

select * from sales

--4. what are the top 5 highest spending customers?
select top 5 customer_name,
format(sum(price*quantity), 'C0', 'en-IN')  as total_spend
from sales
group by customer_name
order by sum(price*quantity) desc

--5. which product categories generate the highest revenue?
select product_category, 
format(sum(price*quantity), 'C0', 'en-IN')  as highest_revenue
from sales
group by product_category
order by sum(price*quantity) desc


select * from sales

--6. what is the returned and cancellation rate per product category?
--cancellation
select product_category,
format(count(case when status = 'cancelled' then 1 end)*100.0/count(*),'N3') + ' % ' as cancelled_percent
from sales
group by  product_category
order by cancelled_percent desc


--returned
select product_category,
format(count(case when status = 'returned' then 1 end)*100.0/count(*),'N3') + ' % ' as returned_percent
from sales
group by  product_category
order by returned_percent desc

select * from sales

--7. what is the most preferred payment mode?
select payment_mode,
count(payment_mode) as total_count
from sales
group by payment_mode
order by  total_count desc

--8. how does age group affect purchasing behaviour?
select
    case
	     when customer_age between 18 and 25 then '18-25'
		 when customer_age between 26 and 35 then '26-35'
		 when customer_age between 36 and 50 then '36-50'
		 else '51+'
		 end as customer_age,
		 format(sum(price*quantity),'C0') as total_purchase
		 from sales
		 group by case
		 when customer_age between 18 and 25 then '18-25'
		 when customer_age between 26 and 35 then '26-35'
		 when customer_age between 36 and 50 then '36-50'
		 else '51+'
		 end
		 order by sum(price*quantity) desc

--9.what is the monthly sales trend?
select
month(purchase_date) as months,
format(sum(price*quantity),'C0') as total_sales,
sum(quantity) as total_quantity
from sales
group by month(purchase_date)
order by months

select * from sales

--10. are certain age groups buying more specific product categories
--method 1.
select gender,product_category, count(product_category) as total_purchase
from sales
group by gender,product_category
order by gender desc

--method 2.		
select * 
from (
select gender,product_category
 from sales
) as source_table
 pivot ( 
         count(gender) 
		 for gender in ([Male],[Female])
		 ) as pivot_table
 order by product_category








































