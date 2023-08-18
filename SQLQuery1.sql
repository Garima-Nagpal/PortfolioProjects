SELECT
*
FROM
PortfolioProject.dbo.CovidDeaths$
order by 3,4

SELECT
*
FROM
PortfolioProject.dbo.CovidVaccinations$
order by 3,4
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths$
order by 1,2

---looking at total cases vs total deaths
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
order by 1,2

---looking at total cases vs population

SELECT Location, date, POPULATION, total_cases, (total_CASES/population)*100 as covidPercentage
FROM PortfolioProject..CovidDeaths$
order by 1,2
---looking at countries with highest infection rates compared to poulation
 SELECT Location, POPULATION, MAX(total_cases)as HighestInfectionCount, MAX(total_CASES/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$
Group by Population, Location
order by 1,2
 SELECT Location, POPULATION, MAX(total_cases)as HighestInfectionCount, MAX(total_CASES/population)*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths$
Group by Population, Location
order by PercentPopulationInfected desc

--looking at countries with highest death count by population

 SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
Where continent is not null
Group by Location
order by TotalDeathCount desc

--looking at continents now

 SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths$
Where continent is null
Group by location
order by TotalDeathCount desc

 --Looking at continents with highest death count per poulation

 SELECT Continent,  Max(cast(Total_deaths as int))as TotalDeathCount
FROM  PortfolioProject..CovidDeaths$
Where continent is not null
Group by Continent
order by TotalDeathCount desc


--looking at global numbers

SELECT  date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths$
where continent is not null
Group by date
order by 1,2

--Looking at total population vs Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
JOin PortfolioProject..CovidVaccinations$ vac
ON dea.location = vac.Location
and dea.date = vac.date
Where dea.Continent is not null
order by 1,2

--USE CTE

WITH PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
JOin PortfolioProject..CovidVaccinations$ vac
ON dea.location = vac.Location
and dea.date = vac.date
Where dea.Continent is not null
)
SELECT * , (RollingPeopleVaccinated/Population)*100
From PopvsVac


---Temp Table
Drop table if exists #PercentPopulationVaccination

Create Table #PercentPopulationVaccination
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
new_vaccination numeric,
population numeric,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccination


SELECT * , (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccination

--Creating view for visualizations

Create View PercentPopulationVaccination as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths$ dea
JOin PortfolioProject..CovidVaccinations$ vac
ON dea.location = vac.Location
and dea.date = vac.date
Where dea.Continent is not null