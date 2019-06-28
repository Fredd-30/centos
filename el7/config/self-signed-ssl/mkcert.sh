#!/bin/sh
#
# mkcert.sh
#
# Nicolas Kovacs, 2019
#
# Ce script génère un certificat auto-signé pour un serveur de réseau local.
#
# Copier le script vers un endoit approprié comme /usr/local/sbin, éditer en
# fonction de la configuration locale et exécuter avec les droits de root.
#
# Le script crée un groupe système 'certs'. Les certificats et les clés
# appartiennent à root:certs. On songera à ajouter les utilisateurs système au
# groupe 'certs' pour qu'ils puissent accéder aux fichiers.

HOST=$(hostname --fqdn)
TIME=3650
SSLDIR="/etc/pki/tls"
CRTDIR="$SSLDIR/mycerts"
KEYDIR="$SSLDIR/private"
CNFFILE="$CRTDIR/$HOST.cnf"
KEYFILE="$KEYDIR/$HOST.key"
CSRFILE="$CRTDIR/$HOST.csr"
CRTFILE="$CRTDIR/$HOST.crt"

# Testing
rm -f $CNFFILE $KEYFILE $CSRFILE $CRTFILE

# Create certs group 
if ! grep -q "^certs:" /etc/group ; then
  groupadd -g 240 certs
  echo 
  echo ":: Added certs group."
  echo 
  sleep 3
fi

for DIRECTORY in $CRTDIR $KEYDIR; do
  if [ ! -d $DIRECTORY ]; then
    echo 
    echo ":: Creating directory $DIRECTORY."
    echo 
    mkdir -p $DIRECTORY
  fi
done

for FILE in $CNFFILE $KEYFILE $CSRFILE $CRTFILE; do
  if [ -f $FILE ]; then
    echo 
    echo ":: $FILE already exists, won't overwrite."
    echo 
    exit 1
  fi
done

cat > $CNFFILE << EOF
[req]
distinguished_name          = req_distinguished_name
string_mask                 = nombstr
req_extensions              = v3_req

[req_distinguished_name]
organizationName            = Organization Name (company)
emailAddress                = Email Address
emailAddress_max            = 40
localityName                = Locality Name
stateOrProvinceName         = State or Province Name
countryName                 = Country Name (2 letter code)
countryName_min             = 2
countryName_max             = 2
commonName                  = Common Name
commonName_max              = 64
organizationName_default    = Microlinux
emailAddress_default        = info@microlinux.fr
localityName_default        = Montpezat
stateOrProvinceName_default = Gard
countryName_default         = FR
commonName_default          = $HOST

[ v3_req ]
# Extensions to add to a certificate request
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = $HOST
DNS.2 = subdomain1.$HOST
DNS.3 = subdomain2.$HOST
DNS.4 = subdomain3.$HOST
EOF

# Generate private key
openssl genrsa \
  -out $KEYFILE \
  4096 

# Generate Certificate Signing Request
openssl req \
  -new \
  -out $CSRFILE \
  -key $KEYFILE \
  -config $CNFFILE

# Self-sign and generate Certificate
openssl x509 \
  -req \
  -days $TIME \
  -in $CSRFILE \
  -signkey $KEYFILE \
  -out $CRTFILE \
  -extensions v3_req \
  -extfile $CNFFILE

# Set permissions
chown root:certs $KEYFILE $CRTFILE
chmod 0640 $KEYFILE $CRTFILE

# Create a symlink in /etc/ssl/certs
pushd $SSLDIR/certs
  rm -f $HOST.crt
  ln -s ../mycerts/$HOST.crt .
popd

echo 

exit 0
