# Seasonal Sales Analysis — SQL Findings
Based on `sales_analysis.sales` (source: `sales_data_cleaned.csv`)

> **Data note:** an earlier version of this table had duplicate rows from a
> repeated data load, which inflated dollar totals 2×; percentage changes
> were unaffected since the scale factor cancels out in a ratio. The table
> was corrected via `TRUNCATE TABLE sales;` followed by a single reload
> before this analysis was finalized.

## Query 3 results (Before = Spring, During = Summer, After = Fall)

| Year | Period | Total Sales | Customers | Orders | AOV |
|---|---|---|---|---|---|
| 2024 | Before (Spring) | $20,673.31 | 72 | 185 | $111.75 |
| 2024 | During (Summer) | $9,857.65 | 62 | 113 | $87.24 |
| 2024 | After (Fall) | $22,033.07 | 71 | 193 | $114.16 |
| 2024 | Off-Season (Winter) | $20,462.52 | 69 | 190 | $107.70 |
| 2025 | Before (Spring) | $22,594.02 | 67 | 194 | $116.46 |
| 2025 | During (Summer) | $6,484.61 | 49 | 90 | $72.05 |
| 2025 | After (Fall) | $20,968.04 | 74 | 203 | $103.29 |
| 2025 | Off-Season (Winter) | $22,361.46 | 73 | 199 | $112.37 |

## Query 4 results (% change)

| Year | Metric | Before → During | During → After |
|---|---|---|---|
| 2024 | Sales | **−52.32%** | +123.51% |
| 2024 | Customers | −13.89% | +14.52% |
| 2024 | Orders | −38.92% | +70.80% |
| 2024 | AOV | −21.93% | +30.86% |
| 2025 | Sales | **−71.30%** | +223.35% |
| 2025 | Customers | −26.87% | +51.02% |
| 2025 | Orders | −53.61% | +125.56% |
| 2025 | AOV | −38.13% | +43.36% |

---

## Analysis

**1. The summer decline is real, severe, and getting worse.**
Sales dropped 52.3% from Spring to Summer in 2024 — already a major drop —
but that worsened to a 71.3% drop in 2025. This is the single most
important number in the whole analysis: whatever caused the 2024 dip
intensified rather than resolved itself in 2025.

**2. The recovery after summer is not proportional — it looks large only
because the summer base is so small.**
The After-season percentage changes look dramatic (+123.5% in 2024,
+223.4% in 2025), but that's a mathematical effect of dividing by a small
Summer number, not evidence of an unusually strong Fall.

In dollar terms, Fall 2024 ($22,033) and Fall 2025 ($20,968) are close to
Spring's levels in both years — Fall isn't "booming"; Summer is simply
collapsing.

**3. All three levers — customers, orders, and AOV — contributed, but
order volume moved the most.**
Comparing the Before → During drops:

- Customers: −13.9% (2024) / −26.9% (2025)
- Orders: −38.9% (2024) / −53.6% (2025)
- AOV: −21.9% (2024) / −38.1% (2025)

Orders fell substantially more than customer count in both years. This
means the decline was not simply caused by fewer customers — customers
also placed fewer orders, while spending per order also decreased.

All three factors moved in the same negative direction, which contributed
to the overall decline in Summer sales.

**4. Year-over-year, every metric's decline deepened, not just sales.**
This shows that the Summer weakness was not simply a one-time sales
fluctuation. The overall pattern became more severe in 2025, with
customers, orders, and AOV all contributing to the decline.

## What this means for the rest of the report

This SQL-level finding is the foundation for the "Why Did Sales Decline?"
section of the dashboard.

The answer is a combination of three factors:

- Fewer customers
- Fewer orders, with order volume showing the largest decline
- Lower Average Order Value

The decline therefore cannot be attributed to a single metric alone. The
SQL analysis establishes what happened, while the Power BI analysis helps
investigate the potential business drivers behind the decline.
