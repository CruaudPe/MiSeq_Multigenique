#! /bin/bash

#Nom du programme : Summary_RunQuality.sh
#Date de creation : 25 janvier 2017
#Dernier mise a jour : 1er mai 2017
#Auteur : Perrine Cruaud
#But du programme : Creation d'un fichier texte recapitulant les caracteristiques du run
#Dans le dossier ou on lance ce script besoin : SampleSheet.csv

echo -e "CARACTERISTIQUES DU RUN" > CaracteristiquesRun.txt

echo -e "\n\nPour commencer, quelques questions sur votre run :\n\n"

JourAnalyse=$(date +%d/%m/%Y)
echo -e "Date de l'analyse : $JourAnalyse" >> CaracteristiquesRun.txt

sed -n '/Experiment Name,/p' SampleSheet.csv >> CaracteristiquesRun.txt
sed -i -e "s/Experiment Name,/Nom du run : /g" CaracteristiquesRun.txt

sed -n '/Date,/p' SampleSheet.csv >> CaracteristiquesRun.txt
sed -i -e "s/Date,/Date du run : /g" CaracteristiquesRun.txt

echo -e "Technologie de sequencage (ex: MiSeq v3 2*300bp) :"
read TechnologieRun
echo -e "Technologie de sequencage : $TechnologieRun" >> CaracteristiquesRun.txt
 
echo -e "Chargement de la flow cell :"
read LoadFlowCell
echo -e "Chargement de la flow cell : $LoadFlowCell" >> CaracteristiquesRun.txt

echo -e "Nombre d'echantillons multiplexes :"
read NbreEch
echo -e "Nombre d'echantillons multiplexes : $NbreEch" >> CaracteristiquesRun.txt

echo -e "Nombre de genes sequences :"
read NbreGenes
echo -e "Nombre de genes sequences : $NbreGenes" >> CaracteristiquesRun.txt

echo "Genes NomGene Longueurfragment   Amorceforward  Amorcereverse Recouvrement :" > CaracteristiquesFragmentsSequences.txt
for ((i=0;$NbreGenes-$i;i++))
do
echo -e "\nNom du gene $(($i+1))  :"
read NomGene
echo -e "Longueur du fragment a sequencer pour le gene $(($i+1)) :"
read LongueurFragment
echo -e "Amorce forward pour le gene $(($i+1)) :"
read AmorceForward
echo -e "Amorce reverse pour le gene $(($i+1)) :"
read AmorceReverse
Recouvrement=$((600-$LongueurFragment))
echo -e "$Recouvrement bp de recouvrement paired-end pour le gene $(($i+1))"
echo -e "Gene $(($i+1))\n$NomGene\nLongueur fragment $LongueurFragment bp\nAmorce forward : $AmorceForward\nAmorce reverse : $AmorceReverse\nRecouvrement : $Recouvrement bp\n" >> CaracteristiquesRun.txt
echo "Gene $(($i+1))    $NomGene    $LongueurFragment   $AmorceForward  $AmorceReverse  $Recouvrement" >> CaracteristiquesFragmentsSequences.txt
done

sed -n '/Total Sequences/p' Bilan_global/Global_fastqc/fastqc_data.txt >> CaracteristiquesRun.txt
TotSequencesBrut=$(sed -n '/Total Sequences/p' Bilan_global/Global_fastqc/fastqc_data.txt)
TotSequences=$(sed s:'Total Sequences':'':g <<< $TotSequencesBrut)
sed -i -e "s/Total Sequences	/Nombre total de sequences : /g" CaracteristiquesRun.txt

sed -n '/Sequence length	/p' Bilan_global/Global_fastqc/fastqc_data.txt >> CaracteristiquesRun.txt
sed -i -e "s/Sequence length	/Longueurs des sequences (bp) : /g" CaracteristiquesRun.txt

