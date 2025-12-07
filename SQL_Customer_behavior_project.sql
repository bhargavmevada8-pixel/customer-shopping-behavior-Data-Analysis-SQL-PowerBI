CREATE TABLE Customers (
    Customer_id INT,
    customer_age INT,
    gender VARCHAR,
	age_group VARCHAR (50),
    Products VARCHAR,
    category VARCHAR,
    amount NUMERIC,
    state VARCHAR,
    size VARCHAR,
    color VARCHAR,
    season VARCHAR,
    rating NUMERIC,
    subscription_status VARCHAR,
    shipping_type VARCHAR,
    discount_applied VARCHAR,
    promo_code_used VARCHAR,
    previous_purchases INT,
    payment_method VARCHAR,
    frequency VARCHAR
);

select * from Customers;

--1.What is total revenue generetd by Male vs female customers.
	    SELECT gender, SUM(amount) As revenue 
		FROM Customers
		Group By gender;
	
--2.Which customer used a diffrent but still spent more than the average purchase amount?
	    select Customer_id, amount
		FROM Customers
	    Where discount_applied = 'Yes' And amount >= (Select AVG(amount) From Customers);
	
--3. Which are top 5 products with the highest average review rating?
	   select products, AVG(rating) AS avg_rating 
	   From Customers
	   Group By products
	   Order By avg(rating) DESC Limit 5;
	
--4. Compare the average purchase amounts between standerd and express shipping.
		select shipping_type,
		AVG(amount) As pur_amount
		From Customers
		Where shipping_type In ('Standard','Express')
		Group By shipping_type;
	
--5. Do subscribed customers spend more? compare average spent and total revenue between subscribers and non-subscriber.
		select subscription_status,
		Count(Customer_id) As total_customer,
		AVG(amount) As average_spent,
		SUM(amount) As total_revenue
		From Customers
		Group  By subscription_status
		Order By total_revenue, average_spent DESC;         -- subscribed customers ("Yes")
		
--6. find 5 products which have the highest percentage of purchase with discounts applied?
	   Select Products,
	   Round (100 * SUM(Case When discount_applied = 'Yes' Then 1 Else 0 End)/ Count(*), 2) As discount_rate
	   From Customers
	   Group By Products
	   Order By discount_rate DESC Limit 5;
	
--7. segment customer into new, returing and loyal based on their total 
-- number of previous purchases, and show the count of each segment.
	With customer_type As ( 
	   Select Customer_id, previous_purchases,
	   Case 
	       When previous_purchases = 1 Then 'New'
		   When previous_purchases Between 2 And 10 Then 'Returning'
	       Else 'loyal'
	       End As customer_segment
	From Customers
	)
	Select customer_segment, Count(*) As "Number of Customers"
	From Customer_type
	Group By customer_segment;
	
--8. Find top 3 most purchased products within each category?
	With item_counts As (
	Select category,
	Products,
	Count(customer_id) As total_orders,
	Row_Number() Over (partition By category 
	order By count(customer_id) DESC) As item_rank
	From Customers
	Group By category, Products
	) 
	Select item_rank, category, Products, total_orders
	From item_counts
	Where item_rank <= 3;
	
	
--9. Are customers who are repete buyers (more than 5 previous purchase) also likely to subscribe?
	    Select subscription_status,
		Count(Customer_id) As repeat_buyers
		From Customers
		Where previous_purchases >5
		Group By subscription_status;
	
--10. What is the revenue contribution of each age group?
	    Select age_group,
		SUM(amount) As total_revenue
	    From Customers
		Group By age_group
		Order By total_revenue DESC;




	

