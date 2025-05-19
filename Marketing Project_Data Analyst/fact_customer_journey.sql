use PortfolioProject_MarketingAnalytics;

select * from dbo.customer_journey;

-- ***********************************************************************
-- ***********************************************************************

-- Common-Table Expression (CTE) to identify and tag duplicate records

With DuplicateRecords AS(
SELECT
	JourneyID,
	CustomerID,
	ProductID,
	VisitDate,
	Stage,
	Action,
	Duration,
	-- Use ROW_NUMBER() to assign a unique row number to each record within the partition defined below
	ROW_NUMBER() 
		OVER(
			-- PARTITION BY groups the rows based on the specified columns that should be unique
			PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action
			-- -- ORDER BY defines how to order the rows within each partition (usually by a unique identifier like JourneyID)
			ORDER BY JourneyID
			) As row_num -- This creates a new column 'row_num' that numbers each row within its partition
FROM customer_journey
)

SELECT * FROM DuplicateRecords
-- WHERE row_num > 1  -- Filters out the first occurrence (row_num = 1) and only shows the duplicates (row_num > 1)
ORDER BY JourneyID;

-- Outer Query selects the final cleaned and standardized data

SELECT 
	JourneyID,
	CustomerID,
	ProductID,
	VisitDate,
	Stage,
	Action,
	COALESCE(Duration, avg_duration) AS Duration-- Replaces missing durations with the average duration for the corresponding date
	FROM
		-- subquery to process and clean the data
		(
		SELECT 
			JourneyID,
			CustomerID,
			ProductID,
			VisitDate,
			UPPER(Stage) AS Stage,
			Action,
			Duration,
			AVG(Duration) OVER(PARTITION BY VisitDate) AS avg_duration, -- Calculates the average duration for each date, using only numeric values
			ROW_NUMBER() OVER (
                PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action  -- Groups by these columns to identify duplicate records
                ORDER BY JourneyID  -- Orders by JourneyID to keep the first occurrence of each duplicate
            ) AS row_num
		FROM dbo.customer_journey) AS subquery -- Names the subquery for reference in the outer query
		WHERE row_num = 1; -- Keeps only the first occurrence of each duplicate group identified in the subquery

		--AND Duration is not null;