/*
========================================================================================
    VALIDATE INPUTS
========================================================================================
*/


/*
========================================================================================
    CONFIG FILES
========================================================================================
*/


/*
========================================================================================
    IMPORT LOCAL MODULES/SUBWORKFLOWS
========================================================================================
*/

include { SHIFTS } from './shifts'


//
// SUBWORKFLOW: Consisting of a mix of local and nf-core/modules
//

include { CREATE_INPUT_CHANNEL } from '../subworkflows/create_input_channel'



/*
========================================================================================
    IMPORT NF-CORE MODULES/SUBWORKFLOWS
========================================================================================
*/

//
// MODULE: Installed directly from nf-core/modules
//

// include { CUSTOM_DUMPSOFTWAREVERSIONS } from '../modules/nf-core/custom/dumpsoftwareversions/main'



/*
========================================================================================
    RUN MAIN WORKFLOW
========================================================================================
*/

// Info required for completion email and summary
def multiqc_report = []

workflow PTM_COMPASS {

    //
    // SUBWORKFLOW: Read in samplesheet, validate and stage input files
    //

    //
    // SUBWORKFLOW: Create input channel
    //
    CREATE_INPUT_CHANNEL (
        params.input_files
    )


    //
    // SUBWORKFLOW: File preparation
    //
    // // Create output dirs
    // if ( 'output_dir' in params ) {
    //     output_dir = "$params.output_dir"
    //     r = file(output_dir).mkdirs()
    //     println r ? "OK creating the directory: $output_dir" : "Cannot create directory: $output_dir"
    // }



    //
    // WORKFLOW: Run SHIFTS analysis pipeline
    //
    SHIFTS(CREATE_INPUT_CHANNEL.out.input_file)


}

/*
========================================================================================
    COMPLETION EMAIL AND SUMMARY
========================================================================================
*/

// workflow.onComplete {
//     if (params.email || params.email_on_fail) {
//         NfcoreTemplate.email(workflow, params, summary_params, projectDir, log, multiqc_report)
//     }
//     NfcoreTemplate.summary(workflow, params, log)
//     if (params.hook_url) {
//         NfcoreTemplate.IM_notification(workflow, params, summary_params, projectDir, log)
//     }
// }

/*
========================================================================================
    THE END
========================================================================================
*/
