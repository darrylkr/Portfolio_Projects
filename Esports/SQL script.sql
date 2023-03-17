
--------------Teams Data Start--------------
--check for rows with 0 tournaments as tournaments with prize pool cannot be 0
select * from top_teams
where tournaments = 0
order by prize_year desc

--since the respective prize pools are small, set tournamnent to 1
update top_teams
set tournaments = 1
where tournaments = 0

--upper limit for the number of years a team can have been in esports for
select count(distinct year)
from top_teams

--table 1 
--top 10 teams by prize money won
select top 10 team, sum(prize_year) as total_prize, sum(tournaments) as total_tournaments, sum(prize_year)/sum(tournaments) as prize_per_tournament, count (distinct year) as years_active, sum(tournaments)/count (distinct year) as tournaments_per_year
from top_teams
group by team
order by total_prize desc

--table 2
--top 10 teams history month/year
with top_10_teams as (
select top 10 team, sum(prize_year) as total_prize
from top_teams
group by team
order by total_prize desc
)
select * from top_teams
where team in (
select team from top_10_teams
)
order by year, month

--get team liquid's prize winnings history / prize change per year / prize change in percent per year
with liquid_history as (
select team, sum(prize_year) as prize, sum(tournaments) tournaments, year from top_teams
where team = 'Team Liquid'
group by year, team
)
select team, prize, tournaments, year,
prize - lag(prize) over (order by year asc) as prize_change,
cast(round((prize - lag(prize) over (order by year asc))/lag(prize) over (order by year asc)*100,2) as decimal(6,2)) as prize_change_percent
from liquid_history
order by year desc


--join team_detailed_breakdown with player_profiles to get player's game
select t1.team, t1.player_id, t1.player_name, t1.prize, t2.game
from team_detailed_breakdown t1
join player_profiles t2
on t1.player_id = t2.player_id and
t1.player_name = t2.name
order by team, prize desc
------------------End Teams Data------------------

---------------Countries Data Start---------------

--table 3
--get top 5 countries with highest prize winnings to date
select top 5 country, prize, players, top_game, prize_top_game, pct_total_prize
from top_countries

--standardize country name for South Korea
update top_countries
set country = 'South Korea'
where country = 'Korea, Republic of'

update top_countries_history
set country = 'South Korea'
where country = 'Korea, Republic of'

--table 4
--get historical data for the top 5 countries 
with top_5_countries as (
select top 5 country, prize, players, top_game, prize_top_game, pct_total_prize
from top_countries
)
select country, prize_year, players, month, year
from top_countries_history
where country in (
select country from top_5_countries
)
order by year, month

--number of years of data collected
select count (distinct year) from top_countries_history

--for top 10 countries throughout history
--country_count = number of distinct years a country has won prize money.
--index_average = summation of the ranks a country has ranked at per year divided by country_count.
create view top_10_countries as
with country_history as (
select country, sum(prize_year) prize, year, ROW_NUMBER() over (partition by year order by sum(prize_year) desc) rank_no
from top_countries_history
group by country, year
)
select top 10 country, sum(prize) prize, sum(rank_no) rank_sum, count(country) country_count, cast(sum(rank_no) / cast(count(country) as decimal(5,2)) as decimal(5,2)) rank_average
from country_history
group by country
order by rank_average, prize desc

select * from top_10_countries

--table 10
--top 10 countries prize winnings history with their respective cumulative sums per year
with top_10_countries_history as (
select country, sum(prize_year) prize, year
from top_countries_history
where country in (
select country from top_10_countries
)
group by country, year
)
select *, sum(prize) over (partition by country order by year) cumulative_sum
from top_10_countries_history
order by year, prize desc

---------------Countries Data End---------------


----------------Games Data Start----------------

select game, sum(prize) as prize_total
from top_games
group by game
order by prize_total desc

--table 5
--get top 5 games with highest prize to date
--join all_esport_games table to use total unique players column
select top 5 game, sum(t.prize) as total_prize, sum(t.tournaments) as total_tournaments, min(a.players) as players, count(distinct year) as years_active
from top_games t
join all_esport_games a on t.game = a.title
group by game
order by total_prize desc, total_tournaments desc

--table 6
--get top 5 games history of prize/players/tournaments per month/year
with top_5_games as (
select top 5 game, sum(prize) as total_prize
from top_games
group by game
order by total_prize desc
)
select game, prize, players, tournaments, month, year
from top_games
where game in (
select game from top_5_games)
order by year, month

--table 7
select * from all_esport_games

--table 8
--view the top genres in esports
select genre, sum(prize) as total_prize, sum(players) as total_players, sum(tournaments) as total_tournaments
from all_esport_games
group by genre
order by total_prize desc, total_tournaments desc


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