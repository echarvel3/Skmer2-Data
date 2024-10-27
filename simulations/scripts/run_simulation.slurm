#!/bin/bash
#SBATCH --job-name="ART_ILLUMINA"
#SBATCH --nodes=1
#SBATCH --array=0,1,2,3,4,5%1
#SBATCH --ntasks-per-node=14
#SBATCH -o calab-art_%j_%a.out
#SBATCH -e calab-art_%j_%a.err
#SBATCH -t 72:00:00
#SBATCH -A miragrp
#SBATCH --exclude n0020

source ${HOME}/.bashrc
source ${HOME}/programs/miniconda3/etc/profile.d/conda.sh

conda activate skmer

set -x

sample_arr=("rotifer" "leech" "club-moss" "nematode" "moss" "oyster")
samp=${sample_arr[$SLURM_ARRAY_TASK_ID]}

########################################
### Simulating Distances on Genomes ####
########################################

mkdir "./genomes/"
pushd "./genomes/"

#select corresponding parent genome
path_to_genomes="/scratch01/echarvel/skims_sims/reference_genomes/"
reference_genome=$(find "$path_to_genomes/${samp}_genome/" -name '*fna')

#select distances for simulation
for distance in 0.0 0.001 0.002 0.004 0.006 0.008 0.01 0.02; do
	mkdir ${samp}
	mkdir "./${samp}/${samp}_${distance}_1/"
	
	python /scratch03/echarvel_temp/skmer2-sims/skmer2_eqn_analysis/make_genomes.py existing --existing-dir "${reference_genome%/*}" --out-dir "./${samp}/${samp}_${distance}_1/" --mutation-prob "${distance}"
done

popd

############################################
### Simulating Coverages on each Genome ####
############################################

mkdir "./skims"
pushd "./skims"

for distance in 0.0 0.001 0.002 0.004 0.006 0.008 0.01 0.02; do
	mkdir "${samp}"
	genome_1=$(realpath ../genomes/${samp}/${samp}_${distance}_1/*) 
	phred_quality=25
	read_len=150
	
	for coverage in 1 2 4 8; do 
		/calab_data/mirarab/home/echarvel3/programs/art_bin_MountRainier/art_illumina -q -i $genome_1 -l $read_len -f $coverage -qL ${phred_quality} -qU ${phred_quality} -o ${samp}/${samp}_${distance}_${coverage}x_1 &
	done
	wait	
	rm ./${samp}/*.aln

done
popd 

#####################################################
### Run Skmer on the Genome Skims and Save Stats ####
#####################################################

conda activate skmer

mkdir "./libraries"
mkdir "./dist_matrices"
mkdir "./stat_files"

#skmer 1
skmer reference "./skims/${samp}" -l "./libraries/${samp}" -o "./dist_matrices/noref_def_${samp}" -p 2
grep "" ./libraries/${samp}/*/*dat |sort -k2 >  ./stat_files/noref_def_${samp}.csv

#skmer 2 + assembly histogram
path_to_histograms="/scratch01/echarvel/skims_sims/reference_histograms/"
reference_histograms=$(find "$path_to_histograms/${samp}.hist")

python ${HOME}/programs/Skmer-2/skmer/__main__.py --debug reference "./skims/${samp}" -r ${reference_histograms} -l "./libraries/${samp}" -o "./dist_matrices/gen-0.0_err6+new_${samp}" -p 14
grep "" ./libraries/${samp}/*/*dat |sort -k2 >  ./stat_files/gen-0.0_err6+new_${samp}.csv

#skmer 2 + RESPECT estimates
path_to_respect="/scratch01/echarvel/skims_sims/respect_inputs/"
reference_respect=$(find "$path_to_respect/${samp}_r50_N1000/input-spectra.hist")

python ${HOME}/programs/Skmer-2/skmer/__main__.py --debug reference "./skims/${samp}" -r ${reference_respect} -l "./libraries/${samp}" -o "./dist_matrices/respect_r50-err6+new_${samp}" -p 14
grep "" ./libraries/${samp}/*/*dat |sort -k2 >  ./stat_files/respect_r50-err6+new_${samp}.csv



