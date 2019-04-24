#!/bin/sh

set -euo pipefail

# Simple logging function that displays to stdout
log() {
  echo "================================================================================"
  echo $@ | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"
}

# Simple die function, every command should be followed by this!
die() {
  >&2 log "ERROR: $*"
  exit 1
}

log "seting up ssh key"
mkdir ~/.ssh
echo -e "$GITHUB_PRIVATE_KEY" > ~/.ssh/id_rsa || die "failed to echo key into file ~/.ssh/id_rsa"
chmod 0600 ~/.ssh/id_rsa
ssh-keyscan -H github.com > /etc/ssh/ssh_known_hosts || die "failed to add github identity"
