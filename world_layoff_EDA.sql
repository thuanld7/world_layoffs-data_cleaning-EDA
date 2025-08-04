-- Exploratory Data Analysis
 
-- 1. Explore the Data Structure
-- View sample data
SELECT TOP 10 *
FROM layoffs_staging ls;

--Check row count
SELECT COUNT(*) AS total_rows FROM layoffs_staging ls;

-- 2. Exploratory Data Analysis
-- Top companies by total layoffs
SELECT TOP 10 company, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging
GROUP BY company
ORDER BY total_layoffs DESC;

-- Companies with 100% layoffs (Crash)
SELECT company, percentage_laid_off
FROM layoffs_staging
WHERE percentage_laid_off = 1;

-- Layoffs trend over the years
SELECT YEAR([date]) AS layoff_year, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging
WHERE [date] IS NOT NULL
GROUP BY YEAR([date])
ORDER BY layoff_year;

-- Average layoff percentage by industry
SELECT industry, AVG(percentage_laid_off) AS avg_layoff_percentage
FROM layoffs_staging
WHERE percentage_laid_off IS NOT NULL AND industry IS NOT NULL
GROUP BY industry
ORDER BY avg_layoff_percentage DESC;

-- Top countries with the most layoffs
SELECT country, SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging
GROUP BY country
ORDER BY total_layoffs DESC;

-- Layoffs by industry over time
SELECT 
  YEAR([date]) AS layoff_year,
  industry,
  COUNT(*) AS number_of_events,
  SUM(total_laid_off) AS total_layoffs
FROM layoffs_staging
WHERE [date] IS NOT NULL AND industry IS NOT NULL
GROUP BY YEAR([date]), industry
ORDER BY industry, layoff_year, total_layoffs DESC;

-- Rolling total of total_layoffs
WITH rolling_total AS (
SELECT SUBSTRING(CONVERT(VARCHAR, [date], 120), 1, 7) AS month_layoff,
		SUM(total_laid_off) AS total_off
FROM layoffs_staging
WHERE SUBSTRING(CONVERT(VARCHAR, [date], 120), 1, 7) IS NOT NULL
GROUP BY SUBSTRING(CONVERT(VARCHAR, [date], 120), 1, 7)
)
SELECT month_layoff, total_off, SUM(total_off) OVER(ORDER BY month_layoff)
FROM rolling_total 
ORDER BY month_layoff

-- Top 5 highest total_laid_off company per year
WITH company_year (company, years, total_laid_off) AS (
SELECT company, YEAR([date]), SUM(total_laid_off )
FROM layoffs_staging
WHERE YEAR([date]) IS NOT NULL
GROUP BY company, YEAR([date])
), 
company_year_ranking AS (
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM company_year
)
SELECT *
FROM company_year_ranking 
WHERE ranking <= 5
ORDER BY years

