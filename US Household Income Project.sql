-- US Household Income Data Cleaning

SELECT * 
FROM US_Project.ushouseholdincome_statistics;

SELECT * 
FROM US_Project.us_household_income;

SELECT COUNT(id) 
FROM US_Project.ushouseholdincome_statistics;

SELECT COUNT(id)
FROM US_Project.us_household_income;

-- Search For Duplicates

SELECT id, COUNT(id)
FROM US_Project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1
;

SELECT id, COUNT(id)
FROM US_Project.ushouseholdincome_statistics
GROUP BY id
HAVING COUNT(id) > 1
;

SELECT *
FROM (
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM US_Project.us_household_income
) dupicates
WHERE row_num > 1
;

DELETE FROM US_Project.us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id,
		id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM US_Project.us_household_income
		) dupicates
WHERE row_num > 1)
;



SELECT DISTINCT State_Name
FROM US_Project.ushouseholdincome_statistics
ORDER BY 1
;

SELECT DISTINCT State_Name
FROM US_Project.us_household_income
ORDER BY 1
;

UPDATE US_Project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia'
;

SELECT *
FROM US_Project.us_household_income
WHERE Place = ''
ORDER BY 1
;

SELECT *
FROM US_Project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1
;

UPDATE US_Project.us_household_income
SET Place = 'Autagaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont'
;

SELECT Type, COUNT(Type)
FROM US_Project.us_household_income
GROUP BY Type
-- ORDER BY 1
;

SELECT ALand, AWater
FROM US_Project.us_household_income
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL
;

SELECT ALand, AWater
FROM US_Project.us_household_income
WHERE ALand = 0 OR ALand = '' OR ALand IS NULL
;

-- US Household Income Exploratory Data Analysis

SELECT * 
FROM US_Project.ushouseholdincome_statistics;

SELECT * 
FROM US_Project.us_household_income;

-- State with most are of land, water

SELECT State_Name, County, City, ALand, AWater 
FROM US_Project.us_household_income
;

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM US_Project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC -- Order by 2nd column
; 

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM US_Project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC -- Order by 3nd column
; 

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM US_Project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC 
LIMIT 10 -- Top 10 by land area
; 

SELECT State_Name, SUM(ALand), SUM(AWater)
FROM US_Project.us_household_income
GROUP BY State_Name
ORDER BY 3 DESC 
LIMIT 10 -- Top 10 by water area
; 

-- Perform Inner Join 

SELECT * 
FROM US_Project.us_household_income AS u
JOIN US_Project.ushouseholdincome_statistics AS us
	ON u.id = us.id
;

-- RIGHT Join and filter for NULL values

SELECT * 
FROM US_Project.us_household_income AS u
JOIN US_Project.ushouseholdincome_statistics AS us
	ON u.id = us.id
    WHERE u.id IS NULL
;

SELECT * 
FROM US_Project.us_household_income AS u
INNER JOIN US_Project.ushouseholdincome_statistics AS us
	ON u.id = us.id
    WHERE Mean <> 0
;

SELECT u.State_Name, County, Type, `Primary`, Mean, Median
FROM US_Project.us_household_income AS u
INNER JOIN US_Project.ushouseholdincome_statistics AS us
	ON u.id = us.id
    WHERE Mean <> 0
;

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Project.us_household_income AS u
INNER JOIN US_Project.ushouseholdincome_statistics AS us
	ON u.id = us.id
    WHERE Mean <> 0
     GROUP BY u.State_Name
     ORDER BY 2 -- Order by 2nd column = AVG Mean
;

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Project.us_household_income AS u
INNER JOIN US_Project.ushouseholdincome_statistics AS us
	ON u.id = us.id
    WHERE Mean <> 0
     GROUP BY u.State_Name
     ORDER BY 2 
     LIMIT 5 -- Lowest 5 avg income states
;

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Project.us_household_income AS u
INNER JOIN US_Project.ushouseholdincome_statistics AS us
	ON u.id = us.id
    WHERE Mean <> 0
     GROUP BY u.State_Name
     ORDER BY 3 DESC
     LIMIT 10 -- Top 10 median income states
;

SELECT u.State_Name, ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Project.us_household_income AS u
INNER JOIN US_Project.ushouseholdincome_statistics AS us
	ON u.id = us.id
    WHERE Mean <> 0
     GROUP BY u.State_Name
     ORDER BY 3 ASC
     LIMIT 10 -- Lowest 10 median income states
;

SELECT Type, COUNT(TYPE), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Project.us_household_income AS u
INNER JOIN US_Project.ushouseholdincome_statistics AS us
	ON u.id = us.id
    WHERE Mean <> 0
    GROUP BY Type
    ORDER BY 2 DESC
    LIMIT 20
;

-- Filter Outliers

SELECT Type, COUNT(TYPE), ROUND(AVG(Mean),1), ROUND(AVG(Median),1)
FROM US_Project.us_household_income AS u
INNER JOIN US_Project.ushouseholdincome_statistics AS us
	ON u.id = us.id
    WHERE Mean <> 0
    GROUP BY Type
    HAVING COUNT(TYPE) > 100
    ORDER BY 2 DESC
    LIMIT 20
;

-- Exploratory Data analysis on salaries from city type

SELECT u.State_Name, City, ROUND(AVG(MEAN),1)
FROM US_Project.us_household_income AS u
JOIN US_Project.ushouseholdincome_statistics AS us
	ON u.id = us.id
    GROUP BY u.State_Name, City
    ORDER BY ROUND(AVG(MEAN),1) DESC -- Order by Top 10 Highest Income Cities
    LIMIT 10
    ; 
