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


## ETAPE 2 : Merge reads 1 et reads 2
[Travail dans RUNX]

Merge des reads avec Flash2 sur un ensemble  de fichiers contenus dans Fastq_Initiaux/
Resultats dans Fastq_Flash2Merge/

`Chemin/du/Script/FLASH2_multiple.sh`

*modifier le chemin d'acces a flash2 dans le script FLASH2_multiple.sh*


## ETAPE 3 : Tri en fonction des primers
[Travail dans RUNX]

Pour chaque fragment sequence, creer un dossier dans RUNX portant le nom du fragment correspondant (par ex "Bact_V3V4") et, dans ce dossier cree, un fichier texte Caracteristiques_Amplicons.txt qui indique les séquences des amorces forward et reverse (cf fichier Caracteristiques_Amplicons.txt fourni ici pour exemple). Pour chacun des fragments, lancer le script CUTADAPT_multiple.sh en indiquant le nom du dossier correspondant.

`Chemin/du/Script/CUTADAPT_multiple.sh`

*si besoin, modifier les parametres erreur -e et longueur minimum -m dans le script pour adapter au fragment etudie*

## ETAPE 4 : Clusterisation en OTUs et en Swarm
[Travail dans RUNX/FragmentSequence]

*Si plusieurs analyses differentes dans le meme run, on peut creer un sous dossier pour chaque analyse et reunir les fichiers fastq correpondants (*_Trim_Filt200.fastq) dans un sous-dossier qu'on renommera Fastq_MergeFlash2_TrimPrCutadapt/*

Dans le dossier RUNX ou le sous-dossier correspondant a une etude particuliere (ex : TestProtocole/), lancer le script ConvertFastqFasta.sh pour convertir les fichiers fastq en fichiers ConvertFastqFasta

`Chemin/du/Script/ConvertFastqFasta.sh`

L'etape suivante consiste a pooler toutes les sequences fasta en un seul fichier fasta AllSamples.fasta

`Chemin/du/Script/PoolageEchantillons.sh`

Avant de clusteriser en OTUs et/ou en Swarms, on passe par une etape de dereplication du jeu de donnees (avec Vsearch)

`Chemin/du/Script/Dereplication.sh`

Clusterisation en OTUs avec un seuil de 97% avec vsearch

`Chemin/du/Script/ClusterisationVSEARCH.sh`

et/ou clusterisation en SWARMs avec swarm

`Chemin/du/Script/ClusterisationSWARM.sh`




## ETAPE 5 : Elimination des singletons et des chimeres du jeu de donnees
[Travail dans RUNX/FragmentSequence] *ou [Travail dans RUNX/FragmentSequence/EtudeParticuliere]*

Elimination des singletons et des chimeres avec Vsearch pour les clusterisations OTUs et Swarms

`Chemin/du/Script/VSEARCH_ChimereSingleton_Uniq.sh`

*Ce script integre un script R "FormatLongAFormatLarge.R" dont il faut modifier le chemin d'acces*


## ETAPE 6 : Affiliation taxonomique des sequences
[Travail dans RUNX/FragmentSequence] *ou [Travail dans RUNX/FragmentSequence/EtudeParticuliere]*

Classification avec commande classify.seqs de Mothur
Pour chacune des clusterisation (OTUs et Swarms) affiliation des sequences avec : 

- Classification Naive Bayesienne, type RDP Classifier
- Classification par Blast (5 premiers hits de blast pris en compte)

`Chemin/du/Script/Classify_Uniq.sh`

**NB :** La base de donnees ainsi que son chemin peuvent etre modifies dans le script. Par default, Silva_128_NR99.pds.fasta et Silva_128_NR99.pds.tax.

*modifier aussi le chemin d'acces a mothur dans le script Classify_Uniq.sh*



## ETAPE 7 : Formatage des donnees de classification
[Travail dans RUNX/FragmentSequence] *ou [Travail dans RUNX/FragmentSequence/EtudeParticuliere]*

Formatage des donnees issues de l'etape de classification pour qu'elles soient facilement lisibles sous excel
Il faut modifier le niveau taxonomique voulu directement dans le script a la ligne 52 (par default niveau taxonomique 3 *ex: Bacteria;Proteobacteria;Deltaproteobacteria*

`Chemin/du/Script/Formatage_Resultats_Classification_Uniq.sh`

*Ce script integre un script R "TranspositionTable.R" dont il faut modifier le chemin d'acces*


