# СИСТЕМЫ МОНИТОРИНГА

## Обязательные задания

1. Вас пригласили настроить мониторинг на проект. На онбординге вам рассказали, что проект представляет из себя платформу для вычислений с выдачей текстовых отчётов, которые сохраняются на диск. Взаимодействие с платформой осуществляется по протоколу http. Также вам отметили, что вычисления загружают ЦПУ. Какой минимальный набор метрик вы выведите в мониторинг и почему?

__Ответ:__

	Для HTTP минимальным набором метрик является:

	- время отклика (среднее, пиковое)

	- общее количество запросов (среднее, пиковое)

	- количество запросов, которые обрабатываются за секунду за последний интервал (requests per second) 

	- количество 4xx, 5xx ответов по отношению к общему количеству запросов (коэффициент ошибок)

2. Менеджер продукта, посмотрев на ваши метрики, сказал, что ему непонятно, что такое RAM/inodes/CPUla. Также он сказал, что хочет понимать, насколько мы выполняем свои обязанности перед клиентами и какое качество обслуживания. Что вы можете ему предложить?

__Ответ:__

	RAM - утилизация оперативной памяти

	INodes - информация о файловой системе

	CPUla - информация о нагруженности ЦПУ

	Далее по метрикам можно посчитать количество ошибочных запросов (`mem_allocate_error`, `IO_error`) по отношению к общему числу запросов. Если коэффициент < 1, то соглашение с пользователем выполняется (можно уточнять про "количество девяток и уровень соглашения").

	По утилизации CPU можно построить график, например, в grafana, и посмотреть среднюю и пиковую загрузку. Если они не достигают 100% - соглашение с пользователем выполняется.

3. Вашей DevOps-команде в этом году не выделили финансирование на построение системы сбора логов. Разработчики, в свою очередь, хотят видеть все ошибки, которые выдают их приложения. Какое решение вы можете предпринять в этой ситуации, чтобы разработчики получали ошибки приложения?

__Ответ:__

	Я рекомендую использовать PUSH-модель сбора метрик, поскольку её легче реплицировать и настраивать. А разработчикам можно предоставить доступ к API или графической системе анализа логов для контроля разработки продукта.

	Таким образом, одна система будет использоваться как для DevOps, так и для разработки, что сильно сблизит обе команды и заставит их тесно сотрудничать.

4. Вы, как опытный SRE, сделали мониторинг, куда вывели отображения выполнения SLA = 99% по http-кодам ответов. Этот параметр вычисляется по формуле: summ_2xx_requests/summ_all_requests. Он не поднимается выше 70%, но при этом в вашей системе нет кодов ответа 5xx и 4xx. Где у вас ошибка?

__Ответ:__

	Необходимо учитывать еще и ответы с кодами 3xx (кэшированные данные) - по сути это тоже успешные ответы, берущиеся из кеш-памяти и не нагружающие сервер. Кстати, чем их больше, тем больше экономятся вычислительные ресурсы!

## Дополнительное задание* (со звёздочкой)

Реализовано и описано тут: [pyMonitor/](pyMonitor/)

# ЗАДАНИЕ

[https://github.com/netology-code/mnt-homeworks/tree/MNT-video/10-monitoring-01-base](https://github.com/netology-code/mnt-homeworks/tree/MNT-video/10-monitoring-01-base)
