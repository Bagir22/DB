-- 3.1 INSERT
    -- a. Без указания списка полей
INSERT INTO organization VALUES (5, 'Some organisation name', 'Some location', '+79021007050',
                                 'example@gmail.com', 012345678911, 111213140);
    -- b. С указанием списка полей
INSERT INTO competition (name, stard_date, end_date, address, organization)
        VALUES ('Some competition name', '2024-03-25', '2024-03-27', 'Some organization address', 1);
    -- c. С чтением значения из другой таблицы
-- INSERT INTO country VALUES (1, 'Russia');
-- INSERT INTO coach_specialization (name) VALUES ('Some specialization');
-- INSERT INTO coach (full_name, phone_number, specialization, email, age)
    -- VALUES ('Coach name', '81111111111', 1, 'example@example.com', 30);
-- CREATE TYPE gender AS ENUM ('male', 'female');
INSERT INTO athlete (full_name, date_of_birth, country, weight, height, coach_id, gender, phone_number)
    SELECT 'Ivan Ivanov', '2002-02-22', id, 55, 170, 1, 'male', '89999999999' FROM country WHERE name = 'Russia';

-- 3.2. DELETE
    -- a. Всех записей
DELETE FROM organization;
    -- b. По условию
DELETE FROM organization WHERE name = 'Some name';

-- 3. UPDATE
    -- a. Всех записей
UPDATE athlete SET weight = 80; --unsafe query error
    -- b. По условию обновляя один атрибут
UPDATE athlete SET weight = 70 WHERE id = 2;
    -- c. По условию обновляя несколько атрибутов
UPDATE athlete SET weight = 70, height = 180 WHERE id = 1;

--3.4. SELECT
    -- a. С набором извлекаемых атрибутов (SELECT atr1, atr2 FROM...)
SELECT full_name, date_of_birth FROM athlete;
    -- b. Со всеми атрибутами (SELECT * FROM ...)
SELECT * FROM athlete;
    -- c. С условием по атрибуту (SELECT * FROM ... WHERE atr1 = value)
SELECT * FROM athlete WHERE country = 1;

-- 3.5. SELECT ORDER BY + TOP (LIMIT)
    -- a. С сортировкой по возрастанию ASC + ограничение вывода количества записей
SELECT * FROM athlete ORDER BY full_name LIMIT 10;
    -- b. С сортировкой по убыванию DESC
SELECT * FROM athlete ORDER BY date_of_birth DESC LIMIT 2;
    -- c. С сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT * FROM athlete ORDER BY country, height LIMIT 5;
    -- d. С сортировкой по первому атрибуту, из списка извлекаемых
SELECT full_name, date_of_birth FROM athlete ORDER BY full_name LIMIT 2;


-- 3.6. Работа с датами
    -- Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME. Например,
        -- таблица авторов может содержать дату рождения автора.
    -- a. WHERE по дате
SELECT * FROM athlete WHERE date_of_birth = '2002-02-22';
    -- b. WHERE дата в диапазоне
SELECT * FROM athlete WHERE date_of_birth BETWEEN '2002-02-20' AND '2004-02-22';
    -- c. Извлечь из таблицы не всю дату, а только год. Например, год рождения автора.
SELECT full_name, date_part('year', date_of_birth) AS year_of_birth FROM athlete;

-- 3.7. Функции агрегации
    -- a. Посчитать количество записей в таблице
SELECT COUNT(*) AS total_rows FROM athlete;
    -- b. Посчитать количество уникальных записей в таблице
SELECT COUNT(DISTINCT country) AS unique_countries FROM athlete;
    -- c. Вывести уникальные значения столбца
SELECT DISTINCT gender FROM athlete;
    -- d. Найти максимальное значение столбца
SELECT MAX(weight) AS max_weight FROM athlete;
    -- e. Найти минимальное значение столбца
SELECT MIN(height) AS Min, MAX(height) as Max  FROM athlete;

    -- f. Написать запрос COUNT () + GROUP BY
SELECT country, COUNT(*) AS total_athletes FROM athlete GROUP BY country;

-- 3.8. SELECT GROUP BY + HAVING
    -- a. Написать 3 разных запроса с использованием GROUP BY + HAVING.
        -- Для каждого запроса написать комментарий с пояснением, какую информацию
        -- извлекает запрос. Запрос должен быть осмысленным, т.е. находить информацию,
        -- которую можно использовать.

SELECT country, COUNT(*) AS total_athletes FROM athlete
    GROUP BY country HAVING COUNT(*) > 1;
-- Запрос для нахождения стран, в которых количество атлетов превышает определенное значение

-- Запрос для определения организаторов, у которых было менее 3 соревнований
SELECT organization.name, COUNT(*) AS competitions_count FROM organization
    JOIN competition ON organization.id = competition.organization
        GROUP BY organization.name HAVING COUNT(*) < 2;

-- Запрос найдет категории соревнований, в которых количество участников меньше 5
SELECT category, COUNT(*) AS total_perfomances FROM perfomance
    GROUP BY category;

SELECT gender, COUNT(*) FROM athlete GROUP BY gender HAVING COUNT(*) >= 3;

-- 3.9.-- SELECT JOIN
    -- a. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
SELECT athlete.full_name, coach.full_name AS coach_name FROM athlete
    LEFT JOIN coach ON athlete.coach_id = coach.id WHERE athlete.country = 1;
    -- b. RIGHT JOIN. Получить такую же выборку, как и в 3.9 a
SELECT athlete.full_name, coach.full_name AS coach_name FROM coach
    RIGHT JOIN athlete ON athlete.coach_id = coach.id WHERE athlete.country = 1;
    -- c. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT athlete.full_name, coach.full_name AS coach_name, country.name AS country_name FROM athlete
    LEFT JOIN coach ON athlete.coach_id = coach.id
    LEFT JOIN country ON athlete.country = country.id
    WHERE athlete.country = 1 AND coach.id = 1 AND country.name = 'Russia';
    -- d. INNER JOIN двух таблиц
SELECT athlete.full_name, coach.full_name AS coach_name FROM athlete
    INNER JOIN coach ON athlete.coach_id = coach.id;

-- 3.10. Подзапросы
    -- a. Написать запрос с условием WHERE IN (подзапрос)
SELECT * FROM athlete WHERE athlete.country IN (SELECT id FROM country WHERE name = 'Russia');
    -- b. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
SELECT full_name, phone_number, (SELECT name FROM country WHERE id = athlete.country) AS country_name FROM athlete;
    -- c. Написать запрос вида SELECT * FROM (подзапрос)
SELECT * FROM (SELECT * FROM coach WHERE specialization = 1) AS specizalization;
    -- d. Написать запрос вида SELECT * FROM table JOIN (подзапрос) ON ...
SELECT * FROM athlete JOIN (SELECT id, name FROM country WHERE name = 'Russia') AS subquery_result ON athlete.country = subquery_result.id;