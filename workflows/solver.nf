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

include { PROTEIN_ASSIGNER;
          PROTEIN_ASSIGNER as PROTEIN_ASSIGNER_2;
}                               from '../modules/proteinassigner/main'
include { SCANID_GENERATOR }    from '../modules/scanidgenerator/main'
include { PEAK_ASSIGNATOR }     from '../modules/shifts/peakassignator/main'

include { DM0SOLVER }           from '../modules/solver/dm0solver/main'
include { TRUNK_SOLVER }        from '../modules/solver/trunksolver/main'
include { SITELIST_MAKER }      from '../modules/solver/sitelistmaker/main'
include { SITE_SOLVER }         from '../modules/solver/sitesolver/main'
include { PDMTABLE_MAKER }      from '../modules/solver/pdmtablemaker/main'
include { GROUP_MAKER }         from '../modules/solver/groupmaker/main'
include { JOINER      }         from '../modules/solver/joiner/main'



/*
========================================================================================
    RUN MAIN WORKFLOW
========================================================================================
*/

workflow SOLVER {

    take:
    peakfdrer
    apexlist
    database
    sitelist_file
    groupmaker_file
    params_file

    main:
    //
    // SUBMODULE: DM0 solver
    //
    DM0SOLVER('01', peakfdrer, apexlist, params_file)
    //
    // SUBMODULE: protein assigner
    //
    PROTEIN_ASSIGNER('02', DM0SOLVER.out.ofile, database, params_file)
    //
    // SUBMODULE: Trunk solver
    //
    TRUNK_SOLVER('03', PROTEIN_ASSIGNER.out.ofile, database, params_file)
    //
    // SUBMODULE: protein assigner
    //
    PROTEIN_ASSIGNER_2('04', TRUNK_SOLVER.out.ofile, database, params_file)
    //
    // SUBMODULE: Peak assignator
    //
    def params_sections = Channel.value(['PeakAssignator_in_Solver','Logging','General'])
    PEAK_ASSIGNATOR('05', PROTEIN_ASSIGNER_2.out.ofile, apexlist, params_file, params_sections)
    //
    // SUBMODULE: Site list maker
    //
    SITELIST_MAKER('06', PEAK_ASSIGNATOR.out.oPeakassign, params_file)
    //
    // SUBMODULE: Site solver
    //
    SITE_SOLVER('07', PEAK_ASSIGNATOR.out.oPeakassign, sitelist_file, params_file)
    //
    // SUBMODULE: Scan id generator
    //
    SCANID_GENERATOR('08', SITE_SOLVER.out.ofile)
    //
    // SUBMODULE: PDMtable maker
    //
    PDMTABLE_MAKER('09', SCANID_GENERATOR.out.ofile, database, params_file)
    //
    // SUBMODULE: Group maker
    //
    GROUP_MAKER('10', PDMTABLE_MAKER.out.ofile, groupmaker_file, params_file)
    //
    // SUBMODULE: Joiner
    //
    JOINER('11', GROUP_MAKER.out.ofile, params_file)


    // return channels
    ch_DM0solver              = DM0SOLVER.out.ofile
    ch_MProtein               = PROTEIN_ASSIGNER.out.ofile
    ch_TrunkSolver            = TRUNK_SOLVER.out.ofile
    ch_PeakAssign             = PEAK_ASSIGNATOR.out.oPeakassign
    ch_SiteFrequency          = SITELIST_MAKER.out.oFrequency
    ch_SiteCleanFrequency     = SITELIST_MAKER.out.oCleanFrequency
    ch_SiteCleanP0Frequency   = SITELIST_MAKER.out.oCleanP0Frequency
    ch_SiteSolver             = SITE_SOLVER.out.ofile
    ch_PDMtable               = PDMTABLE_MAKER.out.ofile
    ch_GroupMaker             = GROUP_MAKER.out.ofile
    ch_GroupJoiner            = JOINER.out.ofile

    emit:
    DM0solver             = ch_DM0solver
    MProtein              = ch_MProtein
    TrunkSolver           = ch_TrunkSolver
    Peakassign            = ch_PeakAssign
    SiteFrequency         = ch_SiteFrequency
    SiteCleanFrequency    = ch_SiteCleanFrequency
    SiteCleanP0Frequency  = ch_SiteCleanP0Frequency
    SiteSolver            = ch_SiteSolver
    PDMtable              = ch_PDMtable
    GroupMaker            = ch_GroupMaker
    GroupJoiner           = ch_GroupJoiner
}

/*
========================================================================================
    THE END
========================================================================================
*/
