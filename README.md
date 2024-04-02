# HPO_analysis
Datasets required: The full gene list of 129 genes used for this project is uploaded here as gene_list.csv. Information about each gene, including uniprot ID, protein description, length and GO terms, was gathered from uniprot.org. The DECIPHER dataset has not been uploaded here as it requires an access agreement.

The data_handling.ipynb file filters the DECIPHER dataset using the gene list and performs various statistical tests. The sole output of this script is a filtered dataset csv.

The clustering_gene_groups.ipynb file uses the filtered dataset csv to group patients by gene and perform hierarchical clustering. 

