#!/bin/bash
#################################################################
# Copy in appropriate install and metal3 config and update	#
#################################################################
echo "config-refesh : Begin config refresh process..."
source $HOME/vars-env
: ${VERSION:=4.3.1}
: ${NET:=4}
SUBVER=`echo "${VERSION:0:3}"`

echo "config-refresh : Pulling in install-config.yaml.ipv$NET-$SUBVER..."
cp $HOME/install-configs/install-config.yaml.ipv$NET-$SUBVER $HOME/install-config.yaml
if [[ $SUBVER < 4.4 ]]; then
  echo "config-refresh : Pulling in metal3-config.yaml.ipv$NET-$SUBVER..."
  cp $HOME/metal3-configs/metal3-config.yaml.ipv$NET-$SUBVER $HOME/metal3-config.yaml
fi

echo "config-refresh : Updating RHCOS images in config files..."
sed -i "s/RHCOS_QEMU_IMAGE/$RHCOS_QEMU_IMAGE/g" $HOME/install-config.yaml
sed -i "s/RHCOS_OPENSTACK_IMAGE/$RHCOS_OPENSTACK_IMAGE/g" $HOME/install-config.yaml
if [[ $SUBVER < 4.4 ]]; then
 sed -i "s/RHCOS_OPENSTACK_IMAGE/$RHCOS_OPENSTACK_IMAGE/g" $HOME/metal3-config.yaml
fi

echo "config-refresh : Completed config refresh process..."
