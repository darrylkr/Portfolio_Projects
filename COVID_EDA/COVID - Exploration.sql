select * from covid_vaccines

-- total cases vs total deaths in Singapore
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_rate
from covid_vaccines
where location = 'Singapore'
order by location, date


-- total cases vs total deaths in USA
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_rate
from covid_vaccines
where location like '%states'
order by location, date


-- total cases vs population in Singapore/USA
select location, date, total_cases, population, (total_cases/population)*100 as infection_rate
from covid_vaccines
where location in ('Singapore', 'United States')
order by location, date


-- countries with the highest infection rates
select location, max(date) latest_date, max(total_cases) highest_infection_count, population, (max(total_cases)/population)*100 as infection_rate
from covid_vaccines
where continent is not null
group by location, population
having max(total_cases) is not null
order by infection_rate desc


-- countries with highest death counts
select location, max(cast(total_deaths as int)) highest_death_count
from covid_vaccines
where continent is not null
group by location
order by highest_death_count desc


-- continents with the highest death counts
select location, max(cast(total_deaths as int)) highest_death_count
from covid_vaccines
where continent is null
group by location
order by highest_death_count desc

select location, sum(cast(new_deaths as int)) as total_death_count
from covid_vaccines
where continent is null
and location not in ('World', 'European Union', 'International')
group by location
order by total_death_count desc


--global cases/death rate
select date, sum(new_cases) total_new_cases, sum(cast(new_deaths as int)) total_new_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 death_rate
from covid_vaccines
where continent is not null
group by date
order by date

select sum(new_cases) total_cases, sum(cast(new_deaths as int)) total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 death_rate
from covid_vaccines
where continent is not null


--total population vs new vaccinations
with cte as (
select continent, location, date, population, new_vaccinations, sum(cast(new_vaccinations as numeric)) over (partition by location order by date) cumulative_new_vaccinations
from covid_vaccines
where continent is not null
and new_vaccinations is not null
)
select *, (cumulative_new_vaccinations/population)*100 location_vaccination_rate
from cte


--temp table for total population vs new vaccinations
drop table if exists #percent_population_vaccinated
create table #percent_population_vaccinated
(
continent nvarchar(255),
location nvarchar(255),
ate datetime,
population numeric,
new_vaccinations numeric,
cumulative_new_vaccinations numeric
)

insert into #percent_population_vaccinated
select continent, location, date, population, new_vaccinations, sum(cast(new_vaccinations as numeric)) over (partition by location order by date) cumulative_new_vaccinations
from covid_vaccines
where continent is not null
and new_vaccinations is not null

select * from #percent_population_vaccinated