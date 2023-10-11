## Executive Summary

When I found myself in between jobs and needing some extra cash, I recalled my previously long-forgotten collection of Pokémon cards. I remembered from childhood discussions that certain cards in my collection were worth significant sums, but I hadn’t examined the market prices for any trading cards in over a decade. At the same time, my passion for data analytics was growing, and I saw an opportunity to further hone my skills in SQL and data visualization, along with my then-nascent understanding of database design. Inspired by reading Kimball's _**The Data Warehouse Toolkit**_, I decided to design my own database according to the data warehousing principles outlined in the book using Microsoft SQL Server. After manually inputting and wrangling the data with SQL queries, I exported it to Excel and then to Tableau, where I visualized the data to find patterns and insights into the niche world of Pokémon card sales. **My findings indicate that there are important patterns in terms of time of day, day of the week, location, and specific card details that have significant impacts on KPIs related to eBay auctions**, specifically with regards to Pokémon cards. This dataset was ultimately too small to draw conclusions about card sales outside of my collection, but preliminary trends emerged that could be further investigated using a similar approach.

#### Technical Skills Used
* Excel
* Microsoft SQL Sever
* Tableau

### Key Findings

[Interactive Tableau Dashboard Here](https://public.tableau.com/views/PokemonCardsProject/CardDashboard?:language=en-US&:display_count=n&:origin=viz_share_link)

![image](https://github.com/Wlefils/PokeMarket/assets/98787088/5fb58470-0f71-4246-80b7-efb6f75121b3)

#### Geographical Insights
I found a pronounced geographical trend regarding bidding locations. No bids originated from the Northwestern United States, rather, bids were concentrated in the Eastern and Northeastern U.S. This is despite the fact that I live in California and offered international shipping as an option on all listings.
#### Temporal Patterns
Most bids were placed between 5:00PM and 8:30 PM PST. This correlates well with off-work hours for adults in the United States, particularly in the Eastern time zone (where it would be 8:00 PM to 11:30 PM). Additionally, Friday and Saturday were the most active bidding days, while none of my auctions received bids on Mondays.
#### Card Value Distribution
As expected, there is a large disparity in the market value of cards. While I owned hundreds of Common quality cards, selling them would rarely offset the associated shipping and/or selling costs. Collectors have a strong preference towards first edition, Rare, and holographic cards, particularly those in Mint or Near Mint condition. There was also considerable variation in the value of cards based on which Set they were a part of. A single card, my holographic Charizard from Base Set 2, generated significantly more earnings than any of my other cards (17% of total net proceeds out of 26 cards sold).
#### Profit Analysis
I was able to realize approximately 91% of the expected value per card. The 9% was eroded primarily by shipping fees and eBay’s percentage fee. This does not account for the 28% capital gains tax on collectibles, which would further erode profit margins.

## Project Report

### Data Collection and Management
![image](https://github.com/Wlefils/PokemonCardSales/assets/98787088/113015b4-7eb8-4830-8b39-63b83f42b19e)

The first step was to take stock of all the parameters involved in the project. I examined all of my cards and took note of the variables by which I could categorize them: the card set, their specific set number, the name of the card, which Pokémon was featured on the card, the type of card (e.g., Pokémon, Trainer, Energy, etc.), the card’s rarity, the finish (e.g., Holographic, Reverse Holographic, Regular), whether it was a first edition card, and what condition each card was in. Additionally, I wanted to have a ballpark estimate for what each card was worth. To do this, I browsed current eBay listings and sites like TCG Player (as seen in the above image) and averaged several recent sales prices for each card to estimate value. This process was a time-consuming endeavor, as I had to carefully look through every card in my collection and input the data into an Excel spreadsheet.

![image](https://github.com/Wlefils/PokemonCardSales/assets/98787088/e0543bc5-19e3-4f14-a38c-e9c2e32d4d84)


### Database Design 
I took the opportunity to implement industry standard practices in my database design and in my analysis. I used this Excel spreadsheet to model the SQL Server database where I would eventually store this data. The database was designed following a star schema (a central fact table surrounded by dimension tables). I felt the star schema seemed particularly apt for this project because it provides a balanced, efficient, and user-friendly structure.

![image](https://github.com/Wlefils/PokemonCardSales/assets/98787088/e07df4cd-661b-4553-89df-289b7560b335)

After designing this mock-up schema, the next step was to create the database Microsoft SQL Server according to the schema I designed. I wrote the following SQL queries to implement the tables:

```SQL
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

-- Creating the product_dimension table, which stores detailed attributes of each Pokémon card
-- such as its set, name, type, rarity, and estimated value.
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
```

I imported the initial card data into the database using the SQL Server Import Wizard:
![image](https://github.com/Wlefils/PokemonCardSales/assets/98787088/4d968ed5-246d-44be-94d3-47f27f0bbe28)

However, over the course of the project, there were additional cards and sales that needed to be input into the database. I used INSERT INTO queries to add this information to the relevant tables:
```SQL
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
```


### Exploratory Analysis
With all of the data input into the database, it was time to do some exploratory analysis. I wrote simple SQL queries to find important details such as the number of total cards sold, my net earnings from selling cards, ranking the income each card generated, and understanding each card's contribution to the overall net income. 
```SQL
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
```
As previously noted, **I sold 26 cards, resulting in a net income of $476.83.**
The screenshot below shows the output for the last SQL query, ranking the Top 10 cards sold by the percentage of total net income they contributed.

![image](https://github.com/Wlefils/PokemonCardSales/assets/98787088/50b4b208-4721-4e61-83f3-a8dbc37c8f71)

I continued to perform in-depth exploratory analysis, using SQL queries to explore many different aspects of the data. While performing some analysis related to card set valuation, I noticed I had made an error in my initial data input process. Some cards had been labelled with an improper set name; 'Team Rocket Returns EX' and 'Ex Team Rocket Returns' refer to the same set. I found that this error only affected cards that remained in my collection, not any that I had sold. The correct set name is the latter one. I fixed this error before proceeding further.

![image](https://github.com/Wlefils/PokemonCardSales/assets/98787088/f964117b-4508-43c5-962a-e5f1cc24d0c1)

```SQL
--First, I'll write a SELECT statement to ensure I'm looking at the right data.
SELECT *
FROM product_dimension
WHERE card_set = 'Team Rocket Returns EX';

--And here's the UPDATE statement to correct the error:
UPDATE product_dimension
SET card_set = 'EX Team Rocket Returns'
WHERE card_set = 'Team Rocket Returns EX';
```

For the sake of relative brevity, I won't include every query on this page. To view all of the queries I wrote for this project, please click [here](https://github.com/Wlefils/PokemonCardSales/blob/main/Pokemon%20Cards%20Database%20Queries.sql). I later used all the information retrieved by these queries to create my Tableau visualizations, which can be found [here](https://public.tableau.com/views/PokemonCardsProject/CardDashboard?:language=en-US&:display_count=n&:origin=viz_share_link).

### Data Visualization
After exploring and wrangling the data with SQL queries, I exported the most poignant results into Excel. I then imported these Excel files into Tableau to create visualizations. I wanted to understand the most important details in the data, and to figure out the best method to communicate my findings clearly and concisely.
The data I’d collected contained information across several dimensions: date, day of the week, time of day, customer location, page views of the listings, etc. What insights could I gain from this data? It started with thinking about what questions to ask. As an MBA student, my thought process was to consider the most important, relevant questions to my business strategy, and try to answer them. These were the initial questions I came up with:

* Where were my customers located?
* What day of the week and what time of day were my customers purchasing my cards?
* Do listings posted on different days of the week receive more page views?
* What cards generated the most net income?
* Are certain card sets worth more than others?
* How does my estimated value of each card correlate to the net proceeds I’m earning?

#### Customer Location
![image](https://github.com/Wlefils/PokemonCardSales/assets/98787088/e14aebf0-e1f3-4c93-a8e3-cad09634e42f)


As I had information about each bidder’s location, including both city and state, I was able to create a simple table containing the number of bids from each state. 
This table, while informative, doesn’t give a great sense of geographic location at a glance. I decided to visualize this data using a Tableau map visualization to better contextualize my customer’s locations relative to each other. This also made it very easy to quickly identify locations where I didn’t receive any bids, unlike the table.

![image](https://github.com/Wlefils/PokeMarket/assets/98787088/10ae47fa-da0c-42ec-bdf9-7f66b0076423)

This map demonstrates that the majority of bids were placed by customers in the North and particularly in the Northeastern United States. New Jersey stands out as having nearly 20% of the total number of bids, with Ohio and Florida also receiving several bids. Note that these bid counts do not represent unique bidders, therefore a bid war between two individuals would drive up the bid count for their respective locations quickly. While I did offer international shipping, I only received one bid from outside the United States, from Ontario. The combination of the table and the map sufficiently answered my first question: **my customers are located in the United States, primarily in the North and Northeastern region.**

#### Day of the Week and Time of Day
I was also quite curious about the temporal patterns regarding my Pokémon card auctions. I analyzed the day of the week and time of day for both bids and page views to try to see any apparent trends. The first aspect I examined here was the day of the week:


![image](https://github.com/Wlefils/PokeMarket/assets/98787088/76cfd0ae-b2aa-49f7-bab8-4990fb12cd64)


**Friday and Saturday alone accounted for nearly 57% of the total bids. I received 0 bids on Monday.** This information was quite surprising to me. I hypothesized that I would get the most bids on the days that I posted my auctions, as the listing would be new and attract more attention. However, I posted the majority of my listings on Wednesdays as 10-day auctions. This meant that most of my listings would be listed for two unique Wednesday, Thursday, and Friday, but only one Saturday, Sunday, Monday, and Tuesday. Therefore it is particularly interesting to note that Saturday received the second-greatest number of bids despite most listings only being active for one Saturday. I couldn't draw any firm conclusions by just looking at the bidding information, however. I decided to examine the page views as well.

![image](https://github.com/Wlefils/PokeMarket/assets/98787088/43325d56-c845-4aeb-8310-71bee73f79b8)


The above bar chart shows the total number of page views based on the day an auction was listed. It does not reveal the day a view was received; eBay does not provide a breakdown of that information, and I did not collect it manually, although that would be an excellent avenue of further exploration. However, this information is still useful. It shows that **listings I posted on Tuesday and Wednesday received the greatest average views and perhaps just as importantly, the greatest average views**. While 16 of my 26 listings (over 61%) were on Wednesday and combined to total over 51% of my total page views, only 3 of my listings were posted on Tuesday, accounting for over 30% of total page views. 

My hypothesis is that the listings posted on Tuesday received the highest average page views for two reasons: first, the specific cards that were listed on Tuesday were more popular, higher value cards, and attracted more collector attention. Secondly, however, is that these auctions received page views from two Fridays and two Saturdays, unlike the Wednesday listings that were only active for two Fridays and one Saturday. While I don't know for certain that a high percentage of page views are received on Saturday, I hypothesize that the higher number of bids received on Saturday would also correlate with page views. While auctions posted on Thursday received the lowest number of page views, note that I only posted one auction on a Thursday, and it was a card that wasn't particularly valuable or in high demand. The sample size isn't big enough to draw a firm conclusion on Thursday's viability. **I hypothesize that it would be best to ensure future listings are active during both Friday and Saturday. For my 10-day auctions, listing on Wednesday or Thursday would ensure my auctions were active during two of each of these days.**

![image](https://github.com/Wlefils/PokeMarket/assets/98787088/f4ea4794-7ad5-4213-bb48-8d967af869f0)


As the above line chart indicates, most bids were placed between 5:00PM and 9:00PM PST, with the plurality being between 5:30PM and 6:30PM, followed by 7:30PM-8:00PM. Adjusting these times to EST, where the majority of bids were placed, shifts them to 8:00 PM to 12:00 AM EST, with **the highest bidding density occurring between 8:30PM and 9:30PM EST**. This makes intuitive sense, as this timing captures standard after-work hours of all time zones in the United States, but before many adults go to sleep.

My day of the week and time of day analysis allowed me to draw some valuable conclusions and answer my temporal questions. Based on these results, I believe the **best day and time to list 10-day auctions for Pokémon cards appears to be on Wednesday or Thursday between 5:00 PM and 9:00 PM PST**. 

#### Net Income Analysis
![image](https://github.com/Wlefils/PokemonCardSales/assets/98787088/66592eee-e57e-41af-8816-80158980791e)
The above chart showcases the net income each card generated, ranked in descending order. My Base Set 2 Charizard, a famous card in collector circles, was by far my highest-grossing card. While Charizard is a popular Pokémon, this card is unique in its enduring popularity and rarity. First edition versions of this card in excellent condition (of which mine was neither) routinely sell for thousands of dollars. Even a later edition, Fair condition card like my Base Set 2 Charizard was worth more than any other card in my collection. However, Charizard's popularity is reflected in that a much less sought after card, such as my Charizard from the Expedition set, still ranked in the top 10, netting me $27.73, despite being a non-holographic version. There is also considerable variance in market price as was demonstrated by my two identical Dark Wartortle cards. Despite these cards being the same (including their condition), one of them sold for nearly 36% more than the other. This is the nature of eBay's bidding system, as bidding war dynamics between prospective customers can increase prices on individual items. Conversely, if there are fewer bidders competing for a particular item, the price will remain low.

This visualization makes it clear that, at least in my collection, the value of cards is not evenly distributed. Less than half of the cards sold net more than $10, and once we look beyond the top 10, the net proceeds quickly drop off dramatically. The 20th highest-earning card in my collection, Koga's Arbok, only generated $5.42 in net income (only 1.14% of my total earnings). While my entire collection consists of hundreds of cards, I opted not to list any with market values of under about $3.50, as the margins were too small to be worth the time and effort.

![image](https://github.com/Wlefils/PokemonCardSales/assets/98787088/af8477da-c558-4443-9f3d-c611a7901284)

I also compared my expected value to my actual net income on each card, using a scatter plot and a linear regression analysis. This is a simple one variable linear regression model to examine how the net income is affected by the estimated value of each card. The p-value of < 0.0001 shows that this is statistically significant. The R-Squared value of 0.97 tells us that the model explains 97% of the variation in the net income of each card. The regression equation informs us that **I earned about 91% of the estimated value per card, less 32 cents**.

### Conclusion
#### Insights and Recommendations
**There is clearly a vast disparity in card market prices**. Certain cards, particularly first edition, holographic, and Rare-quality cards are worth orders of magnitude more to collectors than Common-quality, non-holographic cards. Condition was certainly an important variable as well, but even relatively poor condition versions of high-value cards still sell for more than even Mint condition examples of cards in lower demand. **I was able to realize 91% of the expected value of each card**, indicating that the estimated value I calculated based on averaging recent eBay listings and external collector site prices was quite accurate. The 9% difference was primarily eroded by shipping fees and the percentage fee that eBay retains from each sale. However, **this figure does not account for the 28% capital gains tax on collectibles**, which would considerably reduce my net profits.

Based on my analysis, I would recommend the following to anyone who wishes to sell Pokémon cards on eBay. First, identify the highest value cards in your collection, and assess their market price based on their condition. I highly recommend browsing collector sites and researching recent eBay auctions for your specific cards. When creating listings, I found that offering free shipping was very enticing for buyers. However, to retain profit margins, you’ll need to increase the price of your card to make up for the shipping costs (including packaging materials). My findings indicate that **bids predominantly occurred between 5:00PM and 8:30PM PST (or 8:00PM and 11:30PM EST), particularly on Fridays and Saturdays**. Therefore, it’s important to ensure your listings are active during these peak engagement periods to maximize page views, bids, and ultimately, sales. More bidding engagement results in competition between buyers, driving up card prices and thus profits for sellers. I found my **customers were heavily concentrated within the Eastern and Northeastern United States**, despite offering international shipping options, so it may be less economical for sellers outside the United States to enter this market.

#### Limitations and Challenges
Two distinct limitations permeated the entire project:

* **Sample Size:** My analysis was inevitably constrained by the limited size of the dataset, which was restricted to my personal collection and the specific timeframe of the project. While my SQL and Tableau explorations were thorough given the data I had, my analyses were ultimately bound by this data. Further analysis would be enriched by incorporating broader market data. In the future, I could expand this project by web scraping additional eBay listings. However, I wouldn’t have access to as many variables for each individual card and listing, so there are some tradeoffs with this method.
* **Market Variability:** The collectible trading card market is inherently variable and unpredictable. When combined with the small sample size of my collection, it is difficult to draw firm conclusions. However, I believe I was able to make preliminary predictions that are informed by the trends in the data despite the built-in volatility of the environment.

#### Final Thoughts
This project was a very enriching, rewarding endeavor for me. I was able to merge a childhood hobby as well as my professional career goals and generate income while doing so. This project illustrates the potential of data-driven decision-making in optimizing and understanding niche markets The detailed analysis unveiled some intriguing patterns and valuable insights, as well as providing an opportunity for me to put my technical skills into practice while I was looking for work.

#### External Links
* [Complete collection of SQL queries used for this project](https://github.com/Wlefils/PokemonCardSales/blob/main/Pokemon%20Cards%20Database%20Queries.sql)
* [Tableau Dashboard](https://public.tableau.com/app/profile/william.lefils/viz/PokemonCardsProject/CardDashboard)
* [LinkedIn](https://www.linkedin.com/in/will-lefils-57b838132/)
* [Resume](https://wlefils.github.io/Will%20LeFils%20Resume.pdf)
* [Portfolio Homepage](https://wlefils.github.io/)
