#!/usr/bin/env python3

import sys

d = {}

for line in sys.stdin:
    # strip and split considering only the first gap
    word, count = line.strip().split(' ', 1)

    # convert the string to integer
    try:
        count = int(count)
    except ValueError:
        # if the value is not a number, discard line
        continue

    c = d.get(word)
    c = 0 if c is None else c
    d[word] = c + count

for k, v in d.items():
    print(f'{k} {v}')
