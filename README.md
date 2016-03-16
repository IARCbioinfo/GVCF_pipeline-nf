## GVCF_pipeline-nf
### Nextflow pipeline for generate GVCF from BAM with GenomeAnalysisTK with step of realignment 

#### Pipeline skeleton
The pipeline is seperated in four chained nextflow processes:

1. A BAM realignement process, which desaligns and realigns BAM files.
2. An indel realignment process, which performs a local realignment around indels.
3. A recalibration process from realigned BAM files.
4. A GVCF build process from recalibrated BAM files.

#### Dependencies
1. Install [Samtools](https://github.com/samtools/samtools).
2. Install [bwa](http://bio-bwa.sourceforge.net/)
3. Install [Sambamba](https://github.com/lomereiter/sambamba/releases).
4. Download [GATK tools](https://www.broadinstitute.org/gatk/download/).

Install [nextflow](http://www.nextflow.io/).

	```bash
	curl -fsSL get.nextflow.io | bash
	```
	And move it to a location in your `$PATH` (`/usr/local/bin` for example here):
	```bash
	sudo mv nextflow /usr/local/bin
	```
Also copy or move in your path ```samtools```, ```bwa``` and ```sambamba```.

#### Parameters
##### Mandatory
- ```--bam_folder```: Folder containing BAM files to be called.
- ```--hg19_ref```: Reference fasta file (with index) (excepted if in your config).
- ```--GenomeAnalysisTK```: GenomeAnalysisTK.jar file.
- ```--gold_std_indels```: Gold standard GATK for indels.
- ```--phase1_indels```: Phase 1 GATK for indels.
- ```--dbsnp```: dbSNP mutations file. 

##### Optional
- ```--cpu```: Number of cpu used by bwa mem and sambamba (default: 8).
- ```--mem```: Size of memory used by sambamba (in GB) (default: 32).
- ```--RG```: Samtools read group specification with "\t" between fields (Default: "ID:bam_file_name\tSM:bam_file_name").
 
             e.g. --RG "PL:ILLUMINA\tDS:custom_read_group".
             
- ```--out_folder ```: Output folder (default: results_realignment).
- ```--intervals_gvcf```: Bed file provided to GATK HaplotypeCaller.

All the parameters you want to use can be defined globally in your ```~/.nextflow/config``` file as the following example:

```bash
profiles {
	standard {
                params {
                   hg19_ref = '/appli57/reference/GATK_Bundle/ucsc.hg19.fasta'
                   dbsnp = '/appli57/reference/GATK_Bundle/dbsnp_138.hg19_noMT.vcf'
                   GenomeAnalysisTK = '/appli57/GenomeAnalysisTK/GATK-3.4-0/GenomeAnalysisTK.jar'
                   gold_std_indels = '/appli57/reference/GATK_Bundle/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf'
                   phase1_indels = '/appli57/reference/GATK_Bundle/1000G_phase1.indels.hg19.sites.vcf'
                }

}
```

## BAM realignment pipeline

If you just want to desalign and realign your BAM files in order to precisely control the alignment, you can use the nextflow script `bam_realignment.nf`.
This pipeline use an optimized combination of `samtools`, `bwa mem` and `sambamba` in one command line with pipes.

#### Parameters
