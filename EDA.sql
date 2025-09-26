-- Exploratory Data Analysis --
USE world_layoffs;

SELECT * FROM layoffs_staging2;

-- querying companies having the maximum percentage of laying off employers
SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off = (SELECT MAX(percentage_laid_off) FROM layoffs_staging2)
ORDER BY total_laid_off DESC;

-- querying distinct conutries 
SELECT DISTINCT country from layoffs_staging2;


-- querying for top Indian companies that laid off workers
SELECT company, sum(total_laid_off)
FROM layoffs_staging2
WHERE country = 'INDIA'
GROUP BY company
ORDER BY 2 DESC;

-- range of dates for the given data
SELECT MIN(`date`), MAX(`date`) 
FROM layoffs_staging2;

-- querying top layoffs based on industry
SELECT industry, sum(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- querying location wise layoffs
SELECT DISTINCT location, sum(total_laid_off)
FROM layoffs_staging2
WHERE country = "India"
GROUP BY location
ORDER BY 2 DESC;



SELECT DISTINCT
    company, SUM(total_laid_off)
FROM
    layoffs_staging2
WHERE
    location = 'Bengaluru'
GROUP BY company
ORDER BY 2 DESC;

-- time series : querying number of layoffs year wise
SELECT YEAR(`date`) AS `YEAR`, SUM(total_laid_off) AS `TOTAL`
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;



-- querying number of layoffs year and month wise with a rolling total
SELECT * FROM layoffs_staging2;
WITH Rolling_Total AS 
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY `MONTH`
)
SELECT `MONTH`, total_off, 
SUM(total_off) OVER(ORDER BY `MONTH`) as rolling_total
FROM Rolling_Total
ORDER BY 1;

-- querying companies year wise layoffs 
SELECT company, YEAR(`date`) AS `year`, SUM(total_laid_off) AS total
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
HAVING total > 4000
ORDER BY 1;

-- querying top 5 companies every year with a total layoff sum
WITH Company_Year AS
(
SELECT company, YEAR(`date`) AS `year`, SUM(total_laid_off) AS total
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 1
), Company_Year_Rank AS
(
SELECT company, `year`, total, DENSE_RANK() OVER (PARTITION BY `year` ORDER BY total DESC) as Ranking
FROM Company_Year
WHERE `year` IS NOT NULL
)
SELECT company, `year`, total, Ranking
FROM Company_Year_Rank
WHERE Ranking <= 5;






































