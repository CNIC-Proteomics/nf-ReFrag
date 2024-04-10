process PEAK_MODELLER {
    tag "${order}"
    label 'process_high'

    input:
    val  order
    path input_file
    val  params_file

    output:
    path "PeakModeller_DMTable.feather", emit: oDMtable
    path "PeakModeller_DMHistogram.tsv", emit: oHistogram
    path "*_log.txt", emit: log

    script:
    """
    source ${SHIFTS_HOME}/env/bin/activate && python ${SHIFTS_HOME}/PeakModeller.py -i "*_Unique_calibrated.feather" -c "${params_file}"
    """
}
