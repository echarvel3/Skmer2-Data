for x in {01..10}; do
    mkdir rep${x}
    pushd rep${x}

    mkdir distances
    pushd distances
    
    dir="/scratch01/echarvel/skims_sims/experiments_error-rates/rep${x}/dist_matrices/"
    
    cp ${dir}"/gen-0.0_err6+new"* .
    cp ${dir}"/respect_r50-err6+new"* .
    cp ${dir}"/noref_def"* .

    popd
    
    mkdir stats
    pushd stats

    dir="/scratch01/echarvel/skims_sims/experiments_error-rates/rep${x}/stat_files/"

    cp ${dir}"/gen-0.0_err6+new"* .    
    cp ${dir}"/respect_r50-err6+new"* .   
    cp ${dir}"/noref_def"* .

    popd

    dir="/scratch01/echarvel/skims_sims/experiments_error-rates/rep${x}/respect/"

    mkdir respect

    cp -r ${dir}/result*/ ./respect/

    mkdir --parents ./respect/final_results/moss_r50_N1000/
    mkdir --parents ./respect/final_results/rotifer_r50_N1000/

    head -n1 ./respect/results/moss_r50_N1000/estimated-parameters.txt > ./respect/final_results/moss_r50_N1000/estimated-parameters.txt
    head -n1 ./respect/results/rotifer_r50_N1000/estimated-parameters.txt > ./respect/final_results/moss_r50_N1000/estimated-parameters.txt

    cat ./respect/results/moss_r50_N1000/estimated-parameters.txt | grep -v 'eq' >> ./respect/final_results/moss_r50_N1000/estimated-parameters.txt
    cat ./respect/results2/moss_r50_N1000/estimated-parameters.txt | grep -v 'eq' >> ./respect/final_results/moss_r50_N1000/estimated-parameters.txt
    cat ./respect/results3/moss_r50_N1000/estimated-parameters.txt | grep -v 'eq' >> ./respect/final_results/moss_r50_N1000/estimated-parameters.txt
    
    cat ./respect/results/rotifer_r50_N1000/estimated-parameters.txt | grep -v 'eq' >> ./respect/final_results/rotifer_r50_N1000/estimated-parameters.txt
    cat ./respect/results2/rotifer_r50_N1000/estimated-parameters.txt | grep -v 'eq' >> ./respect/final_results/rotifer_r50_N1000/estimated-parameters.txt
    cat ./respect/results3/rotifer_r50_N1000/estimated-parameters.txt | grep -v 'eq' >> ./respect/final_results/rotifer_r50_N1000/estimated-parameters.txt

    head -n1 ./respect/results/moss_r50_N1000/estimated-spectra.txt > ./respect/final_results/moss_r50_N1000/estimated-spectra.txt
    head -n1 ./respect/results/rotifer_r50_N1000/estimated-spectra.txt > ./respect/final_results/moss_r50_N1000/estimated-spectra.txt

    cat ./respect/results/moss_r50_N1000/estimated-spectra.txt | grep -v 'eq' | grep -v 'sample' >> ./respect/final_results/moss_r50_N1000/estimated-spectra.txt
    cat ./respect/results2/moss_r50_N1000/estimated-spectra.txt | grep -v 'eq' | grep -v 'sample' >> ./respect/final_results/moss_r50_N1000/estimated-spectra.txt
    cat ./respect/results3/moss_r50_N1000/estimated-spectra.txt | grep -v 'eq' | grep -v 'sample' >> ./respect/final_results/moss_r50_N1000/estimated-spectra.txt
    
    cat ./respect/results/rotifer_r50_N1000/estimated-spectra.txt | grep -v 'eq' | grep -v 'sample' >> ./respect/final_results/rotifer_r50_N1000/estimated-spectra.txt
    cat ./respect/results2/rotifer_r50_N1000/estimated-spectra.txt | grep -v 'eq' | grep -v 'sample' >> ./respect/final_results/rotifer_r50_N1000/estimated-spectra.txt
    cat ./respect/results3/rotifer_r50_N1000/estimated-spectra.txt | grep -v 'eq' | grep -v 'sample' >> ./respect/final_results/rotifer_r50_N1000/estimated-spectra.txt

    cp -r ./respect/result*/ ${dir}

    popd
done
