-- Хранимые процедуры

-- (1) Функция, добавляющая информацию о новом матче: необходимо передать название
-- соревнования, 2 команды и номер выигравшей команды (1 если синяя, 2 если красная).
CREATE OR REPLACE FUNCTION pro_league_database.add_match(split_n VARCHAR, team_blue VARCHAR, team_red VARCHAR, winner INTEGER) RETURNS void AS $$
DECLARE
    blue_id INTEGER := (SELECT team_id FROM pro_league_database.team WHERE t_name = team_blue);
    red_id INTEGER := (SELECT team_id FROM pro_league_database.team WHERE t_name = team_red);
BEGIN
    IF (winner = 1) THEN
        winner = blue_id;
    ELSEIF (winner = 2) THEN
        winner = red_id;
    END IF;
    INSERT INTO pro_league_database.match(split_id, team_id_blue, team_id_red, winner_team)
    VALUES ((SELECT split_id FROM pro_league_database.split WHERE split_name = split_n),
            blue_id, red_id, winner);
END;
$$ LANGUAGE plpgsql;

SELECT pro_league_database.add_match('LEC 2022 Spring', 'Team BDS', 'Fnatic', 2);


-- (2) Функция для получения актуального кол-ва побед данной команды
CREATE OR REPLACE FUNCTION pro_league_database.get_wins(t_id INTEGER) RETURNS INTEGER AS $$
    SELECT COUNT(t_id)
    FROM pro_league_database.match
    WHERE t_id = winner_team;
$$ LANGUAGE SQL;


-- (3) Функция для получения актуального кол-ва поражений данной команды
CREATE OR REPLACE FUNCTION pro_league_database.get_losses(t_id INTEGER) RETURNS INTEGER AS $$
    SELECT COUNT(t_id)
    FROM pro_league_database.match
    WHERE t_id = (CASE WHEN winner_team = team_id_red THEN team_id_blue ELSE team_id_red END);
$$ LANGUAGE SQL;


-------------------------------------------------------------------------------------------------------------
-- Триггеры

-- (1) При вызове INSERT/DELETE/UPDATE для таблицы match в таблице team
-- изменяется статистика побед/поражений игравших команд.

CREATE OR REPLACE FUNCTION pro_league_database.trigger_upd() RETURNS TRIGGER AS $$
    BEGIN
        IF (TG_OP = 'INSERT') OR (TG_OP = 'DELETE') OR (TG_OP = 'UPDATE') THEN
            UPDATE pro_league_database.team
            SET n_wins = pro_league_database.get_wins(team_id)
            WHERE (team_id = NEW.team_id_blue) OR (team_id = NEW.team_id_red) OR
                    (team_id = OLD.team_id_blue) OR (team_id = OLD.team_id_red);

            UPDATE pro_league_database.team
            SET n_losses = pro_league_database.get_losses(team_id)
            WHERE (team_id = NEW.team_id_blue) OR (team_id = NEW.team_id_red) OR
                    (team_id = OLD.team_id_blue) OR (team_id = OLD.team_id_red);
            RETURN NEW;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_scores
AFTER INSERT OR UPDATE OR DELETE ON pro_league_database.match
FOR EACH ROW
EXECUTE PROCEDURE pro_league_database.trigger_upd();

-- Проверка
SELECT pro_league_database.add_match('LEC 2022 Spring', 'Rogue', 'Misfits Gaming', 1);
SELECT pro_league_database.add_match('LEC 2022 Spring', 'Team BDS', 'Excel', 1);

SELECT *
FROM pro_league_database.team;


-- (2) При вызове INSERT в таблицу player_x_team в таблицу логов контрактов
-- добавляется запись о новом контракте с указанием id игрока, команды, даты
-- истечения действия контракта и текущего времени.

CREATE TABLE pro_league_database.contract_logs(
  contract_id SERIAL PRIMARY KEY,
  player_id SERIAL NOT NULL,
  team_id SERIAL NOT NULL,
  date DATE NOT NULL,
  time TIME NOT NULL,
  contract_exp DATE NOT NULL
);

CREATE OR REPLACE FUNCTION pro_league_database.add_contract() RETURNS TRIGGER AS
  $$
  BEGIN
    IF (TG_OP = 'INSERT') THEN
      INSERT INTO pro_league_database.contract_logs(player_id, team_id, date, time, contract_exp)
        VALUES (NEW.player_id, NEW.team_id, CURRENT_DATE, CURRENT_TIME, NEW.contract_exp);
    END IF;
    RETURN NEW;
  END
  $$ LANGUAGE plpgsql;

CREATE TRIGGER contract_trigger
AFTER INSERT ON pro_league_database.player_x_team
FOR EACH ROW
EXECUTE PROCEDURE pro_league_database.add_contract();

INSERT INTO pro_league_database.player_x_team(player_id, team_id, contract_exp)
    VALUES ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Whiteknight'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Astralis'), '2025-11-14');

SELECT *
FROM pro_league_database.contract_logs;