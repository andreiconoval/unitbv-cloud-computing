#!/usr/bin/env python

import sys
import re

# read input from stdin, line by line
for line in sys.stdin:
  # strip trailing spaces and split into words
  words = re.split('[\W]+', line.strip())

  # emit <key, value> pairs
  for word in words:
    if word != '':
      print '%s %s' % (word.lower(), 1)
