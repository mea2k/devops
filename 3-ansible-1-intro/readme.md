# ВВЕДЕНИЕ В ANSIBLE

## Основное задание

1. Попробуйте запустить playbook на окружении из test.yml, зафиксируйте значение, которое имеет факт some_fact для указанного хоста при выполнении playbook.

Команда:
```
ansible-playbook site.yml -i inventory/test.yml
```

Результат:
```
PLAY [Print os facts] **************************************************************
TASK [Gathering Facts] *************************************************************
ok: [localhost]

TASK [Print OS] ********************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ******************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP *************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

2. Найдите файл с переменными (`group_vars`), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.

Файл: [playbook/group_vars/all/examp.yml](playbook/group_vars/all/examp.yml)

Команда:
```
ansible-playbook site.yml -i inventory/test.yml
```

Результат:
```
PLAY [Print os facts] ********************************************************************
TASK [Gathering Facts] *******************************************************************
ok: [localhost]

TASK [Print OS] **************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ************************************************************************
ok: [localhost] => {
    "msg": "default fact"
}

PLAY RECAP *******************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0  
  rescued=0    ignored=0
```

3. Воспользуйтесь подготовленным (используется docker) или создайте собственное окружение для проведения дальнейших испытаний.

_3 docker-контейнера: AltLinux, CentOs7, Ubuntu_ 

Файл [playbook/inventory/prod.yml](playbook/inventory/prod.yml)

Файл [playbook/site.yml](playbook/site.yml)


4. Проведите запуск playbook на окружении из prod.yml. Зафиксируйте полученные значения `some_fact` для каждого из managed host.

Запуск:
```
docker run -it --name centos centos:7 /bin/bash
docker run -it --name ubuntu ubuntu:20.04 /bin/bash
docker run -it --name altlinux alt /bin/sh
ansible-playbook site.yml -i inventory/prod.yml
```

Результат:
```
PLAY [install python3 on centos] **********************************************************
TASK [install python3] ********************************************************************
changed: [centos]

PLAY [install python3 on AltLinux] ********************************************************
TASK [install python3] ********************************************************************
changed: [altlinux]

PLAY [install python3 on Ubuntu] **********************************************************
TASK [install python3] ********************************************************************
changed: [ubuntu]

PLAY [Print os facts] *********************************************************************
TASK [Gathering Facts] ********************************************************************
ok: [ubuntu]
ok: [altlinux]
ok: [centos]
ok: [localhost]

TASK [Print OS] ***************************************************************************
ok: [centos] => {
    "msg": "CentOS"
}
ok: [altlinux] => {
    "msg": "Altlinux"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *************************************************************************
ok: [centos] => {
    "msg": "el"
}
ok: [altlinux] => {
    "msg": "alt"
}
ok: [ubuntu] => {
    "msg": "default fact"
}
ok: [localhost] => {
    "msg": "default fact"
}

PLAY [Set default tmp dir] ****************************************************************
TASK [Gathering Facts] ********************************************************************
ok: [localhost]
ok: [altlinux]
ok: [ubuntu]
ok: [centos]

PLAY RECAP ********************************************************************************
altlinux                   : ok=5    changed=1    unreachable=0    failed=0    skipped=0   
 rescued=0    ignored=0
centos                     : ok=5    changed=1    unreachable=0    failed=0    skipped=0   
 rescued=0    ignored=0
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=0   
 rescued=0    ignored=0
ubuntu                     : ok=5    changed=1    unreachable=0    failed=0    skipped=0   
 rescued=0    ignored=0
```

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.Повторите запуск playbook на окружении prod.yml. Убедитесь, что выдаются корректные значения для всех хостов.

Изменены файлы:
- [playbook/group_vars/alt/examp.yml](playbook/group_vars/alt/examp.yml)
- [playbook/group_vars/el/examp.yml](playbook/group_vars/el/examp.yml)
- [playbook/group_vars/ubuntu/examp.yml](playbook/group_vars/ubuntu/examp.yml)

Результат:
```
TASK [Print fact] *************************************************************************ok: [centos] => {
    "msg": "el default fact"
}
ok: [altlinux] => {
    "msg": "alt default fact"
}
ok: [ubuntu] => {
    "msg": "ubuntu default fact"
}
ok: [localhost] => {
    "msg": "default fact"
}
```

6. При помощи ansible-vault зашифруйте факты в group_vars/deb и group_vars/el с паролем netology. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь в работоспособности.

Добавлены файлы:
- [playbook/group_vars/el/secret.yml](playbook/group_vars/el/secret.yml)
- [playbook/group_vars/el/secret.yml](playbook/group_vars/ubuntu/secret.yml)

Они зашифрованы с помощью команд:
```
ansible-vault encrypt group_vars/el/secret.yml
ansible-vault encrypt group_vars/ubuntu/secret.yml
```

Запуск с зашифрованным хранилищем и запросом пароля:
```
ansible-playbook site.yml -i inventory/prod.yml --ask-vault-password
```

Результат:
```
TASK [Print secret] ***********************************************************************
ok: [centos] => {
    "msg": "CentOS secret"
}
ok: [ubuntu] => {
    "msg": "Ubuntu secret"
}
```

7. Посмотрите при помощи ansible-doc список плагинов для подключения. Выберите подходящий для работы на control node.

8. В `prod.yml` добавьте новую группу хостов с именем local, в ней разместите localhost с необходимым типом подключения. Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь, что факты some_fact для каждого из хостов определены из верных group_vars.
Добавлена группа в [prod.yml](playbook/inventory/prod.yml#L15)
```
  local:
    hosts:
      localhost:
        ansible_connection: local
```

Результаты работы:
```
TASK [Print fact] *************************************************************************
ok: [centos] => {
    "msg": "el default fact"
}
ok: [altlinux] => {
    "msg": "alt default fact"
}
ok: [ubuntu] => {
    "msg": "ubuntu default fact"
}
ok: [localhost] => {
    "msg": "default fact"
}

PLAY [Print secrets] **********************************************************************
TASK [Gathering Facts] ********************************************************************
ok: [ubuntu]
ok: [centos]

TASK [Print secret] ***********************************************************************
ok: [centos] => {
    "msg": "CentOS secret"
}
ok: [ubuntu] => {
    "msg": "Ubuntu secret"
}
```




## Необязательная часть - _часть задач реализована в основной части_
1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

2. Зашифруйте отдельное значение PaSSw0rd для переменной some_fact паролем netology. Добавьте полученное значение в group_vars/all/exmp.yml.
Запустите playbook, убедитесь, что для нужных хостов применился новый fact.

3. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. 

4. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.


# Задание
[https://github.com/netology-code/ter-homeworks/blob/main/03/hw-03.md](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-01-base)
