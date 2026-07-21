-- Databricks notebook source
SELECT *
FROM brighttv.brighttv.bright_tv_dataset_user_profiles
limit 100; 
------------------------------------------------------
---------Gender Checks-----------------------
------------------------------------------------------
SELECT DISTINCT gender
FROM brighttv.brighttv.bright_tv_dataset_user_profiles;

SELECT DISTINCT
    CASE 
       WHEN gender ='None' THEN 'Unknown'--Replacing the value none with unknow
       WHEN gender = ' ' THEN 'Unknown'----Replacing the empty with unknow
       WHEN gender IS Null THEN 'Unknown'
       ELSE gender --if gender is male or female return it as it is
    END AS sex ---- New column name
FROM brighttv.brighttv.bright_tv_dataset_user_profiles;
--------------------------------------------------------
------------ Race Checks ------ Counting Ethnicity
-------------------------------------------------------
SELECT DISTINCT race
FROM brighttv.brighttv.bright_tv_dataset_user_profiles;


SELECT COUNT(DISTINCT  userid) AS subs,
     CASE
         WHEN race = 'other' THEN 'Unknown'
         WHEN race = 'None' THEN 'Unknown'
         WHEN race = ' ' THEN 'Unknown'
         WHEN race IS NULL THEN 'Unknown'
         ELSE race
    END AS ethnicity ---- New column name
FROM brighttv.brighttv.bright_tv_dataset_user_profiles
GROUP BY ethnicity;
--------------------------------------------------------
------Province Checks ------ 
-------------------------------------------------------
SELECT DISTINCT province
FROM brighttv.brighttv.bright_tv_dataset_user_profiles;

SELECT DISTINCT 
CASE
    WHEN province = 'None' THEN 'Unknown'
    WHEN Province = ' ' THEN 'Unknown'
    WHEN province IS NULL THEN 'Unknown'
    ELSE province 
    END AS Region
FROM brighttv.brighttv.bright_tv_dataset_user_profiles;

--------------------------------------------------------
------Age Checks ------ 
-------------------------------------------------------

SELECT DISTINCT age
FROM brighttv.brighttv.bright_tv_dataset_user_profiles;

SELECT 
  CASE
     WHEN Age = 0 THEN 'Infant'
     WHEN Age Between 1 AND 12 THEN 'Kids'
     WHEN Age Between 13 AND 17 THEN 'Youth'
     WHEN Age Between 18 AND 35 THEN 'Young Adult'
     WHEN Age Between 36 AND 50 THEN 'Adult'
     WHEN Age >50 AND age<=60 THEN 'Elder'
     WHEN Age >60 THEN 'Pensioner' 
     END AS Age_group
FROM brighttv.brighttv.bright_tv_dataset_user_profiles;

--------------------------------------------------------
CREATE OR REPLACE TEMPORARY TABLE processed_userprofiles AS 
SELECT 
    UserID,

    CASE
       WHEN (Email IS NOT NULL) OR (Email<>' ') OR (Email NOT IN ('None', 'other')) THEN 1
       ELSE 0
    END AS email_flag,

    CASE
       WHEN (`Social Media Handle`IS NOT NULL) OR (`Social Media Handle`<>' ') OR (`Social Media Handle` NOT IN ('None', 'other')) THEN 1
       ELSE 0
    END AS socialmedia_flag,

    CASE 
       WHEN gender ='None' THEN 'Unknown'
       WHEN gender = ' ' THEN 'Unknown'
       WHEN gender IS Null THEN 'Unknown'
       ELSE gender 
    END AS sex,

    CASE
        WHEN race = 'other' THEN 'Unknown'
        WHEN race = 'None' THEN 'Unknown'
        WHEN race = ' ' THEN 'Unknown'
        WHEN race IS NULL THEN 'Unknown'
    ELSE race
    END AS ethnicity,

    CASE
        WHEN province = 'None' THEN 'Unknown'
        WHEN Province = ' ' THEN 'Unknown'
        WHEN province IS NULL THEN 'Unknown'
    ELSE province 
    END AS Region,

    AGE,
    CASE
        WHEN Age = 0 THEN '01.Infant: 0'
        WHEN Age Between 1 AND 12 THEN '02.Kids: 1-12'
        WHEN Age Between 13 AND 17 THEN '03.Youth: 13-17'
        WHEN Age Between 18 AND 35 THEN '04.Young Adult: 18-35'
        WHEN Age Between 36 AND 50 THEN '05.Adult: 36-50'
        WHEN Age >50 AND age<=60 THEN '06.Elder: 51-60'
        WHEN Age >60 THEN '07.Pensioner: >60' 
     END AS Age_group

FROM brighttv.brighttv.bright_tv_dataset_user_profiles;

Select count(*) as cnt,
       count(distinct userid) as subs
from processed_userprofiles;

