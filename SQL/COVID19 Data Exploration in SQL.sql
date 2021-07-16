--All Data regarding the cases, deaths and there ratio in the following queries.
select * from [COVID19-Deaths] order by location, date


-- Data that we are going to focus for next queries.
select location, date, total_cases, new_cases, total_deaths, population
from [COVID19-Deaths] where continent is not null order by location, date

--Death ratio of cases reported: Likelyhood of dying from virus if you have contracted it.
select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRatioPercentage
from [COVID19-Deaths] where continent is not null order by location, date
--Death ratio of cases reported: For Pakistan.
select location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathRatioPercentage
from [COVID19-Deaths] where location like '%Pak%' order by location, date

--Positive cases ratio: Number of cases against the population of the country.
select location, date, total_cases, population, (total_cases/population)*100 as PostiveCaseRatioPercentage
from [COVID19-Deaths] where continent is not null order by location, date
--Positive cases ratio: For Pakistan.
select location, date, total_cases, population, (total_cases/population)*100 as PostiveCaseRatioPercentage
from [COVID19-Deaths]  where location like '%Pak%' order by location, date

--Highest Infection rate per country.
select location, population, max(total_cases) as PositveCases , max((total_cases/population))*100 as PercentagePopulationInfected
from [COVID19-Deaths] where continent is not null group by location, population order by PercentagePopulationInfected desc

--Highest Death rate per country.
select location, population, max(total_deaths) as TotalDeaths , max((total_deaths/population))*100 as PercentagePopulationDeaths
from [COVID19-Deaths] where continent is not null group by location, population order by PercentagePopulationDeaths desc

--Highest Death count per country.
select location, max(cast(total_deaths as int)) as DeathCount
from [COVID19-Deaths] where continent is not null group by location order by DeathCount desc

--Highest Death count per continent.
select location, max(cast(total_deaths as int)) as DeathCount
from [COVID19-Deaths] where continent is null group by location order by DeathCount desc

--Global Statistics of Cases & Deaths each day.
select date, sum(new_cases) as TotalCases, sum(cast(new_deaths  as int)) as DeathCount
from [COVID19-Deaths] where continent is null group by date order by Date, TotalCases desc


--All Data regarding the vaccinations in the following queries.
select * from [COVID19-Vaccinations]

--New & Aggregated Vaccinations each day for every country.
select death.continent, death.location, death.date, death.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by death.location order by death.location, death.date)
as AggregatedVaccinations from [COVID19-Deaths] as death join [COVID19-Vaccinations] as vac on death.location=vac.location and death.date=vac.date where death.continent is not null
order by death.location, death.date

-- Creating View for New & Aggregated Vaccinations each day for every country.
create view PercentPopulationVaccinated as
select death.continent, death.location, death.date, death.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int)) over (partition by death.location order by death.location, death.date)
as AggregatedVaccinations from [COVID19-Deaths] as death join [COVID19-Vaccinations] as vac on death.location=vac.location and death.date=vac.date where death.continent is not null




