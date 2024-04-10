process SITE_SOLVER {
    tag "${order}"
    label 'process_medium'

    input:
    val  order
    path input_file
    path sitelist_file
    val  params_file

    output:
    path "${input_file.baseName}_SS.txt", emit: ofile
    path "*_log.txt", emit: log

    script:
    """
    source ${SOLVER_HOME}/env/bin/activate && python ${SOLVER_HOME}/SiteSolver_V2.py -i "${input_file}" -pl "${sitelist_file}" -c "${params_file}"
    """
}
