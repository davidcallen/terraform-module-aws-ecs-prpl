//variable "name" {
//  description = "The Name for modules resources"
//  type        = string
//  default     = ""
//}
variable "aws_region" {
  type = string
}
variable "name_suffix" {
  description = "The AWS name suffix for AWS resources"
  type        = string
  default     = ""
}
variable "environment" {
  description = "Environment information e.g. account IDs, public/private subnet cidrs"
  type = object({
    name                                         = string # Environment Account IDs are used for giving permissions to those Accounts for resources such as AMIs
    account_id                                   = string
    resource_name_prefix                         = string # For some environments  (e.g. Core, Customer/production) want to protect against accidental deletion of resources
    resource_deletion_protection                 = bool
    cloudwatch_alarms_sns_emails                 = list(string)
    cloudwatch_log_groups_default_retention_days = number
    default_tags                                 = map(string)
  })
  default = {
    name                                         = ""
    account_id                                   = ""
    resource_name_prefix                         = ""
    resource_deletion_protection                 = true
    cloudwatch_alarms_sns_emails                 = []
    cloudwatch_log_groups_default_retention_days = 10
    default_tags                                 = {}
  }
}
variable "vpc_id" {
  description = "The VPC ID"
  type        = string
  default     = ""
}
variable "vpc_private_subnet_ids" {
  description = "The VPC private subnet IDs list"
  type        = list(string)
  default     = []
}
variable "vpc_private_subnet_cidrs" {
  description = "The VPC private subnet CIDRs list"
  type        = list(string)
  default     = []
}
variable "ecs_cluster_id" {
  description = "The ECS Cluster ID"
  type        = string
  default     = ""
}
variable "ecs_cluster_name" {
  description = "The ECS Cluster Name"
  type        = string
  default     = ""
}
variable "ecs_cluster_service_registry_arn" {
  type = string
}
variable "ecs_cluster_efs_security_group_id" {
  type = string
}
//variable "load_balancer_target_group_arn_http" {
//  type = string
//}
variable "ecr_repository_name" {
  type = string
}
variable "ecr_image_tag" {
  type = string
}
//variable "ecs_task_execution_role_arn" {
//  type = string
//}
variable "prpl_database_user_password" {
  type = string
}
variable "prpl_database_admin_password" {
  type = string
}
variable "combined_service_enabled" {
  description = "A combined service contains both the application and database backend. This only to be used for QA/Dev deploys."
  type    = bool
  default = false
}
//variable "allowed_egress_cidrs" {
//  type = object({
//    smtp               = list(string)
//    pop3               = list(string)
//  })
//}
variable "global_default_tags" {
  description = "Global default tags"
  type        = map(string)
  default     = {}
}