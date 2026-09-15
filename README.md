Manufacturing Production & Downtime Analysis
📌 Project Overview

Manufacturing Production & Downtime Analysis is an end-to-end data analytics project focused on evaluating production performance, downtime, quality, and maintenance activities across multiple manufacturing plants.

The project uses a combination of Python, SQL, and Power BI to transform manufacturing data into meaningful operational insights and an interactive business intelligence dashboard.

The analysis covers 4 plants, 20 production lines, 20 products, and 3 shifts, using production and operational records from 2024 to 2025.

🎯 Business Problem

Manufacturing plants may experience production gaps, machine downtime, quality issues, and differences in performance across plants and production lines. Without a consolidated view of these factors, it becomes difficult to identify production losses, understand downtime causes, and determine areas that require improvement.

This project analyzes manufacturing data to identify operational bottlenecks and provide a clear view of production efficiency, downtime, quality, and maintenance performance.

🎯 Objectives
Analyze planned versus actual production performance.
Identify production gaps across plants and production lines.
Analyze downtime patterns and major downtime causes.
Evaluate defect and quality-related patterns.
Analyze maintenance activities, duration, and cost.
Use SQL and Python for data analysis and exploration.
Build an interactive Power BI dashboard for operational monitoring.
Generate business insights to support data-driven decisions.
📊 Dataset

The project uses a synthetic manufacturing dataset designed to represent an automotive parts manufacturing environment.

Dataset Coverage
Metric	Details
Plants	4
Production Lines	20
Products	20
Shifts	3
Production Records	34,985
Downtime Records	12,000
Defect Records	8,000
Maintenance Records	5,000
Production Period	Jan 2024 – Jun 2025
Defect Inspection Period	Jan 2024 – Jul 2025
Tables
Table	Description
production_records	Production planning and actual output records
downtime_records	Machine downtime events and reasons
defect_records	Defect inspection and quality records
maintenance_records	Maintenance activity, duration, and cost
plants	Plant information
production_lines	Production line information
products	Product information
shifts	Shift information
🛠️ Tools & Technologies
Python
Pandas
NumPy
Matplotlib
Seaborn
SQL / MySQL
Power BI
DAX
Data Modeling
Exploratory Data Analysis
🔄 Project Workflow
Raw Manufacturing Data
        ↓
Python / Pandas
Data Cleaning & Preparation
        ↓
SQL / MySQL
Business Analysis
        ↓
Python
Exploratory Data Analysis
        ↓
Power BI
Data Modeling & Dashboard
        ↓
Business Insights & Recommendations
🧹 Data Preparation

Python and Pandas were used to prepare the manufacturing data for analysis.

Key preparation activities included:

Datetime conversion and standardization.
Data consistency and value validation.
Missing-value verification.
Descriptive statistical checks.
Feature engineering.
Creation of production_gap.
Calculation of achievement_rate.
Key Calculations

Production Gap

Production Gap = Planned Quantity − Actual Quantity

Achievement Rate

Achievement Rate = (Actual Quantity / Planned Quantity) × 100
🗄️ SQL Analysis

SQL was used to analyze the manufacturing data from multiple related tables.

Key analysis areas included:

Plant-level production performance.
Production-line performance.
Shift-wise production analysis.
Downtime reason analysis.
Defect type and severity analysis.
Maintenance cost and duration analysis.

SQL techniques used included aggregations, joins, grouping, percentage calculations, and analytical queries.

🐍 Python Exploratory Data Analysis

Python was used to explore production and operational patterns before dashboard development.

The analysis included:

Overall production performance.
Plant performance comparison.
Production-line achievement analysis.
Downtime duration analysis.
Maintenance cost and duration analysis.
Defect quantity analysis.
Statistical summaries and visualizations.
📊 Power BI Dashboard

The final Power BI dashboard provides an interactive view of manufacturing performance across production, quality, downtime, and maintenance.

Dashboard Pages
Home
Plant Overview
Shift Overview
Monthly Trend Overview
Product & Quality
Reliability

The dashboard uses a structured data model connecting production, downtime, defect, maintenance, and reference tables.

Dashboard Preview

Screenshots of the dashboard are available in the screenshots folder.

📈 Key Performance Indicators
KPI	Result
Planned Production	15,832,893 units
Actual Production	14,938,596 units
Production Gap	894,297 units
Overall Achievement Rate	94.35%
Downtime Events	12,000
Average Downtime/Event	58.99 min
Maintenance Events	5,000
Average Maintenance Duration	72.87 min
Average Maintenance Cost/Event	$4,298.79
Defect Records	8,000
Average Defect Quantity/Record	3.99 units
🔍 Key Insights
Plant Performance
P01 (Chennai) recorded the highest achievement rate at 96.76%.
P02 (Pune) recorded the lowest achievement rate at 92.79%.
P02 also recorded the largest production gap of 380,857 units.
Production Line Performance
L04 (Chennai Line 4) was the highest-performing line with 96.80% achievement.
L06 (Pune Line 1) recorded the lowest achievement at 92.76%.
The three lowest-performing lines were all located in P02 Pune.
Downtime & Reliability
The dataset contains 12,000 downtime events.
Average downtime per event was approximately 59 minutes.
The analysis identified major downtime categories including mechanical, electrical, setup, and material-related issues.
Maintenance
The project contains 5,000 maintenance records.
Average maintenance duration was 72.87 minutes.
Average maintenance cost was $4,298.79 per event.
💡 Recommendations

Based on the analysis:

Focus improvement efforts on P02 Pune, particularly its lower-performing production lines.
Investigate recurring downtime causes to reduce production losses.
Strengthen preventive maintenance for critical equipment.
Monitor production achievement and downtime trends regularly.
Use quality and defect patterns to identify opportunities for process improvement.
📁 Repository Contents
📂 data
   └── Manufacturing CSV datasets

📂 python
   └── Python EDA and analysis notebook

📂 sql
   └── SQL analysis script

📂 powerbi
   └── Power BI dashboard

📂 screenshots
   └── Dashboard screenshots

📂 report
   └── Final project report
🚀 Future Scope

The project can be further enhanced by integrating:

Real-time IoT and machine sensor data.
Predictive maintenance models.
Machine failure prediction.
Automated operational alerts.
Production forecasting.
Machine learning-based anomaly detection.
👩‍💻 Project Skills Demonstrated

Data Cleaning • Exploratory Data Analysis • SQL • Python • Pandas • Data Visualization • Power BI • DAX • Data Modeling • KPI Analysis • Business Intelligence • Manufacturing Analytics

📌 Project Outcome

The project provides an end-to-end view of manufacturing operations by combining production, downtime, quality, and maintenance analysis.

The final analysis identified 94.35% overall production achievement, with P02 Pune requiring the greatest attention due to its lower achievement rate and largest production gap. The Power BI dashboard brings these findings together into an interactive reporting solution for operational monitoring and decision-making.
