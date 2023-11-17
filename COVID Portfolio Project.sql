
Select *
From PortfolioProject.dbo.CovidDeaths
Where continent is not null -- Where the location is the a continent and not country
Order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--Order by 3,4

-- Select Data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
Order by 1,2

-- Looking at Total Cases vs Total Deaths
-- Shows the likelihood of dying if you contract Covid in the Netherlands

Select location, date, total_cases, total_deaths, 
(total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location='Netherlands' AND continent is not null
Order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population get Covid

Select location, date, population, total_cases, 
(total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
-- Where location='Netherlands'
Order by 1,2

-- Looking at Coutries with Highest Infection Rate Compared to Population\

Select location, population, MAX(total_cases) as HighestInfectionCount, 
MAX((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
-- Where location='Netherlands'
Group by location, population
Order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

Select location, MAX(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- Where location='Netherlands'
Where continent is not null
Group by location
Order by TotalDeathCount desc

-- Breaking down by continent



-- Showing Continents with the Highest Death Count per Population

Select continent, MAX(Cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- Where location='Netherlands'
Where continent is not null
Group by continent
Order by TotalDeathCount desc

-- Global Numbers

Select date, SUM(new_cases) as total_cases, SUM(Cast(new_deaths as int)) as total_deaths, 
SUM(Cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
-- Where location='Netherlands'
Where continent is not null
Group by date
Order by 1,2

-- Looking at Total Population vs Vaccinations

-- Using CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) 
OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated)*100: How many people in the country are vaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac 
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)

Select *, (RollingpeopleVaccinated/Population)*100
From PopvsVac

-- Using Temp Table

Drop table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255), 
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) 
OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated)*100: How many people in the country are vaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac 
	On dea.location = vac.location 
	and dea.date = vac.date
--Where dea.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated

-- Creating View to Store Data for Later Visualization

USE PortfolioProject

Create View dbo.PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea. population, vac.new_vaccinations, 
SUM(CONVERT(int, vac.new_vaccinations)) 
OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
-- (RollingPeopleVaccinated)*100: How many people in the country are vaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac 
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3

Select *
From PercentPopulationVaccinated
