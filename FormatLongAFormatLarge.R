#! /usr/bin/env Rscript

#Nom du programme : FormatLongAFormatLarge.R
#Date de création : 13 avril 2017
#Derniere mise a jour : 13 avril 2017
#Auteur : Perrine Cruaud
#But du programme : Permet de passer un tableau d'un format long a un format large (entree : TableauLong.csv)

library(reshape)
TableauLong <- read.csv(file="TableauLong.csv", sep=";")
TableauLarge <- cast(TableauLong, SAMPLE~CENTROID)
write.table(TableauLarge, file="TableauLarge.csv", sep=";", col.names=TRUE)
