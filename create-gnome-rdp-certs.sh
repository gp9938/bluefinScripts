#!/bin/bash
export SUBJECT="/C=US/ST=NY/L=Brooklyn/O=160W3A/OU=3A/CN=3A"
export GRDCERTDIR=/var/tmp/${USER}.tmp
export FILEBASENAME="grd-tls"
mkdir -p ${GRDCERTDIR}
sudo openssl genrsa -out ${GRDCERTDIR}/grd-tls.key 4096
sudo openssl req -new -key ${GRDCERTDIR}/grd-tls.key -out ${GRDCERTDIR}/grd-tls.csr -subj $SUBJECT -addext \
	"extendedKeyUsage = serverAuth, clientAuth" \
	-keyform PEM \
	-outform PEM
sudo openssl x509 -req -days 100000 -signkey ${GRDCERTDIR}/${FILEBASENAME}.key -in ${GRDCERTDIR}/${FILEBASENAME}.csr -out ${GRDCERTDIR}/${FILEBASENAME}.crt
