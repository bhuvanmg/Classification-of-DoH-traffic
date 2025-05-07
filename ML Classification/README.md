## Classification of DoH traffic generated using ML models


Dataset used - dga_dataset.csv , dnsexfil_dataset.csv

# Classifier Performance Comparison

This table summarizes the performance of three classification models — k-Nearest Neighbors, Naive Bayes, and Random Forest.

| Classifier       | Accuracy | Precision         | Recall         | F1-Score         |
|------------------|----------|-------------------|----------------|------------------|
| k-NN             | 0.9586   | 0.96              | 0.96           | 0.96             |
| Naive Bayes      | 0.8650   | 0.86              | 0.88           | 0.86             |
| Random Forest    | 0.9714   | 0.97              | 0.97           | 0.97             |


## Observations

- **Random Forest** performed the best across all metrics.
- **k-NN** showed strong performance, close to Random Forest.
- **Naive Bayes** had relatively lower precision and recall, particularly for class 0(dga), but still achieved decent results.
