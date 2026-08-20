-- ============================================================
-- Query 1: Executive Overview
-- Business question:
-- What are the main trip, revenue, distance, and duration KPIs
-- for January 2024?
-- ============================================================

SELECT
    COUNT(*) FILTER (
        WHERE is_january_trip
    ) AS total_trips,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_january_trip
              AND is_positive_revenue
        ),
        2
    ) AS gross_recorded_trip_amount,

    ROUND(
        AVG(fare_amount) FILTER (
            WHERE is_january_trip
              AND fare_amount >= 0
        ),
        2
    ) AS avg_fare_amount,

    ROUND(
        AVG(trip_distance) FILTER (
            WHERE is_january_trip
              AND is_valid_distance
        ),
        2
    ) AS avg_trip_distance,

    ROUND(
        AVG(duration_minutes) FILTER (
            WHERE is_january_trip
              AND is_valid_duration
        ),
        2
    ) AS avg_trip_duration_minutes

FROM vw_taxi_trips_analysis;

-- ============================================================
-- Query 2: Revenue Composition
-- Business question:
-- How is the gross recorded trip amount distributed across
-- fare, tips, tolls, taxes, surcharges, and other components?
-- ============================================================

SELECT
    ROUND(
        SUM(fare_amount) FILTER (
            WHERE is_january_trip
              AND is_positive_revenue
        ),
        2
    ) AS total_fare_amount,

    ROUND(
        SUM(tip_amount) FILTER (
            WHERE is_january_trip
              AND is_positive_revenue
        ),
        2
    ) AS total_tip_amount,

    ROUND(
        SUM(tolls_amount) FILTER (
            WHERE is_january_trip
              AND is_positive_revenue
        ),
        2
    ) AS total_tolls_amount,

    ROUND(
        SUM(extra) FILTER (
            WHERE is_january_trip
              AND is_positive_revenue
        ),
        2
    ) AS total_extra,

    ROUND(
        SUM(mta_tax) FILTER (
            WHERE is_january_trip
              AND is_positive_revenue
        ),
        2
    ) AS total_mta_tax,

    ROUND(
        SUM(improvement_surcharge) FILTER (
            WHERE is_january_trip
              AND is_positive_revenue
        ),
        2
    ) AS total_improvement_surcharge,

    ROUND(
        SUM(congestion_surcharge) FILTER (
            WHERE is_january_trip
              AND is_positive_revenue
        ),
        2
    ) AS total_congestion_surcharge,

    ROUND(
        SUM(airport_fee) FILTER (
            WHERE is_january_trip
              AND is_positive_revenue
        ),
        2
    ) AS total_airport_fee,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_january_trip
              AND is_positive_revenue
        ),
        2
    ) AS gross_recorded_trip_amount

FROM vw_taxi_trips_analysis;

-- ============================================================
-- Query 3: Daily Demand and Gross Amount
-- Business question:
-- How did trip demand and gross recorded trip amount
-- change by day during January 2024?
-- ============================================================

