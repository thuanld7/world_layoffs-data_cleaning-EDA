-- DATA CLEANING

-- 1. Remove duplicates
-- 2. Standardize data
-- 3. Null & blank values
-- 4. Remove any columns or rows


-- 1. Remove duplicates
SELECT *
FROM layoffs_staging;

WITH duplicates_cte AS (
    SELECT 	*,
    		ROW_NUMBER() OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, date, stage, country, funds_raised_millions ORDER BY company) AS row_num
    FROM layoffs_staging
)
DELETE *
FROM duplicates_cte 
WHERE row_num > 1;

-- 2. Standardize data
-- Check for any extra space
SELECT company, TRIM(company)
FROM layoffs_staging;
-- Remove extra space
UPDATE layoffs_staging
SET company = TRIM(company);
-- Double check
SELECT company, TRIM(company)
FROM layoffs_staging;

-- Checking name of industry
SELECT DISTINCT industry
FROM layoffs_staging
ORDER BY industry;
-- Standardize name of Crypto industry
SELECT *
FROM layoffs_staging
WHERE industry LIKE 'crypto%';

UPDATE layoffs_staging
SET industry = 'Crypto'
WHERE industry LIKE 'crypto%';

-- Checking name of country
SELECT DISTINCT country
FROM layoffs_staging
ORDER BY country;
-- Standardize name of United States
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging
ORDER BY country;

UPDATE layoffs_staging
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United STATES%';

-- Checking name of location
SELECT DISTINCT location, country
FROM layoffs_staging
ORDER BY country, location;
-- Standardize name of Dusseldorf location
SELECT *
FROM layoffs_staging
WHERE location LIKE '%sseldorf';

UPDATE layoffs_staging
SET location = 'Dusseldorf'
WHERE location LIKE '%sseldorf';
-- Standardize name of Malmo location
SELECT *
FROM layoffs_staging
WHERE location LIKE 'mal%';

UPDATE layoffs_staging
SET location = 'Malmo'
WHERE location LIKE 'mal%';

-- Standardize [date] data types
SELECT 
    [date],
    CONVERT(DATE, [date], 101) AS converted_date
FROM layoffs_staging;

UPDATE layoffs_staging
SET [date] = TRY_CONVERT(DATE, [date], 101);

ALTER TABLE layoffs_staging
ALTER COLUMN [date] DATE;


-- 3. Null & blank values
-- Take a look of the data
SELECT *
FROM layoffs_staging
WHERE industry = 'null'
	OR industry = ' ';
-- Change 'null' text values to true null values
UPDATE layoffs_staging
SET industry = NULL
WHERE industry = 'null'
	OR industry = ' ';
-- Check
SELECT *
FROM layoffs_staging
WHERE industry IS NULL;

SELECT *
FROM layoffs_staging
WHERE company = 'Airbnb';

SELECT T1.industry, T2.industry
FROM layoffs_staging T1
JOIN layoffs_staging T2
	ON T1.company = T2.company
	AND T1.location = T2.location
WHERE T1.industry IS NULL
	AND T2.industry IS NOT NULL;

-- Synchronize industry name when same company name at same location
UPDATE T1
SET T1.industry = T2.industry
FROM layoffs_staging T1
JOIN layoffs_staging T2
	ON T1.company = T2.company
	AND T1.location = T2.location
WHERE T1.industry IS NULL
	AND T2.industry IS NOT NULL;
-- Check
SELECT *
FROM layoffs_staging
WHERE industry IS NULL;
-- And okay, we did it. Except for "Bally's Interactive" because they only appeared once so there was no reference to fix.


-- 4. Remove any columns or rows
-- Change 'null' text values to true null values
UPDATE layoffs_staging
SET total_laid_off = NULL
WHERE total_laid_off = 'null'
	OR total_laid_off = ' ';

UPDATE layoffs_staging
SET percentage_laid_off = NULL
WHERE percentage_laid_off = 'null'
	OR percentage_laid_off = ' ';

UPDATE layoffs_staging
SET funds_raised_millions = NULL
WHERE funds_raised_millions = 'null'
	OR funds_raised_millions = ' ';
-- Remove records if total_laid_off is null and percentage_laid_off is null
SELECT *
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE
FROM layoffs_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- Final clean data
SELECT *
FROM layoffs_staging;
