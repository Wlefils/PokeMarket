--Creating a date dimension table to store various date-related attributes
CREATE TABLE date_dimension (
	date_key INT NOT NULL,
	date DATE NOT NULL,
	full_date_description VARCHAR(255),
	day_of_week VARCHAR(255),
	month VARCHAR(255),
	year INT
	PRIMARY KEY (date_key)
)

-- Creating a time dimension table to store different times of day
CREATE TABLE time_dimension (
	time_key INT NOT NULL,
	time_of_day VARCHAR(255)
	PRIMARY KEY (time_key)
	)

-- Creating a product dimension table to store detailed information about each card
CREATE TABLE product_dimension (
	product_key INT NOT NULL,
	card_set_no VARCHAR(10),
	card_set VARCHAR(255),
	card_name VARCHAR(255),
	pokemon_featured VARCHAR(255),
	card_type VARCHAR(25),
	card_rarity VARCHAR(15),
	card_finish VARCHAR(20),
	first_edition VARCHAR(3),
	card_condition VARCHAR(20),
	est_value DECIMAL(6,2)
	PRIMARY KEY (product_key)
)

-- Creating a listing dimension to store information about each eBay listing
CREATE TABLE list_dimension (
	listing_key INT NOT NULL,
	beg_date INT NOT NULL,
	beg_time INT NOT NULL,
	listing_type VARCHAR(255),
	listing_duration VARCHAR(255),
	page_views INT,
	bids INT,
	free_shipping VARCHAR(3),
	start_price DECIMAL(6,2),
	end_price DECIMAL(6,2)
	PRIMARY KEY (listing_key)
)

--Creating a customer dimension to store detailed info about each customer
CREATE TABLE customer_dimension (
	customer_key INT NOT NULL,
	customer_ID VARCHAR(255) NOT NULL,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	company_name VARCHAR(255),
	customer_city VARCHAR(255),
	customer_state VARCHAR(255)
	PRIMARY KEY (customer_key)
)


-- Creating a shipping dimension to store information about each shipment
CREATE TABLE shipping_dimension (
	shipping_key INT NOT NULL,
	shipping_type VARCHAR(255),
	handling_revenue DECIMAL(6,2),
	shipment_cost DECIMAL(6,2),
	net_shipping DECIMAL(6,2),
	shipping_status VARCHAR(255),
	tracking_no VARCHAR(255) NOT NULL
	PRIMARY KEY (shipping_key)
)

-- Creating an order dimension to store information about each order
CREATE TABLE order_dimension (
	order_key INT NOT NULL,
	order_no VARCHAR(255) NOT NULL
	PRIMARY KEY (order_key)
)

-- Creating an order fact table to store transaction data related to orders
CREATE TABLE order_fact (
	order_date INT NOT NULL,
	order_time INT NOT NULL,
	product_key INT NOT NULL,
	order_key INT NOT NULL,
	customer_key INT NOT NULL,
	listing_key INT NOT NULL,
	shipping_key INT NOT NULL,
	order_total DECIMAL(6,2),
	fees DECIMAL(6,2),
	net_proceeds DECIMAL(6,2)
)

-- Creating a bid fact table to store transactional data related to bids
CREATE TABLE bid_fact (
	listing_key INT NOT NULL,
	customer_key INT NOT NULL,
	bid_date INT NOT NULL,
	bid_time INT NOT NULL,
	winning_bid VARCHAR(3),
)

-- Adding foreign key constraints to the orer_fact table to ensure data integrity
-- Linking various keys in the order_fact table to their respective dimension tables
ALTER TABLE order_fact ADD CONSTRAINT order_fact_fk0 FOREIGN KEY (order_date) REFERENCES date_dimension(date_key);

ALTER TABLE order_fact ADD CONSTRAINT order_fact_fk1 FOREIGN KEY (order_time) REFERENCES time_dimension(time_key);

