
library(data.table)
library(ggplot2)

setwd("/home/echarvel/Desktop/cunner_data/full_decontam/subsampled_matrices/diploid_transformed/")

angsd_cunner = fread("../../new_angsd_mtrx.txt", fill=T)
angsd_outliers = fread("/home/echarvel/Desktop/cunner_data/full_decontam/outliers.txt")

angsd_cunner_melt = melt(angsd_cunner, id.vars = "sample")
angsd_cunner_melt$type = "ANGSD"
angsd_cunner_melt$coverage = "Published Data"
angsd_outliers = fread("/home/echarvel/Desktop/cunner_data/full_decontam/outliers.txt")
angsd_cunner_filtered = angsd_cunner_melt[!angsd_cunner_melt$variable %in% angsd_outliers$V1, ]
angsd_cunner_filtered = angsd_cunner_filtered[!angsd_cunner_filtered$value %in% angsd_outliers$V1,]

#####################################
# Skmer 1
#####################################

skmer_1_cunner = fread("../../no_outlier_matrices/skmer_1_lib.txt", fill=T)
skmer_1_cunner_melt = melt(skmer_1_cunner)
skmer_1_cunner_melt$type = "Skmer1"
skmer_1_cunner_melt$coverage = "2X"
names(skmer_1_cunner_melt) = c("sample", "variable", "value", "type", "coverage")
skmer_1_cunner_melt$value = 1- (55 / (6-36*(1-skmer_1_cunner_melt$value)^31) + 17/6) ^ (6/(11*31)) 

skmer_1_4x_cunner = fread("../../no_outlier_matrices/skmer_1_library-4x.txt", fill=T)
skmer_1_4x_cunner_melt = melt(skmer_1_4x_cunner)
skmer_1_4x_cunner_melt$type = "Skmer1"
skmer_1_4x_cunner_melt$coverage = "4X"
names(skmer_1_4x_cunner_melt) = c("sample", "variable", "value", "type", "coverage")
skmer_1_4x_cunner_melt$value = 1- (55 / (6-36*(1-skmer_1_4x_cunner_melt$value)^31) + 17/6) ^ (6/(11*31))

skmer_D_cunner = fread("../../no_outlier_matrices/skmer_1-full-cov_lib.txt", fill=T)
skmer_D_cunner_melt = melt(skmer_D_cunner)
skmer_D_cunner_melt$type = "Skmer1"
skmer_D_cunner_melt$coverage = "RawCov"
names(skmer_D_cunner_melt) = c("sample", "variable", "value", "type", "coverage")
skmer_D_cunner_melt$value = 1- (55 / (6-36*(1-skmer_D_cunner_melt$value)^31) + 17/6) ^ (6/(11*31))

#####################################
# Skmer 2 + Assembly
#####################################

skmer_2_cunner = fread("../../no_outlier_matrices/skmer_2_lib.txt", fill=T)
skmer_2_cunner_melt = melt(skmer_2_cunner)
skmer_2_cunner_melt$type = "Skmer2+\nAssembly"
skmer_2_cunner_melt$coverage = "2X"
names(skmer_2_cunner_melt) = c("sample", "variable", "value", "type", "coverage")
skmer_2_cunner_melt$value = 1- (55 / (6-36*(1-skmer_2_cunner_melt$value)^31) + 17/6) ^ (6/(11*31))

skmer_2_4x_cunner = fread("../../no_outlier_matrices/skmer_2_library-4x.txt", fill=T)
skmer_2_4x_cunner_melt = melt(skmer_2_4x_cunner)
skmer_2_4x_cunner_melt$type = "Skmer2+\nAssembly"
skmer_2_4x_cunner_melt$coverage = "4X"
names(skmer_2_4x_cunner_melt) = c("sample", "variable", "value", "type", "coverage")
skmer_2_4x_cunner_melt$value = 1- (55 / (6-36*(1-skmer_2_4x_cunner_melt$value)^31) + 17/6) ^ (6/(11*31))

