select l.P_ID,l.MyUnknownColumn,p.PName,l.Difficulty
from player_details p
join level_details2 l
on p.P_ID=l.P_ID where l.level = 0
order by p.P_ID desc

select p.L1_Code,AVG(l.Kill_Count) AS Avg_Kills
from player_details p
join level_details2 l
on p.P_ID=l.P_ID
where l.Lives_Earned=2 and l.Stages_crossed >=3
group by p.L1_Code

SELECT Difficulty AS Diff_Level, COUNT(Stages_crossed) AS Total_Stages
FROM level_details2
WHERE Level = 2 AND Dev_ID LIKE 'zm%'
GROUP BY Difficulty
ORDER BY Total_Stages DESC

select P_ID,count(distinct(Start_datetime)) as Unique_Dates
from level_details2
group by P_ID
Having count(distinct(Start_datetime)) > 1
order by Unique_Dates desc

select P_ID,Level,Sum(kill_Count) as Total,AVG(kill_Count) AS Avg_kills
from level_details2
where Difficulty='Medium'
group by P_ID,Level
having Sum(kill_Count)>AVG(kill_Count)
order by Level desc

SELECT Level, L1_Code, L1_Code,
(SELECT SUM(Lives_Earned) FROM level_details2 WHERE Level <= l.Level) AS totallives
FROM player_details p
JOIN level_details2 l ON p.P_ID = l.P_ID
WHERE l.Level <> 0

select Score,MyUnknownColumn,ROW_NUMBER() over (partition by MyUnknownColumn order by Score) as rownum
from level_details2
select Score,MyUnknownColumn,RANK() over (order by Score) as Rank,
DENSE_RANK() over(order by Score) as rownum
from level_details2
select top 3 MyUnknownColumn,Score,Difficulty,
RANK() over (partition by MyUnknownColumn order by Score) as DENCERank,
ROW_NUMBER() over (partition by MyUnknownColumn order by Score) as rownum
from level_details2

select l.DEV_ID, MIN(l.start_datetime) AS first_login_datetime
from level_details2 l
JOIN player_details p ON p.P_ID = l.P_ID
GROUP BY l.Dev_ID

select top 5 Dev_ID,Score,Difficulty,
RANK() over (partition by Difficulty order by Score)as Rank,
DENSE_RANK() over (partition by Difficulty order by Score) as DENCERank,
ROW_NUMBER() over (partition by Difficulty order by Score) as rownum
from level_details2

select p.P_ID,p.PNAME,l.Dev_ID, MIN(l.start_datetime)over(partition by p.P_ID) AS
first_login_datetime
from player_details p
join level_details2 l on p.P_ID=l.P_ID

select P.PName,L.start_datetime,
SUM(L.kill_count) OVER (PARTITION BY P.P_ID ORDER BY L,start_datetime) AS TOTAL_Games,
DENSE_RANK() OVER (PARTITION BY P.P_ID ORDER BY L,start_datetime) AS Rank
FROM player_details P
JOIN level_details2 L ON P.P_ID = L.P_ID

select P.PName,L.start_datetime,sum(L.kill_count) AS TOTAL_Games
from player_details p
join level_details2 l
on p.P_ID=l.P_ID
group by P.PName,L.start_datetime
order y TOTAL_Games

SELECT start_datetime, SUM(Stages_crossed) OVER (ORDER By start_datetime) AS 
cumulative_stages
From Level_deatails2

WITH RankedLevels AS (
select*,
ROW_NUMBER() OVER (PARTITION BY P_ID ORDER BY satrt_datetime DESC) AS rn FROM level_details2
)
SELECT P_ID, start_datetime,
SUM(Stages_crossed) OVER (PARTITION BY P_ID ORDER BY start_datetime ROWS BETWEEN
UNBOUNDER PROCEDING AND ! PRECEING) AS total_stages
FROM RankedLevels
Where rn > 1

select top 3 Dev_ID,P_ID,SUM(Score) as score 
from level_details2
group by Dev_ID,P_ID
order by score desc

WITH PlayerScores AS(
SELECT P_ID, SUM(Score) AS Total_Score
FROM level_details2
GROUP BY P_ID
),
AvgScores AS(
SELECT AVG(Total_Score) AS Avg_Score
FROM PlayerScores)
SELECT ps.P_ID,ps.Total_Score, a.Avg_Score
FROM PlayerScores ps, AvgScores a 
WHERE ps.Total_Score > 0.5* a.Avg_Score