import sys
import math

# Dictionary to store document frequencies (DF) for each word
document_frequencies = {}

# Load document frequencies from side input file
with open("df_counts.txt") as f:
    for line in f:
        word, df = line.strip().split("\t")
        document_frequencies[word] = int(df)    

# Process each line from the input
for line in sys.stdin:
    document_id, total_words, word, count = line.strip().split("@")
    total_words = int(total_words)
    tf = int(count) / total_words  # Calculate term frequency (TF)
    df = document_frequencies.get(word, 1)  # Get document frequency (DF) or default to 1
    tfidf = tf * math.log(1 + 1 / df)  # Simplified TF-IDF calculation

    # Output format: document_id, word, tfidf
    print(f"{document_id}\t{word}\t{tfidf}")
