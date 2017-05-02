#! /bin/bash

#Nom du programme : Formatage_Resultats_Classification_Uniq.sh
#Date de création : 18 novembre 2015
#Derniere mise a jour : 1er mai 2017
#Auteur : Perrine Cruaud
#But du programme : Formater les résultats issus de Classify.seqs de Mothur pour qu'ils soient lisibles pour tous les échantillons en meme temps. Il faut choisir le niveau taxonomique voulu a la ligne 52 du script


echo -e "\n###############################################\nDebutAnalyse\n###############################################"

JourAnalyse=$(date +%d/%m/%Y)
echo -e "Date de l'analyse : $JourAnalyse"
HeureDebut=$(date +%Hh%M)
echo -e "Heure du debut de l'analyse : $HeureDebut"


###############################

echo -e "\n\nNom du fichier de classification (.taxonomy) : "
read FichierTax
echo -e "Nom du fichier taxonomie: $FichierTax"

echo -e "\n\nNom du fichier bilan nbre sequences (_Glob_SsSingletons_FiltChim.txt) : "
read FichierSeq
echo -e "Nom du fichier taxonomie: $FichierSeq"

echo -e "\n\nNom du fichier resultats (ex : Resultats_UClust_Taxonomie_Silva128_Level7_Blast.txt) : "
read FichierOut
echo -e "Nom du fichier taxonomie: $FichierOut"

#Mise en forme du fichier taxonomie
cp $FichierTax Taxo.temp
sed -i -e "s/;size=\([0-9][0-9]*\);//g" Taxo.temp
sed -i -e "s/(...)//g" Taxo.temp
sed -i -e "s/(..)//g" Taxo.temp
sed -i -e "s/(.)//g" Taxo.temp

#Mise en forme bilan nbre de sequences par echantillon (transposition de la table)
cp $FichierSeq TableATransposer.csv
R --slave -e 'source("/home/pcruaud/Programmes/Scripts_perso/TranspositionTable.R")'
sed -i -e '1d' TaxoTransposee.csv
sed -i -e "s/\"//g" TaxoTransposee.csv
sed -i -e "s/\s//g" TaxoTransposee.csv
sed -i -e "s/;/\t/g" TaxoTransposee.csv
sed -n '/^SAMPLE/p' TaxoTransposee.csv > EnTetes_Ech.temp

#Recuperation par correspondance des donnees de taxonomie
awk -F'\t' 'FNR==NR{a[$1]=$2;next} $1 in a{print a[$1],$0}' Taxo.temp TaxoTransposee.csv > Resultats_Taxo.temp
awk '{$2="";print $0}' Resultats_Taxo.temp > Resultats_Taxo2.temp

awk -F';' '{print $1 ";" $2 ";" $3 "\t" $NF}' Resultats_Taxo2.temp > Taxo_NiveauTaxo3.temp
sed -i -e "s/\t/ /g" Taxo_NiveauTaxo3.temp

awk -F' ' '{print $1}' Taxo_NiveauTaxo3.temp > Test2.temp

NbreColonnes=$(awk -F' ' 'END {print NF}' Taxo_NiveauTaxo3.temp)

awk '{print $2}' Taxo_NiveauTaxo3.temp > Test.temp
paste Test2.temp Test.temp > Test3.temp
awk -F'\t' '{arr[$1]+=$2}END{for (i in arr) {print i, arr[i]}}' Test3.temp > Test6.temp


for numero in `seq 3 $NbreColonnes`
    do
    #echo -e $numero
    awk '{print $'$numero'}' Taxo_NiveauTaxo3.temp > Test.temp
    paste Test2.temp Test.temp > Test3.temp
    awk '{arr[$1]+=$2}END{for (i in arr) {print i, arr[i]}}' Test3.temp > Test4.temp
    awk -F' ' '{print $2}' Test4.temp > Test5.temp
    paste Test6.temp Test5.temp > Test7.temp
    mv Test7.temp Test6.temp
    done

cat EnTetes_Ech.temp Test6.temp > $FichierOut

rm *.temp

echo -e "\n\n"

echo -e "\n###############################################\nFinAnalyse\n###############################################"

exit			
			

