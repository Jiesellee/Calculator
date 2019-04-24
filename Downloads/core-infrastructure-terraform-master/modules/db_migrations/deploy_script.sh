#!/bin/sh -e

# this script needs aws credentials and the awscli to run. 
# It needs permission to create services and tasks and update services in ECS.

# Simple logging function that displays to stdout
log() {
  echo "================================================================================"
  echo $@ | sed  -e :a -e 's/^.\{1,77\}$/ & /;ta'
  echo "================================================================================"

}

run() {
  if [ "$NO_OP" == "true" ]; then
    echo "would run $1"
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
  echo "Usage: $0 [-s <service name> -e <service environment>]" 1>&2; exit 1;
}

while getopts ":t:c:" o; do
  case "${o}" in
    t)
      TASK_DEFINITION=${OPTARG}
      ;;
    c)
      ECS_CLUSTER=${OPTARG}
      ;;
    r)
      IAM_ROLE=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z ${TASK_DEFINITION+x} ]; then
  export TASK_DEFINITION=$(terraform output aws_ecs_task_definition_name)
fi

if [ -z ${ECS_CLUSTER+x} ]; then
  export ECS_CLUSTER=$(terraform output ecs_cluster_arn)
fi

if ! which aws; then
  # install the aws cli
  apk add aws-cli jq --update --no-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/
fi

# if the iam role isnt specified then try and find it from the terraform cd_overrides.
if [ -z ${IAM_ROLE+x} ]; then
  IAM_ROLE=$(grep -m1 -Ehro 'arn:aws:iam::\d{12}:role\/cd' cd_override.tf || echo)
fi

# if a aws profile is not set or aws vault is not in use then set up the profiles
if [ -z "${AWS_VAULT+x}" ]; then
  log "assuming IAM role ${IAM_ROLE}"
  export AWS_DEFAULT_REGION=eu-west-1
  
  unset AWS_SESSION_TOKEN

  temp_role=$(aws sts assume-role --role-arn "${IAM_ROLE}" --role-session-name "cd-role" $STS_OPTS)
  export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq .Credentials.AccessKeyId | xargs)
  export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq .Credentials.SecretAccessKey | xargs)
  export AWS_SESSION_TOKEN=$(echo $temp_role | jq .Credentials.SessionToken | xargs)

  unset AWS_SECURITY_TOKEN
fi

log "running terraform test task"
RUNNING_TASK=$(run "aws ecs run-task --cluster ${ECS_CLUSTER} --task-definition ${TASK_DEFINITION}") || die "failed to run deploy task!"
RUNNING_TASK_ID="$(echo ${RUNNING_TASK} | jq -r .tasks[0].taskArn)"

log "task running with id: ${RUNNING_TASK_ID}"

COUNTER=0
while [  $COUNTER -lt 30 ]; do
  
  TASK_STATUS=$(run "aws ecs describe-tasks --cluster ${ECS_CLUSTER} --tasks ${RUNNING_TASK_ID}")
  EXIT_CODE=$(echo "$TASK_STATUS" | jq -r '.tasks[0].containers[] | select(.name=="flyway") | .exitCode') 
  log "task exited with code: ${EXIT_CODE}"

  # expr is weird. if the exit code isnt a number its null and pending
  if [ "$EXIT_CODE" == "null" ]; then            
    log "task null and pending..."                   
    let COUNTER=COUNTER+1                            
    sleep 1                                          
  elif [ "$EXIT_CODE" == "0" ]; then
    log "task success"
    exit 0
  elif expr "$EXIT_CODE" : "[0-9]*"; then
    die "task failed with exit code $EXIT_CODE"
  else
    log "task pending..."
    let COUNTER=COUNTER+1
    sleep 1
  fi

done

die "task failed"
