# SQL Data Cleaning Project: Messy Shop Orders

## Overview
A practice dataset of shop orders with deliberately planted data quality problems: missing values, duplicates, wrong data types, inconsistent spelling and capitalization, and mixed date formats. I cleaned it using only SQL in MySQL Workbench.

**Tools:** MySQL, MySQL Workbench
**Rows before cleaning:** 39
**Rows after cleaning:** 34 (5 duplicate rows removed)

## Files
- `messy_orders.sql`: creates and loads the raw table
- `cleaning_steps.sql`: every cleaning query, in the order I ran it
- `orders_cleaned.csv`: the final cleaned data
- `README.md`: this file

> **Note on the CSV:** Phone numbers are stored as text so leading zeros are kept. Excel may hide the zero when opening the CSV directly. To view them correctly, use Data > From Text/CSV and set the phone column to Text. Don't re-save the CSV from Excel, or the zeros are lost.

## Cleaning Checklist

| # | Problem | Example found | How I found it | How I fixed it | Rows affected |
|---|---------|---------------|----------------|----------------|---------------|
| 1 | No safety copy | n/a | n/a | Made a backup of the raw table before any cleaning, using `CREATE TABLE ... AS SELECT` | 39 |
| 2 | Extra spaces | `'  Sunday Okon'` | Compared column to `TRIM(column)` | `TRIM()` | 7 columns |
| 3 | Inconsistent capitalization | `delivered`, `DELIVERED` | `SELECT DISTINCT` | `LOWER()` / `UPPER()` | 7 columns |
| 4 | Misspellings | `Lgos`, `Abudja`, `Delivred`, `Electrnics` | `SELECT DISTINCT` | `UPDATE ... WHERE` | 9 |
| 5 | Missing values | `''`, `N/A`, `unknown`, `NULL` | `WHERE col IS NULL OR col = ''` | Set to `NULL`; filled only where other rows gave the answer | 9 |
| 6 | Mixed date formats | `05/01/2026`, `Jan 7, 2026`, `11-Jan-2026` | Looked at the distinct values | `STR_TO_DATE()` inside a `CASE`, stored as `DATE` | 1 column |
| 7 | Wrong data types | quantity `'one'`, price `'NGN 12,000'` | `NOT REGEXP` checks | `REPLACE()`, then `MODIFY` to `INT` and `DECIMAL(10,2)` | 4 rows (3 columns) |
| 8 | Invalid values | quantity `-1`, blender price `2800000` | Compared to other rows of the same product | Corrected (see decisions) | 2 |
| 9 | Duplicates | order `1010` appears 3 times | `GROUP BY ... HAVING COUNT(*) > 1` | `SELECT DISTINCT` into a new table | 5 |
| 10 | Inconsistent phone formats | `0803 987 6543`, `+2348051112222` | `WHERE phone NOT REGEXP '^0[0-9]{10}$'` | `REPLACE()` to remove spaces; converted `+234` to a leading `0` | 2 |

## Decisions I Made

**Dates.** Slash dates were treated as DD/MM/YYYY, because some slash dates, like `15/01/2026`, can't be MM/DD, which settles the format. Dates are stored as a real `DATE` (YYYY-MM-DD) so they sort and calculate correctly.

**Missing values.** I filled a blank only when other rows could prove the answer, and otherwise left it `NULL`, because a made-up value is worse than an honest gap.
- Missing category: recovered from other rows of the same product.
- Order 1032 price (`unknown`): all other Bluetooth Speakers cost 12,000, so I filled it with 12,000.
- Order 1033 date: neighbouring order IDs place it between 2 and 3 February, but the exact day can't be known, so it stays `NULL`.
- Order 1014 quantity (blank): no other row could supply it, so it stays `NULL`.
- Order 1029 customer name, order 1030 city and order 1034 status (all blank): nothing in other rows could supply them, so I set them to `NULL`.
- 2 emails and 4 phone numbers: each customer appears only once, so nothing could recover them. I left them `NULL` instead of inventing values.

**Text numbers.** Quantities written as words (`one`, `three`) were converted to digits (`1`, `3`). Prices written as `NGN 12,000` had the `NGN ` and the comma removed so the column could become `DECIMAL`.

**Broken email.** All other emails end in `@mail.com`, so I completed `ngozi.nwosu@mail` as `.com`. This is only safe because the whole dataset uses one email provider. In real data with mixed providers, I would leave it `NULL`.

**Outliers.**
- Order 1025: a blender listed at 2,800,000. Every other blender costs 28,000, so I corrected it as an extra-zero typo.
- Order 1017: charger price `$5` was a wrong entry. Every other phone charger costs 3,500, so I changed it to 3,500.
- Order 1018: quantity `-1`. A negative quantity is impossible and the order was cancelled, so I set it to 1.

**Phone numbers** stay as text, not numbers, for two reasons: they are never calculated with, and a number type would drop the leading `0`.

