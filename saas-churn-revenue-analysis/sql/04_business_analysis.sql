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

-- ============================================================
-- 2. Current Revenue Snapshot
--
-- Business question:
-- What is the current paid customer and recurring revenue snapshot?
--
-- Logic:
-- Use the last month available in the subscription data as the
-- reporting period. Count paid subscriptions that are active on the
-- last day of that month. Trial subscriptions are excluded from revenue.
--
-- Insight:
-- As of the latest reporting date, the dataset shows 500 active paid
-- accounts, 3,836 active paid subscriptions, 10.26M MRR, and 123.11M ARR.
-- ============================================================

WITH reporting_date AS (
    SELECT
        (
            DATE_TRUNC('month', MAX(start_date))
            + INTERVAL '1 month'
            - INTERVAL '1 day'
        )::DATE AS report_date
    FROM subscriptions
),

active_paid_subscriptions AS (
    SELECT
        rd.report_date,
        s.account_id,
        s.subscription_id,
        s.mrr_amount,
        s.arr_amount
    FROM reporting_date rd
    LEFT JOIN subscriptions s
        ON s.start_date <= rd.report_date
        AND (
            s.end_date IS NULL
            OR s.end_date >= rd.report_date
        )
        AND s.is_trial = FALSE
        AND s.mrr_amount > 0
)

SELECT
    report_date,
    COUNT(DISTINCT account_id) AS active_paid_accounts,
    COUNT(DISTINCT subscription_id) AS active_paid_subscriptions,
    COALESCE(SUM(mrr_amount), 0) AS current_mrr,
    COALESCE(SUM(arr_amount), 0) AS current_arr,
    ROUND(
        COALESCE(SUM(mrr_amount), 0) / NULLIF(COUNT(DISTINCT account_id), 0),
        2
    ) AS avg_mrr_per_account
FROM active_paid_subscriptions
GROUP BY
    report_date;

-- ============================================================
-- 3. Current Revenue by Plan Tier
--
-- Business question:
-- Which plan tiers contribute the most to current MRR and ARR?
--
-- Logic:
-- Use the last month available in the subscription data as the
-- reporting period. Group active paid subscriptions by plan tier.
-- Trial subscriptions are excluded from revenue.
--
-- Insight:
-- Enterprise is the main revenue driver, contributing 74.46% of
-- current MRR, followed by Pro at 18.81% and Basic at 6.72%.
-- ============================================================

WITH reporting_date AS (
    SELECT
        (
            DATE_TRUNC('month', MAX(start_date))
            + INTERVAL '1 month'
            - INTERVAL '1 day'
        )::DATE AS report_date
    FROM subscriptions
),

active_paid_subscriptions AS (
    SELECT
        rd.report_date,
        s.account_id,
        s.subscription_id,
        s.plan_tier,
        s.mrr_amount,
        s.arr_amount
    FROM reporting_date rd
    LEFT JOIN subscriptions s
        ON s.start_date <= rd.report_date
        AND (
            s.end_date IS NULL
            OR s.end_date >= rd.report_date
        )
        AND s.is_trial = FALSE
        AND s.mrr_amount > 0
),

plan_revenue AS (
    SELECT
        report_date,
        plan_tier,
        COUNT(DISTINCT account_id) AS active_paid_accounts,
        COUNT(DISTINCT subscription_id) AS active_paid_subscriptions,
        SUM(mrr_amount) AS current_mrr,
        SUM(arr_amount) AS current_arr
    FROM active_paid_subscriptions
    GROUP BY
        report_date,
        plan_tier
)

SELECT
    report_date,
    plan_tier,
    active_paid_accounts,
    active_paid_subscriptions,
    current_mrr,
    current_arr,
    ROUND(
        current_mrr * 100.0 / SUM(current_mrr) OVER (),
        2
    ) AS mrr_share_percent
FROM plan_revenue
ORDER BY
    current_mrr DESC;
