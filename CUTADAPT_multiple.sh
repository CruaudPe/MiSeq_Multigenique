#! /bin/bash

#Nom du programme : CUTADAPT_multiple.sh
#Date de création : 10 novembre 2015
#Derniere mise a jour : 1er mai 2017
#Auteur : Perrine Cruaud
#But du programme : Lancer Cutadapt sur un ensemble de fichiers contenu dans Fastq_Flash2Merge/ avec paramètres par défault : 
#1ère étape enlever amorce forward, 2ème étape enlever amorce reverse et séquences de moins de 350 bp. Besoin d'un fichier Caracteristiques_Amplicons.txt
#qui indique les séquences des amorces forward et reverse contenu dans un nouveau dossier au nom du gene sur lequel on travaille (ex Bacteries_V4).
#Rester dans le dossier du RUN global pour lancer ce script. Les fichiers resultats seront dans le dossier specifique du gene analyse dans un sous-dossier $FragmentName/Fastq_MergeFlash2_TrimPrCutadapt

echo -e "Nom du fragment sequence (doit correspondre au dossier contenant le fichier Caracteristiques_Amplicons.txt)"
read FragmentName
mkdir $FragmentName/Suivi_Analyse
echo -e "Nom du fragment sequence : $FragmentName"  > $FragmentName/Suivi_Analyse/Resultats_Script_TrimPrCutadapt.txt 



echo -e "\n###############################################\nDebutAnalyse\n###############################################" >> $FragmentName/Suivi_Analyse/Resultats_Script_TrimPrCutadapt.txt

echo -e "\n###############################################\nDebutAnalyse\n###############################################"

echo -e "Tri en fonction des primers specifiques"

JourAnalyse=$(date +%d/%m/%Y)
echo -e "Date de l'analyse : $JourAnalyse"
echo -e "Date de l'analyse : $JourAnalyse" >> $FragmentName/Suivi_Analyse/Resultats_Script_TrimPrCutadapt.txt 

HeureDebut=$(date +%Hh%M)
echo -e "Heure du debut de l'analyse : $HeureDebut"
echo -e "Heure du debut de l'analyse : $HeureDebut" >> $FragmentName/Suivi_Analyse/Resultats_Script_TrimPrCutadapt.txt 

mkdir $FragmentName/Fastq_MergeFlash2_TrimPrCutadapt

echo -e "\nVoici les fichiers traites : \n"

Forward=$(sed -n '/Forward/p' $FragmentName/Caracteristiques_Amplicons.txt | sed s/'Forward '/''/g)
Reverse=$(sed -n '/Reverse/p' $FragmentName/Caracteristiques_Amplicons.txt | sed s/'Reverse '/''/g | rev | tr ACGTRYKMSWBDHVN TGCAYRMKSWVHDBN)

for fichier in $(find Fastq_Flash2Merge/ -name "*.extendedFrags.fastq" -type f)
			do
						echo -e "	$fichier" 
						echo -e "Sample:::$fichier" >> $FragmentName/Suivi_Analyse/Resultats_Script_TrimPrCutadapt.txt 
						NvNom=$(sed s:'Fastq_Flash2Merge/':'':g <<< $fichier)
						Output=$(sed s/".extendedFrags.fastq"/"_TrimForward.fastq"/g <<< $NvNom)
						(cutadapt -g $Forward -e 0.1 --discard-untrimmed $fichier > $FragmentName/Fastq_MergeFlash2_TrimPrCutadapt/$Output) 2>> $FragmentName/Suivi_Analyse/Resultats_Script_TrimPrCutadapt.txt
			done
			
echo -e "\n\n"

for fichier in $(find $FragmentName/Fastq_MergeFlash2_TrimPrCutadapt/ -name "*_TrimForward.fastq" -type f)
			do
						echo -e "	$fichier"
                                                echo -e "Sample:::$fichier" >> $FragmentName/Suivi_Analyse/Resultats_Script_TrimPrCutadapt.txt 
						NvNom=$(sed s/"$FragmentName\/Fastq_MergeFlash2_TrimPrCutadapt\/"/""/g <<< $fichier)
						Output=$(sed s/"_TrimForward.fastq"/"_Trim_Filt200.fastq"/g <<< $NvNom)
						(cutadapt -b $Reverse -e 0.2 -m 350 --discard-untrimmed $fichier > $FragmentName/Fastq_MergeFlash2_TrimPrCutadapt/$Output) 2>> $FragmentName/Suivi_Analyse/Resultats_Script_TrimPrCutadapt.txt
			done
			
echo -e "\n\n"

sed -n '/Sample\:\:\:/p' $FragmentName/Suivi_Analyse/Resultats_Script_TrimPrCutadapt.txt > SampleName.temp
sed -i -e "s/Sample\:\:\://g" SampleName.temp
sed -i -e "s/\.extendedFrags\.fastq/_Forward/g" SampleName.temp
sed -i -e "s/_TrimForward\.fastq/_Reverse/g" SampleName.temp
sed -i -e "s/Fastq_Flash2Merge\///g" SampleName.temp
sed -i -e "s/$FragmentName\/Fastq_MergeFlash2_TrimPrCutadapt\///g" SampleName.temp
sed -i -e "1iSample_Name" SampleName.temp

sed -n '/Reads written (passing filters)\:/p' $FragmentName/Suivi_Analyse/Resultats_Script_TrimPrCutadapt.txt > Sequences_Flash2.temp
sed -i -e "s/Reads written (passing filters)\://g" Sequences_Flash2.temp
sed -i -e "s/ (.*$//g" Sequences_Flash2.temp
sed -i -e "s/ //g" Sequences_Flash2.temp
sed -i -e "1iSequences_Cutadapt" Sequences_Flash2.temp
paste SampleName.temp Sequences_Flash2.temp > $FragmentName/Suivi_Analyse/Suivi_Script_TrimPrCutadapt.txt
        
rm *.temp



echo -e "Heure du debut de l'analyse : $HeureDebut"
HeureFin=$(date +%Hh%M)
echo -e "Heure de fin de l'analyse : $HeureFin"

echo -e "Heure du debut de l'analyse : $HeureDebut" >> $FragmentName/Suivi_Analyse/Resultats_Script_TrimPrCutadapt.txt
echo -e "Heure de fin de l'analyse : $HeureFin" >> $FragmentName/Suivi_Analyse/Resultats_Script_TrimPrCutadapt.txt



echo -e "\n###############################################\nFinAnalyse\n###############################################" >> $FragmentName/Suivi_Analyse/Resultats_Script_TrimPrCutadapt.txt
echo -e "\n###############################################\nFinAnalyse\n###############################################"

exit
