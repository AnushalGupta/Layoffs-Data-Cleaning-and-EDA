
# 📊 Layoffs 2022 SQL Data Cleaning & EDA Project

This project focuses on **cleaning**, **transforming**, and **exploring** a real-world layoffs dataset using **SQL**.

---

## 📂 Dataset
- **Source:** [Layoffs 2022 Kaggle Dataset](https://www.kaggle.com/datasets/swaptr/layoffs-2022)
- **Description:** Details major layoffs that occurred across startups and tech companies.

---

## 🎯 Objectives
- Clean and prepare the dataset for analysis.
- Perform detailed Exploratory Data Analysis (EDA) to find insights.
- Visualize trends and outliers in layoffs across companies, industries, countries, and time periods.

---

## 🛠️ Steps Taken

### 1. Data Cleaning:
- Created a staging table and inserted raw data.
- Removed duplicates using SQL window functions (`ROW_NUMBER()`).
- Standardized column values:
  - Industry names.
  - Country names.
  - Date formats.
- Filled missing industries based on existing company data.
- Removed records with no significant data.

### 2. Exploratory Data Analysis (EDA):
- Top companies, locations, and countries with the most layoffs.
- Year-wise analysis of layoffs.
- Industry and startup stage breakdowns.
- Rolling total layoffs month-by-month.

### 3. Advanced Analysis:
- Top 5 industries impacted each year.
- Top 10 months with the highest number of layoffs.
- Survival analysis: Companies that survived layoffs over multiple years.

---

## 📈 Skills Highlighted
- SQL Data Cleaning
- SQL CTEs & Window Functions
- Exploratory Data Analysis with SQL
- Data Aggregation, Grouping, and Ranking
- Professional project structuring

---

## 🖥️ Future Work
- Create visualizations in Tableau or Power BI based on the clean dataset.
- Build a dynamic dashboard to showcase layoff trends over time.
- Predict future layoffs based on industry and funding trends.

---

## 🚀 Quick Glimpse of Results

| Metric                     | Insights                                          |
|-----------------------------|---------------------------------------------------|
| Max Layoffs in a Day        | **Thousands** from major companies like Meta, Amazon |
| Most Impacted Industries    | Crypto, Consumer, Retail, Transportation          |
| Countries with Highest Layoffs | USA, India, Canada                             |
| Peak Months for Layoffs     | Late 2022 and Early 2023                          |

---

> **Made with ❤️ using pure SQL!**
