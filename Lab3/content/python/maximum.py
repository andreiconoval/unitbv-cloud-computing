#!/usr/bin/env python3

import sys

max_count = int(sys.argv[1])
max_word = None

for line in sys.stdin:
  if len(line) == 0:
    continue

  # strip and split considering only the first gap
  word, count = line.strip().split(' ', 1)

  # convert the string to integer
  try:
    count = int(count)
  except ValueError:
    # if the value is not a number, discard line
    continue

  if count > max_count:
    max_count = count
    max_word = word

print(f'{max_word} {max_count}')
