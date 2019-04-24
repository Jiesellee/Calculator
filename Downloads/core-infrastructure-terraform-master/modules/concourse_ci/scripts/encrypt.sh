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

while getopts ":k:s:" o; do
  case "${o}" in
    k)
      ENC_KEY=${OPTARG}
      ;;
    s)
      GH_CLIENT_SECRET=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z "${GH_CLIENT_SECRET+x}" ]; then
  log "you havent set the github auth secret as an environment variable or via the -s argument, this is needed to run concourse."
  read -p "Are you sure you want to proceed without encrypting this?!" -n 1 -r

  if [[ $REPLY =~ ^[Nn]$ ]]
  then
      log "set the var using -s with this command"
      exit 0
  fi
fi

which aws || die "aws-cli is not installed"

test -d keys && die "keys directory already exists, delete this and try again"

mkdir -p keys

ssh-keygen -t rsa -f ./keys/tsa_host_key -N ''
ssh-keygen -t rsa -f ./keys/session_signing_key -N ''

ssh-keygen -t rsa -f ./keys/worker_key -N ''

cp ./keys/worker_key.pub ./keys/authorized_worker_keys

ENC_FILES=('authorized_worker_keys' 'session_signing_key' 'session_signing_key.pub' 'tsa_host_key' 'tsa_host_key.pub' 'worker_key' 'worker_key.pub')

echo -e "// Encrypting files with KMS key: $ENC_KEY\n"

for ENC_FILE in "${ENC_FILES[@]}"; do
  ENC_STRING="$(aws kms encrypt --key-id $ENC_KEY --plaintext fileb://keys/$ENC_FILE --output text --query CiphertextBlob)"

  echo "// kms encrypted $ENC_FILE"
  echo -e "$(echo $ENC_FILE | replace . _) = \"$ENC_STRING\"\\n"

  rm "./keys/$ENC_FILE" || die "failed to delete private key"
done
rm -rf ./keys || die "couldnt delete them keys"

RAND_PW="$(base64 /dev/urandom | tr -d '/+' | dd bs=32 count=1 2>/dev/null)"
log "basic auth pw: $RAND_PW"

echo "config_basic_auth_encrypted_password = \"$(aws kms encrypt --key-id $ENC_KEY --plaintext=${RAND_PW} --output text --query CiphertextBlob)\""

RAND_PW="$(base64 /dev/urandom | tr -d '/+' | dd bs=32 count=1 2>/dev/null)"
log "postgres pw: $RAND_PW"

echo "config_postgres_encrypted_password = \"$(aws kms encrypt --key-id $ENC_KEY --plaintext=${RAND_PW} --output text --query CiphertextBlob)\""

if [ -n "${GH_CLIENT_SECRET+x}" ]; then
  echo "config_github_auth_client_secret = \"$(aws kms encrypt --key-id $ENC_KEY --plaintext $GH_CLIENT_SECRET --output text --query CiphertextBlob)\""
fi

# test a decrypt with 
# echo $ENVSEC_test | base64 --decode > tmp
# aws kms decrypt --ciphertext-blob=fileb://tmp --output text --query Plaintext | base64 -D

# aws kms encrypt \
# --key-id ab123456-c012-4567-890a-deadbeef123 \
# --plaintext fileb://plaintext-example \
# --output text --query CiphertextBlob
