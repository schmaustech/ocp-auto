#!/bin/bash
#######################################################################
# Looks at NET env variable and determines services to start and stop #
# NET=4 then ipv4 deploy NET=6 then ipv6 deploy 		      #
#######################################################################
: ${NET:=4}
echo "service-refresh : Begin services refresh..."
echo "service-refresh : Refreshing services for ipv$NET..."
if [[ "$NET" == 6 ]]; then
  systemctl stop dhcpd
  systemctl status dhcpd
  systemctl start dnsmasq
  systemctl status dnsmasq
else
  systemctl stop dnsmasq
  systemctl status dnsmasq
  systemctl start dhcpd
  systemctl status dhcpd
fi
echo "service-refresh : Completed services refresh!"
