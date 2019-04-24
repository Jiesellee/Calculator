#!/bin/bash -e

# this script needs aws kms credentials

# Simple logging function that displays to stdout
log() {
  echo "================================================================================"
  echo $@ | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"

}

run() {
  if [ "$NO_OP" == "true" ]; then
    echo "would run command: $1"
  else
    $1 || die "command: $1 failed"
  fi
}

# Simple die function, every command should be followed by this!
die() {
  >&2 log "ERROR: $*"
  exit 1
}

usage() {
  echo "Usage: $0 [-v service_version ]" 1>&2; exit 1;
}

while getopts ":k:" o; do
  case "${o}" in
    k)
      ENC_KEY=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

# ENC_FILES=('vault_cert' 'vault_key')
ENC_FILES=('vault.pem' 'vault-key.pem' 'vault_ca.pem')

if [[ ! -d ./vault ]];
then
    cp -r ../tls/gentls/vault .
    cp -r ../tls/gentls/ca .
fi
echo -e "// Encrypting files with KMS key: $ENC_KEY\n"

for ENC_FILE in "${ENC_FILES[@]}"; do
    if [[ $ENC_FILE = "vault_ca.pem" ]]
    then
        ENC_STRING="$(aws kms encrypt --key-id $ENC_KEY --plaintext fileb://ca/$ENC_FILE --output text --query CiphertextBlob)"
    else
        ENC_STRING="$(aws kms encrypt --key-id $ENC_KEY --plaintext fileb://vault/$ENC_FILE --output text --query CiphertextBlob)"
    fi

  echo "// kms encrypted $ENC_FILE"
  echo -e "$(echo $ENC_FILE | replace . _ | sed 's/-/_/g' ) = \"$ENC_STRING\"\\n"
done

echo "// removing TLS assets"
rm -rf ./vault/
rm -rf ./ca/
