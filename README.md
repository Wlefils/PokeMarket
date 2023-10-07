## Executive Summary

When I found myself in between jobs and needing some extra cash, I recalled my previously long-forgotten collection of Pokémon cards. I remembered from childhood discussions that certain cards in my collection were worth significant sums, but I hadn’t examined the market prices for any trading cards in over a decade. At the sametime, my passion for data analytics was growing, and I saw an opportunity to further hone my skills in SQL and data visualization, along with my then-nascent understanding of database design. Inspired by reading Kimball's _**The Data Warehouse Toolkit**_, I decided to design my own database according to the data warehousing principles outlined in the book using Microsoft SQL Server. After manually inputting and wrangling the data with SQL queries, I exported it to Excel and then to Tableau, where I visualized the data to find patterns and insights into the niche world of Pokémon card sales. **My findings indicate that there are important patterns in terms of time of day, day of the week, location, and specific card details that have significant impacts on KPIs related to eBay auctions**, specifically with regards to Pokémon cards. This dataset was ultimately too small to draw conclusions about card sales outside of my collection, but preliminary trends emerged that could be further investigated using a similar approach.

### Key Findings

[Interactive Tableau Dashboard Here](https://public.tableau.com/views/PokemonCardsProject/CardDashboard?:language=en-US&:display_count=n&:origin=viz_share_link)


#### Geographical Insights
I found a pronounced geographical trend regarding bidding locations. No bids originated from the Northwestern United States, rather, bids were concentrated in the Eastern and Northeastern U.S. This is despite the fact that I live in California and offered international shipping as an option on all listings.
#### Temporal Patterns
Most bids were placed between 5:00PM and 8:30 PM PST. This correlates well with off-work hours for adults in the United States, particularly in the Eastern time zone (where it would be 8:00 PM to 11:30 PM). Additionally, Friday and Saturday were the most active bidding days, while none of my auctions received bids on Mondays.
#### Card Value Distribution
As expected, there is a large disparity in the market value of cards. While I owned hundreds of Common quality cards, selling them would rarely offset the associated shipping and/or selling costs. Collectors have a strong preference towards first edition, Rare, and holographic cards, particularly those in Mint or Near Mint condition. There was also considerable variation in the value of cards based on which Set they were a part of. A single card, my holographic Charizard from Base Set 2, generated significantly more earnings than any of my other cards (17% of total net proceeds out of 26 cards sold).
#### Profit Analysis
I was able to realize approximately 91% of the expected value per card. The 9% was eroded primarily by shipping fees and eBay’s percentage fee. This does not account for the 28% capital gains tax on collectibles, which would further erode profit margins.
