
-- SQL Project: Layoffs Data Cleaning and EDA
-- Dataset Source: https://www.kaggle.com/datasets/swaptr/layoffs-2022

/* -----------------------------------------
Step 1: Data Cleaning
----------------------------------------- */

-- 1. Create staging table
CREATE TABLE world_layoffs.layoffs_staging LIKE world_layoffs.layoffs;
INSERT INTO world_layoffs.layoffs_staging SELECT * FROM world_layoffs.layoffs;

-- 2. Remove duplicates
ALTER TABLE world_layoffs.layoffs_staging ADD row_num INT;

CREATE TABLE world_layoffs.layoffs_staging2 (
    company TEXT,
    location TEXT,
    industry TEXT,
    total_laid_off INT,
    percentage_laid_off TEXT,
    date TEXT,
    stage TEXT,
    country TEXT,
    funds_raised_millions INT,
    row_num INT
);

INSERT INTO world_layoffs.layoffs_staging2
SELECT company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions,
ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_staging;

DELETE FROM world_layoffs.layoffs_staging2 WHERE row_num >= 2;

/* -----------------------------------------
Step 2: Standardize Data
----------------------------------------- */

-- Handle nulls and standardize values
UPDATE world_layoffs.layoffs_staging2 SET industry = NULL WHERE industry = '';
UPDATE world_layoffs.layoffs_staging2 t1 JOIN world_layoffs.layoffs_staging2 t2 ON t1.company = t2.company
SET t1.industry = t2.industry WHERE t1.industry IS NULL AND t2.industry IS NOT NULL;

UPDATE world_layoffs.layoffs_staging2 SET industry = 'Crypto'
WHERE industry IN ('Crypto Currency', 'CryptoCurrency');

UPDATE world_layoffs.layoffs_staging2 SET country = TRIM(TRAILING '.' FROM country);

UPDATE world_layoffs.layoffs_staging2 SET date = STR_TO_DATE(date, '%m/%d/%Y');
ALTER TABLE world_layoffs.layoffs_staging2 MODIFY COLUMN date DATE;

/* -----------------------------------------
Step 3: Handle Null Values
----------------------------------------- */

DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

ALTER TABLE world_layoffs.layoffs_staging2 DROP COLUMN row_num;

/* -----------------------------------------
Step 4: Exploratory Data Analysis (EDA)
----------------------------------------- */

-- Max and Min Layoffs
SELECT MAX(total_laid_off) FROM world_layoffs.layoffs_staging2;
SELECT MAX(percentage_laid_off), MIN(percentage_laid_off) FROM world_layoffs.layoffs_staging2 WHERE percentage_laid_off IS NOT NULL;

-- Companies with 100% layoffs
SELECT * FROM world_layoffs.layoffs_staging2 WHERE percentage_laid_off = 1 ORDER BY funds_raised_millions DESC;

-- Companies with most layoffs
SELECT company, SUM(total_laid_off) AS total_laid_off_sum
FROM world_layoffs.layoffs_staging2
GROUP BY company
ORDER BY total_laid_off_sum DESC
LIMIT 10;

-- Locations with most layoffs
SELECT location, SUM(total_laid_off) AS total_laid_off_sum
FROM world_layoffs.layoffs_staging2
GROUP BY location
ORDER BY total_laid_off_sum DESC
LIMIT 10;

-- Countries with most layoffs
SELECT country, SUM(total_laid_off) AS total_laid_off_sum
FROM world_layoffs.layoffs_staging2
GROUP BY country
ORDER BY total_laid_off_sum DESC;

-- Year-wise layoffs
SELECT YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off_sum
FROM world_layoffs.layoffs_staging2
GROUP BY year
ORDER BY year ASC;

-- Industry-wise layoffs
SELECT industry, SUM(total_laid_off) AS total_laid_off_sum
FROM world_layoffs.layoffs_staging2
GROUP BY industry
ORDER BY total_laid_off_sum DESC;

-- Funding stage-wise layoffs
SELECT stage, SUM(total_laid_off) AS total_laid_off_sum
FROM world_layoffs.layoffs_staging2
GROUP BY stage
ORDER BY total_laid_off_sum DESC;

/* -----------------------------------------
Bonus: Advanced EDA Queries
----------------------------------------- */

-- Top 3 companies layoffs per year
WITH Company_Year AS (
  SELECT company, YEAR(date) AS year, SUM(total_laid_off) AS total_laid_off_sum
  FROM world_layoffs.layoffs_staging2
  GROUP BY company, year
),
Company_Year_Rank AS (
  SELECT company, year, total_laid_off_sum,
  DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off_sum DESC) AS ranking
  FROM Company_Year
)
SELECT company, year, total_laid_off_sum, ranking
FROM Company_Year_Rank
WHERE ranking <= 3 AND year IS NOT NULL
ORDER BY year ASC, total_laid_off_sum DESC;

-- Rolling Total Layoffs per Month
WITH Date_CTE AS (
  SELECT DATE_FORMAT(date, '%Y-%m') AS month, SUM(total_laid_off) AS total_laid_off_sum
  FROM world_layoffs.layoffs_staging2
  GROUP BY month
)
SELECT month, SUM(total_laid_off_sum) OVER (ORDER BY month) AS rolling_total_layoffs
FROM Date_CTE
ORDER BY month ASC;
