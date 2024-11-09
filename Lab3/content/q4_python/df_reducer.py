# df_reducer.py
import sys
from collections import defaultdict

document_count = defaultdict(set)

for line in sys.stdin:
    document_id, word = line.strip().split("@", 1)
    document_count[document_id].add(word)

for document, words in document_count.items():
    print(f"{document}@{len(words)}")
