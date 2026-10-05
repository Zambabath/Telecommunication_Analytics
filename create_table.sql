-- Table
CREATE TABLE IF NOT EXISTS stg_telco_churn (
    customerID VARCHAR(50) PRIMARY KEY,
    gender VARCHAR(20),
    SeniorCitizen INT,
    Partner VARCHAR(10),
    Dependents VARCHAR(10),
    tenure INT,
    PhoneService VARCHAR(10),
    MultipleLines VARCHAR(20),
    InternetService VARCHAR(20),
    OnlineSecurity VARCHAR(20),
    OnlineBackup VARCHAR(20),
    DeviceProtection VARCHAR(20),
    TechSupport VARCHAR(20),
    StreamingTV VARCHAR(20),
    StreamingMovies VARCHAR(20),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(10),
    PaymentMethod VARCHAR(50),
    MonthlyCharges NUMERIC(10, 2),
    TotalCharges VARCHAR(20),
    Churn VARCHAR(10)
);

-- Customer Demographics
CREATE TABLE IF NOT EXISTS dim_customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    gender VARCHAR(20),
    is_senior BOOLEAN,
    has_partner BOOLEAN,
    has_dependents BOOLEAN
);

-- Subscription Plans & Payment Methods
CREATE TABLE IF NOT EXISTS dim_subscriptions (
    subscription_id SERIAL PRIMARY KEY,
    contract_type VARCHAR(30),
    payment_method VARCHAR(50),
    paperless_billing BOOLEAN,
    internet_service VARCHAR(20)
);

-- Financials and Churn Events
CREATE TABLE IF NOT EXISTS fct_churn_events (
    customer_id VARCHAR(50) PRIMARY KEY REFERENCES dim_customers(customer_id),
    tenure_months INT,
    monthly_charges NUMERIC(10, 2),
    total_charges NUMERIC(10, 2),
    is_churned BOOLEAN,
    contract_type VARCHAR(30),
    payment_method VARCHAR(50)
);