ALTER TABLE order_fact ADD CONSTRAINT order_fact_fk2 FOREIGN KEY (order_key) REFERENCES order_dimension(order_key);

ALTER TABLE order_fact ADD CONSTRAINT order_fact_fk3 FOREIGN KEY (product_key) REFERENCES product_dimension(product_key);

ALTER TABLE order_fact ADD CONSTRAINT order_fact_fk4 FOREIGN KEY (customer_key) REFERENCES customer_dimension(customer_key);

ALTER TABLE order_fact ADD CONSTRAINT order_fact_fk5 FOREIGN KEY (listing_key) REFERENCES list_dimension(listing_key);

ALTER TABLE order_fact ADD CONSTRAINT order_fact_fk6 FOREIGN KEY (shipping_key) REFERENCES shipping_dimension(shipping_key);

-- Adding foreign key constraints to the list_dimension and bid_fact tables
ALTER TABLE list_dimension ADD CONSTRAINT list_dimension_fk0 FOREIGN KEY (beg_date) REFERENCES date_dimension(date_key);

ALTER TABLE list_dimension ADD CONSTRAINT list_dimension_fk1 FOREIGN KEY (beg_time) REFERENCES time_dimension(time_Key);

ALTER TABLE bid_fact ADD CONSTRAINT bid_fact_fk0 FOREIGN KEY (listing_key) REFERENCES list_dimension(listing_key);

ALTER TABLE bid_fact ADD CONSTRAINT bid_fact_fk1 FOREIGN KEY (customer_key) REFERENCES customer_dimension(customer_key);

ALTER TABLE bid_fact ADD CONSTRAINT bid_fact_fk2 FOREIGN KEY (bid_date) REFERENCES date_dimension(date_key);

ALTER TABLE bid_fact ADD CONSTRAINT bid_fact_fk3 FOREIGN KEY (bid_time) REFERENCES time_dimension(time_key);

--Inserting relevant information for card sales that I added after I started this project
INSERT INTO list_dimension (listing_key, beg_date, beg_date, listing_type, listing_duration, page_views, bids, free_shipping, start_price, end_price)
VALUES ('22', '20220330', '36', 'Auction', '10 days', '11', '1', 'No', '4.99', '4.99'),
       ('23', '20220330', '36', 'Auction', '10 days', '28', '1', 'No', '3.99', '3.99');
INSERT INTO shipping_dimension (shipping_key, shipping_type, handling_revenue, shipment_cost, net_shipping, shipping_status, tracking_no)
VALUES ('22', 'eBay Standard Envelope', '', '', '', 'Shipped', ''),
	   ('23', 'eBay Standard Envelope', '', '', '', 'Shipped', '');

INSERT INTO order_dimension (order_key, order_no)
VALUES ('22', ''),
	   ('23', '');

INSERT INTO customer_dimension (customer_key, customer_ID, first_name, last_name, company_name, customer_city, customer_state)
VALUES	('21', '', '', '', '', '', ''),
	    ('22', '', '', '', '', '', '');

INSERT INTO product_dimension (product_key, card_set_no, card_set, card_name, pokemon_featured, card_type, card_rarity, card_finish, first_edition, card_condition, est_value)
VALUES ('389', '28/62', 'Fossil', 'Muk', 'Muk', 'Pokemon', 'Rare', 'Regular', 'Yes', 'Lightly Played', '3.50');

INSERT INTO order_fact (order_date, order_time, product_key, order_key, customer_key, listing_key, shipping_key, order_total, fees, net_proceeds)
VALUES	('20220409', '', '153', '22', '21', '22', '22', '', '', ''),
        ('20220409', '', '389', '23', '22', '23', '23', '', '', '');


SELECT dd.DATE,
	od.order_no,
	cd.customer_id,
	pd.card_name,
	pd.est_value,
	ofs.order_total,
	ofs.net_proceeds,
	ld.listing_type
