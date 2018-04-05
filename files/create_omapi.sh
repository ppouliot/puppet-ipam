#!/usr/bin/env bash

exec &>> $HOME/create_omapi_key.log
echo "**** Script to create omapi keys for IPAM cluster **********"
echo "**** Determining Key Variables *****************************"

OMAPI_KEY_NAME=`hostname -f`
DN=`hostname -d`
PRIMARY=ipam1.$DN
SECONDARY=ipam2.$DN

echo "**** Waiting for creation of directory bind.keys.d      ****"
echo "**** which is created during first execution of puppet. ****"
until [ -d "$OMAPI_KEYS_DIR" ]
do 
  OMAPI_KEYS_DIR=`find / -name bind.keys.d`
  echo -n "#"
done
echo "**** "$OMAPI_KEYS_DIR" Found ***********************"
cd $OMAPI_KEYS_DIR
if [[ $OMAPI_KEY_NAME == $SECONDARY ]]; then
  rsync -av -e ssh root@$PRIMARY:${REMOTE_OMAPI_KEYS_DIR}/${OMAPI_KEYS_DIR}/
exit
else
echo "**** Creating OMAPI Key ****"
dnssec-keygen -r /dev/urandom -a HMAC-MD5 -b 512 -n HOST $OMAPI_KEY_NAME
echo "**** Creating OMAPI Secret FIle  ***************************"
export OMAPI_SECRET=`cat $OMAPI_KEYS_DIR/K${OMAPI_KEY_NAME}.+*.private |grep ^Key| cut -d ' ' -f2-`
echo 'secret "'$OMAPI_SECRET'";' > ${OMAPI_KEYS_DIR}/${OMAPI_KEY_NAME}.secret
echo "**** Creating OMAPI Key FIle  ****"
cat <<EOF > ${OMAPI_KEYS_DIR}/${OMAPI_KEY_NAME}.key
key "${OMAPI_KEY_NAME}" {
  algorithm hmac-md5;
  secret "${OMAPI_SECRET}";
}
EOF

cat <<EOF > /etc/puppetlabs/code/modules/ipam/files/hiera/groups/ipam.yaml
---
dhcp::dnsupdatekey: "%{::dns::server::params::cfg_dir}/bind.keys.d/${OMAPI_KEY_NAME}.key"
dhcp::dnskeyname: ${OMAPI_KEY_NAME}
dhcp::omapi_name: ${OMAPI_KEY_NAME}
dhcp::omapi_key: ${OMAPI_SECRET}
dhcp::omapi_port: 7911
EOF

exit
fi

