USE credit_bridge;

-- 1. Total Applications and Overall Default Rate
SELECT COUNT(*) AS total_applications, AVG(loan_status) * 100 AS overall_default_rate FROM raw_credit;

-- 2. Average Loan Amount and Interest Rate
SELECT AVG(loan_amnt) AS avg_loan_amount, AVG(loan_int_rate) AS avg_interest_rate FROM raw_credit;

-- 3. Count of Defaults by Previous Default History
SELECT cb_person_default_on_file, COUNT(*) AS total, SUM(loan_status) AS defaults FROM raw_credit GROUP BY cb_person_default_on_file;

-- 4. Default Rate by Home Ownership
SELECT person_home_ownership, COUNT(*) AS total, AVG(loan_status) * 100 AS default_rate FROM raw_credit GROUP BY person_home_ownership ORDER BY default_rate DESC;

-- 5. Average Income and Default Rate by Loan Intent
SELECT loan_intent, AVG(person_income) AS avg_income, AVG(loan_status) * 100 AS default_rate FROM raw_credit GROUP BY loan_intent ORDER BY default_rate DESC;

-- 6. Default Rate by Age Group
SELECT CASE WHEN person_age < 25 THEN 'Under 25' WHEN person_age BETWEEN 25 AND 35 THEN '25-35' ELSE 'Over 35' END AS age_group, AVG(loan_status) * 100 AS default_rate FROM raw_credit GROUP BY age_group ORDER BY default_rate DESC;

-- 7. Loan Amount Distribution by Grade
SELECT loan_grade, MIN(loan_amnt) AS min_amount, MAX(loan_amnt) AS max_amount, AVG(loan_amnt) AS avg_amount FROM raw_credit GROUP BY loan_grade ORDER BY avg_amount DESC;

-- 8. Top 5 Riskiest Loan Intents by Default Rate
SELECT loan_intent, default_rate FROM (SELECT loan_intent, AVG(loan_status) * 100 AS default_rate FROM raw_credit GROUP BY loan_intent) AS sub ORDER BY default_rate DESC LIMIT 5;

-- 9. Income-to-Loan Ratio Impact on Defaults
SELECT CASE WHEN (person_income / loan_amnt) < 2 THEN 'Low Ratio (<2)' ELSE 'High Ratio (>=2)' END AS ratio_category, AVG(loan_status) * 100 AS default_rate FROM raw_credit GROUP BY ratio_category;

-- 10. Top 10 Applicants by Risk Rank
SELECT person_age, person_income, loan_amnt, RANK() OVER (ORDER BY (person_income / loan_amnt) ASC) AS risk_rank FROM raw_credit WHERE loan_status = 1 ORDER BY risk_rank LIMIT 10;

-- 11. Default Rate by Employment Length Bins
SELECT FLOOR(person_emp_length) AS emp_years, AVG(loan_status) * 100 AS default_rate FROM raw_credit GROUP BY emp_years ORDER BY emp_years;

-- 12. Correlation Between Age and Defaults (Approximation)
SELECT AVG(age_default) AS avg_age_defaults FROM (SELECT person_age * loan_status AS age_default FROM raw_credit) AS sub;

-- 13. Top 5 Riskiest Applicants by Income-to-Loan Ratio
SELECT person_age, person_income, loan_amnt, income_loan_ratio, risk_rank
FROM (
    SELECT person_age, person_income, loan_amnt, (person_income / loan_amnt) AS income_loan_ratio,
           RANK() OVER (ORDER BY (person_income / loan_amnt) ASC) AS risk_rank
    FROM raw_credit
    WHERE loan_status = 1
) AS ranked
WHERE risk_rank <= 5;

-- 14. Default Rate by Loan Intent with Cumulative Percentage
SELECT loan_intent, default_rate, SUM(default_rate) OVER (ORDER BY default_rate DESC) AS cumulative_default_rate
FROM (
    SELECT loan_intent, AVG(loan_status) * 100 AS default_rate
    FROM raw_credit
    GROUP BY loan_intent
) AS intent_defaults
ORDER BY default_rate DESC;

-- 15. Applicants with Above-Average Defaults by Home Ownership (CTE)
WITH avg_defaults AS (
    SELECT person_home_ownership, AVG(loan_status) * 100 AS avg_default_rate
    FROM raw_credit
    GROUP BY person_home_ownership
)
SELECT r.person_home_ownership, r.person_age, r.loan_amnt, r.loan_status * 100 AS default_rate
FROM raw_credit r
JOIN avg_defaults a ON r.person_home_ownership = a.person_home_ownership
WHERE r.loan_status > a.avg_default_rate / 100
LIMIT 100;

