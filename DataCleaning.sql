-- DATA CLEANING --
USE world_layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs;

INSERT INTO layoffs_staging 
SELECT * FROM layoffs;

SELECT * FROM layoffs_staging;


-- REMOVING DUPLICATES

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;


WITH duplicate_removal AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) as row_num
FROM layoffs_staging
)
SELECT * FROM duplicate_removal
WHERE row_num = 2;


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_number` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location,
industry, total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) as row_num
FROM layoffs_staging;

SELECT * FROM layoffs_staging2;

DELETE FROM layoffs_staging2
WHERE `row_number` > 1;

SELECT * FROM layoffs_staging2;

-- Standardizing Data

SELECT * FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT * FROM layoffs_staging2;

SELECT DISTINCT industry 
FROM layoffs_staging2
ORDER BY 1;

SELECT * FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';


UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT distinct country FROM layoffs_staging2
ORDER BY 1;

SELECT * FROM layoffs_staging2
WHERE country LIKE 'United States%';


UPDATE layoffs_staging2
SET country = "United States"
WHERE country LIKE 'United States%';


SELECT `date`, str_to_date(`date`, '%m/%d/%Y')
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_staging2;


SELECT industry from layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';


SELECT * FROM layoffs_staging2
WHERE industry IS NULL;

SELECT * FROM layoffs_staging2
WHERE company = 'Carvana';


SELECT t1.company, t1.industry, t2.company, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;


UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
	SET t1.industry = t2.industry
    WHERE t1.industry IS NULL
	AND t2.industry IS NOT NULL;
    
SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN `row_number`;
