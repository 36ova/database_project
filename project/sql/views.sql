-- (1) Представление игроков: роль, команда, регион, показатели
CREATE VIEW pro_league_database.player_info AS
SELECT nickname, p_role, t_name, region, n_wins, n_losses
FROM pro_league_database.player
        LEFT JOIN pro_league_database.player_x_team USING (player_id)
        LEFT JOIN pro_league_database.team USING (team_id);

SELECT *
FROM pro_league_database.player_info;


-- (2) Представление личной информации игроков: имя, страна, возраст, ник, команда, винрейт
CREATE VIEW pro_league_database.player_personal_info AS
SELECT p_name, country, age, nickname, t_name, CAST(n_wins AS float) / CAST((n_wins + n_losses) AS float) winrate
FROM pro_league_database.player
        LEFT JOIN pro_league_database.player_x_team USING (player_id)
        LEFT JOIN pro_league_database.team USING (team_id);

SELECT *
FROM pro_league_database.player_personal_info;


-- (3) Представление команд: название, регион, количество игроков, винрейт
CREATE VIEW pro_league_database.team_info AS
SELECT t_name, region, COUNT(player_id) players, CAST(n_wins AS float) / CAST((n_wins + n_losses) AS float) winrate
FROM pro_league_database.player
        RIGHT JOIN pro_league_database.player_x_team USING (player_id)
        RIGHT JOIN pro_league_database.team USING (team_id)
GROUP BY t_name, region, n_wins, n_losses
ORDER BY winrate DESC;

SELECT *
FROM pro_league_database.team_info;


-- (4) Представление стран: название, регион, количество игроков, винрейт
CREATE VIEW pro_league_database.country_info AS
WITH team_extended AS (
        SELECT team_id, t_name, region, n_wins, n_losses, CAST(n_wins AS float) / CAST((n_wins + n_losses) AS float) AS winrate
        FROM pro_league_database.team
    )
SELECT country, region, COUNT(player_id) players, AVG(winrate) avg_winrate
FROM pro_league_database.player
        LEFT JOIN pro_league_database.player_x_team USING (player_id)
        LEFT JOIN team_extended USING (team_id)
WHERE region IS NOT NULL
GROUP BY country, region
ORDER BY avg_winrate DESC;

SELECT *
FROM pro_league_database.country_info;


-- (5) Представление игроков с точки зрения контрактов:
-- никнейм, роль, винрейт, команда, регион, дата истечения контракта;
-- сортировка сначала по дате истечения контракта, потом по винрейту.
CREATE VIEW pro_league_database.contracts AS
WITH team_extended AS (
        SELECT team_id, t_name, region, n_wins, n_losses, CAST(n_wins AS float) / CAST((n_wins + n_losses) AS float) AS winrate
        FROM pro_league_database.team
    )
SELECT nickname, p_role, ROUND(CAST(winrate AS numeric), 3) winrate, t_name, region,
       (CASE WHEN contract_exp IS NULL THEN 'Free agent' ELSE CAST(exp_date AS VARCHAR) END)
FROM (
    SELECT nickname, p_role, t_name, contract_exp, region, winrate,
           (CASE WHEN contract_exp IS NULL THEN CURRENT_DATE ELSE contract_exp END) exp_date
    FROM pro_league_database.player
        LEFT JOIN pro_league_database.player_x_team USING (player_id)
        LEFT JOIN team_extended USING (team_id)
    ORDER BY exp_date, winrate DESC) subquery;

SELECT *
FROM pro_league_database.contracts;


-- (6) Представление игроков с точки зрения ролей в правильном порядке (от Top к Support)
-- никнейм, роль, винрейт, команда, регион, дата истечения контракта;
-- сортировка сначала по роли, потом по винрейту.
CREATE VIEW pro_league_database.roles AS
WITH team_extended AS (
        SELECT team_id, t_name, region, n_wins, n_losses, CAST(n_wins AS float) / CAST((n_wins + n_losses) AS float) AS winrate
        FROM pro_league_database.team
    )
SELECT nickname, p_role, ROUND(CAST(winrate AS numeric), 3) winrate, t_name, region,
       (CASE WHEN contract_exp IS NULL THEN 'Free agent' ELSE CAST(exp_date AS VARCHAR) END)
FROM (
    SELECT nickname, p_role, CASE WHEN p_role LIKE 'Top' THEN 0
                        WHEN p_role LIKE 'Jungle' THEN 1
                        WHEN p_role LIKE 'Mid' THEN 2
                        WHEN p_role LIKE 'Bot' THEN 3
                        WHEN p_role LIKE 'Support' THEN 4 END role, t_name, contract_exp, region, winrate,
           (CASE WHEN contract_exp IS NULL THEN CURRENT_DATE ELSE contract_exp END) exp_date
    FROM pro_league_database.player
        LEFT JOIN pro_league_database.player_x_team USING (player_id)
        LEFT JOIN team_extended USING (team_id)
    ORDER BY role, winrate DESC) subquery;

SELECT *
FROM pro_league_database.roles;