#load seqinr and tidyverse packages
library(seqinr)
library(tidyverse)
#set working directory
setwd()
#define fasta file input
f <- #fastafile
#define list of names
names_list <- read_tsv() %>% filter()
write.fasta(f[match(names_list,names(f))],file.out="output.fasta"))