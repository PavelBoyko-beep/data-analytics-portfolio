-- ============================================================
-- SaaS Churn & Revenue Analysis
-- 04_business_analysis.sql
--
-- Purpose:
-- Answer business questions about revenue, churn, customers,
-- retention, and product usage using PostgreSQL.
-- ============================================================

-- ============================================================
-- 1. End-of-Month Monthly Recurring Revenue
--
-- Business question:
-- How does end-of-month MRR change over time?
--
-- Logic:
-- For each month, count paid subscriptions that were active
-- on the last day of that month and sum their MRR amount.
-- Trial subscriptions are excluded from revenue.
--
-- Insight:
-- The synthetic SaaS business shows steady month-over-month growth
-- in paid accounts, active paid subscriptions, and total MRR.
-- ============================================================

WITH date_bounds AS (
    SELECT
        DATE_TRUNC('month', MIN(start_date))::DATE AS min_month,
        DATE_TRUNC('month', MAX(COALESCE(end_date, start_date)))::DATE AS max_month
    FROM subscriptions
),

months AS (
    SELECT
        GENERATE_SERIES(
            min_month,
            max_month,
            INTERVAL '1 month'
        )::DATE AS month_start
    FROM date_bounds
),

monthly_mrr AS (
    SELECT
        m.month_start,
        (m.month_start + INTERVAL '1 month' - INTERVAL '1 day')::DATE AS month_end,
        COUNT(DISTINCT s.account_id) AS active_paid_accounts,
        COUNT(DISTINCT s.subscription_id) AS active_paid_subscriptions,
        SUM(s.mrr_amount) AS total_mrr
    FROM months m
    LEFT JOIN subscriptions s
        ON s.start_date <= (m.month_start + INTERVAL '1 month' - INTERVAL '1 day')
        AND (
            s.end_date IS NULL
            OR s.end_date >= (m.month_start + INTERVAL '1 month' - INTERVAL '1 day')
        )
        AND s.is_trial = FALSE
        AND s.mrr_amount > 0
    GROUP BY
        m.month_start
)

SELECT
    month_start,
    month_end,
    active_paid_accounts,
    active_paid_subscriptions,
    total_mrr
FROM monthly_mrr
ORDER BY
    month_start;