FROM order_fact AS ofs
JOIN date_dimension AS dd
	ON dd.date_key = ofs.order_date
JOIN time_dimension AS td
	ON td.time_key = ofs.order_time
JOIN product_dimension AS pd
	ON pd.product_key = ofs.product_key
JOIN customer_dimension AS cd
	ON cd.customer_key = ofs.customer_key
JOIN list_dimension AS ld
	ON ld.listing_key = ofs.listing_key
JOIN shipping_dimension AS sd
	ON sd.shipping_key = ofs.shipping_key
JOIN order_dimension AS od
	ON od.order_key = ofs.order_key;


--1. --First, let's take a look at how many cards I've sold and my net income from selling cards so far.
SELECT COUNT(od.order_no) AS cards_sold,
	SUM(ofs.net_proceeds) AS net_income
FROM order_fact AS ofs
JOIN order_dimension AS od
	ON od.order_key = ofs.order_key;

--1a.Let's take a closer look at the income each card has generated, ranked in descending order.
SELECT pd.card_set,
	pd.card_name,
	ofs.net_proceeds,
	DENSE_RANK() OVER (
		ORDER BY ofs.net_proceeds DESC
		) AS rank
FROM order_fact AS ofs
JOIN product_dimension AS pd
	ON pd.product_key = ofs.product_key;

--2.I'm also curious as to each card's contribution to the overall net income as a percentage.
WITH nip AS (
	SELECT pd.card_set, pd.card_name,
		net_proceeds,
		net_proceeds * 100.0 / (SUM(ofs.net_proceeds) OVER ()) AS net_income_percentage
	FROM order_fact AS ofs
	JOIN product_dimension AS pd
		ON ofs.product_key = pd.product_key
	)
SELECT card_set, card_name,
	net_proceeds,
	CAST((net_income_percentage) AS DECIMAL(4, 2)) AS net_income_pct,  DENSE_RANK() OVER (
		ORDER BY net_income_percentage DESC
		) AS rank
FROM nip
ORDER BY net_income_pct DESC;


--Let's compare the estimated value to the actual net proceeds and rank on that metric
WITH pvd AS (
	SELECT pd.card_set,
		pd.card_name,
		(ofs.net_proceeds - pd.est_value) AS proceeds_value_diff
	FROM order_fact AS ofs
	JOIN product_dimension AS pd
		ON ofs.product_key = pd.product_key
	)
SELECT card_set,
	card_name,
	proceeds_value_diff,
	DENSE_RANK() OVER (
		ORDER BY proceeds_value_diff DESC
		) AS rank
FROM pvd;
--We can see that I earned more than the estimated value on 7/26 cards sold, and lower than the estimated value on 19/26 cards sold. 

SELECT pd.product_key, pd.card_set,
	pd.card_name,
	ofs.net_proceeds,
	pd.est_value,
		(ofs.net_proceeds - pd.est_value) AS proceeds_value_diff
FROM order_fact AS ofs
JOIN product_dimension AS pd
	ON pd.product_key = ofs.product_key;


--3.Let's break it down by the set each card belongs to.
SELECT pd.card_set,
	COUNT(ofs.order_key) AS no_of_cards,
	CAST(AVG(net_proceeds) AS DECIMAL(4, 2)) AS set_avg_income,
	SUM(ofs.net_proceeds) AS set_net
FROM order_fact AS ofs
JOIN product_dimension AS pd
	ON ofs.product_key = pd.product_key
GROUP BY pd.card_set
ORDER BY SUM(net_proceeds) DESC;

--4.Taking a look at the estimated value of each set - from my entire collection, rather than only cards sold.
SELECT pd.card_set,
	COUNT(pd.product_key) AS no_of_cards,
	CAST(AVG(pd.est_value) AS DECIMAL(6, 2)) AS set_avg_value,
	SUM(pd.est_value) AS set_est_value
FROM product_dimension AS pd
GROUP BY pd.card_set
ORDER BY SUM(pd.est_value) DESC;

