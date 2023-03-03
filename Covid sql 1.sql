

Select *
From PortfolioProject..['covid death$']
Where continent is not null
order by 3,4

--Select *
--from PortfolioProject..['covid vaccination$']
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..['covid death$']
Where continent is not null
order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..
Where continent is not null
order by 1,2

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..['covid death$']
where location like '%india%'
order by 1,2

Select Location, date, total_cases, population, (total_cases/population)*100 as DeathPercentage
from PortfolioProject..['covid death$']
--where location like '%india%'
Where continent is not null
order by 1,2

Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
from PortfolioProject..['covid death$']
--where location like '%india%'
group by Location, population
order by PercentPopulationInfected desc


Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..['covid death$']
--where location like '%india
Where continent is not null
group by Location
order by TotalDeathCount desc


Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
from PortfolioProject..['covid death$']
--where location like '%india
Where continent is not null
group by continent
order by TotalDeathCount desc


Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM
(New_Cases)*100 as DeathPercentage
From PortfolioProject..['covid death$']
--where location like '%india%'
Where continent is not null
group by date
order by 1,2

-- TOTAL CASES AND TOTAL DEATHS 
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM
(New_Cases)*100 as DeathPercentage
From PortfolioProject..['covid death$']
--where location like '%india%'
Where continent is not null
--group by date
order by 1,2


-- Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..['covid death$'] dea
Join PortfolioProject..['covid vaccination$'] vac
     on dea.location = vac.location
	 and dea.date =  vac.date
Where dea.continent is not null
order by 2,3


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..['covid death$'] dea
Join PortfolioProject..['covid vaccination$'] vac
     on dea.location = vac.location
	 and dea.date =  vac.date
Where dea.continent is not null
order by 2,3

-- USE CTE

With PopvsVac (Continent, location, date, population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..['covid death$'] dea
Join PortfolioProject..['covid vaccination$'] vac
     on dea.location = vac.location
	 and dea.date =  vac.date
Where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


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
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..['covid death$'] dea
Join PortfolioProject..['covid vaccination$'] vac
     on dea.location = vac.location
	 and dea.date =  vac.date
Where dea.continent is not null
--order by 2,3


Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location, dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
from PortfolioProject..['covid death$'] dea
Join PortfolioProject..['covid vaccination$'] vac
     on dea.location = vac.location
	 and dea.date =  vac.date
Where dea.continent is not null
--order by 2,3

Select *
from PercentPopulationVaccinated









