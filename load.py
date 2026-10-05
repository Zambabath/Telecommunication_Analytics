import pandas as pd
import time
import os
from sqlalchemy import create_engine, text
from sqlalchemy.exc import OperationalError

db_password = os.environ.get("POSTGRES_PASSWORD")
DATABASE_URL = f"postgresql+psycopg2://postgres:{db_password}@db:5432/telco_db"
engine = create_engine(DATABASE_URL)

def wait_for_db():
    retries = 10
    for i in range(retries):
        try:
            with engine.connect() as conn:
                print("connected to database")
                return
        except OperationalError:
            print(f"Retrying in 3 seconds ({i+1}/{retries})")
            time.sleep(3)
    raise Exception("connection failed")

def run_pipeline():
    wait_for_db()
    
    df = pd.read_csv("WA_Fn-UseC_-Telco-Customer-Churn.csv")
    df["TotalCharges"] = pd.to_numeric(df["TotalCharges"].str.strip(), errors="coerce").fillna(0)
    
    with engine.begin() as conn:
        with open("create_table.sql", "r") as f:
            conn.execute(text(f.read()))
            
        df.to_sql("stg_telco_churn", con=conn, if_exists="replace", index=False)

        with open("transform.sql", "r") as f:
            conn.execute(text(f.read()))

    print("Done")

if __name__ == "__main__":
    run_pipeline()