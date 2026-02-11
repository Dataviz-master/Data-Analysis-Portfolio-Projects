
-- 01_create_database_and_table.sql
-- This script creates the Blinkitdb database and the Blinkit_data table

-- Step 1: Create database if it doesn't exist
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Blinkitdb')
BEGIN
    CREATE DATABASE Blinkitdbo;
END
GO

-- Step 2: Use the database
USE Blinkitdbo;
GO

-- Step 3: Create table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Blinkit_data')
BEGIN
    CREATE TABLE dbo.Blinkit_data (
        Item_Fat_Content        VARCHAR(50) NOT NULL,
        Item_Identifier         VARCHAR(50) NOT NULL,
        Item_Type               VARCHAR(50) NOT NULL,
        Outlet_Establishment_Year INT NOT NULL,
        Outlet_Identifier       VARCHAR(50) NOT NULL,
        Outlet_Location_Type    VARCHAR(50) NOT NULL,
        Outlet_Size             VARCHAR(50) NOT NULL,
        Outlet_Type             VARCHAR(50) NOT NULL,
        Item_Visibility         FLOAT NOT NULL,
        Item_Weight             FLOAT NULL,
        Total_Sales             FLOAT NOT NULL,
        Rating                  FLOAT NOT NULL
    );
END
GO

-- Step 4: Ensure database is read/write
ALTER DATABASE Blinkitdbo SET READ_WRITE;
GO