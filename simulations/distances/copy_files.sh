for x in {1..10}; do
    mkdir rep${x}
    pushd rep${x}

    mkdir distances
    pushd distances
    
    dir="/mirarablab_data/echarvel/skmer2/experiments_child-to-parent/rep${x}/dist_matrices/"

    cp ${dir}"/assembly-50-paired_err6+new"* .
    cp ${dir}"/gen-0.0_err6+new"* .
    cp ${dir}"/respect_r50-err6+new"* .
    cp ${dir}"/noref_def"* .

    popd
    
    mkdir stats
    pushd stats

    dir="/mirarablab_data/echarvel/skmer2/experiments_child-to-parent/rep${x}/stat_files/"

    cp ${dir}"/assembly-50-paired_err6+new"* .
    cp ${dir}"/gen-0.0_err6+new"* .
    cp ${dir}"/respect_r50-err6+new"* .   
    cp ${dir}"/noref_def"* .


    popd

    dir="/mirarablab_data/echarvel/skmer2/experiments_child-to-parent/rep${x}/respect/results/"

    mkdir respect

    cp -r ${dir}/* ./respect/


    popd

done
