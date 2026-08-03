-- ============================================================
-- SaaS Churn & Revenue Analysis
-- 02_import_data.sql
--
-- Purpose:
-- Document the processed CSV import process into PostgreSQL.
--
-- Note:
-- In this project, CSV files were imported using DBeaver's Import Data UI.
-- This file documents the required import order, target tables, and
-- post-import validation steps.
-- ============================================================

-- ============================================================
-- 1. Import order
-- ============================================================
-- Import the processed CSV files in this order because of foreign key relationships:
--
-- 1. data/processed/accounts_clean.csv        -> accounts
-- 2. data/processed/subscriptions_clean.csv   -> subscriptions
-- 3. data/processed/feature_usage_clean.csv   -> feature_usage
-- 4. data/processed/support_tickets_clean.csv -> support_tickets
-- 5. data/processed/churn_events_clean.csv    -> churn_events
--
-- Relationship logic:
-- accounts -> subscriptions -> feature_usage
-- accounts -> support_tickets
-- accounts -> churn_events

-- ============================================================
-- 2. DBeaver import settings used
-- ============================================================
-- Source type: CSV
-- Target schema: public
-- Target tables: existing PostgreSQL tables
-- Header row: enabled
-- Delimiter: comma
-- Encoding: UTF-8
-- Transactions: enabled
-- Referential integrity checks: enabled

-- ============================================================
-- 3. Post-import cleanup
-- ============================================================
-- DBeaver imported blank feedback_text values as empty strings.
-- Convert blank strings to NULL to match pandas missing value logic.

UPDATE churn_events
SET feedback_text = NULL
WHERE TRIM(feedback_text) = '';

-- ============================================================
-- 4. Post-import row count validation
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

-- Expected row counts:
-- accounts        = 500
-- subscriptions   = 5000
-- feature_usage   = 25000
-- support_tickets = 2000
-- churn_events    = 600