-- 16. Age Group Default Trends (Fixed: Non-Recursive CTE with CASE)
WITH age_grouped AS (
    SELECT 
        CASE 
            WHEN person_age BETWEEN 20 AND 24 THEN '20-24'
            WHEN person_age BETWEEN 25 AND 29 THEN '25-29'
            WHEN person_age BETWEEN 30 AND 34 THEN '30-34'
            WHEN person_age BETWEEN 35 AND 39 THEN '35-39'
            WHEN person_age BETWEEN 40 AND 44 THEN '40-44'
            ELSE '45+' 
        END AS age_group,
        loan_status
    FROM raw_credit
)
SELECT age_group, AVG(loan_status) * 100 AS default_rate
FROM age_grouped
GROUP BY age_group
ORDER BY age_group;

-- 17. Loan Grade Risk Ranking with Percentile
SELECT loan_grade, default_rate, PERCENT_RANK() OVER (ORDER BY default_rate DESC) AS risk_percentile
FROM (
    SELECT loan_grade, AVG(loan_status) * 100 AS default_rate
    FROM raw_credit
    GROUP BY loan_grade
) AS grade_defaults;

-- 18. Subquery for Defaults Exceeding Overall Average by Intent
SELECT loan_intent, default_rate
FROM (
    SELECT loan_intent, AVG(loan_status) * 100 AS default_rate
    FROM raw_credit
    GROUP BY loan_intent
) AS intent_avg
WHERE default_rate > (SELECT AVG(loan_status) * 100 FROM raw_credit);

-- 19. CTE for Income Quartiles and Default Rates
WITH income_quartiles AS (
    SELECT person_income, NTILE(4) OVER (ORDER BY person_income) AS quartile
    FROM raw_credit
)
SELECT iq.quartile, AVG(r.loan_status) * 100 AS default_rate
FROM raw_credit r
JOIN income_quartiles iq ON r.person_income = iq.person_income
GROUP BY iq.quartile
ORDER BY iq.quartile;

-- 20. Window Function for Running Total of Defaults by Age
SELECT person_age, COUNT(*) AS total_apps, SUM(loan_status) AS defaults,
       SUM(SUM(loan_status)) OVER (ORDER BY person_age) AS running_defaults
FROM raw_credit
GROUP BY person_age
ORDER BY person_age
LIMIT 50;

-- 21. CTE with Join for Cross-Tab: Home Ownership vs. Loan Intent Defaults
WITH cross_tab AS (
    SELECT person_home_ownership, loan_intent, AVG(loan_status) * 100 AS default_rate
    FROM raw_credit
    GROUP BY person_home_ownership, loan_intent
)
SELECT * FROM cross_tab
ORDER BY default_rate DESC
LIMIT 10;

-- 22. Subquery for Top 10% Riskiest Loans by Amount
SELECT * FROM raw_credit
WHERE loan_amnt > (
    SELECT loan_amnt FROM (
        SELECT loan_amnt, ROW_NUMBER() OVER (ORDER BY loan_amnt DESC) AS rn, COUNT(*) OVER () AS total
        FROM raw_credit
    ) AS ranked
    WHERE rn = FLOOR(total * 0.1)
)
LIMIT 100;

-- 23. Employment Length Default Patterns (Fixed: Non-Recursive CTE with CASE)
WITH emp_grouped AS (
    SELECT 
        CASE 
            WHEN FLOOR(person_emp_length) = 0 THEN '0'
            WHEN FLOOR(person_emp_length) = 1 THEN '1'
            WHEN FLOOR(person_emp_length) = 2 THEN '2'
            WHEN FLOOR(person_emp_length) = 3 THEN '3'
            WHEN FLOOR(person_emp_length) = 4 THEN '4'
            WHEN FLOOR(person_emp_length) = 5 THEN '5'
            WHEN FLOOR(person_emp_length) = 6 THEN '6'
            WHEN FLOOR(person_emp_length) = 7 THEN '7'
            WHEN FLOOR(person_emp_length) = 8 THEN '8'
            WHEN FLOOR(person_emp_length) = 9 THEN '9'
            WHEN FLOOR(person_emp_length) = 10 THEN '10'
            ELSE '11+' 
        END AS emp_length_bin,
        loan_status
    FROM raw_credit
    WHERE FLOOR(person_emp_length) <= 10  -- Limit to 0-10 for focus
)
SELECT emp_length_bin, AVG(loan_status) * 100 AS default_rate
FROM emp_grouped
GROUP BY emp_length_bin
ORDER BY emp_length_bin;

-- 24. Window Function for Default Rate Change by Grade
SELECT loan_grade, default_rate, default_rate - LAG(default_rate) OVER (ORDER BY loan_grade) AS rate_change
FROM (
    SELECT loan_grade, AVG(loan_status) * 100 AS default_rate
    FROM raw_credit
    GROUP BY loan_grade
) AS grade_avg
ORDER BY loan_grade;
--  Find Pairs of Applicants with Similar Income but Different Default Status
SELECT a.person_income, a.loan_status AS status_a, a.loan_intent,
       b.loan_status AS status_b, b.loan_intent AS intent_b
FROM raw_credit a
JOIN raw_credit b ON ABS(a.person_income - b.person_income) < 5000 AND a.loan_status != b.loan_status
WHERE a.loan_status = 1
LIMIT 10;