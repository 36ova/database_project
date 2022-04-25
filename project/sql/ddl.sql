-- Создание таблиц

-- Создание схемы базы данных о профессиональной Лиге легенд
CREATE SCHEMA pro_league_database;

-- Информация о командах
CREATE TABLE pro_league_database.team (
    team_id SERIAL PRIMARY KEY,
    t_name VARCHAR(255) NOT NULL UNIQUE,
    region VARCHAR(255) NOT NULL,
    n_wins INTEGER CHECK (team.n_wins >= 0),
    n_losses INTEGER CHECK (team.n_losses >= 0)
);

-- Информация о игроках
CREATE TABLE pro_league_database.player (
    player_id SERIAL PRIMARY KEY,
    nickname VARCHAR(255) NOT NULL UNIQUE,
    country VARCHAR(255) NOT NULL,
    p_role VARCHAR(255) NOT NULL,
    age INTEGER CHECK (player.age >= 0),
    p_name VARCHAR(255) NOT NULL
);

-- Таблица-связка "Игрок-команда"
CREATE TABLE pro_league_database.player_x_team (
    player_id SERIAL NOT NULL,
    team_id SERIAL NOT NULL,
    contract_exp DATE,
    PRIMARY KEY (player_id, team_id),
    FOREIGN KEY (player_id)
        REFERENCES pro_league_database.player(player_id),
    FOREIGN KEY (team_id)
        REFERENCES pro_league_database.team(team_id)
);

-- Информация о соревнованиях
CREATE TABLE pro_league_database.split (
    split_id SERIAL PRIMARY KEY,
    split_name VARCHAR(255) NOT NULL UNIQUE,
    region VARCHAR(255) NOT NULL
);

-- Информация о матчах
CREATE TABLE pro_league_database.match (
    match_id SERIAL PRIMARY KEY,
    split_id SERIAL NOT NULL,
    team_id_blue SERIAL NOT NULL,
    team_id_red SERIAL NOT NULL,
    winner_team SERIAL NOT NULL,
    FOREIGN KEY (split_id)
        REFERENCES pro_league_database.split(split_id),
    FOREIGN KEY (team_id_blue)
        REFERENCES pro_league_database.team(team_id),
    FOREIGN KEY (team_id_red)
        REFERENCES pro_league_database.team(team_id),
    FOREIGN KEY (winner_team)
        REFERENCES pro_league_database.team(team_id)
);

------------------------------------------------------------------------------------------------------------------------

