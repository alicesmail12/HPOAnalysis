library(tidyverse)
library(extrafont)

# Set colours
revcolour <- '#f1f2f2'
genecolour <- '#939598'

# Parent HPO terms comparison ##################################################
# Get output from data handling
genelistOtherHPO <- read_csv("./DataHandlingOutput/genelistOtherHPOTopLevel.csv")

# Reshape dataframe for visualisation
genelistOtherHPOReshape <- data.frame(term=genelistOtherHPO$HPOTerm,
                                      adj_p_value=genelistOtherHPO$pValAdj,
                                      percent=c(genelistOtherHPO$genelistPercent, genelistOtherHPO$otherPercent),
                                      group=c(rep("genelistPercent", nrow(genelistOtherHPO)), rep("rev", nrow(genelistOtherHPO))))

# Only visualise terms present in 10% of patients 
genelistOtherHPOReshape <- genelistOtherHPOReshape %>%
  filter(percent>10) %>%
  mutate(term=fct_reorder(term, -percent))   

# Plot
HPOTopLevel <- ggplot(genelistOtherHPOReshape, aes(term, percent, fill=group))+
  geom_col(position=position_dodge(width=0.7), width=0.7, colour='black')+
  labs(x="Top-Level HPO Term", y="Patients (%)")+
  coord_flip()+
  geom_text(data=subset(genelistOtherHPOReshape, percent > 0), aes(label=round(percent, 1),), 
            hjust=-0.2, position=position_dodge(width=0.7), size=5, family="Franklin Gothic Book")+
  scale_y_continuous(limits=c(0, 100))+
  geom_text(aes(label=ifelse(adj_p_value < (0.005), "***", "")), y=max(genelistOtherHPOReshape$percent), hjust=26.8, size=7)+
  geom_text(aes(label=ifelse(adj_p_value < (0.01) & adj_p_value > (0.005), "**", "")), y=max(genelistOtherHPOReshape$percent), hjust=0, size=7)+
  geom_text(aes(label=ifelse(adj_p_value < (0.05) & adj_p_value > (0.01), "*", "")), y=max(genelistOtherHPOReshape$percent), hjust=79.5, size=7)+
  scale_fill_manual(values=c("rev"=revcolour, "genelistPercent"=genecolour), name="Group", labels=c("PcG/TrxG (n=462)", "Rest of DECIPHER (n=5070)"))+ 
  theme_bw()+
  theme(panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.border=element_rect(size=1),
        text=element_text(size=20, family="Franklin Gothic Book"),
        legend.position=c(0.78, 0.85),
        legend.margin=margin(15,15,15,15),
        legend.background=element_blank(),
        legend.box.background=element_rect(colour="black"),
        legend.title=element_text(size=16, family="Franklin Gothic Medium")) 

# Save
ggsave(file="./Figures/HPOTermsTopLevel.png", plot=HPOTopLevel, width=14, height=7.5)

# Number of top-level terms per patient ########################################
# Get output from data handling
HPOBins <- read.csv("./DataHandlingOutput/HPOTopLevelPercent.csv")

# Reshape
HPOBinsReshape <- data.frame(hpo_freq=HPOBins$X,
                             percent=c(HPOBins$genelistPercent, HPOBins$otherPercent),
                             group=c(rep("genelistPercent", nrow(HPOBins)), rep("otherPercent", nrow(HPOBins))))

# Plot
HPOPerPatient1 <- ggplot(HPOBinsReshape, aes(x=hpo_freq, y=percent, fill=group))+
  theme_bw()+
  theme(panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.border=element_rect(size=1))+ 
  geom_col(position=position_dodge(width=0.9), width=0.9, colour='black')+
  geom_text(aes(label=round(percent, 1)), position=position_dodge(width=0.9), vjust=-0.25, size=3.25)+
  labs(x="Top-Level HPO Terms per Patient", y="Patients (%)")+
  theme(text=element_text(size=16, family="Franklin Gothic Book"))+
  scale_x_continuous(n.breaks=20, expand=c(0.01, 0.01))+
  scale_y_continuous(limits=c(0,20),expand=c(0, 0))+
  theme(legend.position=c(0.98, 0.9),
        legend.justification=c("right", "top"),
        legend.box.just="right",
        legend.margin=margin(15, 15, 15, 15),
        legend.background=element_blank(),
        legend.box.background=element_rect(colour="black"),
        legend.title=element_text(size=16, family="Franklin Gothic Medium"))+
  scale_fill_manual(values=c("genelistPercent"=genecolour, "otherPercent"=revcolour), 
                    labels=c("PcG/TrxG (n=462)", "Rest of DECIPHER (n=5070)"), name="Group")

# Save
ggsave(file="TopLevelHPOTermsPerPatient.png", plot=HPOPerPatient1, width=14, height=4)

# Number of unpropagated terms per patient #####################################
HPOBins <- read.csv("./DataHandlingOutput/histogram.csv")

# Reshape
HPOBinsReshape <- data.frame(bin=(HPOBins$bin),
                             percent=c(HPOBins$genelistPercent, HPOBins$otherPercent),
                             group=c(rep("genelistPercent", nrow(HPOBins)), rep("otherPercent", nrow(HPOBins))))

# Define order of x-axis
group_order <- c("1-4", "5-9", "10-14", "15-19", "20-24", "25-29", "30-34", "35-39")
HPOBinsReshape$bin <- factor(HPOBinsReshape$bin, levels=group_order)

# Plot
HPOPerPatient2 <- ggplot(HPOBinsReshape, aes(x=bin, y=percent, fill=group))+
  theme_bw()+
  theme(panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.border=element_rect(size=1))+ 
  geom_col(position=position_dodge(width=0.9), width=0.9, colour='black')+
  geom_text(aes(label=paste0(round(percent, 2)),), position=position_dodge(width=0.9), vjust=-0.25, size=3.25)+
  labs(x="HPO Terms per Patient", y="Patients (%)")+
  theme(text=element_text(size=16, family="Franklin Gothic Book"))+
  scale_x_discrete(expand=c(0.08, 0.08))+
  scale_y_continuous(limits=c(0,50),expand=c(0, 0))+
  theme(legend.position=c(0.98, 0.9),
        legend.justification=c("right", "top"),
        legend.box.just="right",
        legend.margin=margin(15, 15, 15, 15),
        legend.background=element_blank(),
        legend.box.background=element_rect(colour="black"),
        legend.title=element_text(size=16, family="Franklin Gothic Medium"))+
  scale_fill_manual(values=c("genelistPercent"=genecolour, "otherPercent"=revcolour), 
                    labels=c("PcG/TrxG (n=462)", "Rest of DECIPHER (n=5070)"), name="Group")

# Save
ggsave(file="HPOTermsPerPatient.png", plot=HPOPerPatient2, width=14, height=4)
