# world_layoffs-data_cleaning

This project demonstrates how to clean raw layoff data using **Transact-SQL (T-SQL)**. The process involves identifying and fixing common data quality issues such as duplicates, inconsistent formatting, invalid or missing values, and unnecessary records. The final dataset is prepared for further analysis or reporting.

## 📁 Dataset

The data used is a CSV file containing company layoff information, including fields such as:

- `company`
- `location`
- `industry`
- `total_laid_off`
- `percentage_laid_off`
- `date`
- `stage`
- `country`
- `funds_raised_millions`

> Note: Raw data may contain incorrect formats like `'null'` as a string, extra spaces, or inconsistent naming conventions.

---

## Cleaning Steps
-- 1. Remove duplicates
-- 2. Standardize data
-- 3. Null & blank values
-- 4. Remove any columns or rows
