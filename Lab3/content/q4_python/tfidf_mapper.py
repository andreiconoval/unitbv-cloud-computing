import sys

# Process each line from the input
for line in sys.stdin:
    document_id, total_words, word, count = line.strip().split("@")
    total_words = int(total_words)  # Total words in the document
    count = int(count)  # Word count for the current word

    # Emit document_id, word, count, and total_words
    print(f"{document_id}\t{word}\t{count}\t{total_words}")