-- NYC Yellow Taxi Operations & Revenue Analysis
-- Step 3: Validate imported source data


-- ============================================================
-- 1. Validate row counts
-- ============================================================

SELECT COUNT(*) AS zone_count
FROM taxi_zones;

-- Expected: 265


SELECT COUNT(*) AS trip_count
FROM yellow_taxi_trips;

-- Expected: 2,964,624


-- ============================================================
-- 2. Validate table column count
-- ============================================================

SELECT COUNT(*) AS column_count
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'yellow_taxi_trips';

-- Expected: 19


-- ============================================================
-- 3. Validate NULL values
-- ============================================================

SELECT
    COUNT(*) FILTER (WHERE vendor_id IS NULL) AS vendor_id_nulls,
    COUNT(*) FILTER (WHERE pickup_datetime IS NULL) AS pickup_datetime_nulls,
    COUNT(*) FILTER (WHERE dropoff_datetime IS NULL) AS dropoff_datetime_nulls,
    COUNT(*) FILTER (WHERE passenger_count IS NULL) AS passenger_count_nulls,
    COUNT(*) FILTER (WHERE trip_distance IS NULL) AS trip_distance_nulls,
    COUNT(*) FILTER (WHERE ratecode_id IS NULL) AS ratecode_id_nulls,
    COUNT(*) FILTER (WHERE store_and_fwd_flag IS NULL) AS store_and_fwd_flag_nulls,
    COUNT(*) FILTER (WHERE pickup_location_id IS NULL) AS pickup_location_id_nulls,
    COUNT(*) FILTER (WHERE dropoff_location_id IS NULL) AS dropoff_location_id_nulls,
    COUNT(*) FILTER (WHERE payment_type IS NULL) AS payment_type_nulls,
    COUNT(*) FILTER (WHERE fare_amount IS NULL) AS fare_amount_nulls,
    COUNT(*) FILTER (WHERE extra IS NULL) AS extra_nulls,
    COUNT(*) FILTER (WHERE mta_tax IS NULL) AS mta_tax_nulls,
    COUNT(*) FILTER (WHERE tip_amount IS NULL) AS tip_amount_nulls,
    COUNT(*) FILTER (WHERE tolls_amount IS NULL) AS tolls_amount_nulls,
    COUNT(*) FILTER (WHERE improvement_surcharge IS NULL) AS improvement_surcharge_nulls,
    COUNT(*) FILTER (WHERE total_amount IS NULL) AS total_amount_nulls,
    COUNT(*) FILTER (WHERE congestion_surcharge IS NULL) AS congestion_surcharge_nulls,
    COUNT(*) FILTER (WHERE airport_fee IS NULL) AS airport_fee_nulls
FROM yellow_taxi_trips;


-- ============================================================
-- 4. Validate store-and-forward flag distribution
-- ============================================================

SELECT
    COUNT(*) FILTER (WHERE store_and_fwd_flag IS NULL) AS null_count,
    COUNT(*) FILTER (WHERE store_and_fwd_flag = 'N') AS n_count,
    COUNT(*) FILTER (WHERE store_and_fwd_flag = 'Y') AS y_count
FROM yellow_taxi_trips;

-- Expected:
-- NULL = 140,162
-- N    = 2,813,126
-- Y    = 11,336


-- ============================================================
-- 5. Preview imported records
-- ============================================================

SELECT
    vendor_id,
    pickup_datetime,
    dropoff_datetime,
    passenger_count,
    trip_distance,
    ratecode_id,
    store_and_fwd_flag,
    pickup_location_id,
    dropoff_location_id,
    payment_type,
    total_amount
FROM yellow_taxi_trips
LIMIT 10;
