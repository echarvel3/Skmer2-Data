library(data.table)
library(ggplot2)
library(gridExtra)
library(reshape2)
library(ggpol)

setwd("~/Desktop/calab_data/code_bases/Skmer-2/final_figures/error_rates/")

###############################################
# Figure 2C
###############################################

dists = fread("./distance_dt3.csv")

dists = dists[dists$coverage.1 == dists$coverage.2 & 
                       dists$error_prof.1 == dists$error_prof.2 &
                       (dists$dist_from_ref.1 == 0 | dists$dist_from_ref.2 == 0)]

dists$species = factor(dists$species.1, 
                              levels = c("club-moss", 
                                         "moss", 
                                         "oyster",
                                         "nematode", 
                                         "leech", 
                                         "rotifer"))

dists[version == "gen-0.0", version := "skmer2+assembly"]
dists[version == "noref", version := "skmer1"]
dists[version == "respect", version := "skmer2+respect"]

#################################################################
dists$species_l = factor(dists$species, levels = c("club-moss", "moss", "oyster",
                                                   "nematode", "rotifer", "leech"))
dists[species_l == "club-moss", species_l := "S. moellendorffii
    (0.42)"]
dists[species_l == "moss", species_l := "C. crispus
    (0.51)"]
dists[species_l == "oyster", species_l := "O. edulis scaffold
    (0.64)"]
dists[species_l == "nematode", species_l := "N. nomurai
    (0.71)"]
dists[species_l == "rotifer", species_l := "B. plicatilis
    (0.85)"]
dists[species_l == "leech", species_l := "H. medicinalis
    (0.90)"]
#################################################################
dists[error_prof.1 == "20", error_profile := "phred 20"]
dists[error_prof.1 == "23", error_profile := "phred 23"]
dists[error_prof.1 == "25", error_profile := "phred 25"]
dists[error_prof.1 == "novaseq-profR", error_profile := "NovaSeq
  6000"]
dist[erro]
dists[error_prof.1 == "HiSeq2500L150R", error_profile := "HiSeq2500"]
##############################################################

dists_err = ggplot(data = dists[species %in% c("moss", "rotifer") &
                     error_profile %in% c("phred 20", "phred 23", "phred 25") &
                      version %in% c("skmer1", "skmer2+assembly", "skmer2+respect") &
                      #species %in% c("rotifer") &
                      #coverage.1 %in% c("2")  &
                      true_distance == 0.01 & 
                      coverage.1 %in% c(1,2,4,8)], 
       aes(y = (ifelse(log2((as.numeric(dist_estimate)/ as.numeric(true_distance))) < -4, 
                      -4, 
                      log2((as.numeric(dist_estimate)/ as.numeric(true_distance))))),
           x = sub("phred ", "", error_profile),
           color = coverage.1,
           #fill = version,
           group = version
       )) +
  facet_grid(species_l~version, scale = "free_y") +
  #stat_summary(geom="line", linewidth = 1.5, alpha = 0.5) +
  geom_hline(yintercept = 0, linetype = 2) +
  geom_point(position=position_jitterdodge(jitter.width = 0.1, dodge.width =  0.7), size = 3, alpha = 0.4) +
  stat_summary(size = 2, fun = mean, geom = "point", shape=25, color = "black", fill="white", 
               position = position_dodge(width=0.7), stroke=2) +
  theme_classic() + 
  scale_color_viridis_c(end = .90) +
  #scale_color_manual(values = c("#d95f02", "#1b9e77", "#7570b3")) +
  scale_fill_manual(values = c("#d95f02", "#1b9e77", "#7570b3")) +
  #scale_color_brewer(palette = "Dark2", direction = -1) +
  #scale_fill_brewer(palette = "Dark2", direction = -1) +
  xlab("phred score") + 
  ylab("\n\nlog2( estimated distance / true distance )") +
  guides(fill="none", 
         color=guide_legend(title="coverage", size=20, override.aes = list(size=5, alpha = 1))) +
  theme(axis.text.x = element_text(size = 20),
        axis.text.y = element_text(size=15),
        axis.title.x = element_text(size = 20, vjust = -1),
        axis.title.y = element_text(size = 20),
        legend.position = "bottom",
        strip.text = element_text(size = 15),
        panel.grid.major.x = element_line(linewidth = 0.1, color="grey50"),
        panel.grid.major.y = element_line(linewidth = 0.1, color="grey50"),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_line(linewidth = 0.1, color="grey50"),
        legend.text = element_text(size=15),
        legend.title = element_text(size=15),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 1))

dists_err
ggsave("./dist-err_fig-FINAL.pdf", dists_err, width = 10, height = 10)
  
?element_text
