#!/usr/bin/env python3

import os
import logging
import random
import time
import sys

# importing necessary functions from dotenv library
from dotenv import load_dotenv, dotenv_values
# loading variables from .env file
load_dotenv()

# Убираем вывод на экран Traceback...
sys.tracebacklimit = 0


# шанс ошибки (к 100)
error_chance = int(os.getenv('ERROR_CHANCE')) if os.getenv(
    'ERROR_CHANCE') else 10

# путь к файлу журнала
log_path = os.getenv('LOG_PATH') if os.getenv('LOG_PATH') else './logs'


# имя файла журнала
log_file = os.getenv('LOG_FILE') if os.getenv('LOG_FILE') else 'dice.log'


# Создаем папку для журнала
os.makedirs(log_path, exist_ok=True)


logger = logging.getLogger(__name__)
# logging.basicConfig(encoding='utf-8', format='%(levelname)s:%(message)s', level=logging.DEBUG)
logging.basicConfig(filename=os.path.join(log_path, log_file), encoding='utf-8',
                    format='%(levelname)s:%(message)s', level=logging.DEBUG)

counts = [0 for i in range(0, 7)]


while True:

    number = random.randrange(0, 7)

    rand_error = random.randrange(0, 100)  # шанс ошибки в процентах

    try:
        # проверка, что выпала ошибка
        # (RND < ERROR_CHANCE)
        if rand_error < error_chance:
            raise Exception('Dice has broken!').with_traceback(None) from None

        # бросаем кубик
        # 0 - ребро
        counts[number] = counts[number] + 1
        if number >= 1 and number <= 6:
            logging.info(f'Your dice: {number} ({counts[number]})!')
        elif number == 0:
            logging.info(f'EDGE ({counts[number]})!!')

    except Exception as e:
        logging.error(e)
        time.sleep(2)

    finally:
        time.sleep(1)
