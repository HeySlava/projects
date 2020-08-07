#!/usr/bin/env python
# coding: utf-8

# In[377]:


import random
import math 
date = {}
new_list = []
def game(predict):
    max_pred = 100 
    min_pred = 0
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
    
for i in range (1, 101): # перебор первого предполагаемого числа от 0 до 100
    for j in range(1000): # количество тестов для каждого числа от 0 до 100
        new_list.append(game(i)[1])
    average = sum(new_list) / len(new_list)
    date[i] = average
print(date)
for pred, aver in date.items():
    if aver == min(date.values()):
        print('При начальном предполагаемом числе {}, в среднем отгадывется за {} попыток'.format(pred, aver))


# In[81]:


round(13 // 2)

