-- Databricks notebook source
SELECT*
FROM brighttv.brighttv.bright_tv_dataset_viewership;

----------------------- Viewing Patterns by hour of day ---------------------------------------------
  
WITH viewing_time AS (
  SELECT
    userid4,
    SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`))
      / 60.0 as total_minutes
  FROM
    `brighttv`.`brighttv`.`bright_tv_dataset_viewership`
  GROUP BY
    userid4
)
SELECT
  CASE
    WHEN
      p.Province IS NULL
      OR TRIM(p.Province) IN ('None', '')
    THEN
      'Unknown'
    ELSE p.Province
  END as province,
  COUNT(DISTINCT v.userid4) as user_count,
  ROUND(AVG(v.total_minutes), 2) as avg_viewing_minutes
FROM
  viewing_time v
    JOIN `brighttv`.`brighttv`.`bright_tv_dataset_user_profiles` p
      ON v.userid4 = p.UserID
WHERE
  p.Province NOT IN ('None', ' ', '')
GROUP BY
  province
ORDER BY
  avg_viewing_minutes DESC;

  ----------------------- Average Viewing Time by Race  ---------------------------------------

WITH viewing_time AS (
  SELECT
    userid4,
    SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`))
      / 60.0 as total_minutes
  FROM
    `brighttv`.`brighttv`.`bright_tv_dataset_viewership`
  GROUP BY
    userid4
)
SELECT
  CASE
    WHEN
      p.Race IS NULL
      OR TRIM(p.Race) IN ('None', '')
    THEN
      'Unknown'
    ELSE p.Race
  END as race,
  COUNT(DISTINCT v.userid4) as user_count,
  ROUND(AVG(v.total_minutes), 2) as avg_viewing_minutes
FROM
  viewing_time v
    JOIN `brighttv`.`brighttv`.`bright_tv_dataset_user_profiles` p
      ON v.userid4 = p.UserID
WHERE
  p.Race NOT IN ('None', ' ', '')
GROUP BY
  race
ORDER BY
  avg_viewing_minutes DESC;

  ----------------------------------------------------------------------------

  SELECT
  HOUR(RecordDate2) as viewing_hour,
  COUNT(*) as session_count,
  ROUND(
    SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0,
    2
  ) as total_minutes,
  ROUND(
    AVG(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0,
    2
  ) as avg_session_minutes
FROM
  `brighttv`.`brighttv`.`bright_tv_dataset_viewership`
GROUP BY
  viewing_hour
ORDER BY
  viewing_hour;

----------------------------- Channels with Lowest Consumption  -----------------------------------------

SELECT
  Channel2 as channel,
  COUNT(*) as session_count,
  ROUND(
    AVG(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0,
    2
  ) as avg_session_minutes
FROM
  `brighttv`.`brighttv`.`bright_tv_dataset_viewership`
GROUP BY
  channel
HAVING
  session_count >= 50
ORDER BY
  avg_session_minutes ASC
LIMIT 10;

------------------------------- Viewing Time by Day of Week-----------------

SELECT
  DAYOFWEEK(RecordDate2) as day_num,
  CASE DAYOFWEEK(RecordDate2)
    WHEN 1 THEN 'Sunday'
    WHEN 2 THEN 'Monday'
    WHEN 3 THEN 'Tuesday'
    WHEN 4 THEN 'Wednesday'
    WHEN 5 THEN 'Thursday'
    WHEN 6 THEN 'Friday'
    WHEN 7 THEN 'Saturday'
  END as day_of_week,
  COUNT(*) as session_count,
  ROUND(
    SUM(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0,
    2
  ) as total_minutes,
  ROUND(
    AVG(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0,
    2
  ) as avg_session_minutes,
  COUNT(DISTINCT userid4) as unique_viewers
FROM
  `brighttv`.`brighttv`.`bright_tv_dataset_viewership`
GROUP BY
  day_num,
  day_of_week
ORDER BY
  day_num;

------------------------- Hours with Lowest Average Session Time--------------

SELECT
  HOUR(RecordDate2) as viewing_hour,
  COUNT(*) as session_count,
  ROUND(
    AVG(HOUR(`Duration 2`) * 3600 + MINUTE(`Duration 2`) * 60 + SECOND(`Duration 2`)) / 60.0,
    2
  ) as avg_session_minutes
FROM
  `brighttv`.`brighttv`.`bright_tv_dataset_viewership`
GROUP BY
  viewing_hour
ORDER BY
  avg_session_minutes ASC
LIMIT 10;

----------------------------- 

