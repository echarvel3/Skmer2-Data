library(data.table)
library(ggplot2)
library(gridExtra)
library(reshape2)
library(ggpol)

setwd("~/Desktop/calab_data/code_bases/Skmer-2/final_figures/assemblies/")

############################################################
# Figure 2 Panel B
############################################################


directories = list.dirs(path = "./data_final/", recursive = F)
all = NULL

for (dir in directories){
  files = list.files(path = dir)
  for (file in files){
    distance_matrix = fread(paste(dir, file, sep = "/"),
                            header=TRUE)
    x = as.data.table(melt(distance_matrix))
    
    split_columns = strsplit(as.character(x$sample), "_")
    x$species = sapply(split_columns, "[", 1)
    x$distance1 = sapply(split_columns, "[", 2)
    x$cov1 = sapply(split_columns, "[", 3)
    x$rep1 = sapply(split_columns, "[", 4)
    
    split_columns = strsplit(as.character(x$variable), "_")
    x$distance2 = sapply(split_columns, "[", 2)
    x$cov2 = sapply(split_columns, "[", 3)
    x$rep2 = sapply(split_columns, "[", 4)
    
    x = x[cov2 == cov1 & (distance1 == "0.0" | distance2 == "0.0")]
    z = aggregate(value ~ species + distance1 + distance2 + cov1, 
                  data = x, 
                  FUN = median)
    
    z$version = strsplit(file, "_")[[1]][1]
    z$variant = strsplit(file, "_")[[1]][2]
    z$distance_t = as.numeric(z$distance1) + as.numeric(z$distance2)
    z$rep = dir
    if (is.null(nrow(all)))
      all = z
    else
      all = rbind(all,z)
  }
}

names(all) = c("species", "distance1", "distance2",  "coverage", 
               "estimated_distance", "version", "variant", "true_distance", "rep")
all = as.data.table(all)

all$species_l = factor(all$species, levels = c("club-moss", "moss", "oyster",
                                               "nematode", "leech", "rotifer"))
#all[version == "gen1-0.0", version := "skmer2 assembly"]
all[version == "gen-0.0", version := "Complete \nAssembly"]
all[version == "assembly-10-paired", version := "10x \nAssembly"]
all[version == "assembly-50-paired", version := "50x \nAssembly"]
all[version == "noref", version := "skmer1"]
all[version == "respect", version := "Estimated \nSpectrum"]

#View(all[(version %in% c("skmer2 assembly", 
#                    "skmer1", 
#                    "skmer2 respect") & 
#       variant %in% c("err6",
#                      "r50-err6")) | 
#      (variant == "def" & version == "skmer1")])

all$version_l = factor(all$version, 
                       levels = c("Complete \nAssembly", 
                                  "10x \nAssembly", 
                                  "50x \nAssembly", 
                                  "Respect \nReference",
                                  "skmer1"))

assembly_dist = ggplot(data = all[(
  version %in% c("Complete \nAssembly", "10x \nAssembly", "50x \nAssembly", "Estimated \nSpectrum") & 
    variant %in% c("err6+new","r50-err6+new") & 
    as.numeric(true_distance) > 0
) | (
  variant == "dexf" & 
    version == "skmer1" & 
    as.numeric(true_distance) > 0)], 
aes(y = ifelse(log2((as.numeric(estimated_distance)/ as.numeric(true_distance))) < -4, 
               -4, 
               log2((as.numeric(estimated_distance)/ as.numeric(true_distance)))), 
    x = version)) +
  geom_boxjitter(jitter.alpha=0.5,jitter.size = 0.3,outlier.size = NA, outlier.colour = NA) +
  stat_summary(color="red", stroke=2, shape = 8, size = 1) +
  theme_bw() +
  guides(color=guide_legend(title="skmer version", size=20)) +
  xlab("Repeat Spectrum\n") + 
  ylab("\n\nlog2( estimated distance / true distance )") + 
  scale_color_brewer(palette = "Dark2", direction = -1) +
  scale_y_continuous(breaks = c(-4,-2, 0, 2)) +
  coord_cartesian(ylim = c(-4.1,2)) +
  theme(axis.text.x = element_text(size = 17),
        axis.text.y = element_text(size=15),
        axis.title.x = element_text(size = 20, vjust = -0.5),
        axis.title.y = element_text(size = 20),
        legend.position = "bottom",
        panel.grid.major.x = element_line(linewidth = 0.1, color="grey50"),
        panel.grid.major.y = element_line(linewidth = 0.1, color="grey50"),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_line(linewidth = 0.1, color="grey50"),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 1)) +
  guides(color = "none")
assembly_dist
ggsave("./assembly_dist_fig-NEW.png", assembly_dist, width = 10, height = 5)

