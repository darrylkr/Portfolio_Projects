## Project Overview

#### The following is a web scraping exploration project of an Esports website: https://www.esportsearnings.com. The focus of this project is to get an overview of the Esports scene and it's growth over the years. The metric I will be focusing on to measure this growth is Prize Winnings. I scrape all available historical data up till December 2022 using python and save said data into Excel files. After which I load the data files into an SQL database and perform Exploratory Data Analysis on it. Lastly, I extract insightful data from SQL to visualize in Tableau.  

Python notebook: [Web Scraper](scraper.ipynb)  
SQL script: [EDA Script](SQL%20script.sql)  
Tableau Story: [Esports Dashboards](https://public.tableau.com/views/Esports_16739876336460/Esports?:language=en-US&:display_count=n&:origin=viz_share_link)  

## Web Scraping  
From the website: https://www.esportsearnings.com/history, I scrape the following: __Top 500 \[Players, Games, Countries, Teams] per Year/Month__. From this historical data, I extract the following information:  
For __Players__: \[Rank for the year, Player's ID, Player's Name, Winnings for the year, Winnings in career, Winnings for the year as a percentage of career winnings, Year, Player's Profile (URL)]      
For __Games__: \[Rank for the month/year, Game name, Prize for the month/year, Month, Year]       
For __Country__: \[Rank for the month/year, Country, Prize for the month/year, Player count for the month/year, Month, Year]      
For __Teams__: \[Rank for the month/year, Team, Prize for the month/year, Tournament count for the month/year, Month, Year]    

From each player in the Top 500 Players per Year, they have a unique Player's Profile (URL) which I use to extract more information about the players. This URL also functions as a foreign key to join multiple tables in SQL later on. I extract each player's demographic data and the player's career history of winnings:  
For __Demographics__: \[Player Name, Player Username, Game Title, Age, Country, Player's Profile (URL)]  
For __Career History__: \[Year, Prize, Tournament count, Prize as a percentage of Total Prize, Player's Profile (URL)]  
<br>

Next, I also collect the following data which is aggregated to date (till Dec 2022): __Top \[Countries, Games/Genre]__.  
For __Countries__: From https://www.esportsearnings.com/countries, we have the Top Countries by prize money and the number of players who have competed.  
Data scraped: \[Rank, Country, Prize, Player count, Top Game, Prize for Top Game, Prize for Top Game as a percentage of Total Prize]   
For __Games/Genre__: From https://www.esportsearnings.com/games/browse-by-genre, we have all esport games grouped by their genres; for each game, their respective aggregated prize pools, player count and tournament count.  
Data scraped: \[Game Title, Genre of game title, Prize, Player count, Tournament count]   
<br>
Website's Terms of Use: https://www.esportsearnings.com/terms-of-use  

## SQL Exploration/Cleaning
Using the scraped data from above, I clean the data, use joins, CTEs/Subqueries, Aggregate Functions, Window Functions and Views to manipulate the data in SQL, outputing a total of 13 tables of data for visualisation in Tableau.

<ins>Teams Data</ins>    
Table 1: Top 10 Teams by Prize Money, Tournament count of team, Average Prize per Tournament, Years Active, Tournaments per Year     
Table 2: Top 10 Teams' History of Prize Winnings by Month/Year  
<br>

<ins>Countries Data</ins>    
Table 3: Top 5 Countries by Prize Winnings, Player count of Country, Top Game of Country, Prize for Top Game, Top Game's prize as a percentage of the Country's total Prize Winnings  
Table 4: Top 5 Countries' History of Prize Winnings and Player count by Month/Year    
Table 10: Top 10 Countries' History of Prize Winnings as Cumulative Sums per Year  
<br>

<ins>Games Data</ins>  
Table 5: Top 5 Games by Largest Prize Pool aggregated to date with Total Tournaments, Unique Players and Years Active   
Table 6: Top 5 Games' History of Prize Pool and Player/Tournament count by Month/Year  
Table 7: All Games/Genres by Prize Pool, Player/Tournament count aggregated to date  
Table 8: All Genres by Largest Prize Pool, Total Players and Total Tournaments aggregated to date   
Table 12: 

----------------Games Data Start----------------
--table 12
--genre's games history of prize/players/tournaments per year
select t1.game, t2.genre, sum(t1.prize) prize, sum(t1.players) players, sum(t1.tournaments) tournaments, t1.year
from top_games t1
join all_esport_games t2
on t1.game = t2.title
group by year, game, genre
having sum(t1.prize) >0 
order by year asc, prize desc, genre

-----------------Games Data End-----------------

--------------Player Data Start--------------

select * from player_profiles 
where country like 'Korea%'

--standardize country name for South Korea
update player_profiles
set country = 'South Korea'
where country like 'Korea%'

--standardize game name
update player_profiles
set game = 'Counter-Strike: Global Offensive'
where game = 'CS:GO'

select * from top_player_history
select * from top_players
select * from player_profiles

--table 9: top players with their latest esports data and their demographic information
--using the top players with their total_prize winnings and total_tournaments,
--join to top_players to get their player_ids and player_names,
--finally join to player_profiles to get their demographic information.
with table1 as(
select sum(prize_year) as total_prize, sum(tournaments) as total_tournaments, profile_link
from top_player_history
group by profile_link
--order by total_prize desc
),
table2 as (
select distinct t2.player_id, t2.player_name, t2.prize_overall, t1.total_tournaments, t1.profile_link
from top_players t2
join table1 t1
on t2.player_profile = t1.profile_link
--order by prize_overall desc
)
select t2.player_id, t2.player_name, t2.prize_overall, t2.total_tournaments, t3.game, t3.age, t3.country, t2.profile_link
from table2 t2
join player_profiles t3
on t2.profile_link = t3.profile_link
where t2.prize_overall > 100000
order by t2.prize_overall desc

--alternative query to the above but without tournament numbers
with top_players_table as (
select sum(prize_year) as prize_year, avg(prize_overall) as prize_overall, player_profile
from top_players t
group by player_profile
)
select p.name, p.player_id, p.game, p.age, t.prize_year, t.prize_overall, t.player_profile
from top_players_table t
join player_profiles p
on t.player_profile = p.profile_link
--where p.game in ('Dota 2', 'Fortnite', 'CS:GO', 'League of Legends', 'Arena of Valor')
order by t.prize_overall desc


--table 11
--top 10 countries history of player prize winnings per year
select tp.player_id, tp.prize_year, pp.country, pp.game, tp.year
from top_players tp
join player_profiles pp
on tp.player_profile = pp.profile_link
where country in (
select country from top_10_countries
)
order by year, prize_year desc


--table 13
--number of years from 1998-2022 that a player has ranked in the top 500 in terms of prize winnings
with table13 as (
select tp.player_id, tp.player_name, pp.game, count(distinct tp.year) year_count
from top_players tp
join player_profiles pp
on tp.player_profile = pp.profile_link
group by player_profile, tp.player_id, player_name, game
--order by top_500_count desc
)
select year_count, count(year_count) player_count
from table13
group by year_count
order by player_count desc


-- 1998-2001 does not have a full 500 players for the "Top 500 Players by prize winnings" by year.
select max(rank) last_rank, year
from top_players
group by year
order by year

-- from the annual top 500 players by prize winnings, get the last ranked player every year from 1998-2022
-- to show what the minimum amount of prize winnings did the last of the best make per year
with top_500_players as (
select rank, player_id, player_name, prize_year, year, ROW_NUMBER() over (partition by year order by rank desc) as last_rank_year
from top_players
where prize_year > 0
)
select player_id, rank, prize_year, year
from top_500_players
where last_rank_year = 1

---------------Player Data End---------------




The dataset has over 70 columns of information, but I mainly explore the following at the global, continent and country levels:  
- Number of cases vs deaths (death rate)  
- Number of cases vs population (infection rate)  
- Number of vaccinations vs population (% population vaccinated)  
- Partially vs Fully Vaccinated populations (% population partial vs full vaccination)  
- GDP vs % of population that has received at least 1 vaccination  

## Data Visualisation  
__Infections and Deaths Dashboard__
![Infections & Deaths](Infections%20and%20Deaths.png)  
---
__Global Vaccine Tracker__
---
![Global Vaccine Tracker](Global%20Vaccine%20Tracker.png)  