**Duplicates.** I cleaned spelling and spacing first, because `'FATIMA BELLO'` and `'fatima bello '` would otherwise look like different rows. Then I kept one copy of each repeated order.

## Key Queries

**Backup** (Step 1: a backup copy of the raw data was made before any cleaning, so the original could always be restored)
```sql
CREATE TABLE messy_orders_backup AS
SELECT * FROM messy_orders;
```

**Trim spaces**
```sql
UPDATE messy_orders
SET customer_name = TRIM(customer_name),
    email         = TRIM(email),
    city          = TRIM(city);
```

**Convert mixed dates**
```sql
UPDATE messy_orders
SET order_date_clean = CASE
  WHEN order_date REGEXP '^[0-9]{4}-[0-9]{2}-[0-9]{2}$' THEN STR_TO_DATE(order_date, '%Y-%m-%d')
  WHEN order_date REGEXP '^[0-9]{2}/[0-9]{2}/[0-9]{4}$' THEN STR_TO_DATE(order_date, '%d/%m/%Y')
  -- ...one WHEN per format; full version in cleaning_steps.sql
END
WHERE order_date IS NOT NULL;
```

**Clean prices**
```sql
UPDATE messy_orders
SET unit_price = REPLACE(REPLACE(unit_price, 'NGN ', ''), ',', '')
WHERE unit_price LIKE 'NGN%';
```

**Change column types**
```sql
ALTER TABLE messy_orders
  MODIFY order_id   INT,
  MODIFY quantity   INT,
  MODIFY unit_price DECIMAL(10,2);
```

**Fix invalid values**
```sql
UPDATE messy_orders SET quantity = 1 WHERE quantity = -1;
UPDATE messy_orders SET unit_price = 28000 WHERE unit_price = 2800000;
```

**Remove duplicates**
```sql
CREATE TABLE orders_clean AS
SELECT DISTINCT * FROM messy_orders;
```

## Before and After
**Before (raw data)**

| order_id | customer_name | email | phone | city | quantity | unit_price | order_date | status |
|---|---|---|---|---|---|---|---|---|
| 1002 | `  chinedu eze` | `Chinedu.Eze@mail.com ` | `0803 987 6543` | `lagos` | `1` | `3500.00` | `05/01/2026` | `delivered` |
| 1005 | `Ngozi Nwosu` | `ngozi.nwosu@mail` | `07066667777` | `Port Harcourt` | `one` | `45000` | `08/01/2026` | `Delivered` |
| 1017 | `Victor Okoro` | `victor.okoro@mail.com` | `08033332222` | `PH` | `3` | `$5` | `2026-01-18` | `Delivered` |

**After (cleaned)**

| order_id | customer_name | email | phone | city | quantity | unit_price | order_date | status |
|---|---|---|---|---|---|---|---|---|
| 1002 | `chinedu eze` | `chinedu.eze@mail.com` | `08039876543` | `lagos` | `1` | `3500.00` | `2026-01-05` | `delivered` |
| 1005 | `ngozi nwosu` | `ngozi.nwosu@mail.com` | `07066667777` | `port harcourt` | `1` | `45000.00` | `2026-01-08` | `delivered` |
| 1017 | `victor okoro` | `victor.okoro@mail.com` | `08033332222` | `port harcourt` | `3` | `3500.00` | `2026-01-18` | `delivered` |

**What changed:** extra spaces trimmed, text made lowercase, `PH` standardized to `port harcourt`, the broken email completed, phone numbers standardized to one local format, `one` converted to `1`, `$5` corrected to 3,500, and all dates converted to the standard `DATE` format.

## Validation
```sql
-- no duplicates left
SELECT order_id, COUNT(*) FROM orders_clean GROUP BY order_id HAVING COUNT(*) > 1;   -- 0 rows

-- row count after cleaning
SELECT COUNT(*) FROM orders_clean;   -- 34

-- column types are correct
DESCRIBE orders_clean;

-- spellings are consistent
SELECT DISTINCT city FROM orders_clean;
SELECT DISTINCT status FROM orders_clean;
SELECT DISTINCT category FROM orders_clean;

-- remaining missing emails
SELECT COUNT(*) - COUNT(email) AS missing_emails FROM orders_clean;   -- 2
```

**Remaining missing values (left on purpose):** 2 emails, 4 phone numbers, 1 order date, 1 quantity, 1 customer name, 1 city, 1 status. None could be recovered from other rows.

## What I Learned
- Clean spelling and spacing before removing duplicates, or some duplicates stay hidden.
- Fill a missing value only when the data proves the answer. Otherwise leave it `NULL`.
- Store values in the right data type: phone numbers as text, dates as `DATE`, prices as `DECIMAL`.
- Always keep a backup and preview an `UPDATE` as a `SELECT` first.

---
*The SQL cleaning, decisions and validation in this project are my own work. I used Claude (an AI assistant) to help draft and format this README.*