SELECT pd.card_set, pd.card_name,
	COUNT(pd.product_key) AS no_of_cards,
	CAST(AVG(pd.est_value) AS DECIMAL(6, 2)) AS set_avg_value,
	SUM(pd.est_value) AS set_est_value
FROM product_dimension AS pd
GROUP BY pd.product_key
ORDER BY SUM(pd.est_value) DESC;


SELECT pd.card_set, pd.card_set_no, pd.card_name, pd.card_finish, pd.first_edition, pd.card_rarity, pd.card_condition, pd.card_type, pd.pokemon_featured, pd.est_value
FROM product_dimension AS pd


--Uh oh! Looks like some cards were input with an improper set name; 'Team Rocket Returns EX' and 'EX Team Rocket Returns' refer to the same set. Looks like this only affected cards in my collection, not any that were sold. The correct set name is the latter one. Let's fix that before going further. 
--First I'll write a SELECT statement to ensure I'm looking at the right data.

SELECT *
FROM product_dimension
WHERE card_set = 'Team Rocket Returns EX';

--And here's the UPDATE statement:
UPDATE product_dimension
SET card_set = 'EX Team Rocket Returns'
WHERE card_set = 'Team Rocket Returns EX';

--4.a-Back to our previous query, but this time let's only include sets with a sample size of >= 20 cards.
SELECT pd.card_set,
	COUNT(pd.product_key) AS no_of_cards,
	CAST(AVG(pd.est_value) AS DECIMAL(6, 2)) AS set_avg_value,
	SUM(pd.est_value) AS set_est_value
FROM product_dimension AS pd
GROUP BY pd.card_set
HAVING COUNT(pd.product_key) >= 20
ORDER BY SUM(pd.est_value) DESC;
--What this tells me is that the cards in my collection do vary significantly in value depending on which set they're from. This doesn't mean that cards from e.g. Legendary Collection
--are generally more valuable than those from Gym Heroes, only that the specific cards in my collection that are more valuable happen to be from those sets.


--Let's include some additional details on our cards to see if paints a clearer picture on why certain sets seem to be worth more than others. I'll use the CUBE function to provide group level totals of all combinations sets, finishes, rarities, and conditions. The commented WHERE clause allows us to see the valuation of Trainer and Energy-type cards without placing them in the CUBE function. These types of cards are worth much less than Pokemon-type cards.
SELECT COALESCE(card_set, 'All sets') AS card_set,
	COALESCE(card_finish, 'All finishes') AS card_finish,
	COALESCE(card_rarity, 'All rarities') AS card_rarity,
	COALESCE(card_condition, 'All conditions') AS card_condition,
	COUNT(*) AS no_of_cards,
	CAST(AVG(pd.est_value) AS DECIMAL(6, 2)) AS avg_value,
	SUM(pd.est_value) AS sum_est_value
FROM product_dimension AS pd
--WHERE card_type IN ('Energy', 'Trainer')
--WHERE card_finish NOT LIKE '%Holo%'
GROUP BY CUBE(card_set, card_finish, card_rarity, card_condition)
ORDER BY sum_est_value DESC;

--It appears that Holo and Reverse Holo cards are significantly more valuable than cards with other finishes. The condition and rarity don't appear to be as significant. There's a lot to parse here, so let's narrow it down: we'll just look at the set differences in terms of number of holo/reverse holo cards and see how that affects the valuation.

DECLARE @TotalVal AS DECIMAL(8,4)
SET @TotalVal = 916.18

SELECT COALESCE(card_set, 'All sets') AS card_set,
	COALESCE(card_finish, 'Total Holos') AS card_finish,
	COUNT(*) AS no_of_cards,
	CAST(AVG(pd.est_value) AS DECIMAL(6, 2)) AS avg_value,
	SUM(pd.est_value) AS sum_est_value,
	CAST((SUM(pd.est_value / @TotalVal) * 100) AS DECIMAL(4, 2)) AS pct_of_total_value
