# 🚕 OLA Ride Analytics — End-to-End Data Analysis Project

<p align="center">
  <img src="https://img.shields.io/badge/MySQL-8.x-blue?style=for-the-badge&logo=mysql&logoColor=white"/>
  <img src="https://img.shields.io/badge/Microsoft_Excel-217346?style=for-the-badge&logo=microsoft-excel&logoColor=white"/>
  <img src="https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black"/>
  <img src="https://img.shields.io/badge/Records-103%2C024-brightgreen?style=for-the-badge"/>
  <img src="https://img.shields.io/badge/Period-July_2024-orange?style=for-the-badge"/>
</p>

---

## 📌 Project Overview

This is a **complete, end-to-end data analytics project** on OLA's ride-booking platform, analysing **103,024 booking records** for the month of **July 2024**. The project answers 10 critical business questions using SQL and presents all findings through a 5-page interactive Power BI dashboard.

| Metric | Value |
|--------|-------|
| 📦 Total Bookings | **103,024** |
| 💰 Total Booking Value | **₹35.08 Million** |
| ✅ Successful Rides | **63,967 (62.09%)** |
| ❌ Cancellation Rate | **28.08%** |
| 🚗 Vehicle Types Analysed | **7** |
| 📅 Data Period | **July 1 – 31, 2024** |

---

## 🛠️ Tools & Technology Stack

| Tool | Role in Project |
|------|----------------|
| **Microsoft Excel** | Raw data inspection, initial exploration & cleaning of `Bookings.csv` |
| **MySQL Workbench 8.x** | Database creation, CSV import, writing 10 SQL Views for analysis |
| **Power BI Desktop** | 5-page interactive dashboard with slicers, KPI cards, pie/bar/line charts |

### Project Workflow

```
Bookings.csv  ──►  Microsoft Excel  ──►  MySQL Workbench  ──►  Power BI  ──►  Insights
 (Raw Data)        (Inspect & Clean)     (SQL Analysis)       (Dashboard)
```

---

## 📁 Repository Structure

```
OLA-Ride-Analytics/
│
├── README.md                     ← Project documentation (this file)
├── ola_project.sql               ← All 10 SQL views
├── Bookings.csv                  ← Raw dataset (103,024 rows × 20 columns)
├── Ola.pbix                      ← Power BI dashboard (5 pages)
│
└── images/
    ├── 00_sql_workbench.png      ← MySQL Workbench in action
    ├── 01_overall_dashboard.jpeg ← Page 1: Overall summary
    ├── 02_vehicle_type.png       ← Page 2: Vehicle type performance
    ├── 03_revenue.jpeg           ← Page 3: Revenue analysis
    ├── 04_cancellation.png       ← Page 4: Cancellation analysis
    └── 05_ratings.png            ← Page 5: Ratings analysis
```

---

## 📋 Step 1 — Data Collection & Exploration (Microsoft Excel)

**What I did:**
- Opened `Bookings.csv` in Microsoft Excel
- Inspected all **20 columns** across **103,024 rows**
- Checked for missing values, inconsistent formats, and data types
- Understood all categorical fields before writing SQL queries

### Dataset Columns

| Column | Type | Description |
|--------|------|-------------|
| `Date` | DateTime | Booking date and time |
| `Time` | Time | Time of booking |
| `Booking_ID` | String | Unique ride identifier (e.g. CNR7153255142) |
| `Booking_Status` | Categorical | Success / Canceled by Driver / Canceled by Customer / Driver Not Found |
| `Customer_ID` | String | Anonymised customer ID (e.g. CID713523) |
| `Vehicle_Type` | Categorical | Prime Sedan, Prime SUV, Prime Plus, Mini, Auto, Bike, E-Bike |
| `Pickup_Location` | String | Area name (e.g. Tumkur Road) |
| `Drop_Location` | String | Area name (e.g. RT Nagar) |
| `V_TAT` | Numeric | Vehicle turnaround time (seconds) |
| `C_TAT` | Numeric | Customer turnaround time (seconds) |
| `Canceled_Rides_by_Customer` | String | Customer's cancellation reason |
| `Canceled_Rides_by_Driver` | String | Driver's cancellation reason |
| `Incomplete_Rides` | Boolean | Yes / No |
| `Incomplete_Rides_Reason` | String | Reason if incomplete |
| `Booking_Value` | Numeric (INR) | Fare charged |
| `Payment_Method` | Categorical | Cash, UPI, Credit Card, Debit Card |
| `Ride_Distance` | Numeric (km) | Distance of trip |
| `Driver_Ratings` | Numeric | Rating out of 5 |
| `Customer_Rating` | Numeric | Rating out of 5 |
| `Vehicle_Images` | URL | Icon image link |

---