skmer_2_F_cunner = fread("../../no_outlier_matrices/skmer_2-full-cov_lib.txt", fill=T)
skmer_2_F_cunner_melt = melt(skmer_2_F_cunner)
skmer_2_F_cunner_melt$type = "Skmer2+\nAssembly"
skmer_2_F_cunner_melt$coverage = "RawCov"
names(skmer_2_F_cunner_melt) = c("sample", "variable", "value", "type", "coverage")
skmer_2_F_cunner_melt$value = 1- (55 / (6-36*(1-skmer_2_F_cunner_melt$value)^31) + 17/6) ^ (6/(11*31))



#####################################
# Skmer 2 + Respect
#####################################

skmer_R_cunner = fread("../../no_outlier_matrices/skmer_2-respect_lib.txt", fill=T)
skmer_R_cunner_melt = melt(skmer_R_cunner)
skmer_R_cunner_melt$type = "Skmer2+\nRESPECT"
skmer_R_cunner_melt$coverage = "2X"
names(skmer_R_cunner_melt) = c("sample", "variable", "value", "type", "coverage")
skmer_R_cunner_melt$value = 1- (55 / (6-36*(1-skmer_R_cunner_melt$value)^31) + 17/6)^(6/(11*31))

skmer_2_4xR_cunner = fread("../../no_outlier_matrices/skmer_2-respect_library-4x.txt", fill=T)
skmer_2_4xR_cunner_melt = melt(skmer_2_4xR_cunner)
skmer_2_4xR_cunner_melt$type = "Skmer2+\nRESPECT"
skmer_2_4xR_cunner_melt$coverage = "4X"
names(skmer_2_4xR_cunner_melt) = c("sample", "variable", "value", "type", "coverage")
skmer_2_4xR_cunner_melt$value = 1- (55 / (6-36*(1-skmer_2_4xR_cunner_melt$value)^31) + 17/6)^(6/(11*31))

skmer_2_FR_cunner = fread("../../no_outlier_matrices/skmer_2-respect-full-cov_lib.txt", fill=T)
skmer_2_FR_cunner_melt = melt(skmer_2_FR_cunner)
skmer_2_FR_cunner_melt$type = "Skmer2+\nRESPECT"
skmer_2_FR_cunner_melt$coverage = "RawCov"
names(skmer_2_FR_cunner_melt) = c("sample", "variable", "value", "type", "coverage")
skmer_2_FR_cunner_melt$value = 1- (55 / (6-36*(1-skmer_2_FR_cunner_melt$value)^31) + 17/6) ^ (6/(11*31))

all_data = rbind(skmer_1_cunner_melt, angsd_cunner_filtered)
all_data = rbind(skmer_2_cunner_melt, all_data)
all_data = rbind(skmer_R_cunner_melt, all_data)
all_data = rbind(skmer_D_cunner_melt, all_data)
all_data = rbind(skmer_1_4x_cunner_melt, all_data)
all_data = rbind(skmer_2_4x_cunner_melt, all_data)
all_data = rbind(skmer_2_4xR_cunner_melt, all_data)
all_data = rbind(skmer_2_F_cunner_melt, all_data)
all_data = rbind(skmer_2_FR_cunner_melt, all_data)


  
all_data$analysis <- factor(all_data$type, levels=c("ANGSD", 
                                                    "Skmer2+\nAssembly",
                                                    "Skmer2+\nRESPECT",
                                                    "Skmer1"))
all_data$cov <- factor(all_data$coverage, levels=c("Published Data", 
                                                    "2X",
                                                    "4X",
                                                    "RawCov"))


#############################################################
# Figure 5
#############################################################

