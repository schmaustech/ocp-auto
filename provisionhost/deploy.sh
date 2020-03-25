#!/bin/bash
#########################################################################
# Cleanup, deploy and return results to jumphost			#
#########################################################################
echo "deploy : Begin deployment process..."
source $HOME/vars-env
: ${VERSION:=4.3.1}
: ${NET:=4}
SUBVER=`echo "${VERSION:0:3}"`
export PATH=$PATH:.
#export TF_LOG=trace

echo "deploy : Run cleanup process..."
$HOME/cleanup-refresh.sh

echo "deploy : Run config-refresh process.."
$HOME/config-refresh.sh

echo "deploy : Setting environment vars..."
export OPENSHIFT_RELEASE_IMAGE="registry.svc.ci.openshift.org/ocp/release:$VERSION"
export LOCAL_REG='jumphost.rna1.cloud.lab.eng.bos.redhat.com:5000'
export LOCAL_REPO='ocp4/openshift4'
export OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE=${LOCAL_REG}/${LOCAL_REPO}:${VERSION}

echo "deploy: Pausing for 60 seconds..."
sleep 60

echo "deploy : Version: $VERSION"
echo "deploy : Net-Type: ipv$NET"
echo "deploy : Release Image Override: $OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE"

mkdir $HOME/ocp
cp $HOME/install-config.yaml $HOME/ocp
$HOME//openshift-baremetal-install --dir=ocp create manifests
if [[ $SUBVER < 4.4 ]]; then
    echo "deploy : Deployment version less then 4.4 so use metal3-config.yaml..."
    cp $HOME/metal3-config.yaml $HOME/ocp/openshift/99_metal3-config.yaml
fi
$HOME/openshift-baremetal-install --dir=ocp --log-level debug create cluster

retVal=$?
if [ $retVal -ne 0 ]; then
    echo "JOBSTATE=Failed">>$HOME/vars-env
else
    echo "JOBSTATE=Success">>$HOME/vars-env
fi

EP=`date +%s`
echo "EPOCH=$EP">>$HOME/vars-env

# Run Validate and LogGathering

echo "deploy : Run validation and log collections..."
$HOME/deploy-validate.sh

echo "deploy : Completed deployment process!"
