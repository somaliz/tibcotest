#!/bin/bash

TIBCO_HOME=/usr/local/tibco
BW_HOME=$TIBCO_HOME/bw/6.4

domain=$1
appspace=$2
profile=$3

cd /app/deploy/tibconow.auto/
ear=$(ls tibconow.auto.application_*.ear)

# Check EAR exists
if [ ! -f $ear ] ; then
	echo "EAR $ear not found"
	exit 1
fi

source $BW_HOME/scripts/bashrc.sh

script=$(mktemp)

echo "upload -domain $domain -replace /app/deploy/tibconow.auto/$ear" >> $script
echo "deploy -domain $domain -appspace $appspace -replace $ear" >> $script
echo "start -domain $domain appspace $appspace" >> $script
echo "start -d $domain -a $appspace application tibconow.auto.application 1.3" >> $script

echo "Deployment script"
echo "------------------------"
cat $script
echo "------------------------"
bwadmin -f $script
rm $script
rm -rf /app/deploy/
