# Домашнее задание к занятию «Docker. Часть 2»

## Задание 1


## Задание 2


## Задание 3


## Задание 4

*Текст конфига*

```shell
version: "3"
services:

  netology-db:
    image: postgres:latest
    container_name: BondarenkoVA-netology-db
    restart: always
    ports:
      - "5432:5432"
    volumes:
      - ./pg_data:/var/lib/postgresql/data/pgdata
    environment:
      POSTGRES_PASSWORD: BondarenkoVA12!3!!
      POSTGRES_DB: BondarenkoVA-netology_db
      PGDATA: /var/lib/postgresql/data/pgdata 
    networks:
      BondarenkoVA-my-netology-hw:
        ipv4_address: 172.22.0.2

  pgadmin:
    image: dpage/pgadmin4
    container_name: BondarenkoVA-pgadmin
    environment:
      PGADMIN_DEFAULT_EMAIL: BondarenkoVA@ilove-netology.com
      PGADMIN_DEFAULT_PASSWORD: 123
    ports:
      - "61231:80"
    networks:
      BondarenkoVA-my-netology-hw:
        ipv4_address: 172.22.0.3
    restart: always

networks:
  BondarenkoVA-my-netology-hw:
    driver: bridge
    ipam:
      config:
        - subnet: 172.22.0.0/24
```
*Скрин админки pdAdmin*

![](./homework-4/image-01.jpg)


## Задание 5


## Задание 6

## Задание 7

## Задание 8

## Задание 9