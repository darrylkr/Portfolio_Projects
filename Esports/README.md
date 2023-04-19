## Project Overview

#### The following is a web scraping exploration project of an Esports website: https://www.esportsearnings.com. I scrape the all available historical data up till December 2022 using python and save said data into Excel files. After which I load the data files into an SQL database and perform Exploratory Data Analysis on it. Lastly, I extract insightful data and visualize them in Tableau.  

Python notebook: [Web Scraper](scraper.ipynb)  
SQL script: [EDA Script](SQL%20script.sql)  
Interactive Tableau Dashboards: [Esports Dashboards](https://public.tableau.com/views/Esports_16739876336460/Esports?:language=en-US&:display_count=n&:origin=viz_share_link)  

## Web Scraping  
From the website: https://www.esportsearnings.com/history, I scrape the following: Top 500 \[Players, Games, Countries, Teams] per Year/Month. From this historical data, I extract the following information:  
For __Players__: \[Rank for the year, Player's ID, Player's Name, Winnings for the year, Winnings in career, Winnings for the year as a percentage of career winnings, Year, Player's Profile (URL)]      
For __Games__: \[Rank for the month/year, Game name, Prize for the month/year, Month, Year]       
For __Country__: \[Rank for the month/year, Country, Prize for the month/year, Player count for the month/year, Month, Year]      
For __Teams__: \[Rank for the month/year, Team, Prize for the month/year, Tournament count for the month/year, Month, Year]    
<br>

Next, The following data is aggregated to-date (till Dec 2022).  
From https://www.esportsearnings.com/countries, we have the Top Countries by prize money and the number of players who have competed. 
From https://www.esportsearnings.com/teams, we have the Top Teams by prize money and number of tournaments they have competed in.  
From https://www.esportsearnings.com/games/browse-by-genre, we have all esport games grouped by their genres; for each game, their respective aggregated prize pools, player count and tournament count.

## Data and Exploration
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
