variable "private_subnet_ids" {
  description = "IDs of the subnets to which the services and database will be deployed"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "IDs of the subnets to which the load balancer will be deployed"
  type        = list(string)
}

variable "domain" {
  description = "Domain where metabase will be hosted. Example: metabase.mycompany.com"
  type        = string
}

variable "zone_id" {
  description = "https://www.terraform.io/docs/providers/aws/r/route53_record.html#zone_id"
  type        = string
}

variable "certificate_arn" {
  description = "https://www.terraform.io/docs/providers/aws/r/lb_listener.html#certificate_arn"
  type        = string
}

variable "cluster_instance_count" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster_instance"
  type        = number
  default     = 1
}

variable "vpc_id" {
  description = "https://www.terraform.io/docs/providers/aws/r/security_group.html#vpc_id"
  type        = string
}

variable "id" {
  description = "Unique identifier for naming resources"
  type        = string
  default     = "metabase"
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "image" {
  description = "https://hub.docker.com/r/metabase/metabase"
  type        = string
  default     = "metabase/metabase:v0.41.5"
}

variable "cpu" {
  description = "https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html"
  type        = number
  default     = 512
}

variable "memory" {
  description = "https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html"
  type        = number
  default     = 2048
}

variable "max_capacity" {
  description = "https://www.terraform.io/docs/providers/aws/r/rds_cluster.html#max_capacity"
  type        = number
  default     = 8
}

variable "desired_count" {
  description = "https://www.terraform.io/docs/providers/aws/r/ecs_service.html#desired_count"
  type        = number
  default     = 1
}

variable "log_retention" {
  description = "Retention period in days for both ALB and container logs"
  type        = number
  default     = 90
}

variable "protect" {
  description = "Enables deletion protection on eligible resources"
  type        = bool
  default     = true
}

variable "https_egress_only" {
  description = "Grant outbound internet access to Metabase for http and https only"
  type        = bool
  default     = false
}

variable "ssl_policy" {
  description = "https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/elb-security-policy-table.html"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "snapshot_identifier" {
  description = "https://www.terraform.io/docs/providers/aws/r/rds_cluster.html#snapshot_identifier"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Additional container environment variables"
  type        = list(string)
  default     = []
}

variable "java_timezone" {
  description = "https://www.metabase.com/docs/v0.21.1/operations-guide/running-metabase-on-docker.html#setting-the-java-timezone"
  type        = string
  default     = "US/Eastern"
}

variable "db_cluster_parameter_group_name" {
  description = "https://www.terraform.io/docs/providers/aws/r/rds_cluster.html#db_cluster_parameter_group_name"
  type        = string
  default     = ""
}

variable "auto_pause" {
  description = "https://www.terraform.io/docs/providers/aws/r/rds_cluster.html#auto_pause"
  type        = bool
  default     = false
}

variable "ingress_cidr_blocks" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule#cidr_blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ingress_source_security_group_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule#source_security_group_id"
  type        = set(string)
  default     = []
}

variable "enable_global_write_forwarding" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_cluster#enable_global_write_forwarding"
  type        = bool
  default     = false
}