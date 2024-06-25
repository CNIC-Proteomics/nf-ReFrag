//
// Create channel for input files
//


/*
========================================================================================
    IMPORT MODULES
========================================================================================
*/

import org.yaml.snakeyaml.Yaml

/*
========================================================================================
    LOCAL FUNCIOTNS
========================================================================================
*/


// Define a function to check which parameters are missing
def getMissingParams(params, required_params) {
    def missingParams = []
    // Iterate over each parameter in the list
    for (param in required_params) {
        // Check if the parameter exists in the params
        if (!params.containsKey(param)) {
            // If parameter is missing, add it to the list of missing parameters
            missingParams.add(param)
        }
    }
    // Return the list of missing parameters
    return missingParams
}

// Print an error message for the missing parameters
def printErrorMissingParams(params, required_params) {
    // check which parameters are missing in the dict
    def missingParams = getMissingParams(params, required_params)
    // stop from the missing parameters
    if (!missingParams.isEmpty()) {
        exit 1, "ERROR: Missing parameters: ${missingParams}"
    }
}

// Join two channels based on the file name
def joinChannelsFromFilename(ifiles1, ifiles2) {

    // create a list of tuples with the base name and the file name.
    def files1 = ifiles1
                    // .flatten()
                    .map{  file -> tuple(file.baseName, file) }
                    // .view()
                    // .set { files1 }

    // create a list of tuples with the base name and the file name.
    def files2 = ifiles2
                    .map { file -> tuple(file.baseName, file) }
                    // .view()
                    // .set { files2 }

    // join both channels based on the first element (base name)
    def files3 = files1
                    .join(files2)
                    .map { name, f1, f2 -> [f1, f2] }
                    // .view { "value: $it" }
                    // .set { files3 }

    return files3
}

/*
========================================================================================
    DEFINED WORKFLOWS
========================================================================================
*/

workflow CREATE_INPUT_CHANNEL_PTMCOMPASS {
    main:

    // stop from the missing parameters
    def requiredParams = ['raw_files','msf_files','dm_file','exp_table','database','decoy_prefix']
    printErrorMissingParams(params, requiredParams)

    // create channels from input files
    raw_files = Channel.fromPath("${params.raw_files}", checkIfExists: true)
    msf_files = Channel.fromPath("${params.msf_files}", checkIfExists: true)
    // join two channels based on the file name
    msf_raw_files = joinChannelsFromFilename(raw_files, msf_files)

    // these files will be used multiple times; So, we have to create a Value Channel and then, check if file exists
    File file = new File("${params.dm_file}")
    if ( file.exists() ) {
        dm_file = Channel.value("${params.dm_file}")
    } else { exit 1, "ERROR: The 'dm_file' file does not exist" }

    // create channels from input files
    exp_table       = Channel.fromPath("${params.exp_table}", checkIfExists: true)
    database        = Channel.fromPath("${params.database}", checkIfExists: true)
    sitelist_file   = Channel.fromPath("${params.sitelist_file}", checkIfExists: true)
    groupmaker_file = Channel.fromPath("${params.groupmaker_file}", checkIfExists: true)

    // // update the given parameter into the fixed parameter file
    // def redefinedParams = ['decoy_prefix': params.decoy_prefix]
    // def updated_params_str = Utils.updateParamsFile(params.fixed_params_file, redefinedParams)
    // def fixed_params_file = Utils.writeStrIntoFile(updated_params_str, "${params.paramdir}/params.ini")

    // // merge the files that contain both the fixed parametes and the variable parameters
    // def merged_params_str = Utils.mergeIniFiles(fixed_params_file, params.params_file)
    // def updated_params_file = Utils.writeStrIntoFile(merged_params_str, "${params.paramdir}/params.ini")

    // update the given parameter into the fixed parameter file
    def redefinedParams = ['decoy_prefix': params.decoy_prefix]
    def updated_params_str = Utils.updateParamsFile(params.params_file, redefinedParams)
    def updated_params_file = Utils.writeStrIntoFile(updated_params_str, "${params.paramdir}/params.ini")

    // create channel for params file
    params_file = Channel.value("${updated_params_file}")


    emit:
    ch_re_files         = re_files
    ch_exp_table        = exp_table
    ch_database         = database
    ch_sitelist_file    = sitelist_file
    ch_groupmaker_file  = groupmaker_file
    ch_params_file      = params_file
}

