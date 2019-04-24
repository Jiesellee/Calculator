#!/bin/bash
set -xe
# overwrite the existing config to use our cluster and iam roles
cat <<'EOF' > /etc/ecs/ecs.config
ECS_CLUSTER=${cluster_name}
ECS_ENABLE_TASK_IAM_ROLE=true
EOF
if [ -e "/dev/nvme0n1" ]
then
    yum install -y e2fsprogs
    mkfs.ext4 /dev/nvme0n1
    stop ecs || true
    service docker stop || true
    mkdir -p  /opt/concourse/worker-state
    mount /dev/nvme0n1 /opt/concourse/worker-state
    echo /dev/nvme0n1 /opt/concourse/worker-state ext4 defaults 1 1 >> /etc/fstab
    service docker start
    start ecs || true
fi
set +xe
echo finished
