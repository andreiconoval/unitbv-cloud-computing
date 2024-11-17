#!/usr/bin/env python3
import sys
from collections import defaultdict

# Dictionaries to store totals and individual word counts
total_counts = defaultdict(int)
word_counts = defaultdict(dict)

# Process input from the mapper
for line in sys.stdin:
    try:
        key, count = line.strip().rsplit(" ", 1)
        count = int(count)
    except ValueError:
        continue  # Skip malformed lines
    
    document_id, word = key.split("@", 1)
    total_counts[document_id] += count
    word_counts[document_id][word] = count

# Output the results in the desired format
for document_id, words in word_counts.items():
    total_words = total_counts[document_id]
    for word, count in words.items():
        print(f"{document_id}@{total_words}@{word} {count}")
