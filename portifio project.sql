/****** Script for SelectTopNRows command from SSMS  ******/


SELECT  *
  FROM [portifolie].[dbo].[CovidDeaths$]
  where [continent] is not null
  order by 3,4

  --Looking at total cases vs total deaths 
  --shows likelihood of daying if you contrract covid in your country

  SELECT [location],[date],[total_cases],[total_deaths],(total_deaths/total_cases)*100 as Deathperscentage
  
  FROM [portifolie].[exel2].[dbo. CovidDeathes]
  where location like '%canada%'
   order by 1,2


   ----looking at total cases vs populations 
   ---shows what percentage of population got covid

SELECT [location],[date],[total_cases],population,(population/total_cases)*100 as Deathperscentage
FROM [portifolie].[exel2].[dbo. CovidDeathes]
--where location like '%canada%'
order by 1,2


--looking ATAN countries with hihest infection rate compred to population
     

SELECT [location], [population],MAX([total_cases]) as Highestinfectioncount, MAX([total_cases]/[population])*100 as percentpopulationinfected
FROM [portifolie].[exel2].[dbo. CovidDeathes]
--where location like '%canada%'
group by  [location],[population] 
order by percentpopulationinfected desc

---showing the countries with highest death count per population


SELECT [location],MAX(cast([total_deaths] as int)) as TotalDeathCount
FROM [portifolie].[exel2].[dbo. CovidDeathes]
--where location like '%canada%'
 where [continent] is not null
group by  [location]
order by TotalDeathCount desc


  --LET'S BREAK THINGS DOWN BY CONTINENT

SELECT [continent],MAX(cast([total_deaths] as int)) as TotalDeathCount
FROM [portifolie].[dbo].[CovidDeaths$]
--where location like '%canada%'
 where [continent] is not null
group by  [continent]
order by TotalDeathCount desc

SELECT [location],MAX(cast([total_deaths] as int)) as TotalDeathCount
FROM [portifolie].[dbo].[CovidDeaths$]
--where location like '%canada%'
 where [continent] is null
group by  [location]
order by TotalDeathCount desc

--SHOWING CONTINENT WITH THE HIGHEST DEATH COUNT PER POPULATIONS 

SELECT [continent],MAX(cast([total_deaths] as int)) as TotalDeathCount
FROM [portifolie].[dbo].[CovidDeaths$]
--where location like '%canada%'
 where [continent] is not null
group by  [continent]
order by TotalDeathCount desc

--GLOBAL NUMBERS 

SELECT SUM([new_cases]) as total_cases, SUM (CAST([new_deaths] as int)) as total_deaths
,(SUM (CAST([new_deaths] as int))/SUM([new_cases]))*100 as Deathperscentage
FROM [portifolie].[dbo].[CovidDeaths$]
--where location like '%canada%'
where continent is not null
--Group by  [date]
Order by 1,2


--Looking ATAN total population vs vaccinations / use cte

--temp tabel

drop table if exists #RollingpeopleVaccinated
create table #RollingpeopleVaccinated
(
continent nvarchar(255),
location nvarchar (255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingpeopleVaccinated numeric ,

)
Insert into #RollingpeopleVaccinated
--WITH popvsvac (continent, location , date, population, New_vaccinations,RollingpeopleVaccinated)
--as
select dea.continent, dea.location , dea. date, dea.population, vac.New_vaccinations
,SUM( cast(vac.New_vaccinations as int)) OVER (partition by dea.location order by dea.location,
dea.Date) as RollingpeopleVaccinated
--,(RollingpeopleVaccinated/population)*100
from  [dbo].[CovidDeaths$] dea
join [dbo].[CovidVaccinations$] vac
	on dea .location = vac. location 
	and dea. date = vac. date 
where dea.continent is not null
--order by 2,3


select * ,(RollingpeopleVaccinated/population)*100
from #RollingpeopleVaccinated

Creating view to store data for 


create view precentpopulationVaccinated as
select dea.continent, dea.location , dea. date, dea.population, vac.New_vaccinations
,SUM( cast(vac.New_vaccinations as int)) OVER (partition by dea.location order by dea.location,
dea.Date) as RollingpeopleVaccinated
--,(RollingpeopleVaccinated/population)*100
from  [dbo].[CovidDeaths$] dea
join [dbo].[CovidVaccinations$] vac
	on dea .location = vac. location 
	and dea. date = vac. date 
where dea.continent is not null
--order by 2,3