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


    popd

done
