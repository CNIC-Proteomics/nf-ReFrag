/*
========================================================================================
    IMPORT LOCAL MODULES/SUBWORKFLOWS
========================================================================================
*/

include { REFRAG } from './refrag'
include { SHIFTS } from './shifts'
include { SOLVER } from './solver'


//
// SUBWORKFLOW: Create input channels
//
include {
    CREATE_INPUT_CHANNEL_PTMCOMPASS;
    CREATE_INPUT_CHANNEL_PTMCOMPASS_1;
    CREATE_INPUT_CHANNEL_REFRAG;
    CREATE_INPUT_CHANNEL_SHIFTS;
    CREATE_INPUT_CHANNEL_SOLVER
} from '../subworkflows/create_input_channel'


/*
========================================================================================
    DEFINED WORKFLOWS
========================================================================================
*/

//
// WORKFLOW: Run main analysis pipeline
//

workflow PTM_COMPASS_WORKFLOW {
    //
    // SUBWORKFLOW: Create input channels
    //
    CREATE_INPUT_CHANNEL_PTMCOMPASS()
    //
    // WORKFLOW: ReFrag analysis
    //
    REFRAG(
        CREATE_INPUT_CHANNEL_PTMCOMPASS.out.ch_msf_raw_files,
        CREATE_INPUT_CHANNEL_PTMCOMPASS.out.ch_dm_file,
        CREATE_INPUT_CHANNEL_PTMCOMPASS.out.ch_params_file
    )
    // WORKFLOW: Run SHIFTS analysis pipeline
    //
    SHIFTS(
        REFRAG.out.ofile.collect(),
        CREATE_INPUT_CHANNEL_PTMCOMPASS.out.ch_exp_table,
        CREATE_INPUT_CHANNEL_PTMCOMPASS.out.ch_params_file
    )
    //
    // WORKFLOW: Run SOLVER analysis pipeline
    //
    SOLVER(
        SHIFTS.out.FDRfiltered,
        SHIFTS.out.Apexlist,
        CREATE_INPUT_CHANNEL_PTMCOMPASS.out.ch_database,
        CREATE_INPUT_CHANNEL_PTMCOMPASS.out.ch_sitelist_file,
        CREATE_INPUT_CHANNEL_PTMCOMPASS.out.ch_groupmaker_file,
        CREATE_INPUT_CHANNEL_PTMCOMPASS.out.ch_params_file
    )
}

workflow PTM_COMPASS_WORKFLOW_1 {
    //
    // SUBWORKFLOW: Create input channel
    //
    CREATE_INPUT_CHANNEL_PTMCOMPASS_1()
    // WORKFLOW: Run SHIFTS analysis pipeline
    //
    SHIFTS(
        CREATE_INPUT_CHANNEL_PTMCOMPASS_1.out.ch_re_files,
        CREATE_INPUT_CHANNEL_PTMCOMPASS_1.out.ch_exp_table,
        CREATE_INPUT_CHANNEL_PTMCOMPASS_1.out.ch_params_file
    )
    //
    // WORKFLOW: Run SOLVER analysis pipeline
    //
    SOLVER(
        SHIFTS.out.FDRfiltered,
        SHIFTS.out.Apexlist,
        CREATE_INPUT_CHANNEL_PTMCOMPASS_1.out.ch_database,
        CREATE_INPUT_CHANNEL_PTMCOMPASS_1.out.ch_sitelist_file,
        CREATE_INPUT_CHANNEL_PTMCOMPASS_1.out.ch_groupmaker_file,
        CREATE_INPUT_CHANNEL_PTMCOMPASS_1.out.ch_params_file
    )
}

workflow REFRAG_WORKFLOW {
    //
    // SUBWORKFLOW: Create input channels
    //
    CREATE_INPUT_CHANNEL_REFRAG ()
    //
    // WORKFLOW: ReFrag analysis
    //
    REFRAG(
        CREATE_INPUT_CHANNEL_REFRAG.out.ch_msf_raw_files,
        CREATE_INPUT_CHANNEL_REFRAG.out.ch_dm_file,
        CREATE_INPUT_CHANNEL_REFRAG.out.ch_params_file
    )
}

workflow SHIFTS_WORKFLOW {
    //
    // SUBWORKFLOW: Create input channel
    //
    CREATE_INPUT_CHANNEL_SHIFTS()
    // WORKFLOW: Run SHIFTS analysis pipeline
    //
    SHIFTS(
        CREATE_INPUT_CHANNEL_SHIFTS.out.ch_re_files,
        CREATE_INPUT_CHANNEL_SHIFTS.out.ch_exp_table,
        CREATE_INPUT_CHANNEL_SHIFTS.out.ch_params_file
    )
}

workflow SOLVER_WORKFLOW {
    //
    // SUBWORKFLOW: Create input channel
    //
    CREATE_INPUT_CHANNEL_SOLVER()
    //
    // WORKFLOW: Run SOLVER analysis pipeline
    //
    SOLVER(
        CREATE_INPUT_CHANNEL_SOLVER.out.ch_peakfdr_file,
        CREATE_INPUT_CHANNEL_SOLVER.out.ch_apexlist_file,
        CREATE_INPUT_CHANNEL_SOLVER.out.ch_database,
        CREATE_INPUT_CHANNEL_SOLVER.out.ch_sitelist_file,
        CREATE_INPUT_CHANNEL_SOLVER.out.ch_groupmaker_file,
        CREATE_INPUT_CHANNEL_SOLVER.out.ch_params_file
    )
}


/*
========================================================================================
    THE END
========================================================================================
*/
