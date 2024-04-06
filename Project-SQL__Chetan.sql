USE [Project_SQL]
GO

select * from dbo.Customers_new
select * from dbo.Transactions_new
select * from dbo.prod_cat_info

============================================================================================================================================================================
                       ##DATA PREPARATION AND UNDERSTANDING##
============================================================================================================================================================================


#Q1. WHAT IS THE TOTAL NUMBER OF ROWS IN EACH OF THE 3 TABLES IN THE DATABASE ?

     Select Count(*) as Cust_rows from [dbo].[Customers_new]
     Select Count(*) as Prod_rows from [dbo].[prod_cat_info] 
     Select Count(*) as Tran_rows from [dbo].[Transactions_new]
	
	       #Ans#   -Customer_new table - 5647 rows
                   -Transactions_new table - 23053 rows
                   -prod_cat_info - 23 rows


=============================================================================================================================================================================


#Q2. WHAT IS THE TOTAL NUMBER OF TRANSACTIONS THAT HAVE A RETURN ?
  
     Select Count(*) from Transactions_new
     Where total_amt < 0;

	       #Ans# - Total numbers of transactions that have  returned = 2177.


=============================================================================================================================================================================


#Q4. WHAT IS THE TIME RANGE OF THE TRANSACTION DATA AVAILABLE FOR ANALYSIS ? SHOW THE OUTPUT IN NUMBER OF DAYS, MONTHS AND YEARS SIMULTANEOUSLY IN DIFFERENT COLUMNS.

     Select
     Datediff(day, min(tran_date), max(tran_date)) as total_days,
     Datediff(month, min(tran_date), max(tran_date)) as total_months,
     Datediff(year, min(tran_date), max(tran_date)) as total_years
     From Transactions_new

	       #Ans# - The time range of transaction data in Days - 1430
		           The time range of transaction data in Months - 47
				   The time range of transaction data in Years - 3


=============================================================================================================================================================================


#Q5. WHICH PRODUCT CATEGORY DOES THE SUB-CATEGORY "DIY" BELONG TO ?

     Select prod_subcat, prod_cat from [dbo].[prod_cat_info]
     Where prod_subcat ='DIY'


==============================================================================================================================================================================
==============================================================================================================================================================================
                        
						
						
==============================================================================================================================================================================		
						##DATA ANALYSIS##
==============================================================================================================================================================================



#Q1. WHICH CHANNEL IS MOST FREQUENTLY USED FOR TRANSACTION ?

     Select top 1 Count(*) as Most_Used, Store_type from Transactions_new
     Group by Store_type
     Order by Most_Used desc

	       #Ans# - Most frequently used for transaction ids 9311 in e-shop.


==============================================================================================================================================================================


#Q2. WHAT IS THE COUNT OF MALE AND FEMALE CUSTOMERS IN THE DATABASE ?

     Update [dbo].[Customers_new]
     Set gender = 'Unknown'
     Where gender = ' '
 
     Select top 2 (gender), count(gender) as Total_count from [dbo].[Customers_new]
     Group by gender
     Order by case when gender = 'M' then 1
     When gender = 'F' then 2
     Else 3
     End

	       #Ans# - Count of Male and Female customers are = Male-2892
		                                                   Female-2753


==============================================================================================================================================================================


#Q3. FROM WHICH CITY DO WE HAVE THE MAXIMUM NUMBER OF CUSTOMERS AND HOW MANY ?

     Select top 1 (city_code), count(city_code) as Count_city from [dbo].[Customers_new]
     Group by city_code
     Order by Count_city desc

	       #Ans# - Maximum number of customers are 595 customers from city_code 3.


==============================================================================================================================================================================


#Q4. HOW MANY SUB-CATEGORIES ARE THE UNDER THE BOOKS CATEGORY ?

     Select prod_cat, count(prod_subcat) as No_of_subcat  from [dbo].[prod_cat_info]
     Where prod_cat = 'Books'
     Group by prod_cat

     Select prod_cat, prod_subcat from [dbo].[prod_cat_info]
     Where prod_cat = 'Books'

	       #Ans# - There are 6 sub-categories under the books category.


==============================================================================================================================================================================


#Q5. WHAT IS THE MAXIMUM QUANTITY OF PRODUCTS EVER ORDERED ?


     Select top 1(tran_date), count(prod_cat) as No_of_products from [dbo].[Transactions_new] as T
     Inner join [dbo].[prod_cat_info] as P
     On T.prod_cat_code = P.prod_cat_code
     Group by tran_date
     Order by No_of_products desc

	       #Ans# - No.of maximum quantity of products - 153.


==============================================================================================================================================================================


