#!/usr/bin/env bash

exec &>> $HOME/create_omapi_key.log
echo "**** Script to create omapi keys for IPAM cluster **********"
echo "**** Determining Key Variables *****************************"

# OMAPI_KEY_NAME=`hostname -f`
# OMAPI_KEY_NAME=dhcp-failover
#
OMAPI_KEY_NAME=omapi_key
RNDC_KEY_NAME=rndc-key
DN=`hostname -d`
FQDN=`hostname -f`
PRIMARY=ipam1.$DN
SECONDARY=ipam2.$DN

echo "**** Displaying Variables                               ****"
echo "**** Domain Name:$DN                          ****"
echo "**** Fully Qualified Domain Name:$FQDN        ****"
echo "**** PRIMARY:$PRIMARY                   ****"
echo "**** OMAPI_KEY_NAME: $OMAPI_KEY_NAME          ****"
echo "**** RNDC_KEY_NAME: $RNDC_KEY_NAME            ****"
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
if [[ $FQDN == $SECONDARY ]]; then
  until [ -e /etc/puppetlabs/puppet/data/omapi_key.tgz ]
  do
    echo "!"
  done
  echo "**** Extracting OMAPI Key Archive from ipam1          ****"
  tar -xvzf /etc/puppetlabs/puppet/data/omapi_key.tgz
  exit
else

echo "**** Creating OMAPI Key for ISC-DHCP-Server Mgmt ****"
dnssec-keygen -r /dev/urandom -a HMAC-MD5 -b 512 -n HOST $OMAPI_KEY_NAME

echo "**** Creating OMAPI Secret FIle  ***************************"
export OMAPI_PRIVATE_KEY=`cat ${OMAPI_KEYS_DIR}/K${OMAPI_KEY_NAME}.+*.private |grep ^Key| cut -d ' ' -f2-`
export OMAPI_SECRET_KEY=`cat ${OMAPI_KEYS_DIR}/K${OMAPI_KEY_NAME}.+*.key |awk '{ print $8 }'`
echo 'secret "'$OMAPI_PRIVATE_KEY'";' > ${OMAPI_KEYS_DIR}/${OMAPI_KEY_NAME}.secret
echo "**** OMAPI_PRIVATE_KEY: ${OMAPI_PRIVATE_KEY} ****"
echo "**** OMAPI_SECRET_KEY: ${OMAPI_SECRET_KEY} ****"
echo "**** Creating OMAPI Key FIle  ****"
cat <<EOF > ${OMAPI_KEYS_DIR}/omapi.key
key "${OMAPI_KEY_NAME}" {
  algorithm hmac-md5;
  secret "${OMAPI_SECRET_KEY}";
};
EOF
chmod 775 ${OMAPI_KEYS_DIR}/omapi.key

echo "**** Creating Tarball of DHCP/DNS Key Data *****************"
tar -cvzf /etc/puppetlabs/puppet/data/omapi_key.tgz ${RNDC_KEY_FILE} *.*

echo "**** Creating groups/common.yaml with Key Data for IPAM2 Vagrant Host ****"
cat <<EOF > /etc/puppetlabs/code/modules/ipam/files/hiera/groups/common.yaml
---
dns::server::params::rndc_key_file: "%{::dns::server::cfg_dir}/bind.keys.d/omapi.key"
dhcp::dnsupdatekey: "%{::dns::server::cfg_dir}/bind.keys.d/omapi.key"
dhcp::dnskeyname: "${OMAPI_KEY_NAME}"
dhcp::omapi_name: "${OMAPI_KEY_NAME}"
dhcp::omapi_key: "${OMAPI_SECRET_KEY}"
dhcp::omapi_port: 7911
EOF

exit
fi
