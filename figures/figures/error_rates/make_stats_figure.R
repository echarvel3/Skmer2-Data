library(data.table)
library(ggplot2)
library(gridExtra)
library(reshape2)
library(ggpol)

setwd("~/Desktop/calab_data/code_bases/Skmer-2/final_figures/error_rates/")
stats = fread("./stats_dt3.csv")

########################################
# Make Figure S4
#######################################


stats$species = factor(stats$species, 
                              levels = c("club-moss", 
                                         "moss", 
                                         "oyster",
                                         "nematode", 
                                         "leech", 
                                         "rotifer"))

stats[version == "gen-0.0", version := "skmer2+assembly"]
stats[version == "noref", version := "skmer1"]
stats[version == "respect", version := "skmer2+respect"]

####

hlines <- data.frame(error_prof = c("phred 20",
                           "phred 23", 
                           "phred 25"), 
#                           "MiSeqv3L250R.dat",
  #                         "NovaSeq
  #6000"), 
                     true_err = c(0.01, 
                           0.005,
                           0.003))
                           #NA,
                          # NA))

stats[error_prof == "20.dat", error_profile := "phred 20"]
stats[error_prof == "23.dat", error_profile := "phred 23"]
stats[error_prof == "25.dat", error_profile := "phred 25"]
stats[error_prof == "novaseq-profR.dat", error_profile := "NovaSeq
  6000"]

#################################################################
stats$species_l = factor(stats$species, levels = c("club-moss", "moss", "oyster",
                                                   "nematode", "rotifer", "leech"))
stats[species_l == "club-moss", species_l := "S. moellendorffii
    (0.42)"]
stats[species_l == "moss", species_l := "C. crispus
    (0.51)"]
stats[species_l == "oyster", species_l := "O. edulis scaffold
    (0.64)"]
stats[species_l == "nematode", species_l := "N. nomurai
    (0.71)"]
stats[species_l == "rotifer", species_l := "B. plicatilis
    (0.85)"]
stats[species_l == "leech", species_l := "H. medicinalis
    (0.90)"]
#################################################################

stats_fig = ggplot(data = stats[species %in% c("rotifer", "moss") &
                      species %in% c("club-moss", "moss", "oyster", "nematode", "leech", "rotifer") &
                      error_prof %in% c("20.dat","23.dat", "25.dat") &
                      version %in% c("skmer1", "skmer2+assembly", "skmer2+respect") &
                      dist_from_ref == 0.001 & error_profile %in% c("phred 20","phred 23","phred 25")],
       aes(x = error_profile,
           y = error_rate,
           color = as.factor(version),
           #linetype = sim_coverage,
           shape = as.factor(version)
       )) +
  facet_grid(species_l~sim_coverage) +
  #stat_summary(geom = "line") + 
  stat_summary(alpha=0.7, size=1.25) + 
  geom_point(data = hlines, aes(x=error_prof, y = true_err), color = "black", shape = 8, size = 4) +
  scale_y_continuous(breaks = c(0.00, 0.005, 0.01, 0.015, 0.02, 0.025), label = scales::percent) +
  #scale_x_continuous(label = scales::percent) +
  theme_classic() +   scale_color_manual(values = c("#d95f02", "#1b9e77", "#7570b3")) +
  xlab("error profile") + 
  ylab("sequencing error estimate") +
  guides(color=guide_legend(title="version", size=20), shape=guide_legend(title="version", size=20)) +
  theme(axis.text.x = element_text(size = 15, angle = 90, vjust = 0.5, hjust = -0.05),
        axis.text.y = element_text(size=15),
        axis.title.x = element_text(size = 20, vjust = -1),
        axis.title.y = element_text(size = 20),
        legend.position = "top",
        strip.text = element_text(size = 17),
        panel.grid.major.x = element_line(linewidth = 0.1, color="grey80"),
        panel.grid.major.y = element_line(linewidth = 0.1, color="grey80"),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_line(linewidth = 0.1, color="grey80"),
        legend.text = element_text(size=20),
        legend.title = element_text(size=20),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 1)) 

stats_fig

ggsave("./stats_fig-FINAL.pdf", stats_fig, width = 14, height = 8)

