#############################################################################################################
# ggplot2 script for plotting a bubble chart showing the divergence of CVL and Plasma SGA sequences from the TMF 
# virus over time. The bubble size shows the relative abundance of sequences normalized by the number of CVL/Plasma 
# SGA sequences per timepoint.
#############################################################################################################
# Install required packages
library(tidyverse)
library(grid)
library(plyr)
library(reshape2)
library(cowplot)
# Import csv file containing divergence and relative abundance data
# csv file must contain columns time, divergence, rel_abun and origin
setwd("/Users/dale/Dropbox/Rdata/batsi_data") #Point R to directory where your raw data in csv file is located
data<-read.csv2("grouped_divergence.csv", header = T, dec='.') #import csv file, dec needed otherwise imports this field as factors
data<-unique(data) #get rid of any duplicate entries
data$time<-as.factor(data$time) #Change the Time to factor data class, if not done ggplot will plot time on a continuous x-axis even though our visits are not evenly spaced
is.factor(data$time) #QC step to check Time was changed to factor data class
data$rel_abun<-data$rel_abun*100 #csv files from Batsi had rel_abun as fractions so needed to add this to converet to percentage values
factor(data$Participant, ordered = "T")
# Plot bubble plot
bubble.plot=ggplot(data, aes(x=time, y=divergence, size=rel_abun)) + # Set x and y variables and the variable to be used for bubble size. 
  geom_point(position = position_jitter(width = 0.2), colour='black', shape= 21, stroke= 0.6, alpha=0.8, aes(fill=origin)) + #Add horizontal jitter, bubble stransparency (alpha) and black outline (shape and stroke) to make overlapping bubbles clearer
  scale_fill_manual(name='Sample type', values=c('blue', 'red'))+ #Stipulate name of headings in legend and change colour of bubbles
  scale_size_area(name='Relative abundance (%)', max_size=12, limits=c(5,80), breaks=c(5,10,20,40,80))+ #Stipulate name of headings in legend and adjust the relatvie scale of bubbles using max_size. Limits and breaks used to ensure constant legend for all plots. 
  guides(fill=guide_legend(order=1, override.aes = list(size = 4)),
         area=guide_legend(order = 2))+# Format the legend using "guides" function: Stipulate order of the two legends using "order" and increase symbol size by using "override.aes"
  scale_y_continuous(limits = c(0,6.5), breaks = c(0,2,4,6))+
  xlab('Time after infection (weeks)')+ # Change x-axis label
  ylab("Sequence divergence from transmitted\nfounder virus (%)") # Change y-axis label (\n makes new line in label)
bubble.plot
# Divide bubble.plot into three different facets based on participant
facet.plot <- bubble.plot + facet_grid(. ~ Participant, scales = 'free_x', space = 'free_x')+
theme(strip.text.x = element_text(face = 'bold')) # make participant labels in plot bold text
facet.plot
# Save output to svg file
ggsave(filename='grouped_divergence_plot.svg',width = 70, height = 14, units = "cm") #Save plot to svg output for customization inkscape, width and height are in cm