# HPO Analysis (May 2023 - June 2024)
Datasets required: The gene list of 129 genes used for this project is saved as genelist.csv. Information about each gene, including uniprot ID, protein description, length and GO terms, was gathered from uniprot.org. The DECIPHER dataset has not been uploaded as it requires an access agreement.

`DECIPHERDataHandling.ipynb` filters the DECIPHER dataset using the gene list and performs various statistical tests: the output of this script is a filtered csv. `DECIPHERClusteringPatients.ipynb` perfoms hierarchical clustering on the filtered dataset, and `DECIPHERClusteringGeneGroups.ipynb` groups patients by gene and performs hierarchical clustering.