FROM product_dimension AS pd
WHERE card_finish IN (
		'Holo',
		'Reverse Holo'
		)
GROUP BY CUBE(card_set, card_finish)
ORDER BY card_set,
	card_finish,
	sum_est_value DESC;

--This tells me that I have 27 Holo or Reverse Holo cards in my collection (23 Holo and 4 Reverse Holo). The valuation of all the Holo cards is 628.33 - more than 2/3rds the value of my
--entire collection. Thus, what makes the card sets appear to be more valuable is largely the number of Holo cards I possess from any given set.


--This is a breakdown of all cards in my collection into multiple group-level totals by set, finish, rarity, and condition.
SELECT COALESCE(card_set, 'All sets') AS card_set,
	COALESCE(card_finish, 'All finishes') AS card_finish,
	COALESCE(card_rarity, 'All rarities') AS card_rarity,
	COALESCE(card_condition, 'All conditions') AS card_condition,
	COALESCE(card_type, 'All types') AS card_type,
	COUNT(*) AS no_of_cards
FROM product_dimension AS pd
--WHERE card_finish IN ('Holo', 'Reverse Holo') OR card_rarity LIKE 'Rare' AND card_condition = 'Near Mint'
GROUP BY ROLLUP(card_set, card_finish, card_rarity, card_condition, card_type)
ORDER BY card_set,
	card_rarity,
	card_finish,
	card_condition,
	card_type,
	no_of_cards;

--Let's examine some listing information. I'll CREATE a VIEW so I can do many queries off of it without repeating all the joins necessary to access the information.
--trying to make a view here
CREATE VIEW list_info AS
	SELECT pd.card_set,
	pd.card_name,
	pd.card_finish,
	pd.card_rarity,
	pd.card_type,
	pd.first_edition,
	pd.pokemon_featured,
	dd2.DATE AS list_date,
	td2.time_of_day AS list_time,
	dd.DATE AS order_date,
	td.time_of_day AS order_time,
	LEFT(dd2.day_of_week, CHARINDEX(',', dd2.day_of_week + ',') - 1) AS list_dow,
	LEFT(dd.day_of_week, CHARINDEX(',', dd.day_of_week + ',') - 1) AS order_dow,
	ld.bids,
	ld.page_views,
	ld.free_shipping,
	ld.listing_type,
	ld.start_price,
	ld.end_price,
	ld.listing_duration
FROM order_fact AS ofs
JOIN product_dimension AS pd
	ON ofs.product_key = pd.product_key
JOIN date_dimension AS dd
	ON ofs.order_date = dd.date_key
JOIN time_dimension AS td
	ON ofs.order_time = td.time_key
JOIN list_dimension AS ld
	ON ld.listing_key = ofs.listing_key
JOIN date_dimension AS dd2
	ON ld.beg_date = dd2.date_key
JOIN time_dimension AS td2
	ON ld.beg_time = td2.time_key
JOIN shipping_dimension AS sd
	ON ofs.shipping_key = sd.shipping_key
JOIN order_dimension AS od
	ON ofs.order_key = od.order_key;

---Let's make sure it worked.
SELECT *
FROM list_info;
--Great!

