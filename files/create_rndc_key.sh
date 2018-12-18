#!/usr/bin/env bash
  
exec &>> $HOME/create_omapi_key.log
echo "**** Script to create omapi keys for IPAM cluster **********"
echo "**** Determining Key Variables *****************************"

# OMAPI_KEY_NAME=$(hostname -f)
# OMAPI_KEY_NAME=dhcp-failover
#
OMAPI_KEY_NAME=omapi-key
RNDC_KEY_NAME=rndc-key
DN=$(hostname -d)
FQDN=$(hostname -f)
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
  OMAPI_KEYS_DIR=$(find / -name bind.keys.d)
  echo "#"
done
echo "**** "$OMAPI_KEYS_DIR" Found ***********************"
cd $OMAPI_KEYS_DIR
if [[ $FQDN == $SECONDARY ]]; then
  until [ -e $OMAPI_KEYS_DIR/rndc.key ]
  do
    echo "!"
  done
  echo "**** Extracting OMAPI Key Archive from ipam1          ****"
  tar -xvzf /etc/puppetlabs/puppet/data/omapi_key.tgz
  exit
else
echo "**** Creating rndc.key *************************************"
rndc-confgen -a -r /dev/urandom -A HMAC-MD5 -b 512 -k ${RNDC_KEY_NAME} -c ${OMAPI_KEYS_DIR}/rndc.key
export RNDC_KEY_FILE=`find / -name rndc.key`
export RNDC_CONF_FILE=`find / -name rndc.conf`
echo "**** $RNDC_KEY_FILE ****"
export RNDC_SECRET_KEY=$(cat ${RNDC_KEY_FILE} |awk '{ print $8 }')
echo "**** $RNDC_SECRET_KEY ****"
cat <<EOF > ${OMAPI_KEYS_DIR}/rndc.conf
key "${RNDC_KEY_NAME}" {
  algorithm hmac-md5;
  secret "${RNDC_SECRET_KEY}";
}
EOF
export RNDC_CONF_FILE=$(find / -name rndc.conf)
echo "**** $RNDC_CONF_FILE ****"
fi
