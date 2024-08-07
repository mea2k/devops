# УПРАВЛЯЮЩИЕ КОНСТРУКЦИИ В TERRAFORM

## Задание 1 - Инициализация проекта

В результате выполнения исходного кода были созданы:
- сеть `develop`
- подсеть `develop` с диапазоном адресов 10.0.1.0/24
- группа безопасности `example_dynamic` с правилами фильтрации входящего и исходящего трафика

![Группа безопасности example_dynamic](images/z1-yandex-security-group.png)


## Задание 2 - Циклы

1. Создан файл [count-vm.tf](count-vm.tf). В нем описано создание двух __одинаковых__ ВМ `web-NN` с использованием `count`. Параметры ВМ заданы в переменной `var.vms_resources["web"]` ([variables.tf](variables.tf#L61)). 

2. Создан файл [for_each-vm.tf](for_each-vm.tf). В нем описано создание двух __разных__ ВМ `main` и '`replica` с использованием `for_each`. Параметры ВМ заданы в переменной `var.vms_resources` ([variables.tf](variables.tf#L72)). В блоке `locals` происходит поиск параметров ВМ по имени из словаря `var.vms_resources` с проверкой на существование указанных имен. В результате формируется список из имен ВМ, которые надо создать.

3. Добавлена зависимость: ВМ `web-NN` создаются _после_ ВМ `main` и `replica` ([count-vm.tf](count-vm.tf#L46)).

4. Добавлен файл с SSH-ключами (в папку проекта/.ssh). Настроено использование файла `id_ed25519.pub` для SSH-подключения (см. файл [locals.tf](locals.tf)).

5. Настроен вывод информации об IP-адресах созданных ВМ ([outputs.tf](outputs.tf)).

![Созданные ВМ](images/z2-yandex-vms.png)


## Задание 3 - виртуальные диски

1. Создан файл [disk_vm.tf](disk_vm.tf), в котором описано создание __трех одинаковых__ дисков типа `yandex_compute_disk` с помощью `count`.


2. Создана ВМ `storage` с дисками из п.1. с использованием блока `dynamic` ([disk_vm.tf](disk_vm.tf#L40)).


## Задание 4 - Ansible

Создан файл [ansible.tf](ansible.tf). В нем вызывается шаблонизатор на основе файла [hosts.tftpl](hosts.tftpl). Параметры шаблона:
- `webservers` - список ВМ `web-NN`
- `databases` - список ВМ СУБД (`main`, `replica`)
- `storage` - список ВМ хранилища (`storage`)

В результате работы формируется файл [hosts.ini](hosts.ini)

![Файл hosts.ini](images/z4-hosts-ini.png)


## Дополнительные задания (со звездочкой*)

_Не успеваю - модуль закрывается через 2 дня. В спокойном режиме сделаю и обновлю репозиторий.._


# Задание
[https://github.com/netology-code/ter-homeworks/blob/main/03/hw-03.md](https://github.com/netology-code/ter-homeworks/blob/main/03/hw-03.md)
