# ИСПОЛЬЗОВАНИЕ ANSIBLE (INVENTORY)

## Основное задание
1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.

Файл: [playbook/inventory/prod.yml](playbook/inventory/prod.yml#L19) - добавлена группа узлов `lighthouse`, состоящая из одного узла `lighthouse-01` на базе Fedora Core 37

Файл [playbook/site.yml](playbook/site.yml#L77) - добавлена работа 'Install Nginx for Lighthouse' и 'Install Lighthouse'

3. Подготовьте свой inventory-файл prod.yml.

Файл [playbook/inventory/prod.yml](playbook/inventory/prod.yml) описывает группы серверов:
- `clickhouse` - состоит из одного узла `clickhouse-01` на базе Fedora Core 37 с устанавливаемой БД Clickhouse
- `vector` - состоит из одного узла `vector-01` на базе Fedora Core 37 с устанавливаемой системой Vector
- `lighthouse` - состоит из одного узла `lighthouse-01` на базе Fedora Core 37 с устанавливаемым web-сервером nginx и скачиваемым проектом lighthouse из git-репозитория `https://github.com/VKCOM/lighthouse.git` (переменная `lighthouse_vcs`)

4. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

_Ошибок нет_

5. Попробуйте запустить playbook на этом окружении с флагом `--check`.

Команда:
```
ansible-playbook site.yml -i inventory/prod.yml --check
```

Результат:
```
PLAY [Install Clickhouse] *************************************************************************
TASK [Gathering Facts] ****************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] *********************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
ok: [clickhouse-01] => (item=clickhouse-common-static)

TASK [Install clickhouse packages] ****************************************************************
ok: [clickhouse-01]

TASK [Flush handlers to restart clickhouse] *******************************************************
TASK [Create database] ****************************************************************************
skipping: [clickhouse-01]

PLAY [Install vector] *****************************************************************************
TASK [Gathering Facts] ****************************************************************************
ok: [vector-01]

TASK [Get vector distrib] *************************************************************************
ok: [vector-01]

TASK [Install vector packages] ********************************************************************
ok: [vector-01]

TASK [Flush handlers to restart vector] ***********************************************************
TASK [Configure Vector | ensure what directory exists] ********************************************
ok: [vector-01]

TASK [Configure Vector | Template config] *********************************************************
ok: [vector-01]

PLAY [Install Nginx for Lighthouse] ***************************************************************
TASK [Gathering Facts] ****************************************************************************
ok: [lighthouse-01]

TASK [install nginx] ******************************************************************************
ok: [lighthouse-01]

TASK [create config] ******************************************************************************
ok: [lighthouse-01]

PLAY [Install Lighthouse] *************************************************************************
TASK [Gathering Facts] ****************************************************************************
ok: [lighthouse-01]

TASK [install dependencies for clickhouse] ********************************************************
ok: [lighthouse-01]

TASK [create Lighthouse directory] ****************************************************************
ok: [lighthouse-01]

TASK [make git safe directory] ********************************************************************
changed: [lighthouse-01]

TASK [clone from Git] *****************************************************************************
ok: [lighthouse-01]

TASK [create lighthouse config] *******************************************************************
ok: [lighthouse-01]

PLAY RECAP ****************************************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0
lighthouse-01              : ok=9    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

```

В итоге изменился только узел `lighthouse-01`. Остальные без изменений с предыдущей ДЗ.

6. Запустите playbook на prod.yml окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

Команда:
```
ansible-playbook site.yml -i inventory/prod.yml --diff
```

Результат:
```
PLAY RECAP ********************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0  
  ignored=0
lighthouse-01              : ok=9    changed=1    unreachable=0    failed=0    skipped=0    rescued=0  
  ignored=0
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0  
  ignored=0

```

7. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

Результат:
```
TASK [make git safe directory] ************************************************************************
changed: [lighthouse-01]

TASK [clone from Git] *********************************************************************************
ok: [lighthouse-01]

TASK [create lighthouse config] ***********************************************************************
ok: [lighthouse-01]

PLAY RECAP ********************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0  
  ignored=0
lighthouse-01              : ok=9    changed=1    unreachable=0    failed=0    skipped=0    rescued=0  
  ignored=0
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0  
  ignored=0
```


8. Готовый playbook выложите в свой репозиторий, поставьте тег 08-ansible-03-yandex на фиксирующий коммит, в ответ предоставьте ссылку на него.



# Задание
[https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-03-yandex](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-03-yandex)
