# МЕНЕДЖЕР ПАКЕТОВ HELM В KUBERNETES

## Стенд

Стенд состоит из двух виртуальных машин (ВМ) и хостовой машины:
1. Кластерная ВМ с установленным microk8s - **`cluster`** (Ubuntu 20) IP: **192.168.50.54**
	
	- дополнительно установлены расширения `dashboard`, `ingress`, `hostpath-storage`, `rbac`

2. ВМ управления с установленным kubectl - **`controller`** (Ubuntu 20) IP: **192.168.50.50**
3. Хостовой компьютер - **`host`** (Windows 10) IP: **192.168.50.1**

------

## Задания

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.

------

### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.


------

## Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

[Инструкция  по установке Helm](https://helm.sh/docs/intro/install/).

[Helm completion](https://helm.sh/docs/helm/helm_completion/).

[https://helm.sh/docs/topics/charts/#the-chart-file-structure](https://helm.sh/docs/topics/charts/#the-chart-file-structure).


------

# Задание

[https://github.com/netology-code/kuber-homeworks/blob/main/2.5/2.5.md](https://github.com/netology-code/kuber-homeworks/blob/main/2.5/2.5.md)
