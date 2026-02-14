
# Credit-Risk-Intelligence-Analytics

This project analyzes borrower credit data to identify default risk patterns, evaluate financial behavior, and support data-driven lending decisions.  
The workflow integrates Python-based data cleaning, exploratory analysis, MySQL database engineering, advanced SQL analytics, Excel validation, and an interactive Power BI dashboard to transform raw financial data into executive-level insights.

---

## 📂 Dataset Overview
**Source:** Credit Risk Dataset  
**Records:** Thousands of borrower applications  

**Key Fields:**
- Person Age, Income, Employment Length  
- Home Ownership  
- Loan Intent & Loan Grade  
- Loan Amount & Interest Rate  
- Loan Status (Default / Non-Default)  
- Credit History Length  

---

## 🧹 Data Cleaning & Feature Engineering
- Assessed dataset structure, datatypes, and statistical summary  
- Treated missing values:
  - Employment Length → Median imputation  
  - Interest Rate → Mean imputation  
- Removed unrealistic entries:
  - Age > 100  
  - Employment length > 50 years  
- Capped extreme outliers to stabilize distributions:
  - Income capped at **140,250**  
  - Loan amount capped at **23,000**  
  - Interest rate capped at **20.04%**  
  - Employment length capped at **14.5**  
- Removed duplicate records  
- Exported the cleaned dataset for downstream analytics  

**Outcome:** Improved data reliability and prevented skewed risk interpretations.

---

## 📊 Numerical Insights & Visual Analysis

### 1️⃣ Default Risk by Home Ownership
- Renters exhibit higher default tendencies compared to mortgage holders.  
- Owned properties show relatively lower credit risk.  

**Insight:** Housing stability strongly correlates with repayment behavior.

---

### 2️⃣ Loan Intent vs Default Behavior
- Certain loan purposes demonstrate elevated default rates.  
- Risk varies significantly depending on borrower motivation.  

**Insight:** Intent-based risk segmentation can improve underwriting precision.

---

### 3️⃣ Loan Grade Risk Hierarchy
- Lower loan grades correspond with higher default probability.  
- Higher grades maintain stronger repayment consistency.  

**Insight:** Credit grading remains one of the strongest predictors of default.

---

### 4️⃣ Age-Based Risk Trends
- Younger borrowers show moderately higher default rates.  
- Risk stabilizes as borrower age increases.  

**Insight:** Financial maturity contributes to improved repayment patterns.

---

### 5️⃣ Income vs Loan Exposure
- Applicants with lower income relative to loan size demonstrate elevated risk.  
- High income-to-loan ratios correlate with safer lending profiles.  

**Insight:** Debt burden is a critical indicator of financial stress.

---

## 🔍 Deep-Dive Findings
- High loan amounts paired with moderate income increase default probability.  
- Borrowers with prior defaults represent a significantly riskier segment.  
- Employment stability positively influences repayment likelihood.  
- Interest rate spikes often align with higher-risk borrowers.  

---

## 📊 Excel-Based Validation
Excel was used as a supplementary analytical layer to:

- Perform quick tabular validation  
- Cross-check aggregated metrics  
- Improve accessibility for non-technical stakeholders  
- Support dashboard-ready formatting  

**Outcome:** Enhanced transparency and auditability of computed metrics.

---

## 📈 Interactive Dashboard – Credit Risk Intelligence
A Power BI dashboard was developed to translate analytical outputs into business-ready visuals.

### Dashboard Highlights:
- Overall default rate monitoring  
- Borrower segmentation by income and age  
- Loan grade risk comparison  
- Intent-based default distribution  
- Income vs loan exposure analysis  

**Business Value:** Enables financial stakeholders to identify high-risk applicants instantly and optimize lending strategies.

---

## 🗄 Database Engineering (MySQL)
- Established a MySQL connection using Python  
- Created database **credit_bridge**  
- Built table **raw_credit**  
- Inserted cleaned records programmatically  
- Verified data integrity with row-count validation  

**Outcome:** Structured, query-ready financial dataset for scalable analytics.

---

## 📉 Advanced Business Analysis Using SQL
Executed analytical queries to answer high-impact risk questions:

- Overall default rate  
- Risk distribution by home ownership  
- Income-to-loan ratio impact  
- Age-group default trends  
- Loan grade percentile ranking  
- Employment length risk patterns  
- Cross-tab borrower analysis  
- Running default totals using window functions  

**Techniques Used:**
- CTEs  
- Window Functions  
- Ranking & Percentiles  
- Subqueries  

**Outcome:** Converted raw borrower data into strategic lending intelligence.

---

## 🧠 Business Recommendations
- Strengthen verification for high debt-to-income applicants  
- Apply risk-based pricing for lower credit grades  
- Limit exposure to borrowers with prior defaults  
- Introduce intent-aware underwriting policies  
- Monitor high-interest loans as potential risk indicators  

---

## 🛠 Tech Stack
- Python  
- Pandas, NumPy  
- Matplotlib, Seaborn  
- MySQL  
- Advanced SQL  
- Excel  
- Power BI  

---

## 📁 Repository Structure
```
├── credit_risk_dataset.csv
├── final_cleaned_credit_risk.csv
├── EDA.ipynb
├── Connection.ipynb
├── Business Analysis.sql
├── clean.csv / clean.xlsx
├── Credit Risk Intelligence Dashboard.pbix
└── README.md
```

---

## 🚀 Skills Demonstrated
- Data Cleaning & Validation  
- Risk Analytics  
- Financial Data Modeling  
- Database Engineering  
- Advanced SQL  
- Dashboard Development  
- Business Insight Generation  

This project showcases an end-to-end credit risk analytics pipeline — from raw data processing to executive-level visualization — enabling smarter, faster financial decision-making.

---

## ▶️ How to Execute the Project

### 1. Clone the Repository
```bash
git clone <your-repo-link>
cd credit-risk-intelligence-analytics
```

### 2. Install Dependencies
```bash
pip install pandas numpy matplotlib seaborn mysql-connector-python jupyter
```

### 3. Run Data Cleaning & EDA
```bash
jupyter notebook EDA.ipynb
```

### 4. Setup MySQL
- Ensure MySQL server is running.  
- Update credentials inside **Connection.ipynb**.

### 5. Load Data into Database
```bash
jupyter notebook Connection.ipynb
```

### 6. Execute Business SQL Queries
Run **Business Analysis.sql** in MySQL Workbench (or any SQL client).

### 7. Open the Dashboard
Open **Credit Risk Intelligence Dashboard.pbix** in Power BI to explore interactive insights.
