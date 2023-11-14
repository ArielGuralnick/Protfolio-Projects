
-- looking for best 10 countries to live in
select top 10 *
from ProtfolioProject..happy2021

-- looking for average happiness score by region 
select Regional_indicator, avg(Ladder_score) as Avarage_Score
from ProtfolioProject..happy2021
group by Regional_indicator 
order by Avarage_Score desc

-- looking for best healty life expectancy and best GDP
select Country_name, Regional_indicator, Healthy_life_expectancy, Logged_GDP_per_capita
from ProtfolioProject..happy2021
where Healthy_life_expectancy = 
(
	select max (Healthy_life_expectancy)
	from ProtfolioProject..happy2021)
or Logged_GDP_per_capita = 
(
	select max (Logged_GDP_per_capita)
	from ProtfolioProject..happy2021
)

-- Calculate the average happiness and GDP for each continent
select regional_indicator,
    avg(Ladder_score) as Avg_Happiness,
    avg(Logged_GDP_per_capita) as Avg_GDP
from ProtfolioProject..happy2021
group by regional_indicator;


-- Identify countries where both social support and freedom to make life choices are above the global averages.
select Country_name, Social_support, Freedom_to_make_life_choices
from ProtfolioProject..happy2021
where Social_support > (select avg(Social_support) from ProtfolioProject..happy2021)
  AND Freedom_to_make_life_choices > (select avg(Freedom_to_make_life_choices) from ProtfolioProject..happy2021)


-- Rank countries based on the perception of corruption, considering only countries with a ladder score above the global average.
select country_name, ROW_NUMBER() over (order by Perceptions_of_corruption asc) as corruption_rank
from ProtfolioProject..happy2021
where Ladder_score > (select avg(Ladder_score) from ProtfolioProject..happy2021); 


-- Identify countries that experienced the largest increase in Score from 2020 to 2021.
select a.country_name, a.ladder_score as ladder_score_2020, b.ladder_score as ladder_score_2021,
(b.ladder_score - a.ladder_score) as Score_Increase
from ProtfolioProject..happy2020 as a
join ProtfolioProject..happy2021 as b on a.country_name = b.Country_name
--where a.year = 2020 and b.year = 2021
order by Score_Increase desc


-- Average Change in GDP by Continent from 2020 to 2021:
SELECT a.Regional_indicator, avg (b.Logged_GDP_per_capita - a.Logged_GDP_per_capita) as Avg_GDP_Change
from ProtfolioProject..happy2020 as a
join ProtfolioProject..happy2021 as b on a.country_name = b.country_name and a.Regional_indicator = b.Regional_indicator
group by a.Regional_indicator 
order by Avg_GDP_Change desc


-- Countries with Increased Freedom and Decreased Corruption Perception in 2021 compared to 2020
select a.country_name
from ProtfolioProject..happy2020 as a
join ProtfolioProject..happy2021 as b on a.country_name = b.Country_name
where b.Freedom_to_make_life_choices > a.Freedom_to_make_life_choices
and b.Perceptions_of_corruption < a.Perceptions_of_corruption
order by b.Ladder_score desc


--Identifying Countries with Consistently High or Improved Generosity and Life Expectancy from 2020 to 2021
select a.country_name
from ProtfolioProject..happy2020 as a
join ProtfolioProject..happy2021 as b on a.country_name = b.country_name
where a.Generosity > (
	select avg(Generosity)
	from ProtfolioProject..happy2020
) and
a.Healthy_life_expectancy < b.Healthy_life_expectancy


-- Countries with a Decrease in Happiness Despite Increased GDP and Social Support from 2020 to 2021
select a.country_name, a.Ladder_Score, b.Ladder_Score,
a.Logged_GDP_per_capita, b.Logged_GDP_per_capita,
a.Social_Support, b.Social_Support
from ProtfolioProject..happy2020 as a
join ProtfolioProject..happy2021 as b on a.country_name = b.country_name
where b.Ladder_Score > a.Ladder_Score and b.Logged_GDP_per_capita < a.Logged_GDP_per_capita and b.Social_Support < a.Social_Support
