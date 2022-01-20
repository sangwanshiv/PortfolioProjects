select*
from PortfolioProjects..coviddeaths$
where continent is not null
order by 3,4

select*
from PortfolioProjects..covidvaccination$
where continent is not null
order by 3,4

--Selecting data that we are going to be using 

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProjects..coviddeaths$
where continent is not null
order by 1,2

--Looking at the Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
from PortfolioProjects..coviddeaths$
where location like '%India%' and continent is not null
order by 1,2

--Looking at the Total Cases Vs Population
--Shows what percentage of population got Covid 

Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
from PortfolioProjects..coviddeaths$
--where location like '%India%'
where continent is not null
order by 1,2

--Looking at countries with Highest Infection rate compared to population

Select location, population, max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected 
from PortfolioProjects..coviddeaths$
--where location like '%India%'
where continent is not null
Group By location, population
order by PercentPopulationInfected desc

--Showing countries with highest death count per population

Select location, max(cast(total_deaths as int)) as TotalDeathCount 
from PortfolioProjects..coviddeaths$
--where location like '%India%'
where continent is not null
Group By location
order by TotalDeathCount desc

--LETS BREAK THINGS DOWN BY CONTINENT
--Showing the continents with highest death count per population

Select continent, max(cast(total_deaths as int)) as TotalDeathCount 
from PortfolioProjects..coviddeaths$
--where location like '%India%'
where continent is not null
Group By continent
order by TotalDeathCount desc



--GLOBAL NUMBERS 

Select SUM(new_cases) as totalcases, SUM(CAST(new_deaths as int)) as totaldeaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as deathpercentage
from PortfolioProjects..coviddeaths$
--where location like '%India%'
where continent is not null  
--group by date
order by 1,2

--Looking at Total population vs Vaccinations
	 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(cast(vac.new_vaccinations as bigint)) over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/popultion)*100
from PortfolioProjects ..coviddeaths$ dea
Join PortfolioProjects..covidvaccination$ vac
	on dea.location= vac.location
	and dea.date= vac.date
order by 2,3



--USE CTE

With PopvsVac(Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProjects..coviddeaths$ dea
Join PortfolioProjects..covidvaccination$ vac
	on dea.location= vac.location
	and dea.date= vac.date
--order by 2,3
)
Select*, (RollingPeopleVaccinated/Population)*100
From PopvsVac 


--Temp Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProjects..coviddeaths$ dea
Join PortfolioProjects..covidvaccination$ vac
	on dea.location= vac.location
	and dea.date= vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating view to store data for later visualization 

Create View PercentPopulationsVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) over (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortfolioProjects..coviddeaths$ dea
Join PortfolioProjects..covidvaccination$ vac
	on dea.location= vac.location
	and dea.date= vac.date
--where dea.continent is not null
--order by 2,3


 













