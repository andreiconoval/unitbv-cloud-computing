#!/usr/bin/env python3

import sys
from collections import defaultdict

# Get the top K value from arguments
try:
    K = int(sys.argv[1])
except (IndexError, ValueError):
    print("Please provide a valid integer for K.")
    sys.exit(1)

# Dictionary to store word counts
word_counts = defaultdict(int)

# Read input from stdin
for line in sys.stdin:
    if len(line.strip()) == 0:
        continue
    
    # strip and split into word and count
    word, count = line.strip().split(' ', 1)

    # convert the string to integer
    try:
        count = int(count)
    except ValueError:
        # if the value is not a number, discard line
        continue
    
    # Accumulate counts for each word
    word_counts[word] += count

# Sort words by frequency and take the top K
top_k_words = sorted(word_counts.items(), key=lambda x: x[1], reverse=True)[:K]

# Print the top K words and their counts
for word, count in top_k_words:
    print(f'{word} {count}')
