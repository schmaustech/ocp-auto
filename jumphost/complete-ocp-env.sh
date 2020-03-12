#!/bin/bash
###########################################################################
# This will deploy a complete disconnected OCP environment 		  #
###########################################################################

# source variables from vars-env file
source /`pwd`/vars-env
: ${VERSION:=4.3.1}
: ${NET:=4}

echo "Deploying OCP Baremetal Environment..."
echo "Version: $VERSION"
echo "Net Type: $NET"

# Refresh services based on ipv4 or ipv6
/`pwd`/services-refresh.sh

# Refresh oc and openshift-baremetal-install binaries with env VERSION
/`pwd`/binaries-refresh.sh

# Refresh registry mirror with env VERSION
/`pwd`/mirror-refresh.sh

# Refresh cnv registry if CNV=Y
if [ $CNV = "Y" ]; then
  /`pwd`/cnv-refresh.sh
fi

# Refresh rhcos image based on VERSION
/`pwd`/rhcos-refresh.sh

# Stage & Copy requirements to provisioning node
/`pwd`/stage-refresh.sh

# Execute deploy on provision node, validate and push logs back to jumphost

ssh kni@provision.rna1.cloud.lab.eng.bos.redhat.com "/home/kni/deploy.sh"

#Notify DCI Slack Channel

/`pwd`/slack-refresh.sh

# Update html
/`pwd`/html-refresh.sh

echo "Completed OCP Baremetal Environment"
