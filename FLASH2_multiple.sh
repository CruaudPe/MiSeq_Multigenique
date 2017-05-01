#! /bin/bash

#Nom du programme : FLASH2_multiple.sh
#Date de création : 27 janvier 2017
#Derniere Mise a jour : 1er mai 2017
#Auteur : Perrine Cruaud
#But du programme : Lancer FLASH sur un ensemble de fichiers (contenu dans Fastq_Initiaux) avec paramètres par défault et max overlap à 300 bp

echo -e "\n###############################################\nDebutAnalyse\n###############################################" > Resultats_ScriptFlash2.txt
echo -e "\n###############################################\nDebutAnalyse\n###############################################"

mkdir Fastq_Flash2Merge

echo -e "Merge reads1 et reads2 avec Flash2"

JourAnalyse=$(date +%d/%m/%Y)
echo -e "Date de l'analyse : $JourAnalyse"
HeureDebut=$(date +%Hh%M)
HeureHDebut=$(date +%H)
MinuteDebut=$(date +%M)
SecondeDebut=$(date +%S)
echo -e "Heure du debut de l'analyse : $HeureDebut"

echo -e "\nVoici les fichiers traites : \n"

for fichier in $(find Fastq_Initiaux/ -name "*_L001_R1_001.fastq" -type f)
			do
						echo -e "	$fichier" >> Resultats_ScriptFlash2.txt
						echo -e "       $fichier"
						Reads2=$(sed s/"L001_R1_001"/"L001_R2_001"/g <<< $fichier)
						NvNom=$(sed s:'Fastq_Initiaux/':'':g <<< $fichier)
						OutputPrefix=$(sed s/"_L001_R1_001"/""/g <<< $NvNom)
						/home/pcruaud/Programmes/FLASH2-master/flash2 -M 350 -o $OutputPrefix -d Fastq_Flash2Merge/ $fichier $Reads2 >> Resultats_ScriptFlash2.txt
			done
			
echo -e "\n"

HeureFin=$(date +%Hh%M)
echo -e "Heure de fin de l'analyse : $HeureFin"
HeureHFin=$(date +%H)
MinuteFin=$(date +%M)
SecondeFin=$(date +%S)

echo -e "\nTemps de l'analyse : $MinutesMises minute(s)"

echo -e "\n"

echo -e "\n###############################################\nFinAnalyse\n###############################################" >> Resultats_ScriptFlash2.txt
echo -e "\n###############################################\nFinAnalyse\n###############################################"

exit