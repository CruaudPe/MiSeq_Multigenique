# MiSeq_Multigenique
Processing of amplicon raw data from Illumina MiSeq sequencing.

## Raw data

Output files (".fastq.gz") are located in Data/Intensities/BaseCalls.
The first thing to do is to create a folder that will contain input and output files as well as report files for this run : 

`mkdir RUNX`

Then, we need to create a sub-folder Fastq_Initiaux that will contain all the raw fastq files

`mkdir RUNX/Fastq_Initiaux`

Copy and uncompress all .fasq.gz files in this subfolder

`cp Your/Path/*.fastq.gz Your/Path/RUNX/Fastq_Initiaux/`

`gunzip Fastq_Initiaux/*`

**NB :** After sequencing, 2 output files per sample are obtained : one file containing reads 1 (R1) and another one containing reads 2 (R2). Output files are named with sample name and ID as indicated in the Sample Sheet. Lane number is always L001 for MiSeq sequencing.
> SampleName_SampleID_LaneNumber_ReadNumber_001.fastq (e.g. JRAS03221-0182_S183_L001_R1_001.fastq)

Samples are numbered, starting at 1. Non-assigned reads are clustered in fastq file number 0.
> Undetermined_S0_L001_R1_001.fastq

S0 files may be removed from the sub-folder Fastq_Initiaux since they will not be used for this analysis.
`rm Undetermined_S0*` in the sub-folder Fastq_Initiaux/


## STEP 1 : Quality control
[In RUNX]

First, we will check the quality of the run (reads 1 and reads 2).

`mkdir Bilan_Global`

`cat Fastq_Initiaux/* > Bilan_Global/Global.fastq`

`cat Fastq_Initiaux/*L001_R1_001.fastq > Bilan_Global/Global_Reads1.fastq`

`cat Fastq_Initiaux/*L001_R2_001.fastq > Bilan_Global/Global_Reads2.fastq`

[In RUNX/Bilan_Global]

`fastqc --extract Global.fastq`

`fastqc --extract Global_Reads1.fastq`

`fastqc --extract Global_Reads2.fastq`

*or specify the path to the fastqc executable file in your computer*

Create a summary file for the run using the script below.

[In RUNX]

`Path/To/File/Summary_RunQuality.sh`
* with the correct path to the script file*


## STEP 2 : Merge paired-end reads
[In RUNX]

Merge paired-end reads contained in Fastq_Initiaux/ using Flash v.2.
Output files in Fastq_Flash2Merge/

`Path/To/File/FLASH2_multiple.sh`
*set the correct path to the script file*


## STEP 3 : PCR primer trimming
[In RUNX]

Sequence sorting according to primer sequences and elimination of primers.

For each sequenced fragment, create a sub-folder in the RUNX folder with the name of the corresponding fragment (e.g. "Bact_V3V4"). In this sub-folder, create a text file "Caracteristiques_Amplicons.txt" indicating sequences of forward and reverse primers ("Caracteristiques_Amplicons.txt found in this GitHub repository is provided as an example). For each sequenced fragment,   run the script below and indicate the name of the corresponding folder. 

`Path/To/File/CUTADAPT_multiple.sh`

*At the beginning, the program automatically asks the user to set up the maximum allowed error rates in the primer sequence and the minimum length required to keep the sequences in the output file. The default parameters should be loaded if 0.1 is indicated for error rates.*

## STEP 4 : OTUs and/or SWARMs clustering
[In RUNX/SequencedFragment]

Run the script ConvertFastqFasta.sh to convert fastq files in fasta files.

`Path/To/File/ConvertFastqFasta.sh`

Then, concatenate all fasta files in a single file "AllSamples.fasta" using the script below.

`Path/To/File/PoolageEchantillons.sh`

Dereplication 

`Path/To/File/Dereplication.sh`

OTUs clustering (97% similarity) using vsearch

`Path/To/File/ClusterisationVSEARCH.sh`

and/or SWARMs clustering using swarm

`Path/To/File/ClusterisationSWARM.sh`


##STEP 5 : Elimination of singletons and putative chimeric sequences
[In RUNX/SequencedFragment]

Putative chimeric sequences and singletons are removed from the data set using VSEARCH.

`Path/To/File/VSEARCH_ChimereSingleton_Uniq.sh`
*This script includes an R script "FormatLongAFormatLarge.R". You have to set the correct path to this script in the VSEARCH_ChimereSingleton_Uniq.sh script.*


## STEP 6 : Taxonomic assignments
[In RUNX/SequencedFragment]

Taxonomic assignments of the reads are performed using the classify.seqs() command of Mothur.
For each clustering (OTUs and/or SWARMs), taxonomic assignments are performed using :

-  the Mothur version of the "Bayesian" classifier (this classifier implements the same algorithm as the RDP classifier)
-  BLAST (first five hits of blast are taken into account)

`Path/To/File/Classify_Uniq.sh`
*Specify the correct path to Mothur in the script Classify_Uniq.sh.*

**NB :** Database and corresponding path could be modify in the script. Default setting : Silva_128_NR99.pds.fasta and Silva_128_NR99.pds.tax (not included).


## STEP 7 : Data formatting
[In RUNX/SequencedFragment]

We have to choose a taxonomical level in the script (line 52). (Default : Level 3, *e.g. : Bacteria;Proteobacteria;Deltaproteobacteria*

`Path/To/File/Formatage_Resultats_Classification_Uniq.sh`
*This script includes an R script "TranspositionTable.R". You have to set the correct path to this script in the script Formatage_Resultats_Classification_Uniq.sh.*

