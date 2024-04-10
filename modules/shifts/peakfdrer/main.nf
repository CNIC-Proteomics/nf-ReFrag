process PEAK_FDRER {
    tag "${order}"
    label 'process_high'

    input:
    val  order
    path input_file
    path exp_table
    val  params_file

    output:
    path "${input_file.baseName}_FDRfiltered.tsv", emit: oFDRfiltered
    path "${input_file.baseName}_FDR.tsv", emit: oFDR
    path "*_log.txt", emit: log

    script:
    """
    source ${SHIFTS_HOME}/env/bin/activate && python ${SHIFTS_HOME}/PeakFDRer.py -i "${input_file}" -e "${exp_table}" -c "${params_file}"
    """
}
