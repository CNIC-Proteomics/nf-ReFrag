process PEAK_SELECTOR {
    tag "${order}"
    label 'process_medium'

    input:
    val  order
    path input_file
    val  params_file

    output:
    path "PeakModeller_ApexList.txt", emit: oApexlist
    path "*_log.txt", emit: log

    script:
    """
    source ${SHIFTS_HOME}/env/bin/activate && python ${SHIFTS_HOME}/PeakSelector.py -i "${input_file}" -c "${params_file}"
    """
}
