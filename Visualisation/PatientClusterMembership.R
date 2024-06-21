library(tidyverse)
library(extrafont)
library(sysfonts)
library(ggrepel)
library(ggpubr)
library(RColorBrewer)
library(forcats)
setwd('/Users/alicesmail/Desktop/Modules/Chromatinopathy_GitHub/')

# Read csvs
PatientClusterLabels <- read.csv('PatientClusterLabels.csv')
PatientGenes <- read.csv('PatientsGroupedbyGene.csv')

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

# Plot                                                                                     
plot <- ggplot(PatientClusterSum, aes(x=reorder(gene, -NumberofPatients), y=n, fill=factor(cluster, levels=c(5,1,2,4,11,3,10,6,7,8,9,12)))) +
  geom_col(position="stack", colour='black', size=0.4, width=0.8) +
  labs(y='Number of Patients', x='Gene', fill='Cluster')+
  theme_bw()+
  scale_x_discrete(expand=expansion(add=c(1,1)))+
  scale_y_continuous(limits=c(0,90),expand=expansion(add=c(0,0)))+
  scale_fill_manual(values=c('5'='#d10000','1'='#db5e00','2'='#e4a52b',
                             '4'='#e7d044','11'='#cdcb68','3'='#93b572',
                             '10'='#80b8a2','6'='#5f8fb0','7'='#6e6e92',
                             '8'='#804d7e','9'='#bc5589','12'='#db7979'),
                    labels =c('1: Neurodevelopmental & Speech Abnormalities',
                               '2: Facial Dysmorphologies',
                               '3: Behavioural Abnormalities',
                               '4: Strabismus & Limb Abnormalities',
                               '5: Growth Abnormalities',
                               '6: Skull & Skeletal Dysmorphologies',
                               '7: Abnormal Muscle Tone',
                               '8: Growth Delay & Constipation',
                               '9: Heart Abnormalities',
                               '10: Cryptorchidism',
                               '11: No Specific Phenotypes',
                               '12: Cataract & Microphthalmia'))+
  theme(legend.position=c(0.6, 0.6), 
        legend.background=element_blank(),
        legend.box.background=element_rect(colour="black"),
        legend.title=element_text(size=14, family="Franklin Gothic Medium"),
        legend.margin=margin(10, 10, 10, 10),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.border=element_rect(size=1),
        text=element_text(size=12, family="Franklin Gothic Book"),
        axis.text.x=element_text(angle=90, vjust=0.5, hjust=1)) +
  guides(fill=guide_legend(ncol=2))

# Save
ggsave(file="/Users/alicesmail/Desktop/Modules/Chromatinopathy_GitHub/FinalDraft/GitHub/Figures/PatientClusterMembership.png", plot=plot, width=9, height=4)

# Switch order of bars                                                                                     
plot <- ggplot(PatientClusterSum, aes(x=reorder(gene, -NumberofPatients), y=n, fill=factor(cluster, levels=c(12,9,8,7,6,10,3,11,4,2,1,5)))) +
  geom_col(position="stack", colour='black', size=0.4, width=0.8) +
  labs(y='Number of Patients', x='Gene', fill='Cluster')+
  theme_bw()+
  scale_x_discrete(expand=expansion(add=c(1,1)))+
  scale_fill_manual(values=c('12'='#db7979', '9'='#bc5589', '8'='#804d7e',
                             '7'='#6e6e92','6'='#5f8fb0','10'='#80b8a2',
                             '3'='#93b572','11'='#cdcb68','4'='#e7d044',
                             '2'='#e4a52b','1'='#db5e00','5'='#d10000'))+
  theme(legend.position='none', 
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.border=element_rect(size=1),
        text=element_text(size=12, family="Franklin Gothic Book"),
        axis.text.x=element_text(angle=90, vjust=0.5, hjust=1)) 

# Save
ggsave(file="/Users/alicesmail/Desktop/Modules/Chromatinopathy_GitHub/FinalDraft/GitHub/Figures/PatientClusterMembershipFlipped.png", plot=plot, width=9, height=4)


