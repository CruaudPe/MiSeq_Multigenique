#! /bin/bash

#Nom du programme : PoolageEchantillons.sh
#Date de création : 12 avril 2017
#Derniere mise a jour : 12 avril 2017
#Auteur : Perrine Cruaud
#But du programme : Pooler les echantillons avant clusterisation


echo -e "\n###############################################\nDebutAnalyse\n###############################################"

JourAnalyse=$(date +%d/%m/%Y)
echo -e "Date de l'analyse : $JourAnalyse"
HeureDebut=$(date +%Hh%M)
echo -e "Heure du debut de l'analyse : $HeureDebut"


###############################
echo -e "\nVoici les fichiers traites : \n"

for fichier in $(find Fastq_MergeFlash2_TrimPrCutadapt/ -name "*_Trim_Filt200.fasta" -type f)
			do
						echo -e "	$fichier"
						#Commence par inserer le nom de l'echantillon dans les en-tetes des sequences fasta
						NvNom=$(sed s:'Fastq_MergeFlash2_TrimPrCutadapt/':'':g <<< $fichier)
						NomEch=$(sed s:'_Trim_Filt200.fasta':'':g <<< $NvNom)
						sed -i -e "s/^>/>$NomEch __/g" $fichier
			done
#Concatenation de tous les fichiers fasta pour tous les echantillons
find Fastq_MergeFlash2_TrimPrCutadapt/ -name "*_Trim_Filt200.fasta" -exec cat {} > AllSamples.fasta \;
	sed -i -e "s/ //g" AllSamples.fasta
	sed -i -e "s/:/_/g" AllSamples.fasta
	sed -i -e "s/-/_/g" AllSamples.fasta
                        
                        
                        
echo -e "\n"


echo -e "Heure du debut de l'analyse : $HeureDebut"
HeureFin=$(date +%Hh%M)
echo -e "Heure de fin de l'analyse : $HeureFin"

echo -e "\n###############################################\nFinAnalyse\n###############################################"

exit			


