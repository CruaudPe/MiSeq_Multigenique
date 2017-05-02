#! /bin/bash

#Nom du programme : VSEARCH_ChimereSingleton_Uniq.sh
#Date de création : 10 novembre 2015
#Derniere mise a jour : 1er mai 2017
#Auteur : Perrine Cruaud
#But du programme : Lancer VSEARCH sur un fichier fasta (AllSamples_OTURepresent.fasta quand sortie SWARM et AllSamples_CentroidsVsearch.fasta quand sortie VSEARCH) avec paramètres par défault pour retirer les singletons (--derep_fulllength) 
#puis retirer les chimères (--uchime_denovo) puis generation d'un tableau recapitulatif nombre de sequences par OTUs (ou Swarms) par echantillon (Resultats_ClustersOTUsVSEARCH_Glob_SsSingletons_FiltChim.txt pour clusterisation OTUs et 
#Resultats_ClustersSwarms_Glob_SsSingletons_FiltChim.txt pour clusterisation Swarm)

echo -e "\n###############################################\nDebutAnalyse\n###############################################" >  ResultatsSuivi_FiltSingletonsChim.txt
echo -e "\n###############################################\nDebutAnalyse\n###############################################"

JourAnalyse=$(date +%d/%m/%Y)
echo -e "Date de l'analyse : $JourAnalyse"
HeureDebut=$(date +%Hh%M)
echo -e "Heure du debut de l'analyse : $HeureDebut"

echo -e "\n Analyse sur les OTUs... \n"

                #Eliminer les singletons
                (vsearch --derep_fulllength AllSamples_CentroidsVsearch.fasta --minuniquesize 2 --sizein --output AllSamples_CentroidsVsearch_SsSingletons.fasta) 2>> ResultatsSuivi_FiltSingletonsChim.txt
                #Eliminer les chimères
                (vsearch --uchime_denovo AllSamples_CentroidsVsearch_SsSingletons.fasta --nonchimeras AllSamples_CentroidsVsearch_SsSingletons_FiltChim.fasta) 2>> ResultatsSuivi_FiltSingletonsChim.txt
                
                #Recuperation des donnees issues de la clusterisation et recuperation des infos pour sequences conservees par l'etape de filtration singletons et chimeres 
                sed -n '/>/p' AllSamples_CentroidsVsearch_SsSingletons_FiltChim.fasta > Entetes.temp
                sed -i -e "s/>//g" Entetes.temp
                sed -i -e "s/;size=\([0-9][0-9]*\);//g" Entetes.temp
                cp TableauLong_Resultats_VSEARCHOTUs.csv TableauLong.temp
                sed -i -e "s/__/___/g" TableauLong.temp
                sed -i -e "s/@/__/g" TableauLong.temp
                sed -i -e "s/___/@@/g" TableauLong.temp
                echo -e "CENTROID;SAMPLE;NUMBER" > TableauLong.csv
                for ligne in $(<Entetes.temp)
                    do
                        sed -n '/'$ligne'/p' TableauLong.temp > Tableau.temp
                        cat TableauLong.csv Tableau.temp > Tableau2.temp
                        mv Tableau2.temp TableauLong.csv
                    done

sed -i -e "s/ /;/g" TableauLong.csv
sed -i -e "s/@@/;/g" TableauLong.csv

R --slave -e 'source("/home/pcruaud/Programmes/Scripts_perso/FormatLongAFormatLarge.R")'
cp TableauLarge.csv Sauvegarde_TableauLarge0_OTUs.csv
sed -i -e "s/\;NA/\;0/g" TableauLarge.csv
sed -i -e "s/\"//g" TableauLarge.csv
sed -i -e "s/^\([0-9][0-9]*\)\;//g" TableauLarge.csv

cp TableauLarge.csv Resultats_ClustersOTUsVSEARCH_Glob_SsSingletons_FiltChim.txt

rm *.temp
rm TableauLarge.csv
rm TableauLong.csv 
                
echo -e "Heure du debut de l'analyse : $HeureDebut"
HeureFinOTUs=$(date +%Hh%M)
echo -e "Heure de fin de l'etape de filtration pour OTUs : $HeureFinOTUs"             
                

echo -e "\n Analyse sur les SWARMS... \n"

		#Eliminer les singletons
		(vsearch --derep_fulllength AllSamples_OTURepresent.fasta --minuniquesize 2 --sizein --output AllSamples_OTURepresent_SsSingletons.fasta) 2>> ResultatsSuivi_FiltSingletonsChim.txt
                #Eliminer les chimères
		(vsearch --uchime_denovo AllSamples_OTURepresent_SsSingletons.fasta --nonchimeras AllSamples_OTURepresent_SsSingletons_FiltChim.fasta) 2>> ResultatsSuivi_FiltSingletonsChim.txt

                #Recuperation des donnees issues de la clusterisation et recuperation des infos pour sequences conservees par l'etape de filtration singletons et chimeres 
                sed -n '/>/p' AllSamples_OTURepresent_SsSingletons_FiltChim.fasta > Entetes.temp
                sed -i -e "s/>//g" Entetes.temp
                sed -i -e "s/;size=\([0-9][0-9]*\);//g" Entetes.temp
                cp TableauLong_Resultats_SWARMs.csv TableauLong.temp
                sed -i -e "s/__/___/g" TableauLong.temp
                sed -i -e "s/@/__/g" TableauLong.temp
                sed -i -e "s/___/@@/g" TableauLong.temp
                echo -e "CENTROID;SAMPLE;NUMBER" > TableauLong.csv
                for ligne in $(<Entetes.temp)
                    do
                        sed -n '/'$ligne'/p' TableauLong.temp > Tableau.temp
                        cat TableauLong.csv Tableau.temp > Tableau2.temp
                        mv Tableau2.temp TableauLong.csv
                    done

sed -i -e "s/ /;/g" TableauLong.csv
sed -i -e "s/@@/;/g" TableauLong.csv

R --slave -e 'source("/home/pcruaud/Programmes/Scripts_perso/FormatLongAFormatLarge.R")'
cp TableauLarge.csv Sauvegarde_TableauLarge0_Swarms.csv
sed -i -e "s/\;NA/\;0/g" TableauLarge.csv
sed -i -e "s/\"//g" TableauLarge.csv
sed -i -e "s/^\([0-9][0-9]*\)\;//g" TableauLarge.csv

cp TableauLarge.csv Resultats_ClustersSwarms_Glob_SsSingletons_FiltChim.txt
                  
rm *.temp 
rm TableauLarge.csv
rm TableauLong.csv

echo -e "\n"

echo -e "Heure du debut de l'analyse : $HeureDebut"
echo -e "Heure du debut de l'analyse : $HeureDebut" >>  ResultatsSuivi_FiltSingletonsChim.txt
HeureFin=$(date +%Hh%M)
echo -e "Heure de fin de l'analyse : $HeureFin"
echo -e "Heure de fin de l'analyse : $HeureFin"  >>  ResultatsSuivi_FiltSingletonsChim.txt

echo -e "\n"

echo -e "\n###############################################\nFinAnalyse\n###############################################" >>  ResultatsSuivi_FiltSingletonsChim.txt
echo -e "\n###############################################\nFinAnalyse\n###############################################"

exit			
			
