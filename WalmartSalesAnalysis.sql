#------------------------------------------------------------------------------------------------------------------------------------------
/*------------------------------------------------------------------------Feature Engineering--------------------------------------------*/

# Add Time_Of_day column
SELECT time, ( CASE 
						WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
                        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
                        ELSE "Evening"
                        END) AS Time_Of_Day
FROM Walmart_sales;                       

ALTER TABLE walmart_sales ADD COLUMN Time_Of_Day VARCHAR (10);
UPDATE walmart_sales
SET Time_Of_Day = (CASE 
						WHEN time BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
                        WHEN time BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
                        ELSE "Evening"
                        END);
 
#Add DAYNAME column
ALTER TABLE walmart_sales ADD COLUMN Day_name VARCHAR (10);
UPDATE walmart_sales
SET Day_name = dayname(Date);

#Add MONTH_NAME column
 ALTER TABLE walmart_sales ADD COLUMN Month_name VARCHAR (10);
UPDATE walmart_sales
SET Month_name = monthname(Date);
/*------------------------------------------------------------------------Generic Question------------------------------------------------*/
#1.	How many unique cities does the data have?
SELECT COUNT( DISTINCT city)
FROM walmart_sales;

#2.	In which city is each branch?
SELECT City, Branch
FROM walmart_sales 
GROUP BY 1, 2;

/*--------------------------------------------------------------------Business Questions To Answer----------------------------------------*/
/*-----------------------------------------------------------------------------Product-----------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------*/
#1.	How many unique product lines does the data have?
SELECT COUNT(DISTINCT Product_line)
FROM walmart_sales ;

#2.	What is the most common payment method?
SELECT Payment, COUNT(Payment) AS MostCommon
FROM walmart_sales 
GROUP BY 1 ;

#3.	What is the most selling product line?
SELECT Product_line, COUNT(Product_line) AS Most_Selling
FROM walmart_sales
GROUP BY 1
ORDER BY 2 DESC;

#4.	What is the total revenue by month?
SELECT month_name, CAST(SUM(Total) AS UNSIGNED) AS Total_revenue
FROM walmart_sales
GROUP BY 1
ORDER BY 1 DESC;

#5.	What month had the largest COGS?
SELECT Month_Name, 
	   CAST(SUM(COGS) AS UNSIGNED) AS Total_Monthly_COGS
FROM walmart_sales
GROUP BY 1
ORDER BY 2 DESC ;

#6.	What product line had the largest revenue?
SELECT DISTINCT(Product_line), 
	   CAST(SUM(Total) AS UNSIGNED) AS Total_Revenue
FROM walmart_sales
GROUP BY 1
ORDER BY Total_Revenue DESC;

#7.	What is the city with the largest revenue?
SELECT DISTINCT(City), 
		CAST(SUM(Total) AS UNSIGNED) AS Total_Revenue
FROM walmart_sales
GROUP BY 1
ORDER BY Total_Revenue DESC;

#8.	What product line had the largest VAT?
SELECT Product_line , AVG(VAT) AS VAT  
FROM walmart_sales
GROUP BY 1
ORDER BY VAT DESC ;

#9.	Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
SELECT Product_line, AVG(COGS),
	CASE
		WHEN AVG(COGS) < AVG(Total) THEN 'Good'
        ELSE 'Bad'
		END AS AVERAGE_SALES
FROM walmart_sales        
GROUP BY 1;

#10.Which branch sold more products than average product sold?
SELECT Branch,
	CAST(SUM(Quantity) AS UNSIGNED) AS Quantity_Sold
FROM walmart_sales
GROUP BY 1
HAVING SUM(Quantity) > (SELECT CAST(AVG(Quantity) AS UNSIGNED) AS AVG_Products_sold
						  FROM walmart_sales);

#11.What is the most common product line by gender?
SELECT Gender, Product_line, COUNT(Gender)
FROM walmart_sales
GROUP BY 1, 2 ;
 
#12.What is the average rating of each product line?
SELECT Product_line, AVG(Rating)
FROM walmart_sales
GROUP BY 1
ORDER BY 2 DESC;

 
/*-------------------------------------------------------------------------------SALES-----------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------*/
#1.	Number of sales made in each time of the day per weekday
SELECT Time_Of_Day, Day_name, COUNT(Total) Number_Of_Sales
FROM walmart_sales
WHERE Day_name = "FRIDAY"
GROUP BY 1, 2;

#2.	Which of the customer types brings the most revenue?
SELECT Customer_type, CAST(SUM(Total) AS UNSIGNED) Most_revenue
FROM walmart_sales
GROUP BY 1
ORDER BY 2 DESC;

#3.	Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT DISTINCT(City), MAX(VAT)
FROM walmart_sales
GROUP BY 1
ORDER BY 2 DESC;


#4.	Which customer type pays the most in VAT?
 SELECT DISTINCT(Customer_type), MAX(VAT)
FROM walmart_sales
GROUP BY 1
ORDER BY 2 DESC;

 
/*------------------------------------------------------------------------------Customer---------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------*/

#What is the gender distribution per branch?
SELECT Branch, Gender, COUNT(Gender) CNT
FROM walmart_sales
GROUP BY 1, 2;

#Which time of the day do customers give most ratings?
SELECT Time_Of_Day, COUNT(Rating) CNT
FROM walmart_sales
GROUP BY 1 
ORDER BY 2 DESC;

#Which time of the day do customers give most ratings per branch?
SELECT Branch, Time_Of_Day, COUNT(Rating) CNT
FROM walmart_sales
GROUP BY 1, 2 
ORDER BY 3 DESC;

#Which day Of the week has the best avg ratings?
SELECT Branch, Time_Of_Day, AVG(Rating) Average_Rating
FROM walmart_sales
GROUP BY 1, 2 
ORDER BY 3 DESC;

#Which day of the week has the best average ratings per branch?
SELECT Branch, Time_Of_Day, CAST(AVG(Rating) AS UNSIGNED) Average_Rating
FROM walmart_sales
GROUP BY 1, 2 
ORDER BY 3 DESC;


