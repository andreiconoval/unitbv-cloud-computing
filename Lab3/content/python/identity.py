#!/usr/bin/env python3

import sys
import re

# read input from stdin, line by line
for line in sys.stdin:
  words = line.split()
  print(' '.join(words))
