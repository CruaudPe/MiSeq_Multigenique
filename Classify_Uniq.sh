#! /bin/bash

#Nom du programme : Classify_Uniq.sh
#Date de création : 13 novembre 2015
#Derniere mise a jour : 1er mai 2017
#Auteur : Perrine Cruaud
#But du programme : Lancer classify.seqs de Mothur sur un fichier contenant tous les clusters filtres pour tous les echantillons avec banque Silva release 128 et cutoff à 80


echo -e "\n###############################################\nDebutAnalyse\n###############################################" 

JourAnalyse=$(date +%d/%m/%Y)
echo -e "Date de l'analyse : $JourAnalyse"
HeureDebut=$(date +%Hh%M)
echo -e "Heure du debut de l'analyse : $HeureDebut"


###############################
echo -e "\nAnalyse pour Flash2-OTUs-Classifier"

#Classification Mothur sur Silva128 NR99 avec equivalent RDP Classifier
	/home/pcruaud/Programmes/mothur/mothur "#classify.seqs(fasta=AllSamples_CentroidsVsearch_SsSingletons_FiltChim.fasta, template=/home/pcruaud/Documents/BaseDeDonnees/Silva_release128/Silva_128_NR99.pds.fasta, taxonomy=/home/pcruaud/Documents/BaseDeDonnees/Silva_release128/Silva_128_NR99.pds.tax, cutoff=80, processors=4)"
		

#########################
echo -e "\nAnalyse pour Flash2-OTUs-Blastn"
	
#Classification Mothur sur Silva128 NR99 avec blast
	/home/pcruaud/Programmes/mothur/mothur "#classify.seqs(fasta=AllSamples_CentroidsVsearch_SsSingletons_FiltChim.fasta, template=/home/pcruaud/Documents/BaseDeDonnees/Silva_release128/Silva_128_NR99.pds.fasta, taxonomy=/home/pcruaud/Documents/BaseDeDonnees/Silva_release128/Silva_128_NR99.pds.tax, method=knn, numwanted=5, search=blast, processors=4)"
	
	
###############################
echo -e "\nAnalyse pour Flash2-SWARM-Classifier"

	
#Classification Mothur sur Silva128 NR99 avec equivalent RDP Classifier
	/home/pcruaud/Programmes/mothur/mothur "#classify.seqs(fasta=AllSamples_OTURepresent_SsSingletons_FiltChim.fasta, template=/home/pcruaud/Documents/BaseDeDonnees/Silva_release128/Silva_128_NR99.pds.fasta, taxonomy=/home/pcruaud/Documents/BaseDeDonnees/Silva_release128/Silva_128_NR99.pds.tax, cutoff=80, processors=4)"

	

#########################
echo -e "\nAnalyse pour Flash2-SWARM-Blastn"

	
#Classification Mothur sur Silva128 NR99 avec Blast
	/home/pcruaud/Programmes/mothur/mothur "#classify.seqs(fasta=AllSamples_OTURepresent_SsSingletons_FiltChim.fasta, template=/home/pcruaud/Documents/BaseDeDonnees/Silva_release128/Silva_128_NR99.pds.fasta, taxonomy=/home/pcruaud/Documents/BaseDeDonnees/Silva_release128/Silva_128_NR99.pds.tax, method=knn, numwanted=5, search=blast, processors=4)"

	

echo -e "\n"

echo -e "Heure du debut de l'analyse : $HeureDebut"
HeureFin=$(date +%Hh%M)
echo -e "Heure de fin de l'analyse : $HeureFin"

echo -e "\n"



echo -e "\n###############################################\nFinAnalyse\n###############################################" 

exit			
	