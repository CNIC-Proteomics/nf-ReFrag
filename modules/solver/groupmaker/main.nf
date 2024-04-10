process GROUP_MAKER {
    tag "${order}"
    label 'process_medium'

    input:
    val  order
    path input_file
    path groupmaker_file
    val  params_file

    output:
    path "*_GM.txt", emit: ofile
    path "*_log.txt", emit: log

    script:
    """
    source ${SOLVER_HOME}/env/bin/activate && python ${SOLVER_HOME}/GroupMaker.py -i "${input_file}" -u "${groupmaker_file}" -c "${params_file}"
    """
}
