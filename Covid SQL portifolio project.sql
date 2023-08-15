

--covidDeaths 
Select * 
from project1..CovidDeaths --we are selecting all from covid from deaths
order by 3,4

----covidVaccinations 
Select * 
from project1..CovidVaccinationss--we are selecting all from covid from vaccinations 
order by 3,4



--Select Data that we are going to be using ("in excel is called filtering")

select location, date, total_cases, new_cases, total_deaths, population
from project1..CovidDeaths
order by 1, 2 --we want to oder by based off the location and the date

-- LOOKING AT TOTAL CASES VS TOTAL DEATHS
----How many cases do they have in this country 
----How many deaths 
----what is the percentage 

-- we want to know the percentege of people who are dying or who get infected 
--this shows the likely hold in you bla bla covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage -- naming the column deathP
from project1..CovidDeaths
where location like '%cyprus%' --#include country
order by 1, 2 --we want to oder by based off the location and the date


--LOOKING AT THE TOTAL CASES VS THE POPULATION
--shows what percentage of population got covid

select location, date,population, total_cases,  (total_cases/population)*100 as DeathPercentage -- naming the column deathP
from project1..CovidDeaths
where location like '%cyprus%' --#include 
order by 1, 2 --we want to oder by based off the location and the date


--LOOKING AT COUNTRIES WITH HIGHEST INFECTION RATE COMPARED TO POPULATION

select location,population, MAX(total_cases) as HighestInfectionCount ,   MAX((total_deaths/total_cases))*100 as PercentagePopulationInfected -- naming the column deathP
from project1..CovidDeaths
--where location like '%cyprus%' --#include 
GROUP BY location, population --#include  

order by PercentagePopulationInfected desc--we want to oder by based off the location and the date



-- showing countries with highest death count per population 

select location, MAX(cast(total_deaths as int)) as totalDeathCount --change cause of the data type
From project1..CovidDeaths
--where location like '%cyprus%' --#include 
where continent is not null --separating the continents from location
GROUP BY location --#include 
order by totalDeathCount desc--we want to oder by based off the location and the date


--LETS BREAK THINGS DOWN BY CONTINENT 

select location, MAX(cast(total_deaths as int)) as totalDeathCount --change cause of the data type
From project1..CovidDeaths
--where location like '%cyprus%' --#include 
where continent is not null --separating the continents from location
GROUP BY location --#include 
order by totalDeathCount desc--we want to oder by based off the location and the date

--extra
select continent,  MAX(cast(total_deaths as int)) as totalDeathCount
from project1..CovidDeaths
group by continent

--ORIGINAL DATA BASED OFF THE CONTINENT ETC

select continent, MAX(cast(total_deaths as int)) as totalDeathCount --change cause of the data type
From project1..CovidDeaths
--where location like '%cyprus%' --#include 
where continent is not null --separating the continents from location
GROUP BY continent --#include 
order by totalDeathCount desc--we want to oder by based off the location and the date


---SHOWING CONTINENTS WITH THE HIGHEST DEATH COUNT PER POPULATION
-- POINT OF VISUALISING IT
select continent, MAX(cast(total_deaths as int)) as totalDeathCount --change cause of the data type
From project1..CovidDeaths
--where location like '%cyprus%' --#include 
where continent is not null --separating the continents from location
GROUP BY continent --#include 
order by totalDeathCount desc--we 


---GLOBAL NUMBERS 

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as new_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From project1..CovidDeaths
--where location like '%cyprus%' --#include 
where continent is not null --separating the continents from location
group by date 
order by 1, 2


---EXTRA
select continent, SUM(total_deaths) as total_deaths,  SUM(total_cases) as total_cases,
SUM(total_deaths)+Sum(total_cases) as total_deaths_plus_cases, SUM(total_deaths)/Sum(total_cases)*100 as total_D_C_percentage
from project1..CovidDeaths
where continent is not null
group by continent
order by 4 desc


-- EXTRA GLOBAL NUMBERS

select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as new_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From project1..CovidDeaths
--where location like '%cyprus%' --#include 
where continent is not null --separating the continents from location
group by date 
order by 1, 2


---- IF WE WNT OT GET JUST THE TOTALS
--T
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From project1..CovidDeaths
--where location like '%cyprus%' --#include 
where continent is not null --separating the continents from location
--group by date 
order by 1, 2


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--VACCINATIONS
--we want to join the two tables together 

