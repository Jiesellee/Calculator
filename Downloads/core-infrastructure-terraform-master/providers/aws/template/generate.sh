#!/bin/bash

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

usage() {
  echo "Usage: $0 [-i account_id -n account_name -e environment -p project_name ]" 1>&2; exit 1;
}

while getopts ":i:n:e:p:" o; do
  case "${o}" in
    i)
      ACCOUNT_ID=${OPTARG}
      ;;
    n)
      ACCOUNT_NAME=${OPTARG}
      ;;
    p)
      PROJECT_NAME=${OPTARG}
      ;;
    e)
      ENVIRONMENT=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

log "creating account folder"
mkdir ../$ACCOUNT_NAME

log "writing account setup skeleton from template"

cat main.tf | perl -ne "s/ACCOUNT_ID/$ACCOUNT_ID/sgo;\
    s/ACCOUNT_NAME/$ACCOUNT_NAME/sgo;\
    s/PROJECT_NAME/$PROJECT_NAME/sgo;\
    s/ENVIRONMENT/$ENVIRONMENT/sgo; print" > ../$ACCOUNT_NAME/main.tf

log "formatting the new acocunt file"
terraform fmt ../$ACCOUNT_NAME/main.tf

log "All done! SUCCESS!"