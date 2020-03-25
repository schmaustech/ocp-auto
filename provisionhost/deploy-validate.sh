#!/bin/bash
#################################################################
# Validate and log collection					#
#################################################################
echo "deploy-validate : Begin deployment validation and log collection..."
source vars-env
export PATH=$PATH:.
export KUBECONFIG=/home/kni/ocp/auth/kubeconfig

$HOME/oc get nodes >$HOME/ocp/ocgetnodes.log

$HOME/oc get pods --all-namespaces >$HOME/ocp/ocgetpods.log

$HOME/oc get clusteroperators >$HOME/ocp/ocgetclusteroperators.log

$HOME/oc -n openshift-machine-api get bmh >$HOME/ocp/ocgetbmh.log

$HOME/oc -n openshift-machine-api get csr >$HOME/ocp/ocgetcsr.log

echo "deploy-validate : Copy logs over to jumphost..."
echo "copy jumphost:/opt/ocp/ironic/html/results/$VERSION-$EPOCH"
ssh root@jumphost.schmaustech.com "mkdir /opt/ocp/ironic/html/results/$VERSION-$EPOCH"
scp -r $HOME/ocp/* root@jumphost.schmaustech.com:/opt/ocp/ironic/html/results/$VERSION-$EPOCH
scp $HOME/ocp/.openshift_install.log root@jumphost.schmaustech.com:/opt/ocp/ironic/html/results/$VERSION-$EPOCH/openshift_install.log
scp $HOME/ocp/.openshift_install_state.json root@jumphost.schmaustech.com:/opt/ocp/ironic/html/results/$VERSION-$EPOCH/openshift_install_state.json
scp $HOME/vars-env root@jumphost.schmaustech.com:/opt/ocp/ironic/html/results/$VERSION-$EPOCH
scp $HOME/oc root@jumphost.schmaustech.com:/opt/ocp/ironic/html/results/$VERSION-$EPOCH
scp $HOME/openshift-baremetal-install root@jumphost.schmaustech.com:/opt/ocp/ironic/html/results/$VERSION-$EPOCH

echo "deploy-validate : Completed deployment validation and log collection..."
