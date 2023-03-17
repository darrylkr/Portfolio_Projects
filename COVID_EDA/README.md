## Project Overview

#### The following is an exploration of a COVID-19 dataset from https://ourworldindata.org/covid-deaths between __Jan 2020 to Oct 2021__. I load the dataset into an SQL database and perform some EDA on it. Afterwhich, I extract insightful data and visualize them in Tableau.  

Dataset file (~30MB): [covid_dataset (google drive)](https://docs.google.com/spreadsheets/d/1Z4cCsnUyWjxUCI7CEMYGcUD132Vlg_DF/edit?usp=share_link&ouid=102427991570364317954&rtpof=true&sd=true)  
SQL script: [EDA Script](COVID%20-%20Exploration.sql)  
Interactive Tableau Dashboards: [Infections & Deaths](https://public.tableau.com/views/COVID-19InfectionsandDeaths/COVIDInfectionsDeaths?:language=en-US&:display_count=n&:origin=viz_share_link)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Global Vaccine Tracker](https://public.tableau.com/views/COVID-19GlobalVaccineTracker_16783042538840/GlobalVaccineTracker?:language=en-US&:display_count=n&:origin=viz_share_link)  

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
