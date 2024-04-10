process DM0SOLVER {
    tag "${order}"
    label 'process_medium'

    input:
    val  order
    path input_file
    path input_file2
    val  params_file

    output:
    path "${input_file.baseName}_DM0S.txt", emit: ofile
    path "*_log.txt", emit: log

    script:
    """
    source ${SOLVER_HOME}/env/bin/activate && python ${SOLVER_HOME}/DM0SOlver_V2.py -i "${input_file}" -a "${input_file2}" -c "${params_file}"
    """
}
