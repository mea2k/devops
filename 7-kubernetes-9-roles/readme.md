# УПРАВЛЕНИЕ ДОСТУПОМ В KUBERNETES. USER, SERVICEACCOUNT, ROLE, RBAC

## Стенд

Стенд состоит из двух виртуальных машин (ВМ) и хостовой машины:
1. Кластерная ВМ с установленным microk8s - **`cluster`** (Ubuntu 20) IP: **192.168.50.54**
	
	- дополнительно установлены расширения `dashboard`, `ingress`, `hostpath-storage`

2. ВМ управления с установленным kubectl - **`controller`** (Ubuntu 20) IP: **192.168.50.50**
3. Хостовой компьютер - **`host`** (Windows 10) IP: **192.168.50.1**

------

## Задания

### Задание 1. Создайте конфигурацию для подключения пользователя

1. Создайте и подпишите SSL-сертификат для подключения к кластеру.
2. Настройте конфигурационный файл kubectl для подключения.
3. Создайте роли и все необходимые настройки для пользователя.
4. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).
5. Предоставьте манифесты и скриншоты и/или вывод необходимых команд.

------

## Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

[Описание RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).

[Пользователи и авторизация RBAC в Kubernetes](https://habr.com/ru/company/flant/blog/470503/).

[RBAC with Kubernetes in Minikube](https://medium.com/@HoussemDellai/rbac-with-kubernetes-in-minikube-4deed658ea7b).

------

# Задание

[https://github.com/netology-code/kuber-homeworks/blob/main/2.4/2.4.md](https://github.com/netology-code/kuber-homeworks/blob/main/2.4/2.4.md)
