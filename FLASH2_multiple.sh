#! /bin/bash

#Nom du programme : FLASH2_multiple.sh
#Date de création : 27 janvier 2017
#Derniere Mise a jour : 31 aout 2017
#Auteur : Perrine Cruaud
#But du programme : Lancer FLASH2 sur un ensemble de fichiers (contenu dans Fastq_Initiaux) avec paramètres par défault et max overlap à 300 bp

echo -e "\n###############################################\nDebutAnalyse\n###############################################" > Resultats_ScriptFlash2.txt
echo -e "\n###############################################\nDebutAnalyse\n###############################################"

mkdir Fastq_Flash2Merge

echo -e "SampleName" > SampleName.temp

echo -e "Merge reads1 et reads2 avec Flash2"

JourAnalyse=$(date +%d/%m/%Y)
echo -e "Date de l'analyse : $JourAnalyse"
HeureDebut=$(date +%Hh%M)

echo -e "Heure du debut de l'analyse : $HeureDebut"

echo -e "\nVoici les fichiers traites : \n"

for fichier in $(find Fastq_Initiaux/ -name "*_L001_R1_001.fastq" -type f)
			do
						echo -e "	$fichier" >> Resultats_ScriptFlash2.txt
						echo -e "       $fichier"
						Reads2=$(sed s/"L001_R1_001"/"L001_R2_001"/g <<< $fichier)
						NvNom=$(sed s:'Fastq_Initiaux/':'':g <<< $fichier)
						OutputPrefix=$(sed s/"_L001_R1_001"/""/g <<< $NvNom)
						echo -e "$OutputPrefix" >> SampleName.temp
						/home/pcruaud/Programmes/FLASH2-master/flash2 -M 350 -o $OutputPrefix -d Fastq_Flash2Merge/ $fichier $Reads2 >> Resultats_ScriptFlash2.txt
			done


sed -n '/\[FLASH\]     Combined pairs\:/p' Resultats_ScriptFlash2.txt > Combined_Pairs.temp
sed -i -e "s/\[FLASH\]     Combined pairs\://g" Combined_Pairs.temp
sed -i -e "1iCombined_Pairs_Flash2" Combined_Pairs.temp
paste SampleName.temp Combined_Pairs.temp > Suivi_ScriptFlash2.txt

echo -e "\n"

rm *.temp

HeureFin=$(date +%Hh%M)
echo -e "Heure de fin de l'analyse : $HeureFin"



echo -e "\n"

echo -e "\n###############################################\nFinAnalyse\n###############################################" >> Resultats_ScriptFlash2.txt
echo -e "\n###############################################\nFinAnalyse\n###############################################"

exit