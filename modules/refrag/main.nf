process RE_FRAG {
    tag "${order}"
    label 'process_high'

    input:
    val order
    tuple path(raw_files), path(msf_files)
    path dm_file
    path params_file

    output:
    path "${raw_files.baseName}_REFRAG.tsv", emit: ofile
    path "*.log", emit: log

    script:
    """
    source ${REFRAG_HOME}/env/bin/activate && python ${REFRAG_HOME}/ReFrag.py -w "${task.cpus}" -i "${msf_files}" -r "${raw_files}" -d "${dm_file}" -c "${params_file}"
    """
}
