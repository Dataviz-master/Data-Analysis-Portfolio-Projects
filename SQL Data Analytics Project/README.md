#  Sales Analysis using SQL Server

## Project Overview
This project analyzes **sales, products, and customer data** using SQL Server.  
It demonstrates advanced SQL techniques, including:

- Aggregation and summarization
- Window functions (`ROW_NUMBER()`, `LAG()`, `SUM() OVER`, `AVG() OVER`)
- Customer segmentation
- Cumulative analysis
- Creation of a reusable report view

The project covers:

- **Sales performance over time**  
- **Cumulative sales and moving averages**  
- **Year-over-Year and Month-over-Month performance analysis**  
- **Category contribution analysis (part-to-whole)**  
- **Customer segmentation (VIP, Regular, New)**  
- **Creation of `Sales.AllOrders` view** summarizing customer metrics  

---

## Tables Used

| Table | Description |
|-------|-------------|
| `gold.dim_customers` | Contains all sales transactions including order date, sales amount, quantity, and customer/product keys |
| `gold.dim_products` | Product details including product name, category, and cost |
| `gold.fact_sales` | Customer information including name, birthdate, and other demographics |

---

## SQL Scripts & Analysis

### 1. Sales Performance Over Time
- Aggregates **sales, customers, and quantity** by year and month  
- Demonstrates `YEAR()`, `MONTH()`, `FORMAT()`, and `DATETRUNC()` usage  
- Expected output: Table showing **total sales, total customers, total quantity** per month/year

### 2. Cumulative Analysis
- Calculates **running total of sales** and **moving average price**  
- Expected output: Table showing `order_date`, `total_sales`, `running_total_sales`, `moving_average_price`

### 3. Performance Analysis (YoY / MoM)
- Compares **product sales to average sales** and **previous year’s sales**  
- Expected output: Table showing `order_year`, `product_name`, `current_sales`, `avg_sales`, difference vs average, YoY change

### 4. Part-to-Whole Analysis
- Shows which **product categories contribute most to total sales**  
- Expected output: Table with `category`, `total_sales`, `overall_sales`, and `percentage_of_total`

### 5. Product Segmentation
- Groups products by **cost ranges** (`Below 100`, `100-500`, `500-1000`, `Above 1000`)  
- Expected output: Count of products per cost range

### 6. Customer Segmentation
- Groups customers as **VIP, Regular, New** based on **spending and lifespan**  
- Expected output: Table with `customer_segment` and `total_customers`

### 7. Customer Report View
- Creates a **view `Sales.AllOrders`** summarizing customer-level metrics:

| Metric | Description |
|--------|------------|
| `total_orders` | Total orders per customer |
| `total_sales` | Total sales per customer |
| `total_quantity` | Total quantity purchased |
| `total_products` | Number of distinct products purchased |
| `avg_order_value` | Average sales per order |
| `avg_monthly_spend` | Average spend per month |
| `recency` | Months since last purchase |
| `age_group` | Age categories (Under 20, 20-29, etc.) |
| `customer_segment` | VIP, Regular, New based on spending/lifespan |

---

## Expected Output
- **Aggregated tables** showing sales performance, customer segmentation, and category contribution  
- **Running totals and moving averages** for trend analysis  
- **Customer report view** combining multiple metrics per customer  


## Folder Structure

