# Business Questions

## Project Goal

The goal of this project is to understand how a taxi company can improve revenue and operational efficiency using trip-level data.

The analysis focuses on demand patterns, trip revenue, tipping behaviour, pickup and drop-off locations, route performance, and unusual trip records.

## Main Business Question

**How can a taxi company improve revenue and operational efficiency using trip-level data?**

## Analysis Scope

The analysis uses NYC Yellow Taxi trip records for January 2024.

The project will examine:

* trip demand;
* revenue performance;
* time-based patterns;
* pickup and drop-off locations;
* route performance;
* trip distance and duration;
* payment and tipping behaviour;
* operational efficiency;
* suspicious or invalid trip records.

## Business Questions

### 1. Executive Overview

1. How many taxi trips were recorded during the selected period?
2. What were the total revenue, average fare, average trip distance, and average trip duration?
3. What percentage of the total trip amount came from fares, tips, surcharges, taxes, and tolls?

### 2. Demand and Time Patterns

4. How did the number of trips and total revenue change by day?
5. Which days of the week had the highest and lowest demand?
6. Which hours of the day had the highest number of trips?
7. Which hours generated the highest total revenue?
8. Are the busiest hours also the most profitable hours?

### 3. Location and Route Analysis

9. Which pickup zones had the highest number of trips?
10. Which pickup zones generated the highest total revenue?
11. Which drop-off zones were the most common?
12. Which pickup and drop-off zone combinations formed the most frequent routes?
13. Which routes generated the highest total revenue?

### 4. Fare, Payment, and Tips

14. How did average fare, total trip amount, and tip percentage differ by payment type?
15. Which types of trips received the highest tip percentages?
16. How did tipping behaviour change by hour, weekday, trip distance, and fare amount?

### 5. Trip Efficiency

17. How did revenue per mile differ across trips, hours, and pickup zones?
18. How did revenue per minute differ across trips, hours, and pickup zones?
19. Were short trips or long trips more efficient in terms of revenue per mile and revenue per minute?
20. Which time periods combined high demand with strong revenue efficiency?

### 6. Data Quality and Unusual Trips

21. How many trips had zero or negative distance, fare, duration, or total amount?
22. How many trips had unusually high distance, fare, duration, or tip values?
23. Were there pickup or drop-off timestamps outside the selected reporting period?
24. Which records should be excluded from the main business analysis?
25. How much do invalid or suspicious records affect the main KPIs?

## Expected Business Use

The results should help a taxi company:

* identify peak and low-demand periods;
* improve driver allocation by time and location;
* identify high-demand pickup zones and routes;
* understand which trips generate stronger revenue efficiency;
* understand payment and tipping patterns;
* separate valid operational patterns from data quality problems;
* support practical revenue and operations recommendations.

## Analysis Approach

Not every business question will require a separate SQL query.

Related questions may be combined when one result table answers several questions. The final SQL analysis is expected to contain approximately 10–15 clearly documented queries.

Each SQL query should include:

* the business question;
* the SQL code;
* a simple explanation of the logic;
* the expected result;
* a short business interpretation.

