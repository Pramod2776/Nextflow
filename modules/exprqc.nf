nextflow.enable.dsl=2

out_dir = file(params.resDir)
mode = params.publish_dir_mode

process exprqc {
    conda "conda-forge::python=3.8 bioconda::bioconductor-biocparallel=1.28.0 bioconda::bioconductor-deseq2=1.34.0 bioconda::bioconductor-org.hs.eg.db=3.14.0 conda-forge::r-dplyr=1.0.7 bioconda::bioconductor-ihw=1.22.0 conda-forge::r-tibble=3.1.6 conda-forge::r-readr=2.1.1 conda-forge::r-argparser=0.7.1"

    input:
        path(filtered_expression)
        path(configuration)
        path(gtf)
        //path(resDir)
        val(group)

    output:
        path("*.pdf"), emit: plots, optional: true
        path("*.png"), emit: plot, optional: true
        //path("${prefix}_DESeq2_result.tsv"), emit: de_res
        //path("${prefix}_detectedGenesNormalizedCounts_min_10_reads_in_one_condition.tsv"), emit: norm_counts_filtered
        //path("${prefix}_detectedGenesRawCounts_min_10_reads_in_one_condition.tsv"), emit: counts_filtered
        path("RNA__expr-qc_run-log"), emit: log

	script:
	"""
    exprqc.R \\
        --input=${filtered_expression} \\
        --config=${configuration} \\
        --gtf=${gtf} \\
        --group=${group} 
	"""
}