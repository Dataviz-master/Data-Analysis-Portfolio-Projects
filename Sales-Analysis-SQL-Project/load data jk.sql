
-- Drop the primary key constraint first (replace with your actual PK name)
ALTER TABLE dbo.sales
DROP CONSTRAINT PK__sales__85C600AF97D4E522;
GO

-- Make transaction_id nullable
ALTER TABLE dbo.sales
ALTER COLUMN transaction_id NVARCHAR(50) NULL;
GO

-- 4️⃣ Set date format for BULK INSERT
SET DATEFORMAT dmy;
GO

SET DATEFORMAT dmy;
GO

-- 5️⃣ Load CSV data
BULK INSERT dbo.sales
FROM 'C:\Users\DDC\Downloads\sales.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n'
);
GO
-- 6️⃣ Confirm table creation
SELECT TOP 10 * FROM dbo.sales;
GO