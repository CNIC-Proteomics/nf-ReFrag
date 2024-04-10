process SCANID_GENERATOR {
    tag "${order}"
    label 'process_medium'

    input:
    val  order
    path input_file

    output:
    path "${input_file.baseName}_ScanID.txt", emit: ofile

    script:
    """
    source ${SHIFTS_HOME}/env/bin/activate && python ${SHIFTS_HOME}/tools/ScanIDgenerator.py -i "${input_file}" 
    """
}
