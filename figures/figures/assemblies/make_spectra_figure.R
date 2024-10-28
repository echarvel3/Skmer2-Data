library(data.table)
library(ggplot2)
library(gridExtra)
library(reshape2)

setwd("~/Desktop/calab_data/code_bases/Skmer-2/final_figures/assemblies/repeat_spectra/")
all_data = NULL

files = list.files(path = "./")
for (file in files){
    stats = fread(file, header=F)
    
    #metadata = as.data.table(t(stats))

    stats$species = strsplit(file, "_")[[1]][1]
    stats$coverage = sub(".hist", "", strsplit(file, "_")[[1]][2])

    if (is.null(nrow(all_data)))
      all_data = stats
    else
      all_data = rbind(all_data,stats)
}

#write.csv(all_data, "../spectra_dt.csv")

all_data$coverage_l = factor(all_data$coverage, levels = c("1", "2", "4", "8", "10", "20", "50", "10-paired", "50-paired", "100", "respect", "ref"))
all_data$species_l = factor(all_data$species, levels = c("club-moss", "moss", "oyster", "nematode", "leech", "rotifer"))

all_data[,type := ifelse(all_data[, coverage == "ref"], "ref", "not_ref")]

ref_data = all_data[coverage == "ref"] 
cov_data = all_data[coverage != "ref"] 

new_data = merge(cov_data, ref_data, by = c("species", "V1"))
new_data$spectra_error = (as.numeric(new_data$V2.x) - as.numeric(new_data$V2.y)) / as.numeric(new_data$V2.y)

#################################################################
new_data$species_l = factor(new_data$species_l.x, levels = c("club-moss", "moss", "oyster",
                                               "nematode", "rotifer", "leech"))
new_data[species_l == "club-moss", species_l := "S. moellendorffii
    (0.42)"]
new_data[species_l == "moss", species_l := "C. crispus
    (0.51)"]
new_data[species_l == "oyster", species_l := "O. edulis scaffold
    (0.64)"]
new_data[species_l == "nematode", species_l := "N. nomurai
    (0.71)"]
new_data[species_l == "rotifer", species_l := "B. plicatilis
    (0.85)"]
new_data[species_l == "leech", species_l := "H. medicinalis
    (0.90)"]
#################################################################
new_data$coverage = factor(new_data$coverage_l.x, levels = c("10-paired", "50-paired", "respect"))
new_data$coverage

new_data[coverage == "10-paired", coverage := "10x Assembly    "]
new_data[coverage == "50-paired", coverage := "50x Assembly    "]
new_data[coverage == "respect", coverage := "Estimated Spectrum    "]

#################################################################
# FIGURE 2 PANEL A
#################################################################

spectra_fig = ggplot(new_data[as.numeric(V1) < 11 & 
                                coverage_l.x %in% c("10-paired", "50-paired", "respect")], 
                     aes(x=as.numeric(V1), 
                         y=spectra_error, 
                         color = coverage)) + 
  facet_grid(.~species_l) +
  geom_hline(yintercept = 0, color = "grey14", linetype = "dashed") +
  stat_summary(geom = "line") + 
  stat_summary() +
  xlab("k-mer spectra bin\n") + 
  ylab("relative error (%)") + 
  guides(color=guide_legend(title="Repeat Spectrum    ", size=20)) +
  theme_classic() +
  scale_color_manual(values = c("#d95f02", "#1b9e77", "#7570b3")) +
  scale_x_continuous(breaks = c(2,4,6,8,10)) +
  scale_y_continuous(breaks = c(-0.75, -0.5, -0.25, 0, 0.25, 0.5, 0.75),
                     labels = scales::percent) +
  theme(axis.text.x = element_text(size = 15),
        axis.text.y = element_text(size=15),
        axis.title.x = element_text(size = 20, vjust = -0.5),
        axis.title.y = element_text(size = 20),
        legend.position = "top",
        strip.text = element_text(size = 20),
        panel.grid.major.x = element_line(linewidth = 0.1, color="grey50"),
        panel.grid.major.y = element_line(linewidth = 0.1, color="grey50"),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.text = element_text(size=20),
        legend.title = element_text(size=20),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 1))

spectra_fig

ggsave("../spectra_fig-FINAL.png", spectra_fig, width = 14, height = 7)

#######################################
# FIGURE S6
#######################################

moss_hist = fread("../ref-moss.hist")
moss_hist$method = 'assembly'
moss_respect = fread("./moss_respect.hist")
moss_respect$method = 'respect'

all_hists = rbind(moss_hist, moss_respect)

respect_v_true = ggplot(all_hists[V1 <= 50,], aes(x=as.numeric(V1), 
                         y=log(as.numeric(V2)), 
                         color=method)) +
  geom_line() +
  xlab("k-mer spectra bin\n") + 
  ylab("log10(k-mer count)") + 
  guides(color=guide_legend(title="repeat spectra", size=10)) +
  theme_classic() +
  scale_color_manual(values = c("#d95f02", "#1b9e77", "#7570b3")) +
  theme(axis.text.x = element_text(size = 15),
        axis.text.y = element_text(size=15),
        axis.title.x = element_text(size = 20, vjust = -0.5),
        axis.title.y = element_text(size = 20),
        legend.position = "top",
        strip.text = element_text(size = 20),
        panel.grid.major.x = element_line(linewidth = 0.1, color="grey50"),
        panel.grid.major.y = element_line(linewidth = 0.1, color="grey50"),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        legend.text = element_text(size=15),
        legend.title = element_text(size=15),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 1))
respect_v_true
ggsave("../respect_v_true.pdf", respect_v_true, width = 5, height = 5)
