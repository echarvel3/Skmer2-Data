#####################################################
# COMBINE PANELS INTO FIGURE2
#####################################################


library(cowplot)


spectra_combined = plot_grid(assembly_dist, dists_err, 
                             labels = c("B", "C"), 
                             label_size = 20,
                             ncol = 2,
                             rel_heights = c(1,1))

spectra_combined2 = plot_grid(spectra_fig, spectra_combined, 
                             labels = c("A", ""), 
                             label_size = 20,
                             ncol = 1,
                             rel_heights = c(1,1.5))

spectra_combined2

ggsave("/home/echarvel/Desktop/calab_data/code_bases/Skmer-2/final_figures/spectra_combined-all-new.png", 
       spectra_combined2, width = 20, height = 12)
          
