#! /bin/bash

#Nom du programme : ConvertFastqFasta.sh
#Date de création : 12 avril 2017
#Derniere mise a jour : 31 aout 2017
#Auteur : Perrine Cruaud
#But du programme : Convertir fichiers fastq en fichiers fasta


echo -e "\n###############################################\nDebutAnalyse\n###############################################"

JourAnalyse=$(date +%d/%m/%Y)
echo -e "Date de l'analyse : $JourAnalyse"
HeureDebut=$(date +%Hh%M)
echo -e "Heure du debut de l'analyse : $HeureDebut"


###############################
echo -e "\nVoici les fichiers traites : \n"

for fichier in $(find Fastq_MergeFlash2_TrimPrCutadapt/ -name "*_Trim_Filt200.fastq" -type f)
			do
						echo -e "	$fichier"
						#Convert Fastq to Fasta
						Output=$(sed s/"_Trim_Filt200.fastq"/"_Trim_Filt200.fasta"/g <<< $fichier)
						vsearch --fastq_filter $fichier --fastaout $Output
						
                        done
                        
                        
                        
echo -e "\n"


echo -e "SampleName" > SampleName.temp
echo -e "NumberOfSequences" > NumberOfSequences.temp

for fichier in $(find Fastq_MergeFlash2_TrimPrCutadapt/ -name "*_Trim_Filt200.fasta" -type f);
			do
						NvNom=$(sed "s/Fastq_MergeFlash2_TrimPrCutadapt\///g" <<< $fichier)
						OutputPrefix=$(sed "s/_Trim_Filt200\.fasta//g" <<< $NvNom)
						echo -e "$OutputPrefix" >> SampleName.temp
						grep -o "^>" $fichier | wc -l >> NumberOfSequences.temp
			done
			
paste SampleName.temp NumberOfSequences.temp >  Suivi_Analyse/Suivi_ScriptConvertFasqFasta.txt

rm *.temp


echo -e "Heure du debut de l'analyse : $HeureDebut"
HeureFin=$(date +%Hh%M)
echo -e "Heure de fin de l'analyse : $HeureFin"

echo -e "\n###############################################\nFinAnalyse\n###############################################"

exit			

