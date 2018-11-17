setwd("/Users/dale/Documents/Rdata")
env=read.csv2("resistant_env.csv", na.strings = (""))
C5_resistant=env$X...C5_resistant
C5_resistant=na.omit(C5_resistant)
write.table(C5_resistant, "/Users/dale/Documents/Rdata/C5_resistant.txt", col.names = F, row.names = F, sep = "\t")