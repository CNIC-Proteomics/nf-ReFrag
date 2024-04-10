process SITELIST_MAKER {
    tag "${order}"
    label 'process_medium'

    input:
    val  order
    path input_file
    val  params_file

    output:
    path "${input_file.baseName}_Frequency_Table.txt", emit: oFrequency
    path "${input_file.baseName}_Clean_Frequency_Table.txt", emit: oCleanFrequency
    path "${input_file.baseName}_Clean_P0_Frequency_Table.txt", emit: oCleanP0Frequency
    path "*_log.txt", emit: log

    script:
    """
    source ${SOLVER_HOME}/env/bin/activate && python ${SOLVER_HOME}/SiteListMaker.py -i "${input_file}" -c "${params_file}"
    """
}
