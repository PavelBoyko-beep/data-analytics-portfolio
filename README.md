# Data Analytics Portfolio

This repository contains my data analytics portfolio projects.

The goal of this portfolio is to demonstrate practical data analyst skills through end-to-end business cases:

```text
business problem → dataset → data quality → analysis → dashboard → insights → recommendations → portfolio documentation
```

Each project is designed to show not only technical tools, but also business thinking, clear documentation, and the ability to communicate findings.

---

## Projects

| # | Project | Tools | Description |
|---:|---|---|---|
| 01 | [Online Retail Sales Analysis](./01-online-retail-sales-analysis) | Excel, Power Query, Pivot Tables | E-commerce sales analysis with data cleaning, KPI calculation, dashboard, and business insights |
| 02 | [SaaS Churn & Revenue Analysis](./saas-churn-revenue-analysis) | PostgreSQL, SQL, Python, pandas, Power BI | SQL-first SaaS analytics case focused on recurring revenue, churn, support risk, dashboarding, insights, and recommendations |

---

## Project 01 — Online Retail Sales Analysis

### Overview

This project analyzes online retail sales data using Excel.

The goal is to clean the data, calculate key sales KPIs, build a dashboard, and generate business insights.

### Main skills demonstrated

- Excel data cleaning;
- Power Query transformations;
- pivot tables;
- KPI calculation;
- dashboard creation;
- business insight generation;
- GitHub project documentation.

### Project link

[Open Online Retail Sales Analysis](./01-online-retail-sales-analysis)

---

## Project 02 — SaaS Churn & Revenue Analysis

### Overview

This project analyzes a fictional SaaS company with subscription-based revenue.

The goal is to understand:

- how current recurring revenue is distributed;
- which plan tiers generate the most MRR;
- how churn changes over time;
- which churn reasons appear most often;
- whether support escalation is connected with churn risk.

This is a SQL-first portfolio case. SQL was used as the main analysis tool, while Python was used for data quality checks and lightweight visual EDA. Power BI was used to present the final business findings.

### Main business questions

1. How much current MRR and ARR does the company have?
2. Which plan tiers contribute the most to current recurring revenue?
3. Which plan tiers have the highest average revenue per account and subscription?
4. How does churn change over time?
5. What are the most common churn reasons?
6. Which plan tiers show the highest estimated churn rate?
7. Are support escalations higher among churned accounts?
8. Is current revenue concentrated in a few large accounts?

### Main skills demonstrated

- data understanding;
- data quality checks;
- PostgreSQL database setup;
- SQL table creation and import scripts;
- SQL joins, aggregations, CTEs and business metrics;
- recurring revenue analysis;
- churn analysis;
- support risk analysis;
- Python / pandas validation and visual EDA;
- Power BI dashboard creation;
- business insights and recommendations;
- portfolio-ready README documentation.

### Dashboard preview

The Power BI dashboard includes 3 pages:

| Page | Purpose |
|---|---|
| Executive Overview | High-level business performance summary |
| Revenue Analysis | Revenue distribution by plan tier and top accounts |
| Churn & Support Risk | Churn patterns, churn reasons, and support escalation signals |

![SaaS Executive Overview](./saas-churn-revenue-analysis/dashboard/screenshots/executive_overview.jpg)

### Key findings

- Current MRR is **10.26M** and current ARR is **123.11M**.
- Enterprise is the main revenue driver and contributes **74.46%** of current MRR.
- Enterprise has the highest average MRR per account and per subscription.
- Churn increases toward the end of the reporting period.
- Feature-related churn is the top reported churn reason.
- Enterprise has the highest estimated churn rate in the latest reporting month.
- Churned accounts have a slightly higher support escalation rate.
- Revenue concentration is relatively low: the top 20 accounts contribute about **14.49%** of current MRR.

### Project link

[Open SaaS Churn & Revenue Analysis](./saas-churn-revenue-analysis)

---

## Skills Demonstrated

### Data Analysis

- data cleaning;
- data quality checks;
- missing value analysis;
- duplicate checks;
- primary key and foreign key validation;
- date logic checks;
- KPI calculation;
- business metric design;
- exploratory data analysis;
- business insight generation.

### SQL / PostgreSQL

- table creation;
- data import validation;
- joins;
- aggregations;
- CTEs;
- revenue metrics;
- churn metrics;
- support metrics;
- SQL-based business analysis.

### Python / pandas

- CSV loading;
- row count validation;
- data quality checks;
- basic pandas transformations;
- simple visual summaries;
- lightweight EDA.

### Excel / Power Query

- data cleaning;
- Power Query transformations;
- pivot tables;
- KPI summaries;
- Excel dashboard building.

### Power BI

- data import;
- relationship modeling;
- DAX measures;
- KPI cards;
- bar charts;
- line charts;
- dashboard page structure;
- business dashboard storytelling.

### GitHub / Portfolio Packaging

- clean project folder structure;
- README documentation;
- dataset source documentation;
- data dictionary;
- SQL scripts;
- notebook organization;
- dashboard screenshots;
- final insights and recommendations.

---

## Portfolio Structure

```text
data-analytics-portfolio/
├── 01-online-retail-sales-analysis/
├── saas-churn-revenue-analysis/
└── README.md
```

---

## Current Portfolio Status

| # | Project | Status |
|---:|---|---|
| 01 | Online Retail Sales Analysis | Complete |
| 02 | SaaS Churn & Revenue Analysis | Complete |

---

## About

This portfolio is part of my transition into data analytics.

Each project is built as a practical business case and includes:

- source data or dataset documentation;
- data cleaning and quality checks;
- analysis files;
- dashboard screenshots;
- business insights;
- recommendations;
- clear GitHub documentation.

The main goal is to show a realistic analyst workflow from raw data to business conclusions.
