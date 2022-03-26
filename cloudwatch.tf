# ---------------------------------------------------------------------------------------------------------------------
# Cloudwatch Logs for Task
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_cloudwatch_log_group" "prpl" {
  name              = "ecs-${local.name}" # This must match that used in "logConfiguration" in file service-task-definition.template.json
  retention_in_days = var.environment.cloudwatch_log_groups_default_retention_days
  tags = merge(var.global_default_tags, var.environment.default_tags, {
    Name        = "ecs-${local.name}" # This must match that used in "logConfiguration" in file service-task-definition.template.json
    Application = "prpl"
  })
}
resource "aws_cloudwatch_log_group" "prpl-mariadb" {
  name              = "ecs-${local.name}-mariadb" # This must match that used in "logConfiguration" in file service-task-definition.template.json
  retention_in_days = var.environment.cloudwatch_log_groups_default_retention_days
  tags = merge(var.global_default_tags, var.environment.default_tags, {
    Name        = "ecs-${local.name}-mariadb" # This must match that used in "logConfiguration" in file service-task-definition.template.json
    Application = "prpl"
  })
}