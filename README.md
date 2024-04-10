# nf-ReFrag
Nextflow for ReFrag pipeline

# Usage

Debugging using Ubuntu and Singularity (WSL - backend):
```
cd /home/jmrodriguezc/nf-ReFrag

nextflow \
    -log "/tmp/nextflow/log/nf-refrag.log" \
    run main.nf   \
        -params-file "/home/jmrodriguezc/projects/nf-ReFrag/tests/test1/inputs/inputs.yml" \
        --outdir  "/home/jmrodriguezc/projects/nf-ReFrag/tests/test1" \
        --params_file "/home/jmrodriguezc/projects/nf-ReFrag/tests/test1/inputs/params.ini" \
        -resume
```
