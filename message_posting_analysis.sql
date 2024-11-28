-- PURPOSE: This query is designed to analyze the results of an A/B test conducted on Yammer's publisher feature.
-- It calculates key metrics such as average message counts, user engagement, and statistical significance between 
-- the control and treatment groups. The goal is to evaluate whether the new publisher feature leads to a significant 
-- increase in user engagement (message posting rates).

-- NOTE: This query assumes the existence of the following tables and their structure:
-- 1. tutorial.yammer_experiments
--    - Columns:
--        user_id (INTEGER): Unique identifier for each user.
--        experiment_group (STRING): Group assignment ('control_group' or 'test_group').
--        experiment (STRING): Name of the experiment (e.g., 'publisher_update').
--        occurred_at (TIMESTAMP): Timestamp of the user's experiment start date.
-- 
-- 2. tutorial.yammer_events
--    - Columns:
--        user_id (INTEGER): Unique identifier for each user.
--        event_name (STRING): Name of the event (e.g., 'send_message').
--        occurred_at (TIMESTAMP): Timestamp of the event.
--
-- 3. benn.normal_distribution
--    - A lookup table for normal distribution values used to calculate p-values.
--    - Columns:
--        score (FLOAT): The rounded t-statistic value.
--        value (FLOAT): The corresponding probability density.

-- NOTE: These queries are designed to be executed on the Yammer A/B Test SQL editor provided at:
-- [Link to Dataset](https://mode.com/sql-tutorial/validating-ab-test-results)
--
-- The data is not available for direct download. Ensure you have access to the website and execute the queries there.



WITH smbu AS ( -- send message by user
SELECT ex.user_id, experiment, experiment_group,
    COUNT(CASE WHEN (event_name = 'send_message' AND (ev.occurred_at BETWEEN ex.occurred_at AND '2014-06-30 23:59:59')) 
      THEN ex.user_id ELSE NULL END) AS events
  FROM tutorial.yammer_experiments ex
    LEFT JOIN tutorial.yammer_events ev
      ON ex.user_id = ev.user_id
  WHERE experiment = 'publisher_update'
  GROUP BY ex.user_id, experiment, experiment_group
), smbg AS ( -- send message by group
SELECT experiment, experiment_group,
    COUNT(user_id) AS users,
    SUM(events) AS total,
    AVG(events) AS average,
    STDDEV(events) AS stdev,
    VARIANCE(events) AS variance
  FROM smbu
  GROUP BY experiment, experiment_group
), smbg2 AS (
SELECT *,
    SUM(users) OVER() AS total_treated_users,
    ROUND(users/SUM(users) OVER(), 4) AS treatment_percent,
    MAX(CASE WHEN experiment_group = 'control_group' THEN average ELSE NULL END) OVER() AS control_avg,
    MAX(CASE WHEN experiment_group = 'control_group' THEN variance ELSE NULL END) OVER() AS control_var,
    MAX(CASE WHEN experiment_group = 'control_group' THEN users ELSE NULL END) OVER() AS control_users
  FROM smbg
)

SELECT experiment, experiment_group, users, total_treated_users, treatment_percent, total, average, stdev,
    (average - control_avg)/SQRT(variance/users + control_var/control_users) AS t_stat,
    (1 - COALESCE(nd.value,1))*2 AS p_value
  FROM smbg2
  LEFT JOIN benn.normal_distribution nd
    ON nd.score = ABS(ROUND((average - control_avg)/SQRT((variance/users) + (control_var/control_users)),3))