INSERT INTO dim_customers (customer_id, gender, is_senior, has_partner, has_dependents)
SELECT 
    "customerID",
    gender,
    CASE WHEN "SeniorCitizen" = 1 THEN TRUE ELSE FALSE END,
    CASE WHEN "Partner" = 'Yes' THEN TRUE ELSE FALSE END,
    CASE WHEN "Dependents" = 'Yes' THEN TRUE ELSE FALSE END
FROM stg_telco_churn
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO fct_churn_events (
    customer_id, tenure_months, monthly_charges, total_charges, is_churned, contract_type, payment_method
)
SELECT 
    "customerID",
    tenure,
    "MonthlyCharges",
    "TotalCharges",
    CASE WHEN "Churn" = 'Yes' THEN TRUE ELSE FALSE END,
    "Contract",
    "PaymentMethod"
FROM stg_telco_churn
ON CONFLICT (customer_id) DO UPDATE SET
    tenure_months = EXCLUDED.tenure_months,
    monthly_charges = EXCLUDED.monthly_charges,
    total_charges = EXCLUDED.total_charges,
    is_churned = EXCLUDED.is_churned;