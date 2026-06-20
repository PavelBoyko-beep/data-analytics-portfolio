# Online Retail Sales Analysis

## Project Overview

This project analyzes e-commerce transaction data from an online retail store.
The goal was to clean the raw sales data, separate valid sales from problematic records, calculate key business metrics, and build an Excel dashboard with the main sales insights.

The analysis focuses only on **clean sales**. Cancelled invoices, negative quantities, zero or negative prices, and rows with missing `CustomerID` were excluded from the main sales analysis.

---

## Dataset

The dataset contains online retail transactions with the following fields:

| Column        | Description                  |
| ------------- | ---------------------------- |
| `InvoiceNo`   | Invoice/order number         |
| `StockCode`   | Product code                 |
| `Description` | Product name                 |
| `Quantity`    | Number of units purchased    |
| `InvoiceDate` | Date and time of transaction |
| `UnitPrice`   | Price per unit               |
| `CustomerID`  | Customer identifier          |
| `Country`     | Customer country             |

Each row represents one product line inside an invoice.
One invoice can contain multiple product rows.

---

## Data Cleaning Logic

A new calculated column `Revenue` was created:

```text
Revenue = Quantity × UnitPrice
```

A new classification column `RowType` was also created to separate clean and problematic records:

| RowType               | Logic                       |
| --------------------- | --------------------------- |
| `Cancelled invoice`   | `InvoiceNo` starts with `C` |
| `Negative quantity`   | `Quantity < 0`              |
| `Zero/negative price` | `UnitPrice <= 0`            |
| `Missing customer`    | `CustomerID` is missing     |
| `Clean sale`          | Valid sale row              |

Only rows classified as `Clean sale` were used for the main sales analysis.

---

## Data Quality Summary

| Metric              |   Value |
| ------------------- | ------: |
| Total rows          | 541,909 |
| Missing CustomerID  | 135,080 |
| Missing Description |   1,454 |
| Negative Quantity   |  10,624 |
| Zero Quantity       |       0 |
| UnitPrice <= 0      |   2,517 |
| Cancelled invoices  |   9,288 |
| Clean sale rows     | 397,884 |
| Clean Rows %        |  73.42% |
| Excluded Revenue %  |   8.58% |

---

## Key Metrics

| Metric               |     Value |
| -------------------- | --------: |
| Clean Revenue        | 8,911,408 |
| Clean Orders         |    18,532 |
| Average Order Value  |    480.87 |
| Clean Customers      |     4,338 |
| Revenue per Customer |  2,054.27 |
| Orders per Customer  |      4.27 |
| Total Clean Quantity | 5,167,812 |

---

## Business Insights

### 1. Strong country concentration

The United Kingdom generated **82.01%** of total clean revenue.

This shows that the business is highly dependent on one market.
If sales in the UK decline, total revenue could be strongly affected.

---

### 2. Revenue increased strongly before the holiday season

Monthly revenue increased sharply from September to November 2011.

The highest full month was:

| Month         | Clean Revenue |
| ------------- | ------------: |
| November 2011 |  1,161,817.38 |

December 2011 should not be treated as a full-month decline because the dataset includes data only until early December.

---

### 3. Product revenue is spread across many items

Top 10 products generated only **9.95%** of total clean revenue.

This means the business does not depend heavily on one or a few products.

---

### 4. Sales volume is also distributed across many products

Top 10 products by quantity accounted for **8.70%** of all clean units sold.

This suggests that product demand is spread across a wide product catalog.

---

### 5. Moderate customer concentration

Top 10 customers generated **17.26%** of total clean revenue.

This means the business has some dependence on large customers, but the concentration is not as extreme as the country-level concentration.

---

## Dashboard

The Excel dashboard includes:

* Key Metrics
* Executive Summary
* Monthly Clean Revenue chart
* Top Countries by Revenue
* Top Customers by Revenue
* Top Products by Revenue
* Top Products by Quantity

---

## Tools Used

* Microsoft Excel
* Power Query
* Pivot Tables
* Pivot Charts
* Basic data cleaning and KPI calculation

---

## Files

| File                                | Description                                                               |
| ----------------------------------- | ------------------------------------------------------------------------- |
| `online_retail_sales_analysis.xlsx` | Main Excel file with cleaned data, QA checks, pivot tables, and dashboard |
| `README.md`                         | Project documentation                                                     |

---

## Final Conclusion

This project demonstrates a full beginner-level data analysis workflow:

1. Importing raw CSV data
2. Fixing data type issues
3. Creating calculated fields
4. Classifying valid and problematic records
5. Building data quality checks
6. Calculating business KPIs
7. Creating pivot tables
8. Building an Excel dashboard
9. Writing business insights based on data

The main business risk identified in this analysis is the strong dependence on the United Kingdom market, which accounts for more than 80% of total clean revenue.

