#!/bin/bash
HOST_NAME={{ ansible_hostname }}
LVS_MASTER=( {{ groups.all[:2] |join(" ") }} )
LVS_VIP_TYPE={{ isp }}
UPYUN_CFG=/etc/upyun.cfg

node_master_config()
{
if [[ "${LVS_MASTER[@]}" =~ ${HOST_NAME} ]]
  then
    sed -r -i -e '/LVS_MASTER=/s:.*:LVS_MASTER=\"Y\":g' -e '/LVS_HOSTS=/s:.*:LVS_HOSTS=\"{{ lvs_hosts }}\":g' $UPYUN_CFG
    chkconfig keepalived on
fi
}

node_all_config()
{
NGX_UPSTREAM=()
IDX=1
for IP in ( {{  nginx_upstream }})
  do
   NGX_UPSTREAM[${NGX_UPSTREAM}]="$IP#$IDX"
   ((idx ++))
done

sed -r -i -e '/LVS_VIP_{{ isp }}=/s:.*:LVS_VIP_{{ isp }}=\"{{ lvs_ip }}\":g' -e '/NGINX_UPSTREAM=/s:.*:NGINX_UPSTREAM=\"${NGX_UPSTREAM[@]}\":g' $UPYUN_CFG
}

node_master_config
node_all_config
