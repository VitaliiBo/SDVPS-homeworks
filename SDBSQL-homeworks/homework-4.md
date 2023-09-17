# Домашнее задание к занятию «SQL. Часть 2»

### Задание 1

Одним запросом получите информацию о магазине, в котором обслуживается более 300 покупателей, и выведите в результат следующую информацию: 
- фамилия и имя сотрудника из этого магазина;
- город нахождения магазина;
- количество пользователей, закреплённых в этом магазине.
<details><summary>slowest version</summary>

```sql
SELECT
    CONCAT (first_name, ' ', last_name) as name,
    address,
    customers_count
FROM
    staff
    JOIN (
        select
            store_id,
            address
        from
            store
            INNER JOIN address ON address.address_id = store.address_id
    ) st ON st.store_id = staff.store_id
    JOIN (
        select
            store_id,
            count as customers_count
        from
            (
                select
                    store_id,
                    count(*) as count
                from
                    customer
                group by
                    store_id
                order by
                    count desc
            ) as sub
        where
            count > 300
    ) ct ON ct.store_id = staff.store_id;
```
</details>
Доработка

```sql
SELECT CONCAT(staff.first_name, ' ', staff.last_name) as name, city as store_city ,count(customer.store_id) customers_count
FROM customer
JOIN staff ON staff.store_id=customer.store_id
JOIN store s ON s.store_id=staff.store_id
JOIN address a ON a.address_id=s.address_id
JOIN city c ON c.city_id=a.city_id
GROUP BY name, city
HAVING customers_count > 300;
```

### Задание 2

Получите количество фильмов, продолжительность которых больше средней продолжительности всех фильмов.

```sql
select
    count(*) as count
from
    film
where
    length > (
        select
            avg(length) as avg
        from
            film
    );
```

### Задание 3

Получите информацию, за какой месяц была получена наибольшая сумма платежей, и добавьте информацию по количеству аренд за этот месяц.

Доработка

```sql
select
    DATE_FORMAT(payment_date, "%M %Y") as month,
    sum(amount) as total_value,
    count(DATE_FORMAT(payment_date, "%M %Y")) as count
from
    payment
group by
    month
ORDER BY
    total_value DESC;
```


## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 4*

Посчитайте количество продаж, выполненных каждым продавцом. Добавьте вычисляемую колонку «Премия». Если количество продаж превышает 8000, то значение в колонке будет «Да», иначе должно быть значение «Нет».



### Задание 5*

Найдите фильмы, которые ни разу не брали в аренду.

```sql
SELECT
    title
FROM
    inventory
    LEFT OUTER JOIN rental ON rental.inventory_id = inventory.inventory_id
    JOIN film ON film.film_id = inventory.film_id
WHERE
    rental.rental_id IS NULL;
```