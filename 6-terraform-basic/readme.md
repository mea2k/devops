# ОСНОВЫ РАБОТЫ С TERRAFPRM

## Задание 1 - Подготовка и запуск проекта

Исправлены некоторые ошибки, создан вервисный аккаунт, к проекту добавлен файл с ключами (authorized_key.json).

Результат создания и запуска ВМ в консоле Yzndex.Cloud
![Результат создания ВМ в Яндекс.Облаке](images/z1-yandex_cloud.png)

Результат подключения по SSH к созданной ВМ
![Подключение по SSH к созданной ВМ](images/z1-ifconfig.png)


## Задание 2 - Создание переменных

Дополнен файл [variables.tf](variables.tf) и исправлен файл [main.tf](main.tf) для использования переменных. Теперь "хард-кода" нет!

Все работает так же, даже дешевле _(комбинация standard-v3 + 20%CPU + preemptible=true на текущий момент самая дешевая)_.


## Задание 3 - Создание двух ВМ

Созданы файлы:
  - [vm_web_platform.tf](vm_web_platform.tf) - переменные, описывающие ВМ web-платформы
	- [vm_db_platform.tf](vm_db_platform.tf) - переменные, описывающие ВМ СУБД
	
Дополнен файл [main.tf](main.tf) - добавлена новая ВМ `netology-develop-platform-db` в зоне "ru-central1-b".

Результат создания ВМ в Yandex.Cloud
![Создание ВМ в Yandex.Cloud](images/z3-yandex_cloud.png)

Результат выполнения команды `ping <VM2>` из SSH-консоли VM1
![Ping VM1 --> VM2](images/z3-ping-vm1-vm2.png)


## Задание 4 - Output

Дополнен файл [outputs.tf](outputs.tf) - добавлен вывод IP-адресов созданных ВМ.
```
$ terraform output

external_ips = [
  {
    "vm_web" = {
      "external" = "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.79.236"
      "internal" = "10.0.1.31"
    }
  },
  {
    "vm_db" = {
      "external" = "ssh -o 'StrictHostKeyChecking=no' ubuntu@51.250.17.109"
      "internal" = "10.0.2.32"
    }
  },
]
```

![Вывод IP-адресов созданных ВМ](images/z4-output.png)


## Задание 5 - Локальные переменные

Добавлено содержимое файла [locals.tf](locals.tf) - добавлена локальная переменная `vms_name`, содержащая словарь с ключами `{"vm_web", "vm_db"}`. Переменная формирует имя ВМ исходя из префикса (`vm_{web|db}_prefix`), типа платформы (`platform_type`) и название ВМ (`vm_{web|db}_name`). Указанные реоеменные добавлены в файлы [variables.tf](variables.tf#L40), [vm_web_platform.tf](vm_web_platform.tf#L2), [vm_db_platform.tf](vm_dbb_platform.tf#L2)


Имена созданных ВМ:
  - `prod-vmdb-platform-db`
	- `prod-vmweb-platform-web` 

## Задание 6 - Единый блок

1. Добавлен блок переменных `vms_resources` в файл [variables.tf](variables.tf#L56).

2. Закомментированы ненужные теперь переменные в файлах [vm_web_platform.tf](vm_web_platform.tf#L38) и [vm_db_platform.tf](vm_db_platform.tf#L38).

3. Добавлен блок локальных переменных `vms_metadata` в файл [locals.tf](locals.tf#L7) - чтобы была возможность проинициализировать значение по умолчанию другой переменной (`var.vms_ssh_root_key`)

4. Исправлен файл [main.tf](main.tf) - изменены ссылки на переменные - теперь всё ссылается только на `vms_resources` и `vms_metadata`.


Результат - создание таких же переменных, что и в прошлых заданиях.




# ЗАДАНИЕ
[https://github.com/netology-code/ter-homeworks/blob/main/02/hw-02.md](https://github.com/netology-code/ter-homeworks/blob/main/02/hw-02.md)
