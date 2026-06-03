--TABLE 1
CREATE TABLE Customers (
    customer_id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(100),
    age INTEGER,
    gender VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    signup_date DATE,
    phone_number VARCHAR(15));

ALTER TABLE customers
RENAME COLUMN phone_number TO prime_member;

select * from Customers

--TABLE 2
CREATE TABLE order_details(
OrderID VARCHAR(100),
ProductID VARCHAR(100),
Quantity INTEGER,
Unitprice INTEGER,
Discount INTEGER
);

ALTER TABLE order_details
RENAME COLUMN "orderid" TO order_id;

ALTER TABLE order_details
RENAME COLUMN "productid" TO product_id;

select * from order_details

--TABLE 3
CREATE TABLE orders (
    order_id VARCHAR(100),
    customer_id VARCHAR(36),
    order_date DATE,
    order_amount NUMERIC(10,2),
    delivery_fee NUMERIC(10,2),
    discount_applied NUMERIC(10,2)
);
select * from orders

--TABLE 4
CREATE TABLE products (
    product_id VARCHAR(100),
    product_name VARCHAR(150),
    category VARCHAR(50),
    sub_category VARCHAR(50),
    price_per_unit NUMERIC(10,2),
    stock_quantity INTEGER,
    supplier_id VARCHAR(100)
);

ALTER TABLE products
RENAME COLUMN supplier_id TO supplierid;

select * from products

--TABLE 5
CREATE TABLE reviews (
    review_id VARCHAR(100),
    product_id VARCHAR(100),
    customer_id VARCHAR(36),
    rating INTEGER,
    review_text TEXT);
select * from reviews --Gave text for review text because text allows long reviews

--TABLE 6
CREATE TABLE suppliers (
    supplier_id VARCHAR(100),
    supplier_name VARCHAR(150),
    contact_person VARCHAR(100),
    phone VARCHAR(15),
    city VARCHAR(50),
    state VARCHAR(50)
);
 
ALTER TABLE suppliers
ALTER COLUMN phone TYPE VARCHAR(25);

select * from suppliers

ALTER TABLE suppliers
ADD PRIMARY KEY (supplier_id);

ALTER TABLE products
ADD PRIMARY KEY (product_id);

ALTER TABLE orders
ADD PRIMARY KEY (order_id);

ALTER TABLE reviews
ADD PRIMARY KEY (review_id);

ALTER TABLE orders --Altering the Table called Orders
ADD CONSTRAINT fk_orders_customer --Adding a rule that iam adding a constraint,fk_orders_customer is just a name i give(naming-optional)
FOREIGN KEY (customer_id)-- adding customer_id as the foreign key 
REFERENCES customers(customer_id); --which should match the customer_id of customers table

ALTER TABLE products
ADD CONSTRAINT fk_products_supplier
FOREIGN KEY (supplier_id)
REFERENCES suppliers(supplier_id);--  threw error Key (supplier_id)=(0658c953-98c4-4d00-bf29-4fbfe4aca4cd) is not present in table "suppliers" 

ALTER TABLE order_details
ADD CONSTRAINT fk_orderdetails_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE order_details
ADD CONSTRAINT fk_orderdetails_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);

ALTER TABLE reviews
ADD CONSTRAINT fk_review_customer
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE reviews
ADD CONSTRAINT fk_reviews_product
FOREIGN KEY (product_id)
REFERENCES products(product_id);
------------------------------------------------------------------------------------------------

--Task 3: Write a query to Retrieve all customers from a specific city.
select * from Customers
select * from customers where city ='West Daniel';

--Task 3: Write a query to Fetch all products under the "Fruits" category.
select * from products
select * from products where category='Fruits';
-------------------------------------------------------------------------------------------------

--Task 4: Write DDL statements to recreate the Customers table with the following constraints:
--CustomerID as the primary key.(Already done while creating customers table)
--Ensure Age cannot be null and must be greater than 18.

select * from customers
CREATE TABLE customers_2 (
    customer_id VARCHAR(100) PRIMARY KEY,
    name VARCHAR(100),
    age INTEGER,
    gender VARCHAR(10),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50),
    signup_date DATE,
    prime_nember VARCHAR(15));

ALTER TABLE customers_2
ALTER COLUMN age SET NOT NULL;

ALTER TABLE customers_2
ADD CONSTRAINT chk_customers2_age
CHECK (age > 18);

ALTER TABLE customers_2
ADD CONSTRAINT uq_customers2_name
UNIQUE (name);

select * from customers_2

------------------------------------------------------------------------------------------------
--Data Manipulation Language (DML)
--Task 5: Insert 3 new rows into the Products table using INSERT statements.
select * from products

insert into products(product_id, product_name, category, sub_category, price_per_unit, stock_quantity)
values(123, 'Not_Fruit', 'Fruits','Sub-Fruits-4', 550.00, 12),
(132, 'Community_dair', 'Dairy', 'Sub-Dairy-2', 30.00, 111),
 (192, 'Mrs_Vegetables', 'Vegetables', 'Sub-Vegatables-1', 90.00, 300);
------------------------------------------------------------------------------------------------

--Task 6: Update the stock quantity of a product where ProductID matches a specific ID.
UPDATE products
SET stock_quantity= 2000
where product_id='123';--changed the stock of the new product_id i created above from 12 to 2000
------------------------------------------------------------------------------------------------

--Task 7: Delete a supplier from the Suppliers table where their city matches a specific value.
select * from suppliers

