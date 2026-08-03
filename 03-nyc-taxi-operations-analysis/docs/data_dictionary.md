# Data Dictionary

## Dataset Overview

The project contains two tables.

### trips

**Grain**

One row represents one completed taxi trip.

| Column | Type | Business Meaning | Role |
|---------|------|------------------|------|
| VendorID | Integer | Taxi vendor identifier | Categorical |
| tpep_pickup_datetime | Datetime | Pickup timestamp | Datetime |
| tpep_dropoff_datetime | Datetime | Drop-off timestamp | Datetime |
| passenger_count | Numeric | Number of passengers | Measure |
| trip_distance | Numeric | Distance travelled (miles) | Measure |
| RatecodeID | Integer | Fare rate code | Categorical |
| store_and_fwd_flag | Text | Delayed transmission flag | Categorical |
| PULocationID | Integer | Pickup location identifier | Foreign Key |
| DOLocationID | Integer | Drop-off location identifier | Foreign Key |
| payment_type | Integer | Payment method code | Categorical |
| fare_amount | Numeric | Base fare | Measure |
| extra | Numeric | Additional charges | Measure |
| mta_tax | Numeric | MTA tax | Measure |
| tip_amount | Numeric | Tip amount | Measure |
| tolls_amount | Numeric | Toll charges | Measure |
| improvement_surcharge | Numeric | Improvement surcharge | Measure |
| congestion_surcharge | Numeric | Congestion surcharge | Measure |
| Airport_fee | Numeric | Airport fee | Measure |
| total_amount | Numeric | Total recorded trip amount | Measure |

---

### zones

**Grain**

One row represents one TLC taxi zone.

| Column | Type | Business Meaning | Role |
|---------|------|------------------|------|
| LocationID | Integer | Taxi zone identifier | Primary Key |
| Borough | Text | NYC borough | Category |
| Zone | Text | Taxi zone name | Category |
| service_zone | Text | TLC service zone | Category |

---

## Table Relationships

```
trips.PULocationID
        │
        ├────────────► zones.LocationID

trips.DOLocationID
        │
        └────────────► zones.LocationID
```

Both pickup and drop-off locations use the same lookup table.