#Q6. WHAT IS THE NET TOTAL REVENUE GENERATED IN CATEGORIES ELECTRONICS AND BOOKS ?

     Select sum(total_amt) as Total_amount from [dbo].[Transactions_new] as T
     Inner join [dbo].[prod_cat_info] as P
     On T.prod_subcat_code = P.prod_sub_cat_code
     Where prod_cat in ('Books','Electronics')

	       #Ans# - The net total revenue generated in categories electronic and books are 46645675.505.


==============================================================================================================================================================================


#Q7. HOW MANY CUSTOMERS HAVE >10 TRANSACTIONS WITH US, EXCLUDING RETURNS ?

     Select cust_id, COUNT(transaction_id) AS transaction_count FROM Transactions_new
     Where total_amt > 0
     Group by cust_id
     Having Count(transaction_id) > 10

	       #Ans# - Only 6 customers have >10 transactions with us.


==============================================================================================================================================================================


#Q8. WHAT IS THE COMBINED REVENUE EARNED FROM THE "ELECTRONICS" & "CLOTHINGS" CATEGORIES, FROM "FLAGSHIP STORES" ?


 
     Select sum(total_amt) as Total_Amount, store_type from [dbo].[Transactions_new] as T
     Inner join [dbo].[prod_cat_info] as P 
     On T. prod_subcat_code = P.prod_sub_cat_code
     Where prod_cat in ('Electronics','Clothing')
     Group by store_type having store_type = 'flagship store'

	      #Ans# - The combined revenue earned from the "Electronics" & "Clothings" from "Flagship Stores" is 8526843.00000001.


==============================================================================================================================================================================


#Q9. WHAT IS THE TOTAL REVENUE GENERATED FROM "MALE" CUSTOMERS IN  "ELECTRONICS" CATEGORY ? OUTPUT SHOULD DISPLAY TOTAL REVENUE BY PROD SUB.CAT.

     Select sum(total_amt) as Amount_ME from [dbo].[Transactions_new] as T
     Inner join [dbo].[Customers_new] as C
     On T.cust_id = C.customer_Id
     Inner join [dbo].[prod_cat_info] as P 
     On P.prod_sub_cat_code = T.prod_subcat_code
     Where gender = 'M' and prod_cat = 'Electronics'

     Select prod_subcat,sum(total_amt) as Amount_ME from [dbo].[Transactions_new] as T
     Inner join [dbo].[Customers_new] as C
     On T.cust_id = C.customer_Id
     Inner join [dbo].[prod_cat_info] as P 
     On P.prod_cat_code = T.prod_cat_code
     Where gender = 'M' and prod_cat = 'Electronics'
     Group by prod_subcat

	       #Ans# - The total revenue generated  from male customers in Electronics category is 10947130.025


===============================================================================================================================================================================


#Q10. WHAT IS PERCENTAGE OF SALES AND RETURNS BY PRODUCT SUB CATEGORY; DISPLAY ONLY TOP 5 SUB CATEGORIES IN TERMS OF SALES ?

      Select Top 5 (prod_subcat), Sum(total_amt) as Sales from Transactions_new t
      Inner join prod_cat_info p
      On t.prod_cat_code = p.prod_cat_code and t.prod_subcat_code = p.prod_sub_cat_code
      Where t.total_amt > 0
      Group by prod_subcat
      Order by Sales Desc

      With perABS 
      As(select top 5 (prod_subcat), 
      ABS(sum(case when Qty < 0 then Qty else 0 end)) as Returns, 
      Sum(case when Qty > 0 then Qty else 0 end) as Sales
	  From [dbo].[Transactions_new] as T
      Inner join [dbo].[prod_cat_info] as P
      On T.prod_cat_code = P.prod_cat_code
      Group by prod_subcat
      Order by Sales desc)
      Select prod_subcat,round(((Returns /(Returns + Sales))*100),2) as Return_percent,
      Round(((Sales /(Returns + Sales))*100),2) as Sales_percent from perABS

	        #Ans# - Top 5 categories in terms of sales are        sales percent //  return percent
			                                                Mens -    90.01            9.99
														  Womens -    90.01            9.99
														  Comics -    90.41            9.59
														Children -    90.41            9.59
 														Academic -    90.41            9.59

	                Total percentage of sales and returns in sub category =  Women	7020079.36499999
                                                                              Mens	6905869.88
                                                                              Kids	4806698.065
                                                                           Mobiles	2508648.35
                                                                           Fiction	2492900.995
		 

=========================================================================================================================================================================================================
					 

