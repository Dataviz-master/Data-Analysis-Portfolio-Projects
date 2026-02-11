
---

## Files Description

- **01_create_database_and_table.sql**  
  Creates the `Blinkitdb` database and the `Blinkit_data` table.  

- **02_analysis_queries.sql**  
  Performs:
  - Data cleaning (`Item_Fat_Content` normalization)  
  - KPI calculations (Total Sales, Average Sales, Avg Rating, No of Orders)  
  - Analysis queries:  
    - Total Sales by Fat Content  
    - Total Sales by Item Type  
    - Sales distribution by Outlet Location & Outlet Type  
    - Pivot tables for comparison  

- **dataset.csv**  
  Original dataset to populate the table.  

- **screenshots/**  
  Contains **key outputs** for visual proof of your analysis.

---

## How to Run

1. Open **SQL Server Management Studio (SSMS)**.  
2. Run `01_create_database_and_table.sql` to create the database and table.  
3. Import `dataset.csv` into the `Blinkit_data` table.  
   - Right-click the table → **Import Data** → choose CSV  
4. Run `02_analysis_queries.sql` to perform analysis and view KPIs.  

> **Note:** `02_analysis_queries.sql` includes a check to ensure the table exists. If not, it will prompt you to run the setup file first.

---

## Key Insights (Examples)

- **Total Sales:** Shows total revenue in millions.  
- **Average Rating:** Provides average product ratings across outlets.  
- **Top 5 Products:** Highest-selling products by revenue.  
- **Sales by Outlet Type/Fat Content/Outlet Size:** Helps understand performance by category.  

---


---

## Skills Demonstrated

- SQL Server database creation & management  
- Data cleaning & transformation using SQL  
- Aggregate functions, grouping, and pivot tables  
- KPI calculation and business insights generation  
- Professional repository structuring and documentation

---
