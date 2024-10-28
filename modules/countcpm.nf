nextflow.enable.dsl=2

out_dir = file(params.resDir)
mode = params.publish_dir_mode

process countcpm {
    conda "conda-forge::python=3.8 bioconda::bioconductor-biocparallel=1.28.0 bioconda::bioconductor-deseq2=1.34.0 bioconda::bioconductor-org.hs.eg.db=3.14.0 conda-forge::r-dplyr=1.0.7 bioconda::bioconductor-ihw=1.22.0 conda-forge::r-tibble=3.1.6 conda-forge::r-readr=2.1.1 conda-forge::r-argparser=0.7.1"

    input:
        file(counts_expression)
        //path(gtf)
        //path(resDir)
        //val(group)

    output:
        path("*.txt"), emit: files, optional: true
        //path("${FPKM_merged_get_rsem_output.csv), emit: merged_FPKM
        //path("${TPM_merged_get_rsem_output.csv), emit: merged_TPM
        //path("${expected_count_merged_get_rsem_output.csv), emit: merged_counts

	script:
	"""
    count2cpm_raw.R \\
        --count=${counts_expression} \\
        --resDir=${out_dir}
	"""
}