process PEAK_INSPECTOR {
    tag "${order}"
    label 'process_medium'

    input:
    val  order
    path input_file
    path params_file

    output:
    path "${input_file.baseName}_calibrated.feather", emit: ofile
    path "*_log.txt", emit: log

    script:
    """
    source ${SHIFTS_HOME}/env/bin/activate && python ${SHIFTS_HOME}/PeakInspector.py -i "${input_file}" -c "${params_file}"
    """
}
