#!/bin/bash

# Simple script to import Databricks Genie Spaces using REST API
# Update the variables below with your Databricks workspace details

set -e

# Configuration - UPDATE THESE VALUES
DATABRICKS_HOST="https://your-workspace.databricks.com"
DATABRICKS_TOKEN="dapi-your-personal-access-token"

# Check if configuration has been updated
if [[ "$DATABRICKS_HOST" == "https://your-workspace.cloud.databricks.com" ]] || [[ "$DATABRICKS_TOKEN" == "your-personal-access-token" ]]; then
    echo "Error: Please update DATABRICKS_HOST and DATABRICKS_TOKEN variables in this script"
    echo "Edit this file and replace:"
    echo "  DATABRICKS_HOST with your workspace URL"
    echo "  DATABRICKS_TOKEN with your personal access token"
    exit 1
fi

echo "Importing Genie Spaces..."

WAREHOUSE_ID="replace-with-your-warehouse-id"
SPACE_PARENT_PATH="/Workspace/Users/user@company.com/Genie Spaces"
EXPORTED_SPACE_FILE="genie_space_credit_scoring.json"
SPACE_TITLE="Credit Scoring Genie Space"
SPACE_DESCRIPTION="My imported space for credit scoring workshop"

# List Genie Spaces using REST API
curl -s \
    -X POST \
    -H "Authorization: Bearer $DATABRICKS_TOKEN" \
    -H "Content-Type: application/json" \
    "$DATABRICKS_HOST/api/2.0/genie/spaces" \
    -d @- <<EOF
    {
        "warehouse_id": "$WAREHOUSE_ID",
        "parent_path": "$SPACE_PARENT_PATH",
        "serialized_space": "$(cat "$EXPORTED_SPACE_FILE" | jq -r '.serialized_space')",
        "title": "$SPACE_TITLE",
        "description": "$SPACE_DESCRIPTION"
    }
    EOF