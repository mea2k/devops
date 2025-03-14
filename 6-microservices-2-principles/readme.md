# ПРИНЦИПЫ МИКРОСЕРВИСНОЙ АРХИТЕКТУРЫ

## Задача 1: API Gateway 

### Условие
Предложите решение для обеспечения реализации API Gateway. 
Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.

Решение должно соответствовать следующим требованиям:
- маршрутизация запросов к нужному сервису на основе конфигурации,
- возможность проверки аутентификационной информации в запросах,
- обеспечение терминации HTTPS.

Обоснуйте свой выбор.

### Ответ

Рассматриваемые решения:
- NGINX (с модулем NGINX Plus)
- Kong
- AWS API Gateway
- Traefik
- APISIX
 
Таблица. Сравнение решений

| __Критерий\Решение__                                   | __NGINX__                     | __Kong__                        | __AWS API Gateway__             | __Traefik__                     | __APISIX__                     |
|------------------------------------------------|--------------------------------|----------------------------------|----------------------------------|----------------------------------|---------------------------------|
| _Маршрутизация запросов на основе конфигурации_ | &check; Поддерживает сложные правила маршрутизации | &check; Поддерживает маршрутизацию через плагины | &check; Поддерживает сложную маршрутизацию | &check; Поддерживает динамическую маршрутизацию | &check; Поддерживает сложные правила |
| _Проверка аутентификационной информации_      | &check; С помощью сторонних модулей | &check; Встроенная поддержка          | &check; Интеграция с IAM               | &check; С помощью плагинов            | &check; Поддерживает JWT, OAuth2 и др. |
| _Терминация HTTPS_                           | &check; Поддерживает                | &check; Поддерживает                  | &check; Поддерживает       | &check; Поддерживает                  | &check; Поддерживает                 |
| _Масштабируемость_                           |:warning: Требует настройки           | &check; Поддерживает                       | &check; Автоматическая                 | &check; Поддерживает                  | &#10004; Поддерживает (наилучшие показатели)                     |
| _Мониторинг и логирование_                   | :warning: Ограниченная в базовой версии | &check; Встроенные плагины для логов  | &check; Поддерживает CloudWatch        | &check; С помощью плагинов       | &#10004; Встроенная поддержка         |
| _Поддержка плагинов и расширяемость_         | :warning: Ограниченная                | &check; Широкий выбор плагинов        | :warning: Ограничена                    | &check; Гибкая система плагинов       | &#10004; Наиболее полная поддержка           |
| _Лицензирование_                             | :warning: Платная версия (NGINX Plus) | &check; Open Source + Enterprise      | :warning: Платная                        | &check; Open Source                   | &check; Open Source                  |
| _Удобство настройки_                         | &#10005; Требует опыта               | &check; Простая                       | &check; Управляется через веб-консоль | &check; Простая                       | &#10004; Простая и удобная                      |

__Выбор решения:__
- Если необходима простота настройки, масштабируемость и проверка аутентификации, рекомендуется использовать `Kong`,
так как он предоставляет встроенные возможности для аутентификации, мониторинга, логирования, и поддерживает плагинную систему.
  - используется такими компаниями как Nasdaq, Honeywell, Cisco, FAB, Expedia, Samsung, Siemens и Yahoo Japan.
- Если требуется облачная инфраструктура, рекосендуется `AWS API Gateway` для тесной интеграции с сервисами AWS и автоматического масштабирования.
- Если важна гибкость маршрутизации и использование Open Source решений, рекомендуется `Traefik` или `APISIX`.

Так как задача для крупной компании **Kong**  будет оптимален для большинства случаев:
- простая настройка;
- богатый выбор плагинов;
- встроенная поддержка терминации HTTPS, маршрутизации и проверки аутентификации.


## Задача 2: Брокер сообщений

### Условие

Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.

Решение должно соответствовать следующим требованиям:
- поддержка кластеризации для обеспечения надёжности,
- хранение сообщений на диске в процессе доставки,
- высокая скорость работы,
- поддержка различных форматов сообщений,
- разделение прав доступа к различным потокам сообщений,
- простота эксплуатации.

