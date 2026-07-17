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

-- ============================================================
-- 10. Support Tickets and Churn
--
-- Business question:
-- Do churned accounts show different support patterns compared
-- with non-churned accounts?
--
-- Logic:
-- Aggregate support ticket metrics at the account level.
-- Then classify accounts as churned or not churned based on whether
-- they have at least one churn event. Compare support volume,
-- escalation rate, response time, resolution time, and satisfaction.
--
-- This comparison shows association, not causation.
--
-- Insight:
-- Churned accounts show a higher escalation rate than non-churned
-- accounts, while support ticket volume, response time, resolution
-- time, and satisfaction are very similar.
-- ============================================================

WITH account_support AS (
    SELECT
        account_id,
        COUNT(ticket_id) AS support_tickets,
        SUM(CASE WHEN escalation_flag = TRUE THEN 1 ELSE 0 END) AS escalated_tickets,
        AVG(resolution_time_hours) AS avg_resolution_time_hours,
        AVG(first_response_time_minutes) AS avg_first_response_minutes,
        AVG(satisfaction_score) AS avg_satisfaction_score
    FROM support_tickets
    GROUP BY
        account_id
),

account_churn AS (
    SELECT
        account_id,
        COUNT(*) AS churn_events,
        MAX(churn_date) AS last_churn_date
    FROM churn_events
    GROUP BY
        account_id
),

account_level AS (
    SELECT
        a.account_id,
        CASE
            WHEN ac.churn_events IS NULL THEN 'not_churned'
            ELSE 'churned'
        END AS churn_status,
        COALESCE(ac.churn_events, 0) AS churn_events,
        COALESCE(sup.support_tickets, 0) AS support_tickets,
        COALESCE(sup.escalated_tickets, 0) AS escalated_tickets,
        sup.avg_resolution_time_hours,
        sup.avg_first_response_minutes,
        sup.avg_satisfaction_score
    FROM accounts a
    LEFT JOIN account_churn ac
        ON a.account_id = ac.account_id
    LEFT JOIN account_support sup
        ON a.account_id = sup.account_id
)

SELECT
    churn_status,
    COUNT(*) AS accounts,
    SUM(CASE WHEN support_tickets > 0 THEN 1 ELSE 0 END) AS accounts_with_support_tickets,
    SUM(churn_events) AS churn_events,
    ROUND(AVG(support_tickets), 2) AS avg_support_tickets_per_account,
    SUM(support_tickets) AS total_support_tickets,
    SUM(escalated_tickets) AS total_escalated_tickets,
    ROUND(
        SUM(escalated_tickets) * 100.0 / NULLIF(SUM(support_tickets), 0),
        2
    ) AS escalation_rate_percent,
    ROUND(AVG(avg_resolution_time_hours), 2) AS avg_resolution_time_hours,
    ROUND(AVG(avg_first_response_minutes), 2) AS avg_first_response_minutes,
    ROUND(AVG(avg_satisfaction_score), 2) AS avg_satisfaction_score
FROM account_level
GROUP BY
    churn_status
ORDER BY
    churn_status;


-- ============================================================
-- 11. Feature Usage Summary
--
-- Business question:
-- Which product features are used the most, and which features
-- have the highest error volume?
--
-- Logic:
-- Aggregate feature usage by feature_name. Count usage events,
-- distinct subscriptions and accounts using each feature, total usage,
-- total duration, beta usage events, and error metrics.
--
-- Note:
-- feature_usage.usage_date has a documented lifecycle inconsistency,
-- so this query does not use usage_date for lifecycle or cohort logic.
--
-- Insight:
-- Feature usage and error rates are relatively evenly distributed
-- across features in this synthetic dataset, with no single feature
-- strongly dominating usage or error volume.
-- ============================================================

WITH feature_summary AS (
    SELECT
        fu.feature_name,
        COUNT(*) AS usage_events,
        COUNT(DISTINCT fu.subscription_id) AS subscriptions_using_feature,
        COUNT(DISTINCT s.account_id) AS accounts_using_feature,
        SUM(fu.usage_count) AS total_usage_count,
        SUM(fu.usage_duration_secs) AS total_usage_duration_secs,
        ROUND(AVG(fu.usage_duration_secs), 2) AS avg_duration_secs_per_event,
        SUM(fu.error_count) AS total_errors,
        SUM(CASE WHEN fu.error_count > 0 THEN 1 ELSE 0 END) AS events_with_errors,
        SUM(CASE WHEN fu.is_beta_feature = TRUE THEN 1 ELSE 0 END) AS beta_usage_events
    FROM feature_usage fu
    LEFT JOIN subscriptions s
        ON fu.subscription_id = s.subscription_id
    GROUP BY
        fu.feature_name
)

SELECT
    feature_name,
    usage_events,
    subscriptions_using_feature,
    accounts_using_feature,
    total_usage_count,
    total_usage_duration_secs,
    avg_duration_secs_per_event,
    total_errors,
    events_with_errors,
    ROUND(
        events_with_errors * 100.0 / NULLIF(usage_events, 0),
        2
    ) AS event_error_rate_percent,
    ROUND(
        total_errors * 100.0 / NULLIF(total_usage_count, 0),
        2
    ) AS errors_per_100_usage_actions,
    beta_usage_events
FROM feature_summary
ORDER BY
    total_usage_count DESC;