## 🗄️ Step 2 — Database Setup & SQL Analysis (MySQL Workbench)

### 2.1 — Database Creation

```sql
CREATE DATABASE Ola;
USE Ola;
```

After creating the database, `Bookings.csv` was imported into a table called **`bookings`** using MySQL Workbench's **Table Data Import Wizard**.

---

### 2.2 — MySQL Workbench Screenshot

![MySQL Workbench](images/00_sql_workbench.png)

> *MySQL Workbench showing the OLA database with SQL views being created and executed.*

---

### 2.3 — 10 Business Questions Answered with SQL Views

Each question is solved by creating a **reusable SQL View** — a saved query callable like a virtual table.

---

#### ✅ Q1 — Retrieve All Successful Bookings

**Goal:** Isolate completed rides for revenue and quality analysis.

```sql
-- Create the view
CREATE VIEW Successful_Bookings AS
SELECT * FROM bookings
WHERE Booking_Status = 'Success';

-- Query it
SELECT * FROM Successful_Bookings;
```

> **Result:** 63,967 rows — successful bookings representing 62.09% of total volume.

---

#### 🚗 Q2 — Average Ride Distance per Vehicle Type

**Goal:** Understand operational range differences between vehicle categories.

```sql
CREATE VIEW ride_distance_for_each_vehicle AS
SELECT Vehicle_Type, AVG(Ride_Distance) AS avg_distance
FROM bookings
GROUP BY Vehicle_Type;

SELECT * FROM ride_distance_for_each_vehicle;
```

> **Result:** Auto averages ~10 km vs ~25 km for sedans — a clear product segmentation signal.

---

#### ❌ Q3 — Total Rides Cancelled by Customers

**Goal:** Measure customer-side drop-off to find friction points.

```sql
CREATE VIEW canceled_rides_by_customers AS
SELECT COUNT(*) FROM bookings
WHERE Booking_Status = 'Canceled by Customer';

SELECT * FROM canceled_rides_by_customers;
```

> **Result:** 10,499 customer cancellations (10.19% of total bookings).

---

#### 🏆 Q4 — Top 5 Customers by Number of Rides

**Goal:** Identify power users for loyalty programs and retention targeting.

```sql
CREATE VIEW Top_5_Customers AS
SELECT Customer_ID, COUNT(Booking_ID) AS total_rides
FROM bookings
GROUP BY Customer_ID
ORDER BY total_rides DESC
LIMIT 5;

SELECT * FROM Top_5_Customers;
```

> **Result:** Top 5 frequent riders identified — useful for CRM and premium engagement.

---

#### 🔧 Q5 — Driver Cancellations Due to Personal/Car Issues

**Goal:** Quantify fleet reliability problems causing supply-side failures.

```sql
CREATE VIEW Rides_Canceled_by_Drivers_P_C_Issues AS
SELECT COUNT(*) FROM bookings
WHERE Canceled_Rides_by_Driver = 'Personal & Car related issue';

SELECT * FROM Rides_canceled_by_Drivers_P_C_Issues;
```

> **Result:** This reason accounts for **35.49%** of all driver cancellations — the single biggest failure mode.

---

#### ⭐ Q6 — Max & Min Driver Ratings for Prime Sedan

**Goal:** Understand quality spread within the premium segment.

```sql
CREATE VIEW MAX_MIN_Driver_Rating AS
SELECT
    MAX(Driver_Ratings) AS max_rating,
    MIN(Driver_Ratings) AS min_rating
FROM bookings
WHERE Vehicle_Type = 'Prime Sedan';

SELECT * FROM Max_Min_Driver_Rating;
```

> **Result:** Shows the full rating range in the highest-value vehicle category — flags outlier drivers for review.

---

#### 💳 Q7 — All Rides Paid via UPI

**Goal:** Support payment trend analysis and digital adoption tracking.

```sql
CREATE VIEW UPI_Payment AS
SELECT * FROM bookings
WHERE Payment_Method = 'UPI';

SELECT * FROM UPI_Payment;
```

> **Result:** 25,881 UPI transactions — second most popular payment method at 25.1% of all rides.

---

#### 🌟 Q8 — Average Customer Rating per Vehicle Type

**Goal:** Determine which segments deliver the best customer experience.

```sql
CREATE VIEW AVG_cust_Rating AS
SELECT Vehicle_Type, AVG(Customer_Rating) AS avg_customer_rating
FROM bookings
GROUP BY Vehicle_Type;

SELECT * FROM AVG_Cust_Rating;
```

> **Result:** Ratings are remarkably consistent: 3.99–4.01 across all 7 vehicle types.

---

#### 💰 Q9 — Total Revenue from Successful Rides

**Goal:** Calculate net realizable revenue after filtering out failed bookings.

