-- ============================================================
-- SaaS Churn & Revenue Analysis
-- 03_data_quality_checks.sql
--
-- Purpose:
-- Validate imported PostgreSQL tables after loading processed CSV files.
-- ============================================================

-- ============================================================
-- 1. Row count checks
-- ============================================================

SELECT
    'accounts' AS table_name,
    COUNT(*) AS row_count
FROM accounts

UNION ALL

SELECT
    'subscriptions' AS table_name,
    COUNT(*) AS row_count
FROM subscriptions

UNION ALL

SELECT
    'feature_usage' AS table_name,
    COUNT(*) AS row_count
FROM feature_usage

UNION ALL

SELECT
    'support_tickets' AS table_name,
    COUNT(*) AS row_count
FROM support_tickets

UNION ALL

SELECT
    'churn_events' AS table_name,
    COUNT(*) AS row_count
FROM churn_events

ORDER BY table_name;

-- ============================================================
-- 2. Primary key checks
-- ============================================================

SELECT
    'accounts' AS table_name,
    'account_id' AS primary_key,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT account_id) AS unique_keys,
    COUNT(*) - COUNT(DISTINCT account_id) AS duplicate_keys,
    SUM(CASE WHEN account_id IS NULL THEN 1 ELSE 0 END) AS missing_keys
FROM accounts

UNION ALL

SELECT
    'subscriptions' AS table_name,
    'subscription_id' AS primary_key,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT subscription_id) AS unique_keys,
    COUNT(*) - COUNT(DISTINCT subscription_id) AS duplicate_keys,
    SUM(CASE WHEN subscription_id IS NULL THEN 1 ELSE 0 END) AS missing_keys
FROM subscriptions

UNION ALL

SELECT
    'feature_usage' AS table_name,
    'feature_usage_id' AS primary_key,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT feature_usage_id) AS unique_keys,
    COUNT(*) - COUNT(DISTINCT feature_usage_id) AS duplicate_keys,
    SUM(CASE WHEN feature_usage_id IS NULL THEN 1 ELSE 0 END) AS missing_keys
FROM feature_usage

UNION ALL

SELECT
    'support_tickets' AS table_name,
    'ticket_id' AS primary_key,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ticket_id) AS unique_keys,
    COUNT(*) - COUNT(DISTINCT ticket_id) AS duplicate_keys,
    SUM(CASE WHEN ticket_id IS NULL THEN 1 ELSE 0 END) AS missing_keys
FROM support_tickets

UNION ALL

SELECT
    'churn_events' AS table_name,
    'churn_event_id' AS primary_key,
    COUNT(*) AS total_rows,
    COUNT(DISTINCT churn_event_id) AS unique_keys,
    COUNT(*) - COUNT(DISTINCT churn_event_id) AS duplicate_keys,
    SUM(CASE WHEN churn_event_id IS NULL THEN 1 ELSE 0 END) AS missing_keys
FROM churn_events

ORDER BY table_name;

-- ============================================================
-- 3. Original usage_id duplicate check
-- ============================================================

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT usage_id) AS unique_usage_ids,
    COUNT(*) - COUNT(DISTINCT usage_id) AS duplicate_usage_id_rows,
    SUM(CASE WHEN usage_id IS NULL THEN 1 ELSE 0 END) AS missing_usage_ids
FROM feature_usage;

SELECT
    usage_id,
    COUNT(*) AS row_count
FROM feature_usage
GROUP BY usage_id
HAVING COUNT(*) > 1
ORDER BY usage_id;

-- ============================================================
-- 4. Foreign key checks
-- ============================================================

SELECT
    'subscriptions.account_id -> accounts.account_id' AS relationship,
    SUM(CASE WHEN s.account_id IS NULL THEN 1 ELSE 0 END) AS missing_fk_values,
    SUM(CASE WHEN s.account_id IS NOT NULL AND a.account_id IS NULL THEN 1 ELSE 0 END) AS orphan_records
FROM subscriptions s
LEFT JOIN accounts a
    ON s.account_id = a.account_id

UNION ALL

SELECT
    'feature_usage.subscription_id -> subscriptions.subscription_id' AS relationship,
    SUM(CASE WHEN fu.subscription_id IS NULL THEN 1 ELSE 0 END) AS missing_fk_values,
    SUM(CASE WHEN fu.subscription_id IS NOT NULL AND s.subscription_id IS NULL THEN 1 ELSE 0 END) AS orphan_records
FROM feature_usage fu
LEFT JOIN subscriptions s
    ON fu.subscription_id = s.subscription_id

UNION ALL

SELECT
    'support_tickets.account_id -> accounts.account_id' AS relationship,
    SUM(CASE WHEN st.account_id IS NULL THEN 1 ELSE 0 END) AS missing_fk_values,
    SUM(CASE WHEN st.account_id IS NOT NULL AND a.account_id IS NULL THEN 1 ELSE 0 END) AS orphan_records
