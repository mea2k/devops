# РАБОТА С ROLES В ANSIBLE
  
## Основная часть

1. Создайте в старой версии playbook файл requirements.yml и заполните его содержимым:
```
---
  - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
    scm: git
    version: "1.13"
    name: clickhouse 
```
При помощи `ansible-galaxy` скачайте себе эту роль.

_Команда:_
```
ansible-galaxy install -r requirements.yml -p roles
```

_Файл:_ [playbook/requirements.yml](playbook/requirements.yml)

_Изменения:_ изменен адрес репозитория:
```
src: https://git@github.com/AlexeySetevoi/ansible-clickhouse.git
```

Результат: в папке [roles](playbook/roles/) появилась роль [clickhouse](playbook/roles/clickhouse/) со всей вложенной структурой.


2. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.

_Команда:_
```
ansible-galaxy role init --init-path ./roles/ vector
```

_Результат:_ в папке [roles](playbook/roles/) появилась роль [vector](playbook/roles/vector/) со всей вложенной структурой.

3. На основе tasks из старого playbook заполните новую role. Разнесите переменные между vars и default.

_Файлы:_
  - [playbook/roles/vector/defaults/main.yml](playbook/roles/vector/defaults/main.yml) - содержит переменные
    - `vector_version` - устанавливаемая версия
  
  - [playbook/roles/vector/vars/main.yml](playbook/roles/vector/vars/main.yml) - содержит переменные
    - `vector_config_dir` - путь к файлам конфигурации
    - `vector_config` - дополнительные параметры конфигурации (пока пустой)

4. Перенести нужные шаблоны конфигов в templates.

_Файл:_ [playbook/roles/vector/templates/vector.yml.j2](playbook/roles/vector/templates/vector.yml.j2) - шаблон файла конфигурации Vector

5. Повторите шаги для LightHouse. Помните, что одна роль должна настраивать один продукт.

_Команда:_
```
ansible-galaxy role init --init-path ./roles/ lighthouse
```
_Измененные файлы:_
  1. [playbook/roles/lighthouse/defaults/main.yml](playbook/roles/lighthouse/defaults/main.yml) - изменяемые параметры роли:
    
  - `lighthouse_vcs` - URL репозитория Lighthouse ('https://github.com/VKCOM/lighthouse.git')
  - `lighthouse_location_dir` - путь установки (`/var/www/lighthouse`)
  - `lighthouse_access_log_name` - название журнала доступа к lighthouse (`lighthouse`)

  2. [playbook/roles/lighthouse/vars/main.yml](playbook/roles/lighthouse/vars/main.yml) - неизменяемые параметры роли:

  - `nginx_user_name` - имя пользователя для nginx (`nginx`)

  3. Дополнительные файлы с параметрами роли:
 
  - [playbook/roles/lighthouse/vars/debian.yml](playbook/roles/lighthouse/vars/debian.yml) - переменные для ОС Debian

  - [playbook/roles/lighthouse/vars/fedora.yml](playbook/roles/lighthouse/vars/fedora.yml) - переменные для ОС Fedora Core

  - [playbook/roles/lighthouse/vars/redhat.yml](playbook/roles/lighthouse/vars/redhat.yml) - переменные для ОС Redhat

  - [playbook/roles/lighthouse/vars/centos.yml](playbook/roles/lighthouse/vars/centos.yml) - переменные для ОС CentOS

  - [playbook/roles/lighthouse/vars/empty.yml](playbook/roles/lighthouse/vars/empty.yml) - переменные для других ОС

  4. Handlers: [playbook/roles/lighthouse/handlers/main.yml](playbook/roles/lighthouse/handlers/main.yml)

  5. Tasks:
    
  а) установка дополнительных компонентов:
  - Nginx - [playbook/roles/lighthouse/tasks/dependencies/nginx.yml](playbook/roles/lighthouse/tasks/dependencies/nginx.yml)

  - Git - [playbook/roles/lighthouse/tasks/dependencies/git.yml](playbook/roles/lighthouse/tasks/dependencies/git.yml)

  - Epel-release _(только для CentOS)_ - [playbook/roles/lighthouse/tasks/dependencies/epel.yml](playbook/roles/lighthouse/tasks/dependencies/epel.yml)

  б) конфигурационные файлы:
  - для Nginx - [playbook/roles/lighthouse/tasks/config/nginx.yml](playbook/roles/lighthouse/tasks/config/nginx.yml), на основе шаблона [playbook/roles/lighthouse/templates/nginx.conf.j2](playbook/roles/lighthouse/templates/nginx.conf.j2)
  
  в) установка самого Lighthouse:
  - главный файл - [playbook/roles/lighthouse/tasks/main.yml](playbook/roles/lighthouse/tasks/main.yml)
  - шаблон конфигурационного файла Lighthouse - [playbook/roles/lighthouse/templates/lighthouse.conf.j2](playbook/roles/lighthouse/templates/lighthouse.conf.j2)



6. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в requirements.yml в playbook.

Роль Vector: [https://github.com/mea2k/ansible-roles/tree/main/vector](https://github.com/mea2k/ansible-roles/tree/main/vector)

Роль Lighthouse: [https://github.com/mea2k/ansible-roles/tree/main/lighthouse](https://github.com/mea2k/ansible-roles/tree/main/lighthouse)


7. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения roles с tasks.

Новая версия файла [playbook/requirements.yml](playbook/requirements.yml):
```
---
  - src: https://git@github.com/AlexeySetevoi/ansible-clickhouse.git
    scm: git
    version: "1.13"
    name: clickhouse

  - src: https://github.com/mea2k/ansible-roles/tree/main/vector
    scm: git
    version: "1.0.0"
    name: vector

  - src: https://github.com/mea2k/ansible-roles/tree/main/lighthouse
    scm: git
    version: "1.0.0"
    name: lighthouse
```






# Задание
[https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-04-role](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-04-role)
