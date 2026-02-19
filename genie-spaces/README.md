# Credit Scoring Workshop Genie Spaces

This directory contains the Genie Spaces JSON file for the Databricks Credit Scoring Workshop. This file specifies the tables needed to build the Genie Spaces where you can ask questions and get insights about the credit scoring dataset using natural language queries.

Tables I used in this Genie Space:
- `silver_applicants`
- `silver_loans`
- `gold_repayments`

As of February 20, 2026, importing Genie spaces into Databricks is only available via REST API. So I included a script to import the Genie Space into your own workspace. You will need to modify the parameters in the script such as `WAREHOUSE_ID` and `SPACE_PARENT_PATH` as needed before running it.