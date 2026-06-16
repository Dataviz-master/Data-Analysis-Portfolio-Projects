BULK INSERT WalmartSales_Staging
FROM 'C:\Users\DDC\Downloads\walmart_sales.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0a'
);
