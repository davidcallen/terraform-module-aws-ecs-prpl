# ---------------------------------------------------------------------------------------------------------------------
# Secrets
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_ssm_parameter" "prpl-db-user" {
  name        = "/prpl/database/user/prpl/password"
  description = "The PRPL User Password for mariadb database"
  type        = "SecureString"
  value       = var.prpl_database_user_password
  tags        = var.global_default_tags
}
resource "aws_ssm_parameter" "prpl-db-admin" {
  name        = "/prpl/database/admin/prpl/password"
  description = "The Root admin Password for mariadb database"
  type        = "SecureString"
  value       = var.prpl_database_admin_password
  tags        = var.global_default_tags
}