DELETE FROM suppliers WHERE city = 'West Linda';
------------------------------------------------------------------------------------------------

--Task 8: Use SQL constraints to:
--Add a CHECK constraint to ensure that ratings in the Reviews table are between 1 and 5.
alter table reviews
add constraint chk_rating_range
check (rating between 1 and 5);

--Add a DEFAULT constraint for the PrimeMember column in the Customers table (default value: "No")
alter table customers
alter column prime_member set default 'NO';
-------------------------------------------------------------------------------------------------

--Clauses and Aggregations
--Task 9: Write queries using:
--WHERE clause to find orders placed after 2024-01-01.
 select * from orders where order_date > '2024-01-01';

--HAVING clause to list products with average ratings greater than 4
select * from reviews
select product_id, avg(rating) as AVG_rating
from reviews
group by product_id
having avg(rating)>4;

--GROUP BY and ORDER BY clauses to rank products by total sales

select product_id, sum(quantity * (unitprice - discount)) as total_sales
from order_details
group by product_id
order by total_sales desc
limit 5;  -- top 5 high sales value products

select product_id, sum(quantity * (unitprice - discount)) as total_sales
from order_details
group by product_id
order by total_sales
limit 5;--LEAST SALES VALUE PRODUCTS
---------------------------------------------------------------------------------------
--Task 10: Identifying High-Value Customers
--Scenario:Amazon Fresh wants to identify top customers based on their total spending.
--Calculate each customer's total spending.
--Rank customers based on their spending.
--Identify customers who have spent more than ₹5,000.

select customer_id, sum(order_amount) as total_spending
from orders
group by customer_id
having sum(order_amount) > 5000
order by total_spending desc;
-- all the above conditions are applied in same query
------------------------------------------------------------------------------------------

--Complex Aggregations and Joins
--Task 11: Use SQL to:
--Join the Orders and OrderDetails tables to calculate total revenue per order.
SELECT * FROM orders
SELECT * FROM order_details

select 
    o.order_id, sum(od.quantity * (od.unitprice - od.discount)) as total_revenue
from orders o
join order_details od
    on o.order_id = od.order_id
group by o.order_id, o.customer_id
order by total_revenue desc;

--Identify customers who placed the most orders in a specific time period.
SELECT*FROM orders;
select customer_id, count(*) as total_orders
from orders
where order_date = '2025-01-01' --just for task. there was only one date in all the records so date filter is not acquired
group by customer_id
order by total_orders desc

--Find the supplier with the most products in stock.
select * from suppliers
select * from products

select 
  "SupplierID",
  count(*) as total_products
from products
group by "SupplierID"
order by total_products desc;
-- from this can conclude that each supplier is selling only 1 product
select
  "SupplierID",
  product_name,
  stock_quantity
from products
order by stock_quantity desc
limit 1;-- as each supplier is selling only 1 product the product with high stock quantity is the outpu
---------------------------------------------------------------------------------------------

--Normalization
--Task 12: Normalize the Products table to 3NF:
-- Separate product categories and subcategories into a new table.
--Create foreign keys to maintain relationships.

create table categories
(category_id serial primary key,
category varchar(50),
subcategory varchar(50));

alter table categories
rename subcategory to sub_category;

insert into categories(category,sub_category)
select distinct category,sub_category
from products;--Insert unique category & sub_category values from products into categories table

alter table products
add column category_id int;--Adding category column to products table

update products p
set category_id = c.category_id
from categories c
where p.category = c.category
and p.sub_category = c.sub_category;--copying category_id number from categories table matching equivalent cat+sub_cat

alter table products
add constraint fk_products_catgories
foreign key (category_id)
references categories (category_id);--making connection with foreign key

alter table products
drop column category,
drop column sub_category;--deleting old cat & sub_cat columns from products

select * from products
select * from categories
-----------------------------------------------------------------------------------------------
--Subqueries and Nested Queries
--Task 13: Write a subquery to:
--Identify the top 3 products based on sales revenue.
select * from products
select * from order_details

select od.product_id, p.product_name, sum((od.quantity * od.unitprice) - od.discount) as sales_revenue
from order_details od
join products p
on od.product_id = p.product_id
group by od.product_id, p.product_name
order by sum((od.quantity * od.unitprice) - od.discount) desc
limit 3;

select p.product_id, p.product_name, od.sales_revenue
from products p
join 
(
    select product_id, sum((quantity * unitprice) - discount) as sales_revenue
    from order_details
    group by product_id
    order by sales_revenue desc
    limit 3
) od
on p.product_id = od.product_id;

--Find customers who haven’t placed any orders yet.
select * from customers
select * from orders

select customer_id,name
from customers
where customer_id not in 
(
    select customer_id
    from orders
);--Customers whose customer_id does NOT appear at all in the orders table

--non task : To find customer names whose order amount is greater than 8000
select c.customer_id, c.name, o.order_amount from customers c
join
(select customer_id, order_amount 
from orders
where order_amount> 8000 
group by customer_id, order_amount) o 
on c.customer_id=o.customer_id;

---------------------------------------------------------------------------------------
--Task 14: Provide actionable insights:
--Which cities have the highest concentration of Prime members?
select city, count(*) as prime_members
from customers
where prime_member = 'Yes'
group by city
order by prime_members desc
limit 20;

--What are the top 3 most frequently ordered categories?

select
    c.category,
    count(*) as order_count
from order_details od
join products p on od.product_id = p.product_id
join categories c on p.category_id = c.category_id
group by c.category
order by order_count desc
limit 3;










