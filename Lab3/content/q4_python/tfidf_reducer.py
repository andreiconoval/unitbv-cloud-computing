import sys
import math

# Initialize variables to track the total number of documents (N)
document_count = 0
word_document_map = {}  # To track which words appeared in which documents

# Process each line from the mapper
for line in sys.stdin:
    document_id, word, count, total_words = line.strip().split("\t")
    count = int(count)
    total_words = int(total_words)

    # Update the document count (we process one line per document)
    if document_id not in word_document_map:
        document_count += 1
        word_document_map[document_id] = set()

    # Track which words appeared in which documents
    word_document_map[document_id].add(word)

    # Calculate TF
    tf = count / total_words  # Term frequency (TF)

    # Store TF in a temporary map
    if word not in word_document_map:
        word_document_map[word] = []
    word_document_map[word].append((document_id, tf))

# Now calculate the IDF and output TF-IDF
for word, doc_info in word_document_map.items():
    # Calculate DF: count how many documents the word appeared in
    doc_count = len(set([doc for doc, _ in doc_info]))  # Set of documents with the word

    # Calculate IDF
    idf = math.log(document_count / (1 + doc_count))  # 1 + DF to avoid division by 0

    # Output TF-IDF for each word
    for document_id, tf in doc_info:
        tfidf = tf * idf
        print(f"{document_id}\t{word}\t{tfidf:.6f}")
