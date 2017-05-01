# MiSeq_Multigenique
Traitement des donnees brutes amplicons Illumina MiSeq

## Reception des donnees

Les fichiers de resultats ".fastq.gz" se trouvent dans le repertoire Data/Intensities/BaseCalls/
Premiere chose a faire : Creer un dossier qui va contenir toutes les analyses pour ce run :

`mkdir RUNX`

Puis creer un sous-dossier Fastq_Initiaux qui va contenir les fichiers fastq bruts

`mkdir RUNX/Fastq_Initiaux`

Copier tous les fichiers .fastq.gz dans ce sous-dossier et decompresser

`gunzip Fastq_Initiaux/*`


**NB :** Apres sequencage, on obtient 2 fichiers par echantillonm un fichier contenant les reads 1 (R1) et un fichier contentant les reads 2 (R2). Les fichier sont nommes avec le nom de l'echantillon et l'identifiant de l'echantillon comme indiques dans la Sample sheet. Le numero de la lane est toujours L001 pour le MiSeq.
> SampleName_SampleID_LaneNumber_ReadNumer_001.fastq (ex : JRAS03221-0182_S183_L001_R1_001.fastq)

Les echantillons sont numerotes a partir de 1. Les reads qui n'ont pas pu etre assignes a un echantillon se retrouvent dans des fichiers fastq numerotes 0
> Undetermined_S0_L001_R1_001.fastq

On va supprimer les fichiers S0 du dossier Fastq_Initiaux/ car on ne s'en servira plus pour la suite des analyses
`rm Undetermined_S0*` dans le dossier Fastq_Initiaux/


## ETAPE 1 : Controle qualite
[Travail dans RUNX]

Dans un premier temps, on va regarder les resultats obtenus a l'issue du RUN
`mkdir Bilan_Global`

`cat Fastq_Initiaux/* > Bilan_Global/Global.fastq`

`cat Fastq_Initiaux/*L001_R1_001.fastq > Bilan_Global/Global_Reads1.fastq`

`cat Fastq_Initiaux/*L001_R2_001.fastq > Bilan_Global/Global_Reads2.fastq`

[Travail dans RUN1_UTE_IBIS/Bilan_Global]

`fastqc --extract Global.fastq`

`fastqc --extract Global_Reads1.fastq`

`fastqc --extract Global_Reads2.fastq`

*ou en rajoutant le chemin pour aller chercher fastqc sur l'ordinateur*

Generation du fichier Summary du RUN

`Chemin/du/Script/Summary_RunQuality.sh`
*avec le bon chemin pour aller chercher le script*