```sql
CREATE VIEW total_successful_ride_value AS
SELECT
    SUM(Booking_Value) AS total_successful_ride_value
FROM bookings
WHERE Booking_Status = 'Success';

SELECT * FROM total_successful_ride_value;
```

> **Result:** This figure feeds directly into the Power BI Revenue dashboard as the primary KPI.

---

#### 🔄 Q10 — Incomplete Rides with Reasons

**Goal:** Surface mid-trip failures for driver training and safety review.

```sql
CREATE VIEW Incomplete_Rides_Reason AS
SELECT Booking_Id, Incomplete_Rides_Reason
FROM bookings
WHERE Incomplete_Rides = 'Yes';

SELECT * FROM Incomplete_Rides_Reason;
```

> **Result:** A log of all rides that started but did not complete, paired with the documented reason for each.

---

## 📊 Step 3 — Power BI Dashboard (5 Pages)

The `Ola.pbix` file connects to the MySQL database and presents all findings in a fully interactive dashboard. A **date slicer (July 1–31, 2024)** is present on every page to filter all visuals simultaneously.

---

### Page 1 — Overall Summary

![Overall Dashboard](images/01_overall_dashboard.jpeg)

**Visuals:** KPI cards (Total Bookings, Total Booking Value) · Booking Status Pie Chart · Ride Volume Over Time Line Chart · Date Slicer

| Status | Count | % of Total |
|--------|-------|-----------|
| ✅ Success | 63,970 | **62.09%** |
| 🚫 Canceled by Driver | 18,430 | 17.89% |
| ❌ Canceled by Customer | 10,500 | 10.19% |
| 🔍 Driver Not Found | 10,124 | 9.83% |

> **Insight:** Daily ride volume holds steady at 3,200–3,400 bookings with a notable spike on July 28 worth investigating further.

---

### Page 2 — Vehicle Type Performance

![Vehicle Type Dashboard](images/02_vehicle_type.png)

**Visuals:** Matrix table comparing all 7 vehicle types across 4 KPIs · Date Slicer

| Vehicle Type | Total Booking Value | Success Booking Value | Avg Distance | Total Distance |
|---|---|---|---|---|
| Prime Sedan | ₹8.30M | ₹5.22M | 25.01 km | 235K km |
| Prime SUV | ₹7.93M | ₹4.88M | 24.88 km | 224K km |
| Prime Plus | ₹8.05M | ₹5.02M | 25.03 km | 227K km |
| Mini | ₹7.99M | ₹4.89M | 24.98 km | 226K km |
| Auto | ₹8.09M | ₹5.05M | **10.04 km** | **92K km** |
| Bike | ₹7.99M | ₹4.97M | 24.93 km | 228K km |
| E-Bike | ₹8.18M | ₹5.05M | 25.15 km | 231K km |

> **Insight:** Auto's average of 10.04 km (vs ~25 km for all others) confirms it is a dedicated last-mile product requiring separate pricing strategy. Prime Sedan leads in total booking value.

---

### Page 3 — Revenue Analysis

![Revenue Dashboard](images/03_revenue.jpeg)

**Visuals:** Revenue by Payment Method bar chart · Top 5 Customers table · Daily Ride Distance trend · Date Slicer

**Revenue by Payment Method:**

| Method | Revenue |
|--------|---------|
| 💵 Cash | ~₹19M |
| 📱 UPI | ~₹14M |
| 💳 Credit Card | ~₹1.2M |
| 🏦 Debit Card | ~₹0.4M |

**Top 5 Customers by Booking Value:**

| Rank | Customer ID | Booking Value |
|------|------------|--------------|
| 1st | CID785112 | ₹8,025 |
| 2nd | CID308763 | ₹6,281 |
| 3rd | CID734557 | ₹6,177 |
| 4th | CID353074 | ₹6,110 |
| 5th | CID836942 | ₹6,019 |

> **Insight:** Cash dominates at ₹19M despite UPI being available — incentivising digital payments would improve both revenue traceability and transaction cost efficiency.

---

### Page 4 — Cancellation Analysis

![Cancellation Dashboard](images/04_cancellation.png)

**Visuals:** KPI cards (Total, Succeeded, Cancelled, Cancellation Rate) · Customer cancellation reasons pie chart · Driver cancellation reasons pie chart

| KPI | Value |
|-----|-------|
| Total Bookings | 103,024 |
| Succeeded | 63,967 |
| Cancelled | **28,933** |
| Cancellation Rate | **28.08%** |

**Why Customers Cancel:**

| Reason | Share |
|--------|-------|
| Driver not moving towards pickup | **30.24%** |
| Driver asked to cancel | 25.43% |
| Change of plans | 19.82% |
| AC is not working | 14.93% |
| Wrong address | 9.57% |

