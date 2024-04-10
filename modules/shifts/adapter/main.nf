process ADAPTER {
    tag "${order}"
    label 'process_medium'

    input:
    val order
    val input_file // get the value of path

    output:
    path("${input_file.baseName}_SHIFTS.feather"), emit: ofile
    path "*_log.txt", emit: log

    script:
    """
    source ${SHIFTS_HOME}/env/bin/activate && python ${SHIFTS_HOME}/SHIFTSadapter.py -i "${input_file}"
    mv "${input_file.getParent()}/${input_file.baseName}_SHIFTS.feather" "${input_file.getParent()}/${input_file.baseName}_log.txt" .
    """
}