--There's a lot in there. Let's use a CTE to find out how the day of the week a card was listed related to its page views.
WITH listing_info AS (
SELECT
	pd.card_set, pd.card_name, dd2.date as list_date, td2.time_of_day as list_time, dd.date as order_date, td.time_of_day as order_time, LEFT(dd2.day_of_week, CHARINDEX(',', dd2.day_of_week+',')-1) as list_dow, LEFT(dd.day_of_week, CHARINDEX(',', dd.day_of_week+',')-1) as order_dow, ld.bids, ld.page_views, ld.free_shipping, ld.listing_type,
	ld.start_price, ld.end_price, ld.listing_duration
	FROM order_fact as ofs
		JOIN
	date_dimension as dd
		ON ofs.order_date = dd.date_key
		JOIN
	time_dimension as td
		ON ofs.order_time = td.time_key
		JOIN
	list_dimension as ld
		ON ld.listing_key = ofs.listing_key
		JOIN
	date_dimension as dd2
			ON ld.beg_date = dd2.date_key
		JOIN
	time_dimension as td2
			ON ld.beg_time = td2.time_key
			JOIN
	shipping_dimension as sd
	ON ofs.shipping_key = sd.shipping_key
		JOIN
	order_dimension as od
		ON ofs.order_key = od.order_key
		JOIN product_dimension as pd
			ON pd.product_key = ofs.product_key 
		)

SELECT *
FROM listing_info
WHERE list_dow = 'Tuesday';


--First, let's find out how the day of the week on which a card was listed related to its page views.
SELECT list_dow,
	COUNT(list_dow) AS no_of_listings,
	AVG(page_views) AS avg_page_views,
	SUM(page_views) AS sum_page_views
FROM list_info
GROUP BY list_dow
ORDER BY SUM(page_views) DESC;

--Cards listed on Wednesday received the highest overall page views, but they also comprised the vast majority of listing. When looking at average page views, Tuesday reigned supreme. But why is that? Let's see which cards were listed on Tuesday.

SELECT card_set, 
	card_name,
	count(*),
	sum(page_views), 
	list_dow
FROM list_info
WHERE list_dow LIKE 'Tuesday'
GROUP BY card_set, card_name, list_dow
ORDER BY SUM(page_views) DESC;
--The cards listed on Tuesday included some of my most viewed cards. I don't think it's likely to be related to the day of the week that they were listed on, however.

SELECT card_set, card_name, list_dow, sum(page_views) AS num_page_views
FROM list_info
GROUP BY card_set, card_name, page_views, list_dow
ORDER BY page_views DESC;


SELECT card_set, list_dow, SUM(page_views) AS num_page_views, AVG(page_views) AS avg_page_views, COUNT(*) as num_cards
FROM list_info
GROUP BY card_set, list_dow
ORDER BY SUM(page_views) DESC;

--Let's also take a look at what times of day bids were placed.
SELECT td.time_of_day AS bid_time, COUNT(td.time_of_day) as num_bids, SUM(COUNT(td.time_of_day)) OVER() AS total_bids
FROM 
order_fact as ofs
	JOIN bid_fact AS bf
		ON ofs.listing_key = bf.listing_key
	JOIN time_dimension AS td
		ON bf.bid_time = td.time_key
--WHERE winning_bid = 'Yes'
GROUP BY td.time_of_day
ORDER BY COUNT(td.time_of_day) DESC;

SELECT CONVERT(NVARCHAR, td.time_of_day, 8) AS bid_time, COUNT(td.time_of_day) AS num_bids, SUM(COUNT(td.time_of_day)) OVER() AS total_bids
FROM order_fact as ofs
	JOIN bid_fact as bf
		ON ofs.listing_key = bf.listing_key
	JOIN time_dimension AS td
		ON bf.bid_time = td.time_key
GROUP BY td.time_of_day
ORDER BY COUNT(td.time_of_day) DESC;


--Most bids were placed between 5:00PM and 9:00PM PST, with the plurality being between 5:30PM and 6:30PM, followed by 7:30PM-8:00PM. 
--This makes sense to me, as this timing captures after-work hours of all timezones in the United States, but before many adults go to sleep.
--On what days were these bids placed?

SELECT LEFT(dd.day_of_week, CHARINDEX(',', dd.day_of_week+',')-1) as bid_dow, COUNT(dd.day_of_week) as num_bids, SUM(COUNT(dd.day_of_week)) OVER() AS total_bids
FROM bid_fact AS bf
	JOIN date_dimension AS dd
		ON bf.bid_date = dd.date_key
