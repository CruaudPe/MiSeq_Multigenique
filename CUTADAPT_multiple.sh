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
echo -e "Nom du fragment sequence : $FragmentName"  > $FragmentName/Resultats_Script_TrimPrCutadapt.txt 



echo -e "\n###############################################\nDebutAnalyse\n###############################################" >> $FragmentName/Resultats_Script_TrimPrCutadapt.txt

echo -e "\n###############################################\nDebutAnalyse\n###############################################"

echo -e "Tri en fonction des primers specifiques"

JourAnalyse=$(date +%d/%m/%Y)
echo -e "Date de l'analyse : $JourAnalyse"
HeureDebut=$(date +%Hh%M)

echo -e "Heure du debut de l'analyse : $HeureDebut"
echo -e "Heure du debut de l'analyse : $HeureDebut" >> $FragmentName/Resultats_Script_TrimPrCutadapt.txt 

mkdir $FragmentName/Fastq_MergeFlash2_TrimPrCutadapt

echo -e "\nVoici les fichiers traites : \n"

Forward=$(sed -n '/Forward/p' $FragmentName/Caracteristiques_Amplicons.txt | sed s/'Forward '/''/g)
Reverse=$(sed -n '/Reverse/p' $FragmentName/Caracteristiques_Amplicons.txt | sed s/'Reverse '/''/g | rev | tr ACGTRYKMSWBDHVN TGCAYRMKSWVHDBN)
#Reverse=$(sed -n '/Reverse/p' $FragmentName/Caracteristiques_Amplicons.txt | sed s/'Reverse '/''/g | rev | tr ACGTRYKMSWBDHVN TGCANNNNNNNNNNN)

for fichier in $(find Fastq_Flash2Merge/ -name "*.fastq.extendedFrags.fastq" -type f)
			do
						echo -e "	$fichier" 
						echo -e "Sample:::$fichier" >> $FragmentName/Resultats_Script_TrimPrCutadapt.txt 
						NvNom=$(sed s:'Fastq_Flash2Merge/':'':g <<< $fichier)
						Output=$(sed s/".fastq.extendedFrags.fastq"/"_TrimForward.fastq"/g <<< $NvNom)
						(cutadapt -g $Forward -e 0.15 --discard-untrimmed $fichier > $FragmentName/Fastq_MergeFlash2_TrimPrCutadapt/$Output) 2>> $FragmentName/Resultats_Script_TrimPrCutadapt.txt
			done
			
echo -e "\n\n"

for fichier in $(find $FragmentName/Fastq_MergeFlash2_TrimPrCutadapt/ -name "*_TrimForward.fastq" -type f)
			do
						echo -e "	$fichier"
                                                echo -e "Sample:::$fichier" >> $FragmentName/Resultats_Script_TrimPrCutadapt.txt 
						NvNom=$(sed s/"$FragmentName\/Fastq_MergeFlash2_TrimPrCutadapt\/"/""/g <<< $fichier)
						Output=$(sed s/"_TrimForward.fastq"/"_Trim_Filt200.fastq"/g <<< $NvNom)
						(cutadapt -b $Reverse -e 0.15 -m 400 --discard-untrimmed $fichier > $FragmentName/Fastq_MergeFlash2_TrimPrCutadapt/$Output) 2>> $FragmentName/Resultats_Script_TrimPrCutadapt.txt
			done
			
echo -e "\n\n"

echo -e "Heure du debut de l'analyse : $HeureDebut"
HeureFin=$(date +%Hh%M)
echo -e "Heure de fin de l'analyse : $HeureFin"

echo -e "Heure du debut de l'analyse : $HeureDebut" >> $FragmentName/Resultats_Script_TrimPrCutadapt.txt
echo -e "Heure de fin de l'analyse : $HeureFin" >> $FragmentName/Resultats_Script_TrimPrCutadapt.txt



echo -e "\n###############################################\nFinAnalyse\n###############################################" >> $FragmentName/Resultats_Script_TrimPrCutadapt.txt
echo -e "\n###############################################\nFinAnalyse\n###############################################"

exit
