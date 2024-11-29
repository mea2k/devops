# РАБОТА С JENKINS

## Инфраструктура

Для создангия и настройки инфраструктуры использованы инструменты:
- __terraform__ - создание виртуальных машин
- __ansible__ - настройка программных коипонентов

### Создание инфраструктуры в Yandex.Cloud с использованием terraform

Был подготовлен проект [terraform](./terraform/), состоящий из файлов:
- требуемые провайдеры для работы с Yandex.Cloud ([terraform/providers.tf](terraform/providers.tf))

- переменные для настройки инфраструктуры ([terraform/variables.tf](terraform/variables.tf))

- значение переменных ([terraform/variables.auto.tfvars](terraform/variables.auto.tfvars))

- описание типов, количества и параметров ВМ ([terraform/vm_jenkins.tf](terraform/vm_jenkins.tf))

- главный файл ([terraform/main.tf](terraform/main.tf))

- шаблон для генерации файла inventory для Ansible ([terraform/templates/hosts.tpl](terraform/templates/hosts.tpl))


#### __Запуск__

1. Задать переменные для работы с Yandex.Cloud (`secret.auto.tfvars`)

2. Задать параметры ВМ в файле [terraform/vm_jenkins.tf](terraform/vm_jenkins.tf)

3. Запустить terraform
```
terraform -chdir=terraform apply
```

#### __Результат__
Файл [playbook/inventory/hosts.yml](playbook/inventory/hosts.yml) с актуальными IP-адресами созданных ВМ


### Настройка узлов с использованием ansible

Проект [ansible](playbook/) был существенно переработан:

1. Созданы роли:
- [jenkins-master](playbook/roles/jenkins-master/)
- [jenkins-agent](playbook/roles/jenkins-agent/)

2. Существенно упрощен код основного файла [playbook/site.yml](playbook/site.yml)

3. Переработано для работы под ОС Ubuntu


#### __Запуск__

Для запуска необходимо выполнить команды:
```
cd playbook
ansible-playbook site.yml -i inventory/hosts.yml
```





# Задание
[https://github.com/netology-code/mnt-homeworks/tree/MNT-video/09-ci-04-jenkins](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/09-ci-04-jenkins)
