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
| Revenue analysis | Use rows where total_amount > 0; negative totals are treated as adjustments, disputes, or reversals |
| Revenue per mile | Require valid positive distance and positive total amount |
| Revenue per minute | Require valid positive duration and positive total amount |
| Payment type analysis | Treat payment_type = 0 as a separate category |
| Zone analysis | All pickup and drop-off IDs are covered by the zone lookup |

The dataset will therefore remain intact at the raw level, while metric-specific filters will be applied during SQL analysis.
