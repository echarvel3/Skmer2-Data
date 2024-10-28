library(data.table)
library(ggplot2)
library(gridExtra)
library(reshape2)
library(ggpol)

setwd("~/Desktop/calab_data/code_bases/Skmer-2/final_figures/long-distances/")

########################################
# Make Figure 3
########################################

directories = list.dirs(path = "./distance_matrices/", recursive = F)
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
                                               "nematode", "rotifer", "leech"))
all[species_l == "club-moss", species_l := "S. moellendorffii
    (0.42)"]
all[species_l == "moss", species_l := "C. crispus
    (0.51)"]
all[species_l == "oyster", species_l := "O. edulis scaffold
    (0.64)"]
all[species_l == "nematode", species_l := "N. nomurai
    (0.71)"]
all[species_l == "rotifer", species_l := "B. plicatilis
    (0.85)"]
all[species_l == "leech", species_l := "H. medicinalis
    (0.90)"]


all[version == "gen-0.0", version := "skmer2+assembly"]
all[version == "noref", version := "skmer1"]
all[version == "respect", version := "skmer2+respect"]

error_percent_plot_p = ggplot(data = all[(
  #species_l %in% c("moss", "rotifer") &
  version %in% c("skmer2+assembly", "skmer1", "skmer2+respect") & 
    variant %in% c(
      #"err6+new", 
      "r50-err6+new") & 
    as.numeric(true_distance) > 0
  ) | (
    #species_l %in% c("moss", "rotifer") &
    variant == "def" & 
      version == "skmer1" & 
      as.numeric(true_distance) > 0)], 
       aes(y = ifelse(log2((as.numeric(estimated_distance)/ as.numeric(true_distance))) < -4, 
                      -4, 
                      log2((as.numeric(estimated_distance)/ as.numeric(true_distance)))), 
           x = as.numeric(true_distance), 
           color = version)) +
  facet_grid(species_l~coverage) +
  #geom_hline(yintercept = -4, linetype = "dotted", color = "red") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  stat_summary(geom="line", linewidth=1,alpha=0.8) +
  stat_summary(linewidth=1,alpha=0.8) + 
  #coord_cartesian(ylim = c(-4.1,1.5)) +
  scale_y_continuous(breaks = pretty(c(-0.3, 0.1), n = 4)) +
  scale_x_log10(breaks = c(0.05, 0.1, 0.15, 0.2), 
                     label = scales::percent,
                     guide = guide_axis(check.overlap = T)) + 
  theme_classic() +
  theme(axis.text.x = element_text(size = 15, angle = -90, vjust = 0.5),
        axis.text.y = element_text(size=15),
        axis.title.x = element_text(size = 20, vjust = -0.5),
        axis.title.y = element_text(size = 20),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y = element_line(linewidth = 0.1, color="grey80"),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_line(linewidth = 0.1, color="grey80"),
        legend.position = "top",
        legend.text = element_text(size=20),
        legend.title = element_text(size=20),
        strip.text = element_text(size = 17),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 1)) +
  guides(color=guide_legend(title="version", size=20)) +
  xlab("true genomic distance (%)") + 
  ylab("log2( estimated distance / true distance )") + 
  scale_color_manual(values = c("#d95f02", "#7570b3")) +
  scale_fill_manual(values = c("#d95f02", "#7570b3"))
error_percent_plot_p
ggsave("./error_percent-long-dists.pdf", error_percent_plot_p, width = 12, height = 6)
  
################################################################################
################################################################################

# OLD CODE #

################################################################################
################################################################################