FROM support_tickets st
LEFT JOIN accounts a
    ON st.account_id = a.account_id

UNION ALL

SELECT
    'churn_events.account_id -> accounts.account_id' AS relationship,
    SUM(CASE WHEN ce.account_id IS NULL THEN 1 ELSE 0 END) AS missing_fk_values,
    SUM(CASE WHEN ce.account_id IS NOT NULL AND a.account_id IS NULL THEN 1 ELSE 0 END) AS orphan_records
FROM churn_events ce
LEFT JOIN accounts a
    ON ce.account_id = a.account_id

ORDER BY relationship;

-- ============================================================
-- 5. Post-import cleanup: empty feedback_text to NULL
-- ============================================================

UPDATE churn_events
SET feedback_text = NULL
WHERE TRIM(feedback_text) = '';

-- ============================================================
-- 6. Missing values checks
-- ============================================================

SELECT
    'subscriptions' AS table_name,
    'end_date' AS column_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN end_date IS NULL THEN 1 ELSE 0 END) AS missing_values,
    ROUND(
        SUM(CASE WHEN end_date IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS missing_percent
FROM subscriptions

UNION ALL

SELECT
    'support_tickets' AS table_name,
    'satisfaction_score' AS column_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN satisfaction_score IS NULL THEN 1 ELSE 0 END) AS missing_values,
    ROUND(
        SUM(CASE WHEN satisfaction_score IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS missing_percent
FROM support_tickets

UNION ALL

SELECT
    'churn_events' AS table_name,
    'feedback_text' AS column_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN feedback_text IS NULL THEN 1 ELSE 0 END) AS missing_values,
    ROUND(
        SUM(CASE WHEN feedback_text IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS missing_percent
FROM churn_events

ORDER BY table_name, column_name;

-- ============================================================
-- 7. Numeric value checks
-- ============================================================

SELECT
    'subscriptions' AS table_name,
    'end_date' AS column_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN end_date IS NULL THEN 1 ELSE 0 END) AS missing_values,
    ROUND(
        SUM(CASE WHEN end_date IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS missing_percent
FROM subscriptions

UNION ALL

SELECT
    'support_tickets' AS table_name,
    'satisfaction_score' AS column_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN satisfaction_score IS NULL THEN 1 ELSE 0 END) AS missing_values,
    ROUND(
        SUM(CASE WHEN satisfaction_score IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS missing_percent
FROM support_tickets

UNION ALL

SELECT
    'churn_events' AS table_name,
    'feedback_text' AS column_name,
    COUNT(*) AS total_rows,
    SUM(CASE WHEN feedback_text IS NULL THEN 1 ELSE 0 END) AS missing_values,
    ROUND(
        SUM(CASE WHEN feedback_text IS NULL THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS missing_percent
FROM churn_events

ORDER BY table_name, column_name;

-- ============================================================
-- 8. Date logic checks
-- ============================================================

SELECT
    'subscription end_date before start_date' AS check_name,
    COUNT(*) AS invalid_rows,
    'hard check' AS check_type
FROM subscriptions
WHERE end_date IS NOT NULL
  AND end_date < start_date

UNION ALL

SELECT
    'subscription start_date before account signup_date' AS check_name,
    COUNT(*) AS invalid_rows,
    'hard check' AS check_type
FROM subscriptions s
JOIN accounts a
    ON s.account_id = a.account_id
WHERE s.start_date < a.signup_date

UNION ALL

SELECT
    'ticket closed_at before submitted_at' AS check_name,
    COUNT(*) AS invalid_rows,
    'hard check' AS check_type
FROM support_tickets
WHERE closed_at < submitted_at

UNION ALL

SELECT
    'churn_date before account signup_date' AS check_name,
    COUNT(*) AS invalid_rows,
    'hard check' AS check_type
FROM churn_events ce
JOIN accounts a
    ON ce.account_id = a.account_id
WHERE ce.churn_date < a.signup_date

UNION ALL

SELECT
    'usage_date before subscription start_date' AS check_name,
    COUNT(*) AS invalid_rows,
    'documented limitation' AS check_type
FROM feature_usage fu
JOIN subscriptions s
    ON fu.subscription_id = s.subscription_id
WHERE fu.usage_date < s.start_date

UNION ALL

SELECT
    'usage_date before account signup_date' AS check_name,
    COUNT(*) AS invalid_rows,
    'documented limitation' AS check_type
FROM feature_usage fu
JOIN subscriptions s
    ON fu.subscription_id = s.subscription_id
JOIN accounts a
    ON s.account_id = a.account_id
WHERE fu.usage_date < a.signup_date

ORDER BY check_type, check_name;

