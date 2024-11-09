# df_mapper.py
import sys

for line in sys.stdin:
    document_id, word, count = line.strip().split("@", 2)
    print(f"{document_id}@{word}")