--WHERE winning_bid = 'Yes'
GROUP BY LEFT(dd.day_of_week, CHARINDEX(',', dd.day_of_week+',')-1)
ORDER BY COUNT(dd.day_of_week) DESC;
--Friday and Saturday were particularly popular days for bidding. I received zero bids on Monday over the entire period.


SELECT SUM(page_views)
FROM list_dimension;


SELECT list_dow, COUNT(list_dow) as no_of_listings, avg(page_views) as avg_page_views, sum(page_views) as sum_page_views
FROM list_info
GROUP BY list_dow
ORDER BY sum(page_views) DESC;

--I never listed an item on Friday or Monday. Items listed on Tuesday received the highest average page views, while those listed on Wednesday earned the highest total page views. 
--I listed the majority of my items on Wednesday. Those listed on Tuesday received significantly more page views than those on Sunday despite more items being listed on Sunday.
--The sample size is too low to draw firm conclusions. However, we can also examine what days orders were placed, and compare that to our page views.

--The highest proportion of items were sold on a Wednesday. This is to be expected as most of my listings were 7 days auctions, i.e. they would begin and end on the weekday I listed them.
--As previously mentioned, most items were listed on Wednesday. However, as I never listed an item on Friday, 4 items being sold on a Friday is intriguing.


--Let's take a look at the customers who bid on my listings. I'd like to know their names (or usernames if their first/last are unavailable), city, state, how many times they bid, and
--how many items they won. (Note that these names have been altered so the customers remain anonymous)
WITH customer_info AS (
	SELECT cd.customer_ID,
		CONCAT (
			first_name,
			' ',
			last_name
			) AS name,
		customer_city AS city,
		customer_state AS STATE,
		COUNT(*) AS num_bids,
		COUNT(CASE 
				WHEN winning_bid = 'Yes'
					THEN 1
				END) AS num_orders
	FROM customer_dimension AS cd
	JOIN bid_fact AS bf
		ON bf.customer_key = cd.customer_key
	GROUP BY cd.customer_ID,
		CONCAT (
			first_name,
			' ',
			last_name
			),
		customer_city,
		customer_state
	)
SELECT CASE 
		WHEN name = ' '
			THEN customer_ID
		ELSE name
		END AS name,
	city,
	STATE,
	num_bids,
	num_orders
FROM customer_info
ORDER BY num_bids DESC;
--hocul_25 bid 5 times but never won a listing. Only three bidders have purchased more than one item.

--Let's see what states the bids are coming from!
SELECT customer_state AS state, COUNT(*) AS num_bids
FROM customer_dimension AS cd
	JOIN bid_fact AS bf
		ON bf.customer_key = cd.customer_key
GROUP BY customer_state
ORDER BY COUNT(*) DESC;

SELECT customer_city, customer_state AS state, COUNT(*) AS num_bids
FROM customer_dimension AS cd
	JOIN bid_fact AS bf
		ON bf.customer_key = cd.customer_key
GROUP BY customer_city, customer_state
ORDER BY COUNT(*) DESC;

--Most of the bids are being placed from the Eastern United States. Let's see at what times they were bidding!

SELECT * FROM(
	SELECT 
	td.time_of_day as bid_time,
	customer_state,
	COUNT(bid_time) as num_bids
FROM customer_dimension AS cd
	JOIN bid_fact AS bf
		ON bf.customer_key = cd.customer_key
	JOIN time_dimension as td
		ON bf.bid_time = td.time_key
GROUP BY td.time_of_day, customer_state
) t
ORDER BY num_bids DESC;

--I conclude that the best day and time to list Pokemon cards appears to be between 5:00 PM and 9:00 PM. Because Friday and Saturday seem to generate the most page views, it would be beneficial to ensure my listings are up during peak hours on those days. For a 10-day auction, listing on Wednesday or Thursday between 5:00 and 9:00 PM would make my auctions experience both peak days twice.