x = ggplot(data=all_data[!is.na(all_data$value) & 
                           all_data$cov != "Published Data" &
                           all_data$value <= 0.01 & 
                           all_data$sample != all_data$variable,], 
           aes(y=as.numeric(value), x=analysis, fill = analysis)) +
  geom_hline(yintercept = mean(all_data[all_data$cov == "Published Data" &
                                          all_data$value <= 0.01 & 
                                          all_data$sample != all_data$variable,]$value)) +
  geom_hline(yintercept = median(all_data[all_data$cov == "Published Data" &
                                          all_data$value <= 0.01 & 
                                          all_data$sample != all_data$variable,]$value), linetype=2, color = "red4") +
  geom_violin(alpha = 0.5) +
  facet_grid(.~cov, scales = "free_x") +
  coord_cartesian(ylim = c(0.0, 0.01)) +
  stat_summary(shape = 1) +
  stat_summary(fun = "median", shape = 2) +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Method") + 
  ylab("estimated distances") +
  guides(fill="none") +
  theme_classic() +
  theme(axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size=10),
        axis.title.x = element_text(size = 20, vjust = -1),
        axis.title.y = element_text(size = 20),
        legend.position = "bottom",
        strip.text = element_text(size = 20),
        panel.grid.major.x = element_line(linewidth = 0.1, color="grey80"),
        panel.grid.major.y = element_line(linewidth = 0.1, color="grey80"),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_line(linewidth = 0.1, color="grey80"),
        legend.text = element_text(size=15),
        legend.title = element_text(size=15),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 1))

#############################################################
# Figure S5
#############################################################

x = ggplot(data=all_data[!is.na(all_data$value) & 
                           all_data$value <= 0.01 & 
                           all_data$cov == "2X" &
                           all_data$cov == "Published Data" &
                           all_data$sample != all_data$variable,], 
           aes(y=as.numeric(value), x=analysis, fill = analysis)) +
  geom_violin(alpha = 0.5) +
  coord_cartesian(ylim = c(0.0, 0.01)) +
  stat_summary(shape = 1) +
  stat_summary(fun = "median", shape = 2) +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Method") + 
  ylab("estimated distances") +
  guides(fill="none") +
  theme_classic() +
  theme(axis.text.x = element_text(size = 10),
        axis.text.y = element_text(size=10),
        axis.title.x = element_text(size = 20, vjust = -1),
        axis.title.y = element_text(size = 20),
        legend.position = "bottom",
        strip.text = element_text(size = 20),
        panel.grid.major.x = element_line(linewidth = 0.1, color="grey80"),
        panel.grid.major.y = element_line(linewidth = 0.1, color="grey80"),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_line(linewidth = 0.1, color="grey80"),
        legend.text = element_text(size=15),
        legend.title = element_text(size=15),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 1))
x

ggsave("~/cunner-results-all.png", x,  width = 12, height = 6)

all_data = as.data.table(all_data)
mean(all_data[analysis == "Skmer2+\nAssembly\n(2X)" & !is.na(all_data$value) & all_data$value <= 0.01 & all_data$sample != all_data$variable, value])
mean(all_data[analysis == "ANGSD" & !is.na(all_data$value) & all_data$value <= 0.01 & all_data$sample != all_data$variable, value])
mean(all_data[analysis == "Skmer1\n(2X)" & !is.na(all_data$value) & all_data$value <= 0.01 & all_data$sample != all_data$variable, value])
mean(all_data[analysis == "Skmer2+\nRESPECT\n(2X)" & !is.na(all_data$value) & all_data$value <= 0.01 & all_data$sample != all_data$variable, value])

######################################################
# Cunner Stats
######################################################

cunner_stats = fread("../../all_libs_stats2.tsv")
cunner_stats[is.na(V4), V4 := 0]
cunner_stats$V1

ggplot(data=cunner_stats, aes(x=V1, y=as.numeric(V4), fill=V1)) +
  facet_wrap(.~V3, ncol = 2, scales = "free_y") + 
  guides(fill="none") +
  geom_boxjitter(outlier.color = NA, jitter.size = 0.1, alpha = 0.5) +
  theme_classic() +
  theme(axis.text.x = element_text(size = 10, angle= 90),
        axis.text.y = element_text(size=10),
        axis.title.x = element_text(size = 20, vjust = -1),
        axis.title.y = element_text(size = 20),
        legend.position = "bottom",
        strip.text = element_text(size = 20),
        panel.grid.major.x = element_line(linewidth = 0.1, color="grey80"),
        panel.grid.major.y = element_line(linewidth = 0.1, color="grey80"),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y = element_line(linewidth = 0.1, color="grey80"),
        legend.text = element_text(size=15),
        legend.title = element_text(size=15),
        panel.border = element_rect(color = "black", fill = NA, linewidth = 1))















