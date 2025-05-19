use PortfolioProject_MarketingAnalytics;

select * from dbo.customer_reviews;

-- ***********************************************************************
-- ***********************************************************************

-- SQL Query to clean whitespace issues in ReviewText column
SELECT 
	ReviewID,
	CustomerID,
	ProductID,
	ReviewDate,
	Rating,
	REPLACE(ReviewText, '  ', ' ') As ReviewText -- cleans up ReviewText by replacing double spaces with single spaces to ensure text is more readable and standardized.
FROM dbo.customer_reviews;