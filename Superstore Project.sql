-- Checking structure and what columns exist and which are numeric or categories
EXEC sp_help superstore


-- Converting Profit to a numeric columnn
--- 1. Checking if there is any non numeric values within the column 
SELECT Profit
FROM Superstore
WHERE TRY_CAST(Profit AS float) is NULL
AND Profit is not null

--- 2. Changing the column type
ALTER TABLE Superstore
ALTER COLUMN Profit FLOAT 


-- Checking for missing values
SELECT COUNT(*)
FROM Superstore
WHERE Sales IS NULL OR Profit IS NULL
-- no null values


-- Creating a cleaned view 
CREATE VIEW superstore_cleaned AS
SELECT *
FROM Superstore
WHERE Sales IS NOT NULL
AND Profit IS NOT NULL 


-- Overall Business Performance 
SELECT 
SUM(Sales) AS Total_Sales,
SUM(Profit) AS Total_Profit
FROM superstore_cleaned


-- KPI Summary
SELECT 
SUM(Sales) AS Total_Sales,
SUM(Profit) AS Total_Profit,
CASE 
WHEN SUM(Sales) = 0 THEN 0 
ELSE SUM(Profit) / SUM(Sales)
END AS Profit_Margin 
FROM superstore_cleaned


-- Profit by Product Category  
SELECT 
Category, 
SUM(Sales) AS total_sales,
SUM(Profit) AS total_profit
FROM superstore_cleaned
GROUP BY Category
ORDER BY total_profit DESC


-- Profit by Region 
SELECT 
Region, 
SUM(Sales) AS total_sales,
SUM(Profit) AS total_profit
FROM superstore_cleaned
GROUP BY Region
ORDER BY total_profit DESC


-- Loss making Sub-Catgories
SELECT 
Sub_Category, 
SUM(Profit) AS total_profit
FROM superstore_cleaned
GROUP BY Sub_Category
HAVING SUM(Profit) < 0 
ORDER BY total_profit 


-- SQL Views for Tableau 
CREATE VIEW view_kpi_summary AS
SELECT 
SUM(Sales) AS Total_Sales,
SUM(Profit) AS Total_Profit,
CASE 
WHEN SUM(Sales) = 0 THEN 0 
ELSE SUM(Profit) / SUM(Sales)
END AS Profit_Margin 
FROM superstore_cleaned


CREATE VIEW view_profit_by_category AS
SELECT 
Category, 
SUM(Sales) AS total_sales,
SUM(Profit) AS total_profit
FROM superstore_cleaned
GROUP BY Category


CREATE VIEW view_profit_by_region AS
SELECT 
Region, 
SUM(Sales) AS total_sales,
SUM(Profit) AS total_profit
FROM superstore_cleaned
GROUP BY Region


CREATE VIEW view_loss_by_subcategory AS
SELECT 
Sub_Category, 
SUM(Profit) AS total_profit
FROM superstore_cleaned
GROUP BY Sub_Category
HAVING SUM(Profit) < 0


