Select *
From PortfolioProject..CovidVaccinations
order by 3,4



Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2



----Looking at total_cases vs total_deaths to study & understand the fatality of this new disease 

Select location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as DeathPercentage
From PortfolioProject..CovidDeaths
where location like '%desh%'
order by 1,2



----Studying the relevance of total cases with population

Select location, date, total_cases, population, ((total_cases/population)*100) as CasesPercentage
From PortfolioProject..CovidDeaths
where location like '%desh%'
order by 1,2



--Looking at the countries with highest infection rate

Select location, max(total_cases) as HighestInfectionCount, population, max((total_cases/population))*100 as HighestInfectionPercentage
From PortfolioProject..CovidDeaths
Group by location, population
order by HighestInfectionPercentage desc


--Looking for the countries with Highest Death Count per Population

Select location, max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths
Where continent is not null
Group by location
order by HighestDeathCount desc



-- Let's see this data by continent

Select location, max(cast(total_deaths as int)) as HighestDeathCount
From PortfolioProject..CovidDeaths
Where continent is null
Group by location
order by HighestDeathCount desc



--GLOBAL NUMBERS

Select date, sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where continent is not null
group by date
order by 1,2



--Comperative study of vaccination with total population

Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
order by 1,2,3



---Checking the vaccination drive with cumulative comparison

Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint))  
over (partition by dea.location order by dea.location, dea.date) as Cumulative_Vaccinations
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
order by 1,2,3





---Temp Table

DROP Table if exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
Cumulative_vaccinations numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint))  
over (partition by dea.location order by dea.location, dea.date) as Cumulative_Vaccinations
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

Select *, (Cumulative_vaccinations/Population)*100 as PCVPP
From #PercentPopulationVaccinated





--Create View to store data for later visualization

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as bigint))  
over (partition by dea.location order by dea.location, dea.date) as Cumulative_Vaccinations
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
   on dea.location = vac.location
   and dea.date = vac.date
where dea.continent is not null

select * 
from PercentPopulationVaccinated