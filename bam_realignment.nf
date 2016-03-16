#! /usr/bin/env nextflow

// usage : ./bam_realignment.nf --bam_folder BAM/ --cpu 8 --mem 32 --ref hg19.fasta --RG "PL:ILLUMINA"

if (params.help) {
    log.info ''
    log.info '--------------------------------------------------'
    log.info 'NEXTFLOW BAM REALIGNMENT WITH SORT AND INDEX'
    log.info '--------------------------------------------------'
    log.info ''
    log.info 'Usage: '
    log.info 'nextflow run bam_realignment.nf --bam_folder BAM/ --cpu 8 --mem 32 --fasta_ref hg19.fasta'
    log.info ''
    log.info 'Mandatory arguments:'
    log.info '    --bam_folder   FOLDER                  Folder containing BAM files to be called.'
    log.info '    --ref    FILE                    Reference fasta file (with index).'
    log.info 'Optional arguments:'
    log.info '    --cpu          INTEGER                 Number of cpu used by bwa mem and sambamba (default: 8).'
    log.info '    --mem          INTEGER                 Size of memory used by sambamba (in GB) (default: 32).'
    log.info '    --RG           STRING                  Samtools read group specification with "\t" between fields.'
    log.info '                                           e.g. --RG "PL:ILLUMINA\tDS:custom_read_group".'
    log.info '                                           Default: "ID:bam_file_name\tSM:bam_file_name".'
    log.info '    --out_folder   STRING                  Output folder (default: results_realignment).'
    log.info ''
    exit 1
}

params.RG = ""
params.cpu = 8
params.mem = 32
params.out_folder="results_realignment"

fasta_ref = file(params.ref)
bams = Channel.fromPath( params.bam_folder+'/*.bam' )
              .ifEmpty { error "Cannot find any bam file in: ${params.bam_folder}" }

process bam_realignment {

    memory = params.mem+'GB'    
  
    tag { bam_tag }

    publishDir params.out_folder, mode: 'move'

    input:
    file bam from bams
    file fasta_ref

    output:
    file('*realigned.bam*') into outputs

    shell:
    bam_tag = bam.baseName
    '''
    samtools collate -uOn 128 !{bam_tag}.bam tmp_!{bam_tag} | samtools fastq - | bwa mem -M -t!{params.cpu} -R "@RG\tID:!{bam_tag}\tSM:!{bam_tag}\t!{params.RG}" -p !{fasta_ref} - | samblaster --addMateTags | sambamba view -S -f bam -l 0 /dev/stdin | sambamba sort -t !{params.cpu} -m !{params.mem}G --tmpdir=!{bam_tag}_tmp -o !{bam_tag}_realigned.bam /dev/stdin
    '''
}



