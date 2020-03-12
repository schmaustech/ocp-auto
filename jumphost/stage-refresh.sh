#!/bin/bash
#########################################################################
# Stages and moves over what is needed by provisioning node 		#
#########################################################################
echo "stage-refresh : Begin stage and copy refresh..."
echo "stage-refresh : SCP oc and openshift-baremetal-install binaries..."
scp /`pwd`/oc kni@provision.schmaustech.com:/home/kni/oc
scp /`pwd`/openshift-baremetal-install kni@provision.schmaustech.com:/home/kni/openshift-baremetal-install
echo "stage-refresh : SCP vars-env file..."
scp /`pwd`/vars-env kni@provision.schmaustech.com:/home/kni/vars-env
echo "stage-refresh : Completed stage and copy refresh!"
