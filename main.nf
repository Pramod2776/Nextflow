#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { dummyCheckInput } from "./modules/dummy_check_input"
include { DESeq2 } from "./modules/DESeq2"
include { VolcanoPlot } from "./modules/VolcanoPlot"
include { CLUSTERPROFILER_ORA } from "./modules/clusterprofiler_ora"
include { goTopGo } from "./modules/GO_TOPGO"
//include { PCA } from "./modules/pca"
include { BioQC } from "./modules/BioQC"
include { exprqc } from "./modules/exprqc"
include { merged } from "./modules/merged"
include { countcpm } from "./modules/countcpm"


workflow {
    // Retrieve and validate parameters
    assert params.gene_expression != null : "Please specify the `gene_expression` parameter"
    assert params.samplesheet != null : "Please specify the `samplesheet` parameter"
    expression = file(params.expression, checkIfExists: true)
    counts_expression = file(params.counts_expression, checkIfExists: true)
    filtered_expression = file(params.filtered_expression, checkIfExists: true)
    configuration = file(params.configuration, checkIfExists: true)
    gtf = file(params.gtf, checkIfExists: true)
    gene_expression = file(params.gene_expression, checkIfExists: true)
    group = params.group
    samplesheet = file(params.samplesheet, checkIfExists: true)
    genes_of_interest = params.genes_of_interest ? file(params.genes_of_interest, checkIfExists: true) : []
    ch_ora_pathway_dbs = Channel.from(params.ora_pathway_dbs)
    prefix = params.prefix
    de_fdr_cutoff = params.fdr
    pCutoff = params.pCutoff
    FCcutoff = params.FCcutoff
    colour_colum_pca = params.colour_colum_pca
    annotation_columns_counts = params.annotation_columns_counts
    annotation_columns_samplesheet = params.annotation_columns_samplesheet

    // start workflow
    dummyCheckInput(samplesheet, gene_expression, genes_of_interest)
    DESeq2(gene_expression, samplesheet, prefix)
    VolcanoPlot(DESeq2.out.de_res, genes_of_interest, pCutoff, FCcutoff,prefix)
    goTopGo(DESeq2.out.de_res)
   //PCA(gene_expression, samplesheet, colour_colum_pca, annotation_columns_counts, annotation_columns_samplesheet, prefix)
    BioQC(gene_expression, samplesheet)
    exprqc(filtered_expression, configuration, gtf, group)
    merged(expression, gtf)
    countcpm(counts_expression)

    if (!params.skip_ora) {
        //CLUSTERPROFILER_ORA(DESeq2.out.de_res, ch_ora_pathway_dbs, prefix, de_fdr_cutoff)
    }
}