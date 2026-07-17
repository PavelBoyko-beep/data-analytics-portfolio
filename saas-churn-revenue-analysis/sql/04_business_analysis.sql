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

-- ============================================================
-- 4. Average Revenue per Account by Plan Tier
--
-- Business question:
-- Which plan tiers generate the highest average revenue per account
-- and per subscription?
--
-- Logic:
-- Use the last month available in the subscription data as the
-- reporting period. Group active paid subscriptions by plan tier
-- and calculate average MRR per account and per subscription.
-- Trial subscriptions are excluded from revenue.
--
-- Insight:
-- Enterprise has the highest revenue efficiency, with 16,535.52
-- average MRR per account and 5,805.02 average MRR per subscription.
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
)

SELECT
    report_date,
    plan_tier,
    COUNT(DISTINCT account_id) AS active_paid_accounts,
    COUNT(DISTINCT subscription_id) AS active_paid_subscriptions,
    SUM(mrr_amount) AS current_mrr,
    ROUND(
        SUM(mrr_amount) / NULLIF(COUNT(DISTINCT account_id), 0),
        2
    ) AS avg_mrr_per_account,
    ROUND(
        SUM(mrr_amount) / NULLIF(COUNT(DISTINCT subscription_id), 0),
        2
    ) AS avg_mrr_per_subscription
FROM active_paid_subscriptions
GROUP BY
    report_date,
    plan_tier
ORDER BY
    avg_mrr_per_account DESC;

-- ============================================================
-- 5. Monthly Churn Events Trend
--
-- Business question:
-- How many churn events happen each month, and how much refund
-- amount is associated with churn?
--
-- Logic:
-- Group churn events by churn month. Count churn events,
-- distinct churned accounts, reactivation events, and total refunds.
--
-- Insight:
-- Churn events increase toward the end of the observed period,
-- with the highest churn volume in December 2024.
-- ============================================================

SELECT
    DATE_TRUNC('month', churn_date)::DATE AS churn_month,
    COUNT(*) AS churn_events,
    COUNT(DISTINCT account_id) AS churned_accounts,
    SUM(CASE WHEN is_reactivation = TRUE THEN 1 ELSE 0 END) AS reactivation_events,
    SUM(refund_amount_usd) AS total_refund_amount,
    ROUND(AVG(refund_amount_usd), 2) AS avg_refund_amount
FROM churn_events
GROUP BY
    DATE_TRUNC('month', churn_date)::DATE
ORDER BY
    churn_month;

-- ============================================================
-- 6. Churn by Reason Code
--
-- Business question:
-- What are the most common churn reasons, and how much refund
-- amount is associated with each reason?
--
-- Logic:
-- Group churn events by reason_code. Count churn events,
-- distinct churned accounts, reactivation events, and refund metrics.
--
-- Insight:
-- Feature-related churn is the most common reason,
-- but churn reasons are relatively distributed across categories.
-- ============================================================

SELECT
    reason_code,
    COUNT(*) AS churn_events,
    COUNT(DISTINCT account_id) AS churned_accounts,
    SUM(CASE WHEN is_reactivation = TRUE THEN 1 ELSE 0 END) AS reactivation_events,
    SUM(refund_amount_usd) AS total_refund_amount,
    ROUND(AVG(refund_amount_usd), 2) AS avg_refund_amount,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS churn_event_share_percent
FROM churn_events
GROUP BY
    reason_code
ORDER BY
    churn_events DESC;

-- ============================================================
-- 7. Churn by Plan Tier
--
-- Business question:
-- Which plan tiers have the highest number of churn events?
--
-- Logic:
-- Join churn events to accounts to attach plan tier information.
-- Group churn events by account-level plan tier and calculate churn,
-- reactivation, and refund metrics.
--
-- Insight:
-- Pro has the highest number of churn events, followed by Enterprise
-- and Basic. This shows churn volume by tier, not churn rate.
-- ============================================================

SELECT
    a.plan_tier,
    COUNT(*) AS churn_events,
    COUNT(DISTINCT ce.account_id) AS churned_accounts,
    SUM(CASE WHEN ce.is_reactivation = TRUE THEN 1 ELSE 0 END) AS reactivation_events,
    SUM(ce.refund_amount_usd) AS total_refund_amount,
    ROUND(AVG(ce.refund_amount_usd), 2) AS avg_refund_amount,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS churn_event_share_percent
FROM churn_events ce
LEFT JOIN accounts a
    ON ce.account_id = a.account_id
GROUP BY
    a.plan_tier
ORDER BY
    churn_events DESC;

