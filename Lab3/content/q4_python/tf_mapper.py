# tf_mapper.py
import sys
import re
import os
from collections import Counter

# Get the filename from the Hadoop environment variable
document_path = os.getenv("mapreduce_map_input_file", "Dumas-TheBorgias.txt")
document_id = os.path.basename(document_path) # Extract just the filename


all_text = ""
for line in sys.stdin:
    all_text += line.strip() + " "

words = re.findall(r'\w+', all_text.lower())
word_counts = Counter(words)

for word, count in word_counts.items():
    print(f"{document_id}@{word}@{count}")