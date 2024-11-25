# ЖИЗНЕННЫЙ ЦИКЛ ПО

Создано 2 проекта на платформе atlassian.net: [https://djira.atlassian.net/jira/software/projects/SC/boards/1](https://djira.atlassian.net/jira/software/projects/SC/boards/1)

## Доска Kanban

В проекте созданы 4 задачи типа `task`:
- Add feature 1
- Add feature 2
- Test feature 1
- Test feature 2

Дополнительно созданы 2 задачи типа `bug`:
- Fix bug 1
- Fix bug 2


Задачи переносились между столбцами со стасусами:
- Open -> On reproduce.
- On reproduce -> Open, Done reproduce.
- Done reproduce -> On fix.
- On fix -> On reproduce, Done fix.
- Done fix -> On test.
- On test -> On fix, Done.
- Done -> Closed, Open.

![Workflow](./kanban01.png)


## Доска Scrum

Перечень задач аналогичен предыдущему проекту
![Sprint_workflow_](./scrum01.png)


Создано 2 спринта
1. __Спринт 1__
- Add feature 1
- Add feature 2
- Test feature 1
- Test feature 2

![Sprint1](./scrum03.png)



2. __Спринт 2__
- Fix bug 1
- Fix bug 2

![Sprint1](./scrum04.png)


В рамках спринтов было движение задач
`Open -> In progress -> Done -> In progress -> Done`



# Задание
[https://github.com/netology-code/mnt-homeworks/blob/MNT-video/09-ci-01-intro/README.md](https://github.com/netology-code/mnt-homeworks/blob/MNT-video/09-ci-01-intro/README.md)