-- ============================================================
-- 8. Monthly Churn Rate Estimate
--
-- Business question:
-- What is the estimated monthly account churn rate?
--
-- Logic:
-- For each month, calculate the active paid account base at the
-- start of the month. Then count distinct accounts from that base
-- that had a churn event during the same month.
--
-- This is an estimated account churn rate, not revenue churn.
-- Trial subscriptions are excluded from the active paid base.
--
-- Insight:
-- Estimated monthly account churn rate increases toward the end of
-- 2024, reaching 16.24% in December among accounts active at the
-- start of the month.
-- ============================================================

WITH date_bounds AS (
    SELECT
        DATE_TRUNC('month', MIN(start_date))::DATE AS min_month,
        DATE_TRUNC('month', MAX(start_date))::DATE AS max_month
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

active_base AS (
    SELECT DISTINCT
        m.month_start,
        s.account_id
    FROM months m
    JOIN subscriptions s
        ON s.start_date <= m.month_start
        AND (
            s.end_date IS NULL
            OR s.end_date >= m.month_start
        )
        AND s.is_trial = FALSE
        AND s.mrr_amount > 0
),

monthly_churn AS (
    SELECT
        m.month_start,
        COUNT(DISTINCT ab.account_id) AS starting_active_paid_accounts,
        COUNT(DISTINCT ce.account_id) AS churned_accounts,
        COUNT(ce.churn_event_id) AS churn_events
    FROM months m
    LEFT JOIN active_base ab
        ON m.month_start = ab.month_start
    LEFT JOIN churn_events ce
        ON ce.account_id = ab.account_id
        AND ce.churn_date >= m.month_start
        AND ce.churn_date < m.month_start + INTERVAL '1 month'
    GROUP BY
        m.month_start
)

SELECT
    month_start,
    (month_start + INTERVAL '1 month' - INTERVAL '1 day')::DATE AS month_end,
    starting_active_paid_accounts,
    churned_accounts,
    churn_events,
    ROUND(
        churned_accounts * 100.0 / NULLIF(starting_active_paid_accounts, 0),
        2
    ) AS churn_rate_percent
FROM monthly_churn
ORDER BY
    month_start;

-- ============================================================
-- 9. Churn Rate by Plan Tier
--
-- Business question:
-- Which plan tiers have the highest estimated account churn rate
-- in the latest reporting month?
--
-- Logic:
-- Use the latest month available in the subscription data as the
-- reporting month. For each account-level plan tier, calculate the
-- active paid account base at the start of the month. Then count
-- distinct accounts from that base that had a churn event during
-- the same month.
--
-- This is an estimated account churn rate by plan tier, not revenue churn.
-- Plan tier is joined from the accounts table.
--
-- Insight:
-- Enterprise has the highest estimated account churn rate in the
-- latest reporting month, but churn rates are relatively close
-- across plan tiers.
-- ============================================================

WITH reporting_month AS (
    SELECT
        DATE_TRUNC('month', MAX(start_date))::DATE AS month_start
    FROM subscriptions
),

active_base AS (
    SELECT DISTINCT
        rm.month_start,
        a.plan_tier,
        s.account_id
    FROM reporting_month rm
    JOIN subscriptions s
        ON s.start_date <= rm.month_start
        AND (
            s.end_date IS NULL
            OR s.end_date >= rm.month_start
        )
        AND s.is_trial = FALSE
        AND s.mrr_amount > 0
    LEFT JOIN accounts a
        ON s.account_id = a.account_id
),

plan_churn AS (
    SELECT
        ab.month_start,
        ab.plan_tier,
        COUNT(DISTINCT ab.account_id) AS starting_active_paid_accounts,
        COUNT(DISTINCT ce.account_id) AS churned_accounts,
        COUNT(ce.churn_event_id) AS churn_events
    FROM active_base ab
    LEFT JOIN churn_events ce
        ON ce.account_id = ab.account_id
        AND ce.churn_date >= ab.month_start
        AND ce.churn_date < ab.month_start + INTERVAL '1 month'
    GROUP BY
        ab.month_start,
        ab.plan_tier
)

SELECT
    month_start,
    (month_start + INTERVAL '1 month' - INTERVAL '1 day')::DATE AS month_end,
    plan_tier,
    starting_active_paid_accounts,
    churned_accounts,
    churn_events,
    ROUND(
        churned_accounts * 100.0 / NULLIF(starting_active_paid_accounts, 0),
        2
    ) AS churn_rate_percent
FROM plan_churn
ORDER BY
    churn_rate_percent DESC;
