-- Databricks notebook source

SELECT *
FROM `brighttv`.`brighttv`.`bright_tv_dataset_viewership`
Limit 100;
-----------------------
-- Row count
-----------------------
SELECT COUNT(*) AS total_rows
FROM `brighttv`.`brighttv`.`bright_tv_dataset_viewership`

--------------------------
-- Channel Check-----
--------------------------

SELECT DISTINCT Channel2
FROM `brighttv`.`brighttv`.`bright_tv_dataset_viewership`


SELECT 
  Channel2,
  COUNT(*) AS total_views
FROM `brighttv`.`brighttv`.`bright_tv_dataset_viewership`
GROUP BY Channel2
ORDER BY total_views DESC
LIMIT 10;

-------------------------------------------------------
-- Channel popularity by day of week-----
-------------------------------------------------------

SELECT
  RecordDate2,
  Channel2,                                    
  COUNT(*)  AS sessions                                  
FROM `brighttv`.`brighttv`.`bright_tv_dataset_viewership`
GROUP BY RecordDate2, Channel2;









