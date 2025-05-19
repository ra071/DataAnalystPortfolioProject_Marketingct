use PortfolioProject_MarketingAnalytics;

select * from dbo.engagement_data;

-- ***********************************************************************
-- ***********************************************************************

--SQL Query to clean and normalize the engagement_data table

SELECT
	EngagementID,
	ContentID,
	CampaignID,
	ProductID,
	UPPER(REPLACE(ContentType, 'socialmedia', 'Social Media')) As ContentType,
	LEFT(ViewsClicksCombined, CHARINDEX('-', ViewsClicksCombined) - 1) AS VIEWS,
	RIGHT(ViewsClicksCombined, LEN(ViewsClicksCombined) - CHARINDEX('-', ViewsClicksCombined)) As Clicks,
	Likes,
	FORMAT(CONVERT(DATE,EngagementDate), 'dd.MM.yyyy') As EngagementDate
FROM dbo.engagement_data
WHERE ContentType != 'NEWSLETTER';