**Why Drivers Cancel:**

| Reason | Share |
|--------|-------|
| Personal & Car related issue | **35.49%** |
| Customer related issue | 29.36% |
| Customer was coughing/sick | 19.82% |
| More than permitted people | 15.32% |

> **Insight:** "Driver not moving toward pickup" (30.24%) is a real-time GPS enforcement issue. "Car/personal issues" (35.49%) is a fleet maintenance and pre-trip inspection problem — both are concrete, fixable operational gaps.

---

### Page 5 — Ratings Analysis

![Ratings Dashboard](images/05_ratings.png)

**Visuals:** Driver Ratings matrix by vehicle type · Customer Ratings matrix by vehicle type

**Driver Ratings (avg per vehicle):**

| Prime Sedan | Prime SUV | Prime Plus | Mini | Auto | Bike | E-Bike |
|:-----------:|:---------:|:----------:|:----:|:----:|:----:|:------:|
| 3.99 | 4.01 | 4.00 | 3.99 | 4.00 | 3.98 | 4.01 |

**Customer Ratings (avg per vehicle):**

| Prime Sedan | Prime SUV | Prime Plus | Mini | Auto | Bike | E-Bike |
|:-----------:|:---------:|:----------:|:----:|:----:|:----:|:------:|
| 4.00 | 4.00 | 4.01 | 4.00 | 4.00 | 3.99 | 3.99 |

> **Insight:** All ratings fall within a razor-thin 3.98–4.01 range across both drivers and customers for all 7 vehicle types. This shows remarkably consistent service quality platform-wide — no segment is a clear satisfaction outlier.

---

## 💡 Step 4 — Key Business Insights & Recommendations

| # | Finding | Recommendation |
|---|---------|---------------|
| 1 | 28.08% cancellation rate | Audit driver pre-trip checklists; introduce penalty for avoidable cancellations |
| 2 | Car/personal issues = #1 driver cancellation (35.49%) | Enforce mandatory vehicle health checks before shift start |
| 3 | Driver not moving = #1 customer complaint (30.24%) | Improve real-time GPS tracking enforcement and alerts |
| 4 | Cash dominates payments at ₹19M | Offer UPI cashback incentives to shift to digital |
| 5 | Auto has distinct 10 km avg trip | Create a dedicated Auto pricing tier and route optimisation |
| 6 | Prime Sedan leads revenue at ₹8.30M | Expand Prime Sedan fleet in high-demand zones |
| 7 | Ratings uniformly ~4.0 across all types | Maintain current quality standards; investigate outlier low-rated drivers individually |
| 8 | July 28 booking spike detected | Investigate cause (event, promo?) and prepare capacity for similar dates |

---

## 🚀 How to Reproduce This Project

### Step 1 — Import the Data into MySQL

```bash
# In MySQL Workbench:
# 1. Run the SQL file to create the database and views
mysql -u root -p < ola_project.sql

# 2. Import Bookings.csv via:
#    Right-click 'bookings' table → Table Data Import Wizard → Browse to Bookings.csv
```

### Step 2 — Run All SQL Views

Open `ola_project.sql` in MySQL Workbench and execute all statements (Ctrl+Shift+Enter). All 10 views will be created automatically.

### Step 3 — Open the Power BI Dashboard

```
1. Open Ola.pbix in Power BI Desktop
2. If prompted, update the MySQL data source credentials
3. Click Home → Refresh
4. Use the left sidebar to navigate all 5 dashboard pages
5. Use the date slicer to filter by any date range in July 2024
```

---

## 📂 Files in This Repository

| File | Description |
|------|-------------|
| `README.md` | Full project documentation with steps and analysis |
| `ola_project.sql` | MySQL script: CREATE DATABASE + 10 SQL Views |
| `Bookings.csv` | Raw dataset — 103,024 rows × 20 columns |
| `Ola.pbix` | Power BI interactive dashboard — 5 pages |
| `images/` | All 6 screenshots (SQL Workbench + 5 dashboard pages) |

---

## 🧰 Skills Demonstrated

- **Data Exploration:** Raw CSV inspection, column profiling, null analysis in Excel
- **SQL:** `CREATE VIEW`, `SELECT`, `WHERE`, `GROUP BY`, `ORDER BY`, `COUNT`, `SUM`, `AVG`, `MAX`, `MIN`, `LIMIT`
- **Data Visualisation:** KPI cards, pie charts, bar charts, line charts, matrix tables, date slicers in Power BI
- **Dashboard Design:** Multi-page navigation, consistent OLA branding, responsive layout
- **Business Analysis:** Translating data patterns into actionable operational and revenue recommendations

---

*Data Period: July 1–31, 2024 | Platform: OLA Ride-Hailing | City: Bengaluru, India*
