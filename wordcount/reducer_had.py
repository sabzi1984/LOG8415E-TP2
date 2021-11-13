#!/usr/bin/python3

import sys

current_word = None
current_count = 0
word = None

for row in sys.stdin:
    row = row.strip()

    word, count = row.split('\t', 1)

    if current_word == word:
        current_count += count
    else:
        if current_word:
            print(f'{current_word}\t{current_count}')
        current_count = count
        current_word = word

if current_word == word:
    print(f'{current_word}\t{current_count}')
    
    
    
    