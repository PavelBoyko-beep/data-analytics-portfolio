DROP TABLE IF EXISTS feature_usage;
DROP TABLE IF EXISTS support_tickets;
DROP TABLE IF EXISTS churn_events;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS accounts;

-- ============================================================
-- 1. Accounts
-- One row = one customer account / company
-- ============================================================

CREATE TABLE accounts (
    account_id TEXT PRIMARY KEY,
    account_name TEXT,
    industry TEXT,
    country TEXT,
    signup_date DATE,
    referral_source TEXT,
    plan_tier TEXT,
    seats INTEGER,
    is_trial BOOLEAN,
    churn_flag BOOLEAN
);

-- ============================================================
-- 2. Subscriptions
-- One row = one subscription record
-- ============================================================

CREATE TABLE subscriptions (
    subscription_id TEXT PRIMARY KEY,
    account_id TEXT,
    start_date DATE,
    end_date DATE,
    plan_tier TEXT,
    seats INTEGER,
    mrr_amount NUMERIC(12, 2),
    arr_amount NUMERIC(12, 2),
    is_trial BOOLEAN,
    upgrade_flag BOOLEAN,
    downgrade_flag BOOLEAN,
    churn_flag BOOLEAN,
    billing_frequency TEXT,
    auto_renew_flag BOOLEAN,

    CONSTRAINT fk_subscriptions_accounts
        FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);

-- ============================================================
-- 3. Feature Usage
-- One row = one product feature usage event
--
-- Note:
-- The original usage_id is not fully unique in the raw dataset.
-- Therefore, feature_usage_id is used as the technical primary key.
-- ============================================================

CREATE TABLE feature_usage (
    feature_usage_id INTEGER PRIMARY KEY,
    usage_id TEXT,
    subscription_id TEXT,
    usage_date DATE,
    feature_name TEXT,
    usage_count INTEGER,
    usage_duration_secs INTEGER,
    error_count INTEGER,
    is_beta_feature BOOLEAN,

    CONSTRAINT fk_feature_usage_subscriptions
        FOREIGN KEY (subscription_id)
        REFERENCES subscriptions(subscription_id)
);

-- ============================================================
-- 4. Support Tickets
-- One row = one customer support ticket
-- ============================================================

CREATE TABLE support_tickets (
    ticket_id TEXT PRIMARY KEY,
    account_id TEXT,
    submitted_at TIMESTAMP,
    closed_at TIMESTAMP,
    resolution_time_hours NUMERIC(10, 2),
    priority TEXT,
    first_response_time_minutes INTEGER,
    satisfaction_score NUMERIC(3, 1),
    escalation_flag BOOLEAN,

    CONSTRAINT fk_support_tickets_accounts
        FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);

-- ============================================================
-- 5. Churn Events
-- One row = one churn event
-- ============================================================

CREATE TABLE churn_events (
    churn_event_id TEXT PRIMARY KEY,
    account_id TEXT,
    churn_date DATE,
    reason_code TEXT,
    refund_amount_usd NUMERIC(10, 2),
    preceding_upgrade_flag BOOLEAN,
    preceding_downgrade_flag BOOLEAN,
    is_reactivation BOOLEAN,
    feedback_text TEXT,

    CONSTRAINT fk_churn_events_accounts
        FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);
