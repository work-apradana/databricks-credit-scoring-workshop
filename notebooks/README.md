# Databricks Credit Scoring Workshop Notebooks

This directory contains the Databricks notebooks needed to complete the workshop. Each notebook corresponds to a specific module of the workshop, covering various aspects of credit scoring, data processing, machine learning, and data governance using Databricks.

How to follow the notebooks:
1. Begin with `00-setup.ipynb` to set up your Databricks environment and import necessary libraries.
2. Upload the datasets from the `datasets` directory to your Databricks workspace under the directory `/Volumes/{your-catalog}/{your-schema}/{your-volume}/credit_datasets`.
3. Follow the notebooks in order, starting from `01-Data-Ingestion.ipynb` to `05-Data-Governance.ipynb`, to complete the workshop.
4. Notebook `04b-Data-Science-with-AutoML-optional.ipynb` is optional and provides an introduction to using AutoML for credit scoring. This notebook **only works** with **Classic Compute** which is not available in the **Databricks Free Edition**, so it is recommended to skip this notebook if you are using the Free Edition.