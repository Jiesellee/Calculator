#cloud-config

repo_update: true

packages:
  - awslogs

write_files:
  - path: "/etc/awslogs/awslogs.conf"
    permissions: "0644"
    owner: "root"
    content: |
      [general]
      state_file = /var/lib/awslogs/agent-state        
       
      [/var/log/dmesg]
      file = /var/log/dmesg
      log_group_name = ${log_group_name}
      log_stream_name = <instance_id>/var/log/dmesg

      [/var/log/messages]
      file = /var/log/messages
      log_group_name = ${log_group_name}
      log_stream_name = <instance_id>/var/log/messages
      datetime_format = %b %d %H:%M:%S

      [/var/log/docker]
      file = /var/log/docker
      log_group_name = ${log_group_name}
      log_stream_name = <instance_id>/var/log/docker
      datetime_format = %Y-%m-%dT%H:%M:%S.%f

      [/var/log/ecs/ecs-init.log]
      file = /var/log/ecs/ecs-init.log.*
      log_group_name = ${log_group_name}
      log_stream_name = <instance_id>/var/log/ecs/ecs-init.log
      datetime_format = %Y-%m-%dT%H:%M:%SZ

      [/var/log/ecs/ecs-agent.log]
      file = /var/log/ecs/ecs-agent.log.*
      log_group_name = ${log_group_name}
      log_stream_name = <instance_id>/var/log/ecs/ecs-agent.log
      datetime_format = %Y-%m-%dT%H:%M:%SZ

      [/var/log/ecs/audit.log]
      file = /var/log/ecs/audit.log.*
      log_group_name = ${log_group_name}
      log_stream_name = <instance_id>/var/log/ecs/audit.log
      datetime_format = %Y-%m-%dT%H:%M:%SZ

runcmd:
  - echo ECS_CLUSTER=${ecs_cluster_name} > /etc/ecs/ecs.config
  - sed -i "s/<instance_id>/$(cat /var/lib/cloud/data/instance-id)/g" /etc/awslogs/awslogs.conf
  - sed -i -e "s/region = us-east-1/region = $(curl 169.254.169.254/latest/meta-data/placement/availability-zone | sed s'/.$//')/g" /etc/awslogs/awscli.conf
  - service awslogs restart
  - chkconfig awslogs on
