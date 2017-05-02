#! /bin/bash

#Nom du programme : ClusterisationSWARM.sh
#Date de création : 13 avril 2017
#Derniere mise a jour : 1er mai 2017
#Auteur : Perrine Cruaud
#But du programme : Clusterisation en Swarms pour le fichier fasta AllSamples_Dereplic.fasta

echo -e "\n###############################################\nDebutAnalyse\n###############################################" >  ResultatsSuivi_SWARMs.txt
echo -e "\n###############################################\nDebutAnalyse\n###############################################"

JourAnalyse=$(date +%d/%m/%Y)
echo -e "Date de l'analyse : $JourAnalyse"
HeureDebut=$(date +%Hh%M)
echo -e "Heure du debut de l'analyse : $HeureDebut"

#Clusterisation SWARM
    OutputOTU=$(sed s/"_Dereplic.fasta"/"_OTURepresent.fasta"/g <<< AllSamples_Dereplic.fasta)
    OutputUC=$(sed s/".fasta"/"_Resultats_ClustersSWARMs.txt"/g <<< AllSamples_Dereplic.fasta)
    (swarm -u $OutputUC -w $OutputOTU -z AllSamples_Dereplic.fasta) 2>> ResultatsSuivi_SWARMs.txt
        
echo -e "\n"


echo -e "Heure du debut de l'analyse : $HeureDebut"
HeureFinCluster=$(date +%Hh%M)
echo -e "Heure de fin de l'etape de clusterisation : $HeureFinCluster"

#Recuperation du nom des sequences centroides pour chaque Swarm
cp AllSamples_Dereplic_Resultats_ClustersSWARMs.txt AllSamples_Dereplic_Resultats_ClustersSWARMs.temp
sed -i -e '/^C/d' AllSamples_Dereplic_Resultats_ClustersSWARMs.temp
#Recuperation colonne 10 "Label of Centroid sequence" (ou "*" si query sequence = centroid sequence) et colonne 9 "Label of query sequence"
awk -F'\t' '{print $10 "\t" $9}' AllSamples_Dereplic_Resultats_ClustersSWARMs.temp > NvFormat.temp
sed -i -e "s/;size=\([0-9][0-9]*\);//g" NvFormat.temp
#CentroidsName.temp liste les noms de toutes les sequences centroides
sed -n '/*/p' NvFormat.temp > CentroidsName.temp
sed -i -e "s/^\*\t//g" CentroidsName.temp

#Preparation d'un tableau format long indiquant combien de fois on trouve chaque sequence centroide dans chaque echantillon
awk -F'__' '{print $1 "__" $2 "\t" $1 "__" $2}' CentroidsName.temp > CentroidsSeuls.temp
cp NvFormat.temp HitCentroids.temp
sed -i -e '/\*/d' HitCentroids.temp
cat HitCentroids.temp CentroidsSeuls.temp > TableauLong.temp
awk -F'\t' '{print $2 "\t" $1}' TableauLong.temp > AncienCentroid_NvCentroid.temp
sed -i -e "s/__/@/g" AncienCentroid_NvCentroid.temp

#Recuperation des donnees de dereplication et remplacement par les nouveaux centroids OTUs
cp TableauLong_Resultats_Dereplic.csv Donnees_Dereplic_AncienCentroids.temp
sed -i -e "s/ /\t/g" Donnees_Dereplic_AncienCentroids.temp
sed -i -e "s/__/\t__/g" Donnees_Dereplic_AncienCentroids.temp
awk -F'\t' 'FNR==NR{a[$1]=$2;next} $1 in a{print a[$1],$2,$3}' AncienCentroid_NvCentroid.temp Donnees_Dereplic_AncienCentroids.temp > Donnees_NvCentroids.temp
sed -i -e "s/ __/__/g" Donnees_NvCentroids.temp
awk -F' ' '{arr[$1]+=$2}END{for(i in arr){print i,arr[i]}}' Donnees_NvCentroids.temp > Bilan_Derepli_SWARMs.temp
sort -n -r -k 2,2 Bilan_Derepli_SWARMs.temp > Bilan_Derepli_SWARMs_Sort.temp
cp Bilan_Derepli_SWARMs_Sort.temp TableauLong_Resultats_SWARMs.csv

rm *.temp


echo -e "Heure du debut de l'analyse : $HeureDebut"
echo -e "Heure du debut de l'analyse : $HeureDebut" >>  ResultatsSuivi_SWARMs.txt
HeureFin=$(date +%Hh%M)
echo -e "Heure de fin de l'analyse : $HeureFin"
echo -e "Heure de fin de l'analyse : $HeureFin"  >>  ResultatsSuivi_SWARMs.txt

echo -e "\n###############################################\nFinAnalyse\n###############################################"
echo -e "\n###############################################\nFinAnalyse\n###############################################" >>  ResultatsSuivi_SWARMs.txt


exit	
            
            

