This is a solo project I undertook to showcase some of my skills in SQL and PowerBI.

This project is an automated data pipeline that takes raw telecommunications data, loads it into a database, and analyses why customers cancel their subscriptions. 

It connects Python, SQL, and Docker to build a database that feeds into Power BI for visualisation.

The tools used are: PostgreSQL, Python (Pandas, SQLAlchemy), Docker & Docker Compose, and PowerBI

The process:
1. `load.py` reads the raw CSV file and fixes formatting issues.
2. SQL scripts create an organised database structure with tables for customers, subscriptions, and churn events.
3. Python inserts the cleaned data into the PostgreSQL database.
4. `analytics.sql` calculate churn rates and highlight lost revenue trends.

NEEDED TO RUN
Create a file named `.env` in the main folder and add:

POSTGRES_PASSWORD=...........

where ........... is the password of your choosing
