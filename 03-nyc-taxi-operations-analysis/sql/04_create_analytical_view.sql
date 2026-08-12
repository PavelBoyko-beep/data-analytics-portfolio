-- NYC Yellow Taxi Operations & Revenue Analysis
-- Step 4: Create analytical view


DROP VIEW IF EXISTS vw_taxi_trips_analysis;


CREATE VIEW vw_taxi_trips_analysis AS

SELECT
    t.vendor_id,
    t.pickup_datetime,
    t.dropoff_datetime,
    t.passenger_count,
    t.trip_distance,
    t.ratecode_id,
    t.store_and_fwd_flag,
    t.pickup_location_id,
    t.dropoff_location_id,
    t.payment_type,
    t.fare_amount,
    t.extra,
    t.mta_tax,
    t.tip_amount,
    t.tolls_amount,
    t.improvement_surcharge,
    t.total_amount,
    t.congestion_surcharge,
    t.airport_fee,

    EXTRACT(
        EPOCH FROM (t.dropoff_datetime - t.pickup_datetime)
    ) / 60.0 AS duration_minutes,

    pu.borough AS pickup_borough,
    pu.zone AS pickup_zone,
    pu.service_zone AS pickup_service_zone,

    do_zone.borough AS dropoff_borough,
    do_zone.zone AS dropoff_zone,
    do_zone.service_zone AS dropoff_service_zone,

    (
        t.pickup_datetime >= TIMESTAMP '2024-01-01 00:00:00'
        AND t.pickup_datetime < TIMESTAMP '2024-02-01 00:00:00'
    ) AS is_january_trip,

    (
        t.trip_distance > 0
        AND t.trip_distance <= 500
    ) AS is_valid_distance,

    (
        t.dropoff_datetime > t.pickup_datetime
        AND EXTRACT(
            EPOCH FROM (t.dropoff_datetime - t.pickup_datetime)
        ) / 60.0 <= 1440
    ) AS is_valid_duration,

    (
        t.total_amount > 0
    ) AS is_positive_revenue

FROM yellow_taxi_trips AS t

LEFT JOIN taxi_zones AS pu
    ON t.pickup_location_id = pu.location_id

LEFT JOIN taxi_zones AS do_zone
    ON t.dropoff_location_id = do_zone.location_id;
