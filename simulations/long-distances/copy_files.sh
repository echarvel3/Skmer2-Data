for x in {1..5}; do
    mkdir rep${x}
    pushd rep${x}

    mkdir distances
    pushd distances
    
    dir="/scratch01/echarvel/skims_sims/experiments_long-distances/rep${x}/dist_matrices/"

    cp ${dir}"/respect_r50-err6+new"* .
    cp ${dir}"/noref_def"* .

    popd
    
    mkdir stats
    pushd stats

    dir="/scratch01/echarvel/skims_sims/experiments_long-distances/rep${x}/stat_files/"

    cp ${dir}"/respect_r50-err6+new"* .   
    cp ${dir}"/noref_def"* .

    popd

    dir="/scratch01/echarvel/skims_sims/experiments_long-distances/rep${x}/respect/"

    mkdir respect

    cp -r ${dir}/results/* ./respect/


    popd

done
