library(tidyverse)
library(extrafont)
library(ggrepel)
library(ggpubr)
library(RColorBrewer)
library(forcats)

# Get phenotype binary matrix for each gene group
phenotypes <- read.csv('decipherPhenotypeMatrix.csv', header=FALSE)

# Set row and column names
colnames(phenotypes) <- phenotypes[1,]
phenotypes <- phenotypes[-1,]

# Get frequency of patients in each group
GeneGroupFreq <- read.csv('PatientsGroupedbyGene.csv', row.names=1)

# Add to binary matrix
phenotypes$TotalPatients <- GeneGroupFreq$NumberofPatients

# Set gene order
geneOrder <- (phenotypes %>% arrange(TotalPatients))$gene

# Make function to get frequency table
phenotypeBarPlot <- function(term){
  
  # Reshape data
  df <- phenotypes %>% select('gene', term, 'TotalPatients') 
  df[term] <- as.numeric(unlist(df[term]))
  df$None <- unlist(df$TotalPatients - df[term])
  df <- df %>% pivot_longer(cols=c(term, 'None'))
  
  # Plot
  ggplot(df, aes(x=factor(gene, levels=geneOrder), y=value, fill=forcats::fct_rev(name))) +
    geom_col(position="stack", colour='black', size=0.4, width=1) +
    coord_flip()+
    theme_bw()+
    scale_x_discrete(expand=expansion(add=c(1,1)))+
    scale_y_continuous(limits=c(0,90),expand=expansion(add=c(0,0.5)))+
    scale_fill_manual(values=c('#f1f2f2', '#939598'))+
    labs(y='Frequency', x='Gene', fill='Phenotype')+
    theme(text=element_text(size=8, family="Franklin Gothic Book"),
          panel.grid.major=element_blank(),
          panel.grid.minor=element_blank(),
          panel.border=element_rect(size=1),
          legend.position='none',
          plot.title=element_text(size=12, family='Franklin Gothic Medium'),          
          axis.title.y=element_blank())
}

# Repeat for each term
nervousSystem <- phenotypeBarPlot('Abnormality of the nervous system')+labs(title='Abnormality of the nervous system')
headNeck <- phenotypeBarPlot('Abnormality of head or neck')+labs(title='Abnormality of head or neck')
integument <- phenotypeBarPlot('Abnormality of the integument')+labs(title='Abnormality of the integument')
growth <- phenotypeBarPlot('Growth abnormality')+labs(title='Growth abnormality')
limbs <- phenotypeBarPlot('Abnormality of limbs')+labs(title='Abnormality of limbs')
digestiveSystem <- phenotypeBarPlot('Abnormality of the digestive system')+labs(title='Abnormality of the digestive system')

# Plot altogether
plot<-ggarrange(nervousSystem, headNeck, integument, growth, limbs, digestiveSystem, ncol=3, nrow=2)+theme(plot.margin=margin(0.1,0.1,0.1,0.1, "cm")) 
ggsave(file="/Users/alicesmail/Desktop/Modules/Chromatinopathy_GitHub/FinalDraft/GitHub/Figures/TermsInEachGeneGroup.png", plot=plot, width=12, height=8)