SELECT
    pickup_datetime::date AS trip_date,

    COUNT(*) AS total_trips,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS gross_recorded_trip_amount,

    ROUND(
        AVG(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS avg_positive_trip_amount

FROM vw_taxi_trips_analysis

WHERE is_january_trip

GROUP BY pickup_datetime::date

ORDER BY trip_date;

-- ============================================================
-- Query 4: Weekday Analysis
-- Business question:
-- Which days of the week had the highest and lowest demand
-- and gross recorded trip amount?
-- ============================================================

SELECT
    EXTRACT(ISODOW FROM pickup_datetime) AS weekday_number,

    TO_CHAR(pickup_datetime, 'FMDay') AS weekday_name,

    COUNT(*) AS total_trips,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS gross_recorded_trip_amount,

    ROUND(
        AVG(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS avg_positive_trip_amount

FROM vw_taxi_trips_analysis

WHERE is_january_trip

GROUP BY
    EXTRACT(ISODOW FROM pickup_datetime),
    TO_CHAR(pickup_datetime, 'FMDay')

ORDER BY weekday_number;

-- ============================================================
-- Query 4B: Normalized Weekday Analysis
-- Business question:
-- Which weekdays have the highest typical daily demand
-- and gross recorded trip amount?
-- ============================================================

SELECT
    EXTRACT(ISODOW FROM pickup_datetime) AS weekday_number,

    TO_CHAR(pickup_datetime, 'FMDay') AS weekday_name,

    COUNT(DISTINCT pickup_datetime::date) AS number_of_days,

    COUNT(*) AS total_trips,

    ROUND(
        COUNT(*)::numeric
        / COUNT(DISTINCT pickup_datetime::date),
        0
    ) AS avg_trips_per_day,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS gross_recorded_trip_amount,

    ROUND(
        (
            SUM(total_amount) FILTER (
                WHERE is_positive_revenue
            )
            / COUNT(DISTINCT pickup_datetime::date)
        ),
        2
    ) AS avg_gross_amount_per_day,

    ROUND(
        AVG(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS avg_positive_trip_amount

FROM vw_taxi_trips_analysis

WHERE is_january_trip

GROUP BY
    EXTRACT(ISODOW FROM pickup_datetime),
    TO_CHAR(pickup_datetime, 'FMDay')

ORDER BY weekday_number;

-- ============================================================
-- Query 5: Hourly Demand and Gross Amount
-- Business question:
-- Which hours of the day have the highest trip demand
-- and gross recorded trip amount?
-- ============================================================

SELECT
    EXTRACT(HOUR FROM pickup_datetime) AS pickup_hour,

    COUNT(*) AS total_trips,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS gross_recorded_trip_amount,

    ROUND(
        AVG(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS avg_positive_trip_amount

FROM vw_taxi_trips_analysis

WHERE is_january_trip

GROUP BY EXTRACT(HOUR FROM pickup_datetime)

ORDER BY pickup_hour;

-- ============================================================
-- Query 6: Top Pickup Zones
-- Business question:
-- Which pickup zones generate the highest trip demand
-- and gross recorded trip amount?
-- ============================================================

SELECT
    pickup_borough,
    pickup_zone,

    COUNT(*) AS total_trips,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS gross_recorded_trip_amount,

    ROUND(
        AVG(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS avg_positive_trip_amount

FROM vw_taxi_trips_analysis

WHERE is_january_trip

GROUP BY
    pickup_borough,
    pickup_zone

ORDER BY total_trips DESC

LIMIT 15;


-- ============================================================
-- Query 7: Top Drop-off Zones
-- Business question:
-- Which drop-off zones receive the highest number of trips
-- and gross recorded trip amount?
-- ============================================================

SELECT
    dropoff_borough,
    dropoff_zone,

    COUNT(*) AS total_trips,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS gross_recorded_trip_amount,

    ROUND(
        AVG(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS avg_positive_trip_amount

FROM vw_taxi_trips_analysis

WHERE is_january_trip

GROUP BY
    dropoff_borough,
    dropoff_zone

ORDER BY total_trips DESC

LIMIT 15;

-- ============================================================
-- Query 8: Top Routes
-- Business question:
-- Which pickup-to-drop-off zone combinations are the most
-- frequent and which generate the highest gross trip amount?
-- ============================================================

SELECT
    pickup_borough,
    pickup_zone,
    dropoff_borough,
    dropoff_zone,

    COUNT(*) AS total_trips,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS gross_recorded_trip_amount,

    ROUND(
        AVG(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS avg_positive_trip_amount

FROM vw_taxi_trips_analysis

WHERE is_january_trip

GROUP BY
    pickup_borough,
    pickup_zone,
    dropoff_borough,
    dropoff_zone

ORDER BY total_trips DESC

LIMIT 20;


-- ============================================================
-- Query 8B: Top Routes by Gross Amount
-- Business question:
-- Which pickup-to-drop-off routes generate the highest
-- gross recorded trip amount?
-- ============================================================

SELECT
    pickup_borough,
    pickup_zone,
    dropoff_borough,
    dropoff_zone,

    COUNT(*) AS total_trips,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS gross_recorded_trip_amount,

    ROUND(
        AVG(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS avg_positive_trip_amount

FROM vw_taxi_trips_analysis

WHERE is_january_trip

GROUP BY
    pickup_borough,
    pickup_zone,
    dropoff_borough,
    dropoff_zone

ORDER BY gross_recorded_trip_amount DESC NULLS LAST

LIMIT 20;

-- ============================================================
-- Query 9: Payment Type Performance
-- Business question:
-- How do fare, trip amount, and tipping behaviour differ
-- by payment type?
-- ============================================================

SELECT
    payment_type,

    COUNT(*) AS total_trips,

    ROUND(
        AVG(fare_amount) FILTER (
            WHERE fare_amount >= 0
              AND is_january_trip
        ),
        2
    ) AS avg_fare_amount,

    ROUND(
        AVG(total_amount) FILTER (
            WHERE is_positive_revenue
              AND is_january_trip
        ),
        2
    ) AS avg_positive_trip_amount,

    ROUND(
        AVG(tip_amount) FILTER (
            WHERE tip_amount >= 0
              AND is_january_trip
        ),
        2
    ) AS avg_tip_amount,

    ROUND(
        AVG(
            CASE
                WHEN fare_amount > 0
                     AND tip_amount >= 0
                THEN tip_amount / fare_amount * 100
            END
        ) FILTER (
            WHERE is_january_trip
        ),
        2
    ) AS avg_tip_percentage

FROM vw_taxi_trips_analysis

WHERE is_january_trip

GROUP BY payment_type

ORDER BY total_trips DESC;

-- ============================================================
-- Query 10: Credit Card Tipping by Hour
-- Business question:
-- How does recorded tipping behaviour change by hour of day
-- for credit-card trips?
-- ============================================================

SELECT
    EXTRACT(HOUR FROM pickup_datetime) AS pickup_hour,

    COUNT(*) AS credit_card_trips,

    ROUND(
        AVG(tip_amount),
        2
    ) AS avg_tip_amount,

    ROUND(
        SUM(tip_amount)
        / NULLIF(SUM(fare_amount), 0) * 100,
        2
    ) AS weighted_tip_percentage,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE tip_amount > 0
        ) / COUNT(*),
        2
    ) AS tipped_trip_share_pct

FROM vw_taxi_trips_analysis

WHERE is_january_trip
  AND payment_type = 1
  AND fare_amount > 0
  AND tip_amount >= 0

GROUP BY EXTRACT(HOUR FROM pickup_datetime)

ORDER BY pickup_hour;

-- ============================================================
-- Query 11: Revenue Efficiency by Hour
-- Business question:
-- How does gross trip amount efficiency differ by hour
-- in terms of amount per mile and amount per minute?
-- ============================================================

SELECT
    EXTRACT(HOUR FROM pickup_datetime) AS pickup_hour,

    COUNT(*) FILTER (
        WHERE is_valid_distance
          AND is_valid_duration
          AND is_positive_revenue
    ) AS valid_trips,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_valid_distance
              AND is_positive_revenue
        )
        /
        NULLIF(
            SUM(trip_distance) FILTER (
                WHERE is_valid_distance
                  AND is_positive_revenue
            ),
            0
        ),
        2
    ) AS gross_amount_per_mile,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_valid_duration
              AND is_positive_revenue
        )
        /
        NULLIF(
            SUM(duration_minutes) FILTER (
                WHERE is_valid_duration
                  AND is_positive_revenue
            ),
            0
        ),
        2
    ) AS gross_amount_per_minute

FROM vw_taxi_trips_analysis

WHERE is_january_trip

GROUP BY EXTRACT(HOUR FROM pickup_datetime)

ORDER BY pickup_hour;

-- ============================================================
-- Query 12: Trip Distance Segment Efficiency
-- Business question:
-- Are short or long trips more efficient in terms of
-- gross amount per mile and per minute?
-- ============================================================

SELECT
    CASE
        WHEN trip_distance <= 2 THEN '1. Short (0-2 miles)'
        WHEN trip_distance <= 5 THEN '2. Medium (2-5 miles)'
        WHEN trip_distance <= 10 THEN '3. Long (5-10 miles)'
        ELSE '4. Very Long (10+ miles)'
    END AS distance_segment,

    COUNT(*) AS total_trips,

    ROUND(
        AVG(total_amount),
        2
    ) AS avg_trip_amount,

    ROUND(
        AVG(trip_distance),
        2
    ) AS avg_trip_distance,

    ROUND(
        AVG(duration_minutes),
        2
    ) AS avg_duration_minutes,

    ROUND(
        SUM(total_amount)
        / NULLIF(SUM(trip_distance), 0),
        2
    ) AS gross_amount_per_mile,

    ROUND(
        SUM(total_amount)
        / NULLIF(SUM(duration_minutes), 0),
        2
    ) AS gross_amount_per_minute

FROM vw_taxi_trips_analysis

WHERE is_january_trip
  AND is_positive_revenue
  AND is_valid_distance
  AND is_valid_duration

GROUP BY
    CASE
        WHEN trip_distance <= 2 THEN '1. Short (0-2 miles)'
        WHEN trip_distance <= 5 THEN '2. Medium (2-5 miles)'
        WHEN trip_distance <= 10 THEN '3. Long (5-10 miles)'
        ELSE '4. Very Long (10+ miles)'
    END

ORDER BY distance_segment;

-- ============================================================
-- Query 13: High Demand and High Efficiency Hours
-- Business question:
-- Which hours combine high trip demand with strong
-- gross amount efficiency?
-- ============================================================

SELECT
    EXTRACT(HOUR FROM pickup_datetime) AS pickup_hour,

    COUNT(*) AS total_trips,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_positive_revenue
        ),
        2
    ) AS gross_recorded_trip_amount,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_valid_distance
              AND is_positive_revenue
        )
        /
        NULLIF(
            SUM(trip_distance) FILTER (
                WHERE is_valid_distance
                  AND is_positive_revenue
            ),
            0
        ),
        2
    ) AS gross_amount_per_mile,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_valid_duration
              AND is_positive_revenue
        )
        /
        NULLIF(
            SUM(duration_minutes) FILTER (
                WHERE is_valid_duration
                  AND is_positive_revenue
            ),
            0
        ),
        2
    ) AS gross_amount_per_minute

FROM vw_taxi_trips_analysis

WHERE is_january_trip

GROUP BY EXTRACT(HOUR FROM pickup_datetime)

ORDER BY total_trips DESC;

-- ============================================================
-- Query 14: Impact of Data Quality Filters
-- Business question:
-- How much do invalid or suspicious records affect
-- the main analytical KPIs?
-- ============================================================

SELECT
    -- Trip counts
    COUNT(*) FILTER (
        WHERE is_january_trip
    ) AS all_january_trips,

    COUNT(*) FILTER (
        WHERE is_january_trip
          AND is_valid_distance
          AND is_valid_duration
          AND is_positive_revenue
    ) AS fully_valid_trips,

    -- Raw vs cleaned average distance
    ROUND(
        AVG(trip_distance) FILTER (
            WHERE is_january_trip
        ),
        2
    ) AS raw_avg_distance,

    ROUND(
        AVG(trip_distance) FILTER (
            WHERE is_january_trip
              AND is_valid_distance
        ),
        2
    ) AS cleaned_avg_distance,

    -- Raw vs cleaned average duration
    ROUND(
        AVG(duration_minutes) FILTER (
            WHERE is_january_trip
        ),
        2
    ) AS raw_avg_duration,

    ROUND(
        AVG(duration_minutes) FILTER (
            WHERE is_january_trip
              AND is_valid_duration
        ),
        2
    ) AS cleaned_avg_duration,

    -- Raw vs positive gross amount
    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_january_trip
        ),
        2
    ) AS raw_net_recorded_amount,

    ROUND(
        SUM(total_amount) FILTER (
            WHERE is_january_trip
              AND is_positive_revenue
        ),
        2
    ) AS positive_gross_recorded_amount

FROM vw_taxi_trips_analysis;
