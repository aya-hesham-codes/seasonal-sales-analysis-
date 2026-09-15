import pandas as pd

# ---------------------------------------------------------------------
# Load the sales file
# ---------------------------------------------------------------------
sales = pd.read_excel("sales_data.xlsx", sheet_name="Sales")


def h(t):
    print(f"\n----- {t} -----")


# ---------------------------------------------------------------------
# 1. Strip stray whitespace from text columns
# ---------------------------------------------------------------------
h("1. Whitespace cleanup")

text_cols = sales.select_dtypes(include=["object", "str"]).columns
changed = 0

for col in text_cols:
    cleaned = (
        sales[col]
        .astype(str)
        .str.strip()
        .str.replace(r"\s+", " ", regex=True)
    )

    changed += (cleaned != sales[col].astype(str)).sum()
    sales[col] = cleaned

print(f"Sales: {changed} cell(s) had whitespace fixed")


# ---------------------------------------------------------------------
# 2. Drop exact duplicate rows
# ---------------------------------------------------------------------
h("2. Drop exact duplicate rows")

before = len(sales)

sales.drop_duplicates(inplace=True)

print(f"Sales: {before - len(sales)} duplicate row(s) removed")


# ---------------------------------------------------------------------
# 3. Drop duplicate SaleID (keep first occurrence)
# ---------------------------------------------------------------------
h("3. Drop duplicate SaleID")

before = len(sales)

sales.drop_duplicates(
    subset="SaleID",
    keep="first",
    inplace=True
)

print(
    f"Sales: {before - len(sales)} row(s) removed "
    "for duplicate SaleID"
)


# ---------------------------------------------------------------------
# 4. Handle missing values
# ---------------------------------------------------------------------
h("4. Handle missing values")

null_counts = sales.isnull().sum()
null_counts = null_counts[null_counts > 0]

if len(null_counts) == 0:
    print("Sales: no missing values")

else:
    print(f"Sales: filling {dict(null_counts)}")

    for col in null_counts.index:

        if (
            sales[col].dtype == object
            or str(sales[col].dtype) == "str"
        ):
            sales[col] = sales[col].fillna("Unknown")

        else:
            sales[col] = sales[col].fillna(
                sales[col].median()
            )


# ---------------------------------------------------------------------
# 5. Fix out-of-range values
# ---------------------------------------------------------------------
h("5. Fix out-of-range values")

# Discount percentages must be between 0 and 1
bad_disc = (
    (sales["DiscountPercent"] < 0)
    | (sales["DiscountPercent"] > 1)
).sum()

sales["DiscountPercent"] = sales["DiscountPercent"].clip(0, 1)

print(
    f"Sales.DiscountPercent: {bad_disc} "
    "out-of-range value(s) clipped to [0, 1]"
)


# Quantity and price must be positive
# Rows with non-positive values are removed
before = len(sales)

sales = sales[
    (sales["Quantity"] > 0)
    & (sales["UnitPrice"] > 0)
]

print(
    f"Sales: {before - len(sales)} row(s) dropped "
    "for non-positive Quantity/UnitPrice"
)


# ---------------------------------------------------------------------
# 6. Recompute derived financial columns
# ---------------------------------------------------------------------
h("6. Recompute derived columns")

sales["GrossAmount"] = (
    sales["Quantity"] * sales["UnitPrice"]
).round(2)

sales["NetAmount"] = (
    sales["GrossAmount"]
    * (1 - sales["DiscountPercent"])
).round(2)

print(
    "Sales.GrossAmount / NetAmount recalculated "
    "from Quantity, UnitPrice, DiscountPercent"
)


# ---------------------------------------------------------------------
# 7. Ensure correct dtype for Date
# ---------------------------------------------------------------------
h("7. Ensure correct dtype")

sales["Date"] = pd.to_datetime(
    sales["Date"],
    errors="coerce"
)

print("Sales.Date converted to datetime")


# ---------------------------------------------------------------------
# 8. Save cleaned file
#    Original sales_data.xlsx remains untouched
# ---------------------------------------------------------------------
h("8. Save cleaned file")

sales.to_excel(
    "sales_data_cleaned.xlsx",
    sheet_name="Sales",
    index=False
)

print("Saved: sales_data_cleaned.xlsx")


# ---------------------------------------------------------------------
# Final shape
# ---------------------------------------------------------------------
h("Final shape")

print("Sales:", sales.shape)