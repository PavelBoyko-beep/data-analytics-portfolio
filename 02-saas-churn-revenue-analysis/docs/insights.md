# Insights

This document summarizes the main business insights from the SQL analysis stage of the SaaS Churn & Revenue Analysis project.

The insights are based on PostgreSQL queries stored in:

```text
sql/04_business_analysis.sql
```

---

## Key Insights

### 1. MRR shows steady month-over-month growth

End-of-month MRR increases steadily throughout the observed period.

This suggests that the synthetic SaaS business is growing its paid subscription base over time.

**Business meaning:**  
The company is expanding revenue consistently, but the smooth growth pattern should be interpreted carefully because the dataset is synthetic.

---

### 2. Current recurring revenue is strong at the latest reporting date

As of the latest reporting date, `2024-12-31`, the business has:

| Metric | Value |
|---|---:|
| Active paid accounts | 500 |
| Active paid subscriptions | 3,836 |
| Current MRR | 10.26M |
| Current ARR | 123.11M |
| Average MRR per account | 20.52K |

**Business meaning:**  
The company has a large active paid base and strong recurring revenue at the end of the dataset period.

---

### 3. Enterprise is the main revenue driver

Enterprise contributes the largest share of current MRR:

| Plan tier | MRR share |
|---|---:|
| Enterprise | 74.46% |
| Pro | 18.81% |
| Basic | 6.72% |

**Business meaning:**  
Enterprise customers are the most important revenue segment. Retention and customer success efforts should pay special attention to this tier.

---

### 4. Enterprise has the highest revenue efficiency

Enterprise has the highest average revenue per account and per subscription:

| Plan tier | Avg MRR per account | Avg MRR per subscription |
|---|---:|---:|
| Enterprise | 16,535.52 | 5,805.02 |
| Pro | 4,327.82 | 1,498.61 |
| Basic | 1,539.93 | 559.98 |

**Business meaning:**  
Enterprise does not only contribute more total MRR; it also generates much more revenue per customer and per subscription.

---

### 5. Churn increases toward the end of the observed period

Monthly churn events increase toward the end of 2024.

The highest churn volume appears in December 2024:

| Month | Churn events | Churned accounts |
|---|---:|---:|
| 2024-12 | 117 | 96 |

**Business meaning:**  
Churn pressure becomes more visible near the end of the period. This should be investigated further before assuming the growth trend is fully healthy.

---

### 6. Feature-related churn is the most common reason, but churn reasons are distributed

The most common churn reason is `features`, but the distribution is relatively balanced:

| Reason code | Churn events | Share |
|---|---:|---:|
| features | 114 | 19.00% |
| budget | 104 | 17.33% |
| support | 104 | 17.33% |
| unknown | 95 | 15.83% |
| competitor | 92 | 15.33% |
| pricing | 91 | 15.17% |

**Business meaning:**  
Churn does not appear to come from one single dominant issue. Product features are the top reason, but budget, support, competitors, and pricing also matter.

---

### 7. Estimated monthly account churn rate reaches 16.24% in December 2024

The estimated monthly account churn rate increases toward the end of 2024.

In December 2024:

| Metric | Value |
|---|---:|
| Starting active paid accounts | 474 |
| Churned accounts | 77 |
| Churn events | 87 |
| Estimated churn rate | 16.24% |

**Business meaning:**  
A 16.24% estimated monthly churn rate is a warning signal. The business should investigate why churn increased in the latest month.

**Important limitation:**  
This is an estimated account churn rate, not revenue churn. It is calculated using churn events and the active paid account base at the start of the month.

---

### 8. Churn rate is relatively close across plan tiers

In the latest reporting month, estimated churn rate by plan tier is:

| Plan tier | Starting active paid accounts | Churned accounts | Estimated churn rate |
|---|---:|---:|---:|
| Enterprise | 147 | 26 | 17.69% |
| Pro | 172 | 29 | 16.86% |
| Basic | 155 | 22 | 14.19% |

**Business meaning:**  
Enterprise has the highest estimated churn rate, but the difference between tiers is moderate. Churn should be investigated across all tiers, with extra attention to Enterprise because it drives most revenue.

---

### 9. Churned accounts have a slightly higher escalation rate

Support metrics are very similar between churned and non-churned accounts, except for escalation rate:

| Churn status | Avg support tickets per account | Escalation rate | Avg satisfaction score |
|---|---:|---:|---:|
| Churned | 3.96 | 5.09% | 3.96 |
| Not churned | 4.09 | 3.97% | 3.97 |

**Business meaning:**  
Churned accounts show a slightly higher escalation rate, which means their support tickets were more often passed to a higher support level. This may be worth further investigation.

**Important limitation:**  
This shows association, not causation. It does not prove that support issues caused churn.

---

### 10. Feature usage and error rates are relatively balanced

Feature usage and error rates are relatively evenly distributed across features.

No single feature strongly dominates usage or error volume.

**Business meaning:**  
The dataset does not show one obvious feature that is responsible for most usage or most errors. Product usage appears balanced in this synthetic dataset.

**Important limitation:**  
`feature_usage.usage_date` has a documented lifecycle inconsistency, so feature usage was not used for lifecycle or cohort analysis.

---

### 11. Revenue concentration is relatively low

The largest accounts do not dominate current MRR.

| Group | MRR share |
|---|---:|
| Largest account | 1.29% |
| Top 20 accounts | 14.49% |

**Business meaning:**  
Current MRR is relatively diversified across the account base. The business is not heavily dependent on only a few large customers.

---

## Recommendations

### 1. Prioritize Enterprise retention

Enterprise contributes 74.46% of current MRR and has the highest revenue efficiency.

Recommended actions:

- monitor Enterprise churn closely;
- review Enterprise churn reasons;
- strengthen customer success for Enterprise accounts;
- identify early warning signals before Enterprise customers churn.

---

### 2. Investigate the December churn increase

December 2024 shows the highest churn volume and the highest estimated monthly churn rate.

Recommended actions:

- review churn reasons in December;
- compare churned accounts by plan tier;
- check whether churn is connected to support escalations, pricing, or missing features;
- investigate whether December is an anomaly or part of a trend.

---

### 3. Improve feature-related churn understanding

`features` is the most common churn reason.

Recommended actions:

- collect more detailed feedback for feature-related churn;
- identify which missing or weak features are mentioned most often;
- connect churn feedback with product roadmap decisions;
- improve feedback collection because some churn reasons are marked as `unknown`.

---

### 4. Monitor support escalations

Churned accounts have a slightly higher escalation rate than non-churned accounts.

Recommended actions:

- monitor escalated tickets as a possible churn risk signal;
- review escalated ticket topics;
- improve resolution process for escalated issues;
- track whether escalated accounts churn more often in future periods.

---

### 5. Keep revenue concentration low

Top 20 accounts contribute only 14.49% of current MRR, which suggests relatively low concentration risk.

Recommended actions:

- continue growing a broad paid customer base;
- avoid overdependence on a small number of large accounts;
- monitor top-account revenue concentration over time.

---

## Notes and Limitations

- The dataset is synthetic, so business patterns may appear smoother than in real SaaS data.
- MRR and ARR are based on active paid subscriptions and exclude trial subscriptions.
- Churn rate calculations are estimates based on churn events and active paid account base.
- Revenue churn was not calculated in this SQL stage.
- `feature_usage.usage_date` has a documented lifecycle inconsistency, so feature usage was not used for lifecycle, cohort, or time-to-first-usage analysis.
- Support analysis shows association, not causation.