#Q11. FOR ALL CUSTOMERS AGED BETWEEN 25 TO 35 YEARS FIND WHAT IS THE NET TOTAL REVENUE GENERATED BY THESE CUSTOMERS IN LAST 30 DAYS OF TRANSACTION FROM MAX TRANSACTION DATE AVAILABLE IN THE DATA ?
      
      Select top 30 (tran_date) from [dbo].[Transactions_new]
      Group by tran_date
      Order by tran_date desc

      With ABC 
      As(select top 30 (tran_date), sum(total_amt) as Total_amount from [dbo].[Customers_new] as C
      Inner join [dbo].[Transactions_new] as T
      On T.cust_id = C.customer_id
      Where datediff(year,DOB,getdate()) between 25 and 35
      Group by tran_date
      Order by tran_date desc)
      Select sum(Total_amount) as Final_revenue from ABC

	        #Ans# - Net total revenue generated by customers in last 30 days = 211997.565


===========================================================================================================================================================================================================


#Q12. WHICH PRODUCT CATEGORY HAS SEEN THE MAX VALUE OF RETURNS IN THE LAST 3 MONTHS OF TRANSACTIONS ?


      Select prod_cat, count(Qty) as No_of_returns from Transactions_new t
      Inner join prod_cat_info p 
      On t.prod_cat_code = p.prod_cat_code
      Where total_amt < 0 and datediff(month, '2014-09-01',tran_date)=3
      Group by prod_cat
	  
	 -- product category having maximum vaku of returns in last three months
	  
      With ABC
      As(select prod_cat, transaction_id, total_amt
      From Transactions_new t
      Inner join prod_cat_info p
      On t.prod_cat_code = p.prod_cat_code
      Where total_amt < 0 and datediff(month, '2014-09-01',tran_date)=3)
      Select ABS(sum(total_amt)) as Return_amount_cat from ABC

	        #Ans# - Product category seen Max values of returns in last 3 months of transactions = Home and kitchen - no of returns 4
			                                                                                          return amount - 6152.64


================================================================================================================================================================================================																									  


#Q13. WHICH STORE-TYPE SELLS THE MAXIMUM PRODUCTS; BY VALUE OF SALES AMOUNT AND BY QUANTITY SOLD ?
      
      Select top 1(Store_type),count(Qty) as No_of_products,
      Sum(total_amt) as Amount from [dbo].[Transactions_new]
      Where total_amt > 0
      Group by Store_type
      Order by No_of_products desc
	  
	        #Ans# - e-Shop store type sells tha maximum products. no of products-8429, Amount-22185609.8749999


=================================================================================================================================================================================================


#Q14. WHAT ARE THE CATEGORIES FOR WHICH AVERAGE REVENUE IS ABOVE THE OVERALL AVERAGE.

      With CategoryAverage As (
      Select p.prod_cat, round(avg(total_amt), 2) as average_revenue, (select round(avg(total_amt), 2) from Transactions_new) as overall_average_revenue from Transactions_new t
      Join prod_cat_info p on t.prod_cat_code = p.prod_cat_code
      Group by p.prod_cat
      )
      Select prod_cat, average_revenue from CategoryAverage
      Where average_revenue > overall_average_revenue

	        #Ans# - The categories which are above the overall average = Books	2112.82
                                                                      Clothing	2111.87
                                                                   Electronics	2189.15


===================================================================================================================================================================================================


#Q15. FIND THE AVERAGE AND TOTAL REVENUE BY EACH SUBCATEGORY FOR THE CATEGORIES WHICH ARE AMONG TOP 5 CATEGORIES IN TERMS OF QUANTITY SOLD.

      Select top 5(prod_cat), count(Qty) as Quantity_Sold from Transactions_new t
      Inner join prod_cat_info p
      On t.prod_cat_code = t.prod_cat_code
      Where total_amt > 0
      Group by prod_cat
      Order by Quantity_Sold desc
      Select prod_cat, prod_subcat, round(sum(total_amt), 3) as Total_amount, round(avg(total_amt), 3) as Avg_amount from Transactions_new t
      Inner join prod_cat_info p
      On t.prod_cat_code = p.prod_cat_code
      Where total_amt > 0 AND prod_cat IN ('Books', 'Electronics', 'Home and kitchen', 'Footwear', 'Clothing')
      Group by prod_cat, prod_subcat
      Order by case when prod_cat = 'Books' then 1
      When prod_cat = 'Electronics' then 2
      When prod_cat = 'Home and kitchen' then 3
      When prod_cat = 'Footwear' then 4
      Else 5
      End

	        #Ans# - Top 5 categories in terms of quantity sold = Books	125256
                                                           Electronics	104380
                                                      Home and kitchen	83504
													          Footwear	62628
															  Clothing	62628


===================================================================================================================================================================================================================
===================================================================================================================================================================================================================
