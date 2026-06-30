USE help_desk_analysis;

/* =========================
   SECTION 1: DATA OVERVIEW
   ========================= */

# ----------------------------
# Total tickets in the dataset
# ----------------------------
SELECT COUNT(*) AS total_tickets
FROM help_desk;

# ------------------------------
# Incident state distribution 
# ------------------------------
SELECT 
     incident_state,
     COUNT(*) AS ticket_count
FROM help_desk
GROUP BY incident_state
ORDER BY ticket_count DESC;

# ----------------------
# Priority distribution 
# ----------------------
SELECT 
     priority,
     COUNT(*) AS ticket_count
FROM help_desk
GROUP BY priority
ORDER BY ticket_count DESC;

# ------------------
# Top 10 categories
# ------------------
SELECT 
     category,
     COUNT(*) AS ticket_count
FROM help_desk
GROUP BY category
ORDER BY ticket_count DESC
LIMIT 10;


/* ===================================
   SECTION 2 : OPERATIONAL PERFORMANCE
   =================================== */

#----------------------------------
# Avg resolution time by priority
#----------------------------------
SELECT 
      ROUND(AVG(TIMESTAMPDIFF(SECOND, opened_at, resolved_at)) / 3600,
        2) AS avg_resolution_hours,
	  priority
FROM help_desk
WHERE resolved_at IS NOT NULL
GROUP BY priority
ORDER BY avg_resolution_hours;

#-------------------------------------------
# AVG resolution time for assignment groups 
#-------------------------------------------
SELECT 
      assignment_group,
      COUNT(*) AS total_tickets,
      AVG(TIMESTAMPDIFF
			(SECOND,opened_at,resolved_at)/3600) 
            AS avg_resolution_hrs
FROM help_desk
WHERE assignment_group IS NOT NULL AND resolved_at IS NOT NULL
GROUP BY assignment_group
HAVING COUNT(*)>=50
ORDER BY avg_resolution_hrs DESC;

#--------------------------
# Resolution time bucket
#--------------------------

SELECT  
     COUNT(*) AS total_tickets,
     CASE
    WHEN TIMESTAMPDIFF(HOUR, opened_at, resolved_at) < 24 THEN '< 24 Hours'
    WHEN TIMESTAMPDIFF(HOUR, opened_at, resolved_at) < 72 THEN '1–3 Days'
    WHEN TIMESTAMPDIFF(HOUR, opened_at, resolved_at) < 168 THEN '3–7 Days'
    WHEN TIMESTAMPDIFF(HOUR, opened_at, resolved_at) < 720 THEN '7–30 Days'
    ELSE '> 30 Days'
END AS resolution_bucket
FROM help_desk 
WHERE resolved_at IS NOT NULL
GROUP BY resolution_bucket
ORDER BY 
CASE resolution_bucket
    WHEN '< 24 Hours' THEN 1
    WHEN '1–3 Days' THEN 2
    WHEN '3–7 Days' THEN 3
    WHEN '7–30 Days' THEN 4
    WHEN '> 30 Days' THEN 5
END;
#---------------------------------------
# Resolution time Vs reassignment count
#---------------------------------------
SELECT 
      reassignment_count,
      COUNT(*) AS total_tickets,
      ROUND(AVG(TIMESTAMPDIFF(SECOND,opened_at,resolved_at)/3600),2)
          AS avg_resolution_hrs
FROM help_desk
WHERE resolved_at IS NOT NULL
GROUP BY reassignment_count
ORDER BY reassignment_count;

#-------------------------------
# Monthly SLA performance trend
#-------------------------------
SELECT 
      YEAR(opened_at) AS year,
      MONTH(opened_at) AS month,
      COUNT(*) AS total_ticket,
      ROUND(
           (SUM(CASE WHEN made_sla = 0 THEN 1 
                   ELSE 0 END)/COUNT(*))*100,2)
                   AS sla_failure_rate
FROM help_desk
GROUP BY year,month
ORDER BY year,month;


/* ===============================
   Section 3: SLA & Service Quality
   =============================== */
  
