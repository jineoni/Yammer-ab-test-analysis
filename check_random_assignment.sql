SELECT DATE_TRUNC('month', created_at) AS month,
    COUNT(CASE WHEN experiment_group = 'control_group' THEN ex.user_id ELSE NULL END) AS control_group,
    COUNT(CASE WHEN experiment_group = 'test_group' THEN ex.user_id ELSE NULL END) AS test_group
  FROM tutorial.yammer_experiments ex
  LEFT JOIN tutorial.yammer_users u
    ON ex.user_id = u.user_id
  WHERE experiment = 'publisher_update'
  GROUP BY month
  ORDER BY month;