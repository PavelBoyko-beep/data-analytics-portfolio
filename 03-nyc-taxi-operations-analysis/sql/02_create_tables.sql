-- NYC Yellow Taxi Operations & Revenue Analysis
-- Step 2: Create source tables

DROP TABLE IF EXISTS yellow_taxi_trips;
DROP TABLE IF EXISTS taxi_zones;


CREATE TABLE taxi_zones (
    location_id INTEGER PRIMARY KEY,
    borough VARCHAR(50),
    zone VARCHAR(100),
    service_zone VARCHAR(50)
);


CREATE TABLE yellow_taxi_trips (
    vendor_id INTEGER,
    pickup_datetime TIMESTAMP,
    dropoff_datetime TIMESTAMP,
    passenger_count NUMERIC,
    trip_distance NUMERIC,
    ratecode_id NUMERIC,
    store_and_fwd_flag VARCHAR(1),
    pickup_location_id INTEGER,
    dropoff_location_id INTEGER,
    payment_type INTEGER,
    fare_amount NUMERIC,
    extra NUMERIC,
    mta_tax NUMERIC,
    tip_amount NUMERIC,
    tolls_amount NUMERIC,
    improvement_surcharge NUMERIC,
    total_amount NUMERIC,
    congestion_surcharge NUMERIC,
    airport_fee NUMERIC
);
