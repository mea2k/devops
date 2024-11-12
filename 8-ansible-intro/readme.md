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



Проведите запуск playbook на окружении из prod.yml. Зафиксируйте полученные значения some_fact для каждого из managed host.
Добавьте факты в group_vars каждой из групп хостов так, чтобы для some_fact получились значения: для deb — deb default fact, для el — el default fact.
Повторите запуск playbook на окружении prod.yml. Убедитесь, что выдаются корректные значения для всех хостов.
При помощи ansible-vault зашифруйте факты в group_vars/deb и group_vars/el с паролем netology.
Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь в работоспособности.
Посмотрите при помощи ansible-doc список плагинов для подключения. Выберите подходящий для работы на control node.
В prod.yml добавьте новую группу хостов с именем local, в ней разместите localhost с необходимым типом подключения.
Запустите playbook на окружении prod.yml. При запуске ansible должен запросить у вас пароль. Убедитесь, что факты some_fact для каждого из хостов определены из верных group_vars.
Заполните README.md ответами на вопросы. Сделайте git push в ветку master. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым playbook и заполненным README.md.
Предоставьте скриншоты результатов запуска команд.






## Необязательная часть


# Задание
[https://github.com/netology-code/ter-homeworks/blob/main/03/hw-03.md](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/08-ansible-01-base)
