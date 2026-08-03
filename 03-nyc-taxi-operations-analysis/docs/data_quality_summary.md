# Data Quality Summary

## Dataset Scope

The Yellow Taxi trip table contains 2,964,624 records and 19 columns.

The taxi zone lookup contains 265 records with unique LocationID values.

## Key Findings

| Data Quality Check | Result | Analytical Decision |
|---|---:|---|
| Exact duplicate rows | 0 | No duplicate removal required |
| Duplicate trip-key combinations | 0 | No duplicate removal required |
| Rows with five related missing fields | 140,162 (4.73%) | Retain for applicable analyses; exclude from passenger, rate code, congestion surcharge, and airport fee analyses |
| Rows with payment_type = 0 | 140,162 | Treat as a separate category because they match the missing-value group exactly |
| Pickup records outside January 2024 | 18 | Exclude from January demand analysis |
| Trips with duration <= 0 | 870 | Exclude from duration, speed, and revenue-per-minute metrics |
| Trips with zero distance | 60,371 (2.04%) | Exclude from distance-based metrics, but retain where time, zone, or financial fields remain usable |
| Trips with negative fare_amount | 37,448 | Do not use in standard positive-fare KPIs |
| Trips with negative total_amount | 35,504 | Treat as potential adjustments, disputes, or reversals and exclude from standard positive-revenue KPIs |
| Trips with trip_distance > 100 miles | 59 | Review as outliers; clearly impossible values must be excluded from distance metrics |
| Trips with duration > 180 minutes | 1,983 | Review as outliers; extreme durations must be excluded from time-based metrics |
| Pickup IDs missing from zone lookup | 0 | All pickup locations can be joined to the zone table |
| Drop-off IDs missing from zone lookup | 0 | All drop-off locations can be joined to the zone table |

## Missing-Value Pattern

The same 140,162 records have missing values in all five of the following columns:

- passenger_count
- RatecodeID
- store_and_fwd_flag
- congestion_surcharge
- Airport_fee

These records also match `payment_type = 0` exactly and form one continuous block at the end of the source file.

They were not deleted because other useful fields remain available, including:

- pickup and drop-off datetime;
- pickup and drop-off location;
- trip distance;
- fare amount;
- total amount.

## Outlier Examples

Several clearly implausible records were identified, including:

- a trip distance of 312,722.30 miles recorded over 13 minutes;
- a trip duration of 9,455.4 minutes for a distance of 2.26 miles;
- records with zero distance and zero duration but total amounts up to 5,000.

Because the correct replacement values are unknown, these records will not be manually corrected. They will be excluded only from metrics that they would distort.

## Analytical Treatment Rules

The raw dataset was preserved without deleting records.

Instead of applying one global cleaning rule, records will be filtered according to the metric being calculated.

| Analysis Type | Treatment Rule |
|---|---|
| Trip count analysis | Use trips with pickup datetime within January 2024 |
| Passenger analysis | Exclude rows where passenger_count is missing |
| Rate code analysis | Exclude rows where RatecodeID is missing |
| Distance analysis | Use rows where trip_distance > 0 and exclude clearly impossible distance outliers |
| Duration analysis | Use rows where duration_minutes > 0 and exclude extreme duration outliers |
| Revenue analysis | Use rows where total_amount > 0; negative totals are treated as potential adjustments, disputes, or reversals |
| Revenue per mile | Require valid positive distance and positive total amount |
| Revenue per minute | Require valid positive duration and positive total amount |
| Payment type analysis | Treat payment_type = 0 as a separate category |
| Zone analysis | All pickup and drop-off IDs are covered by the zone lookup |

The dataset will therefore remain intact at the raw level, while metric-specific filters will be applied during SQL analysis.
