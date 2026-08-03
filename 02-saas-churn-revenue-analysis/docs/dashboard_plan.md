# Dashboard Plan

This document defines the planned Power BI dashboard structure for the SaaS Churn & Revenue Analysis project.

The dashboard is based on the cleaned CSV files stored in:

```text
data/processed/
```

The main business analysis was performed in SQL. Power BI is used to present the key findings visually.

---

## Dashboard Goal

The dashboard should help answer the following business question:

> How is the SaaS business performing in terms of revenue, churn, and customer risk?

In simple terms, the dashboard should help a viewer quickly understand:

- how much recurring revenue the business currently has;
- which plan tiers drive revenue;
- where churn risk appears;
- whether support activity is connected with churn signals.

---

## Planned Dashboard Pages

| Page | Name | Purpose |
|---:|---|---|
| 1 | Executive Overview | Show the high-level business performance |
| 2 | Revenue Analysis | Explain where current MRR comes from |
| 3 | Churn & Support Risk | Highlight churn patterns and customer risk signals |

---

## Page 1 — Executive Overview

### Purpose

This page gives a quick high-level summary of the SaaS business.

It should help a viewer quickly understand:

- current recurring revenue;
- active paid customer base;
- main revenue-driving plan tier;
- key churn signals.

### Planned visuals

| Visual type | Metric | Source file |
|---|---|---|
| Card | Current MRR | `subscriptions_clean.csv` |
| Card | Current ARR | `subscriptions_clean.csv` |
| Card | Active paid accounts | `subscriptions_clean.csv` |
| Card | Active paid subscriptions | `subscriptions_clean.csv` |
| Bar chart | Current MRR by Plan Tier | `subscriptions_clean.csv` |
| Bar chart | Churn Events by Reason Code | `churn_events_clean.csv` |

### Key message

The business has strong current recurring revenue, but Enterprise drives most MRR and churn requires monitoring.

---

## Page 2 — Revenue Analysis

### Purpose

This page explains where current revenue comes from.

It should help answer:

> Which plan tiers and accounts contribute the most to current MRR?

### Planned visuals

| Visual type | Metric | Source file |
|---|---|---|
| Bar chart | Current MRR by Plan Tier | `subscriptions_clean.csv` |
| Bar chart | Average MRR per Account by Plan Tier | `subscriptions_clean.csv`, `accounts_clean.csv` |
| Bar chart | Average MRR per Subscription by Plan Tier | `subscriptions_clean.csv` |
| Table | Top 20 Accounts by Current MRR | `subscriptions_clean.csv`, `accounts_clean.csv` |

### Key message

Enterprise is the main revenue driver and has the highest revenue efficiency.

### Business context

Enterprise contributes the largest share of current MRR and has the highest average MRR per account and per subscription.

This means Enterprise is the most important revenue segment for the business.

---

## Page 3 — Churn & Support Risk

### Purpose

This page highlights customer churn and support-related risk signals.

It should help answer:

> Where are the main churn and customer risk signals?

### Planned visuals

| Visual type | Metric | Source file |
|---|---|---|
| Line chart | Monthly Churn Events | `churn_events_clean.csv` |
| Bar chart | Churn Events by Reason Code | `churn_events_clean.csv` |
| Bar chart | Churn Rate by Plan Tier | `subscriptions_clean.csv`, `churn_events_clean.csv`, `accounts_clean.csv` |
| Bar chart | Support Escalation Rate by Churn Status | `support_tickets_clean.csv`, `churn_events_clean.csv` |
| Card | December Estimated Churn Rate | calculated metric |

### Key message

Churn increases toward the end of the period, feature-related churn is the top reported reason, and churned accounts show a slightly higher support escalation rate.

### Business context

Churn is not explained by one single issue only.

The top reported churn reason is `features`, but budget, support, competitor, pricing, and unknown reasons are also significant.

Support escalation rate is slightly higher for churned accounts, but this should be interpreted carefully because it shows association, not causation.

---

## Data Sources

The dashboard will use the cleaned CSV files from:

```text
data/processed/
```

Planned files:

| File | Purpose |
|---|---|
| `accounts_clean.csv` | Account-level customer information |
| `subscriptions_clean.csv` | Subscription, revenue, plan tier, MRR and ARR data |
| `churn_events_clean.csv` | Churn events, churn reasons, refunds and churn dates |
| `support_tickets_clean.csv` | Support volume, response time, resolution time and escalation data |
| `feature_usage_clean.csv` | Product usage data, used only with documented limitations |

---

## Metric Rules

### Revenue metrics

Revenue metrics should use active paid subscriptions only.

Trial subscriptions should be excluded from revenue calculations.

Revenue metrics should be based on:

- `is_trial = False`;
- `mrr_amount > 0`;
- subscription active at the latest reporting date.

The latest reporting date used in SQL analysis is:

```text
2024-12-31
```

---

### Churn metrics

Churn metrics are based on `churn_events_clean.csv`.

The monthly churn rate used in the analysis is an estimate.

It is based on churned accounts and the active paid account base at the start of the month.

This is not a production-grade revenue churn calculation.

---

### Support metrics

Support escalation rate is calculated as:

```text
Escalation Rate = Escalated Tickets / Total Support Tickets * 100
```

This metric is used to compare support patterns between churned and non-churned accounts.

Important limitation:

> Support escalation analysis shows association, not causation.

This means it does not prove that support escalations caused churn.

---

## Important Limitations

- The dataset is synthetic, so patterns may look smoother than real SaaS data.
- Trial subscriptions should be excluded from revenue visuals.
- MRR and ARR should be based on active paid subscriptions.
- Churn rate is an estimate, not a production-grade revenue churn calculation.
- Revenue churn was not calculated in this dashboard plan.
- Support escalation analysis shows association, not causation.
- `feature_usage.usage_date` should not be used for lifecycle, cohort, or time-to-first-usage visuals because of documented data quality limitations.

---

## Dashboard Design Principles

The dashboard should be simple and readable.

The first version should prioritize:

- clear business logic;
- readable charts;
- correct metrics;
- simple page structure;
- consistency with SQL insights.

The first version should not prioritize advanced design effects.

Avoid:

- too many visuals on one page;
- decorative charts without business meaning;
- complex DAX before basic metrics are correct;
- using `feature_usage.usage_date` for lifecycle conclusions.

---

## Dashboard Readiness Checklist

Before building the dashboard in Power BI, confirm:

| Check | Status |
|---|---|
| Cleaned CSV files exist in `data/processed/` | Done |
| SQL business analysis is complete | Done |
| Key insights are documented in `docs/insights.md` | Done |
| Dashboard page structure is defined | Done |
| Dashboard metrics are mapped to source files | Done |
| Power BI build is ready to start | Ready |

---

## Next Step

The next step is to load the cleaned CSV files into Power BI Desktop and begin building Page 1 — Executive Overview.