#-----------------------------------
# Contact type SLA failure analysis
#-----------------------------------
SELECT
    contact_type,
    COUNT(*) AS total_tickets,
    ROUND(
        SUM(CASE WHEN made_sla = 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS sla_failure_rate
FROM help_desk
GROUP BY contact_type
ORDER BY sla_failure_rate DESC;

#-----------------------------
# SLA failure rate by category
#-----------------------------
SELECT 
	category,
    ROUND(AVG(CASE WHEN made_sla = 0 THEN 1 
               ELSE 0 END)*100,2) AS failure_rate
FROM help_desk
WHERE category IS NOT NULL
GROUP BY category
ORDER BY failure_rate DESC;

#-------------------------------
# SLA failure rate by  location
#-------------------------------
SELECT 
      location,
      ROUND(
           (SUM(CASE WHEN made_sla = 0 THEN 1 
                   ELSE 0 END)/COUNT(*))*100,2) 
                   AS sla_failure_rate
FROM help_desk 
GROUP BY location
HAVING COUNT(*)>=50
ORDER BY sla_failure_rate DESC;

#-----------------------------------------------
# Assignment groups rank by the SLA failure rate
#-----------------------------------------------
WITH CTE AS (
SELECT 
      assignment_group,
      ROUND(
           (SUM(CASE WHEN made_sla = 0 THEN 1 
                   ELSE 0 END)/COUNT(*))*100,2)
                   AS sla_failure_rate
FROM help_desk 
WHERE assignment_group IS NOT NULL
GROUP BY assignment_group
)
SELECT 
      assignment_group,
      sla_failure_rate,
      DENSE_RANK() OVER(ORDER BY sla_failure_rate DESC) AS group_rank
FROM CTE;

#---------------------------
# Categories risk scorecard
#---------------------------
SELECT 
     category,
     COUNT(*) AS total_tickets,
      ROUND(AVG(TIMESTAMPDIFF(SECOND,opened_at,resolved_at)/3600),2)
          AS avg_resolution_hrs,
	 ROUND(
           (SUM(CASE WHEN made_sla = 0 THEN 1 
                   ELSE 0 END)/COUNT(*))*100,2)
                   AS sla_failure_rate,
	 ROUND((SUM(CASE WHEN priority = '1 - Critical' THEN 1 
               ELSE 0 END)*100)/COUNT(*),
               2
               ) AS critical_ticket_rate,
	 ROUND(AVG(reopen_count)*100,2) AS reopen_rate_percent
FROM help_desk 
WHERE category IS NOT NULL AND resolved_at IS NOT NULL
GROUP BY category
HAVING total_tickets>=50
ORDER BY sla_failure_rate DESC,critical_ticket_rate DESC ;

#---------------------------
# Priority wise performance
#---------------------------
SELECT 
      priority,
      COUNT(*) AS total_tickets,
       ROUND(AVG(TIMESTAMPDIFF(SECOND,opened_at,resolved_at)/3600),2)
          AS avg_resolution_hrs,
      ROUND(
           (SUM(CASE WHEN made_sla = 0 THEN 1 
                   ELSE 0 END)/COUNT(*))*100,2)
                   AS sla_failure_rate,
	  ROUND(AVG(reopen_count)*100,2) AS reopen_rate_percent
FROM help_desk 
WHERE resolved_at IS NOT NULL
GROUP BY priority
ORDER BY priority;

/* ==============================
   Section 4: Process Efficiency
   ============================== */

#------------------------------
# AVG reopen count by category
#------------------------------
SELECT 
      category,
      COUNT(*) AS ticket_count,
      ROUND(AVG(reopen_count)*100,2) AS reopen_rate_percent
FROM help_desk 
WHERE category IS NOT NULL
GROUP BY category
ORDER BY AVG(reopen_count) DESC;

#----------------------------------------
# Assignment group performance scorecard
#----------------------------------------
SELECT 
      assignment_group,
      COUNT(*) AS total_tickets,
      ROUND(AVG(TIMESTAMPDIFF(SECOND,opened_at,resolved_at)/3600),2)
          AS avg_resolution_hrs,
	  ROUND(AVG(reassignment_count),2) AS avg_reassignment,
      ROUND(AVG(reopen_count)*100,2) AS avg_reopen_rate,
      ROUND(
           (SUM(CASE WHEN made_sla = 0 THEN 1 
                   ELSE 0 END)/COUNT(*))*100,2)
                   AS sla_failure_rate,
	  ROUND(SUM(CASE WHEN active = 1 THEN 1 
                ELSE 0 END)/COUNT(*)*100,2) 
                 AS active_ticket_rate
FROM help_desk 
WHERE assignment_group IS NOT NULL AND resolved_at IS NOT NULL
GROUP BY assignment_group
HAVING COUNT(*)>=50
ORDER BY total_tickets DESC;

#--------------------------------------------------
# Categories above overall average resolution time
#--------------------------------------------------
WITH A AS (
SELECT 
      ROUND(AVG(TIMESTAMPDIFF(SECOND,opened_at,resolved_at)/3600),2)
          AS overall_avg
FROM help_desk
WHERE resolved_at IS NOT NULL
),
B AS (
SELECT 
      category,
      COUNT(*) AS total_tickets,
      ROUND(AVG(TIMESTAMPDIFF(SECOND,opened_at,resolved_at)/3600),2)
          AS category_avg
FROM help_desk 
WHERE category IS NOT NULL AND  resolved_at IS NOT NULL
GROUP BY category
)
SELECT 
      B.category,
      B.category_avg,
      A.overall_avg
FROM B CROSS JOIN A 
WHERE B.category_avg>A.overall_avg AND category IS NOT NULL;

SELECT MONTH(opened_at) AS mnt, ROUND(AVG(TIMESTAMPDIFF(SECOND,opened_at,resolved_at)/3600),2)
          AS avg_resolution_hrs
FROM help_desk
GROUP BY mnt;

/* ============================
    Assignment Group Analysis
   ============================ */

# --------------------------------------------------------------
# Assignment groups with the highest average reassignment count
# --------------------------------------------------------------
SELECT
    assignment_group,
    COUNT(*) AS total_tickets,
    ROUND(AVG(reassignment_count),2) AS avg_reassignment_count,
    ROUND(AVG(resolution_hours),2) AS avg_resolution_hours
FROM help_desk
WHERE assignment_group IS NOT NULL
GROUP BY assignment_group
HAVING COUNT(*) >= 50
ORDER BY avg_reassignment_count DESC;