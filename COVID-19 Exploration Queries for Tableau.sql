


--Queries used for Tableau Project

-- 1. 

SELECT SUM(new_cases) total_cases, 
       SUM(CAST(new_deaths AS int)) total_deaths, 
       SUM(CAST(new_deaths AS int))/SUM(New_Cases) * 100 DeathPercentage
FROM Portfolio..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
	--GROUP BY date
	ORDER BY 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location

--SELECT SUM(new_cases) total_cases, 
         SUM(CAST(new_deaths AS int)) total_deaths, 
	 SUM(CAST(new_deaths AS int))/SUM(New_Cases) * 100 DeathPercentage
--FROM Portfolio..CovidDeaths
--WHERE location LIKE '%states%'
--WHERE location = 'World'
	--GROUP BY date
	--ORDER BY 1,2

-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT location, 
       SUM(CAST(new_deaths AS int)) TotalDeathCount
FROM Portfolio..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NULL
AND location NOT IN ('World', 'European Union', 'International')
	GROUP BY location
	ORDER BY TotalDeathCount DESC

-- 3.

SELECT location, 
       population, 
       MAX(total_cases) HighestInfectionCount, 
       MAX((total_cases/population)) * 100 PercentPopulationInfected
From Portfolio..CovidDeaths
--WHERE location LIKE '%states%'
	GROUP BY location, population
	ORDER BY PercentPopulationInfected DESC

-- 4.

SELECT location, 
       population, 
       date, 
       MAX(total_cases) HighestInfectionCount,  
       MAX((total_cases/population)) * 100 PercentPopulationInfected
FROM Portfolio..CovidDeaths
--WHERE location LIKE '%states%'
	GROUP BY location, population, date
	ORDER BY PercentPopulationInfected DESC

-- Queries I originally had, but excluded some because it created too long of video
-- Here only in case you want to check them out

-- 1.

SELECT dea.continent, 
       dea.location, 
       dea.date, 
       dea.population, 
       MAX(vac.total_vaccinations) RollingPeopleVaccinated
       --, (RollingPeopleVaccinated/population) * 100
FROM Portfolio..CovidDeaths dea
INNER JOIN Portfolio..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
	GROUP BY dea.continent, 
		 dea.location, 
		 dea.date, 
		 dea.population
	ORDER BY 1,2,3

-- 2.

SELECT SUM(new_cases) total_cases, 
       SUM(CAST(new_deaths AS int)) total_deaths, 
       SUM(CAST(new_deaths AS int))/SUM(New_Cases) * 100 DeathPercentage
From Portfolio..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
	--GROUP BY date
	ORDER BY 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location

--SELECT SUM(new_cases) total_cases, 
         SUM(CAST(new_deaths AS int)) total_deaths, 
	 SUM(CAST(new_deaths AS int))/SUM(New_Cases) * 100 DeathPercentage
--FROM Portfolio..CovidDeaths
--WHERE location LIKE '%states%'
--WHERE location = 'World'
	--GROUP BY date
	--ORDER BY 1,2

-- 3.

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT location, 
       SUM(CAST(new_deaths AS int)) TotalDeathCount
FROM Portfolio..CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NULL 
AND location NOT IN ('World', 'European Union', 'International')
	GROUP BY location
	ORDER BY TotalDeathCount DESC

-- 4.

SELECT location, 
       population, 
       MAX(total_cases) HighestInfectionCount, 
       MAX((total_cases/population)) * 100 PercentPopulationInfected
FROM Portfolio..CovidDeaths
--WHERE location LIKE '%states%'
	GROUP BY location, population
	ORDER BY PercentPopulationInfected DESC

-- 5.

--SELECT location, 
         date, 
	 total_cases,total_deaths, 
	 (total_deaths/total_cases) * 100 DeathPercentage
--FROM Portfolio..CovidDeaths
----WHERE location LIKE '%states%'
--WHERE continent IS NOT NULL
	--ORDER BY 1,2

-- took the above query and added population

SELECT location, 
       date, 
       population, 
       total_cases, 
       total_deaths
FROM Portfolio.CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
	ORDER BY 1,2

-- 6. 

WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, 
       dea.location, 
       dea.date, 
       dea.population, 
       vac.new_vaccinations, 
       SUM(CONVERT(int,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) RollingPeopleVaccinated
       --, (RollingPeopleVaccinated/population)*100
FROM Portfolio..CovidDeaths dea
INNER JOIN Portfolio..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
	--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population) * 100 PercentPeopleVaccinated
FROM PopvsVac

-- 7. 

SELECT location, 
       population,
       date, 
       MAX(total_cases) HighestInfectionCount, 
       MAX((total_cases/population)) * 100 PercentPopulationInfected
FROM Portfolio..CovidDeaths
--WHERE location LIKE '%states%'
	GROUP BY location, population, date
	ORDER BY PercentPopulationInfected DESC


