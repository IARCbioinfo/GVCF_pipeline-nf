## GVCF_pipeline-nf
### Nextflow pipeline for generate GVCF from BAM with GenomeAnalysisTK with step of realignment 

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
