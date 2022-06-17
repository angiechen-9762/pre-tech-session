/* 
For questions 1-10, use the Shipments table in the attached Excel file.
1.	How many shipments are in the dataset?
2.	Using the Shipments table, find out the minimum ship date (as min_ship_date), the maximum ship date (as max_ship_date), 
	and the average weight (as avg_weight).
3.	Provide the number of LTL shipments.
4.	Provide the number of unique origin zip codes.
5.	How many shipments are greater than 100 and less than 250 lbs?
6.	What is the average number of pallets per LTL shipments less than 500 lbs?
7.	We want to get an idea of how many shipments are sent each month. Use SQL to count the number of shipments by year-month. 
	Note that by year-month, we mean that May 2013 and May 2014 should be considered as different year-months. 
	The resulting table should show year-month and count, and order results by year-month.
8.	How many unique cities have shipments originating from them?
9.	What is the average shipment weight leaving each city? The resulting table should include origin city name and each city's 
	average weight. Limit results to those that have an average weight over 15000 pounds and sort the results in descending order by weight.
10.	Find the set of shipments that are shipping out of an origin with 'City' in the name (i.e., Johnson City, Salt Lake City, 
	Kansas City, etc.). Report ID number and origin city name.
    
For questions 11-15, use the Workers, Bonus, and Title tables in the attached Excel file.
11.	Write a SQL query to print the first name and title of the workers who are also managers.
12.	Write a SQL query to print the worker ID's who have had a bonus and the corresponding bonus values.
13.	Select the ID of workers who have had bonuses, the bonus date, bonus amount, and the title for each worker.
14.	Select full name (this means the result should return one column with the full name) and corresponding bonuses for workers 
	who received higher than average bonuses. 
15.	Write a SQL query to print first name, last name, title, and salary of workers who have the highest salary for each of the departments. 
*/



/*
1.	How many shipments are in the dataset?
*/
SELECT count(*) FROM shipments;

/* 
2.	Using the Shipments table, find out the minimum ship date (as min_ship_date), the maximum ship date (as max_ship_date), 
	and the average weight (as avg_weight). */
SELECT min(`Ship Date`) min_ship_date, 
	max(`Ship Date`) max_ship_date,
    avg(Weight)
FROM shipments;

/*
3.	Provide the number of LTL shipments.
*/
SELECT sum(Mode='LTL') FROM shipments; -- 4
SELECT count(*) FROM shipments WHERE Mode='LTL'; -- 2
SELECT sum(if(Mode='LTL',1,0)) FROM shipments; -- 3
SELECT count(if(Mode='LTL',Mode,null)) FROM shipments; -- 1
-- wrong ans:
SELECT count(Mode='LTL') FROM shipments; -- count: count all non-null values, wrong value is not null

/*
4.	Provide the number of unique origin zip codes.
*/
SELECT count(distinct `Origin Zip`) FROM shipments; 
SELECT `Origin Zip`, count(*) FROM shipments GROUP BY `Origin Zip`; 

/*
5.	How many shipments are greater than 100 and less than 250 lbs?
*/
SELECT count(*) FROM shipments WHERE Weight>100 and Weight<250;
SELECT count(*) FROM shipments WHERE Weight between 100 and 250; -- both sides included
SELECT sum(Weight>100 and Weight<250) FROM shipments;

/*
6.	What is the average number of pallets per LTL shipments less than 500 lbs?
*/
SELECT avg(pallets) FROM shipments WHERE Mode='LTL' and Weight<=500;

/*
7.	We want to get an idea of how many shipments are sent each month. Use SQL to count the number of shipments by year-month. 
	Note that by year-month, we mean that May 2013 and May 2014 should be considered as different year-months. 
    The resulting table should show year-month and count, and order results by year-month.
*/
SELECT date_format(`Ship Date`,'%Y-%m') yr_m, count(*) FROM shipments
GROUP BY yr_m
ORDER BY yr_m;

/*
8.	How many unique cities have shipments originating from them?
*/
SELECT count(distinct `Origin City`) FROM shipments;
SELECT `Origin City` FROM shipments GROUP BY `Origin City`; -- show exact cities

/*
9.	What is the average shipment weight leaving each city? The resulting table should include origin city name and each city's 
	average weight. Limit results to those that have an average weight over 15000 pounds and sort the results in descending order by weight.
*/
SELECT `Origin City`, avg(Weight) avg_w FROM shipments
GROUP BY `Origin City`
HAVING avg_w>15000
ORDER BY avg_w DESC;

/*
10.	Find the set of shipments that are shipping out of an origin with 'City' in the name (i.e., Johnson City, Salt Lake City, 
	Kansas City, etc.). Report ID number and origin city name.
*/
-- wrong question: destination city maybe?
SELECT `ID Number`, `Origin City`, `Destination City` FROM shipments WHERE `Destination City` like '%City%';
SELECT `ID Number`, `Origin City`, `Destination City` FROM shipments WHERE `Destination City` rlike '^.*City.*$';


/*
11.	Write a SQL query to print the first name and title of the workers who are also managers.
*/
SELECT First_Name, Worker_Title From workers w JOIN title t ON w.Worker_ID=t.Worker_Ref_ID AND Worker_Title='Manager';

/*
12.	Write a SQL query to print the worker ID's who have had a bonus and the corresponding bonus values.
*/
SELECT Worker_Ref_ID FROM bonus WHERE Worker_Ref_ID!='' AND Bonus_Amount!=0;

/*
13.	Select the ID of workers who have had bonuses, the bonus date, bonus amount, and the title for each worker.
*/
SELECT b.*, Worker_title FROM bonus b JOIN title t USING(Worker_Ref_ID);

/*
14.	Select full name (this means the result should return one column with the full name) and corresponding bonuses for workers 
	who received higher than average bonuses. 
*/
SELECT concat(First_Name,' ',Last_Name) Full_Name, Bonus_Amount 
FROM workers w JOIN bonus b ON w.Worker_ID=b.Worker_Ref_ID
WHERE Bonus_Amount > (SELECT avg(Bonus_Amount) FROM bonus);

/*
15.	Write a SQL query to print first name, last name, title, and salary of workers who have the highest salary for each of the departments.
*/
SELECT First_Name, Last_Name, Worker_Title, Salary
FROM workers w LEFT JOIN title t ON w.Worker_ID=t.Worker_Ref_ID
WHERE (Department, Salary) in (SELECT Department, max(Salary) FROM workers GROUP BY Department);

SELECT First_Name, Last_Name, Worker_Title, Salary
FROM workers w LEFT JOIN title t ON w.Worker_ID=t.Worker_Ref_ID
WHERE Salary = (SELECT max(Salary) FROM workers WHERE Department=w.Department GROUP BY Department);

SELECT First_Name, Last_Name, Worker_Title, Salary FROM
(SELECT First_Name, Last_Name, Worker_Title, Salary, RANK()OVER(PARTITION BY Department ORDER BY Salary DESC) rk FROM 
	workers w LEFT JOIN title t ON w.Worker_ID=t.Worker_Ref_ID) t
WHERE rk=1


