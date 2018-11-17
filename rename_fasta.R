#########################################################################
# Written by Dale John Kitchin 
# This script is for renaming sequences in a fasta file.
# It takes a csv file with the existing names and their corresponding 
# new names as input along with the fasta file to be renamed.
# It outputs a renamed fasta file as well as a csv file containing old 
# names and sequences for data preservation.
# Its also outputs a csv file with unused names and another csv file with 
# unmatched sequences.
#########################################################################
# Install and load required R packages
# Only install if not already installed
## install.packages("phylotools"))
# Load installed packages
library("phylotools")
# Set working directory (user input required)
setwd("/Users/dale/Desktop/batsi")
# Define file names to use (user input required)
fasta_in <- "select_test.fasta"
fasta_out <- "renamed.fasta"
name_table <- "ref_table.csv"
seq_df_out <- "seq_df.csv"
unused_csv <- "unused_names.csv"
unmatched_csv <- "unmatched_seqs.csv"
# Read in name csv file as a dataframe and replace punctuation and spaces with "_"
ref_table <- read.csv2(name_table, header = T)
# Best practice to maintain record of original names and corresponding sequences, reading fasta sequences into a dataframe
seq_df <- read.fasta(file = fasta_in, clean_name = T)
# Export seq_df dataframe as a csv file
write.csv2(seq_df, seq_df_out)
# Create dataframe of any sequences with names not matched to ref_table entries,
# x %in% y operator returns logical vector for where entries in x occur in y
unmatched_seqs <- subset(seq_df,!((seq_df[,1]) %in% ref_table[,1]))
write.csv2(unmatched_seqs, unmatched_csv)
# Create dataframe of unused names present in ref_table but not in fasta file,
# ! preceding the logical condition means "not"
unused_names <- subset(ref_table, (!(ref_table[,1] %in% seq_df[,1])))
write.csv2(unused_names, unused_csv)
# Rename sequences in the fasta file
rename.fasta(infile = fasta_in, ref_table, outfile = fasta_out)
