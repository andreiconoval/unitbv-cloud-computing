#!/usr/bin/env python

import sys

max = int(sys.argv[1])
maxWord = None

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

  if count > max:
    max = count
    maxWord = word

print '%s %d' % (maxWord, max)
