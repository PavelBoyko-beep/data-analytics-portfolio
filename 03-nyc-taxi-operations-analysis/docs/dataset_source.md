# Dataset Source

## Dataset

**NYC TLC Yellow Taxi Trip Records**

This project uses real trip-level data published by the New York City Taxi and Limousine Commission.

## Selected Period

**January 2024**

The initial analysis is limited to one complete calendar month:

* start date: 2024-01-01;
* end date: 2024-01-31.

Using one month keeps the project manageable while still providing enough observations to analyse demand, revenue, locations, trip characteristics, tips, and data quality issues.

## Main Trip Dataset

File name:

`yellow_tripdata_2024-01.parquet`

File format:

`PARQUET`

Official download:

`https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet`

## Taxi Zone Lookup Table

File name:

`taxi_zone_lookup.csv`

Official download:

`https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv`

The lookup table will be used to convert pickup and drop-off location IDs into understandable borough and taxi zone names.

## Official Source Page

New York City Taxi and Limousine Commission — TLC Trip Record Data:

`https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page`

## Data Dictionary

Yellow Taxi Trip Records Data Dictionary:

`https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf`

The data dictionary explains the meaning of the main trip fields, including pickup and drop-off timestamps, trip distance, payment type, fare amount, tip amount, total amount, and taxi zone IDs.

## Why This Dataset Was Selected

This dataset was selected because it:

* contains real operational taxi data;
* supports SQL-first business analysis;
* includes time, location, revenue, distance, payment, and tip information;
* contains realistic data quality issues and unusual trips;
* can support a practical Power BI dashboard;
* allows business recommendations related to demand, driver allocation, routes, and revenue efficiency.

## Important Limitations

The trip data is submitted to NYC TLC by authorised technology providers. NYC TLC does not guarantee that every record is completely accurate.

The `tip_amount` field mainly records credit card tips. Cash tips are not included, so cash tipping behaviour cannot be fully measured.

The official documentation may be updated over time. Therefore, the actual January 2024 file structure and column names will be checked directly during the Data Understanding stage.

## Planned Use in the Project

The trip dataset will be used to analyse:

* total trips and revenue;
* demand by day and hour;
* revenue by time period;
* pickup and drop-off zones;
* popular routes;
* fare and tip behaviour;
* revenue per mile and minute;
* suspicious or invalid trips;
* possible opportunities to improve driver allocation and operational efficiency.

