#!/bin/bash
# sample: ./runMe.sh 

# t2 R0083_V0168_DTI_Schaefer2018_200_7Networks_connmat_sift2 Traceback (most recent call last):
#   File "/home/kabil/Vault/ToolBox/yusuf/bctWrapper/scripts/bct_features.py", line 434, in <module>
#     measure_matrix[i]=bct.edge_betweenness_wei(weightedConnectomes_length_norm[i])[1]/float((numNodes-1)*(numNodes-2)) #normalize the betwenness centrality. Note that, input being weightedConnectomes_length_norm or weightedConnectomes_length doesn't affect the output of this function, as expected
#   File "/home/kabil/.anaconda3/envs/neuro/lib/python3.9/site-packages/bct/algorithms/centrality.py", line 330, in edge_betweenness_wei
#     Q[:q], = np.where(np.isinf(D))  # these are first in line
# ValueError: could not broadcast input array from shape (219,) into shape (218,)

basepath=/home/kabil/Vault/Coursework/CS-T680/AutismCNN
experimentPath=$basepath/data/statistics-schaefer
samplePath=$experimentPath/subjects.txt
measuresList=$experimentPath/features.txt
connectomesFolder=$basepath/data/CHARM/Schaefer200_sift2

systemMaps=$basepath/data/Schaefer2018_220Parcels_networks.txt
hemisphereMaps=$basepath/data/hemispheremap_Schaefer220.txt
numNodes=220

bct_features_py=/home/kabil/Vault/ToolBox/yusuf/bctWrapper/scripts/bct_features.py


if [[ ! -e $measuresList ]]; then
	python $bct_features_py --printFullMeasureList > $measuresList
	echo "Features list file is not found!! A full features lits is generated in $measuresList . Check the file and rerun this script to generate features for connectomes. Exiting..."
	exit 1
fi

mkdir -p $experimentPath/features

# python $bct_features_py --measuresList $measuresList --connectomesFolder $connectomesFolder/ --subjectsList $samplePath --systemMaps $systemMaps --hemisphereMaps $hemisphereMaps --outputFolder $experimentPath/features/ --numNodes $numNodes --verbose --normalizeConnectomes none
python $bct_features_py --measuresList $measuresList --connectomesFolder $connectomesFolder/ --subjectsList $samplePath --systemMaps $systemMaps --hemisphereMaps $hemisphereMaps --outputFolder $experimentPath/features/ --numNodes $numNodes --verbose --normalizeConnectomes maxEdge1_subject


