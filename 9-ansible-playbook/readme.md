# ANSIBLE PLAYBOOK


## Основная часть

1. Подготовьте свой inventory-файл prod.yml. 

Файл [playbook/inventory/prod.yml](playbook/inventory/prod.yml) описывает три группы узлов:
- `clickhouse` (состоит из 1 ВМ `clickhouse-01` на базе Fedora Core 37)
- `vector` (состоит из 1 ВМ `vector-01` на базе Fedora Core 37)
- `local` - localhost

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает vector. Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по ссылке. не забудьте сделать handler на перезапуск vector в случае изменения конфигурации!
При создании tasks рекомендую использовать модули: get_url, template, unarchive, file.
Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.

Файл: [playbook/site.yml](playbook/site.yml)

3. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

_Ошибок нет_

4. Попробуйте запустить playbook на этом окружении с флагом `--check`.

Команда:
```
ansible-playbook site.yml -i inventory/prod.yml --check
```

Результат:
```
PLAY [Install Clickhouse] *********************************************************************************
TASK [Gathering Facts] ************************************************************************************ok: [clickhouse-01]

TASK [Get clickhouse distrib] *****************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
ok: [clickhouse-01] => (item=clickhouse-common-static)

TASK [Install clickhouse packages] ************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers to restart clickhouse] ***************************************************************
TASK [Create database] ************************************************************************************skipping: [clickhouse-01]

PLAY [Install vector] *************************************************************************************
TASK [Gathering Facts] ************************************************************************************ok: [vector-01]

TASK [Get vector distrib] *********************************************************************************
ok: [vector-01]

TASK [Install vector packages] ****************************************************************************
ok: [vector-01]

TASK [Flush handlers to restart vector] *******************************************************************
TASK [Configure Vector | ensure what directory exists] ****************************************************
ok: [vector-01]

TASK [Configure Vector | Template config] *****************************************************************
changed: [vector-01]

PLAY RECAP ************************************************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
vector-01                  : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

_Комментарии: запускалось второй раз, после исправления ошибки, возникшей на группе серверов vector. Поэтому clickhouse - без изменений, vector - изменен._

5. Запустите playbook на prod.yml окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

Команда
```
ansible-playbook site.yml -i inventory/prod.yml --diff
```

Результат:
```
PLAY [Install Clickhouse] *********************************************************************************
TASK [Gathering Facts] ************************************************************************************ok: [clickhouse-01]

TASK [Get clickhouse distrib] *****************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
ok: [clickhouse-01] => (item=clickhouse-common-static)

TASK [Install clickhouse packages] ************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers to restart clickhouse] ***************************************************************
TASK [Create database] ************************************************************************************ok: [clickhouse-01]

PLAY [Install vector] *************************************************************************************
TASK [Gathering Facts] ************************************************************************************ok: [vector-01]

TASK [Get vector distrib] *********************************************************************************
ok: [vector-01]

TASK [Install vector packages] ****************************************************************************
ok: [vector-01]

TASK [Flush handlers to restart vector] *******************************************************************
TASK [Configure Vector | ensure what directory exists] ****************************************************
ok: [vector-01]

TASK [Configure Vector | Template config] *****************************************************************
--- before
+++ after: /home/admin/.ansible/tmp/ansible-local-9436kizhl3l_/tmpocbqm82k/vector.yml.j2
@@ -0,0 +1,10 @@
+---
+null
+...
+
+
+# Warning: This file is Ansible Managed, manual changes will be overwritten on next playbook run.
+#!/usr/bin/env bash
+
+# export VECTOR_HOME=/src/vector
+# export PATH=$PATH:$VECTOR_HOME/bin
\ No newline at end of file

changed: [vector-01]

PLAY RECAP ************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
vector-01                  : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

6. Повторно запустите playbook с флагом --diff и убедитесь, что playbook идемпотентен.

Повторный запуск не выявил изменений:
```
PLAY RECAP ************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


08-ansible-02-playbook 




# ЗАДАНИЕ
[https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-02-playbook](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-02-playbook) 