sed -n '/>>Per sequence quality scores/{:a;N;/>>END_MODULE/!ba;p;}' Bilan_global/Global_fastqc/fastqc_data.txt > Quality.temp
sed -i -e '1d' Quality.temp
sed -i -e '2d' Quality.temp
sed -i -e '$d' Quality.temp
sed -n '/^30	/,$p' Quality.temp > Quality2.temp
SeqSupQ30=$(awk '{t+=$2} END {print t}' Quality2.temp)
PercentQ30Temp=$(bc <<< "scale=3;$SeqSupQ30 / $TotSequences")
PercentQ30=$(bc <<< "$PercentQ30Temp * 100")
echo -e "Pourcentage de sequences dont la qualite est superieure a Q30 moyen (%): $PercentQ30" >> CaracteristiquesRun.txt

sed -n '/Total Sequences/p' Bilan_global/Global_Reads1_fastqc/fastqc_data.txt >> CaracteristiquesRun.txt
TotSequencesBrutR1=$(sed -n '/Total Sequences/p' Bilan_global/Global_Reads1_fastqc/fastqc_data.txt)
TotSequencesR1=$(sed s:'Total Sequences':'':g <<< $TotSequencesBrutR1)
sed -i -e "s/Total Sequences	/Nombre total de reads 1 : /g" CaracteristiquesRun.txt

sed -n '/Sequence length	/p' Bilan_global/Global_Reads1_fastqc/fastqc_data.txt >> CaracteristiquesRun.txt
sed -i -e "s/Sequence length	/Longueurs des sequences (bp) : /g" CaracteristiquesRun.txt

sed -n '/>>Per sequence quality scores/{:a;N;/>>END_MODULE/!ba;p;}' Bilan_global/Global_Reads1_fastqc/fastqc_data.txt > QualityR1.temp
sed -i -e '1d' QualityR1.temp
sed -i -e '2d' QualityR1.temp
sed -i -e '$d' QualityR1.temp
sed -n '/^30	/,$p' QualityR1.temp > QualityR12.temp
SeqSupQ30R1=$(awk '{t+=$2} END {print t}' QualityR12.temp)
PercentQ30TempR1=$(bc <<< "scale=3;$SeqSupQ30R1 / $TotSequencesR1")
PercentQ30R1=$(bc <<< "$PercentQ30TempR1 * 100")
echo -e "Pourcentage de reads 1 dont la qualite est superieure a Q30 moyen (%): $PercentQ30R1" >> CaracteristiquesRun.txt

sed -n '/Total Sequences/p' Bilan_global/Global_Reads2_fastqc/fastqc_data.txt >> CaracteristiquesRun.txt
TotSequencesBrutR2=$(sed -n '/Total Sequences/p' Bilan_global/Global_Reads2_fastqc/fastqc_data.txt)
TotSequencesR2=$(sed s:'Total Sequences':'':g <<< $TotSequencesBrutR2)
sed -i -e "s/Total Sequences	/Nombre total de reads 2 : /g" CaracteristiquesRun.txt

sed -n '/Sequence length	/p' Bilan_global/Global_Reads2_fastqc/fastqc_data.txt >> CaracteristiquesRun.txt
sed -i -e "s/Sequence length	/Longueurs des sequences (bp) : /g" CaracteristiquesRun.txt

sed -n '/>>Per sequence quality scores/{:a;N;/>>END_MODULE/!ba;p;}' Bilan_global/Global_Reads2_fastqc/fastqc_data.txt > QualityR2.temp
sed -i -e '1d' QualityR2.temp
sed -i -e '2d' QualityR2.temp
sed -i -e '$d' QualityR2.temp
sed -n '/^30	/,$p' QualityR2.temp > QualityR22.temp
SeqSupQ30R2=$(awk '{t+=$2} END {print t}' QualityR22.temp)
PercentQ30TempR2=$(bc <<< "scale=3;$SeqSupQ30R2 / $TotSequencesR2")
PercentQ30R2=$(bc <<< "$PercentQ30TempR2 * 100")
echo -e "Pourcentage de reads 2 dont la qualite est superieure a Q30 moyen (%): $PercentQ30R2" >> CaracteristiquesRun.txt

SeqGeneEch=$(($TotSequencesR1 / $NbreEch / $NbreGenes))
echo -e "Nombre de sequences envisage par echantillon et par gene (apres contigage des reads 1 et 2) : $SeqGeneEch" >> CaracteristiquesRun.txt


echo -e "\n\n"
more CaracteristiquesRun.txt

rm *.temp
exit
