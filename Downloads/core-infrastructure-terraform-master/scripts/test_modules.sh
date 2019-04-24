#!/bin/bash -eu

set -o pipefail

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

# set the timeout to 20 mins for each module!
TIMEOUT=1200

if [[ "$OSTYPE" == "darwin"* ]]; then
  which gtimeout || die "you need gtimout, run: brew install coreutils"
  TIMEOUT_BIN="gtimeout"      # Mac OSX
else
  TIMEOUT_BIN="timeout"
fi

log "merging the master branch into the current branch to avoid testing all modules if the branch is out of date"
git config --global user.email "test@test.com" || die "couldnt config git"
git config --global user.name "circle ci" || die "couldnt config git"
git merge --strategy=ours --commit origin/master || die "failed to merge master branch, you need to resolve conflicts and try again."

log "getting the git branch"
GIT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"

log "find out which modules changed against master"
export CHANGED_MODULES=$(git diff --name-status  origin/master..${GIT_BRANCH} | awk '{ print $2 }' | xargs -I {} dirname "{}" | grep modules | grep -v test  | awk -F '/' '{ print $2 }' | sort -u)

log "running tests for each of the following modules: \n $CHANGED_MODULES"
for MODULE in $CHANGED_MODULES; do
  log "testing module: $MODULE"

  # we create the state dir to make sure if we crash, we can recover the state and destroy the resources.
  STATE_DIR="/tmp/cache/$MODULE"
  STATE_FILE="$STATE_DIR/terraform.tfstate"
  mkdir -p "$STATE_DIR" || die "failed to create state tmp dir"

  pushd . || die "failed to pushd"

  if [ -d "./modules/test/$MODULE/" ]; then
    export APPLY_FAILED=false

    cd ./modules/test/$MODULE/ || die "failed to change directory"

    cp ../config/cd_override.tf ./ || die "failed to copt ci provider override file"

    terraform init || die "failed to get modules"
    $TIMEOUT_BIN -t $TIMEOUT terraform plan || die "failed to plan"

    if $TIMEOUT_BIN -t $TIMEOUT terraform apply -state=$STATE_FILE -input=false -auto-approve; then
      log "applied successfully"
    else
      log "failed to apply, going to destroy whatevers left"
      export APPLY_FAILED=true
    fi

    # should put this in a more rubust loop instead of copy pasta, but this is easier for now with the timeout.
    if [ "$APPLY_FAILED" = true ] && [ -f ".retry_test" ]; then
      if $TIMEOUT_BIN -t $TIMEOUT terraform apply -state=$STATE_FILE -input=false -auto-approve; then
        log "applied successfully"
        export APPLY_FAILED=false
      else
        log "failed to apply, going to destroy whatevers left"
        export APPLY_FAILED=true
      fi
    fi

    # retry upto 5 times
    for tries in {1..5}; do
      log "destroying module: $MODULE"
      $TIMEOUT_BIN -t $TIMEOUT terraform destroy -force -state="$STATE_FILE" && break

      log "failed to destroy the first time, sometimes things need time..."
      sleep 10

      if [ "$tries" == 5 ]; then
        die "Failed to destroy terraform module. Use the state file cache to manually try to delete this"
      fi
    done

    if [ "$APPLY_FAILED" == "true" ]; then
      die "Failed to terraform apply"
    else
      log "module apply successful"
    fi

    popd || die "failed to go back to base dir"
  else
    log "WARNING: this module does not have tests. we must have tests!"
  fi

done
