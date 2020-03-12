#!/bin/bash
#################################################################
# Cleanup previous deploy whether success or failure		#
#################################################################
echo "cleanup-refresh : Begin cleanup of previous deployment..."
export VM=`sudo virsh list|grep running|awk {'print \$2'}`
if [[ $VM = *bootstrap* ]]; then 
  echo "cleanup-refresh : Cleaning up left over bootstrap..."
  sudo virsh destroy $VM
  sudo virsh undefine $VM
  sudo rm -r -f /var/lib/libvirt/images/$VM
  sudo rm -r -f /var/lib/libvirt/images/$VM.ign
  sudo ls -l /var/lib/libvirt/images/
fi
echo "cleanup-refresh : Cleaning up left over cache from previous deployment..."
rm -r -f `pwd`/.kube
rm -r -f `pwd`/.cache
rm -r -f `pwd`/ocp
rm -r -f `pwd`/install-config.yaml
rm -r -f `pwd`/metal3-config.yaml
echo "cleanup-refresh : Turning off nodes..."
/usr/bin/ipmitool -I lanplus -Hidrac1.schmaustech.com -Uroot -Ppassword chassis power off
/usr/bin/ipmitool -I lanplus -Hidrac2.schmaustech.com -Uroot -Ppassword chassis power off
/usr/bin/ipmitool -I lanplus -Hidrac3.schmaustech.com -Uroot -Ppassword chassis power off
/usr/bin/ipmitool -I lanplus -Hidrac4.schmaustech.com -Uroot -Ppassword chassis power off
/usr/bin/ipmitool -I lanplus -Hidrac5.schmaustech.com -Uroot -Ppassword chassis power off
/usr/bin/ipmitool -I lanplus -Hidrac6.schmaustech.com -Uroot -Ppassword chassis power off
echo "cleanup-refresh : Completed cleanup!"
