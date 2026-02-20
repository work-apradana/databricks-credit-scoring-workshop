# Credit Scoring Workshop Dashboards

This directory contains the dashboard JSON file for the Databricks Credit Scoring Workshop. These dashboards are designed to visualize key metrics and insights related to credit scoring, loan performance, and customer behavior. The dashboards can be imported into your Databricks workspace and customized as needed.

Note that I built this dashboard almost entirely using **Dashboard Authoring Agent** in Databricks. You may want to try the agent to experience AI-assisted dashboard creation!

## How to import the dashboard
1. Open the Databricks workspace where you want to import the dashboard.
2. Go to the "Dashboards" section in the sidebar.
3. Under the "Create dashboard" button, click the dropdown arrow, and click the "Import dashboard from file"
4. Select the JSON file in this directory to import the dashboard.
5. Modify the source table to match the ones in your Databricks workspace, especially if you used different catalog, schema, or volume names.

Source tables I used in this Genie Space:
- `{CATALOG}.{SILVER_SCHEMA}.applicants`
- `{CATALOG}.{SILVER_SCHEMA}.loans`
- `{CATALOG}.{GOLD_SCHEMA}.repayments`
