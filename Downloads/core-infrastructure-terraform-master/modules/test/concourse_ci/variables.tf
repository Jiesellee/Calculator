variable "encrypted_keys" {
  type = "map"

  default = {
    // kms encrypted authorized_worker_keys
    authorized_worker_keys = "AQECAHjl1QBQxYpegulpOE3mwmJVcwCfECJkIBhp1DNlm4QkZgAAAe4wggHqBgkqhkiG9w0BBwagggHbMIIB1wIBADCCAdAGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM9ikHj96q7d9BmiBcAgEQgIIBofJqbeQKyvu6ABfylM7Ut31Rh0ss7wuKq/ZmtNAOXp64X/3l2jle87BemAeWlD7wXQYsWxAIdLOEFyOljzKT6r8Ks7XqDtLYtJulaZNe3kM6iYngreM0MLBS1b93KYl3G8qaSkZBPvG2MJD/mSyTovIUDLD7+HLrTvB0jjCMtfvAF4+YgEHtpmJX/SZKMsQLQAPv61Jmg6fVVbgOnfM2rIwdm9MuXJKpygOseM3DGBzSuSM4QIvU2xy+mDElgVI70ggM3oKQnv7xPGFkLn1IfZnX8Wx2n7d3kiod8nMq0ANsCamNSBfGoEL+TyLCj8e1tUVn7Lt+iqGS7kryGmmspWzuIjynwZqIx5htlLT4JxE6ewG2r8opgN4DRXKUiSa1t6kiys5nw6Y+S32sDxBV4M/Kpp6KNj2veAUvLRcyCbv8NbXRgBhgBR8N1yEJ3yP1xRcJkbNAYt9EH38mIGtGiH+JX7TTOQLi8gt8BnMh4WE9dNANg76kCI+PwuOuHm1CsDhn9OwrhHBsXubQarUE58ff4nc3TgtuYLj+A93BK3SRIQ=="

    // kms encrypted session_signing_key
    session_signing_key = "AQECAHjl1QBQxYpegulpOE3mwmJVcwCfECJkIBhp1DNlm4QkZgAABvMwggbvBgkqhkiG9w0BBwagggbgMIIG3AIBADCCBtUGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMtsbcmZnl3uDK0Xk8AgEQgIIGpiKakpEuFqZUKLFefhDvPIPwpstBRNXlIbwstJZBoZaqBuiJrkmo/9+A9qARrC87+Lg6FBuwfyEOChiLexDdp67xhsGJM4fuSvrfllZlkLG+X6kWQlUdLBWhPHAjigLekksVrhUUzQWyJVT2A4OfhShEQlBPHm7dd7SLFA1iTO4HUtPxi02g61GL3YJOwg8et+S4crACZcHKSQcbDMXPV+m89jsJFHi18c6DfHuypyZK8HrCKLkbIznwCsbbbCR2beHKtz1dmR4oqPym1gfe+fc+54Z9XOZ9FvRJx06FPfQdFlrzO8bb9lKuA4Crnsi9pmE5rIiu51nC05MtWkpXSZERK0NMJaUFV70csSAtiy7+somImrz8FETLypwPoPTbYl4gdfVKoIcFs0IfYR6vhE6EA63NC55GYOFsewe4MYBBuPhoxqrwlCuDjwJRJS7ymj6RhIiY4eCZC0QURns9LHLk85MXjCUaK0v+UfmNNrLJ46HYqfXL1rbBSwKuGE0XdG6AZME/mNi0gBFqQ1W4WeobG2QzN6J9czV+rfcr8BzWeiT4w7qIiz/WmLUoewvkr+tPJ5uqgKFGn2Smf3XVmQw1/lv8A5q1ghgbgW3m80vfN6eHuUKRsmNuEWvI7bsXqVbFt0bm63rfPYtg/QCdIcqrUSE38/qC83kyHTbUAbMiEETemblHDRcP7RiQSPeK6q2oRNIVArs/y80Ox42LH3YrCK5OiyJnJZ+0ciLqbjPDQUPIokbMiOclAGB0SISrQrs5fPBwTTO+otzxWCEO0dnUXgAfNMHXeBkpYDfsdvnVFwx0JoNdR25lViVcLLMKhZevaAyrUk6xdUGxz2LW8lZ87gfEZ4SoDcf7IjmQXIWApu/aVmebFtdyMNs5JEmOq+yRl3zLz1TluzMu3igVUuv7qalMdSh5JwwGs5FsN368p1KXEdq2HhcWfsdLzD4oZ7a//WdDK42NyVpEEG0lWU18RJYj5Vq2j5ZWQtsTezNZt5g63dAc6ZL/K1NQg2H4gME/M8tKw3njLoqXYIAQbpl/lBs1Dady8n9JLYcvm9ve/3XTiy5pUuhlI/O++7xSiMOM7SNaaHZlIFNa565RrzSVTe8Z6exJ6/JWZHWwcZz0UaZsXenBoH6XEHx888Bjo9nQaViJ+N9CTIN9zRdcytVqPPDeGeveY9gRILlm+7049JT9fWbm3nULa1cqjApWFoYaxKLUUTyJfnu6prUbNEL2MwHrxhIUd01z2ScrlOakdXQDV9FmRGQUEeVwQ0cXFfDSACPHqitagoUSwHSvy2dWvjI5Ttkfb1bVEoOSk16PCkAg/BodKTvbOvoTDrBpmvvLZtn/UJ3EsLsnheF5v/BWRsx8aRdMkbtGZfzfbsD/ybQzlvlGRvxAbrHz1yUn+JjAbAwVdcItlXO511YB5ymwBzqbdDz/aanHEvOxuojgd9ihnkMgG0IFY6013CoGhH9vHRdGKY+3brsHj1RRRw0DWbzwQ+IiYTMJqY0vleBnGgVTkVW33+DRTsjmP2qyEhPsE0KxziyQg4yy00QosA2hYlcQ8ECfZHW4YzY/3juu7LrMN9Xl9ZylRAYwnVep7IkOPCGQde1E2bB7MG3sDRZfTSGmleG1ObEJSVkLLVVCCMKA80Yfxo0VK1dOyAexPCBqeZKZo7ejszNCb60xQ1Y9yJrl4Abp+R202d7AF2DPQVSw3lphysiDQHvrTlVonpT/udQ2idpGp3W6VUZmCtEO8dkMJXTGCLnBud85POMJLGHS7XD4+G8a6IQi9MEiJUNsg6dTgSB6jyvvpT+SgcXkAZhtEugeHaR0zsUbW4gyCCZl8I1AYNduGXBeBDwiCp+bf6fizCK+CUHihIY5XUnHdrvnTSn8trZQDblNc/8I2557J2ajUL88r+aWCgchaQKTzMXousZ+LJUU/Sjsn3eOjzkAHnk76/kvABP3+jpO+7mx0DkvIG8C7EraYy8sAxvcMEaFGF00ev5TCLyqRW802pnUi3lzHfcUoLE2sc5lBO115aTHQ3W3PaniqmSqdFjrPXl9UrVbnAxWC33122mCjfHylcJ8EhbaTvLXP8VyJ83OCPnqY43Gq2If7nJ81HyOKM9ViSZxW4Q/jJOY/7U3Na+1U+wRgIUJsMBSjKwhbdW2u0HAvfWcGKdHLup78doK0cgERhpXZz6wkpqNNHf6xUyzKktrX7fKrZl0Ub7bNMF1JOTf7Lq+0MK8aIxMrukt8eE1R4yVJvE+niaZso2AiedeHWM="

    // kms encrypted session_signing_key.pub
    session_signing_key_pub = "AQECAHjl1QBQxYpegulpOE3mwmJVcwCfECJkIBhp1DNlm4QkZgAAAe4wggHqBgkqhkiG9w0BBwagggHbMIIB1wIBADCCAdAGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMsV98zDzeurS+oIKfAgEQgIIBocnXZ38xxEVeglCpEpnNGZhjoCRxBCGaxLwN1b90M1vvpEvEFKE7R7XIyTYtVxgNpmRmWTiXe28Zu5bNFn5Ts+3OduF+nyip8kDFlrepVixbTs7sL1QFwdKJY6GdC0gwdTXJ+icBqd8nVGPF1kKp1Y8+T700KPyf/QvH/Vvi2ldqOXL6GzwSQvOsOwBo+H5YcHPLr/hDazgCHX+gu20ZXisBfqAPgWGWtnoP9ZJtT2YrgVP9edvv1qVnE9DEEHpPuM0PHI6smIttyVIBgFXo8GfOo8vG8xIOAFQT5oPvZnW6S+/X/zBeFM7ukjtShmUOeEoe0MpfDLhaS0tn637dYmTbOe3uwWBXHFZ7TUHf1EKaLopJlWfh7hNX1wVSZvyCx9v3kbfIPs/uFZHfi/b0KbU8vzEw2IDbpMbGyT6cV9CjM66l4qwyKFcJVJmKWZaQGmz73GKbbvTIzeKzL4ejFFp9X1IWQgqMehknBAm9oNSm1R4gHz9coGxz6flfy/7O0M0Unoea9nvStbezEFGyQFFzzhSMmm4sQ9gdXwC8m/BGKg=="

    // kms encrypted tsa_host_key
    tsa_host_key = "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"

    // kms encrypted tsa_host_key.pub
    tsa_host_key_pub = "AQECAHjl1QBQxYpegulpOE3mwmJVcwCfECJkIBhp1DNlm4QkZgAAAe4wggHqBgkqhkiG9w0BBwagggHbMIIB1wIBADCCAdAGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMi9sbUxnZS2WMztXGAgEQgIIBobXDdh2CaiIb/Z8Lx7yOmnK7T4aX0C9rcnWLgkFtyWhQ9tCo+8N7IBrkyFg0lBQlu9IvVMljn1r8jY1+GoduGHqKRKja2vnd8r4KXFUiBM2Uvwiz0rOwwMxPYBT6yOUfN+McjtwTe2nUCbpKGQC6YZLrDRmI4e8+xWt+E6aip/tk9sYyxsZ3u+0fC0XSYVl2AQ7aN6iId3RM6xqU1QytlY/M6B4HELCv0K2tSUBAijhsWD+x4S3AB4IraSLc4UaQbWBnVYpIZiC6M+U5bOpDLs+dWTX04heUxWdo5f6HSCWX1tmPDH5hAhJEfaTU3lQ8F0w49iWFICfgqpu9cSDG+ZIn88uoLMTkaMKToTqL4FCB+zNIaGHlsPuLSH1t/CX8fSl3pytPhgnS0hB2tqHu6oeWSAGXfeLt32aldhLN/Bx8XRr/zeDDBT6L1G6/xx2tvdUKyAAJvhMCmCpq04WPOWOnXF4QwMEMsH1YlUT60xXu3SRbab33/bRFu8osqY/oyjNqm/rG7iKazwiXcpHbH4+Z+9B8xIxuyZAgcyBSnhw9wA=="

    // kms encrypted worker_key
    worker_key = "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"

    // kms encrypted worker_key.pub
    worker_key_pub = "AQECAHjl1QBQxYpegulpOE3mwmJVcwCfECJkIBhp1DNlm4QkZgAAAe4wggHqBgkqhkiG9w0BBwagggHbMIIB1wIBADCCAdAGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMpqXdio+Hm6Dh8hhAAgEQgIIBocVTv/4tefvwhEnQOxdS/hBbety4qYCSjUeGtCSYi6MUgArbso74BCwg78Z/wvVwyyCJlq03XHSDpEnmOvRb+DaI9VmCLz0cy0mGCvuwxEEYBnYSmSERivP3/88L4G9Q2f2qDkc+NZAS6+hzaEh9FUjsnT21gBXT65gr2X2jzWIixYQnI7qMN8S0auM41ekmg0w5EHA6JrwvvlrReXgl+Vai1mLgIIg3wg6+g3eWtmQn+1BDX0ISSYDO6zQGwMzMRZ6CyiM5MqcXJwaeQ5xuZKontbQi1NW0+8fBhprO6iM9q4qpjo0KJLD8jANZnHsdsTtZrY3y9xQ9cPHl/i2dftC3DkfNgeWiYwUYDg/aRh5E/wDAPj9CF9C2vcTMYp5s2CitWRIz5x77CwSti8xgAxjJPWtOQTpe6D7i0vkX3e8ftl6otGXwPIJ6ZVsv+hxISlkTY8cxDrt/165D5zczLquGHIBVAnPnzCsQ+B6FjsDjxPCj3mol1UNykLBeY4eCXvXilEFldwioClabHbMvPe7sMJPWnOb01eEWH/Hsk4KsHA=="
  }
}

variable "vault_encrypted_keys" {
  type = "map"

  default = {
    vault_pem     = "abcd"
    vault_key_pem = "abcd"
  }
}

variable "project_name" {
  description = "The name of the project"
  default     = "c1abd721"
}

variable "environment" {
  description = "The environment the cluster is running in"
  default     = "circleci"
}

variable "region" {
  description = "The region the AWS resources will run in"
  default     = "eu-west-1"
}

variable "ecs_instance_type" {
  type        = "string"
  description = "The type of the aws ec2 instance that ecs runs on"
  default     = "t2.medium"
}

variable "namespace" {
  type        = "string"
  description = "The namespace used to create different names for EC2 key pairs, and other resources."
  default     = "c1abd721-circleci"
}

variable "concourse_ecs_min_size" {
  type        = "string"
  description = "the minimum size of the concourse autoscaling group that spawns ECS instances"
  default     = "2"
}

variable "concourse_ecs_max_size" {
  type        = "string"
  description = "the maximum size of the concourse autoscaling group that spawns ECS instances"
  default     = "3"
}

variable "concourse_ecs_desired_capacity" {
  type        = "string"
  description = "the desired capacity for the concourse autoscaling group that spawns ECS instances"
  default     = "2"
}