/* 
Diabetes Project
*/


-- 1. Previewing all the data

Select *
From DiabetesProject1..Diabetes
---> The results show that there are records of 768 women 




-- 2. The number of women that are diabetic vs non diabetic 

Select 
COUNT (*) AS TotalPatients,
SUM (CASE WHEN outcome = 'Diabetic' THEN 1 ELSE 0 END) AS DiabeticPatients,
SUM (CASE WHEN outcome = 'Non Diabetic' THEN 1 ELSE 0 END) AS NonDiabeticPatients
From DiabetesProject1..Diabetes
---> there are 268 diabetic patients and 500 non diabetic patients 




-- 3. Diabetic Percentage rate 

Select 
COUNT (*) AS TotalPatients,
SUM (CASE WHEN outcome = 'Diabetic' THEN 1 ELSE 0 END) AS DiabeticPatients,
(SUM (CASE WHEN outcome = 'Diabetic' THEN 1 ELSE 0 END) * 100 / COUNT(*))  AS DiabeticPercentageRate
From DiabetesProject1..Diabetes
---> 34% of 768 women are diabetic 
 



 -- 4. Average Health Factors for Diabetic and Non Diabetic Patients 

 Select 
 outcome, 
 ROUND(AVG(glucose),2) AS AverageGlucose, 
 ROUND(AVG(bmi),2) AS AverageBMI, 
 ROUND(AVG(age),2) AS AverageAge,
 ROUND(AVG(bloodpressure),2) AS AverageBloodPressure
From DiabetesProject1..Diabetes
GROUP BY outcome
---> The difference in average glucose levels, BMI, age and blood pressure between diabetic and non diabetic patients 
---> Diabetic patients have a higher overlal average 




-- 5. Top 5 patients with high glucose levels

Select TOP 5 *
From DiabetesProject1..Diabetes
ORDER BY Glucose desc 
---> 4/5 are diabetic - 1 patient is not diabetic but has glucose level similar to those of diabetic patients (potentially an outlier)




-- 6. Top 5 patients with high BMI levels

Select TOP 5 *
From DiabetesProject1..Diabetes
ORDER BY BMI desc 
---> 4/5 are diabetic - 1 patient is not diabetic but has high BMI level (potentially an outlier)




-- 7. Top 10 youngest non diabetic patients 

Select TOP 10 *
From DiabetesProject1..Diabetes
Where Outcome = 'Non Diabetic' 
ORDER BY age asc 
---> the patients are 21 years old and have had 1 or 2 pregnancies and BMI equal to or less than 30 




-- 8. Top 10 youngest diabetic patients 

Select TOP 10 *
From DiabetesProject1..Diabetes
Where Outcome = 'Diabetic' 
ORDER BY age asc 
---> the patients are 21/22 years old and have had 0,1,2,3 or 4 pregnancies and BMI greater than 25





-- 9. Top 10 oldest non diabetic patients 

Select TOP 10 *
From DiabetesProject1..Diabetes
Where Outcome = 'Non Diabetic' 
ORDER BY age desc 
---> the patients are 65 or older  





-- 10. Top 10 oldest diabetic patients 

Select TOP 10 *
From DiabetesProject1..Diabetes
Where Outcome = 'Diabetic' 
ORDER BY age desc 
---> 



-- 11. The number of women that are diabetic and have been pregant once or more 

Select Pregnancies, Outcome
From DiabetesProject1..Diabetes
Where Outcome = 'Diabetic' AND Pregnancies >= 1 
---> Of 268 diabetic women, 230 have been pregnant once or more 



-- 12. Age Group Breakdown 

With AgeGroup AS (
Select *,
CASE 
WHEN age < 30 THEN 'Under 30'
WHEN age BETWEEN 30 AND 39 THEN '30-39' 
WHEN age BETWEEN 40 AND 49 THEN '40-49' 
WHEN age BETWEEN 50 AND 59 THEN '50-59' 
ELSE 'Over 60'
END AS AgeGroup
From DiabetesProject1..Diabetes
)
Select
AgeGroup,
COUNT(*) AS TotalPatients,
SUM(CASE WHEN outcome = 'Diabetic' THEN 1 ELSE 0 END) * 100 /COUNT(*) AS DiabeticPercentageRate,
AVG(glucose) AS AverageGlucose,
AVG(bmi) AS AverageBMI
From AgeGroup
GROUP BY AgeGroup
ORDER BY AgeGroup



-- 13. Number of Pregnancies Breakdown 

With NumberOfPregnancies AS (
Select *,
CASE 
WHEN Pregnancies = 0 THEN 'No Pregnancies'
WHEN Pregnancies BETWEEN 1 AND 2 THEN '1-2 Pregnancies' 
WHEN Pregnancies BETWEEN 3 AND 4 THEN '3-4 Pregnancies' 
WHEN Pregnancies BETWEEN 5 AND 6 THEN '5-6 Preganacies' 
ELSE '7+ Pregnancies'
END AS NumberOfPregnancies
From DiabetesProject1..Diabetes
)
Select
NumberOfPregnancies,
COUNT(*) AS TotalPatients,
SUM(CASE WHEN outcome = 'Diabetic' THEN 1 ELSE 0 END) * 100 /COUNT(*) AS DiabeticPercentageRate,
AVG(glucose) AS AverageGlucose,
AVG(bmi) AS AverageBMI
From NumberOfPregnancies
GROUP BY NumberOfPregnancies
ORDER BY NumberOfPregnancies




-- 14(a). Patients with normal glucose levels but diabetic 

Select *
From DiabetesProject1..Diabetes
WHERE Outcome = 'Diabetic' AND Glucose < 140 
ORDER BY glucose asc
---> less than 140 is normal levels 
---> 133 patients 


-- (b). Patients with very high glucose levels but not diabetic 

Select *
From DiabetesProject1..Diabetes
WHERE Outcome = 'Non Diabetic' AND Glucose > 200 
ORDER BY glucose desc
---> equal to and greater than 200 is diabetic -- no results 


---> (c). checking at mid point between 140 and 200 which is 170 -- prediabetes
Select *
From DiabetesProject1..Diabetes
WHERE Outcome = 'Non Diabetic' AND Glucose > 170 
ORDER BY glucose desc
---> 11 patients 





-- 15. Ranking of High-Risk Patients from all Patients

Select TOP 10 *,
ROW_NUMBER() OVER (ORDER BY glucose desc, bmi desc, age desc) AS RiskRanking
From DiabetesProject1..Diabetes



-- 16. Ranking of High-Risk Patients that are not diabetic

Select TOP 10 *,
ROW_NUMBER() OVER (ORDER BY glucose desc, bmi desc, age desc) AS RiskRanking
From DiabetesProject1..Diabetes
WHERE Outcome = 'Non Diabetic'




--  17. The number of women that are diabetic and have blood pressure greater than normal (80 and greater)

Select Pregnancies, BloodPressure
From DiabetesProject1..Diabetes
Where Outcome = 'Diabetic' AND BloodPressure >= 80
---> Of 268 diabetic women, 90 have a diastolic blood pressure greater than 80 




-- 18. The number of women that are diabetic and have BMI greater than healthy (25 and greater)

Select Pregnancies, BMI
From DiabetesProject1..Diabetes
Where Outcome = 'Diabetic' AND BMI >= 25
---> Of 268 diabetic women, 259 have a BMI greater than 25 (i.e. overweight or obese)





























 





