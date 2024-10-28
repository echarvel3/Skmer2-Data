#!/bin/bash

set -x

sed -i 's/9[.].*e-05/0.0/g' ./all_libs_stats2.tsv
sed -i 's/NA/0.0/g' ./all_libs_stats2.tsv

grep 'skmer' ./all_libs_stats2.tsv | grep 'error' | sort -rn -k4 | awk '$NF+0 >= 0.0001 && $NF+0 <= 0.006' > testing.txt

grep 'skmer' ./all_libs_stats2.tsv | grep 'genome_length' | sort -rn -k4 | awk '$NF+0 >= 500000000 && $NF+0 <= 800000000' >> testing.txt

grep -E 'skmer_._lib' ./all_libs_stats2.tsv | grep 'coverage' | sort -rn -k4 | awk '$NF+0 >= 1 && $NF+0 <= 3' >> testing.txt
grep 'skmer_2-respect_lib' ./all_libs_stats2.tsv | grep 'coverage' | sort -rn -k4 | awk '$NF+0 >= 1 && $NF+0 <= 3' >> testing.txt

grep 'skmer_2-respect_library-4x' ./all_libs_stats2.tsv | grep 'coverage' | sort -rn -k4 | awk '$NF+0 >= 3 && $NF+0 <= 7' >> testing.txt
grep 'skmer_2_library-4x' ./all_libs_stats2.tsv | grep 'coverage' | sort -rn -k4 | awk '$NF+0 >= 3 && $NF+0 <= 7' >> testing.txt
grep 'skmer_1_library-4x' ./all_libs_stats2.tsv | grep 'coverage' | sort -rn -k4 | awk '$NF+0 >= 3 && $NF+0 <= 7' >> testing.txt

grep 'skmer_2-full-cov_lib' ./all_libs_stats2.tsv | grep 'coverage' | sort -rn -k4 | awk '$NF+0 >= 1 && $NF+0 <= 300' >> testing.txt
grep 'skmer_1-full-cov_lib' ./all_libs_stats2.tsv | grep 'coverage' | sort -rn -k4 | awk '$NF+0 >= 1 && $NF+0 <= 300' >> testing.txt
grep 'skmer_2-respect-full-cov_lib' ./all_libs_stats2.tsv | grep 'coverage' | sort -rn -k4 | awk '$NF+0 >= 1 && $NF+0 <= 300' >> testing.txt

grep 'skmer*' ./all_libs_stats2.tsv | grep 'read_length' | sort -rn -k4 | awk '$NF+0 >= 130 && $NF+0 <= 160' >> testing.txt

cat ./testing.txt | cut -f1,2 | sort | uniq -c | grep ' 4 ' | sed -e 's/^.*4 //g' > ./outlier_list/no_outliers.txt

grep 'skmer_1_lib' ./outlier_list/no_outliers.txt | cut -f2 > ./outlier_list/skmer_1_NOOUT.txt
grep 'skmer_2_lib' ./outlier_list/no_outliers.txt | cut -f2 > ./outlier_list/skmer_2_NOOUT.txt
grep 'skmer_2-respect_lib' ./outlier_list/no_outliers.txt | cut -f2 > ./outlier_list/skmer_2-respect_NOOUT.txt

grep 'skmer_1-full-cov_lib' ./outlier_list/no_outliers.txt | cut -f2 > ./outlier_list/skmer_1-full-cov_NOOUT.txt
grep 'skmer_2-full-cov_lib' ./outlier_list/no_outliers.txt | cut -f2 > ./outlier_list/skmer_2-full-cov_NOOUT.txt
grep 'skmer_2-respect-full-cov_lib' ./outlier_list/no_outliers.txt | cut -f2 > ./outlier_list/skmer_2-respect-full-cov_NOOUT.txt


grep 'skmer_1_library-4x' ./outlier_list/no_outliers.txt | cut -f2 > ./outlier_list/skmer_1_library-4x_NOOUT.txt
grep 'skmer_2_library-4x' ./outlier_list/no_outliers.txt | cut -f2 > ./outlier_list/skmer_2_library-4x_NOOUT.txt
grep 'skmer_2-respect_library-4x' ./outlier_list/no_outliers.txt | cut -f2 > ./outlier_list/skmer_2-respect_library-4x_NOOUT.txt

bash ../subsample-dist-mat.sh ./outlier_list/skmer_1_NOOUT.txt ./full_matrices/skmer_1_lib.txt > ./no_outlier_matrices/skmer_1_lib.txt
bash ../subsample-dist-mat.sh ./outlier_list/skmer_2_NOOUT.txt ./full_matrices/skmer_2_lib.txt > ./no_outlier_matrices/skmer_2_lib.txt
bash ../subsample-dist-mat.sh ./outlier_list/skmer_2-respect_NOOUT.txt ./full_matrices/skmer_2-respect_lib.txt > ./no_outlier_matrices/skmer_2-respect_lib.txt

bash ../subsample-dist-mat.sh ./outlier_list/skmer_1-full-cov_NOOUT.txt ./full_matrices/skmer_1_lib.txt > ./no_outlier_matrices/skmer_1-full-cov_lib.txt
bash ../subsample-dist-mat.sh ./outlier_list/skmer_2-full-cov_NOOUT.txt ./full_matrices/skmer_2_lib.txt > ./no_outlier_matrices/skmer_2-full-cov_lib.txt
bash ../subsample-dist-mat.sh ./outlier_list/skmer_2-respect-full-cov_NOOUT.txt ./full_matrices/skmer_2-respect_lib.txt > ./no_outlier_matrices/skmer_2-respect-full-cov_lib.txt

bash ../subsample-dist-mat.sh ./outlier_list/skmer_1_library-4x_NOOUT.txt ./full_matrices/skmer_1_library-4x.txt > ./no_outlier_matrices/skmer_1_library-4x.txt
bash ../subsample-dist-mat.sh ./outlier_list/skmer_2_library-4x_NOOUT.txt ./full_matrices/skmer_2_library-4x.txt > ./no_outlier_matrices/skmer_2_library-4x.txt
bash ../subsample-dist-mat.sh ./outlier_list/skmer_2-respect_library-4x_NOOUT.txt ./full_matrices/skmer_2-respect_library-4x.txt > ./no_outlier_matrices/skmer_2-respect_library-4x.txt


