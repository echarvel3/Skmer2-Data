library(data.table)
library(ggplot2)
library(gridExtra)
library(reshape2)

setwd("~/Desktop/calab_data/code_bases/Skmer-2/final_figures/error_rates/")

directories = list.dirs(path = "./dists_final/", recursive = F)
all_data = NULL
for (dir in directories){
  files = list.files(path = dir)
  for (file in files){
    distance_data = fread(paste(dir, file, sep = "/"), header=TRUE)
    distance_data = melt(distance_data)
    distance_data = as.data.table(lapply(distance_data, function(x){gsub("novaseq_profR","novaseq-profR",x)}))
    distance_data = as.data.table(lapply(distance_data, function(x){gsub("miseq_profileR","miseq-profileR",x)}))
    
    metadata_1 = t(as.data.table(strsplit(as.character(distance_data$sample), "_")))
    metadata_2 = t(as.data.table(strsplit(as.character(distance_data$variable), "_")))
    distance_data = cbind(distance_data, cbind(metadata_1, metadata_2))
    
    names(distance_data) = c("sample.1",
                             "sample.2",
                             "dist_estimate",
                             "species.1",
                             "dist_from_ref.1",
                             "coverage.1",
                             "error_prof.1",
                             "species.2",
                             "dist_from_ref.2",
                             "coverage.2",
                             "error_prof.2")
    
    
    distance_data[,coverage.1 := as.numeric(gsub("x","",distance_data$coverage.1))]
    distance_data[,coverage.2 := as.numeric(gsub("x","",distance_data$coverage.2))]
    
    distance_data$true_distance = as.numeric(distance_data$dist_from_ref.1) + as.numeric(distance_data$dist_from_ref.2)
    distance_data$version = t(as.data.table(strsplit(file, "_")))[,1]
    distance_data$variation = t(as.data.table(strsplit(file, "_")))[,2]
    
    if (is.null(nrow(all_data)))
      all_data = distance_data
    else
      all_data = rbind(all_data,distance_data)
  }
}

write.csv(all_data, "./distance_dt3.csv")

