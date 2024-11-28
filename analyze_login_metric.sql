WITH smbu AS ( -- send message by user
SELECT ex.user_id, experiment, experiment_group,
    COUNT(CASE WHEN (event_name = 'login' AND (ev.occurred_at BETWEEN ex.occurred_at AND '2014-06-30 23:59:59')) 
      THEN ex.user_id ELSE NULL END) AS events
  FROM tutorial.yammer_experiments ex
    LEFT JOIN tutorial.yammer_events ev
      ON ex.user_id = ev.user_id
--    LEFT JOIN tutorial.yammer_users u 
--      ON ex.user_id = u.user_id
  WHERE experiment = 'publisher_update'
--    AND u.created_at < '2014-06-01 00:00:00'
  GROUP BY ex.user_id, experiment, experiment_group
)
...