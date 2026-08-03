# NYC Taxi Operations & Revenue Analysis

## Project Status

**In Progress — Case Setup**

## Project Overview

This project analyses real NYC Yellow Taxi trip records to understand demand patterns, recorded trip amounts, tipping behaviour, location performance, route activity, operational efficiency, and unusual trip records.

The project is designed as a SQL-first Data Analyst portfolio case. PostgreSQL and SQL will be used as the main analytical tools, while Python will support data understanding, data quality checks, and lightweight exploratory analysis. Power BI will be used for the final dashboard.

## Business Problem

A taxi company needs to understand when and where demand is strongest, which trips and locations generate the highest recorded trip amounts, and how driver allocation could be improved.

The main business question is:

> How can a taxi company improve revenue and operational efficiency using trip-level data?

## Dataset

The project uses NYC TLC Yellow Taxi Trip Records for January 2024.

Main files:

* `yellow_tripdata_2024-01.parquet` — trip-level taxi records;
* `taxi_zone_lookup.csv` — taxi zone and borough names.

The dataset is published by the New York City Taxi and Limousine Commission.

More information:

* [Dataset source](./docs/dataset_source.md)
* [Business questions](./docs/business_questions.md)

## Important Revenue Assumption

The `total_amount` field will initially be used as a proxy for gross trip revenue.

It is not treated as confirmed net revenue received by a taxi company because it may include fares, tips, tolls, taxes, surcharges, and other fees.

The project will distinguish between the recorded trip amount and its available components whenever the data allows it.

## Tools

* PostgreSQL;
* SQL;
* DBeaver;
* Python;
* pandas;
* Google Colab or Jupyter Notebook;
* Power BI;
* GitHub.

## Planned Analysis

The project will examine:

* total trip volume and recorded trip amounts;
* demand by date, weekday, and hour;
* pickup and drop-off zone activity;
* popular and high-value routes;
* payment and tipping behaviour;
* trip distance and duration;
* recorded trip amount per mile and per minute;
* zero, negative, extreme, or otherwise suspicious trip records;
* possible driver allocation and operational improvements.

## Project Workflow

```text
business problem
→ dataset source
→ data understanding
→ data quality
→ PostgreSQL setup
→ SQL business analysis
→ Python EDA
→ Power BI dashboard
→ insights and recommendations
→ GitHub packaging
```

## Project Structure

```text
nyc-taxi-operations-analysis/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_import_data.sql
│   ├── 03_data_quality_checks.sql
│   └── 04_business_analysis.sql
│
├── notebooks/
│   └── 01_data_understanding_eda.ipynb
│
├── dashboard/
│   ├── taxi_operations_dashboard.pbix
│   └── screenshots/
│
├── docs/
│   ├── dataset_source.md
│   ├── business_questions.md
│   ├── data_dictionary.md
│   ├── data_quality_summary.md
│   ├── dashboard_plan.md
│   └── insights.md
│
└── README.md
```

The folders and files will be added gradually as each project stage is completed.

## Current Progress

| Stage                 | Status      |
| --------------------- | ----------- |
| Case Setup            | In Progress |
| Dataset Source        | Complete    |
| Business Questions    | Complete    |
| Data Understanding    | Not Started |
| Data Quality          | Not Started |
| PostgreSQL Setup      | Not Started |
| Business SQL Analysis | Not Started |
| Python EDA            | Not Started |
| Power BI Dashboard    | Not Started |
| GitHub Packaging      | Not Started |
| Final QA              | Not Started |

## Expected Deliverables

The completed project will include:

* documented dataset sources;
* a data dictionary;
* data quality checks and filtering rules;
* reproducible PostgreSQL setup scripts;
* 10–15 documented SQL business queries;
* a beginner-friendly Python notebook;
* a Power BI dashboard;
* key insights and practical recommendations;
* portfolio-ready GitHub documentation.

## Current Findings

Business findings will be added after the data quality and SQL analysis stages. No analytical conclusions are reported at the Case Setup stage.

