#!/bin/bash
chkconfig zabbix_agentd on;/etc/init.d/zabbix_agentd start
sed -r -i -e '/snmp/s@^@#@g' -e '/nrpe/s@^@#@g' /etc/rc.d/rc.local;/etc/init.d/snmpd stop;/etc/init.d/nrpe stop
mv /usr/sbin/named /usr/sbin/named.new;ln -snf /usr/bin/named.old /usr/sbin/named
sed -r -i -e '/\/marco config;/d' -e '/sharp_ats_8200/a\/etc/init.d/marco config;/etc/init.d/marco start' /etc/rc.d/rc.local
rm -rf /root/*.tgz* /root/*.sh
