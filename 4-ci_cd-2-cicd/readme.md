# ПРОЦЕССЫ CI/CD

## Подготовка инфраструктуры

Для создания необходимой инфраструктуры был разработан проект [terraform](./terraform/), который создает 2 ВМ в Yandex.Cloud (с самым дешёвым вариантом компоновки) на базе ОС CentOS-7.

Пользовательские переменные:
- описаны в [variables.tf](./terraform/variables.tf) и могут быть заданы в [variables.auto.tfvars](./terraform/variables.auto.tfvars)

- [outputs.tf](./terraform/outputs.tf) - содержит информацию об IP адресах созданных ВМ

### Запуск:

Для запуска необходимо выполнить следующие действия:

1. Указать требуемые значения переменных в файле [variables.auto.tfvars](./terraform/variables.auto.tfvars).

2. Указать значения секретных/недостающих переменных в файле `secret.auto.tfvars`.

3. Запустить создание инфраструктуры:
```
terraform -chdir=./terraform apply
```
Пример результата корректной работы:
```
Outputs:

OS_family = "centos-7"
external_ips = [
  {
    "external" = "ssh -o 'StrictHostKeyChecking=no' admin@<IP>"
    "internal" = "10.0.1.2"
  },
  {
    "external" = "ssh -o 'StrictHostKeyChecking=no' admin@<IP>"
    "internal" = "10.0.1.3"
  },
]
```

4. Проверить, что создан файл инвентаря [inventory](./playbook/inventory/) для playbook Ansible, в котором записаны актуальные IP-адреса.

Пример содержимого файла:
```
---
all:
  hosts:
    prod-vm-cicd-1:
      ansible_host: <IP1>
    prod-vm-cicd-2:
      ansible_host: <IP2>
  children:
    sonarqube:
      hosts:
        prod-vm-cicd-1:
    nexus:
      hosts:
        prod-vm-cicd-2:
    postgres:
      hosts:
        prod-vm-cicd-1:

  vars:
    ansible_connection_type: paramiko
    ansible_user: admin
    ansible_ssh_common_args: '-o StrictHostKeyChecking=no'
```

## Настройка сервисов

Для установки серверного ПО использовался предоставленный [playbook](./playbook/) для Ansible.

В него были внесены изменения и исправления.

- изменена структура папок

- изменен сам файл playbook

- файл inventory теперь автоматически формируется с помощью terraform


Изменения в playbook ([site.yml](./playbook/site.yml)):

1. Исправлен репозиторий centos (файл [CentOS-Base.repo](./playbook/files/CentOS-Base.repo))

2. Исправлена версия PostgreSQL до 14

3. Добавлена задача 'Creates Postgres data directory' (`/var/lib/pgsql/14/data`) - _без нее сервис PostgreSQLне запускался_

4. Исправлены ошибки в _"захардкоженной"_ версии 11 в команде инициализации БД (`/usr/pgsql-{{ postgresql_version }}/bin/postgresql-{{ postgresql_version }}-setup initdb`)

5. Исправлена _"захардкоженная"_ версия 11 в команде Copy pg_hba.conf (`/var/lib/pgsql/{{ postgresql_version }}/data/pg_hba.conf`)


### Запуск

1. Подготовка инфраструктуры, создание ВМ
```
terraform -chdir=./terraform apply
```
В результате появится файл в инфентаре ansible [hosts.yml](./playbook/inventory/hosts.yml), в котором будут содержаться актуальные IP-адреса созданных ВМ

2. Копирование файла публичного ключа (`id_rsa.pub` или `id_ed25519.pub`) в папку `playbook/files`.

3. Запуск playbook
```
cd playbook
ansible-playbook site.yml -i inventory/hosts.yml
```

В результате устанавливаются Nexus, SonarQube, PostgreSQL14, Maven.



# Задание
[https://github.com/netology-code/mnt-homeworks/blob/MNT-video/09-ci-03-cicd/README.md](https://github.com/netology-code/mnt-homeworks/blob/MNT-video/09-ci-03-cicd/README.md)
