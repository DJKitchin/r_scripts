##########################################
# Install required packages
##########################################
install.packages("devtools")
devtools::install_github("jaredhuling/jcolors")
library(jcolors)
library(tidyverse)
library(ggthemes)
library(svglite)
library(cowplot) # this package adds publication style theme and gives plot annotation abilities to ggplot2 for publication quality figures
###########################################
# Stipulate csv file
###########################################
setwd("/Users/dale/Desktop/Analyses")
csv.file <- "/Users/dale/Desktop/Analyses/G3_UCALc&G3Hc.csv"
data <- read.csv2(csv.file, header = T, dec='.') %>% as.tibble() #import csv file, dec needed otherwise imports this field as factors
shapes <- c(24,23,22,21,8,4,3,7)
plot <- ggplot(data, aes(x=mAb, y=titre))+
  geom_point(aes(fill=PSV, shape=PSV), size=5, stroke=1.5)+
  geom_line(aes(group=PSV),colour="black", size=1)+
  scale_y_log10(limits=c(0.015,70), expand=c(0.03,0))+#give the y axis a log10 scale with limits of 20-20000 and major ticks/divisions of 20,100,1000 and 10000. expand places/displaces first tick/data point at position away from axes.  
  annotation_logticks(base=10, sides = "l")+ #add minor log ticks to left hand side axis only (y axis).
  ylab(expression(paste("Titer"," (IC"[50],')')))+
  scale_shape_manual(values = c(24,7,23,3,22,4,21,8))+
  scale_color_jcolors(palette = "pal8")
plot + theme( panel.background = element_rect(fill = "white",colour = "black",size = 1, linetype = "solid"),
              axis.text.x = element_text(size=18),
              axis.text.y = element_text(size=16),
              axis.ticks.length = unit(.2, "cm"),
              axis.title.y = element_text(size = rel(1.5), angle = 90),
              axis.title.x = element_text(size = rel(1.5)))
ggsave(filename='G3_UCALc&G3Hc.pdf', width = 18, height = 12, units = "cm") #Save plot to pdf output for customization in inkscape, width and height are in cm
