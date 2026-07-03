create database Bank_Loan;
use Bank_Loan;
--  Overall KPIs
SELECT
    COUNT(*)  AS total_loans,
    SUM(default_flag)AS total_defaults,
    ROUND(AVG(default_flag) * 100, 2)AS default_rate_pct,
    ROUND(AVG(loan_amnt),2)AS avg_loan_amount,
    ROUND(AVG(int_rate), 2)AS avg_interest_rate,
    ROUND(SUM(loan_amnt), 0)AS total_loan_value
FROM Bank_Loan.loan;

-- Default Rate by Loan Grade
SELECT
    grade,
    COUNT(*)  AS total_loans,
    SUM(default_flag) AS defaults,
    ROUND(AVG(default_flag) * 100, 2)  AS default_rate_pct,
    ROUND(AVG(loan_amnt), 2)  AS avg_loan,
    ROUND(AVG(int_rate), 2)  AS avg_int_rate
FROM bank_loan.loan
GROUP BY grade
ORDER BY grade;


-- Default Rate by Loan Purpose
SELECT
    purpose,
    COUNT(*) AS total_loans,
    SUM(default_flag)AS defaults,
    ROUND(AVG(default_flag) * 100, 2)AS default_rate_pct,
    ROUND(AVG(loan_amnt), 2)AS avg_loan_amount
FROM  bank_loan.loan
GROUP BY purpose
ORDER BY default_rate_pct DESC;

-- Rank each grade by default rate using CTE + RANK()
WITH grade_risk AS (
    SELECT
        grade,risk_tier,
        COUNT(*)AS total_loans,
        SUM(default_flag)AS defaults,
        ROUND(AVG(default_flag)*100,2)AS default_rate_pct,
        ROUND(AVG(int_rate),2)AS avg_int_rate
    FROM bank_loan.loan
    GROUP BY grade, risk_tier
)
SELECT *,
    RANK() OVER (
        ORDER BY default_rate_pct DESC
    ) AS risk_rank
FROM grade_risk
ORDER BY risk_rank;

-- Top 10 High Risk States
SELECT
    addr_state AS state,
    COUNT(*)AS total_loans,
    SUM(default_flag)AS defaults,
    ROUND(AVG(default_flag) * 100, 2)AS default_rate_pct,
    ROUND(AVG(loan_amnt), 2)AS avg_loan
FROM bank_loan.loan
GROUP BY addr_state
HAVING COUNT(*) >= 100
ORDER BY default_rate_pct DESC
LIMIT 10;