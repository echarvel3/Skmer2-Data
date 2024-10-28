library(data.table)
library(ggplot2)
library(gridExtra)
library(reshape2)

setwd("~/Desktop/calab_data/code_bases/Skmer-2/final_figures/error_rates/")

directories = list.dirs(path = "./stats_final/", recursive = F)
all_data = NULL
for (dir in directories){
  files = list.files(path = dir)
  for (file in files){
    stats = fread(paste(dir, file, sep = "/"), header=F)
    stats = as.data.table(lapply(stats, function(x){gsub("novaseq_profR","novaseq-profR",x)}))
    stats = as.data.table(lapply(stats, function(x){gsub("miseq_profileR","miseq-profileR",x)}))
    
    
    metadata = t(as.data.table(strsplit(as.character(stats$V1), "/")))[,5]
    data_type = as.data.table(tstrsplit(as.character(metadata), ":"))

    metadata = as.data.table(tstrsplit(as.character(data_type$V1), "_"))
    new_stats = cbind(metadata, cbind(stats$V2, data_type$V2))
    names(new_stats) = c("species", "dist_from_ref", "sim_coverage", "error_prof", "value", "stat")
    
    new_stats = dcast(new_stats, species+sim_coverage+error_prof+dist_from_ref~stat)
    new_stats$version = t(as.data.table(strsplit(file, "_")))[,1]
    new_stats$variation = t(as.data.table(strsplit(file, "_")))[,2]
    
    if (is.null(nrow(all_data)))
      all_data = new_stats
    else
      all_data = rbind(all_data,new_stats)
  }
}

write.csv(all_data, "./stats_dt3.csv")

