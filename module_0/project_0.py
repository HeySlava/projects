#!/usr/bin/env python
# coding: utf-8

# In[32]:


import numpy as np
import math
count = 0                            # счетчик попыток
number = np.random.randint(1,101)    # загадали число
print ("Загадано число от 1 до 100")     

def score_game(game_core):
    '''Запускаем игру 1000 раз, чтобы узнать, как быстро игра угадывает число'''
    count_ls = []
    np.random.seed(1)  # фиксируем RANDOM SEED, чтобы ваш эксперимент был воспроизводим!
    random_array = np.random.randint(1,101, size=(1000))
    for number in random_array:
        count_ls.append(game_core(number))
    score = int(np.mean(count_ls))
    print(f"Мой алгоритм угадывает число в среднем за {score} попытки")
    return(score)

def game_core_v2(number):
    '''Функция использует данные больше или меньше, деля на 2 область, 
       где находится число.
       Функция возвращает число попыток'''
    predict = 50
    max_pred = 100  # максимальное предполагаемое число
    min_pred = 0  # минимальное предполагаемое число
    count = 1
    
    while number != predict: # условие завершения цикла
        count += 1
        if number < predict:
            max_pred = predict
            predict = math.ceil((predict + min_pred) / 2)
            
        if number > predict:
            min_pred = predict
            predict = math.ceil((predict + max_pred) / 2)
    return count

score_game(game_core_v2)


# In[ ]:




