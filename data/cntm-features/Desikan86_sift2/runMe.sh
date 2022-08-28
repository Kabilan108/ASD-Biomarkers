#!/bin/bash
# sample: ./runMe.sh 

basepath=/home/kabil/Vault/Coursework/CS-T680/AutismCNN
experimentPath=$basepath/data/statistics-desikan
samplePath=$experimentPath/subjects.txt
measuresList=$experimentPath/features.txt
connectomesFolder=$basepath/data/CHARM/Desikan_sift2

systemMaps=$basepath/data/11System_in_Desikan86.txt
hemisphereMaps=$basepath/data/hemispheremap_Desikan86.txt
numNodes=86

bct_features_py=/home/kabil/Vault/ToolBox/yusuf/bctWrapper/scripts/bct_features.py


if [[ ! -e $measuresList ]]; then
	python $bct_features_py --printFullMeasureList > $measuresList
	echo "Features list file is not found!! A full features lits is generated in $measuresList . Check the file and rerun this script to generate features for connectomes. Exiting..."
	exit 1
fi

mkdir -p $experimentPath/features

# python $bct_features_py --measuresList $measuresList --connectomesFolder $connectomesFolder/ --subjectsList $samplePath --systemMaps $systemMaps --hemisphereMaps $hemisphereMaps --outputFolder $experimentPath/features/ --numNodes $numNodes --verbose --normalizeConnectomes none
python $bct_features_py --measuresList $measuresList --connectomesFolder $connectomesFolder/ --subjectsList $samplePath --systemMaps $systemMaps --hemisphereMaps $hemisphereMaps --outputFolder $experimentPath/features/ --numNodes $numNodes --verbose --normalizeConnectomes maxEdge1_subject


