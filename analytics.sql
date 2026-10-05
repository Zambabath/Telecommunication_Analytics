-- Cohort Retention & Churn Rate by Contract and Payment Channel
WITH CohortMetrics AS (
    SELECT 
        contract_type,
        payment_method,
        COUNT(customer_id) AS total_subscribers,
        SUM(CASE WHEN is_churned THEN 1 ELSE 0 END) AS churned_subscribers,
        SUM(monthly_charges) AS total_mrr,
        SUM(CASE WHEN is_churned THEN monthly_charges ELSE 0 END) AS lost_mrr
    FROM fct_churn_events
    GROUP BY contract_type, payment_method
)
SELECT 
    contract_type,
    payment_method,
    total_subscribers,
    churned_subscribers,
    ROUND((churned_subscribers * 100.0 / NULLIF(total_subscribers, 0)), 2) AS churn_rate_pct,
    lost_mrr,
    RANK() OVER (ORDER BY lost_mrr DESC) AS revenue_risk_rank
FROM CohortMetrics;

-- Customer Tenure Deciles & Churn Distribution
SELECT 
    customer_id,
    tenure_months,
    monthly_charges,
    NTILE(10) OVER (ORDER BY tenure_months ASC) AS tenure_decile,
    AVG(monthly_charges) OVER (PARTITION BY contract_type) AS avg_plan_charge,
    monthly_charges - AVG(monthly_charges) OVER (PARTITION BY contract_type) AS diff_from_plan_avg
FROM fct_churn_events;