workflow CREATE_INPUT_CHANNEL_PTMCOMPASS_1 {
    main:

    // stop from the missing parameters
    def requiredParams = ['re_files','exp_table','database','decoy_prefix']
    printErrorMissingParams(params, requiredParams)

    // create channels from input files
    re_files        = Channel.fromPath("${params.re_files}", checkIfExists: true)
    exp_table       = Channel.fromPath("${params.exp_table}", checkIfExists: true)
    database        = Channel.fromPath("${params.database}", checkIfExists: true)
    sitelist_file   = Channel.fromPath("${params.sitelist_file}", checkIfExists: true)
    groupmaker_file = Channel.fromPath("${params.groupmaker_file}", checkIfExists: true)

    // update the given parameter into the fixed parameter file
    def redefinedParams = ['decoy_prefix': params.decoy_prefix]
    def updated_params_str = Utils.updateParamsFile(params.params_file, redefinedParams)
    def updated_params_file = Utils.writeStrIntoFile(updated_params_str, "${params.paramdir}/params.ini")

    // create channel for params file
    // these files will be used multiple times; So, we have to create a Value Channel and then, check if file exists
    params_file = Channel.value("${updated_params_file}")


    emit:
    ch_re_files         = re_files
    ch_exp_table        = exp_table
    ch_database         = database
    ch_sitelist_file    = sitelist_file
    ch_groupmaker_file  = groupmaker_file
    ch_params_file      = params_file
}

workflow CREATE_INPUT_CHANNEL_REFRAG {
    main:

    // stop from the missing parameters
    def requiredParams = ['raw_files','msf_files','dm_file','decoy_prefix']
    printErrorMissingParams(params, requiredParams)

    // create channels from input files
    raw_files = Channel.fromPath("${params.raw_files}", checkIfExists: true)
    msf_files = Channel.fromPath("${params.msf_files}", checkIfExists: true)
    // join two channels based on the file name
    msf_raw_files = joinChannelsFromFilename(raw_files, msf_files)

    // these files will be used multiple times; So, we have to create a Value Channel and then, check if file exists
    File file = new File("${params.dm_file}")
    if ( file.exists() ) {
        dm_file = Channel.value("${params.dm_file}")
    } else { exit 1, "ERROR: The 'dm_file' file does not exist" }

    // update the given parameter into the fixed parameter file
    def redefinedParams = ['decoy_prefix': params.decoy_prefix]
    def updated_params_str = Utils.updateParamsFile(params.params_file, redefinedParams)
    def updated_params_file = Utils.writeStrIntoFile(updated_params_str, "${params.paramdir}/params.ini")

    // create channel for params file
    // these files will be used multiple times; So, we have to create a Value Channel and then, check if file exists
    params_file = Channel.value("${updated_params_file}")

    emit:
    ch_msf_raw_files  = msf_raw_files
    ch_dm_file        = dm_file
    ch_params_file    = params_file
}

workflow CREATE_INPUT_CHANNEL_SHIFTS {
    main:

    // stop from the missing parameters
    def requiredParams = ['re_files','exp_table']
    printErrorMissingParams(params, requiredParams)

    // create channels from input files
    re_files        = Channel.fromPath("${params.re_files}", checkIfExists: true)
    exp_table       = Channel.fromPath("${params.exp_table}", checkIfExists: true)

    // update the given parameter into the fixed parameter file
    def redefinedParams = []
    def updated_params_str = Utils.updateParamsFile(params.params_file, redefinedParams)
    def updated_params_file = Utils.writeStrIntoFile(updated_params_str, "${params.paramdir}/params.ini")

    // create channel for params file
    params_file = Channel.value("${updated_params_file}")


    emit:
    ch_re_files         = re_files
    ch_exp_table        = exp_table
    ch_params_file      = params_file
}

workflow CREATE_INPUT_CHANNEL_SOLVER {
    main:

    // stop from the missing parameters
    def requiredParams = ['peak_fdr','apex_list','database','decoy_prefix']
    printErrorMissingParams(params, requiredParams)

    // create channels from input files
    peak_fdr        = Channel.fromPath("${params.peak_fdr}", checkIfExists: true)
    apex_list       = Channel.fromPath("${params.apex_list}", checkIfExists: true)
    database        = Channel.fromPath("${params.database}", checkIfExists: true)
    sitelist_file   = Channel.fromPath("${params.sitelist_file}", checkIfExists: true)
    groupmaker_file = Channel.fromPath("${params.groupmaker_file}", checkIfExists: true)

    // update the given parameter into the fixed parameter file
    def redefinedParams = ['decoy_prefix': params.decoy_prefix]
    def updated_params_str = Utils.updateParamsFile(params.params_file, redefinedParams)
    def updated_params_file = Utils.writeStrIntoFile(updated_params_str, "${params.paramdir}/params.ini")

    // create channel for params file
    params_file = Channel.value("${updated_params_file}")


    emit:
    ch_peakfdr_file     = peak_fdr
    ch_apexlist_file    = apex_list
    ch_database         = database
    ch_sitelist_file    = sitelist_file
    ch_groupmaker_file  = groupmaker_file
    ch_params_file      = params_file
}
