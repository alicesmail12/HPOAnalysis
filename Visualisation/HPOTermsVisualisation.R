library(ggplot2)
library(tidyverse)
library(dplyr)
library(extrafont)
library(ggrepel)

# Get significant HPO terms
setwd('/Users/alicesmail/Desktop/Modules/Chromatinopathy_GitHub/FinalDraft/')
HPOSig <- read.csv('./DataHandlingOutput/genelistOtherHPOSignificant.csv', row.names=1) 

# Check for obsolete terms
HPOSig[- grep("obsolete", HPOSig$HPOTerm, fixed=TRUE),]

# Get top-level terms 
TopLevelTerms <- c('Abnormality of head or neck','Abnormality of limbs',
                   'Abnormality of the digestive system','Abnormality of the integument', 'Growth abnormality')

# Get top-level term labels
HPOSig <- HPOSig %>% mutate(labelTopLevel=ifelse(HPOTerm %in% TopLevelTerms, HPOTerm, NA))
HPOSig <- HPOSig %>% mutate(labelTopLevelNeuro=ifelse(HPOTerm %in% c('Abnormality of the nervous system'), HPOTerm, NA))

# Get most increased terms
HPOSigTail <- HPOSig %>% arrange(delta) %>% filter(is.na(labelTopLevel)) %>% tail(n=2)
deltaTermsTail <- HPOSigTail$HPOTerm

# Get most decreased terms
HPOSigHead <- HPOSig %>% arrange(delta) %>% filter(is.na(labelTopLevel)) %>% head(n=2)
deltaTermsHead <- HPOSigHead$HPOTerm

# Add column for top-level term labels
HPOSig <- HPOSig %>% mutate(labelTopLevel=ifelse(HPOTerm %in% TopLevelTerms, HPOTerm, NA))
HPOSig <- HPOSig %>% mutate(labelDeltaTermsTail=ifelse(HPOTerm %in% deltaTermsTail, HPOTerm, NA))
HPOSig <- HPOSig %>% mutate(labelDeltaTermsHead=ifelse(HPOTerm %in% deltaTermsHead, HPOTerm, NA))

# Plot
plot <- ggplot(HPOSig, aes(x=otherPercent, y=genelistPercent, size=X.log10padj, color=delta))+
  theme_bw()+
  theme(panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        panel.border=element_rect(size=1)) + 
  geom_point()+ geom_abline()+
  scale_x_continuous(limits=c(0,100), expand=c(0.05, 0.01))+
  scale_y_continuous(limits=c(0,100), expand=c(0.05, 0.01))+
  theme(text=element_text(size=12, family="Franklin Gothic Book"))+
  labs(y="Patients with PcG- and TrxG-Associated Conditions (%)", x="Patients in Remainder of DECIPHER (%)")+
  geom_label_repel(label=HPOSig$labelTopLevel, 
                   nudge_y=0, nudge_x=28, label.r=0.15,
                   segment.curvature=0.1, segment.ncp=0.5,
                   segment.angle=45, box.padding=0.1, label.size=0.2, 
                   family= "Franklin Gothic Medium", size=4, color='black',
                   fill= "white")+
  geom_label_repel(label=HPOSig$labelDeltaTermsTail, 
                   nudge_y=20, nudge_x=0, label.r=0.15,
                   segment.curvature=0.1, segment.ncp=0.5,
                   segment.angle=-45, box.padding=0.1, label.size=0.2, 
                   family="Franklin Gothic Book", size=4, color='black',
                   fill="white")+
  geom_label_repel(label=HPOSig$labelDeltaTermsHead, 
                   nudge_y=0, nudge_x=15, label.r=0.15,
                   segment.curvature=0.1, segment.ncp=0.5,
                   segment.angle=45, box.padding=0.1, label.size=0.2, 
                   family="Franklin Gothic Book", size=4, color='black',
                   fill="white")+
  geom_label_repel(label=HPOSig$labelTopLevelNeuro, 
                   nudge_y=5.5, nudge_x=0, label.r=0.15,
                   segment.curvature=0.1, segment.ncp=0.5,
                   segment.angle=45, box.padding=0.1, label.size=0.2, 
                   family="Franklin Gothic Medium", size=4, color='black',
                   fill="white")+
  scale_color_gradient2(low="#A1D5D2", mid="#f7eb86", high="#ee4800",
                        aesthetics="color",limits=c(-10.3, 21))+
  scale_size_continuous(range=c(2,15), limits=c(1,30))+
  guides(color=guide_legend(title='-log10(adj pval)'), size=guide_legend(title='-log10(adj pval)'))+
  theme(legend.position='none', 
    legend.justification=c(0.9, 0.1), 
    legend.background=element_blank(),
    legend.box.background=element_rect(colour="black"),
    legend.title=element_text(size=10))
plot
ggsave('./Figures/HPOTermsEnriched.png', plot=plot, width=8, height=5)






