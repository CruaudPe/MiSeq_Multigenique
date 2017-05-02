#! /bin/bash

#Nom du programme : Dereplication.sh
#Date de création : 12 avril 2017
#Derniere mise a jour : 1er mai 2017
#Auteur : Perrine Cruaud
#But du programme : Dereplication Vsearch pour un fichier fasta avec en entree AllSamples.fasta et en sortie un fichier fasta des sequences centroides (AllSamples_Dereplic.fasta), un fichier type sortie uclust avec toutes les sequences
#query et la sequence centroide a laquelle elles sont associees (AllSamples_Resultats_Dereplic_UC.txt), et un tableau TableauLong_Resultats_Dereplic.csv indiquant le nombre de sequences associees a chaque centroide pour chaque echantillon

echo -e "\n###############################################\nDebutAnalyse\n###############################################" >  ResultatsSuivi_Dereplication.txt
echo -e "\n###############################################\nDebutAnalyse\n###############################################"

JourAnalyse=$(date +%d/%m/%Y)
echo -e "Date de l'analyse : $JourAnalyse"
HeureDebut=$(date +%Hh%M)

#Dereplication
Output=$(sed s/".fasta"/"_Dereplic.fasta"/g <<< AllSamples.fasta)
OutputUC=$(sed s/".fasta"/"_Resultats_Dereplic_UC.txt"/g <<< AllSamples.fasta)
(vsearch --derep_fulllength AllSamples.fasta --sizeout --output $Output --uc $OutputUC) 2>> ResultatsSuivi_Dereplication.txt

echo -e "\n"


echo -e "Heure du debut de l'analyse : $HeureDebut"
HeureFinDerep=$(date +%Hh%M)
echo -e "Heure de fin de l'etape de dereplication : $HeureFinDerep"



cp AllSamples_Resultats_Dereplic_UC.txt AllSamples_Resultats_Dereplic.temp
sed -i -e '/^C/d' AllSamples_Resultats_Dereplic.temp
#Recuperation colonne 10 "Label of Centroid sequence" (ou "*" si query sequence = centroid sequence) et colonne 9 "Label of query sequence"
awk -F'\t' '{print $10 "\t" $9}' AllSamples_Resultats_Dereplic.temp > NvFormat.temp
#CentroidsName.temp liste les noms de toutes les sequences centroides
sed -n '/*/p' NvFormat.temp > CentroidsName.temp
sed -i -e "s/^\*\t//g" CentroidsName.temp

#Preparation d'un tableau format long indiquant combien de fois on trouve chaque sequence centroide dans chaque echantillon
awk -F'__' '{print $1 "__" $2 "\t" $1 "__" $2}' CentroidsName.temp > CentroidsSeuls.temp
cp NvFormat.temp HitCentroids.temp
sed -i -e '/\*/d' HitCentroids.temp
cat HitCentroids.temp CentroidsSeuls.temp > TableauLong.temp
sed -i -e "s/__/@/" TableauLong.temp
sed -i -e "s/__.*$//" TableauLong.temp
sed -i -e "s/\t/__/g" TableauLong.temp
awk '{arr[$1]+=1}END{for(i in arr){print i,arr[i]}}' TableauLong.temp > TableauLong2.temp
sort -n -r -k 2,2 TableauLong2.temp > TableauLong3.temp
cp TableauLong3.temp TableauLong_Resultats_Dereplic.csv


rm *.temp

echo -e "Heure du debut de l'analyse : $HeureDebut"
echo -e "Heure du debut de l'analyse : $HeureDebut" >>  ResultatsSuivi_Dereplication.txt
HeureFin=$(date +%Hh%M)
echo -e "Heure de fin de l'analyse : $HeureFin"
echo -e "Heure de fin de l'analyse : $HeureFin"  >>  ResultatsSuivi_Dereplication.txt

echo -e "\n###############################################\nFinAnalyse\n###############################################"
echo -e "\n###############################################\nFinAnalyse\n###############################################" >>  ResultatsSuivi_Dereplication.txt


exit			


