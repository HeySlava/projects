#!/usr/bin/env python
# coding: utf-8

# In[1]:


import random
import math 
date = {}
count_list = []

def game():
    '''Функция использует данные больше или меньше, деля на 2 область, 
       где находится число.
       Функция возвращает загаданное сгенерированное число и число попыток'''
    predict = 88
    max_pred = 100  # максимальное предполагаемое число
    min_pred = 0  # минимальное предполагаемое число
    number = random.randint(1, max_pred)
    count = 1
    
    while number != predict:
        count += 1
        if number < predict:
            max_pred = predict
            predict = math.ceil((predict + min_pred) / 2)
            
        if number > predict:
            min_pred = predict
            predict = math.ceil((predict + max_pred) / 2)
            
    return (predict, count)


for repeat in range(1000):  # количество тестов для выявления среднего попыток отгадывания
    count_list.append(game()[1])
    
average = sum(count_list) / len(count_list)

print('Мой алгоритм отгадывает число в среднем за {} попыток'.format(average))

