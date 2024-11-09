# tfidf_mapper.py
import sys
import math

document_frequencies = {}

# Load document frequencies from side input
with open("df_counts.txt") as f:
    for line in f:
        word, df = line.strip().split("\t")
        document_frequencies[word] = int(df)

for line in sys.stdin:
    word, document_id, count = line.strip().split("\t")
    tf = int(count)
    df = document_frequencies.get(word, 1)
    tfidf = tf * math.log(1 + 1 / df)  # Simplified TF-IDF formula
    print(f"{document_id}\t{word}\t{tfidf}")
