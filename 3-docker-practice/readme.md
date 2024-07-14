# Практическое применение Docker

## Задача 0 --- версии программ
Версии установленных программ:
docker:
```
$ docker --version
Docker version 24.0.2, build cb74dfc
```

docker compose:
```
$ docker compose version
Docker Compose version v2.28.1
```

## Задача 1 --- web-logger

Репозиторий проекта : [https://github.com/mea2k/devops/tree/main/3-docker-practice](https://github.com/mea2k/devops/tree/main/3-docker-practice)

Сборка проекта включает следующие контейнеры ([compose.yaml](compose.yaml)):
- reverse-proxy (`haproxy`, запускается на порту _8080_)
- ingress-proxy (`nginx`, запускается на порту _8090_)
- web-logger (запускается на порту `APP_PORT` или _5000_)
- mysql (запускается на порту _3306_)
- adminer (запускается на порту _9000_)
- cron-backup (`schnitzler/mysqldump`, запуск 1 раз в минуту)

Схема стенда на рисунке ниже.

![Схема стенда](images/%D1%81%D1%85%D0%B5%D0%BC%D0%B0_%D1%81%D1%82%D0%B5%D0%BD%D0%B4%D0%B0.png)


Сборка контенера с приложением (`web-logger`) осуществляется с помощью файла [Dockerfile.python](Dockerfile.python).

Требуемые переменные окружения ([.env](.env)):
- `MYSQL_ROOT_PASSWORD` - пароль для инициализации MySQL
- `MYSQL_DATABASE` - название БД в MySQL (если её нет, то создастся при первом запуске)
- `MYSQL_USER` - имя пользователя для БД (создаётся при первом запуске)
- `MYSQL_PASSWORD` - пароль для пользователя `MYSQL_USER`
- `DB_HOST` - название хоста с СУБД MySQL (для подключения приложения)
- `DB_NAME` - совпадает с `MYSQL_DATABASE`
- `DB_REQUESTS_TABLE` - название таблицы, в которой будет хранится статистика посещений
- `DB_USER` - совпадает с `MYSQL_USER`
- `DB_PASSWORD` - совпадает с `MYSQL_PASSWORD`
- `APP_PORT` - порт, на котором будет запускаться приложение


## Задача 2  - Yandex.Cloud

Создан репозиторий в Yandex.Cloud. Туда и на открытый репозиторий размещен образ контейнера web-logger ([https://hub.docker.com/r/makevg/web-logger](https://hub.docker.com/r/makevg/web-logger)).

Результаты сканирования в Yandex.Cloud на рисунке.

![Результаты сканирования образа web-logger](images/web-logger_scan.png)


## Задача 3  - сборка контейнеров


Подробно описано в **задаче 1**.

Результаты выполнения SQL-запросов в `adminer`-е приведены ниже.

```
show databases; 
use virtd; 
show tables; 
SELECT * from logs LIMIT 10;
```

Результаты:

![Результаты выполнения SQL-команд](images/sql-check.png)


## Задача 4  - проверка Интернет-ресурса

Скрипт, копирующий исходный код на ВМ в Yandex.Cloud в файле [script.sh](scripts/script.sh).

_P.S. Почему-то при большом числе подключений приложение вылетало, спасала только перезагрузка контейнера web-logger..._

Результаты проверки web-logger с использованием сканера `https://check-host.net/check-http`

![Результаты сканирования](images/scan.png)


## Задача 5  - SQLDUMP

Запуск контейнера из образа `schnitzler/mysqldump` для создания dump-а БД и сохранения в папке `/var/mysl/backup`:
```
docker run --rm --entrypoint "" -v /opt/mysql/backup:/backup --network backend --link=mysql:db schnitzler/mysqldump mysqldump --opt -default-authentication-plugin=mysql_native_password -h db -uroot -p --result-file=/backup/dumps.sql virtd
```

Запуск контейнера `cron-backup` добавлен в [compose.yaml](compose.yaml#L59) - период создания бэкапа - 1 минута.

Сценарий создания резервной копии БД в файле [scripts/backup.sh](scripts/backup.sh)

Настройки crontab в файле [scripts/crontab](scripts/crontab)

Папки:
- `/opt/mysql/data` - файлы БД
- `/opt/mysql/temp` - временные файлы СУБД 
- `/opt/mysql/backup` - бэкапы БД

Прежде чем запустить контейнеры необходимо дать правильные права доступа и указать владельцев файлов:
```
chown 0:0 ./scripts/backup.sh
chmod 700 ./scripts/backup.sh
chown 0:0 ./scripts/crontab
chmod 600 ./scripts/crontab
```

Результаты создания бэкапов

![Содержимое папки /backup](images/backup-files.png)

![Журнал работы cron](images/backup-logs.png)


## Задача 6  - Terraform

### 6.1 - Использование инструментов (dive)

1. Скачивание образа:
```
docker pull hashicorp/terraform:latest
```

2. Сохранение образа на локальную машину:
```
docker save hashicorp/terraform:latest > terraform.tar
```

3. Исследование образа с помощью утилиты dive (_портебовалось преобразовать образ с помощью skopeo, так как с какой-то версии он не поддерживается утилитой_):
```
skopeo --insecure-policy copy docker-archive:terraform.tar docker-archive:terraform_skopeo.tar
dive --source docker-archive terraform_skopeo.tar
```

4. Поиск слоя, копирующего файл /bin/terraform (запоминаем его ID)

![слой с файлом /bin/terraform](images/terraform-dive.png)

5. В папке архива образа `blobs/sha256` берем файл с найденным в п.4 ID, распаковываем его, и оттуда копируем файл `terraform`.

![содержимое слоя с terraform](images/terraform-bin.png)


### 6.2, 6.3 - Использование только docker

1. Создание [Dockerfile.terraform](Dockerfile.terraform), в котором на основе образа hashicorp/terraform:latest создается папка `/opt/terraform/bin`, в которую копируется файл `/bin/terraform`

2. Создание своего контейнера - `terrabash`, в котором уже имеется файл `/opt/terraform/bin/terraform`, а также есть `bash`.
```
docker build -f Dockerfile.terraform -t terrabash .
```

3. Запуск контейнера `terrabash` и проброс локальной временной папки внутрь контейнера.
```
docker run -it --rm -v /home/admin/temp:/tmp terrabash
```

4. Копирование файла внутри контейнера terrabash:
```
cp /opt/terraform/bin/terraform /tmp
```

5. Завершение работы контейнера (`exit`) и работа с файлом `/home/admin/temp/terraform`!






## Задача 7  - runc

### Задание

Запустите ваше python-приложение с помощью runC, не используя docker или containerd.
Предоставьте скриншоты действий .









# Задание
[https://github.com/netology-code/virtd-homeworks/tree/shvirtd-1/05-virt-04-docker-in-practice](https://github.com/netology-code/virtd-homeworks/tree/shvirtd-1/05-virt-04-docker-in-practice)
