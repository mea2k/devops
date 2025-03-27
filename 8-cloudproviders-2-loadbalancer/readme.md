# ВЫЧИСЛИТЕЛЬНЫЕ МОЩНОСТИ. БАЛАНСИРОВЩИКИ НАГРУЗКИ (на примере Yandex.Cloud)

## Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашних заданий.

------

## Задания

### Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать файл доступным из интернета.
 
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.
 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
 - Настроить проверку состояния ВМ.
 
3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.
 - Проверить работоспособность, удалив одну или несколько ВМ.

4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.

Пример bootstrap-скрипта:

```
#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>My cool web-server</h1></html>" > index.html
```




__Результаты:__

1. Структура проекта:
    
    [terraform/variables.tf](terraform/variables.tf) - используемые переменные

    [terraform/variables.auto.tfvars](terraform/variables.auto.tfvars) - подставляемые переменные

    [terraform/main.tf](terraform/main.tf) - основной файл с описанием всех ресурсов

    [terraform/outputs.tf](terraform/outputs.tf) - выводимый на экран результат после создания всех ресурсов
    
1. Создание инфраструктуры

    Команда:
    ```
    terraform -chdir=./terraform apply
    ```

    Результат:

    ![Вывод команды terraform](images/terraform-output-01.png)


    Созданные объекты:

    ![Созданные в Yandex Cloud объекты](images/yandex-cloud-summary.png)

    ВМ:

    ![Созданные ВМ](images/vms-01.png)

    Группа ВМ:

    ![Созданная группа ВМ](images/vm-group-01.png)

    Объекты в хранилище (`buckets`):

    ![Buckets](images/bucket-01.png)

    ![Buckets](images/bucket-02.png)

2. Доступ к созданным ресурсам

    1. Доступ к ВМ через публичные IP-адреса:

        ![Доступ к ВМ через публичные IP-адреса](images/vm-web-01.png)

    2. Доступ к ВМ через сетевой балансировщик (`network-balancer`)

        ![Доступ к ВМ через network-balancer](images/network-balancer-01.png)

    3. Доступ к ВМ через балансировщик уровня приложения (`application-balancer`)

        ![Доступ к ВМ через application-balancer](images/application-balancer-01.png)



------

### Задание 2. AWS* (задание со звёздочкой)

Это необязательное задание. Его выполнение не влияет на получение зачёта по домашней работе.

**Что нужно сделать**

Используя конфигурации, выполненные в домашнем задании из предыдущего занятия, добавить к Production like сети Autoscaling group из трёх EC2-инстансов с  автоматической установкой веб-сервера в private домен.

1. Создать бакет S3 и разместить в нём файл с картинкой:

 - Создать бакет в S3 с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать доступным из интернета.

2. Сделать Launch configurations с использованием bootstrap-скрипта с созданием веб-страницы, на которой будет ссылка на картинку в S3. 

3. Загрузить три ЕС2-инстанса и настроить LB с помощью Autoscaling Group.

------

## Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Yandex.Cloud

  - [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group)

  - [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer)

  - [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer)

2. AWS

  - [S3 bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)

  - [Launch Template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template)

  - [Autoscaling group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)

  [Launch configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration)

------ 

# Задание

[https://github.com/netology-code/clopro-homeworks/blob/main/15.2.md](https://github.com/netology-code/clopro-homeworks/blob/main/15.2.md)
