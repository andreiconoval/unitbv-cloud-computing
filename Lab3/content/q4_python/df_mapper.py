#!/usr/bin/env python3
import sys

# Mapper reads input line by line
for line in sys.stdin:
    # Split the line into fields (documentId, word, wordcount)
    try:
        document_id, word, count = line.strip().split("@", 2)
        count = int(count)  # Convert count to integer
    except ValueError:
        continue  # Skip malformed lines
    
    # Emit the word and its count
    print(f"{document_id}@{word} {count}")
    