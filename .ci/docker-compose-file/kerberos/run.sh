#!/bin/sh


echo "Remove old keytabs"

rm -f /var/lib/secret/kafka.key 2>&1 > /dev/null
rm -f /var/lib/secret/rig.key 2>&1 > /dev/null

echo "Create realm"

kdb5_util -P emqx -r KDC.EMQX.NET create -s

echo "Add principals"

kadmin.local -w password -q "add_principal -randkey kafka/kafka-1.emqx.net@KDC.EMQX.NET"
kadmin.local -w password -q "add_principal -randkey rig@KDC.EMQX.NET"  > /dev/null


echo "Create keytabs"

kadmin.local -w password -q "ktadd  -k /var/lib/secret/kafka.key -norandkey kafka/kafka-1.emqx.net@KDC.EMQX.NET " > /dev/null
kadmin.local -w password -q "ktadd  -k /var/lib/secret/rig.key -norandkey rig@KDC.EMQX.NET " > /dev/null

echo STARTING KDC
/usr/sbin/krb5kdc -n