-- Заполнение таблицы "player"
INSERT INTO pro_league_database.player(nickname, country, p_role, age, p_name)
  VALUES ('Whiteknight', 'Finland', 'Top', 26, 'Matti Sormunen'),
         ('Zanzarah', 'Russia', 'Jungle', 25, 'Nikolay Akatov'),
         ('nukeduck', 'Norway', 'Mid', 25, 'Erlend Våtevik Holm'),
         ('Jeskla', 'Sweden', 'Bot', 21, 'Jesper Klarin Strömberg'),
         ('promisq', 'Sweden', 'Support', 28, 'Hampus Mikael Abrahamsson'),
         ('Dajor', 'Germany', 'Mid', 19, 'Oliver Ryppa'),
         ('Kobbe', 'Denmark', 'Bot', 25, 'asper Kobberup'),
         ('Finn', 'Sweden', 'Top', 22, 'Finn Wiestål'),
         ('Markoon', 'Netherlands', 'Jungle', 19, 'Mark van Woensel'),
         ('Patrik', 'Czech Republic', 'Mid', 22, 'Patrik Jírů'),
         ('Mikyx', 'Slovenia', 'Support', 23, 'Mihael Mehle'),
         ('Wunder', 'Denmark', 'Top', 23, 'Martin Nordahl Hansen'),
         ('Razork', 'Spain', 'Jungle', 21, 'Iván Martín Díaz'),
         ('Humanoid', 'Czech Republic', 'Mid', 22, 'Marek Brázda'),
         ('Upset', 'Germany', 'Bot', 22, 'Elias Lipp'),
         ('Hylissang', 'Bulgaria', 'Support', 26, 'Zdravets Iliev Galabov'),
         ('Broken Blade', 'Germany', 'Top', 22, 'Sergen Çelik'),
         ('Jankos', 'Poland', 'Jungle', 26, 'Marcin Jankowski'),
         ('caPs', 'Denmark', 'Mid', 22, 'Rasmus Borregaard Winther'),
         ('Flakked', 'Spain', 'Bot', 20, 'Victor Lirola Tortosa'),
         ('Targamas', 'Belgium', 'Support', 21, 'Raphaël Crabbé'),
         ('Armut', 'Turkey', 'Top', 23, 'İrfan Berk Tükek'),
         ('Elyoya', 'Spain', 'Jungle', 22, 'Javier Prades Batalla'),
         ('Reeker', 'Germany', 'Mid', 20, 'Steven Chen'),
         ('UNF0RGIVEN', 'Sweeden', 'Bot', 21, '	William Nieminen'),
         ('Kaiser', 'Germany', 'Support', 23, 'Norman Kaiser'),
         ('HiRit', 'South Korea', 'Top', 23, 'Shin Tae-min'),
         ('Shaltan', 'Poland', 'Jungle', 20, 'Lucjan Ahmad'),
         ('Vetheo', 'France', 'Mid', 19, 'Vincent Berrié'),
         ('Neon', 'Slovakia', 'Bot', 23, 'Matúš Jakubčík'),
         ('Mersa', 'Greece', 'Support', 19, 'Mertai Sari'),
         ('Odoamne', 'Belgium', 'Top', 27, 'Andrei Pascu'),
         ('Malrang', 'South Korea', 'Jungle', 22, 'Kim Geun-seong'),
         ('Larssen', 'Sweden', 'Mid', 22, 'Emil Larsson'),
         ('Comp', 'Greece', 'Bot', 20, 'Markos Stamkopoulos'),
         ('Trymbi', 'Poland', 'Support', 21, 'Adrian Trybus'),
         ('JNX', 'Germany', 'Top', 23, 'Janik Bartels'),
         ('Gilius', 'Germany', 'Jungle', 20, 'Erberk Demir'),
         ('Sertuss', 'Germany', 'Mid', 20, 'Daniel Gamani'),
         ('Jezu', 'France', 'Bot', 21, 'Jean Massol'),
         ('Treatz', 'Sweden', 'Support', 25, 'Erik Wessén'),
         ('Adam', 'France', 'Top', 20, 'Adam Maanane'),
         ('Cinkrof', 'Poland', 'Jungle', 24, 'Jakub Rokicki'),
         ('NUCLEARINT', 'France', 'Mid', 19, 'Ilias Bizriken'),
         ('xMatty', 'United Kingdom', 'Bot', 22, 'Matthew Charles Coombs'),
         ('LIMIT', 'Croatia', 'Support', 24, 'Dino Tot'),
         ('Alphari', 'United Kingdom', 'Top', 22, 'Barney Morris'),
         ('Selfmade', 'Poland', 'Jungle', 22, 'Oskar Boderek'),
         ('Perkz', 'Croatia', 'Mid', 23, 'Luka Perković'),
         ('Carzzy', 'Czech Republic', 'Bot', 20, 'Matyáš Orság'),
         ('Labrov', 'Greece', 'Support', 20, 'Labros Papoutsakis');

SELECT *
FROM pro_league_database.player;

-- Заполнение таблицы "team"
INSERT INTO pro_league_database.team(t_name, region, n_wins, n_losses)
  VALUES ('Astralis', 'EU', 3, 15),
         ('Excel', 'EU', 9, 9),
         ('Fnatic', 'EU', 13, 5),
         ('G2 Esports', 'EU', 11, 7),
         ('MAD Lions', 'EU', 8, 10),
         ('Misfits Gaming', 'EU', 12, 6),
         ('Rogue', 'EU', 14, 4),
         ('SK Gaming', 'EU', 7, 11),
         ('Team BDS', 'EU', 4, 14),
         ('Team Vitality', 'EU', 9, 9),
         ('Schalke 04', 'EU', 3, 15);

SELECT *
FROM pro_league_database.team;

-- Заполнение таблицы "split"
INSERT INTO pro_league_database.split(split_name, region)
  VALUES ('LEC 2022 Spring', 'EU'),
         ('LEC 2021 Summer', 'EU'),
         ('LEC 2021 Spring', 'EU');

SELECT *
FROM pro_league_database.split;

