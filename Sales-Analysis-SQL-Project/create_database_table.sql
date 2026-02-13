-- database_table.sql
-- Create database 'salesdbo', table 'sales', ready for CSV load

-- 1️⃣ Create database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'salesdbo')
BEGIN
    CREATE DATABASE salesdbo;
END
GO

-- 2️⃣ Use the database
USE salesdbo;
GO

-- 3️⃣ Create the sales table (drop if exists)
IF OBJECT_ID('dbo.sales', 'U') IS NOT NULL
    DROP TABLE dbo.sales;
GO

CREATE TABLE dbo.sales (
    transaction_id NVARCHAR(50) NULL,
    customer_id NVARCHAR(50) NULL,
    customer_name NVARCHAR(100) NULL,
    customer_age TINYINT NULL,
    gender NVARCHAR(20) NULL,
    product_id NVARCHAR(50) NOT NULL,
    product_name NVARCHAR(100) NOT NULL,
    product_category NVARCHAR(50) NOT NULL,
    quantity TINYINT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    payment_mode NVARCHAR(50) NULL,
    purchase_date DATE NULL,
    time_of_purchase TIME(7) NULL,
    status NVARCHAR(50) NULL
);
GO