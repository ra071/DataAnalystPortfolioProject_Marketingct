use PortfolioProject_MarketingAnalytics;

select * from dbo.products;

-- ***********************************************************************
-- ***********************************************************************

-- Query to categorize products based on their price
SELECT ProductID, ProductName, Price,
	CASE
		WHEN Price < 50 THEN 'LOW'
		WHEN Price BETWEEN 50 AND 200 THEN 'Medium'
		ELSE 'HIgh'
	END AS PriceCategory -- Names the new column as PriceCategory
FROM dbo.products;