select * 
from project1..CovidDeaths dea -- just simplifing the name to dea
join project1..CovidVaccinationss vac -- just simplifing the name to dea
on dea.location = vac.location
and dea.date = vac.date



--LOIKING AT TOTAL POPULATION VS VACCINATIONS
-- to show that you can do something 

select dea.continent, dea.location, dea.date,dea.population, vac.total_vaccinations as total_vaccinations -- should be new_vaccinations etc
from project1..CovidDeaths dea -- just simplifing the name to dea
join project1..CovidVaccinationss vac -- just simplifing the name to dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent  is not null
order by 2,3


--EXTRA EXPERIMENTAL


select dea.continent, dea.location, dea.date,dea.population, vac.total_vaccinations as total_vaccinations -- should be new_vaccinations etc
,SUM(vac.total_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as rolling_total_people_vacccinated  --#include partioning 
from project1..CovidDeaths dea -- just simplifing the name to dea
join project1..CovidVaccinationss vac -- just simplifing the name to dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent  is not null
order by 2,3


--EXTRA CTE

With PopvsVac (continent, location, date, population, total_vaccinations, rolling_total_people) 
as 
(

select dea.continent, dea.location, dea.date,dea.population, vac.total_vaccinations as total_vaccinations -- should be new_vaccinations etc
,SUM(vac.total_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as rolling_total_people_vacccinated  --#include partioning 
from project1..CovidDeaths dea -- just simplifing the name to dea
join project1..CovidVaccinationss vac -- just simplifing the name to dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent  is not null
--order by 2,3

)
select *, (rolling_total_people/population)*100
from PopvsVac


---TEMPT TABLE 
--to create the table

Create table #percentPopulationVaccinated 
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
rolling_total_people numeric,
)

insert into #percentPopulationVaccinated
select dea.continent, dea.location, dea.date,dea.population, vac.total_vaccinations as total_vaccinations -- should be new_vaccinations etc
,SUM(vac.total_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as rolling_total_people_vacccinated  --#include partioning 
from project1..CovidDeaths dea -- just simplifing the name to dea
join project1..CovidVaccinationss vac -- just simplifing the name to dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent  is not null
--order by 2,3
 
 select *, (rolling_total_people/population)*100
from #percentPopulationVaccinated



---TEMPT TABLE 
--to drop the table if already exists 

DROP Table if exists #percentPopulationVaccinated

Create table #percentPopulationVaccinated 
(
continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
rolling_total_people numeric,
)

insert into #percentPopulationVaccinated
select dea.continent, dea.location, dea.date,dea.population, vac.total_vaccinations as total_vaccinations -- should be new_vaccinations etc
,SUM(vac.total_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as rolling_total_people_vacccinated  --#include partioning 
from project1..CovidDeaths dea -- just simplifing the name to dea
join project1..CovidVaccinationss vac -- just simplifing the name to dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent  is not null
--order by 2,3
 
 select *, (rolling_total_people/population)*100
from #percentPopulationVaccinated


---creating our view to store data for later visualizations 

create view	percentagePopulationVaccinations as 
select dea.continent, dea.location, dea.date,dea.population, vac.total_vaccinations as total_vaccinations -- should be new_vaccinations etc
,SUM(vac.total_vaccinations) OVER (Partition by dea.location order by dea.location, dea.date) as rolling_total_people_vacccinated  --#include partioning 
from project1..CovidDeaths dea -- just simplifing the name to dea
join project1..CovidVaccinationss vac -- just simplifing the name to dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent  is not null
--order by 2,3


 select *, (rolling_total_people/population)*100
from #percentPopulationVaccinated

--the views can be used to connect some visuals, save it and upload to 















------------------------------------------------------------
--1
--T
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From project1..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2
--CTRL+SHIFT+C

--2
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From project1..CovidDeaths
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



----extra
--Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
--From project1..CovidDeaths
----Where location like '%states%'
--Where continent is not null 
--Group by location
--order by TotalDeathCount desc

--3
select location,population, MAX(total_cases) as HighestInfectionCount ,   MAX((total_deaths/total_cases))*100 as PercentagePopulationInfected -- naming the column deathP
from project1..CovidDeaths
--where location like '%cyprus%' --#include 
GROUP BY location, population --#include  

order by PercentagePopulationInfected desc--we want to oder by based off the location and the date

--4
Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From project1..CovidDeaths
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc

---------------x