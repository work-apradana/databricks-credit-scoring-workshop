# Credit Scoring Workshop Genie Spaces

This directory contains the Genie Spaces JSON file for the Databricks Credit Scoring Workshop. This file specifies the tables needed to build the Genie Spaces where you can ask questions and get insights about the credit scoring dataset using natural language queries.

## How to import the Genie Space
1. As of February 20, 2026, importing Genie spaces into Databricks is only available via REST API. So I included a script to import the Genie Space into your own workspace. You will need to modify the parameters in the script such as `WAREHOUSE_ID` and `SPACE_PARENT_PATH` as needed before running it.
2. You may have to modify the source table names in the JSON file to match the ones in your Databricks workspace, especially if you used different catalog, schema, or volume names.

Source tables I used in this Genie Space:
- `{CATALOG}.{SILVER_SCHEMA}.applicants`
- `{CATALOG}.{SILVER_SCHEMA}.loans`
- `{CATALOG}.{GOLD_SCHEMA}.repayments`

