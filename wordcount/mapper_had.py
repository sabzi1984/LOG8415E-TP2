#!/usr/bin/python3
import sys

for row in sys.stdin:
    row = row.strip()
    words = row.split()
    for word in words:

        print(f'{word},\t,1')