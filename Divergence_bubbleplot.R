#############################################################################################################
# ggplot2 script for plotting a bubble chart showing the divergence of CVL and Plasma SGA sequences from the TMF 
# virus over time. The bubble size shows the relative abundance of sequences normalized by the number of CVL/Plasma 
# SGA sequences per timepoint. Lineplot is added to show the SGA sampling depth at each timepoint.
#############################################################################################################
# Install required packages
library(tidyverse)
library(grid)
library(plyr)
library(reshape2)
library(cowplot)
# Import csv file containing divergence and relative abundance data
setwd("/Users/dale/Documents/Rdata") #Point R to directory where your raw data in csv file is located
data<-read.csv2("divergence2.csv", header = T, dec='.') #import csv file, dec needed otherwise imports this field as factors
data<-unique(data) #get rid of any duplicate entries
data$time<-as.factor(data$time) #Change the Time to factor data class, if not done ggplot will plot time on a continuous x-axis even though our visits are not evenly spaced
is.factor(data$time) #QC step to check Time was changed to factor data class
# New dataframe containing the total number of CVL and plasma SGA sequences per time point
seq_data<-unique(subset.data.frame(data, select=c(time, seq_no, origin)))
seq_data<-arrange(seq_data, desc(time)) #arrange entries from first to last time point
seq_data<-rbind(seq_data, c(2,0,'CVL')) #add data entry for CVL at 2 wpi
seq_data<-rbind(seq_data, c(28,0,'CVL')) #add data entry for CVL at 28 wpi
seq_data$seq_no<-as.numeric(seq_data$seq_no) #Change seq_no entries to numeric data class, if not done ggplot will plot these on a discrete y-axis as it sees them as factors
is.numeric(seq_data$seq_no) # QC step...check that seq_no data class was changed to numeric
# Plot bubble plot
bubble.plot=ggplot(data, aes(x=time, y=divergence, size=rel_abun)) + # Set x and y variables and the variable to be used for bubble size. 
  geom_point(position = position_jitter(width = 0.12), colour='black', shape= 21, stroke= 0.6, alpha=0.8, aes(fill=origin)) + #Add horizontal jitter, bubble stransparency (alpha) and black outline (shape and stroke) to make overlapping bubbles clearer
  scale_fill_manual(name='Sample type', values=c('blue', 'red'))+ #Stipulate name of headings in legend and change colour of bubbles
  scale_size_area(name='Relative abundance (%)', max_size=12)+ #Stipulate name of headings in legend and adjust the relatvie scale of bubbles using max_size
  guides(fill=guide_legend(order=1, override.aes = list(size = 4)),
         area=guide_legend(order = 2))+ # Format the legend using "guides" function: Stipulate order of the two legends using "order" and increase symbol size by using "override.aes"
  xlab('Time after infection (weeks)')+ # Change x-axis label
  ylab("Sequence divergence from transmitted\nfounder virus (%)") # Change y-axis label (\n makes new line in label)
bubble.plot
# Plot line plot of SGA sequence number (sequencing depth)
line.plot=ggplot(seq_data, aes(x=time, y=seq_no, group=origin))+
  geom_point(size=3, aes(color=origin, shape=origin))+
  geom_line(aes(color=origin))+
  scale_color_manual(name='Sample type', labels=c('CVL', 'Plasma'), values=c('blue','red'))+
  scale_shape_manual(name='Sample type', labels=c('CVL', 'Plasma'), values = c(19,17))+
  xlab('Time after infection (weeks)')+
  ylab('Sampling depth (Number\nof SGA sequences)') #\n is to make new line
line.plot
# Arrange line.plot under bubbleplot and make line.plot shorter
plot_grid(bubble.plot, line.plot, nrow = 2, align = 'v',rel_heights = c(1, 0.3))
