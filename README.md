# SQL-Powered Analysis of Global Layoffs (2020-2023)

## Overview

This project provides a comprehensive analysis of a global layoffs dataset covering the period from 2020 to 2023. Using SQL, this project demonstrates a full data workflow: starting from raw, messy data and progressing to a clean, standardized dataset ready for exploratory analysis. The analysis uncovers key trends and insights into the recent wave of job cuts across various industries and countries.

***

## Dataset

The dataset used is `layoffs.csv`, which contains information about company layoffs, including:
* Company name and location
* Industry
* Total number of employees laid off
* Percentage of the workforce laid off
* Date of the layoff
* Company's funding stage and funds raised

***

## Project Workflow

The project is divided into two main SQL scripts, reflecting a standard data analysis methodology.

### 1. Data Cleaning (`DataCleaning.sql`)

A staging table (`layoffs_staging2`) was created to ensure the raw data remained intact. The cleaning process involved several key steps:

* **Duplicate Removal:** Identified and removed fully duplicate rows using the `ROW_NUMBER()` window function partitioned by all columns.
* **Data Standardization:** Trimmed whitespace from company names and standardized inconsistent values in the `industry` and `country` columns (e.g., merging 'Crypto%', 'Crypto Currency', and 'CryptoCurrency' into a single 'Crypto' category).
* **Data Type Conversion:** Converted the `date` column from a text/string format to a proper `DATE` data type for accurate time-series analysis.
* **Handling Null & Blank Values:** Populated `NULL` or blank `industry` values by cross-referencing other entries from the same company. Rows with no meaningful layoff data (where both `total_laid_off` and `percentage_laid_off` were null) were removed.

### 2. Exploratory Data Analysis (`EDA.sql`)

With a clean and reliable dataset, the analysis focused on answering key questions and identifying trends:

* **Impact Analysis:** Identified the companies, industries, and locations most affected by layoffs.
* **Time-Series Analysis:** Analyzed the total number of layoffs on a yearly and monthly basis to spot trends and peak periods.
* **Cumulative Trends:** Calculated a rolling total of layoffs over time to visualize the cumulative impact and growth rate of job cuts.
* **Company Ranking:** Ranked the top 5 companies with the highest number of layoffs for each year using the `DENSE_RANK()` window function.

***

## Tools Used

* **Language:** SQL
* **Database:** MySQL

***

## How to Use

To replicate this analysis, follow these steps:
1.  Create a MySQL database (e.g., `world_layoffs`).
2.  Import the data from `layoffs.csv` into a table named `layoffs` within your database.
3.  Run the entire `DataCleaning.sql` script. This will create a new, cleaned table named `layoffs_staging2`.
4.  Run the queries in the `EDA.sql` script against the `layoffs_staging2` table to perform the exploratory analysis.
