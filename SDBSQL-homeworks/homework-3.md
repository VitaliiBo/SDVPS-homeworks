# Домашнее задание к занятию «SQL. Часть 1»

### Задание 1

Получите уникальные названия районов из таблицы с адресами, которые начинаются на “K” и заканчиваются на “a” и не содержат пробелов.

```sql
SELECT DISTINCT
    district
FROM
    address
WHERE
    district LIKE 'K%'
    AND district LIKE '%a'
    AND district NOT LIKE '% %';
```

### Задание 2

Получите из таблицы платежей за прокат фильмов информацию по платежам, которые выполнялись в промежуток с 15 июня 2005 года по 18 июня 2005 года **включительно** и стоимость которых превышает 10.00.


Можно использовать between, но мне и так нравится.
```sql
select
    payment_date,
    amount
from
    payment
where
    payment_date >= '2005-06-15'
    AND payment_date <= '2005-06-18'
    AND amount > '10';
```


### Задание 3

Получите последние пять аренд фильмов.

```sql
SELECT
    *
FROM
    (
        SELECT
            *
        FROM
            rental
        ORDER BY
            rental_id DESC
        LIMIT
            5
    ) AS sometable
ORDER BY
    rental_id ASC;
```

### Задание 4

Одним запросом получите активных покупателей, имена которых Kelly или Willie. 

Сформируйте вывод в результат таким образом:
- все буквы в фамилии и имени из верхнего регистра переведите в нижний регистр,
- замените буквы 'll' в именах на 'pp'.

```sql
select
    lower(REGEXP_REPLACE (first_name, 'll', 'pp')) as first_name
from
    (
        select
            *
        from
            customer
        where
            first_name like 'Kelly'
            OR first_name like 'Willie'
    ) AS sub
where
    active = 1;
```

## Дополнительные задания (со звёздочкой*)
Эти задания дополнительные, то есть не обязательные к выполнению, и никак не повлияют на получение вами зачёта по этому домашнему заданию. Вы можете их выполнить, если хотите глубже шире разобраться в материале.

### Задание 5*

Выведите Email каждого покупателя, разделив значение Email на две отдельных колонки: в первой колонке должно быть значение, указанное до @, во второй — значение, указанное после @.

```sql
Select
    SUBSTRING_INDEX (email, '@', 1) as 'before @',
    SUBSTRING_INDEX (email, '@', -1) as 'after @'
from
    customer;
```

### Задание 6*

Доработайте запрос из предыдущего задания, скорректируйте значения в новых колонках: первая буква должна быть заглавной, остальные — строчными.

```sql
select
    CONCAT (
        UCASE (MID (email_name, 1, 1)),
        LCASE (MID (email_name, 2))
    ) as email_name,
    CONCAT (
        UCASE (MID (domain, 1, 1)),
        LCASE (MID (domain, 2))
    ) as domain
FROM
    (
        Select
            SUBSTRING_INDEX (email, '@', 1) as email_name,
            SUBSTRING_INDEX (email, '@', -1) as domain
        from
            customer
    ) as sub;
```