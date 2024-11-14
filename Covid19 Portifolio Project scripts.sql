Select *
From PortifolioProject.dbo.CovidDeaths
Order by 3,4

--Select *
--From PortifolioProject.dbo.CovidVaccination
--Order by 3,4

--Data gone be used
Select location,date,total_cases,new_cases,total_deaths,population
From PortifolioProject.dbo.CovidDeaths
Order by 1,2

--Looking Total case vs Total death
--This show  percentage of death from Total cases
Select location,date,total_cases,total_deaths,((total_deaths/total_cases)*100) as Death_Percentage
From PortifolioProject.dbo.CovidDeaths
Where location like '%States%'
Order by 1,2

--Looking Total case vs Population
--Show percentage of popuation get covid
Select location,date,total_cases,Population,((total_cases/population)*100) as PercentageInfection_rate
From PortifolioProject.dbo.CovidDeaths
--Where location like '%States%'
Order by 1,2

--Country with high infection rate compare to population 
Select location,MAX(total_cases) AS HighestInfectionCount,Population,MAX((total_cases/population)*100) as PercentageInfection_rate
From PortifolioProject.dbo.CovidDeaths
Group by location,population
Order by PercentageInfection_rate desc

--Country with highest death over population
Select location,MAX(cast(total_deaths as int)) AS MaximuDeath
From PortifolioProject.dbo.CovidDeaths
Where  continent is not null
Group by location
Order by MaximuDeath desc

--Breaking things by Continent
--Continent with highest death count
Select continent,MAX(cast(total_deaths as int)) AS MaximuDeath
From PortifolioProject.dbo.CovidDeaths
Where  continent is not null
Group by continent


--Death rate in each date
Select date,Sum(new_cases) as Total_cases,Sum(cast(new_deaths as int))as Total_Deaths,((Sum(cast(new_deaths as int))/Sum(new_cases))*100) AS PercentageDeathRate
From PortifolioProject.dbo.CovidDeaths
Where continent is not null
Group by date
Order by 1,2

--Global Number
Select Sum(new_cases) as Total_cases,Sum(cast(new_deaths as int))as Total_Deaths,((Sum(cast(new_deaths as int))/Sum(new_cases))*100) AS PercentageDeathRate
From PortifolioProject.dbo.CovidDeaths
Where continent is not null
Order by 1,2

--CovidVaccination table
Select *
From PortifolioProject.dbo.CovidVaccination
Order by 3,4
 
--Join CovidDeath table and CovidVaccination table
Select *
From PortifolioProject.dbo.CovidDeaths Dea
Inner Join PortifolioProject.dbo.CovidVaccination Vac
  On Dea.location=Vac.location
  and Dea.date=Vac.date
Order by 3,4

--Looking Total population VS Vaccination
Select dea.continent,dea.location,dea.date,dea.population,Vac.new_vaccinations
From PortifolioProject.dbo.CovidDeaths Dea
Inner Join PortifolioProject.dbo.CovidVaccination Vac
  On Dea.location=Vac.location
  and Dea.date=Vac.date
Where  dea.continent is not null
Order by 2,3

--Total of Vacination in particular location
Select dea.continent,dea.location,dea.date,dea.population,cast(Vac.new_vaccinations as int) as new_Vacination,
SUM(cast(Vac.new_vaccinations as int)) OVER (Partition by dea.location Order by  dea.location,dea.date ) as RollingPeopleVaccinated
--((RollingPeopleVaccinated/dea.population)*100) as VacciantedRatePercentage
From PortifolioProject.dbo.CovidDeaths Dea
Inner Join PortifolioProject.dbo.CovidVaccination Vac
  On Dea.location=Vac.location
  and Dea.date=Vac.date
Where  dea.continent is not null
Order by 2,3

--using CTE
With PopVsVac (Continent,location,date,population,new_Vacination,RollingPeopleVaccinated)
as (
Select dea.continent,dea.location,dea.date,dea.population,cast(Vac.new_vaccinations as int) as new_Vacination,
SUM(cast(Vac.new_vaccinations as int)) OVER (Partition by dea.location Order by  dea.location,dea.date ) as RollingPeopleVaccinated
--((RollingPeopleVaccinated/dea.population)*100) as VacciantedRatePercentage
From PortifolioProject.dbo.CovidDeaths Dea
Inner Join PortifolioProject.dbo.CovidVaccination Vac
  On Dea.location=Vac.location
  and Dea.date=Vac.date
Where  dea.continent is not null

)

Select *,(RollingPeopleVaccinated/population)*100
FROM PopVsVac

--Using TEMP TABLE 
DROP TABLE IF EXISTS #PopulationVaccinated
CREATE TABLE #PopulationVaccinated(
Continent varchar(200),
Location Varchar(200),
Date datetime,
Population numeric,
New_Vaccination numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PopulationVaccinated
Select dea.continent,dea.location,dea.date,dea.population,cast(Vac.new_vaccinations as int) as new_Vacination,
SUM(cast(Vac.new_vaccinations as int)) OVER (Partition by dea.location Order by  dea.location,dea.date ) as RollingPeopleVaccinated
--((RollingPeopleVaccinated/dea.population)*100) as VacciantedRatePercentage
From PortifolioProject.dbo.CovidDeaths Dea
Inner Join PortifolioProject.dbo.CovidVaccination Vac
  On Dea.location=Vac.location
  and Dea.date=Vac.date
Where  dea.continent is not null
Order by 2,3


Select *,(RollingPeopleVaccinated/population)*100
FROM #PopulationVaccinated

Create View PopulationVaccinated 
Select dea.continent,dea.location,dea.date,dea.population,cast(Vac.new_vaccinations as int) as new_Vacination,
SUM(cast(Vac.new_vaccinations as int)) OVER (Partition by dea.location Order by  dea.location,dea.date ) as RollingPeopleVaccinated
--((RollingPeopleVaccinated/dea.population)*100) as VacciantedRatePercentage
From PortifolioProject.dbo.CovidDeaths Dea
Inner Join PortifolioProject.dbo.CovidVaccination Vac
  On Dea.location=Vac.location
  and Dea.date=Vac.date
Where  dea.continent is not null
--Order by 2,3








