#!/bin/bash
#################################################################################
# Extract new oc and openshift-baremetal-install binaries based on VERSION	#
#################################################################################
: ${VERSION:=4.3.1}
: ${NET:=4}
SUBVER=`echo "${VERSION:0:3}"`

echo "binaries-refresh : Begin binaries refresh..."

CMD=openshift-baremetal-install
EXTRACT_DIR=$(pwd)

#if [[ "$NET" == 6 ]]; then
#  if [[ $SUBVER < 4.4 ]]; then
#    echo "binaries-refresh : Gather IPv$NET related binaries for release $VERSION..."
#    RELEASE_IMAGE="registry.svc.ci.openshift.org/ipv6/release:$VERSION"
#    PULLSECRET=/`pwd`/pull-secret.json.ipv6
#  else
#    echo "binaries-refresh : Gather IPv$NET related binaries for release $VERSION"
#    RELEASE_IMAGE="registry.svc.ci.openshift.org/ocp/release:$VERSION"
#    PULLSECRET=/`pwd`/pull-secret.json
#  fi
#else
#  echo "binaries-refresh : Gather IPv$NET related binaries for release $VERSION"
#  RELEASE_IMAGE="registry.svc.ci.openshift.org/ocp/release:$VERSION"
#  PULLSECRET=/`pwd`/pull-secret.json
#fi

echo "binaries-refresh : Gather IPv$NET related binaries for release $VERSION"
RELEASE_IMAGE="registry.svc.ci.openshift.org/ocp/release:$VERSION"
PULLSECRET=/`pwd`/pull-secret.json

echo "binaries-refresh : Fetching oc..."
OCVERSION=$(curl -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp-dev-preview/latest-$SUBVER/release.txt | grep 'Name:' | awk -F: '{print $2}' | xargs)
curl -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp-dev-preview/latest-$SUBVER/openshift-client-linux-$OCVERSION.tar.gz | tar zxvf - oc
echo "binaries-refresh : Fetching $CMD..."
/`pwd`/oc adm release extract --registry-config "${PULLSECRET}" --command=$CMD --to "${EXTRACT_DIR}" ${RELEASE_IMAGE}
echo "binaries-refresh : Completed binaries refresh!"
