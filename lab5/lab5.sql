-- 1. Добавить внешние ключи.
-- dealer - company
alter table lab5.dealer
    add constraint dealer_company_id_company_fk
        foreign key (id_company) references lab5.company (id_company)
            on update restrict on delete restrict;

-- production - company
alter table lab5.production
    add constraint production_company_id_company_fk
        foreign key (id_company) references lab5.company
            on update restrict on delete restrict;

-- production - medicine
alter table lab5.production
    add constraint production_medicine_id_medicine_fk
        foreign key (id_medicine) references lab5.medicine
            on update restrict on delete restrict;

-- order - production
alter table lab5."order"
    add constraint order_production_id_production_fk
        foreign key (id_production) references lab5.production
            on update restrict on delete restrict;

-- order - dealer
alter table lab5."order"
    add constraint order_dealer_id_dealer_fk
        foreign key (id_dealer) references lab5.dealer
            on update restrict on delete restrict;

-- order - pharmacy
alter table lab5."order"
    add constraint order_pharmacy_id_pharmacy_fk
        foreign key (id_pharmacy) references lab5.pharmacy
            on update restrict on delete restrict;


-- 2. Выдать информацию по всем заказам лекарствам “Кордерон” компании “Аргус”
    -- с указанием названий аптек, дат, объема заказов.
SELECT "order".id_order,
            medicine.name AS medicine_name,
            company.name as company_name,
            pharmacy.name AS pharmacy_name,
            "order".date,
            "order".quantity
    FROM "order"
        JOIN production ON "order".id_production = production.id_production
        JOIN medicine ON production.id_medicine = medicine.id_medicine
        JOIN dealer ON "order".id_dealer = dealer.id_dealer
        JOIN company ON dealer.id_company = company.id_company
        JOIN pharmacy ON "order".id_pharmacy = pharmacy.id_pharmacy
    WHERE medicine.name = 'Кордерон' AND company.name = 'Аргус';

-- 3. Дать список лекарств компании “Фарма”, на которые не были сделаны заказы до 25 января.
SELECT DISTINCT (m.name) FROM company c
    JOIN production p ON c.id_company = p.id_company
    JOIN medicine m ON p.id_medicine = m.id_medicine
WHERE c.name = 'Фарма' and m.name NOT IN
      (
        SELECT m.name FROM company c
            JOIN production p ON c.id_company = p.id_company
            JOIN medicine m ON p.id_medicine = m.id_medicine
            JOIN "order" o on o.id_production = p.id_production
            WHERE date <= '2019-01-25' and c.name = 'Фарма'
      );

/*
SELECT DISTINCT (m.name) FROM company c
    JOIN production p ON c.id_company = p.id_company
    JOIN medicine m ON p.id_medicine = m.id_medicine
    JOIN "order" o on o.id_production = p.id_production
WHERE date <= '2019-01-25' and c.name = 'Фарма';
*/

/*
SELECT c.name, date, m.name FROM company c
    JOIN production p ON c.id_company = p.id_company
    JOIN medicine m ON p.id_medicine = m.id_medicine
    JOIN "order" o on o.id_production = p.id_production
WHERE c.name = 'Фарма';
*/

/*
Визмед мульти
Овесол
Синупред
Гриппферон
Кордерон
Гриппферон
Кагоцел
Карсил
Гептрал
Анальгин
Анальгин
*/

-- 4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов.
SELECT company.name AS company_name,
       MIN(production.rating) AS min_rating,
       MAX(production.rating) AS max_rating
    FROM company
        JOIN dealer ON company.id_company = dealer.id_company
        JOIN "order" ON dealer.id_dealer = "order".id_dealer
        JOIN production ON "order".id_production = production.id_production
    GROUP BY company.name
    HAVING COUNT("order".id_order) >= 120;

-- 5. Дать списки сделавших заказы аптек по всем дилерам компании “AstraZeneca”.
    -- Если у дилера нет заказов, в названии аптеки проставить NULL.
SELECT d.name, p.name FROM dealer d
    JOIN company c on c.id_company = d.id_company
    LEFT JOIN "order" o on d.id_dealer = o.id_dealer
    LEFT JOIN lab5.pharmacy p on p.id_pharmacy = o.id_pharmacy
WHERE c.name = 'AstraZeneca';

-- 6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а длительность лечения не более 7 дней.
UPDATE production p
    SET price = p.price * 0.8
FROM medicine m WHERE p.id_medicine = m.id_medicine AND p.price > '900000' and m.cure_duration <= 7;


-- 7. Добавить необходимые индексы.
CREATE INDEX idx_dealer_name ON dealer (name);
CREATE INDEX idx_production_id_company ON production (id_company);
CREATE INDEX idx_production_id_medicine ON production (id_medicine);
CREATE INDEX idx_order_id_production ON "order" (id_production);
CREATE INDEX idx_order_id_dealer ON "order" (id_dealer);
CREATE INDEX idx_order_id_pharmacy ON "order" (id_pharmacy);
CREATE INDEX idx_medicine_name ON medicine (name);
