import sys
from collections import defaultdict

# Dictionary to store unique words and their counts per document
document_words = defaultdict(dict)
# Dictionary to store total word count per document
document_total_count = defaultdict(int)

# Process each line from the input
for line in sys.stdin:
    document_id, word, count = line.strip().split("@", 2)
    count = int(count)
    
    # Add word count to the document's total word count
    document_total_count[document_id] += count
    
    # Store the word count for each unique word in the document
    document_words[document_id][word] = count

# Output in the desired format
for document_id, words in document_words.items():
    total_words = document_total_count[document_id]
    for word, count in words.items():
        print(f"{document_id}@{total_words}@{word}@{count}")