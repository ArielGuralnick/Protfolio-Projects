select *
from ProtfolioProject..CovidDeaths$
order by 3,4

-- Looking at Total Cases vs Total Deaths In Israel
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPrecentage
from ProtfolioProject..CovidDeaths$
where Location like 'Israel'
order by 1,2

-- Looking at Total Cases vs Population In Israel
select Location, date, total_cases, population, (total_deaths/population)*100 as gotInfectedPrecentage
from ProtfolioProject..CovidDeaths$
where Location like 'Israel'
order by 1,2

-- Looking at countries with highest infection rate (compared to population)
select Location, population, MAX(total_cases) as maxTotalcases, population, MAX((total_deaths/population))*100 as precentPopulationInfected
from ProtfolioProject..CovidDeaths$
Group by Location, population
order by precentPopulationInfected desc

--Looking at countries with Hight Death Count per Population
select Location, MAX(cast(total_deaths as int)) as maxTotalDeaths
from ProtfolioProject..CovidDeaths$
where continent is not null
Group by Location
order by maxTotalDeaths desc

-- Looking on Continent
select continent, max(cast(Total_deaths as int)) as totalDeathCount
from ProtfolioProject..CovidDeaths$
where continent is not null
group by continent
order by totalDeathCount desc

-- Looking on total cases,deaths, and precentage all over the world of death
select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as Death_Precentage
from ProtfolioProject..CovidDeaths$
where continent is not null



-- Looking at population vs Vacctinations (using CTE)

-- use CTE
with PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated )
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
from ProtfolioProject..CovidDeaths$ dea
join ProtfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (RollingPeopleVaccinated/population)*100
from PopvsVac


-- create view of percenatge people who vacctinated around the world
create view  percentagePopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
from ProtfolioProject..CovidDeaths$ dea
join ProtfolioProject..CovidVaccinations$ vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select *
from percentagePopulationVaccinated