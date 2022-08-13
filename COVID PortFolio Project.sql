Select *
From NewPortFolioProject..CovidDeaths$
where continent is not null
Order by 3,4


--Select *
--From NewPortFolioProject..CovidVaccinations$
--Order by 3,4

--Selecting data required for my analysis

Select Location, date, total_cases,new_cases total_deaths,population
From NewPortFolioProject..CovidDeaths$,
Order by 1,2

--Analysing total_deaths/total_cases

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as PercentageDeathChance
From NewPortFolioProject..CovidDeaths$
Where location = 'Italy'
Order by 1,2

---Countries with Highest Infection Rate Compared with to Population

Select Location, Population, Max(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentageInfectedPopulation
From NewPortFolioProject..CovidDeaths$

where continent is not null
Group by location , population
Order by PercentageInfectedPopulation desc

--Countries with Highest Death Count per Population
-- Please note the total_death Columns of nvarchar(255), this has to be converted to interger by (Casting method).

Select Location, Max(cast(total_deaths as int)) as TotalDeathCount
From NewPortFolioProject..CovidDeaths$

where continent is not null
Group by location
Order by TotalDeathCount desc


--CONTINENT with Highest Death Count per Population

Select continent , Max(cast(total_deaths as int)) as TotalDeathCount
From NewPortFolioProject..CovidDeaths$

where continent is not null
Group by continent
Order by TotalDeathCount desc


-- Analysing Global Numbers


Select date, SUM(New_cases), SUM(Cast(new_deaths as int)), SUM(Cast(new_deaths as int))/SUM(New_cases)*100 as PecentageDeath
From NewPortFolioProject..CovidDeaths$
-- Where location = 'Italy'

where continent is not null
Group by date
Order by 1,2


---Total cases

Select SUM(New_cases), SUM(Cast(new_deaths as int)) as total_death, SUM(Cast(new_deaths as int))/SUM(New_cases)*100 as PecentageDeath
From NewPortFolioProject..CovidDeaths$
-- Where location = 'Italy'

where continent is not null
---Group by date
Order by 1,2


---Now From Covidvacination Data

Select *
From NewPortFolioProject..CovidDeaths$  Dea
Join NewPortFolioProject..CovidVaccinations$  Vac

On  Dea.location = Vac.location
   and Dea.date	 = Vac.date


---Total World Population vs vaccinated

Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations
From NewPortFolioProject..CovidDeaths$  Dea
Join NewPortFolioProject..CovidVaccinations$  Vac

On  Dea.location = Vac.location
   and Dea.date	 = Vac.date
 
 Where Dea.continent is not null
 Order by 2, 3


--- Summation new vaccination by day and location 

 Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, 
 SUM(Cast(Vac.new_vaccinations as int)) Over (Partition by Dea.location Order by Dea.location, Dea.Date ROWS UNBOUNDED PRECEDING ) as SumOfPeopleVaccinatedDaily

From NewPortFolioProject..CovidDeaths$  Dea
Join NewPortFolioProject..CovidVaccinations$  Vac

On  Dea.location = Vac.location
   and Dea.date	 = Vac.date
 
 Where Dea.continent is not null
 Order by 2, 3

 --- Percentage of new people vaccination by day and location(i.e  (SumOfPeopleVaccinatedDaily/Population )*100 )

 --- By Using CTE.


 With PopvsVac ( continent, location, date, Population, new_vaccination, SumOfPeopleVaccinatedDaily)
 as
 (
  Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, 
 SUM(Cast(Vac.new_vaccinations as int)) Over (Partition by Dea.location Order by Dea.location, Dea.Date ROWS UNBOUNDED PRECEDING ) as SumOfPeopleVaccinatedDaily

From NewPortFolioProject..CovidDeaths$  Dea
Join NewPortFolioProject..CovidVaccinations$  Vac

On  Dea.location = Vac.location
   and Dea.date	 = Vac.date
 
 Where Dea.continent is not null
-- Order by 2, 3
 ) 
Select * , ((SumOfPeopleVaccinatedDaily/Population)*100 ) As PercentageOfPeopleVaccinatedDaily
From PopvsVac


---Creating Views For Analysis

Create view PercentageOfPeopleVaccinatedDaily as

Select Dea.continent, Dea.location, Dea.date, Dea.population, Vac.new_vaccinations, 
 SUM(Cast(Vac.new_vaccinations as int)) Over (Partition by Dea.location Order by Dea.location, Dea.Date ROWS UNBOUNDED PRECEDING ) as SumOfPeopleVaccinatedDaily

From NewPortFolioProject..CovidDeaths$  Dea
Join NewPortFolioProject..CovidVaccinations$  Vac

On  Dea.location = Vac.location
   and Dea.date	 = Vac.date
 
 Where Dea.continent is not null
-- Order by 2, 3

Create View TotalDeathCount  as

Select continent , Max(cast(total_deaths as int)) as TotalDeathCount
From NewPortFolioProject..CovidDeaths$

where continent is not null
Group by continent
--Order by TotalDeathCount desc


Create view PertageDeath as

Select date, SUM(New_cases) as TotalNewCases, SUM(Cast(new_deaths as int)) as TotalNewDeath, SUM(Cast(new_deaths as int))/SUM(New_cases)*100 as PecentageDeath
From NewPortFolioProject..CovidDeaths$
-- Where location = 'Italy'

where continent is not null
Group by date
Order by 1,2