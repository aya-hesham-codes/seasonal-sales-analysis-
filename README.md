# Seasonal Sales Performance Analysis — Investigating the Summer Decline

A data analysis project investigating a significant, worsening drop in
sales during the summer season (2024–2025), using Python for data
cleaning, MySQL for exploratory and comparative analysis, and Power BI
for an interactive business dashboard.

## Business Question

Why did sales decline sharply every summer, and did the problem get
better or worse between 2024 and 2025? The analysis breaks this down
into: what happened, how severe it was, where it was concentrated, and
what the business should investigate next.

## Files in this Repository

| File | Description |
|---|---|
| `sales_data.xlsx` | Raw source data |
| `sales_analysis.py` | Python cleaning pipeline (raw → cleaned) |
| `sales_data_cleaned.csv` | Cleaned dataset, output of the Python script — used by both SQL and Power BI |
| `create_database.sql` | Builds the MySQL schema and loads the cleaned CSV |
| `sales_analysis.sql` | Seasonal comparison queries (Before/During/After framing) |
| `ANALYSIS.md` | Written findings and conclusions from the SQL queries |
| `sales.pbix` | Interactive 3-page Power BI dashboard |

## Tools Used

- **Python (Pandas)** — data cleaning and validation
- **MySQL** — seasonal aggregation and before/during/after comparison
- **Power BI (DAX, Power Query)** — interactive dashboard and root-cause visuals

## 1. Data Cleaning (`sales_analysis.py`)

Raw sales data (`sales_data.xlsx`) is cleaned before any analysis:
- Whitespace trimmed and normalized across all text columns
- Exact duplicate rows removed, plus duplicate `SaleID`s (keeping the first occurrence)
- Missing values filled (median for numeric columns, "Unknown" for text)
- `DiscountPercent` clipped to a valid 0–1 range; rows with non-positive `Quantity`/`UnitPrice` dropped
- `GrossAmount` and `NetAmount` recalculated directly from `Quantity`, `UnitPrice`, and `DiscountPercent` to guarantee consistency
- `Date` cast to a proper datetime type

Output: `sales_data_cleaned.csv`, used by both the SQL and Power BI stages.

## 2. Database & SQL Analysis (`create_database.sql`, `sales_analysis.sql`)

`create_database.sql` builds the `sales_analysis.sales` table and loads
the cleaned CSV. `sales_analysis.sql` then reframes the four calendar
seasons around summer as **Before (Spring) → During (Summer) → After
(Fall)**, and computes:
- Total sales, distinct customers, distinct orders, and AOV per period, per year
- The percentage change between each period, to quantify the size of the drop and any recovery

Full interpreted results and conclusions are in **[`ANALYSIS.md`](ANALYSIS.md)**.

### Key findings
- Sales dropped **52.3%** from Spring to Summer in 2024 — and that worsened to a **71.3%** drop in 2025.
- The decline is driven by a combination of fewer customers, fewer orders (the largest single factor), and lower average order value — not one cause alone.
- Every metric's decline deepened year-over-year, indicating a worsening pattern rather than a one-off dip.

## 3. Power BI Dashboard (`sales.pbix`)

A three-page interactive report:

1. **Cover** — headline stat (−34.2% YoY summer sales) and page navigation
2. **Overview & Severity** — KPI cards, season-by-season performance matrix, 2024 vs. 2025 comparison, and a sales trend line
3. **Root Cause & Findings** — category and channel breakdowns, a discounting hypothesis check, and a final Key Findings / Recommended Actions summary

The report is filterable by Year, Category, and Channel throughout.

### Additional findings from the dashboard
- The decline is broad-based across product categories, not concentrated in one
- All sales channels (Online, In-Store, Mobile App) declined by a similar amount — not channel-specific
- Average discount was actually *higher* in summer than other seasons, which argues against low discounting as the cause

## How to Reproduce

1. Run `sales_analysis.py` against the raw `sales_data.xlsx` to produce the cleaned dataset.
2. Run `create_database.sql` (update the file path to your local CSV location) to build and populate the database.
3. Run `sales_analysis.sql` for the seasonal comparison queries — see `ANALYSIS.md` for the interpreted results.
4. Open `sales.pbix` in Power BI Desktop to explore the full interactive dashboard.

## Author

**Aya Hesham Ahmed**
AI Engineering student, aspiring Data Analyst
[github.com/aya-hesham-codes](https://github.com/aya-hesham-codes) · aya367009@gmail.com