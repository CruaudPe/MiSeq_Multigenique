#Nom du programme : TranspositionTable.R
#Date de création : 13 avril 2017
#Derniere mise a jour : 13 avril 2017
#Auteur : Perrine Cruaud
#But du programme : Script pour transposer un tableau nomme "TableATransposer.csv"


TableATransposer <- read.csv(file="TableATransposer.csv", sep=";")
TableTransposee <- t(TableATransposer)
write.table(TableTransposee, file="TaxoTransposee.csv", sep=";", col.names = TRUE)