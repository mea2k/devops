# БАЗОВЫЕ ОБЪЕКТЫ K8S

## Стенд

Стенд состоит из двух виртуальных машин (ВМ) и хостовой машины:
1. Кластерная ВМ с установленным microk8s - `cluster` (Ubuntu 20) IP: 192.168.50.54
2. ВМ управления с установленным kubectl - `controller` (Ubuntu 20) IP: 192.168.50.50
3. Хостовой компьютер - `host` (Windows 10) IP: 192.168.50.1

## Задания

### Задание 1. Создать Pod с именем hello-world

1. [Манифест]( описания PodСоздать манифест (yaml-конфигурацию) Pod.
2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

------

### Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.
2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.
3. Создать Service с именем netology-svc и подключить к netology-web.
4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).


## Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

Описание [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) и примеры манифестов.

Описание [Service](https://kubernetes.io/docs/concepts/services-networking/service/).







[Getting started with Kubernetes: kubectl and microk8s on Ubuntu](https://dev.to/urlichsanais/getting-started-with-kubernetes-kubectl-and-microk8s-on-ubuntu-pko?ysclid=m7bysw7tyz850254682)

[Working with kubectl](https://microk8s.io/docs/working-with-kubectl)

[Addon: dashboard](https://microk8s.io/docs/addon-dashboard)

[Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.

[Инструкция](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/#bash) по установке автодополнения **kubectl**.

[Шпаргалка](https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/) по **kubectl**.


# Задание

[https://github.com/netology-code/kuber-homeworks/blob/main/1.2/1.2.md](https://github.com/netology-code/kuber-homeworks/blob/main/1.2/1.2.md)
