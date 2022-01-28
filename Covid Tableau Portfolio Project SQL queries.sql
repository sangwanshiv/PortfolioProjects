/*
--Queries used for tableau project
*/

--1.

Select SUM(new_cases) as totalcases, SUM(CAST(new_deaths as int)) as totaldeaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
from PortfolioProjects..coviddeaths$
--where location like '%India%'
where continent is not null  
--group by date
--order by 1,2

--2.

--we take these out as they are not included in the above queries and want to stay consistent 
--European union is the part of europe 

Select location, sum(cast(new_deaths as int)) as TotalDeathCount
from PortfolioProjects..coviddeaths$
--where location like "$India$"
where continent is null
and location not in ('World', 'European Union', 'International', 'Upper middle income', 'High income', 'Lower middle income', 'Low income')
Group by location 
order by TotalDeathCount desc

--3.

Select location, Population,  Max(total_cases) as HighestInfectedCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProjects..coviddeaths$
--where location like "$India$"
Group by location, Population
order by PercentPopulationInfected desc

--4. 

Select location, Population, date, Max(total_cases) as HighestInfectedCount, Max((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProjects..coviddeaths$
--where location like "$India$"
Group by location, Population, date
order by PercentPopulationInfected desc

--
