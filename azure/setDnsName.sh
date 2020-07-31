$IP="23.101.60.87"
$DNSNAME="yourservicename-aks"
$PUBLICIPID=az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[id]" --output tsv
az network public-ip update --ids $PUBLICIPID --dns-name $DNSNAME

az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$IP')].[dnsSettings.fqdn]" -o table
