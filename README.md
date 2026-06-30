# Help Desk Ticket Performance Analysis

End-to-end data analytics project analyzing 141,700+ IT help desk incident tickets using SQL, Python, and Power BI to uncover operational bottlenecks and improve service efficiency.

**Domain:** IT Service Management (ITSM) | **Type:** Self-Learning Portfolio Project

---

## 📊 Project Overview

This project analyzes a ServiceNow Help Desk Incident dataset to understand ticket volume trends, resolution performance, SLA compliance, and the operational factors driving delays. The workflow covers data cleaning, exploratory data analysis, SQL-based business analysis, and an interactive Power BI dashboard.

**Workflow:** Raw Dataset → Data Cleaning → EDA → SQL Analysis → Power BI Dashboard → Business Insights

---

## 🛠️ Tools & Technologies

- **SQL** (MySQL)
- **Python** (Pandas, NumPy, Matplotlib, Seaborn)
- **Power BI** (DAX, Interactive Dashboards)

---

## 📁 Repository Structure

```
help-desk-analysis/
├── data/                 # Raw and cleaned datasets
├── python/              # Python scripts for cleaning and EDA
├── sql/                  # SQL analysis queries
├── dashboard/            # Power BI (.pbix) file and dashboard exports
├── storytelling/         # Full project storytelling document (PDF)
└── README.md
```
---

## 🔑 Key Performance Indicators

| Metric | Value |
|---|---|
| Total Tickets | 141.7K |
| Avg Resolution Time | 269.6 hrs |
| SLA Failure Rate | 6.5% |
| Avg Reassignment Count | 1.1 |

---

## 📈 Dashboard Preview

![Help Desk Dashboard](dashboard/help_desk.PNG)

*Interactive Power BI dashboard with filters for Priority and Assignment Group, covering ticket volume trends, impact distribution, resolution time analysis, and category-level performance.*

---

## 💡 Key Insights

- **Strong SLA compliance overall** — 93.5% of tickets met SLA targets, but average resolution time (269.6 hrs) indicates a long tail of slow-moving tickets.
- **Low-priority tickets take longer than critical ones** — 4-Low priority tickets averaged 408 hrs vs. 176 hrs for High priority, signaling a hidden backlog risk.
- **Reassignment is the strongest driver of delay** — resolution time rises from 190 hrs (0 reassignments) to 1,174+ hrs (25+ reassignments).
- **Workload is concentrated** — top 3 categories (26, 42, 53) account for ~35% of total ticket volume.
- **Category 46 is high-traffic and slow** — ranks 4th in volume but has the longest average resolution time (386.4 hrs), making it a key target for process improvement.
- **95% of tickets are Medium-impact**, showing the help desk's workload is largely routine rather than critical incidents.

---

## 📄 Full Project Report

The complete business storytelling document — including methodology, detailed SQL analysis, EDA findings, and full business recommendations — is available here:
[**View Full Report**](storytelling/help_desk.pdf)

---

## 🚀 Future Improvements

- Predict ticket resolution time using machine learning
- Forecast ticket volume with time series analysis
- Automate dashboard refresh via data pipeline
- Incorporate first response time and CSAT metrics
- Publish dashboard via Power BI Service for real-time monitoring

---

## 👤 Author

**Saurabh Sonawane**

- LinkedIn: https://www.linkedin.com/in/saurabh-sonawane-06b776285/
- GitHub: https://github.com/saurabhsonawane87
- Email: saurabhsonawane1408@gmail.com

---

## 📄 License

This project is intended for educational and portfolio purposes only. The dataset is sourced from a publicly available ServiceNow Incident Event Log dataset on Kaggle and is used solely for learning and demonstration purposes.
