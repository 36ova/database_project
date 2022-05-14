import psycopg2
import psycopg2.extras
import random
from random_word import RandomWords

hostname = 'localhost'
database = 'pg_db'
username = 'postgres'
pwd = 'postgres'
port_id = 5432
conn = None

# Сгенерируем 10 названий команд для Северной Америки.
r = RandomWords()
team_names = [name.capitalize() for name in r.get_random_words()[:10]]
print(team_names)

try:
    with psycopg2.connect(database='org_mipt_atp_db', user='postgres', password='postgres', host='docker', port=49154) as conn:
        with conn.cursor(cursor_factory=psycopg2.extras.DictCursor) as cur:
            # Вставим 10 команд в таблицу teams, найдем их индексы
            team_insert_script = 'INSERT INTO pro_league_database.team (t_name, region, n_wins, n_losses) VALUES (%s, %s, %s, %s)'
            insert_values = [(name, 'NA', 0, 0) for name in team_names]
            for value in insert_values:
                cur.execute(team_insert_script, value)

            cur.execute("SELECT team_id FROM pro_league_database.team WHERE t_name = '{}'".format(team_names[0]))
            first = cur.fetchall()[0][0]
            new_team_ids = list(range(first, first+10))
            print(new_team_ids)

            # Вставим новый сплит, найдем его индекс
            split_insert_script = 'INSERT INTO pro_league_database.split (split_name, region) VALUES (%s, %s)'
            insert_value = ('LCS 2022 Spring', 'NA')
            cur.execute(split_insert_script, insert_value)
            cur.execute("SELECT split_id FROM pro_league_database.split WHERE split_name = 'LCS 2022 Spring'")
            split_id = cur.fetchall()[0][0]
            print(split_id)

            # Проведем по 2 матча между каждой парой среди вставленных команд.
            # Благодаря триггеру автоматически обновится таблица team.
            match_insert_script = 'INSERT INTO pro_league_database.match (split_id, team_id_blue, team_id_red, winner_team) VALUES (%s, %s, %s, %s)'
            insert_values = []
            for blue_team in new_team_ids:
                for red_team in new_team_ids:
                    if blue_team != red_team:
                        outcome = random.randint(0, 1)
                        insert_values.append((split_id, blue_team, red_team, red_team if outcome else blue_team))

            for value in insert_values:
                cur.execute(match_insert_script, value)

            # Посмотрим статистику команд из Северной Америки
            cur.execute("SELECT * FROM pro_league_database.team WHERE region = 'NA' ORDER BY n_wins DESC")
            for record in cur.fetchall():
                print(record)

except Exception as error:
    print(error)
finally:
    if conn is not None:
        conn.close()
