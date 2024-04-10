process JOINER {
    tag "${order}"
    label 'process_medium'

    input:
    val  order
    path input_file
    val  params_file

    output:
    path "*_J.txt", emit: ofile
    path "*_log.txt", emit: log

    script:
    """
    source ${SOLVER_HOME}/env/bin/activate && python ${SOLVER_HOME}/Joiner_V2.py -i "${input_file}" -c "${params_file}"
    """
}
