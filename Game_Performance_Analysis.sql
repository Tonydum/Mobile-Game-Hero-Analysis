SELECT TOP (1000) [hero_name]
      ,[role]
      ,[defense_overall]
      ,[offense_overall]
      ,[skill_effect_overall]
      ,[difficulty_overall]
      ,[movement_spd]
      ,[magic_defense]
      ,[mana]
      ,[hp_regen]
      ,[physical_atk]
      ,[physical_defense]
      ,[hp]
      ,[attack_speed]
      ,[mana_regen]
      ,[win_rate]
      ,[pick_rate]
      ,[ban_rate]
      ,[release_year]
  FROM [MyProject].[dbo].[heroes$]


SELECT hero_name, movement_spd, magic_defense, physical_atk, physical_defense, attack_speed
FROM heroes$
WHERE movement_spd >= 270;




---EDA
---provides a basic overview of each hero role, including the number of heroes in each role and the average win and pick rates.
SELECT role, COUNT(*) AS hero_count, AVG(CAST(win_rate AS FLOAT)) AS average_win_rate, 
AVG(CAST(pick_rate AS FLOAT)) AS average_pick_rate
FROM heroes$
GROUP BY role;

---to understand how hero performance (win and pick rates) has evolved over different release years.
SELECT release_year, AVG(CAST(win_rate AS FLOAT)) AS avg_win_rate, AVG(CAST(pick_rate AS FLOAT)) AS avg_pick_rate
FROM heroes$
GROUP BY release_year;


---identifies heroes with win rates significantly above or below the average
SELECT hero_name, win_rate, pick_rate, release_year
FROM heroes$
WHERE win_rate > (SELECT AVG(CAST(win_rate AS FLOAT)) FROM heroes$) + (SELECT STDEV(CAST(win_rate AS FLOAT)) FROM heroes$)
OR win_rate < (SELECT AVG(CAST(win_rate AS FLOAT)) FROM heroes$) - (SELECT STDEV(CAST(win_rate AS FLOAT)) FROM heroes$);


---analyzing how the difficulty level of heroes relates to their win and pick rates.
SELECT difficulty_overall, AVG(CAST(win_rate AS FLOAT)) AS avg_win_rate, AVG(CAST(pick_rate AS FLOAT)) AS avg_pick_rate
FROM heroes$
GROUP BY difficulty_overall
ORDER BY avg_win_rate DESC, avg_pick_rate;


---determines the popularity of each role based on the number of heroes in each category.
SELECT role, COUNT(*) AS count
FROM heroes$ 
GROUP BY role
ORDER BY count DESC;


---Business Questions:

---1. Hero Balance Analysis:
CREATE VIEW HeroBalance AS
SELECT hero_name, win_rate
FROM heroes$
WHERE win_rate > (SELECT AVG(CAST(win_rate AS FLOAT)) + STDEV(CAST(win_rate AS FLOAT)) FROM heroes$)
OR win_rate < (SELECT AVG(CAST(win_rate AS FLOAT)) - STDEV(CAST(win_rate AS FLOAT)) FROM heroes$);



---2. Player Preference Insights:
-- Most Picked Heroes
CREATE VIEW MostPickedHero 
AS SELECT TOP 5 hero_name, pick_rate
FROM heroes$
ORDER BY pick_rate DESC;

-- Least Picked Heroes
CREATE VIEW LeastPickedHero AS
SELECT TOP 5 hero_name, pick_rate
FROM heroes$
ORDER BY pick_rate;


---3. Meta Game Trends:
CREATE VIEW MetaGameTrend AS
SELECT release_year, AVG(CAST(pick_rate AS FLOAT)) AS avg_pick_rate, 
AVG(CAST(win_rate AS FLOAT)) AS avg_win_rate
FROM heroes$
GROUP BY release_year;


---4. Role Popularity and Performance:
-- Average Win Rate by Role
CREATE VIEW AverageWinRate AS 
SELECT role, AVG(CAST(win_rate AS FLOAT)) AS avg_win_rate
FROM heroes$
GROUP BY role;

-- Role Popularity
CREATE VIEW RolePopularity AS 
SELECT role, COUNT(*) AS hero_count
FROM heroes$
GROUP BY role;

---5. Hero Complexity vs. Performance:
CREATE VIEW HeroComplexity AS 
SELECT difficulty_overall, AVG(CAST(win_rate AS FLOAT)) AS avg_win_rate, AVG(CAST(pick_rate AS FLOAT)) AS avg_pick_rate
FROM heroes$
GROUP BY difficulty_overall;



---6. Impact of Ban Rate on Hero Usage:
CREATE VIEW BanRate AS 
SELECT ban_rate, AVG(CAST(pick_rate AS FLOAT)) AS avg_pick_rate, AVG(CAST(win_rate AS FLOAT)) AS avg_win_rate
FROM heroes$
GROUP BY ban_rate;
