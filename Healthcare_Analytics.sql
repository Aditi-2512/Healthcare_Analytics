--- Creating a table to enter all our values
CREATE TABLE healthcare (
	Name varchar(50) NOT NULL,
	Age varchar(5), 
	Gender varchar(50),
	"Blood Type" varchar(5),
	"Medical Condition" varchar(25),
	"Date of Admission" date,
	Doctor varchar(50),
	Hospital varchar(50),
	Insurance varchar(50),
	"Billing Amount" real,
	"Room Number" varchar(25),
	Admission varchar(25),
	"Discharge Date" date,
	Medication varchar(50),
	"Test Results" varchar(50)
);

--- Copy Data from CSV to SQL
COPY healthcare FROM 'C:\Users\Aditi 732\Desktop\Aditi\Data Science\Healthcare Data Analysis - SQL , Python and Power BI\healthcare_dataset.csv' WITH CSV HEADER

SELECT * FROM healthcare;

--- Check if there are any null values
SELECT * FROM healthcare
WHERE name IS NULL; 
--- There are no null values present in the dataset

--- Change the data type of the columns
ALTER TABLE healthcare
ALTER COLUMN age TYPE INT USING age::integer;

ALTER TABLE healthcare
ALTER COLUMN "Room Number" TYPE INT USING "Room Number"::integer;

ALTER TABLE healthcare
ALTER COLUMN "Billing Amount" TYPE bigint USING "Billing Amount"::bigint;

--- DROP columns that are not necessary
ALTER TABLE healthcare
DROP COLUMN "Test Results";

SELECT * FROM healthcare;

--- Add columns that might be helpful
ALTER TABLE healthcare
ADD duration_days varchar(25);

UPDATE healthcare
SET duration_days = CAST(EXTRACT(EPOCH FROM age("Discharge Date","Date of Admission")) / 86400 AS BIGINT) ;

ALTER TABLE healthcare
ALTER COLUMN duration_days TYPE INTEGER USING duration_days::int;

-- Exploratory Data Analysis 
--- To get a quick overview of numerical column Billing Amount
SELECT COUNT(*) , AVG("Billing Amount") , MAX("Billing Amount"), MIN("Billing Amount")
FROM healthcare;
--- The average a person spends on his treatment is $25,516

--- To get a quick overview of numerical column Billing Amount
SELECT COUNT(*) , AVG(age), MAX(age), MIN(age)
FROM healthcare;
--- The average age of person diagnosed with a disease is 51 , The maximum age is 85 and the minimum age is 18.

--- What is the total billing amount for top 10 hospitals ?
SELECT SUM("Billing Amount") AS Total_Billing_Amount , hospital
FROM healthcare
GROUP BY hospital
ORDER BY Total_Billing_Amount DESC
LIMIT 10;
--- Smith and Sons have the highest billing amount of $477640 in total.

--- What are top insurance providers ?
SELECT COUNT(insurance) , insurance
FROM healthcare
GROUP BY insurance
ORDER BY COUNT(insurance) DESC
LIMIT 5;
--- The topmost insurance provider is Cigna followed by Blue Cross , Aetna , UnitedHealthcare and Medicare.

--- What is the average length of stay for different medical conditions?
SELECT AVG(duration_days) AS avg_length_stay
FROM healthcare
GROUP BY "Medical Condition"
ORDER BY avg_length_stay DESC;

--- What are the most commonly prescribed medications for Diabetes ?
SELECT medication, COUNT(*) AS medication_count
FROM healthcare
WHERE "Medical Condition" = 'Diabetes'
GROUP BY medication
ORDER BY medication_count DESC;
--- The most common medication for Diabetes is Aspirin

--- Which doctors have the highest patient load ?
SELECT doctor , COUNT(*) as number_of_patients
FROM healthcare 
GROUP BY doctor
ORDER BY number_of_patients DESC
LIMIT 5;
--- Dr. Michael Johnson is the doctor with the highest patient load that is 7 patients

--- Which medical condition generated the highest billing amount for both male and female patients ?
SELECT * FROM healthcare;

SELECT "Medical Condition", MAX("Billing Amount") AS max_billing_amount
FROM healthcare
WHERE gender = 'Male'
GROUP BY "Medical Condition"
ORDER BY max_billing_amount DESC;
--- The medical condition which generated the highest billing amount for Men is Hypertension

SELECT "Medical Condition", MAX("Billing Amount") AS max_billing_amount
FROM healthcare
WHERE gender = 'Female'
GROUP BY "Medical Condition"
ORDER BY max_billing_amount DESC;
--- The medical condition which generated the highest billing amount for Women is Arthritis.
