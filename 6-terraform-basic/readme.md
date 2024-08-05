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





# ЗАДАНИЕ
[https://github.com/netology-code/ter-homeworks/blob/main/02/hw-02.md](https://github.com/netology-code/ter-homeworks/blob/main/02/hw-02.md)