Обоснуйте свой выбор.

### Ответ

Рассматриваемые решения:
- RabbitMQ
- Apache Kafka
- ActiveMQ Artemis
- Redis Streams
- NATS JetStream

Таблица. Результаты сравнения брокеров сообщений

| __Критерий\Решение__                          | __RabbitMQ__                 | __Apache Kafka__              | __ActiveMQ Artemis__          | __Redis Streams__             | __NATS JetStream__            |
|-----------------------------------------------|------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
| _Кластеризация для обеспечения надёжности_    | &check; Поддерживается (кластер и HA режим) | &check; Поддерживается (репликация и разделы) | &check; Поддерживается (мастер-слейв и HA) | :warning: Ограниченная поддержка (Redis Sentinel) | &check; Поддерживается (кластер JetStream) |
| _Хранение сообщений на диске_                 | &check; Поддерживается            | &check; Поддерживается              | &check; Поддерживается              | &check; Поддерживается              | &check; Поддерживается              |
| _Высокая скорость работы_                     | &check; Высокая для стандартных задач | &#10004; Очень высокая (особенно для больших данных) | &check; Хорошая                     | &#10004; Очень высокая (все данные в ОП)          | &check; Высокая                    |
| _Поддержка различных форматов сообщений_      | &check; Любые форматы             | &check; Любые форматы               | &check; Любые форматы               | &check; Любые форматы               | &check; Любые форматы              |
| _Разделение прав доступа к потокам_           | &check; Поддерживается (RBAC)     | &check; Поддерживается (ACL)        | &check; Поддерживается              | :warning: Ограниченная поддержка      | &check; Поддерживается (ACL)       |
| _Простота эксплуатации_                       | &check; Удобный интерфейс и документация | &#10005; Сложная конфигурация       | :warning: Умеренная сложность         | &check; Простота настройки          | :warning: Умеренная сложность        |
| _Используемая архитектура_                    | Традиционный брокер          | Лог событий (Event Log)       | Традиционный брокер            | In-Memory Streams             | Pub/Sub с устойчивыми потоками |
| _Масштабируемость_                            |  Хорошая                   |  Отличная                    | Ограниченная                | Ограниченная (на уровне Redis кластера) | Отличная                  |
| _Поддержка транзакций_                        | &check; Поддерживается            | &check; Поддерживается              | &check; Поддерживается              | :warning: Ограниченная                | :warning: Ограниченная               |
| _Лицензирование_                              | &check; Open Source               | &check; Open Source                 | &check; Open Source                 | &check; Open Source                 | &check; Open Source                |

Рекомендуемое решение: `Apache Kafka`.

Apache Kafka удовлетворяет всем заявленным требованиям:
- _кластеризация_: надёжная поддержка кластеров, масштабируемость за счёт разделов (partitions) и репликации;
- _хранение сообщений на диске_: сообщения хранятся в логах на диске с поддержкой длительного хранения;
- _высокая скорость_: спроектирован для работы с большими объёмами данных в реальном времени;
- _форматы сообщений_: поддерживает любые форматы (JSON, Avro, Protobuf и др.);
- _разделение прав доступа_: интеграция с ACL для гибкого управления доступом;
- _простота эксплуатации_: не требует большого опыта, но существует множество инструментов для мониторинга и автоматизации
(Kafka Manager, Confluent Control Center).


## Задача 3: API Gateway * (необязательная)

_В процессе... Сделаю позже._


# Дополнительные ссылки
[https://github.com/netology-code/micros-homeworks/blob/main/11-microservices-02-principles.md](https://github.com/netology-code/micros-homeworks/blob/main/11-microservices-02-principles.md)


# Задание

[https://github.com/netology-code/micros-homeworks/blob/main/11-microservices-02-principles.md](https://github.com/netology-code/micros-homeworks/blob/main/11-microservices-02-principles.md)
