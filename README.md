# nf-ReFrag
Nextflow for ReFrag pipeline

# Usage

Executing using Ubuntu and Singularity (WSL - backend):
```
cd /home/jmrodriguezc/nf-ReFrag

nextflow \
    -log "/tmp/nextflow/log/nf-refrag.log" \
    run main.nf   \
        -profile singularity \
        --raw_files "/mnt/tierra/U_Proteomica/UNIDAD/DatosCrudos/jmrodriguezc/projects/nf-ReFrag/tests/test1/inputs/raw_files/*" \
        --msf_files "/mnt/tierra/U_Proteomica/UNIDAD/DatosCrudos/jmrodriguezc/projects/nf-ReFrag/tests/test1/inputs/msf_files/*" \
        --dm_file "/mnt/tierra/U_Proteomica/UNIDAD/DatosCrudos/jmrodriguezc/projects/nf-ReFrag/tests/test1/inputs/dm_file.tsv" \
        --decoy_prefix "DECOY_"\
        --scanrange ""\
        --params_file "/mnt/tierra/U_Proteomica/UNIDAD/DatosCrudos/jmrodriguezc/projects/nf-ReFrag/tests/test1/inputs/params.ini" \
        --outdir  "/mnt/tierra/U_Proteomica/UNIDAD/DatosCrudos/jmrodriguezc/projects/nf-ReFrag/tests/test1" \
        -resume
```

