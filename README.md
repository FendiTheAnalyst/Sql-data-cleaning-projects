# SQL Data Cleaning Projects

Hands-on data cleaning projects using MySQL. Each project starts with a messy dataset and ends with clean, analysis-ready data, with every step and decision documented.

## Projects

| # | Project | Problems covered | Folder |
|---|---------|------------------|--------|
| 1 | Shop Orders Cleaning | Duplicates, missing values, wrong data types, inconsistent spelling and capitalization, mixed date formats | [01-shop-orders-cleaning](01-shop-orders-cleaning) |


## What's Inside Each Project Folder

| File | Purpose |
|------|---------|
| `README.md` | The full write-up: problems found, decisions made, key queries, before and after, and what I learned |
| `messy_*.sql` | Script that creates and loads the raw messy data |
| `cleaning_steps.sql` | Every cleaning query, in the order I ran it |
| `*_cleaned.csv` | The final cleaned data |

## Skills Demonstrated
- Finding and removing duplicate records
- Handling missing values, and knowing when to leave them as `NULL`
- Standardizing text: `TRIM`, `LOWER`, `UPPER`, `REPLACE`
- Converting mixed date formats with `STR_TO_DATE` and `CASE`
- Fixing data types with `ALTER TABLE ... MODIFY`
- Validating results with `COUNT`, `GROUP BY`, `HAVING` and `DISTINCT`
- Backing up data before making changes
- Documenting decisions clearly

## Tools
MySQL, MySQL Workbench

## About
Name: Moka Victoria
Email: ifechukwumoka@gmail.com
