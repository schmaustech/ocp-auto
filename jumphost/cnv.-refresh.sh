#!/bin/bash
#########################################################################
# Mirror CNV contents down to local registry				#
#########################################################################
echo "cnv-refresh : Begin cnv refresh..."

export BUNDLE_REGISTRY_NAME=cnv-bundle-registry
export BUNDLE_REGISTRY_TAG=2.2.0
export PACKAGEVERSION=5.0.0
export MY_REGISTRY=jumphost.schmaustech.com:5000/ocp4/cnv/

echo "cnv-refresh : Registry: $BUNDLE_REGISTRY_NAME Tag: $BUNDLE_REGISTRY_TAG PackageVersion: $PACKAGEVERSION"

echo "cnv-refresh : Logging into $MY_REGISTRY..."
podman login -u dummy -p dummy $MY_REGISTRY
echo "cnv-refresh : Logging into registry.redhat.io..."
podman login -u 'username' -p 'password' registry.redhat.io

echo "cnv-refresh : Mirroring $BUNDLE_REGISTRY_NAME..."
cd hyperconverged-cluster-operator/tools/mirror-csv-release
./mirror_csv_release.sh --appregistry --version-filter ${BUNDLE_REGISTRY_TAG} --packageversion ${PACKAGEVERSION} --bundle-registry-name ${BUNDLE_REGISTRY_NAME} --bundle-registry-tag ${BUNDLE_REGISTRY_TAG} ${MY_R
EGISTRY}
cd ../
echo "cnv-refresh : Completed cnv refresh..."
