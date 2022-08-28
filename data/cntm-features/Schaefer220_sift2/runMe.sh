#!/bin/bash
# This assumes that directory paths are defined in $VAULT and $COURSEWORK
# sample: ./runMe.sh 

# Define paths
basepath=$COURSEWORK/CS-T680/AutismCNN
experimentPath=$basepath/data/cntm-features/Schaefer220_sift2
samplePath=$experimentPath/connectomes.txt
measuresList=$experimentPath/features.txt
connectomesFolder=$basepath/data/raw/CHARM/Schaefer220_sift2

systemMaps=$basepath/data/atlas-maps/Schaefer220_system_map.txt
hemisphereMaps=$basepath/data/atlas-maps/Schaefer220_hemisphere_map.txt
numNodes=220

bct_features_py=$VAULT/ToolBox/yusuf/bctWrapper/scripts/bct_features.py

if [[ ! -e $measuresList ]]; then
	python $bct_features_py --printFullMeasureList > $measuresList
	echo "Features list file is not found!! A full features lits is generated in $measuresList . Check the file and rerun this script to generate features for connectomes. Exiting..."
	exit 1
fi

mkdir -p $experimentPath/features

python $bct_features_py \
	--measuresList $measuresList \
	--connectomesFolder $connectomesFolder/ \
	--subjectsList $samplePath \
	--systemMaps $systemMaps \
	--hemisphereMaps $hemisphereMaps \
	--outputFolder $experimentPath/features/ \
	--numNodes $numNodes \
	--normalizeConnectomes maxEdge1_subject \
	--verbose 
