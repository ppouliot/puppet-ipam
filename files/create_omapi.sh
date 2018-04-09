#!/usr/bin/env bash

exec &>> $HOME/create_omapi_key.log
echo "**** Script to create omapi keys for IPAM cluster **********"
echo "**** Determining Key Variables *****************************"

# OMAPI_KEY_NAME=`hostname -f`
# OMAPI_KEY_NAME=dhcp-failover
#
OMAPI_KEY_NAME=omapi_key
RNDC_KEY_NAME=rndc_key
DN=`hostname -d`
FQDN=`hostname -f`
PRIMARY=ipam1.$DN
SECONDARY=ipam2.$DN

echo "**** Displaying Variables                               ****"
echo "**** Domain Name:$DN                          ****"
echo "**** Fully Qualified Domain Name:$FQDN        ****"
echo "**** PRIMARY:$PRIMARY                   ****"
echo "**** OMAPI_KEY_NAME                            ****"
echo "**** RNDC_KEY_NAME                              ****"
echo "**** SECONDARY:$SECONDARY               ****"

echo "**** Waiting for creation of directory bind.keys.d      ****"
echo "**** which is created during first execution of puppet. ****"
until [ -d "$OMAPI_KEYS_DIR" ]
do 
  OMAPI_KEYS_DIR=`find / -name bind.keys.d`
  echo "#"
done
echo "**** "$OMAPI_KEYS_DIR" Found ***********************"
cd $OMAPI_KEYS_DIR
if [[ $OMAPI_KEY_NAME == $SECONDARY ]]; then
  until [ -e /etc/puppetlabs/puppet/data/omapi_key.tgz ]
  do
    echo "!"
  done
  echo "**** Extracting OMAPI Key Archive from ipam1          ****"
  tar -xvzf /etc/puppetlabs/puppet/data/omapi_key.tgz
  exit
else
echo "**** Creating rndc.key *************************************"
rndc-confgen -r /dev/urandom -A HMAC-MD5 -b 512 -c -n $FQDN $RNDC_KEY_NAME

echo "**** Creating OMAPI Key for ISC-DHCP-Server Mgmt ****"
dnssec-keygen -r /dev/urandom -a HMAC-MD5 -b 512 -n HOST $OMAPI_KEY_NAME
echo "**** Creating OMAPI Secret FIle  ***************************"
export OMAPI_PRIVATE_KEY=`cat $OMAPI_KEYS_DIR/K${OMAPI_KEY_NAME}.+*.private |grep ^Key| cut -d ' ' -f2-`
export OMAPI_SECRET_KEY=`cat $OMAPI_KEYS_DIR/K${OMAPI_KEY_NAME}.+*.key |awk '{ print $8 }'`
echo 'secret "'$OMAPI_PRIVATE_KEY'";' > ${OMAPI_KEYS_DIR}/${OMAPI_KEY_NAME}.secret
echo "**** Creating OMAPI Key FIle  ****"
cat <<EOF > ${OMAPI_KEYS_DIR}/${OMAPI_KEY_NAME}.key
key "${OMAPI_KEY_NAME}" {
  algorithm hmac-md5;
  secret "${OMAPI_SECRET_KEY}";
}
EOF

echo "**** Creating Tarball of DHCP/DNS Key Data *****************"
tar -cvzf /etc/puppetlabs/puppet/data/omapi_key.tgz *.*

echo "**** Creating groups/common.yaml with Key Data for IPAM2 Vagrant Host ****"
cat <<EOF > /etc/puppetlabs/code/modules/ipam/files/hiera/groups/common.yaml
---
dhcp::dnsupdatekey: "%{::dns::server::params::cfg_dir}/bind.keys.d/${OMAPI_KEY_NAME}.key"
dhcp::dnskeyname: ${OMAPI_KEY_NAME}
dhcp::omapi_name: ${OMAPI_KEY_NAME}
dhcp::omapi_key: ${OMAPI_SECRET_KEY}
dhcp::omapi_port: 7911
dns::tsig:
  ${OMAPI_KEY_NAME}:
    ensure: present
    algorithm: "hmac-md5"
    secret: ${OMAPI_SECRET_KEY}
    server: "%{::ipaddress}"
EOF

exit
fi

