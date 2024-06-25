# HPO Analysis (May 2023 - June 2024)
**Input files**: The gene list of 129 genes used for this project is saved as `genelist.csv`. Information about each gene, including uniprot ID, protein description, length and GO terms, was gathered from uniprot.org.

**Analysis Notebooks**:
- `DECIPHERDataHandling.ipynb` filters the DECIPHER dataset using the gene list and performs various statistical tests.
- `DECIPHERClusteringPatients.ipynb` perfoms hierarchical clustering on the filtered dataset.
- `DECIPHERClusteringGeneGroups.ipynb` groups patients by gene and performs hierarchical clustering.

