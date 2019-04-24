{
  "app": {
    "vaultguard": {
      "gentoken": "disabled",
      "init": {
        "initstatus": "enabled",
        "initspec":{
          "clusterspec": {
            "kind": "ecs",
            "cluster": [
              {
                "ecscluster_name": "${vaultguard_managed_vault_cluster}",
                "region": "${region}"
              },
              {
                "ecscluster_name": "test-cluster",
                "region": "${region}"
              }
            ],
            "encryptionspec": {
              "kind": "kms",
              "encryption_key": "${kms_key_arn}",
              "encryption_key_region": "${region}"
            },
            "storagespec": {
              "kind": "s3",
              "s3bucket": "${vaultguard_state_s3_bucket}"
            }
          }
        }
      },
      "listen_address": "0.0.0.0",
      "listen_port": "8001",
      "mount": {
        "mountstatus": "enabled",
        "mountspec": {
          "mounts": [
            {
              "mountpath": "concourse",
              "description": "The generic secrets backend used for concourse secrets",
              "kind": "generic"
            },
            {
              "mountpath": "testmount",
              "description": "The generic secrets backend mounted for testing secrets",
              "kind": "generic"
            }
          ]
        }
      },
      "authbackend": {
        "authbackendstatus": "enabled",
        "authbackendspec": {
          "authbackends": [
            {
              "kind": "approle",
              "authbackenddesc": "This backend allows machines and services (apps) to authenticate with Vault via a series of administratively defined roles: AppRoles.",
              "role_name": "concourse",
              "role_refresh_interval": "86400s"
            }
          ]
        }
      },
      "policy": {
        "policy_status": "enabled",
        "policy_spec": {
          "policies": [
            {
              "name": "concourse_ci",
              "policyrules": "path \"concourse/*\" {\n  capabilities = [\"read\", \"list\"]\n}\n"
            },
            {
              "name": "concourse_root",
              "policyrules": "# useful for humans to write secrets to the concourse path\npath \"auth/token/*\" {\n  capabilities = [\n    \"create\",\n    \"update\",\n    \"read\",\n    \"list\",\n    \"delete\",\n    \"sudo\"\n  ]\n}\n\npath \"sys\" {\n  capabilities = [\n    \"create\",\n    \"update\",\n    \"read\",\n    \"list\",\n    \"delete\",\n    \"sudo\"\n  ]\n}\n\npath \"concourse/*\" {\n  capabilities = [\n    \"create\",\n    \"read\",\n    \"update\",\n    \"delete\",\n    \"list\"\n  ]\n}\n"
            }
          ]
        }
      },
      "unseal": {
        "unsealstatus": "enabled",
        "unsealspec": {
          "clusterspec": {
            "kind": "ecs",
            "cluster": [
              {
                "ecscluster_name": "vaultguard_managed_vault_cluster",
                "region": "${region}"
              },
              {
                "ecscluster_name": "test-cluster",
                "region": "${region}"
              }
            ],
            "encryptionspec": {
              "kind": "kms",
              "encryption_key": "${kms_key_arn}",
              "encryption_key_region": "${region}"
            },
            "storagespec": {
              "kind": "s3",
              "s3bucket": "${vaultguard_state_s3_bucket}"
            }
          }
        }
      }
    }
  }
}
