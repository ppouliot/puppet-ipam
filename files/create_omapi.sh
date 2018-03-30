#!/usr/bin/env bash
exec &>> /tmp/create_omapi_key.log


echo "**** Script to create omapi keys for IPAM cluster ****"

OMAPI_KEY_NAME=`hostname -f`
# OMAPI_KEYS_DIR=`find / -name bind.keys.d`

echo "**** Waiting for creation of directory bind.keys.d ****"

until [ -d "$OMAPI_KEYS_DIR" ]
do 
  OMAPI_KEYS_DIR=`find / -name bind.keys.d`
  echo -n "#"
done

echo "****"$OMAPI_KEYS_DIR" Found ****"
cd $OMAPI_KEYS_DIR

if $OMAPI_KEY_NAME == 'ipam2.contoso.ltd' ; then
  export REMOTE_OMAPI_KEYS_DIR=`ssh ipam1.contoso.ltd 'find / -name bind.keys.d`
  rsync -av -e ssh ipam1.contoso.ltd:$REMOTE_OMAPI_KEYS_DIR/ $OMAPI_KEYS_DIR/
exit
else

echo "**** Creating OMAPI Key ****"
dnssec-keygen -r /dev/urandom -a HMAC-MD5 -b 512 -n HOST $OMAPI_KEY_NAME

echo "**** Creating OMAPI Secret FIle  ****"
export OMAPI_SECRET=`cat $OMAPI_KEYS_DIR/K${OMAPI_KEY_NAME}.+*.private |grep ^Key| cut -d ' ' -f2-`
echo 'secret "'$OMAPI_SECRET'";' > ${OMAPI_KEYS_DIR}/${OMAPI_KEY_NAME}.secret

echo "**** Creating OMAPI Key FIle  ****"
cat <<EOF > ${OMAPI_KEYS_DIR}/${OMAPI_KEY_NAME}.key
key "${OMAPI_KEY_NAME}" {
  algorithm hmac-md5;
  secret "${OMAPI_SECRET}";
}
EOF
exit
fi
