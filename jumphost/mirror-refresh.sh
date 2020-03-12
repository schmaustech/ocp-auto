#!/bin/bash
#################################################################################
# Mirror down VERSION registry                                                  #
#################################################################################
echo "mirror-refresh : Begin mirror refresh..."
: ${VERSION:=4.3.1}
: ${NET:=4}
SUBVER=`echo "${VERSION:0:3}"`

#if [[ "$NET" == 6 ]]; then
#  if [[ $SUBVER < 4.4 ]]; then
#    UPSTREAM_REPO="registry.svc.ci.openshift.org/ipv6/release:$VERSION"
#    PULLSECRET=/`pwd`/pull-secret.json.ipv6
#  else
#    UPSTREAM_REPO="registry.svc.ci.openshift.org/ocp/release:$VERSION"
#    PULLSECRET=/`pwd`/pull-secret.json
#  fi
#else
#  UPSTREAM_REPO="registry.svc.ci.openshift.org/ocp/release:$VERSION"
#  PULLSECRET=/`pwd`/pull-secret.json
#fi
UPSTREAM_REPO="registry.svc.ci.openshift.org/ocp/release:$VERSION"
PULLSECRET=/`pwd`/pull-secret.json
LOCAL_REG='jumphost.schmaustech.com:5000'
LOCAL_REPO='ocp4/openshift4'
echo "mirror-refresh : Removing old registry..."
podman stop registry
podman rm registry
rm -r -f /opt/registry/data/docker
echo "mirror-refresh : Creating new registry..."
podman create --name registry --net host -p 5000:5000 -v /opt/registry/data:/var/lib/registry:z -v /opt/registry/auth:/auth:z -e "REGISTRY_AUTH=htpasswd" -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry" -e "REGISTRY_H
TTP_SECRET=ALongRandomSecretForRegistry" -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd -v /opt/registry/certs:/certs:z -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/domain.crt -e REGISTRY_HTTP_TLS_KEY=/certs/domain.ke
y docker.io/library/registry:2
podman start registry
echo "mirror-refresh : Mirroring ipv$NET $VERSION..."
/`pwd`/oc adm release mirror -a $PULLSECRET --from=$UPSTREAM_REPO --to-release-image=$LOCAL_REG/$LOCAL_REPO:$VERSION --to=$LOCAL_REG/$LOCAL_REPO
echo "mirror-refresh : Completed mirror refresh!"
