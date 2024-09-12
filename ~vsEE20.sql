Select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3, 4







Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
order by 1, 2





Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%india%'
and continent is not null
order by 1, 2






--Select total_cases
--From PortfolioProject..CovidDeaths

Update dbo.CovidDeaths
Set total_cases = Null
Where total_cases = 0

Update dbo.CovidDeaths
Set total_deaths = Null
Where total_deaths = 0

Update dbo.CovidDeaths
Set new_cases = 0
Where new_cases = Null

--Select total_deaths
--From PortfolioProject..CovidDeaths






Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%india%'
order by 1, 2







Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%india%'
Group by location, population
order by PercentPopulationInfected desc






Select location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%india%'
where continent is not null
Group by location
order by TotalDeathCount desc






Select location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%india%'
where continent is  null
Group by location
order by TotalDeathCount desc





Select continent, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%india%'
where continent is not null
Group by continent
order by TotalDeathCount desc






Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as TotalDeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%india%'
where continent is not null
--group by date
order by 1,2







Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.Date)
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccination vac
	On dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2, 3








WITH VaccinationData AS (
    SELECT vac.location, vac.date,
        SUM(CAST(vac.new_vaccinations AS INT)) AS new_vaccinations
    FROM PortfolioProject..CovidVaccination vac
    GROUP BY vac.location, vac.date
),
PopvsVac As (
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.date) AS cumulative_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN VaccinationData vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
Select *, (cumulative_vaccinations/population)*100
From PopvsVac
Order by location, date







Drop Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
cumulative_vaccinations numeric
)
Insert into #PercentPopulationVaccinated
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CAST(vac.new_vaccinations as numeric)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS cumulative_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

Select *, (cumulative_vaccinations/population)*100
From #PercentPopulationVaccinated






Create view PercentPopulationVaccinated as
	SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
	SUM(CAST(vac.new_vaccinations as numeric)) OVER (PARTITION BY dea.location ORDER BY dea.date) AS cumulative_vaccinations
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccination vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

Select *
From PercentPopulationVaccinated




Create view TotalDeathPercentage as
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as TotalDeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%india%'
where continent is not null
--group by date
--order by 1,2

Select * 
From TotalDeathPercentage





Create view TotalDeathCount as
Select continent, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%india%'
where continent is not null
Group by continent
--order by TotalDeathCount desc




Create view TotalDeathCountCorrect as
Select location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%india%'
where continent is  null
Group by location
--order by TotalDeathCount desc

Select *
From TotalDeathCountAll






Create view TotalDeathCountByLocation as
Select location, MAX(total_deaths) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%india%'
where continent is not null
Group by location
--order by TotalDeathCount desc

Select *
From TotalDeathCountByLocation
Order by 1


Create view PercentPopulationInfected as
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%india%'
Group by location, population
--order by PercentPopulationInfected desc

Select *
From PercentPopulationInfected
Order by 1


Create view PercentPopulationInfectedDate as
Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%india%'
--order by 1, 2


Create view DeathPercentage as 
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%india%'
where continent is not null
--order by 1, 2


Create view PopulationDeaths as
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
where continent is not null
--order by 1, 2