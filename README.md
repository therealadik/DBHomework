# DBHomework

Репозиторий с домашними заданиями по базам данных. Каждое задание включает:
- `init.sql` — создание и инициализация схемы базы данных;
- `example-data.sql` — тестовые данные;
- `taskN.sql` — SQL-запросы для выполнения заданий.

## Состав

```
DBHomework/
├── Homework1/
│   ├── init.sql
│   ├── example-data.sql
│   ├── task1.sql
│   └── task2.sql
│
├── Homework2/
│   ├── init.sql
│   ├── example-data.sql
│   ├── task1.sql
│   ├── task2.sql
│   ├── task3.sql
│   ├── task4.sql
│   └── task5.sql
│
├── Homework3/
│   ├── init.sql
│   ├── example-data.sql
│   ├── task1.sql
│   ├── task2.sql
│   └── task3.sql
│
├── Homework4/
│   ├── init.sql
│   ├── example-data.sql
│   ├── task1.sql
│   ├── task2.sql
│   └── task3.sql
```

## Как проверить задание

### Шаг 1: Запуск PostgreSQL через Docker

Если у вас установлен Docker, выполните:

```bash
docker-compose up -d
```

Контейнер поднимет PostgreSQL на порту 5432 с указанными пользователем и паролем (см. `docker-compose.yaml`).

### Шаг 2: Подключение к базе данных
Подключитесь к базе данных

- Host: `localhost`
- Port: `5432`
- User: `postgres`
- Password: `postgres`
- Database: `postgres`

### Шаг 3: Выполнение скриптов

1. Выполните `init.sql` для создания таблиц.
2. Выполните `example-data.sql` для добавления тестовых данных.
3. Выполните нужный `taskN.sql` и проверьте результат.

Пример выполнения в `psql`:

```sql
\i init.sql
\i example-data.sql
\i task1.sql
```

Повторите для всех `Homework` директорий.