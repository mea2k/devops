# ХРАНЕНИЕ В KUBERNETES. VOLUMES

## Стенд

Стенд состоит из двух виртуальных машин (ВМ) и хостовой машины:
1. Кластерная ВМ с установленным microk8s - `cluster` (Ubuntu 20) IP: 192.168.50.54
	
	- дополнительно установлены расширения `dashboard`, `ingress`

2. ВМ управления с установленным kubectl - `controller` (Ubuntu 20) IP: 192.168.50.50
3. Хостовой компьютер - `host` (Windows 10) IP: 192.168.50.1

## Задания

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.


### Задание 2

**Что нужно сделать**

Создать DaemonSet приложения, которое может прочитать логи ноды.

1. Создать DaemonSet приложения, состоящего из multitool.
2. Обеспечить возможность чтения файла `/var/log/syslog` кластера MicroK8S.
3. Продемонстрировать возможность чтения файла изнутри пода.
4. Предоставить манифесты Deployment, а также скриншоты или вывод команды из п. 2.


## Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

[Дополнительные материалы](https://github.com/netology-code/devkub-homeworks/tree/main/13-kubernetes-config)

[Инструкция по установке MicroK8S](https://microk8s.io/docs/getting-started).

[Описание Volumes](https://kubernetes.io/docs/concepts/storage/volumes/).

[Описание Multitool](https://github.com/wbitt/Network-MultiTool).


# Задание

[https://github.com/netology-code/kuber-homeworks/blob/main/2.1/2.1.md](https://github.com/netology-code/kuber-homeworks/blob/main/2.1/2.1.md)
