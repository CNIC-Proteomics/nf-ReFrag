#!/usr/bin/env nextflow
/*
========================================================================================
    PTM-compass
========================================================================================
    Github : https://github.com/CNIC-Proteomics/ptm-compass
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2


/*
========================================================================================
    VALIDATE & PRINT PARAMETER SUMMARY
========================================================================================
*/

// Under construction
WorkflowMain.initialise(workflow, params, log)

/*
========================================================================================
    IMPORT MAIN LOCAL MODULES/SUBWORKFLOWS
========================================================================================
*/

include {
    PTM_COMPASS_WORKFLOW;
    PTM_COMPASS_WORKFLOW_1;
    REFRAG_WORKFLOW;
    SHIFTS_WORKFLOW;
    SOLVER_WORKFLOW
} from './workflows/main'


/*
========================================================================================
    RUN MAIN WORKFLOW
========================================================================================
*/

// Info required for completion email and summary
def multiqc_report = []

//
// WORKFLOW: Execute the named workflow for the pipeline
//
workflow {
    // Execute main workflow
    REFRAG_WORKFLOW()
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
