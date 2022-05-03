-- (1) GROUP BY + HAVING
SELECT country, COUNT(player_id) cnt
FROM pro_league_database.player
    LEFT JOIN pro_league_database.player_x_team USING (player_id)
    LEFT JOIN pro_league_database.team USING (team_id)
GROUP BY country, region
HAVING region LIKE 'EU'
ORDER BY cnt DESC;

-- В результате запроса будет выведен список количества игроков в кадой
-- стране в порядке убывания, при этом учитываются только игроки из
-- Европейских команд.
-- Будут выведены: страна, количество игроков.


-- (2) ORDER BY
SELECT nickname, p_role, t_name,
       (CASE WHEN contract_exp IS NULL THEN 'Free agent' ELSE CAST(exp_date AS VARCHAR) END)
FROM (
    SELECT nickname, p_role, t_name, contract_exp,
           (CASE WHEN contract_exp IS NULL THEN CURRENT_DATE ELSE contract_exp END) exp_date
    FROM pro_league_database.player
        LEFT JOIN pro_league_database.player_x_team USING (player_id)
        LEFT JOIN pro_league_database.team USING (team_id)
    ORDER BY exp_date) subquery;

-- В результате запроса будет выведен список всех игроков в порядке
-- окончания действия их контрактов, причем игроки без команд помечены как
-- "Free agent" и выводятся в начале списка.
-- Будут выведены: игрок, роль, команда, дата окончания действия контракта.


-- (3) func() OVER(): PARTITION BY
SELECT nickname, country, AVG(age) OVER (PARTITION BY country) AS avg_age
FROM pro_league_database.player
        LEFT JOIN pro_league_database.player_x_team USING (player_id)
        LEFT JOIN pro_league_database.team USING (team_id);

-- В результате запроса будет выведен список всех игроков, их стран и
-- средний возраст игроков из этой страны.
-- Будут выведены: страна, игрок, средний возраст.


-- (4) func() OVER(): ORDER BY
SELECT t_name, region, winrate, AVG(winrate) OVER (ORDER BY team_id) AS avg
FROM (
    SELECT t_name, team_id, region, CAST(n_wins AS float) / CAST((n_wins + n_losses) AS float) AS winrate
    FROM pro_league_database.team
     ) subuquery;

-- В результате запроса будет выведен список всех команд, их винрейт,
-- средний винрейт первых k команд начиная с первой.
-- Будут выведены: команда, регион, винрейт, средний винрейт.


-- (5) PARTITION BY + ORDER BY
WITH team_extended AS (
        SELECT team_id, t_name, region, n_wins, n_losses, CAST(n_wins AS float) / CAST((n_wins + n_losses) AS float) AS winrate
        FROM pro_league_database.team
    )

SELECT exp_date, ROW_NUMBER() OVER(PARTITION BY exp_date ORDER BY winrate), nickname, t_name, winrate
FROM (
    SELECT nickname, t_name, winrate,
           (CASE WHEN contract_exp IS NULL THEN CURRENT_DATE ELSE contract_exp END) exp_date
    FROM pro_league_database.player
        LEFT JOIN pro_league_database.player_x_team USING (player_id)
        LEFT JOIN team_extended USING (team_id)
     ) AS T;

-- Ранжируем игроков по дате истечения срока контракта, сортируя внутри групп по
-- винрейту их команд.
-- Будут выведены: дата истечения срока контракта, номер игрока, никнейм, винрейт.


-- (6) все 3 типа функций
WITH team_extended AS (
        SELECT team_id, t_name, region, n_wins, n_losses, CAST(n_wins AS float) / CAST((n_wins + n_losses) AS float) AS winrate
        FROM pro_league_database.team
    ),
    sorted_countries AS (
        SELECT country, COUNT(nickname) players, AVG(winrate) avg_winrate
        FROM (
            SELECT nickname, t_name, country, winrate
            FROM pro_league_database.player
                LEFT JOIN pro_league_database.player_x_team USING (player_id)
                LEFT JOIN team_extended USING (team_id)
            ) AS T
        WHERE t_name IS NOT NULL
        GROUP BY country
        ORDER BY avg_winrate DESC
    )

SELECT DENSE_RANK() OVER (ORDER BY avg_winrate DESC) rank, country, players, avg_winrate,
       ROUND(CAST(avg_winrate - LEAD(avg_winrate) OVER (ORDER BY avg_winrate DESC) AS numeric), 3) diff
FROM sorted_countries;

-- По каждой стране считаем средний винрейт игроков, состоящих в какой-либо команде.
-- Для каждой страны считаем отрыв от предыдущей по винрейту стране.
-- Ранжируем страны без разрыва в нумерации по их результатам.
-- Будут выведены: "ранг" страны, страна, кол-во учтенных игроков, средний винрейт, отрыв в винрейте.