# Supply Chain Analytics using SQL


## Project Objective
Analyze supply chain operations and delivery performance using the DataCo Smart Supply Chain dataset to identify operational bottlenecks, improve delivery efficiency, and support business decision-making.


## Business Problem
DataCo Global Logistics has experienced increasing delivery delays, inconsistent regional performance, and rising operational costs. Management requires a data-driven assessment of supply chain performance to identify key issues and optimization opportunities.


## Dataset
- Source: DataCo Smart Supply Chain Dataset
- Records: 180,000+
- Tables: One big xlsx file

## Data Modelling Approach
The original DataCo Supply Chain dataset was provided as a single denormalized transactional file containing customer, product, shipping, geographic, and order-related information.

To support analytical reporting and SQL-based business analysis, the dataset was transformed into a dimensional model consisting of fact and dimension tables.

### Fact Tables
* fact_orders
* fact_shipping

### Dimension Tables
* dim_customers
* dim_products
* dim_geography

This structure improves query performance, simplifies business reporting, and follows common data warehouse design principles used in enterprise analytics environments.


## Skills Demonstrated
- Data Validation
- Data Modeling
- SQL Joins
- CTEs
- Window Functions
- Ranking Functions
- Self Joins
- KPI Development
- Business Analysis

## Project Status
🚧 In Progress