-- Заполнение таблицы "match"
INSERT INTO pro_league_database.match(split_id, team_id_blue, team_id_red, winner_team)
  VALUES (1, (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Team Vitality'),
          (SELECT team_id AS red FROM pro_league_database.team WHERE t_name = 'MAD Lions'), 2),
      (1, (SELECT team_id FROM pro_league_database.team WHERE t_name = 'SK Gaming'),
       (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Rogue'), 2),
      (1, (SELECT team_id FROM pro_league_database.team WHERE t_name = 'G2 Esports'),
       (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Excel'), 1),
      (1, (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Misfits Gaming'),
       (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Astralis'), 1),
      (2, (SELECT team_id FROM pro_league_database.team WHERE t_name = 'MAD Lions'),
       (SELECT team_id FROM pro_league_database.team WHERE t_name = 'G2 Esports'), 2),
      (2, (SELECT team_id FROM pro_league_database.team WHERE t_name = 'SK Gaming'),
       (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Astralis'), 2),
      (2, (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Rogue'),
       (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Excel'), 1),
      (3, (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Team Vitality'),
       (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Schalke 04'), 1),
      (3, (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Misfits Gaming'),
       (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Fnatic'), 1);

UPDATE pro_league_database.match
SET winner_team = team_id_blue WHERE winner_team = 1;

UPDATE pro_league_database.match
SET winner_team = team_id_red WHERE winner_team = 2;

SELECT *
FROM pro_league_database.match;

-- Заполнение таблицы "player_x_team"
INSERT INTO pro_league_database.player_x_team(player_id, team_id, contract_exp)
    VALUES ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Zanzarah'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Astralis'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Dajor'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Astralis'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Kobbe'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Astralis'), '2022-11-21'),

        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Finn'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Excel'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Markoon'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Excel'), '2022-11-21'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'nukeduck'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Excel'), '2022-11-21'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Patrik'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Excel'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Mikyx'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Excel'), '2023-11-20'),

        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Wunder'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Fnatic'), '2024-11-18'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Razork'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Fnatic'), '2024-11-18'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Humanoid'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Fnatic'), '2024-11-18'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Upset'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Fnatic'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Hylissang'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Fnatic'), '2023-11-20');

INSERT INTO pro_league_database.player_x_team(player_id, team_id, contract_exp)
    VALUES ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Broken Blade'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'G2 Esports'), '2024-11-18'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Jankos'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'G2 Esports'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'caPs'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'G2 Esports'), '2025-11-17'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Flakked'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'G2 Esports'), '2024-11-18'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Targamas'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'G2 Esports'), '2024-11-18'),

        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Armut'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'MAD Lions'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Elyoya'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'MAD Lions'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Reeker'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'MAD Lions'), '2024-11-18'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'UNF0RGIVEN'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'MAD Lions'), '2024-11-18'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Kaiser'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'MAD Lions'), '2023-11-20'),

        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'HiRit'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Misfits Gaming'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Shaltan'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Misfits Gaming'), '2022-11-21'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Vetheo'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Misfits Gaming'), '2022-11-21'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Neon'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Misfits Gaming'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Mersa'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Misfits Gaming'), '2024-11-18');

INSERT INTO pro_league_database.player_x_team(player_id, team_id, contract_exp)
    VALUES ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Odoamne'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Rogue'), '2022-11-21'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Malrang'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Rogue'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Larssen'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Rogue'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Comp'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Rogue'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Trymbi'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Rogue'), '2023-11-20'),

        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'JNX'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'SK Gaming'), '2022-11-21'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Gilius'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'SK Gaming'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Sertuss'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'SK Gaming'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Jezu'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'SK Gaming'), '2022-11-21'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Treatz'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'SK Gaming'), '2023-11-20'),

        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Adam'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Team BDS'), '2024-11-18'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Cinkrof'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Team BDS'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'NUCLEARINT'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Team BDS'), '2024-11-18'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'xMatty'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Team BDS'), '2023-11-20'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'LIMIT'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Team BDS'), '2023-11-20'),

        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Alphari'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Team Vitality'), '2024-11-18'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Selfmade'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Team Vitality'), '2024-11-18'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Perkz'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Team Vitality'), '2024-11-18'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Carzzy'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Team Vitality'), '2024-11-18'),
        ((SELECT player_id FROM pro_league_database.player WHERE nickname = 'Labrov'),
            (SELECT team_id FROM pro_league_database.team WHERE t_name = 'Team Vitality'), '2024-11-18');

SELECT *
FROM pro_league_database.player_x_team;

-- Удаление значений из таблицы
TRUNCATE pro_league_database.team, pro_league_database.player,
    pro_league_database.match, pro_league_database.player_x_team, pro_league_database.split;

-- Удаление таблиц
DROP TABLE pro_league_database.team, pro_league_database.player,
    pro_league_database.match, pro_league_database.player_x_team, pro_league_database.split;

-- Удаление схемы
DROP SCHEMA pro_league_database