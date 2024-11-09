# tf_mapper.py
import sys
import re
from collections import Counter

d = {}

for line in sys.stdin:
    document_id, word, count = line.strip().split("@", 2)
    # convert the string to integer
    try:
        count = int(count)
    except ValueError:
        # if the value is not a number, discard line
        continue

    c = d.get(word, 0)
    d[word] = c + count

for k, v in d.items():
    print(f'{document_id}@{k}@{v}')

