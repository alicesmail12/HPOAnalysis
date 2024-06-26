library(tidyverse)
library(extrafont)
library(sysfonts)
library(ggrepel)
library(ggpubr)
library(RColorBrewer)
library(forcats)
setwd('/Users/alicesmail/Desktop/Modules/Chromatinopathy_GitHub/FinalDraft/GitHub/ClusteringPatientsOutput')

# Read csv
PatientClusterLabels <- read.csv('PatientClusterLabels.csv')
PatientGenes <- PatientClusterLabels %>% group_by(gene) %>% summarise(NumberofPatients=n()) %>% as.data.frame()

# Check total number of patients
print(sum(PatientGenes$NumberofPatients))

# Get number of patients in each gene group in each cluster
PatientClusterSum <- PatientClusterLabels %>%
  group_by(gene, cluster) %>%
  summarise(n=n())

# Get cluster number
PatientClusterSum <- merge(PatientClusterSum, PatientGenes) %>% select(gene, cluster, n, NumberofPatients)

# Change elements to factors
PatientClusterSum$gene <- factor(PatientClusterSum$gene)
PatientClusterSum$cluster <- factor(PatientClusterSum$cluster)

# Switch order of bars                                                                                     
plot <- ggplot(PatientClusterSum, aes(x=reorder(gene, -NumberofPatients), y=n, fill=factor(cluster, levels=c(12,11,10,9,8,7,6,5,4,3,2,1)))) +
  geom_col(position="stack", colour='black', size=0.4, width=0.8) +
  labs(y='Number of Patients', x='Gene', fill='Cluster')+
  theme_bw()+
  scale_x_discrete(expand=expansion(add=c(1,1)))+
  scale_fill_manual(values=c('12'='#db7979', '11'='#bc5589', '10'='#804d7e',
                             '9'='#6e6e92','8'='#5f8fb0','7'='#80b8a2',
                             '6'='#93b572','5'='#cdcb68','4'='#e7d044',
                             '3'='#e4a52b','2'='#db5e00','1'='#d10000'))+
  theme(legend.position='none', 
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.border=element_rect(size=1),
        text=element_text(size=12, family="Franklin Gothic Book"),
        axis.text.x=element_text(angle=90, vjust=0.5, hjust=1)) 
plot
