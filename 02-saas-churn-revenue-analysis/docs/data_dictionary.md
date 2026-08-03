# Data Dictionary

## Dataset Overview

This project uses the RavenStack synthetic SaaS dataset.

Dataset type: synthetic multi-table SaaS dataset  
Use case: churn analysis, subscription revenue analysis, product usage analysis, support impact analysis  
Author credit: River @ Rivalytics  
License: MIT-like, fully synthetic, no PII

## Tables

The dataset contains 5 CSV tables:

| Table | Rows | Description |
|---|---:|---|
| `ravenstack_accounts.csv` | 500 | Customer/account-level data |
| `ravenstack_subscriptions.csv` | 5,000 | Subscription and recurring revenue data |
| `ravenstack_feature_usage.csv` | 25,000 | Product feature usage events |
| `ravenstack_support_tickets.csv` | 2,000 | Customer support tickets |
| `ravenstack_churn_events.csv` | 600 | Customer churn events and churn reasons |

## Table Relationships

The dataset is structured around customer accounts.  
Each account can have multiple subscriptions, support tickets, and churn events.  
Each subscription can have multiple feature usage events.

```text
accounts
│
├── subscriptions
│   └── feature_usage
│
├── support_tickets
└── churn_events
```

## Relationship Keys

| From Table | Column | To Table | Column | Relationship |
|---|---|---|---|---|
| `subscriptions` | `account_id` | `accounts` | `account_id` | Many subscriptions can belong to one account |
| `feature_usage` | `subscription_id` | `subscriptions` | `subscription_id` | Many usage events can belong to one subscription |
| `support_tickets` | `account_id` | `accounts` | `account_id` | Many support tickets can belong to one account |
| `churn_events` | `account_id` | `accounts` | `account_id` | Many churn events can belong to one account |

---

## 1. accounts

Customer/account-level table.

| Column | Description |
|---|---|
| `account_id` | Unique customer/account identifier |
| `account_name` | Fictional company name |
| `industry` | Customer industry or SaaS vertical |
| `country` | Customer country code |
| `signup_date` | Date when the account signed up |
| `referral_source` | Acquisition source such as organic, ads, event, partner, or other |
| `plan_tier` | Initial plan tier |
| `seats` | Number of licensed users |
| `is_trial` | Whether the account is currently trialing |
| `churn_flag` | Whether the account churned at any point |

---

## 2. subscriptions

Subscription-level table with recurring revenue fields.

| Column | Description |
|---|---|
| `subscription_id` | Unique subscription identifier |
| `account_id` | Foreign key connected to `accounts.account_id` |
| `start_date` | Subscription start date |
| `end_date` | Subscription end date; null means active subscription |
| `plan_tier` | Plan tier at the time of billing |
| `seats` | Number of licensed seats |
| `mrr_amount` | Monthly recurring revenue amount |
| `arr_amount` | Annual recurring revenue amount |
| `is_trial` | Whether the subscription is trialing |
| `upgrade_flag` | Whether the plan was upgraded mid-cycle |
| `downgrade_flag` | Whether the plan was downgraded mid-cycle |
| `churn_flag` | Whether the subscription ended |
| `billing_frequency` | Monthly or annual billing |
| `auto_renew_flag` | Whether auto-renew is enabled |

---

## 3. feature_usage

Product usage event table.

| Column | Description |
|---|---|
| `usage_id` | Unique usage event identifier |
| `subscription_id` | Foreign key connected to `subscriptions.subscription_id` |
| `usage_date` | Date of feature usage |
| `feature_name` | Product feature name |
| `usage_count` | Number of usage events |
| `usage_duration_secs` | Time spent using the feature in seconds |
| `error_count` | Number of errors during usage |
| `is_beta_feature` | Whether the used feature is a beta feature |

---

## 4. support_tickets

Customer support ticket table.

| Column | Description |
|---|---|
| `ticket_id` | Unique support ticket identifier |
| `account_id` | Foreign key connected to `accounts.account_id` |
| `submitted_at` | Ticket submission datetime |
| `closed_at` | Ticket closed datetime |
| `resolution_time_hours` | Total resolution time in hours |
| `priority` | Ticket priority: low, medium, high, urgent |
| `first_response_time_minutes` | Time to first support response |
| `satisfaction_score` | Customer satisfaction score from 1 to 5; can be null |
| `escalation_flag` | Whether the ticket was escalated |

---

## 5. churn_events

Customer churn event table.

| Column | Description |
|---|---|
| `churn_event_id` | Unique churn event identifier |
| `account_id` | Foreign key connected to `accounts.account_id` |
| `churn_date` | Date when the customer churned |
| `reason_code` | Churn reason category |
| `refund_amount_usd` | Refund amount in USD |
| `preceding_upgrade_flag` | Whether the account upgraded within 90 days before churn |
| `preceding_downgrade_flag` | Whether the account downgraded within 90 days before churn |
| `is_reactivation` | Whether the churn event relates to a previously reactivated account |
| `feedback_text` | Optional customer feedback text |

---

## Initial Data Quality Checks To Perform Later

These checks will be validated later using Python and SQL:

1. Check row counts for all 5 tables.
2. Check missing values in important fields.
3. Check duplicate primary keys.
4. Check foreign key consistency between related tables.
5. Check date logic: signup date, subscription start/end date, churn date.
6. Check revenue values: MRR and ARR should not be negative.
7. Check active subscriptions where `end_date` is null.
8. Check churned subscriptions where `churn_flag = true`.
9. Check support tickets with missing satisfaction scores.
10. Check feature usage records with errors.
